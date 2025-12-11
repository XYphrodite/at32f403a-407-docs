# I2S (Inter-IC Sound) Peripheral - AT32F403A/407

## Table of Contents

1. [Overview](#overview)
2. [Key Features](#key-features)
3. [I2S Instances](#i2s-instances)
4. [Pin Configuration](#pin-configuration)
5. [Clock Architecture](#clock-architecture)
6. [Configuration Types](#configuration-types)
7. [Audio Protocols](#audio-protocols)
8. [Data Formats](#data-formats)
9. [Operation Modes](#operation-modes)
10. [Status Flags](#status-flags)
11. [Interrupt Sources](#interrupt-sources)
12. [DMA Support](#dma-support)
13. [Register Overview](#register-overview)
14. [Low-Level API Reference](#low-level-api-reference)
15. [Practical Examples](#practical-examples)
16. [Full-Duplex Mode](#full-duplex-mode)
17. [SPI/I2S Mode Switching](#spii2s-mode-switching)
18. [Clock Calculation](#clock-calculation)
19. [Troubleshooting](#troubleshooting)
20. [Important Notes](#important-notes)

---

## Overview

The I2S (Inter-IC Sound) interface on the AT32F403A/407 microcontroller provides a standardized serial interface for connecting digital audio devices. The I2S functionality is **integrated into the SPI peripheral**, meaning SPI2, SPI3, and SPI4 can be configured to operate in I2S mode instead of SPI mode.

The peripheral supports multiple audio protocols, various sampling frequencies, and can operate in both half-duplex and full-duplex modes using the dedicated I2S extension interfaces (I2S2EXT, I2S3EXT).

### I2S vs SPI Mode

- The same hardware peripheral can operate as either SPI or I2S
- Mode selection is done via the `i2smsel` bit in the I2SCTRL register
- When I2S mode is enabled, SPI-specific features are not available
- Full-duplex I2S uses the I2SxEXT extension interfaces

---

## Key Features

- **Audio Protocol Support**:
  - I2S Philips Standard
  - MSB-Justified Standard
  - LSB-Justified Standard
  - PCM Standard (Short and Long frame sync)

- **Sampling Frequencies**: 8 kHz to 192 kHz
  - 8 kHz, 11.025 kHz, 16 kHz, 22.05 kHz
  - 32 kHz, 44.1 kHz, 48 kHz
  - 96 kHz, 192 kHz

- **Data Formats**:
  - 16-bit data in 16-bit channel frame
  - 16-bit data in 32-bit channel frame
  - 24-bit data in 32-bit channel frame
  - 32-bit data in 32-bit channel frame

- **Operation Modes**:
  - Master Transmitter
  - Master Receiver
  - Slave Transmitter
  - Slave Receiver

- **Full-Duplex Support**: Via I2S2EXT and I2S3EXT extension interfaces

- **Master Clock Output (MCK)**: Optional MCLK output for external codec synchronization

- **DMA Support**: For efficient audio data streaming

- **Interrupt Support**: Data buffer events and error conditions

---

## I2S Instances

| Instance | Base Address | I2S Extension | Notes |
|----------|--------------|---------------|-------|
| SPI1 | SPI1_BASE | - | I2S capable |
| SPI2 | SPI2_BASE | I2S2EXT | I2S with full-duplex extension |
| SPI3 | SPI3_BASE | I2S3EXT | I2S with full-duplex extension |
| SPI4 | SPI4_BASE | - | I2S capable |
| I2S2EXT | I2S2EXT_BASE | - | Extension for SPI2 full-duplex |
| I2S3EXT | I2S3EXT_BASE | - | Extension for SPI3 full-duplex |

### Instance Definitions

```c
#define SPI1    ((spi_type *) SPI1_BASE)
#define SPI2    ((spi_type *) SPI2_BASE)
#define SPI3    ((spi_type *) SPI3_BASE)
#define SPI4    ((spi_type *) SPI4_BASE)
#define I2S2EXT ((spi_type *) I2S2EXT_BASE)
#define I2S3EXT ((spi_type *) I2S3EXT_BASE)
```

---

## Pin Configuration

### I2S Signal Pins

| Signal | Description | Direction (Master TX) | Direction (Slave RX) |
|--------|-------------|----------------------|---------------------|
| WS | Word Select (Left/Right Channel) | Output | Input |
| CK | Serial Clock (Bit Clock) | Output | Input |
| SD | Serial Data | Output | Input |
| MCK | Master Clock (optional) | Output | - |

### SPI3 I2S Pins (Half-Duplex Example)

| Function | Pin | GPIO Port | Mode (Master) | Mode (Slave) |
|----------|-----|-----------|---------------|--------------|
| WS | PA15 | GPIOA | AF Push-Pull | Input |
| CK | PB3 | GPIOB | AF Push-Pull | Input |
| SD | PB5 | GPIOB | AF Push-Pull | Input |
| MCK | PC7 | GPIOC | AF Push-Pull | - |

### SPI2 I2S Pins (Half-Duplex Example)

| Function | Pin | GPIO Port | Mode (Master) | Mode (Slave) |
|----------|-----|-----------|---------------|--------------|
| WS | PB12 | GPIOB | AF Push-Pull | Input |
| CK | PB13 | GPIOB | AF Push-Pull | Input |
| SD | PB15 | GPIOB | AF Push-Pull | Input |
| SDEXT | PB14 | GPIOB | Input (RX) | AF Push-Pull (TX) |

### Full-Duplex Pin Configuration

For full-duplex operation, additional SDEXT pins are used:

| Instance | Main SD | Extension SDEXT |
|----------|---------|-----------------|
| SPI2/I2S2EXT | PB15 | PB14 |
| SPI3/I2S3EXT | PC12 | PC11 |

### GPIO Configuration Example

```c
static void gpio_config(void)
{
    gpio_init_type gpio_initstructure;
    
    /* Enable GPIO clocks */
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
    
    /* Configure JTAG pins for GPIO use if needed */
    gpio_pin_remap_config(SWJTAG_GMUX_010, TRUE);
    
    /* Master I2S WS pin (PA15) */
    gpio_initstructure.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
    gpio_initstructure.gpio_pull = GPIO_PULL_UP;
    gpio_initstructure.gpio_mode = GPIO_MODE_MUX;
    gpio_initstructure.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
    gpio_initstructure.gpio_pins = GPIO_PINS_15;
    gpio_init(GPIOA, &gpio_initstructure);
    
    /* Master I2S CK pin (PB3) */
    gpio_initstructure.gpio_pull = GPIO_PULL_DOWN;
    gpio_initstructure.gpio_mode = GPIO_MODE_MUX;
    gpio_initstructure.gpio_pins = GPIO_PINS_3;
    gpio_init(GPIOB, &gpio_initstructure);
    
    /* Master I2S SD pin (PB5) */
    gpio_initstructure.gpio_pull = GPIO_PULL_UP;
    gpio_initstructure.gpio_mode = GPIO_MODE_MUX;
    gpio_initstructure.gpio_pins = GPIO_PINS_5;
    gpio_init(GPIOB, &gpio_initstructure);
    
    /* Master I2S MCK pin (PC7) - optional */
    gpio_initstructure.gpio_pull = GPIO_PULL_UP;
    gpio_initstructure.gpio_mode = GPIO_MODE_MUX;
    gpio_initstructure.gpio_pins = GPIO_PINS_7;
    gpio_init(GPIOC, &gpio_initstructure);
    
    /* Slave I2S WS pin (PB12) - Input for slave */
    gpio_initstructure.gpio_pull = GPIO_PULL_UP;
    gpio_initstructure.gpio_mode = GPIO_MODE_INPUT;
    gpio_initstructure.gpio_pins = GPIO_PINS_12;
    gpio_init(GPIOB, &gpio_initstructure);
    
    /* Slave I2S CK pin (PB13) - Input for slave */
    gpio_initstructure.gpio_pull = GPIO_PULL_DOWN;
    gpio_initstructure.gpio_mode = GPIO_MODE_INPUT;
    gpio_initstructure.gpio_pins = GPIO_PINS_13;
    gpio_init(GPIOB, &gpio_initstructure);
    
    /* Slave I2S SD pin (PB15) - Input for slave RX */
    gpio_initstructure.gpio_pull = GPIO_PULL_UP;
    gpio_initstructure.gpio_mode = GPIO_MODE_INPUT;
    gpio_initstructure.gpio_pins = GPIO_PINS_15;
    gpio_init(GPIOB, &gpio_initstructure);
}
```

---

## Clock Architecture

### I2S Clock Source

The I2S peripheral uses the system clock (SCLK) as its clock source. The I2S clock divider generates the required bit clock frequency based on the desired audio sampling rate.

### Clock Frequency Calculation

The I2S bit clock frequency depends on:
- Audio sampling frequency (Fs)
- Data channel format (16-bit or 32-bit channel)
- MCK output enabled or disabled

**With MCK Output Enabled:**
- For I2S/MSB/LSB standards: `SCLK / (256 × Fs)`
- For PCM standard: `SCLK / (128 × Fs)`

**Without MCK Output:**
- 16-bit channel: `SCLK / (32 × Fs)` or `SCLK / (16 × Fs)` for PCM
- 32-bit channel: `SCLK / (64 × Fs)` or `SCLK / (32 × Fs)` for PCM

### Clock Divider Configuration

The I2S clock is configured via:
- `I2SDIV`: 10-bit divider value (2-1023)
- `I2SODD`: Odd factor (0 or 1)

**Formula:**
```
Actual_Frequency = SCLK / ((I2SDIV × 2) + I2SODD)
```

---

## Configuration Types

### I2S Initialization Structure

```c
typedef struct
{
    i2s_operation_mode_type      operation_mode;      /* Master/Slave TX/RX selection */
    i2s_audio_protocol_type      audio_protocol;      /* Audio standard selection */
    i2s_audio_sampling_freq_type audio_sampling_freq; /* Sampling frequency */
    i2s_data_channel_format_type data_channel_format; /* Data/channel bit width */
    i2s_clock_polarity_type      clock_polarity;      /* Clock idle state */
    confirm_state                mclk_output_enable;  /* MCK output enable */
} i2s_init_type;
```

### Default Values

```c
void i2s_default_para_init(i2s_init_type* i2s_init_struct)
{
    i2s_init_struct->operation_mode     = I2S_MODE_SLAVE_TX;
    i2s_init_struct->audio_protocol     = I2S_AUDIO_PROTOCOL_PHILLIPS;
    i2s_init_struct->audio_sampling_freq = I2S_AUDIO_FREQUENCY_DEFAULT;
    i2s_init_struct->data_channel_format = I2S_DATA_16BIT_CHANNEL_16BIT;
    i2s_init_struct->clock_polarity     = I2S_CLOCK_POLARITY_LOW;
    i2s_init_struct->mclk_output_enable = FALSE;
}
```

---

## Audio Protocols

### Available Protocols

```c
typedef enum
{
    I2S_AUDIO_PROTOCOL_PHILLIPS   = 0x00,  /* I2S Philips standard */
    I2S_AUDIO_PROTOCOL_MSB        = 0x01,  /* MSB-justified standard */
    I2S_AUDIO_PROTOCOL_LSB        = 0x02,  /* LSB-justified standard */
    I2S_AUDIO_PROTOCOL_PCM_SHORT  = 0x03,  /* PCM standard - short frame */
    I2S_AUDIO_PROTOCOL_PCM_LONG   = 0x04   /* PCM standard - long frame */
} i2s_audio_protocol_type;
```

### Protocol Timing Diagrams

#### I2S Philips Standard
- WS changes one clock before the first data bit
- Data is MSB first
- WS low = Left channel, WS high = Right channel

#### MSB-Justified Standard
- WS changes at the same time as the first data bit
- Data is MSB first, aligned to WS edge

#### LSB-Justified Standard
- WS changes at the same time as the first data bit
- Data is LSB first, aligned to the end of the frame

#### PCM Standard
- Short frame: Single-clock WS pulse
- Long frame: WS pulse equals data frame length

---

## Data Formats

### Available Data/Channel Formats

```c
typedef enum
{
    I2S_DATA_16BIT_CHANNEL_16BIT = 0x01,  /* 16-bit data in 16-bit channel */
    I2S_DATA_16BIT_CHANNEL_32BIT = 0x02,  /* 16-bit data in 32-bit channel */
    I2S_DATA_24BIT_CHANNEL_32BIT = 0x03,  /* 24-bit data in 32-bit channel */
    I2S_DATA_32BIT_CHANNEL_32BIT = 0x04   /* 32-bit data in 32-bit channel */
} i2s_data_channel_format_type;
```

### Data Format Details

| Format | Data Bits | Channel Bits | Transfers per Sample |
|--------|-----------|--------------|---------------------|
| 16BIT_CHANNEL_16BIT | 16 | 16 | 1 (16-bit) |
| 16BIT_CHANNEL_32BIT | 16 | 32 | 2 (16-bit each) |
| 24BIT_CHANNEL_32BIT | 24 | 32 | 2 (16-bit each) |
| 32BIT_CHANNEL_32BIT | 32 | 32 | 2 (16-bit each) |

**Note:** For 24-bit and 32-bit data formats, two 16-bit transfers are required per channel sample.

---

## Operation Modes

### Available Modes

```c
typedef enum
{
    I2S_MODE_SLAVE_TX  = 0x00,  /* Slave transmission mode */
    I2S_MODE_SLAVE_RX  = 0x01,  /* Slave reception mode */
    I2S_MODE_MASTER_TX = 0x02,  /* Master transmission mode */
    I2S_MODE_MASTER_RX = 0x03   /* Master reception mode */
} i2s_operation_mode_type;
```

### Mode Characteristics

| Mode | Clock Generation | Data Direction |
|------|-----------------|----------------|
| Master TX | Internal (CK, WS output) | Data out (SD output) |
| Master RX | Internal (CK, WS output) | Data in (SD input) |
| Slave TX | External (CK, WS input) | Data out (SD output) |
| Slave RX | External (CK, WS input) | Data in (SD input) |

---

## Status Flags

### I2S-Specific Flags

```c
#define SPI_I2S_RDBF_FLAG   0x0001  /* Receive data buffer full flag */
#define SPI_I2S_TDBE_FLAG   0x0002  /* Transmit data buffer empty flag */
#define I2S_ACS_FLAG        0x0004  /* Audio channel state flag */
#define I2S_TUERR_FLAG      0x0008  /* Transmitter underload error flag */
#define SPI_I2S_ROERR_FLAG  0x0040  /* Receiver overflow error flag */
#define SPI_I2S_BF_FLAG     0x0080  /* Busy flag */
```

### Flag Descriptions

| Flag | Description | Clear Method |
|------|-------------|--------------|
| `RDBF` | Receive buffer contains valid data | Read DT register |
| `TDBE` | Transmit buffer is empty | Write to DT register |
| `ACS` | Audio channel side (0=Left, 1=Right) | Hardware managed |
| `TUERR` | Transmit underrun error | Read STS register |
| `ROERR` | Receive overrun error | Read DT then STS |
| `BF` | I2S bus is busy | Hardware managed |

### Flag Usage Example

```c
/* Wait for transmit buffer empty */
while(spi_i2s_flag_get(SPI3, SPI_I2S_TDBE_FLAG) == RESET);

/* Check audio channel side */
if(spi_i2s_flag_get(SPI3, I2S_ACS_FLAG) == RESET)
{
    /* Left channel */
}
else
{
    /* Right channel */
}

/* Wait for I2S to become idle */
while(spi_i2s_flag_get(SPI3, SPI_I2S_BF_FLAG) != RESET);
```

---

## Interrupt Sources

### Available Interrupts

```c
#define SPI_I2S_ERROR_INT  0x0020  /* Error interrupt (underrun, overrun) */
#define SPI_I2S_RDBF_INT   0x0040  /* Receive data buffer full interrupt */
#define SPI_I2S_TDBE_INT   0x0080  /* Transmit data buffer empty interrupt */
```

### NVIC Configuration

| I2S Instance | Event IRQ | Notes |
|--------------|-----------|-------|
| SPI2 | SPI2_I2S2EXT_IRQn | Shared with I2S2EXT |
| SPI3 | SPI3_I2S3EXT_IRQn | Shared with I2S3EXT |

### Interrupt Configuration Example

```c
/* Enable NVIC for I2S */
nvic_irq_enable(SPI3_I2S3EXT_IRQn, 0, 0);

/* Enable transmit data buffer empty interrupt */
spi_i2s_interrupt_enable(SPI3, SPI_I2S_TDBE_INT, TRUE);

/* Enable receive data buffer full interrupt */
spi_i2s_interrupt_enable(SPI2, SPI_I2S_RDBF_INT, TRUE);
```

### Interrupt Handler Example

```c
/* SPI2/I2S2EXT interrupt handler */
void SPI2_I2S2EXT_IRQHandler(void)
{
    if(spi_i2s_interrupt_flag_get(SPI2, SPI_I2S_RDBF_FLAG) != RESET)
    {
        i2s2_buffer_rx[rx_index++] = spi_i2s_data_receive(SPI2);
    }
}

/* SPI3/I2S3EXT interrupt handler */
void SPI3_I2S3EXT_IRQHandler(void)
{
    if(spi_i2s_interrupt_flag_get(SPI3, SPI_I2S_TDBE_FLAG) != RESET)
    {
        spi_i2s_data_transmit(SPI3, i2s3_buffer_tx[tx_index++]);
        if(tx_index == BUFFER_SIZE)
        {
            spi_i2s_interrupt_enable(SPI3, SPI_I2S_TDBE_INT, FALSE);
        }
    }
}
```

---

## DMA Support

### DMA Channel Mapping

| I2S Instance | TX DMA | RX DMA | Flexible Config |
|--------------|--------|--------|-----------------|
| SPI2 | DMA1_CHANNEL5 | DMA1_CHANNEL4 | Standard |
| SPI3 | DMA2_CHANNEL2 | DMA2_CHANNEL1 | Standard |
| I2S2EXT | Flexible | Flexible | DMA_FLEXIBLE_I2S2EXT_RX |
| I2S3EXT | Flexible | Flexible | DMA_FLEXIBLE_I2S3EXT_TX |

### DMA Configuration Example

```c
static void dma_config(void)
{
    dma_init_type dma_init_struct;
    
    /* Enable DMA clocks */
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_DMA2_PERIPH_CLOCK, TRUE);
    
    /* Configure DMA2_CHANNEL2 for SPI3 TX */
    dma_reset(DMA2_CHANNEL2);
    dma_default_para_init(&dma_init_struct);
    dma_init_struct.buffer_size = 32;
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_base_addr = (uint32_t)i2s3_buffer_tx;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_HALFWORD;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)&(SPI3->dt);
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_HIGH;
    dma_init_struct.loop_mode_enable = FALSE;
    dma_init(DMA2_CHANNEL2, &dma_init_struct);
    
    /* Configure DMA1_CHANNEL4 for SPI2 RX */
    dma_reset(DMA1_CHANNEL4);
    dma_init_struct.buffer_size = 32;
    dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
    dma_init_struct.memory_base_addr = (uint32_t)i2s2_buffer_rx;
    dma_init_struct.peripheral_base_addr = (uint32_t)&(SPI2->dt);
    dma_init(DMA1_CHANNEL4, &dma_init_struct);
}
```

### Enabling DMA for I2S

```c
/* Enable DMA transmitter for master */
spi_i2s_dma_transmitter_enable(SPI3, TRUE);

/* Enable DMA receiver for slave */
spi_i2s_dma_receiver_enable(SPI2, TRUE);

/* Start DMA channels */
dma_channel_enable(DMA1_CHANNEL4, TRUE);  /* Slave RX first */
dma_channel_enable(DMA2_CHANNEL2, TRUE);  /* Master TX */

/* Wait for DMA transfer complete */
while(dma_flag_get(DMA1_FDT4_FLAG) == RESET);
```

---

## Register Overview

### SPI/I2S Register Structure

```c
typedef struct
{
    union
    {
        __IO uint32_t ctrl1;    /* Control register 1, offset: 0x00 */
        struct
        {
            __IO uint32_t clkpha   : 1;  /* Clock phase */
            __IO uint32_t clkpol   : 1;  /* Clock polarity */
            __IO uint32_t msten    : 1;  /* Master enable */
            __IO uint32_t mdiv_l   : 3;  /* Master clock divider low */
            __IO uint32_t spien    : 1;  /* SPI enable */
            __IO uint32_t ltf      : 1;  /* LSB transmit first */
            __IO uint32_t swcsil   : 1;  /* Software CS internal level */
            __IO uint32_t swcsen   : 1;  /* Software CS enable */
            __IO uint32_t ora      : 1;  /* Output receive only */
            __IO uint32_t fbn      : 1;  /* Frame bit number */
            __IO uint32_t ntc      : 1;  /* Next transmit CRC */
            __IO uint32_t ccen     : 1;  /* CRC calculation enable */
            __IO uint32_t slbtd    : 1;  /* Single line bidirectional TX direction */
            __IO uint32_t slben    : 1;  /* Single line bidirectional enable */
            __IO uint32_t reserved1: 16;
        } ctrl1_bit;
    };
    
    union
    {
        __IO uint32_t ctrl2;    /* Control register 2, offset: 0x04 */
        struct
        {
            __IO uint32_t dmaren   : 1;  /* DMA receive enable */
            __IO uint32_t dmaten   : 1;  /* DMA transmit enable */
            __IO uint32_t hwcsoe   : 1;  /* Hardware CS output enable */
            __IO uint32_t reserved1: 2;
            __IO uint32_t errie    : 1;  /* Error interrupt enable */
            __IO uint32_t rdbfie   : 1;  /* RDBF interrupt enable */
            __IO uint32_t tdbeie   : 1;  /* TDBE interrupt enable */
            __IO uint32_t mdiv_h   : 1;  /* Master clock divider high */
            __IO uint32_t reserved2: 23;
        } ctrl2_bit;
    };
    
    union
    {
        __IO uint32_t sts;      /* Status register, offset: 0x08 */
        struct
        {
            __IO uint32_t rdbf     : 1;  /* Receive data buffer full */
            __IO uint32_t tdbe     : 1;  /* Transmit data buffer empty */
            __IO uint32_t acs      : 1;  /* Audio channel state */
            __IO uint32_t tuerr    : 1;  /* Transmit underload error */
            __IO uint32_t ccerr    : 1;  /* CRC calculation error */
            __IO uint32_t mmerr    : 1;  /* Master mode error */
            __IO uint32_t roerr    : 1;  /* Receiver overflow error */
            __IO uint32_t bf       : 1;  /* Busy flag */
            __IO uint32_t reserved1: 24;
        } sts_bit;
    };
    
    union
    {
        __IO uint32_t dt;       /* Data register, offset: 0x0C */
        struct
        {
            __IO uint32_t dt       : 16; /* Data */
            __IO uint32_t reserved1: 16;
        } dt_bit;
    };
    
    /* CRC registers (SPI mode only) */
    __IO uint32_t cpoly;        /* CRC polynomial, offset: 0x10 */
    __IO uint32_t rcrc;         /* RX CRC, offset: 0x14 */
    __IO uint32_t tcrc;         /* TX CRC, offset: 0x18 */
    
    union
    {
        __IO uint32_t i2sctrl;  /* I2S control register, offset: 0x1C */
        struct
        {
            __IO uint32_t i2scbn   : 1;  /* I2S channel bit number */
            __IO uint32_t i2sdbn   : 2;  /* I2S data bit number */
            __IO uint32_t i2sclkpol: 1;  /* I2S clock polarity */
            __IO uint32_t stdsel   : 2;  /* Standard selection */
            __IO uint32_t reserved1: 1;
            __IO uint32_t pcmfssel : 1;  /* PCM frame sync selection */
            __IO uint32_t opersel  : 2;  /* Operation mode selection */
            __IO uint32_t i2sen    : 1;  /* I2S enable */
            __IO uint32_t i2smsel  : 1;  /* I2S mode select */
            __IO uint32_t reserved2: 20;
        } i2sctrl_bit;
    };
    
    union
    {
        __IO uint32_t i2sclk;   /* I2S clock register, offset: 0x20 */
        struct
        {
            __IO uint32_t i2sdiv_l : 8;  /* I2S divider low bits */
            __IO uint32_t i2sodd   : 1;  /* I2S odd factor */
            __IO uint32_t i2smclkoe: 1;  /* I2S master clock output enable */
            __IO uint32_t i2sdiv_h : 2;  /* I2S divider high bits */
            __IO uint32_t reserved1: 20;
        } i2sclk_bit;
    };
} spi_type;
```

### Key Register Bits for I2S

| Register | Bit Field | Description |
|----------|-----------|-------------|
| I2SCTRL | i2smsel | 1 = I2S mode, 0 = SPI mode |
| I2SCTRL | i2sen | I2S peripheral enable |
| I2SCTRL | opersel | Operation mode (Master/Slave TX/RX) |
| I2SCTRL | stdsel | Audio standard selection |
| I2SCTRL | pcmfssel | PCM frame sync (short/long) |
| I2SCTRL | i2sclkpol | Clock polarity |
| I2SCTRL | i2sdbn | Data bit number |
| I2SCTRL | i2scbn | Channel bit number |
| I2SCLK | i2sdiv | Clock divider (10-bit) |
| I2SCLK | i2sodd | Odd factor for divider |
| I2SCLK | i2smclkoe | Master clock output enable |

---

## Low-Level API Reference

### Initialization Functions

```c
/* Reset SPI/I2S peripheral */
void spi_i2s_reset(spi_type *spi_x);

/* Initialize I2S with default parameters */
void i2s_default_para_init(i2s_init_type* i2s_init_struct);

/* Initialize I2S with specified parameters */
void i2s_init(spi_type* spi_x, i2s_init_type* i2s_init_struct);

/* Enable/disable I2S */
void i2s_enable(spi_type* spi_x, confirm_state new_state);
```

### Data Transfer Functions

```c
/* Transmit 16-bit data */
void spi_i2s_data_transmit(spi_type* spi_x, uint16_t tx_data);

/* Receive 16-bit data */
uint16_t spi_i2s_data_receive(spi_type* spi_x);
```

### Interrupt Functions

```c
/* Enable/disable interrupt */
void spi_i2s_interrupt_enable(spi_type* spi_x, uint32_t spi_i2s_int, confirm_state new_state);

/* Get interrupt flag status */
flag_status spi_i2s_interrupt_flag_get(spi_type* spi_x, uint32_t spi_i2s_flag);
```

### DMA Functions

```c
/* Enable DMA transmitter */
void spi_i2s_dma_transmitter_enable(spi_type* spi_x, confirm_state new_state);

/* Enable DMA receiver */
void spi_i2s_dma_receiver_enable(spi_type* spi_x, confirm_state new_state);
```

### Flag Functions

```c
/* Get flag status */
flag_status spi_i2s_flag_get(spi_type* spi_x, uint32_t spi_i2s_flag);

/* Clear flag */
void spi_i2s_flag_clear(spi_type* spi_x, uint32_t spi_i2s_flag);
```

---

## Practical Examples

### Example 1: Half-Duplex Polling Mode

Master transmits, slave receives in polling mode.

```c
#define BUF_SIZE  32

uint16_t i2s3_buffer_tx[BUF_SIZE] = {0x0102, 0x0304, 0x0506, /* ... */};
uint16_t i2s2_buffer_rx[BUF_SIZE];

int main(void)
{
    system_clock_config();
    gpio_config();
    
    i2s_init_type i2s_init_struct;
    
    /* Configure SPI3 as I2S Master TX */
    crm_periph_clock_enable(CRM_SPI3_PERIPH_CLOCK, TRUE);
    i2s_default_para_init(&i2s_init_struct);
    i2s_init_struct.audio_protocol = I2S_AUDIO_PROTOCOL_PHILLIPS;
    i2s_init_struct.data_channel_format = I2S_DATA_16BIT_CHANNEL_32BIT;
    i2s_init_struct.mclk_output_enable = FALSE;
    i2s_init_struct.audio_sampling_freq = I2S_AUDIO_FREQUENCY_48K;
    i2s_init_struct.clock_polarity = I2S_CLOCK_POLARITY_LOW;
    i2s_init_struct.operation_mode = I2S_MODE_MASTER_TX;
    i2s_init(SPI3, &i2s_init_struct);
    
    /* Configure SPI2 as I2S Slave RX */
    crm_periph_clock_enable(CRM_SPI2_PERIPH_CLOCK, TRUE);
    i2s_init_struct.operation_mode = I2S_MODE_SLAVE_RX;
    i2s_init(SPI2, &i2s_init_struct);
    
    /* Enable both I2S interfaces */
    i2s_enable(SPI2, TRUE);  /* Enable slave first */
    i2s_enable(SPI3, TRUE);  /* Then master */
    
    /* Transfer data */
    uint32_t tx_index = 0, rx_index = 0;
    while(rx_index < BUF_SIZE)
    {
        /* Transmit data */
        while(spi_i2s_flag_get(SPI3, SPI_I2S_TDBE_FLAG) == RESET);
        spi_i2s_data_transmit(SPI3, i2s3_buffer_tx[tx_index++]);
        
        /* Receive data */
        while(spi_i2s_flag_get(SPI2, SPI_I2S_RDBF_FLAG) == RESET);
        i2s2_buffer_rx[rx_index++] = spi_i2s_data_receive(SPI2);
    }
    
    /* Wait for transfer complete */
    while(spi_i2s_flag_get(SPI3, SPI_I2S_BF_FLAG) != RESET);
    while(spi_i2s_flag_get(SPI2, SPI_I2S_BF_FLAG) != RESET);
    
    /* Verify data */
    if(buffer_compare(i2s2_buffer_rx, i2s3_buffer_tx, BUF_SIZE) == SUCCESS)
    {
        /* Transfer successful */
    }
    
    while(1);
}
```

### Example 2: Half-Duplex Interrupt Mode

```c
uint16_t i2s3_buffer_tx[32];
uint16_t i2s2_buffer_rx[32];
__IO uint32_t tx_index = 0, rx_index = 0;

void i2s_config(i2s_data_channel_format_type format, i2s_audio_sampling_freq_type freq)
{
    i2s_init_type i2s_init_struct;
    
    /* Master I2S3 configuration */
    crm_periph_clock_enable(CRM_SPI3_PERIPH_CLOCK, TRUE);
    nvic_irq_enable(SPI3_I2S3EXT_IRQn, 0, 0);
    spi_i2s_reset(SPI3);
    i2s_default_para_init(&i2s_init_struct);
    
    i2s_init_struct.audio_protocol = I2S_AUDIO_PROTOCOL_PHILLIPS;
    i2s_init_struct.data_channel_format = format;
    i2s_init_struct.mclk_output_enable = TRUE;
    i2s_init_struct.audio_sampling_freq = freq;
    i2s_init_struct.clock_polarity = I2S_CLOCK_POLARITY_LOW;
    i2s_init_struct.operation_mode = I2S_MODE_MASTER_TX;
    i2s_init(SPI3, &i2s_init_struct);
    
    /* Enable TX buffer empty interrupt */
    spi_i2s_interrupt_enable(SPI3, SPI_I2S_TDBE_INT, TRUE);
    
    /* Slave I2S2 configuration */
    crm_periph_clock_enable(CRM_SPI2_PERIPH_CLOCK, TRUE);
    nvic_irq_enable(SPI2_I2S2EXT_IRQn, 0, 0);
    spi_i2s_reset(SPI2);
    
    i2s_init_struct.operation_mode = I2S_MODE_SLAVE_RX;
    i2s_init(SPI2, &i2s_init_struct);
    
    /* Enable RX buffer full interrupt */
    spi_i2s_interrupt_enable(SPI2, SPI_I2S_RDBF_INT, TRUE);
}

void SPI2_I2S2EXT_IRQHandler(void)
{
    if(spi_i2s_interrupt_flag_get(SPI2, SPI_I2S_RDBF_FLAG) != RESET)
    {
        i2s2_buffer_rx[rx_index++] = spi_i2s_data_receive(SPI2);
    }
}

void SPI3_I2S3EXT_IRQHandler(void)
{
    if(spi_i2s_interrupt_flag_get(SPI3, SPI_I2S_TDBE_FLAG) != RESET)
    {
        spi_i2s_data_transmit(SPI3, i2s3_buffer_tx[tx_index++]);
        if(tx_index == 32)
        {
            spi_i2s_interrupt_enable(SPI3, SPI_I2S_TDBE_INT, FALSE);
        }
    }
}

int main(void)
{
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    system_clock_config();
    gpio_config();
    
    i2s_config(I2S_DATA_16BIT_CHANNEL_32BIT, I2S_AUDIO_FREQUENCY_48K);
    
    /* Enable slave first, then master */
    i2s_enable(SPI2, TRUE);
    i2s_enable(SPI3, TRUE);
    
    /* Wait for transfer complete */
    while(rx_index < 32);
    
    while(1);
}
```

### Example 3: Half-Duplex DMA Mode

```c
uint16_t i2s3_buffer_tx[32];
uint16_t i2s2_buffer_rx[32];

static void dma_config(void)
{
    dma_init_type dma_init_struct;
    
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_DMA2_PERIPH_CLOCK, TRUE);
    
    /* DMA2_CHANNEL2 for SPI3 TX */
    dma_reset(DMA2_CHANNEL2);
    dma_default_para_init(&dma_init_struct);
    dma_init_struct.buffer_size = 32;
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_base_addr = (uint32_t)i2s3_buffer_tx;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_HALFWORD;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)&(SPI3->dt);
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_HIGH;
    dma_init_struct.loop_mode_enable = FALSE;
    dma_init(DMA2_CHANNEL2, &dma_init_struct);
    
    /* DMA1_CHANNEL4 for SPI2 RX */
    dma_reset(DMA1_CHANNEL4);
    dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
    dma_init_struct.memory_base_addr = (uint32_t)i2s2_buffer_rx;
    dma_init_struct.peripheral_base_addr = (uint32_t)&(SPI2->dt);
    dma_init(DMA1_CHANNEL4, &dma_init_struct);
}

static void i2s_config(void)
{
    i2s_init_type i2s_init_struct;
    
    /* Master SPI3 configuration */
    crm_periph_clock_enable(CRM_SPI3_PERIPH_CLOCK, TRUE);
    i2s_default_para_init(&i2s_init_struct);
    i2s_init_struct.audio_protocol = I2S_AUDIO_PROTOCOL_PHILLIPS;
    i2s_init_struct.data_channel_format = I2S_DATA_16BIT_CHANNEL_32BIT;
    i2s_init_struct.mclk_output_enable = TRUE;
    i2s_init_struct.audio_sampling_freq = I2S_AUDIO_FREQUENCY_48K;
    i2s_init_struct.clock_polarity = I2S_CLOCK_POLARITY_LOW;
    i2s_init_struct.operation_mode = I2S_MODE_MASTER_TX;
    i2s_init(SPI3, &i2s_init_struct);
    spi_i2s_dma_transmitter_enable(SPI3, TRUE);
    i2s_enable(SPI3, TRUE);
    
    /* Slave SPI2 configuration */
    crm_periph_clock_enable(CRM_SPI2_PERIPH_CLOCK, TRUE);
    i2s_init_struct.operation_mode = I2S_MODE_SLAVE_RX;
    i2s_init(SPI2, &i2s_init_struct);
    spi_i2s_dma_receiver_enable(SPI2, TRUE);
    i2s_enable(SPI2, TRUE);
}

int main(void)
{
    system_clock_config();
    gpio_config();
    dma_config();
    i2s_config();
    
    /* Enable slave DMA first */
    dma_channel_enable(DMA1_CHANNEL4, TRUE);
    
    /* Enable master DMA */
    dma_channel_enable(DMA2_CHANNEL2, TRUE);
    
    /* Wait for slave receive complete */
    while(dma_flag_get(DMA1_FDT4_FLAG) == RESET);
    
    /* Wait for I2S idle */
    while(spi_i2s_flag_get(SPI3, SPI_I2S_BF_FLAG) != RESET);
    while(spi_i2s_flag_get(SPI2, SPI_I2S_BF_FLAG) != RESET);
    
    /* Verify transfer */
    if(buffer_compare(i2s2_buffer_rx, i2s3_buffer_tx, 32) == SUCCESS)
    {
        /* Success */
    }
    
    while(1);
}
```

---

## Full-Duplex Mode

Full-duplex I2S communication uses the main SPI interface for one direction and the I2SxEXT extension interface for the other direction.

### Full-Duplex Configuration

| Configuration | Main Interface | Extension Interface |
|--------------|----------------|---------------------|
| Master TX + RX | SPI2 (TX) | I2S2EXT (RX) |
| Slave RX + TX | SPI3 (RX) | I2S3EXT (TX) |

### Full-Duplex DMA Example

```c
#define TXBUF_SIZE  32
#define RXBUF_SIZE  TXBUF_SIZE

uint16_t i2s2_buffer_tx[TXBUF_SIZE];  /* Master TX data */
uint16_t i2s2_buffer_rx[RXBUF_SIZE];  /* Master RX data (via I2S2EXT) */
uint16_t i2s3_buffer_tx[TXBUF_SIZE];  /* Slave TX data (via I2S3EXT) */
uint16_t i2s3_buffer_rx[RXBUF_SIZE];  /* Slave RX data */

static void dma_config(void)
{
    dma_init_type dma_init_struct;
    
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    
    /* DMA1_CHANNEL1: SPI2 TX (Master transmit) */
    dma_reset(DMA1_CHANNEL1);
    dma_default_para_init(&dma_init_struct);
    dma_init_struct.buffer_size = TXBUF_SIZE;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_HALFWORD;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_HIGH;
    dma_init_struct.loop_mode_enable = FALSE;
    dma_init_struct.memory_base_addr = (uint32_t)i2s2_buffer_tx;
    dma_init_struct.peripheral_base_addr = (uint32_t)&(SPI2->dt);
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init(DMA1_CHANNEL1, &dma_init_struct);
    dma_flexible_config(DMA1, FLEX_CHANNEL1, DMA_FLEXIBLE_SPI2_TX);
    
    /* DMA1_CHANNEL2: I2S2EXT RX (Master receive) */
    dma_reset(DMA1_CHANNEL2);
    dma_init_struct.buffer_size = RXBUF_SIZE;
    dma_init_struct.memory_base_addr = (uint32_t)i2s2_buffer_rx;
    dma_init_struct.peripheral_base_addr = (uint32_t)&(I2S2EXT->dt);
    dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
    dma_init(DMA1_CHANNEL2, &dma_init_struct);
    dma_flexible_config(DMA1, FLEX_CHANNEL2, DMA_FLEXIBLE_I2S2EXT_RX);
    
    /* DMA1_CHANNEL3: SPI3 RX (Slave receive) */
    dma_reset(DMA1_CHANNEL3);
    dma_init_struct.memory_base_addr = (uint32_t)i2s3_buffer_rx;
    dma_init_struct.peripheral_base_addr = (uint32_t)&(SPI3->dt);
    dma_init(DMA1_CHANNEL3, &dma_init_struct);
    dma_flexible_config(DMA1, FLEX_CHANNEL3, DMA_FLEXIBLE_SPI3_RX);
    
    /* DMA1_CHANNEL4: I2S3EXT TX (Slave transmit) */
    dma_reset(DMA1_CHANNEL4);
    dma_init_struct.memory_base_addr = (uint32_t)i2s3_buffer_tx;
    dma_init_struct.peripheral_base_addr = (uint32_t)&(I2S3EXT->dt);
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init(DMA1_CHANNEL4, &dma_init_struct);
    dma_flexible_config(DMA1, FLEX_CHANNEL4, DMA_FLEXIBLE_I2S3EXT_TX);
}

static void i2s_config(void)
{
    i2s_init_type i2s_init_struct;
    
    /* Master SPI2 configuration (TX) */
    crm_periph_clock_enable(CRM_SPI2_PERIPH_CLOCK, TRUE);
    i2s_default_para_init(&i2s_init_struct);
    i2s_init_struct.audio_protocol = I2S_AUDIO_PROTOCOL_PHILLIPS;
    i2s_init_struct.data_channel_format = I2S_DATA_16BIT_CHANNEL_32BIT;
    i2s_init_struct.mclk_output_enable = TRUE;
    i2s_init_struct.audio_sampling_freq = I2S_AUDIO_FREQUENCY_48K;
    i2s_init_struct.clock_polarity = I2S_CLOCK_POLARITY_LOW;
    i2s_init_struct.operation_mode = I2S_MODE_MASTER_TX;
    i2s_init(SPI2, &i2s_init_struct);
    
    /* I2S2EXT configuration (Slave RX for master's receive path) */
    i2s_init_struct.operation_mode = I2S_MODE_SLAVE_RX;
    i2s_init(I2S2EXT, &i2s_init_struct);
    
    /* Enable DMA for master */
    spi_i2s_dma_transmitter_enable(SPI2, TRUE);
    spi_i2s_dma_receiver_enable(I2S2EXT, TRUE);
    
    i2s_enable(SPI2, TRUE);
    i2s_enable(I2S2EXT, TRUE);
    
    /* Slave SPI3 configuration (RX) */
    crm_periph_clock_enable(CRM_SPI3_PERIPH_CLOCK, TRUE);
    i2s_init_struct.operation_mode = I2S_MODE_SLAVE_RX;
    i2s_init(SPI3, &i2s_init_struct);
    
    /* I2S3EXT configuration (Slave TX for slave's transmit path) */
    i2s_init_struct.operation_mode = I2S_MODE_SLAVE_TX;
    i2s_init(I2S3EXT, &i2s_init_struct);
    
    /* Enable DMA for slave */
    spi_i2s_dma_receiver_enable(SPI3, TRUE);
    spi_i2s_dma_transmitter_enable(I2S3EXT, TRUE);
    
    i2s_enable(SPI3, TRUE);
    i2s_enable(I2S3EXT, TRUE);
}

int main(void)
{
    system_clock_config();
    tx_data_fill();
    gpio_config();
    dma_config();
    i2s_config();
    
    /* Enable slave DMA channels first */
    dma_channel_enable(DMA1_CHANNEL3, TRUE);  /* Slave RX */
    dma_channel_enable(DMA1_CHANNEL4, TRUE);  /* Slave TX */
    
    /* Enable master DMA channels */
    dma_channel_enable(DMA1_CHANNEL2, TRUE);  /* Master RX */
    dma_channel_enable(DMA1_CHANNEL1, TRUE);  /* Master TX */
    
    /* Wait for data receive complete */
    while(dma_flag_get(DMA1_FDT2_FLAG) == RESET);  /* Master RX */
    while(dma_flag_get(DMA1_FDT3_FLAG) == RESET);  /* Slave RX */
    
    /* Verify bidirectional transfer */
    if(buffer_compare(i2s2_buffer_rx, i2s3_buffer_tx, TXBUF_SIZE) == SUCCESS &&
       buffer_compare(i2s3_buffer_rx, i2s2_buffer_tx, TXBUF_SIZE) == SUCCESS)
    {
        /* Full-duplex transfer successful */
    }
    
    while(1);
}
```

### Full-Duplex Pin Connection

```
I2S2 (Master)                    I2S3 (Slave)
- PB12 (WS)           <--->      PA4  (WS)
- PB13 (SCK)          <--->      PC10 (SCK)
- PB14 (SDEXT) RX     <--->      PC11 (SDEXT) TX
- PB15 (SD) TX        <--->      PC12 (SD) RX
```

---

## SPI/I2S Mode Switching

The same peripheral can switch between SPI and I2S modes dynamically.

### Mode Switching Example

```c
/* First: I2S communication */
gpio_config(1);  /* Configure for I2S */
i2s_config(I2S_MODE_MASTER_TX, I2S_MODE_SLAVE_RX);
i2s_enable(SPI2, TRUE);
i2s_enable(SPI3, TRUE);

/* Perform I2S transfer */
while(rx_index < 32)
{
    while(spi_i2s_flag_get(SPI3, SPI_I2S_TDBE_FLAG) == RESET);
    spi_i2s_data_transmit(SPI3, i2s3_buffer_tx[tx_index++]);
    
    while(spi_i2s_flag_get(SPI2, SPI_I2S_RDBF_FLAG) == RESET);
    i2s2_buffer_rx[rx_index++] = spi_i2s_data_receive(SPI2);
}

/* Wait for I2S idle */
while(spi_i2s_flag_get(SPI3, SPI_I2S_BF_FLAG) != RESET);
while(spi_i2s_flag_get(SPI2, SPI_I2S_BF_FLAG) != RESET);

/* Reset indices */
tx_index = 0;
rx_index = 0;

/* Second: Switch to SPI communication */
gpio_config(0);  /* Configure for SPI */
spi_config();    /* Configure SPI mode */

/* Pull CS low to start SPI transfer */
SPI_MASTER_CS_LOW;

/* Perform SPI transfer */
while(rx_index < 32)
{
    while(spi_i2s_flag_get(SPI3, SPI_I2S_TDBE_FLAG) == RESET);
    spi_i2s_data_transmit(SPI3, spi3_buffer_tx[tx_index++]);
    
    while(spi_i2s_flag_get(SPI2, SPI_I2S_RDBF_FLAG) == RESET);
    spi2_buffer_rx[rx_index++] = spi_i2s_data_receive(SPI2);
}

/* Pull CS high to end SPI transfer */
SPI_MASTER_CS_HIGH;
```

---

## Clock Calculation

### Audio Sampling Frequency Constants

```c
typedef enum
{
    I2S_AUDIO_FREQUENCY_DEFAULT = 2,      /* Default divider */
    I2S_AUDIO_FREQUENCY_8K      = 8000,   /* 8 kHz */
    I2S_AUDIO_FREQUENCY_11_025K = 11025,  /* 11.025 kHz */
    I2S_AUDIO_FREQUENCY_16K     = 16000,  /* 16 kHz */
    I2S_AUDIO_FREQUENCY_22_05K  = 22050,  /* 22.05 kHz */
    I2S_AUDIO_FREQUENCY_32K     = 32000,  /* 32 kHz */
    I2S_AUDIO_FREQUENCY_44_1K   = 44100,  /* 44.1 kHz */
    I2S_AUDIO_FREQUENCY_48K     = 48000,  /* 48 kHz */
    I2S_AUDIO_FREQUENCY_96K     = 96000,  /* 96 kHz */
    I2S_AUDIO_FREQUENCY_192K    = 192000  /* 192 kHz */
} i2s_audio_sampling_freq_type;
```

### Clock Calculation Algorithm

The `i2s_init()` function automatically calculates the divider values:

```c
/* Clock calculation in i2s_init() */
if(i2s_init_struct->audio_sampling_freq == I2S_AUDIO_FREQUENCY_DEFAULT)
{
    i2sodd_index = 0;
    i2sdiv_index = 2;
}
else
{
    crm_clocks_freq_get(&clocks_freq);
    i2s_sclk_index = clocks_freq.sclk_freq;
    
    if((audio_protocol == PCM_SHORT) || (audio_protocol == PCM_LONG))
    {
        if(mclk_output_enable == TRUE)
            frequency_index = (((i2s_sclk_index / 128) * 10) / audio_sampling_freq) + 5;
        else
        {
            if(data_channel_format == I2S_DATA_16BIT_CHANNEL_16BIT)
                frequency_index = (((i2s_sclk_index / 16) * 10) / audio_sampling_freq) + 5;
            else
                frequency_index = (((i2s_sclk_index / 32) * 10) / audio_sampling_freq) + 5;
        }
    }
    else /* I2S, MSB, LSB standards */
    {
        if(mclk_output_enable == TRUE)
            frequency_index = (((i2s_sclk_index / 256) * 10) / audio_sampling_freq) + 5;
        else
        {
            if(data_channel_format == I2S_DATA_16BIT_CHANNEL_16BIT)
                frequency_index = (((i2s_sclk_index / 32) * 10) / audio_sampling_freq) + 5;
            else
                frequency_index = (((i2s_sclk_index / 64) * 10) / audio_sampling_freq) + 5;
        }
    }
    
    frequency_index = frequency_index / 10;
    i2sodd_index = frequency_index & 0x0001;
    i2sdiv_index = (frequency_index - i2sodd_index) / 2;
    
    /* Clamp divider to valid range */
    if((i2sdiv_index < 2) || (i2sdiv_index > 0x03FF))
    {
        i2sodd_index = 0;
        i2sdiv_index = 2;
    }
}
```

### Example Clock Values

For a 240 MHz system clock with 48 kHz audio sampling and MCK enabled:

| Format | Divider | Actual Frequency |
|--------|---------|------------------|
| I2S Philips | ~4 | 48 kHz (approx) |
| PCM | ~9 | 48 kHz (approx) |

---

## Troubleshooting

### Common Issues and Solutions

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| No audio output | I2S not enabled | Check `i2s_enable()` was called |
| | Wrong pin configuration | Verify GPIO alternate function |
| | Clock not configured | Ensure peripheral clock enabled |
| Data corruption | Timing mismatch | Verify master/slave have same settings |
| | Buffer overrun | Use DMA for high-speed transfers |
| Underrun errors | TX buffer not filled fast enough | Use DMA or increase interrupt priority |
| Overrun errors | RX buffer not read fast enough | Use DMA or increase interrupt priority |
| Wrong channel | ACS flag misread | Check audio protocol timing |
| No clock | MCK not enabled | Set `mclk_output_enable = TRUE` |
| | Wrong GPIO config | Verify MCK pin as alternate function |

### Debug Tips

1. **Verify Clock Output**: Use oscilloscope to check CK and WS signals
2. **Check Data Alignment**: Verify data format matches connected codec
3. **Monitor Flags**: Check BF, TUERR, and ROERR flags for errors
4. **DMA Configuration**: Ensure halfword data width for 16-bit transfers

### Error Flag Handling

```c
/* Check for errors */
if(spi_i2s_flag_get(SPI3, I2S_TUERR_FLAG) == SET)
{
    /* Transmit underrun - data not provided in time */
    spi_i2s_flag_clear(SPI3, I2S_TUERR_FLAG);
}

if(spi_i2s_flag_get(SPI2, SPI_I2S_ROERR_FLAG) == SET)
{
    /* Receive overrun - data not read in time */
    spi_i2s_flag_clear(SPI2, SPI_I2S_ROERR_FLAG);
}
```

---

## Important Notes

1. **Enable Order**: Always enable slave before master to avoid missing initial data.

2. **Slave TX Pre-fill**: In slave TX mode, fill the TX buffer before enabling I2S:
   ```c
   while(spi_i2s_flag_get(SPI3, SPI_I2S_TDBE_FLAG) == RESET);
   spi_i2s_data_transmit(SPI3, i2s3_buffer_tx[tx_index++]);
   i2s_enable(SPI3, TRUE);
   ```

3. **Data Width**: I2S always uses 16-bit data transfers. For 24/32-bit audio, two transfers per sample are required.

4. **Master Clock**: MCK is optional but recommended for external codecs that need a reference clock.

5. **Full-Duplex Clocking**: In full-duplex mode, the extension interface (I2SxEXT) always operates as a slave, deriving its clock from the main interface.

6. **PCM Mode**: PCM mode has different clock requirements. Use short frame for TDM applications.

7. **GPIO Remapping**: Some I2S pins require GPIO remapping. Always configure IOMUX before I2S initialization.

8. **Busy Flag in Master RX**: The BF flag may not be reliable in master half-duplex receive mode.

9. **DMA Priority**: For continuous audio streaming, set DMA priority to HIGH and enable loop mode.

10. **Sampling Frequency Accuracy**: Actual sampling frequency depends on system clock. For CD-quality audio (44.1 kHz), consider using a dedicated audio PLL if available.

---

## References

- AT32F403A/407 Reference Manual
- AT32F403A/407 Datasheet
- Application Note AN0102 - I2S Audio Applications
- I2S Bus Specification (Philips)

