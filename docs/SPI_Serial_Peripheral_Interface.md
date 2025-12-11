# SPI (Serial Peripheral Interface) - AT32F403A/407

## Overview

The AT32F403A/407 microcontroller features up to **four SPI controllers** (SPI1, SPI2, SPI3, SPI4) that provide high-speed synchronous serial communication. The SPI peripheral supports both master and slave modes, full-duplex and half-duplex communication, hardware CRC calculation, and DMA transfers for efficient data handling.

## Key Features

- **Four SPI Controllers**: SPI1, SPI2, SPI3, SPI4
- **Operating Modes**: Master and Slave
- **Transmission Modes**:
  - Full-duplex (simultaneous transmit and receive)
  - Simplex receive-only
  - Half-duplex bidirectional (single data line)
- **Data Frame**: 8-bit or 16-bit
- **Bit Order**: MSB-first or LSB-first
- **Clock Configuration**:
  - Programmable clock polarity (CPOL)
  - Programmable clock phase (CPHA)
  - Master clock divider: 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024
- **Chip Select**: Hardware or software controlled
- **Hardware CRC**: Programmable polynomial for data integrity
- **DMA Support**: Both TX and RX with flexible DMA channel mapping
- **Interrupts**: TX buffer empty, RX buffer full, error conditions

## SPI Instances

| Instance | Base Address | APB Bus | DMA Controller |
|----------|--------------|---------|----------------|
| SPI1     | SPI1_BASE    | APB2    | DMA1           |
| SPI2     | SPI2_BASE    | APB1    | DMA1           |
| SPI3     | SPI3_BASE    | APB1    | DMA2           |
| SPI4     | SPI4_BASE    | APB2    | DMA2           |

## Hardware Interface

### Default Pin Mapping

#### SPI1 (Default)
| Function | Pin  | Direction (Master) | Direction (Slave) |
|----------|------|-------------------|-------------------|
| CS       | PA4  | Output (GPIO)     | Input             |
| SCK      | PA5  | Output (MUX)      | Input             |
| MISO     | PA6  | Input             | Output (MUX)      |
| MOSI     | PA7  | Output (MUX)      | Input             |

#### SPI1 (Remapped via JTAG pins)
| Function | Pin  | Direction (Master) | Direction (Slave) |
|----------|------|-------------------|-------------------|
| CS       | PA15 | Output (GPIO)     | Input             |
| SCK      | PB3  | Output (MUX)      | Input             |
| MISO     | PB4  | Input             | Output (MUX)      |
| MOSI     | PB5  | Output (MUX)      | Input             |

#### SPI2
| Function | Pin  | Direction (Master) | Direction (Slave) |
|----------|------|-------------------|-------------------|
| CS       | PB12 | Output (GPIO)     | Input             |
| SCK      | PB13 | Output (MUX)      | Input             |
| MISO     | PB14 | Input             | Output (MUX)      |
| MOSI     | PB15 | Output (MUX)      | Input             |

#### SPI3 (Default - uses JTAG pins)
| Function | Pin  | Direction (Master) | Direction (Slave) |
|----------|------|-------------------|-------------------|
| CS       | PA15 | Output (GPIO)     | Input             |
| SCK      | PB3  | Output (MUX)      | Input             |
| MISO     | PB4  | Input             | Output (MUX)      |
| MOSI     | PB5  | Output (MUX)      | Input             |

### GPIO Configuration Example

```c
static void gpio_config(void)
{
    gpio_init_type gpio_initstructure;
    
    /* Enable GPIO clocks */
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
    
    gpio_default_para_init(&gpio_initstructure);
    
    /* Master SPI1 CS pin - Software controlled */
    gpio_initstructure.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
    gpio_initstructure.gpio_pull = GPIO_PULL_UP;
    gpio_initstructure.gpio_mode = GPIO_MODE_OUTPUT;
    gpio_initstructure.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
    gpio_initstructure.gpio_pins = GPIO_PINS_4;
    gpio_init(GPIOA, &gpio_initstructure);
    
    /* Set CS high (inactive) */
    gpio_bits_set(GPIOA, GPIO_PINS_4);
    
    /* Master SPI1 SCK pin */
    gpio_initstructure.gpio_pull = GPIO_PULL_DOWN;
    gpio_initstructure.gpio_mode = GPIO_MODE_MUX;
    gpio_initstructure.gpio_pins = GPIO_PINS_5;
    gpio_init(GPIOA, &gpio_initstructure);
    
    /* Master SPI1 MISO pin */
    gpio_initstructure.gpio_pull = GPIO_PULL_UP;
    gpio_initstructure.gpio_mode = GPIO_MODE_INPUT;
    gpio_initstructure.gpio_pins = GPIO_PINS_6;
    gpio_init(GPIOA, &gpio_initstructure);
    
    /* Master SPI1 MOSI pin */
    gpio_initstructure.gpio_pull = GPIO_PULL_UP;
    gpio_initstructure.gpio_mode = GPIO_MODE_MUX;
    gpio_initstructure.gpio_pins = GPIO_PINS_7;
    gpio_init(GPIOA, &gpio_initstructure);
}
```

### Using Remapped Pins (JTAG Pins)

To use SPI on JTAG pins, you must enable the IOMUX clock and configure pin remapping:

```c
static void gpio_config_remapped(void)
{
    gpio_init_type gpio_initstructure;
    
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
    
    /* Disable JTAG to free up pins (keep SWD) */
    gpio_pin_remap_config(SWJTAG_MUX_010, TRUE);
    
    /* Remap SPI1 to PB3/PB4/PB5 */
    gpio_pin_remap_config(SPI1_MUX_01, TRUE);
    
    /* Or remap SPI3 */
    gpio_pin_remap_config(SPI3_GMUX_0010, TRUE);
    
    /* Configure GPIO pins... */
}
```

## Transmission Modes

### Full-Duplex Mode

Standard SPI mode using separate MOSI and MISO lines for simultaneous bidirectional data transfer.

```c
typedef enum
{
    SPI_TRANSMIT_FULL_DUPLEX     = 0x00  /* Dual line unidirectional full-duplex */
} spi_transmission_mode_type;
```

### Simplex Receive-Only Mode

Slave receives data only, no transmission. Uses MOSI line for receiving.

```c
typedef enum
{
    SPI_TRANSMIT_SIMPLEX_RX      = 0x01  /* Dual line unidirectional simplex receive-only */
} spi_transmission_mode_type;
```

### Half-Duplex Mode

Single data line used for both transmit and receive (bidirectional). Direction is switched dynamically.

```c
typedef enum
{
    SPI_TRANSMIT_HALF_DUPLEX_RX  = 0x02, /* Single line bidirectional half duplex - receiving */
    SPI_TRANSMIT_HALF_DUPLEX_TX  = 0x03  /* Single line bidirectional half duplex - transmitting */
} spi_transmission_mode_type;
```

## Configuration Types

### SPI Initialization Structure

```c
typedef struct
{
    spi_transmission_mode_type   transmission_mode;      /* Transmission mode */
    spi_master_slave_mode_type   master_slave_mode;      /* Master or slave mode */
    spi_mclk_freq_div_type       mclk_freq_division;     /* Master clock divider */
    spi_first_bit_type           first_bit_transmission; /* MSB or LSB first */
    spi_frame_bit_num_type       frame_bit_num;          /* 8 or 16 bit frame */
    spi_clock_polarity_type      clock_polarity;         /* Clock polarity (CPOL) */
    spi_clock_phase_type         clock_phase;            /* Clock phase (CPHA) */
    spi_cs_mode_type             cs_mode_selection;      /* Hardware or software CS */
} spi_init_type;
```

### Master/Slave Mode

```c
typedef enum
{
    SPI_MODE_SLAVE   = 0x00,  /* Slave mode */
    SPI_MODE_MASTER  = 0x01   /* Master mode */
} spi_master_slave_mode_type;
```

### Clock Polarity (CPOL)

```c
typedef enum
{
    SPI_CLOCK_POLARITY_LOW   = 0x00,  /* SCK low at idle */
    SPI_CLOCK_POLARITY_HIGH  = 0x01   /* SCK high at idle */
} spi_clock_polarity_type;
```

### Clock Phase (CPHA)

```c
typedef enum
{
    SPI_CLOCK_PHASE_1EDGE    = 0x00,  /* Data capture on first clock edge */
    SPI_CLOCK_PHASE_2EDGE    = 0x01   /* Data capture on second clock edge */
} spi_clock_phase_type;
```

### SPI Modes (CPOL + CPHA)

| Mode | CPOL | CPHA | Clock Idle | Data Capture  | Data Shift    |
|------|------|------|------------|---------------|---------------|
| 0    | 0    | 0    | Low        | Rising edge   | Falling edge  |
| 1    | 0    | 1    | Low        | Falling edge  | Rising edge   |
| 2    | 1    | 0    | High       | Falling edge  | Rising edge   |
| 3    | 1    | 1    | High       | Rising edge   | Falling edge  |

### Master Clock Frequency Division

```c
typedef enum
{
    SPI_MCLK_DIV_2    = 0x00,  /* fPCLK/2 */
    SPI_MCLK_DIV_4    = 0x01,  /* fPCLK/4 */
    SPI_MCLK_DIV_8    = 0x02,  /* fPCLK/8 */
    SPI_MCLK_DIV_16   = 0x03,  /* fPCLK/16 */
    SPI_MCLK_DIV_32   = 0x04,  /* fPCLK/32 */
    SPI_MCLK_DIV_64   = 0x05,  /* fPCLK/64 */
    SPI_MCLK_DIV_128  = 0x06,  /* fPCLK/128 */
    SPI_MCLK_DIV_256  = 0x07,  /* fPCLK/256 */
    SPI_MCLK_DIV_512  = 0x08,  /* fPCLK/512 */
    SPI_MCLK_DIV_1024 = 0x09   /* fPCLK/1024 */
} spi_mclk_freq_div_type;
```

### Frame Bit Number

```c
typedef enum
{
    SPI_FRAME_8BIT   = 0x00,  /* 8-bit data frame */
    SPI_FRAME_16BIT  = 0x01   /* 16-bit data frame */
} spi_frame_bit_num_type;
```

### First Bit Transmission

```c
typedef enum
{
    SPI_FIRST_BIT_MSB = 0x00,  /* MSB transmitted first */
    SPI_FIRST_BIT_LSB = 0x01   /* LSB transmitted first */
} spi_first_bit_type;
```

### Chip Select Mode

```c
typedef enum
{
    SPI_CS_HARDWARE_MODE = 0x00,  /* CS controlled by hardware */
    SPI_CS_SOFTWARE_MODE = 0x01   /* CS controlled by software */
} spi_cs_mode_type;
```

## Status Flags

```c
#define SPI_I2S_RDBF_FLAG   0x0001  /* Receive data buffer full */
#define SPI_I2S_TDBE_FLAG   0x0002  /* Transmit data buffer empty */
#define SPI_CCERR_FLAG      0x0010  /* CRC calculation error */
#define SPI_MMERR_FLAG      0x0020  /* Master mode error */
#define SPI_I2S_ROERR_FLAG  0x0040  /* Receiver overflow error */
#define SPI_I2S_BF_FLAG     0x0080  /* Busy flag */
```

## Interrupts

```c
#define SPI_I2S_ERROR_INT   0x0020  /* Error interrupt */
#define SPI_I2S_RDBF_INT    0x0040  /* Receive data buffer full interrupt */
#define SPI_I2S_TDBE_INT    0x0080  /* Transmit data buffer empty interrupt */
```

### SPI IRQ Names

| SPI Instance | IRQ Handler Name        |
|--------------|------------------------|
| SPI1         | SPI1_IRQHandler        |
| SPI2         | SPI2_I2S2EXT_IRQHandler|
| SPI3         | SPI3_I2S3EXT_IRQHandler|
| SPI4         | SPI4_IRQHandler        |

## Register Structure

```c
typedef struct
{
    union {
        __IO uint32_t ctrl1;
        struct {
            __IO uint32_t clkpha   : 1;  /* [0] Clock phase */
            __IO uint32_t clkpol   : 1;  /* [1] Clock polarity */
            __IO uint32_t msten    : 1;  /* [2] Master enable */
            __IO uint32_t mdiv_l   : 3;  /* [5:3] Clock divider low bits */
            __IO uint32_t spien    : 1;  /* [6] SPI enable */
            __IO uint32_t ltf      : 1;  /* [7] LSB transmit first */
            __IO uint32_t swcsil   : 1;  /* [8] Software CS internal level */
            __IO uint32_t swcsen   : 1;  /* [9] Software CS enable */
            __IO uint32_t ora      : 1;  /* [10] Receive only active */
            __IO uint32_t fbn      : 1;  /* [11] Frame bit number */
            __IO uint32_t ntc      : 1;  /* [12] Next transmit CRC */
            __IO uint32_t ccen     : 1;  /* [13] CRC calculation enable */
            __IO uint32_t slbtd    : 1;  /* [14] Single line bidirectional TX direction */
            __IO uint32_t slben    : 1;  /* [15] Single line bidirectional enable */
            __IO uint32_t reserved1: 16; /* [31:16] */
        } ctrl1_bit;
    };

    union {
        __IO uint32_t ctrl2;
        struct {
            __IO uint32_t dmaren   : 1;  /* [0] DMA receive enable */
            __IO uint32_t dmaten   : 1;  /* [1] DMA transmit enable */
            __IO uint32_t hwcsoe   : 1;  /* [2] Hardware CS output enable */
            __IO uint32_t reserved1: 2;  /* [4:3] */
            __IO uint32_t errie    : 1;  /* [5] Error interrupt enable */
            __IO uint32_t rdbfie   : 1;  /* [6] RX buffer full interrupt enable */
            __IO uint32_t tdbeie   : 1;  /* [7] TX buffer empty interrupt enable */
            __IO uint32_t mdiv_h   : 1;  /* [8] Clock divider high bit */
            __IO uint32_t reserved2: 23; /* [31:9] */
        } ctrl2_bit;
    };

    union {
        __IO uint32_t sts;
        struct {
            __IO uint32_t rdbf     : 1;  /* [0] Receive data buffer full */
            __IO uint32_t tdbe     : 1;  /* [1] Transmit data buffer empty */
            __IO uint32_t acs      : 1;  /* [2] Audio channel state (I2S) */
            __IO uint32_t tuerr    : 1;  /* [3] Transmitter underload error (I2S) */
            __IO uint32_t ccerr    : 1;  /* [4] CRC calculation error */
            __IO uint32_t mmerr    : 1;  /* [5] Master mode error */
            __IO uint32_t roerr    : 1;  /* [6] Receiver overflow error */
            __IO uint32_t bf       : 1;  /* [7] Busy flag */
            __IO uint32_t reserved1: 24; /* [31:8] */
        } sts_bit;
    };

    union {
        __IO uint32_t dt;                /* Data register */
        struct {
            __IO uint32_t dt       : 16; /* [15:0] Data */
            __IO uint32_t reserved1: 16; /* [31:16] */
        } dt_bit;
    };

    union {
        __IO uint32_t cpoly;             /* CRC polynomial register */
        struct {
            __IO uint32_t cpoly    : 16; /* [15:0] CRC polynomial */
            __IO uint32_t reserved1: 16; /* [31:16] */
        } cpoly_bit;
    };

    union {
        __IO uint32_t rcrc;              /* RX CRC register */
        struct {
            __IO uint32_t rcrc     : 16; /* [15:0] RX CRC value */
            __IO uint32_t reserved1: 16; /* [31:16] */
        } rcrc_bit;
    };

    union {
        __IO uint32_t tcrc;              /* TX CRC register */
        struct {
            __IO uint32_t tcrc     : 16; /* [15:0] TX CRC value */
            __IO uint32_t reserved1: 16; /* [31:16] */
        } tcrc_bit;
    };

    /* I2S control and clock registers follow... */
} spi_type;
```

## API Reference

### Initialization Functions

```c
/* Reset SPI peripheral */
void spi_i2s_reset(spi_type *spi_x);

/* Initialize structure with default values */
void spi_default_para_init(spi_init_type* spi_init_struct);

/* Initialize SPI with configuration */
void spi_init(spi_type* spi_x, spi_init_type* spi_init_struct);

/* Enable/disable SPI */
void spi_enable(spi_type* spi_x, confirm_state new_state);
```

### Data Transfer Functions

```c
/* Transmit data */
void spi_i2s_data_transmit(spi_type* spi_x, uint16_t tx_data);

/* Receive data */
uint16_t spi_i2s_data_receive(spi_type* spi_x);
```

### Configuration Functions

```c
/* Set frame bit number */
void spi_frame_bit_num_set(spi_type* spi_x, spi_frame_bit_num_type bit_num);

/* Set half-duplex direction */
void spi_half_duplex_direction_set(spi_type* spi_x, spi_half_duplex_direction_type direction);

/* Set software CS level */
void spi_software_cs_internal_level_set(spi_type* spi_x, spi_software_cs_level_type level);

/* Enable hardware CS output */
void spi_hardware_cs_output_enable(spi_type* spi_x, confirm_state new_state);
```

### CRC Functions

```c
/* Set CRC polynomial */
void spi_crc_polynomial_set(spi_type* spi_x, uint16_t crc_poly);

/* Get CRC polynomial */
uint16_t spi_crc_polynomial_get(spi_type* spi_x);

/* Enable CRC calculation */
void spi_crc_enable(spi_type* spi_x, confirm_state new_state);

/* Trigger next CRC transmission */
void spi_crc_next_transmit(spi_type* spi_x);

/* Get CRC value */
uint16_t spi_crc_value_get(spi_type* spi_x, spi_crc_direction_type crc_direction);
```

### DMA Functions

```c
/* Enable DMA transmitter */
void spi_i2s_dma_transmitter_enable(spi_type* spi_x, confirm_state new_state);

/* Enable DMA receiver */
void spi_i2s_dma_receiver_enable(spi_type* spi_x, confirm_state new_state);
```

### Interrupt Functions

```c
/* Enable/disable interrupt */
void spi_i2s_interrupt_enable(spi_type* spi_x, uint32_t spi_i2s_int, confirm_state new_state);

/* Get interrupt flag status */
flag_status spi_i2s_interrupt_flag_get(spi_type* spi_x, uint32_t spi_i2s_flag);
```

### Status Functions

```c
/* Get flag status */
flag_status spi_i2s_flag_get(spi_type* spi_x, uint32_t spi_i2s_flag);

/* Clear flag */
void spi_i2s_flag_clear(spi_type* spi_x, uint32_t spi_i2s_flag);
```

## Practical Examples

### Basic Full-Duplex Polling Transfer

```c
#define BUFFER_SIZE  32
#define SPI_CS_HIGH  gpio_bits_set(GPIOA, GPIO_PINS_4)
#define SPI_CS_LOW   gpio_bits_reset(GPIOA, GPIO_PINS_4)

uint8_t tx_buffer[BUFFER_SIZE] = {0x01, 0x02, 0x03, /* ... */};
uint8_t rx_buffer[BUFFER_SIZE];

void spi_full_duplex_init(void)
{
    spi_init_type spi_init_struct;
    
    /* Enable SPI clock */
    crm_periph_clock_enable(CRM_SPI1_PERIPH_CLOCK, TRUE);
    
    /* Initialize SPI */
    spi_default_para_init(&spi_init_struct);
    spi_init_struct.transmission_mode = SPI_TRANSMIT_FULL_DUPLEX;
    spi_init_struct.master_slave_mode = SPI_MODE_MASTER;
    spi_init_struct.mclk_freq_division = SPI_MCLK_DIV_8;
    spi_init_struct.first_bit_transmission = SPI_FIRST_BIT_MSB;
    spi_init_struct.frame_bit_num = SPI_FRAME_8BIT;
    spi_init_struct.clock_polarity = SPI_CLOCK_POLARITY_LOW;
    spi_init_struct.clock_phase = SPI_CLOCK_PHASE_2EDGE;
    spi_init_struct.cs_mode_selection = SPI_CS_SOFTWARE_MODE;
    spi_init(SPI1, &spi_init_struct);
    
    spi_enable(SPI1, TRUE);
}

void spi_transfer(uint8_t *tx_buf, uint8_t *rx_buf, uint32_t size)
{
    uint32_t i;
    
    /* Assert CS */
    SPI_CS_LOW;
    
    for (i = 0; i < size; i++)
    {
        /* Wait for TX buffer empty */
        while (spi_i2s_flag_get(SPI1, SPI_I2S_TDBE_FLAG) == RESET);
        spi_i2s_data_transmit(SPI1, tx_buf[i]);
        
        /* Wait for RX buffer full */
        while (spi_i2s_flag_get(SPI1, SPI_I2S_RDBF_FLAG) == RESET);
        rx_buf[i] = spi_i2s_data_receive(SPI1);
    }
    
    /* Wait for SPI idle */
    while (spi_i2s_flag_get(SPI1, SPI_I2S_BF_FLAG) != RESET);
    
    /* Deassert CS */
    SPI_CS_HIGH;
}
```

### Half-Duplex with Interrupt

```c
volatile uint32_t tx_index = 0, rx_index = 0;
uint8_t tx_buffer[BUFFER_SIZE];
uint8_t rx_buffer[BUFFER_SIZE];

void spi_half_duplex_init(void)
{
    spi_init_type spi_init_struct;
    
    crm_periph_clock_enable(CRM_SPI1_PERIPH_CLOCK, TRUE);
    nvic_irq_enable(SPI1_IRQn, 0, 0);
    
    spi_default_para_init(&spi_init_struct);
    
    /* Configure for half-duplex transmit */
    spi_init_struct.transmission_mode = SPI_TRANSMIT_HALF_DUPLEX_TX;
    spi_init_struct.master_slave_mode = SPI_MODE_MASTER;
    spi_init_struct.mclk_freq_division = SPI_MCLK_DIV_8;
    spi_init_struct.first_bit_transmission = SPI_FIRST_BIT_MSB;
    spi_init_struct.frame_bit_num = SPI_FRAME_8BIT;
    spi_init_struct.clock_polarity = SPI_CLOCK_POLARITY_LOW;
    spi_init_struct.clock_phase = SPI_CLOCK_PHASE_2EDGE;
    spi_init_struct.cs_mode_selection = SPI_CS_SOFTWARE_MODE;
    spi_init(SPI1, &spi_init_struct);
    
    /* Enable TX buffer empty interrupt */
    spi_i2s_interrupt_enable(SPI1, SPI_I2S_TDBE_INT, TRUE);
}

void SPI1_IRQHandler(void)
{
    if (spi_i2s_interrupt_flag_get(SPI1, SPI_I2S_TDBE_FLAG) != RESET)
    {
        spi_i2s_data_transmit(SPI1, tx_buffer[tx_index++]);
        if (tx_index == BUFFER_SIZE)
        {
            spi_i2s_interrupt_enable(SPI1, SPI_I2S_TDBE_INT, FALSE);
        }
    }
    
    if (spi_i2s_interrupt_flag_get(SPI1, SPI_I2S_RDBF_FLAG) != RESET)
    {
        /* Disable SPI before reading in half-duplex RX mode */
        spi_enable(SPI1, FALSE);
        rx_buffer[rx_index++] = spi_i2s_data_receive(SPI1);
        spi_enable(SPI1, TRUE);
        
        if (rx_index == BUFFER_SIZE)
        {
            spi_i2s_interrupt_enable(SPI1, SPI_I2S_RDBF_INT, FALSE);
            spi_enable(SPI1, FALSE);
        }
    }
}
```

### DMA Transfer

```c
void spi_dma_init(void)
{
    dma_init_type dma_init_struct;
    spi_init_type spi_init_struct;
    
    /* Enable clocks */
    crm_periph_clock_enable(CRM_SPI1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    
    /* Configure SPI */
    spi_default_para_init(&spi_init_struct);
    spi_init_struct.transmission_mode = SPI_TRANSMIT_FULL_DUPLEX;
    spi_init_struct.master_slave_mode = SPI_MODE_MASTER;
    spi_init_struct.mclk_freq_division = SPI_MCLK_DIV_8;
    spi_init_struct.first_bit_transmission = SPI_FIRST_BIT_LSB;
    spi_init_struct.frame_bit_num = SPI_FRAME_8BIT;
    spi_init_struct.clock_polarity = SPI_CLOCK_POLARITY_LOW;
    spi_init_struct.clock_phase = SPI_CLOCK_PHASE_2EDGE;
    spi_init_struct.cs_mode_selection = SPI_CS_SOFTWARE_MODE;
    spi_init(SPI1, &spi_init_struct);
    
    /* Configure DMA TX channel */
    dma_reset(DMA1_CHANNEL1);
    dma_default_para_init(&dma_init_struct);
    dma_init_struct.buffer_size = BUFFER_SIZE;
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_base_addr = (uint32_t)tx_buffer;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_BYTE;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)&(SPI1->dt);
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_MEDIUM;
    dma_init_struct.loop_mode_enable = FALSE;
    dma_init(DMA1_CHANNEL1, &dma_init_struct);
    dma_flexible_config(DMA1, FLEX_CHANNEL1, DMA_FLEXIBLE_SPI1_TX);
    
    /* Configure DMA RX channel */
    dma_reset(DMA1_CHANNEL2);
    dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
    dma_init_struct.memory_base_addr = (uint32_t)rx_buffer;
    dma_init(DMA1_CHANNEL2, &dma_init_struct);
    dma_flexible_config(DMA1, FLEX_CHANNEL2, DMA_FLEXIBLE_SPI1_RX);
    
    /* Enable SPI DMA */
    spi_i2s_dma_transmitter_enable(SPI1, TRUE);
    spi_i2s_dma_receiver_enable(SPI1, TRUE);
    
    spi_enable(SPI1, TRUE);
}

void spi_dma_transfer(void)
{
    /* Assert CS */
    SPI_CS_LOW;
    
    /* Enable DMA channels */
    dma_channel_enable(DMA1_CHANNEL2, TRUE);  /* RX first */
    dma_channel_enable(DMA1_CHANNEL1, TRUE);  /* TX second */
    
    /* Wait for transfer complete */
    while (dma_flag_get(DMA1_FDT2_FLAG) == RESET);
    
    /* Wait for SPI idle */
    while (spi_i2s_flag_get(SPI1, SPI_I2S_BF_FLAG) != RESET);
    
    /* Deassert CS */
    SPI_CS_HIGH;
}
```

### CRC Transfer

```c
void spi_crc_init(void)
{
    spi_init_type spi_init_struct;
    
    crm_periph_clock_enable(CRM_SPI1_PERIPH_CLOCK, TRUE);
    
    spi_default_para_init(&spi_init_struct);
    spi_init_struct.transmission_mode = SPI_TRANSMIT_FULL_DUPLEX;
    spi_init_struct.master_slave_mode = SPI_MODE_MASTER;
    spi_init_struct.mclk_freq_division = SPI_MCLK_DIV_8;
    spi_init_struct.first_bit_transmission = SPI_FIRST_BIT_MSB;
    spi_init_struct.frame_bit_num = SPI_FRAME_16BIT;  /* 16-bit for CRC */
    spi_init_struct.clock_polarity = SPI_CLOCK_POLARITY_LOW;
    spi_init_struct.clock_phase = SPI_CLOCK_PHASE_2EDGE;
    spi_init_struct.cs_mode_selection = SPI_CS_SOFTWARE_MODE;
    spi_init(SPI1, &spi_init_struct);
    
    /* Configure hardware CRC */
    spi_crc_polynomial_set(SPI1, 7);  /* CRC-7 polynomial */
    spi_crc_enable(SPI1, TRUE);
    
    spi_enable(SPI1, TRUE);
}

void spi_crc_transfer(uint16_t *tx_buf, uint16_t *rx_buf, uint32_t size)
{
    uint32_t i;
    
    SPI_CS_LOW;
    
    /* Transfer all but last byte */
    for (i = 0; i < size - 1; i++)
    {
        while (spi_i2s_flag_get(SPI1, SPI_I2S_TDBE_FLAG) == RESET);
        spi_i2s_data_transmit(SPI1, tx_buf[i]);
        
        while (spi_i2s_flag_get(SPI1, SPI_I2S_RDBF_FLAG) == RESET);
        rx_buf[i] = spi_i2s_data_receive(SPI1);
    }
    
    /* Wait for TX buffer empty */
    while (spi_i2s_flag_get(SPI1, SPI_I2S_TDBE_FLAG) == RESET);
    
    /* Send last data and trigger CRC transmission */
    spi_i2s_data_transmit(SPI1, tx_buf[size - 1]);
    spi_crc_next_transmit(SPI1);  /* CRC will be sent after this byte */
    
    /* Receive last data */
    while (spi_i2s_flag_get(SPI1, SPI_I2S_RDBF_FLAG) == RESET);
    rx_buf[size - 1] = spi_i2s_data_receive(SPI1);
    
    /* Wait for CRC exchange */
    while (spi_i2s_flag_get(SPI1, SPI_I2S_RDBF_FLAG) == RESET);
    
    /* Wait for idle */
    while (spi_i2s_flag_get(SPI1, SPI_I2S_BF_FLAG) != RESET);
    
    SPI_CS_HIGH;
    
    /* Check CRC error */
    if (spi_i2s_flag_get(SPI1, SPI_CCERR_FLAG) != RESET)
    {
        spi_i2s_flag_clear(SPI1, SPI_CCERR_FLAG);
        /* Handle CRC error */
    }
}
```

### External Flash Communication (W25Q)

```c
#define FLASH_CS_HIGH()  gpio_bits_set(GPIOB, GPIO_PINS_12)
#define FLASH_CS_LOW()   gpio_bits_reset(GPIOB, GPIO_PINS_12)

#define SPIF_READDATA    0x03
#define SPIF_PAGEPROGRAM 0x02
#define SPIF_SECTORERASE 0x20
#define DUMMY_BYTE       0xA5

void spiflash_init(void)
{
    spi_init_type spi_init_struct;
    
    crm_periph_clock_enable(CRM_SPI2_PERIPH_CLOCK, TRUE);
    
    spi_default_para_init(&spi_init_struct);
    spi_init_struct.transmission_mode = SPI_TRANSMIT_FULL_DUPLEX;
    spi_init_struct.master_slave_mode = SPI_MODE_MASTER;
    spi_init_struct.mclk_freq_division = SPI_MCLK_DIV_8;
    spi_init_struct.first_bit_transmission = SPI_FIRST_BIT_MSB;
    spi_init_struct.frame_bit_num = SPI_FRAME_8BIT;
    spi_init_struct.clock_polarity = SPI_CLOCK_POLARITY_HIGH;  /* Mode 3 for W25Q */
    spi_init_struct.clock_phase = SPI_CLOCK_PHASE_2EDGE;
    spi_init_struct.cs_mode_selection = SPI_CS_SOFTWARE_MODE;
    spi_init(SPI2, &spi_init_struct);
    
    spi_enable(SPI2, TRUE);
}

uint8_t spi_byte_write(uint8_t data)
{
    spi_i2s_data_transmit(SPI2, data);
    while (spi_i2s_flag_get(SPI2, SPI_I2S_RDBF_FLAG) == RESET);
    return spi_i2s_data_receive(SPI2);
}

void spiflash_read(uint8_t *buffer, uint32_t address, uint32_t length)
{
    FLASH_CS_LOW();
    
    /* Send read command */
    spi_byte_write(SPIF_READDATA);
    
    /* Send 24-bit address */
    spi_byte_write((address >> 16) & 0xFF);
    spi_byte_write((address >> 8) & 0xFF);
    spi_byte_write(address & 0xFF);
    
    /* Read data */
    while (length--)
    {
        *buffer++ = spi_byte_write(DUMMY_BYTE);
    }
    
    FLASH_CS_HIGH();
}

uint16_t spiflash_read_id(void)
{
    uint16_t id = 0;
    
    FLASH_CS_LOW();
    
    spi_byte_write(0x90);  /* Read Manufacturer/Device ID */
    spi_byte_write(0x00);
    spi_byte_write(0x00);
    spi_byte_write(0x00);
    
    id = spi_byte_write(DUMMY_BYTE) << 8;
    id |= spi_byte_write(DUMMY_BYTE);
    
    FLASH_CS_HIGH();
    
    return id;
}
```

## DMA Channel Mapping

### Flexible DMA Configuration

```c
/* SPI1 DMA channels */
dma_flexible_config(DMA1, FLEX_CHANNEL1, DMA_FLEXIBLE_SPI1_TX);
dma_flexible_config(DMA1, FLEX_CHANNEL2, DMA_FLEXIBLE_SPI1_RX);

/* SPI2 DMA channels */
dma_flexible_config(DMA1, FLEX_CHANNEL4, DMA_FLEXIBLE_SPI2_RX);
dma_flexible_config(DMA1, FLEX_CHANNEL5, DMA_FLEXIBLE_SPI2_TX);

/* Or using DMA2 for SPI2 */
dma_flexible_config(DMA2, FLEX_CHANNEL1, DMA_FLEXIBLE_SPI2_TX);
dma_flexible_config(DMA2, FLEX_CHANNEL2, DMA_FLEXIBLE_SPI2_RX);

/* SPI3 DMA channels */
dma_flexible_config(DMA2, FLEX_CHANNEL1, DMA_FLEXIBLE_SPI3_TX);
dma_flexible_config(DMA2, FLEX_CHANNEL2, DMA_FLEXIBLE_SPI3_RX);
```

## Clock Frequency Calculation

The SPI clock frequency is derived from the peripheral clock:

```
SPI_CLK = PCLK / MCLK_DIV

Where:
- PCLK = APB1 or APB2 clock (depending on SPI instance)
- MCLK_DIV = 2, 4, 8, 16, 32, 64, 128, 256, 512, or 1024
```

### Example Clock Calculations

| System Clock | APB Clock | Divider | SPI Clock |
|--------------|-----------|---------|-----------|
| 240 MHz      | 120 MHz   | DIV_2   | 60 MHz    |
| 240 MHz      | 120 MHz   | DIV_4   | 30 MHz    |
| 240 MHz      | 120 MHz   | DIV_8   | 15 MHz    |
| 240 MHz      | 120 MHz   | DIV_16  | 7.5 MHz   |
| 240 MHz      | 120 MHz   | DIV_256 | 468.75 kHz|

## Master vs Slave Configuration

### Master Mode Requirements
- Software CS: Set `swcsil` high to keep internal CS level high
- Clock output on SCK pin
- Drives MOSI, samples MISO

### Slave Mode Requirements
- Hardware CS recommended for proper synchronization
- Samples SCK from master
- Drives MISO, samples MOSI
- Must be enabled before master starts transmission

```c
/* Master configuration */
spi_init_struct.master_slave_mode = SPI_MODE_MASTER;
spi_init_struct.cs_mode_selection = SPI_CS_SOFTWARE_MODE;

/* Slave configuration */
spi_init_struct.master_slave_mode = SPI_MODE_SLAVE;
spi_init_struct.cs_mode_selection = SPI_CS_HARDWARE_MODE;
```

## Error Handling

### Common Errors

| Error Flag     | Description                    | Cause                                    |
|----------------|--------------------------------|------------------------------------------|
| SPI_CCERR_FLAG | CRC calculation error          | CRC mismatch between TX and RX           |
| SPI_MMERR_FLAG | Master mode error              | Multi-master conflict or NSS pulled low  |
| SPI_I2S_ROERR_FLAG | Receiver overflow error    | RX buffer not read before new data       |

### Error Handling Example

```c
void spi_check_errors(void)
{
    if (spi_i2s_flag_get(SPI1, SPI_CCERR_FLAG) != RESET)
    {
        /* CRC error - clear flag */
        spi_i2s_flag_clear(SPI1, SPI_CCERR_FLAG);
        /* Handle error... */
    }
    
    if (spi_i2s_flag_get(SPI1, SPI_MMERR_FLAG) != RESET)
    {
        /* Master mode error - clear by reading STS then writing CTRL1 */
        spi_i2s_flag_clear(SPI1, SPI_MMERR_FLAG);
        /* Handle error... */
    }
    
    if (spi_i2s_flag_get(SPI1, SPI_I2S_ROERR_FLAG) != RESET)
    {
        /* Overflow error - clear by reading DT then STS */
        spi_i2s_flag_clear(SPI1, SPI_I2S_ROERR_FLAG);
        /* Handle error... */
    }
}
```

## Troubleshooting

### Common Issues

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| No clock output | SPI not enabled | Call `spi_enable(SPIx, TRUE)` |
| Wrong clock speed | Incorrect divider | Check PCLK frequency and divider setting |
| Data corruption | CPOL/CPHA mismatch | Match SPI mode with slave device |
| Overflow errors | Slow data reading | Use DMA or increase clock divider |
| Master mode error | NSS configuration | Use software CS in master mode |
| No data received | MISO not connected | Check GPIO configuration |

### Debug Checklist

1. **Clock enabled?** - Check `crm_periph_clock_enable()` for SPI and GPIO
2. **GPIO configured?** - Master SCK/MOSI as MUX output, MISO as input
3. **SPI enabled?** - Call `spi_enable()` after configuration
4. **CS timing?** - Assert CS before transfer, deassert after
5. **Slave enabled first?** - Enable slave before master starts clock
6. **Wait for flags?** - Always check TDBE before TX, RDBF before RX
7. **Wait for idle?** - Check BF flag before deasserting CS

## Important Notes

1. **Enable Order**: In master-slave communication, enable the slave SPI before the master to ensure the slave captures the first clock edge.

2. **CS Timing**: When using software CS, always assert CS before starting transmission and deassert only after the SPI is idle (BF flag cleared).

3. **Full-Duplex Nature**: Even when only transmitting, you must read the received data to clear the RDBF flag and prevent overflow errors.

4. **DMA Order**: Enable RX DMA channel before TX DMA channel to prevent data loss.

5. **Half-Duplex Receive**: In master half-duplex RX mode, the busy flag behavior is different - use received byte count instead.

6. **CRC Timing**: Call `spi_crc_next_transmit()` before the last data byte is clocked out to ensure CRC is sent immediately after.

7. **Clock Divider**: Ensure the SPI clock doesn't exceed the slave device's maximum frequency.

8. **Pin Remapping**: When using JTAG pins for SPI, debug capabilities may be limited.

## See Also

- [I2S (Inter-IC Sound)](I2S_Inter_IC_Sound.md) - Audio communication using SPI peripheral
- [DMA Configuration](DMA_Direct_Memory_Access.md) - DMA setup for SPI
- [CRM (Clock and Reset Management)](CRM_Clock_Reset_Management.md) - Clock configuration

