# USART (Universal Synchronous/Asynchronous Receiver/Transmitter) - AT32F403A/407

## Overview

The AT32F403A/407 microcontroller features up to **8 USART/UART controllers** providing flexible serial communication interfaces. The USART peripheral supports multiple communication modes including asynchronous, synchronous, single-wire half-duplex, IrDA, SmartCard, RS-485, and LIN protocols, making it suitable for a wide range of industrial and consumer applications.

## Key Features

- **Eight USART/UART Controllers**: USART1, USART2, USART3, UART4, UART5, USART6, UART7, UART8
- **Full-duplex asynchronous communication**
- **Synchronous mode** (USART1, USART2, USART3, USART6 only)
- **Single-wire half-duplex communication**
- **Hardware flow control** (RTS/CTS for USART1, USART2, USART3)
- **Multi-processor communication** with receiver mute mode
- **IrDA SIR encoder/decoder** (normal and low-power modes)
- **SmartCard mode** (ISO 7816-3 T=0 protocol)
- **LIN (Local Interconnect Network)** master/slave mode
- **DMA support** for TX and RX
- **Programmable baud rate generator**
- **Frame formats**: 8 or 9 data bits, 1, 0.5, 1.5, or 2 stop bits
- **Parity**: None, Even, or Odd

## USART Controllers Comparison

| Feature | USART1 | USART2 | USART3 | UART4 | UART5 | USART6 | UART7 | UART8 |
|---------|--------|--------|--------|-------|-------|--------|-------|-------|
| **Synchronous Mode** | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ | ✗ | ✗ |
| **Hardware Flow Control** | ✓ | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| **SmartCard Mode** | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ | ✗ | ✗ |
| **IrDA Mode** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **LIN Mode** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Half-Duplex** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **DMA Support** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **APB Bus** | APB2 | APB1 | APB1 | APB1 | APB1 | APB2 | APB2 | APB2 |

> **Note**: UART8 is only available on AT32F403ARx, AT32F403AVx, AT32F407Rx, and AT32F407Vx variants.

## Register Structure

```c
typedef struct
{
  union
  {
    __IO uint32_t sts;            /* Status register, offset: 0x00 */
    struct
    {
      __IO uint32_t perr     : 1; /* [0] Parity error flag */
      __IO uint32_t ferr     : 1; /* [1] Framing error flag */
      __IO uint32_t nerr     : 1; /* [2] Noise error flag */
      __IO uint32_t roerr    : 1; /* [3] Receiver overflow error flag */
      __IO uint32_t idlef    : 1; /* [4] IDLE flag */
      __IO uint32_t rdbf     : 1; /* [5] Receive data buffer full flag */
      __IO uint32_t tdc      : 1; /* [6] Transmit data complete flag */
      __IO uint32_t tdbe     : 1; /* [7] Transmit data buffer empty flag */
      __IO uint32_t bff      : 1; /* [8] Break frame flag */
      __IO uint32_t ctscf    : 1; /* [9] CTS change flag */
      __IO uint32_t reserved : 22;
    } sts_bit;
  };

  union
  {
    __IO uint32_t dt;             /* Data register, offset: 0x04 */
    struct
    {
      __IO uint32_t dt       : 9; /* [8:0] Data value */
      __IO uint32_t reserved : 23;
    } dt_bit;
  };

  union
  {
    __IO uint32_t baudr;          /* Baud rate register, offset: 0x08 */
    struct
    {
      __IO uint32_t div      : 16;/* [15:0] Baud rate divider */
      __IO uint32_t reserved : 16;
    } baudr_bit;
  };

  union
  {
    __IO uint32_t ctrl1;          /* Control register 1, offset: 0x0C */
    struct
    {
      __IO uint32_t sbf      : 1; /* [0] Send break frame */
      __IO uint32_t rm       : 1; /* [1] Receiver mute */
      __IO uint32_t ren      : 1; /* [2] Receiver enable */
      __IO uint32_t ten      : 1; /* [3] Transmitter enable */
      __IO uint32_t idleien  : 1; /* [4] IDLE interrupt enable */
      __IO uint32_t rdbfien  : 1; /* [5] RDBF interrupt enable */
      __IO uint32_t tdcien   : 1; /* [6] TDC interrupt enable */
      __IO uint32_t tdbeien  : 1; /* [7] TDBE interrupt enable */
      __IO uint32_t perrien  : 1; /* [8] Parity error interrupt enable */
      __IO uint32_t psel     : 1; /* [9] Parity selection (0=even, 1=odd) */
      __IO uint32_t pen      : 1; /* [10] Parity enable */
      __IO uint32_t wum      : 1; /* [11] Wakeup method */
      __IO uint32_t dbn      : 1; /* [12] Data bit number (0=8, 1=9) */
      __IO uint32_t uen      : 1; /* [13] USART enable */
      __IO uint32_t reserved : 18;
    } ctrl1_bit;
  };

  union
  {
    __IO uint32_t ctrl2;          /* Control register 2, offset: 0x10 */
    struct
    {
      __IO uint32_t id       : 4; /* [3:0] USART ID for multiprocessor */
      __IO uint32_t reserved1: 1; /* [4] */
      __IO uint32_t bfbn     : 1; /* [5] Break frame bit number */
      __IO uint32_t bfien    : 1; /* [6] Break frame interrupt enable */
      __IO uint32_t reserved2: 1; /* [7] */
      __IO uint32_t lbcp     : 1; /* [8] Last bit clock pulse */
      __IO uint32_t clkpha   : 1; /* [9] Clock phase */
      __IO uint32_t clkpol   : 1; /* [10] Clock polarity */
      __IO uint32_t clken    : 1; /* [11] Clock enable */
      __IO uint32_t stopbn   : 2; /* [13:12] Stop bit number */
      __IO uint32_t linen    : 1; /* [14] LIN mode enable */
      __IO uint32_t reserved3: 17;
    } ctrl2_bit;
  };

  union
  {
    __IO uint32_t ctrl3;          /* Control register 3, offset: 0x14 */
    struct
    {
      __IO uint32_t errien   : 1; /* [0] Error interrupt enable */
      __IO uint32_t irdaen   : 1; /* [1] IrDA mode enable */
      __IO uint32_t irdalp   : 1; /* [2] IrDA low power */
      __IO uint32_t slben    : 1; /* [3] Single line half-duplex enable */
      __IO uint32_t scnacken : 1; /* [4] SmartCard NACK enable */
      __IO uint32_t scmen    : 1; /* [5] SmartCard mode enable */
      __IO uint32_t dmaren   : 1; /* [6] DMA receiver enable */
      __IO uint32_t dmaten   : 1; /* [7] DMA transmitter enable */
      __IO uint32_t rtsen    : 1; /* [8] RTS enable */
      __IO uint32_t ctsen    : 1; /* [9] CTS enable */
      __IO uint32_t ctscfien : 1; /* [10] CTS change flag interrupt enable */
      __IO uint32_t reserved : 21;
    } ctrl3_bit;
  };

  union
  {
    __IO uint32_t gdiv;           /* Guard time and division, offset: 0x18 */
    struct
    {
      __IO uint32_t isdiv    : 8; /* [7:0] IrDA/SmartCard division */
      __IO uint32_t scgt     : 8; /* [15:8] SmartCard guard time */
      __IO uint32_t reserved : 16;
    } gdiv_bit;
  };
} usart_type;
```

## Base Addresses

| USART | Base Address | APB Bus |
|-------|--------------|---------|
| USART1 | 0x40013800 | APB2 |
| USART2 | 0x40004400 | APB1 |
| USART3 | 0x40004800 | APB1 |
| UART4 | 0x40004C00 | APB1 |
| UART5 | 0x40005000 | APB1 |
| USART6 | 0x40015400 | APB2 |
| UART7 | 0x40015800 | APB2 |
| UART8 | 0x40015C00 | APB2 |

## Configuration Types

### Parity Selection

```c
typedef enum
{
  USART_PARITY_NONE = 0x00,  /* No parity */
  USART_PARITY_EVEN = 0x01,  /* Even parity */
  USART_PARITY_ODD  = 0x02   /* Odd parity */
} usart_parity_selection_type;
```

### Data Bit Number

```c
typedef enum
{
  USART_DATA_8BITS = 0x00,   /* 8 data bits */
  USART_DATA_9BITS = 0x01    /* 9 data bits */
} usart_data_bit_num_type;
```

### Stop Bit Number

```c
typedef enum
{
  USART_STOP_1_BIT   = 0x00, /* 1 stop bit */
  USART_STOP_0_5_BIT = 0x01, /* 0.5 stop bit */
  USART_STOP_2_BIT   = 0x02, /* 2 stop bits */
  USART_STOP_1_5_BIT = 0x03  /* 1.5 stop bits */
} usart_stop_bit_num_type;
```

### Hardware Flow Control

```c
typedef enum
{
  USART_HARDWARE_FLOW_NONE    = 0x00, /* No flow control */
  USART_HARDWARE_FLOW_RTS     = 0x01, /* RTS only */
  USART_HARDWARE_FLOW_CTS     = 0x02, /* CTS only */
  USART_HARDWARE_FLOW_RTS_CTS = 0x03  /* Both RTS and CTS */
} usart_hardware_flow_control_type;
```

### Clock Configuration (Synchronous Mode)

```c
typedef enum
{
  USART_CLOCK_POLARITY_LOW  = 0x00,  /* Clock idle low */
  USART_CLOCK_POLARITY_HIGH = 0x01   /* Clock idle high */
} usart_clock_polarity_type;

typedef enum
{
  USART_CLOCK_PHASE_1EDGE = 0x00,    /* First clock edge */
  USART_CLOCK_PHASE_2EDGE = 0x01     /* Second clock edge */
} usart_clock_phase_type;

typedef enum
{
  USART_CLOCK_LAST_BIT_NONE   = 0x00, /* No last bit clock */
  USART_CLOCK_LAST_BIT_OUTPUT = 0x01  /* Last bit clock output */
} usart_lbcp_type;
```

### Wakeup Mode (Multi-processor)

```c
typedef enum
{
  USART_WAKEUP_BY_IDLE_FRAME   = 0x00, /* Wakeup by idle frame */
  USART_WAKEUP_BY_MATCHING_ID  = 0x01  /* Wakeup by address match */
} usart_wakeup_mode_type;
```

### Break Frame Bit Number (LIN Mode)

```c
typedef enum
{
  USART_BREAK_10BITS = 0x00,  /* 10-bit break detection */
  USART_BREAK_11BITS = 0x01   /* 11-bit break detection */
} usart_break_bit_num_type;
```

## Status Flags

| Flag | Description |
|------|-------------|
| `USART_PERR_FLAG` | Parity error |
| `USART_FERR_FLAG` | Framing error |
| `USART_NERR_FLAG` | Noise error |
| `USART_ROERR_FLAG` | Receiver overflow error |
| `USART_IDLEF_FLAG` | IDLE line detected |
| `USART_RDBF_FLAG` | Receive data buffer full |
| `USART_TDC_FLAG` | Transmit data complete |
| `USART_TDBE_FLAG` | Transmit data buffer empty |
| `USART_BFF_FLAG` | Break frame flag |
| `USART_CTSCF_FLAG` | CTS change flag |

## Interrupts

| Interrupt | Description |
|-----------|-------------|
| `USART_IDLE_INT` | IDLE line detected interrupt |
| `USART_RDBF_INT` | Receive data buffer full interrupt |
| `USART_TDC_INT` | Transmit data complete interrupt |
| `USART_TDBE_INT` | Transmit data buffer empty interrupt |
| `USART_PERR_INT` | Parity error interrupt |
| `USART_BF_INT` | Break frame interrupt |
| `USART_ERR_INT` | Error interrupt (framing, noise, overrun) |
| `USART_CTSCF_INT` | CTS change flag interrupt |

## Hardware Interface

### Default Pin Mapping

| USART | TX | RX | CK | CTS | RTS |
|-------|----|----|-----|-----|-----|
| USART1 | PA9 | PA10 | PA8 | PA11 | PA12 |
| USART2 | PA2 | PA3 | PA4 | PA0 | PA1 |
| USART3 | PB10 | PB11 | PB12 | PB13 | PB14 |
| UART4 | PC10 | PC11 | - | - | - |
| UART5 | PC12 | PD2 | - | - | - |
| USART6 | PC6 | PC7 | PC8 | - | - |
| UART7 | PE8 | PE7 | - | - | - |
| UART8 | PE1 | PE0 | - | - | - |

### GPIO Configuration Example

```c
void usart_gpio_config(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable GPIO and USART clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  
  gpio_default_para_init(&gpio_init_struct);
  
  /* Configure TX pin (PA2) - Alternate function push-pull */
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_2;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure RX pin (PA3) - Input with pull-up */
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_3;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);
}
```

## API Functions

### Initialization and Configuration

```c
/* Reset USART to default state */
void usart_reset(usart_type* usart_x);

/* Initialize USART with baud rate, data bits, stop bits */
void usart_init(usart_type* usart_x, uint32_t baud_rate, 
                usart_data_bit_num_type data_bit, 
                usart_stop_bit_num_type stop_bit);

/* Configure parity */
void usart_parity_selection_config(usart_type* usart_x, 
                                   usart_parity_selection_type parity);

/* Enable/disable USART */
void usart_enable(usart_type* usart_x, confirm_state new_state);

/* Enable/disable transmitter */
void usart_transmitter_enable(usart_type* usart_x, confirm_state new_state);

/* Enable/disable receiver */
void usart_receiver_enable(usart_type* usart_x, confirm_state new_state);
```

### Synchronous Mode

```c
/* Configure clock parameters (polarity, phase, last bit) */
void usart_clock_config(usart_type* usart_x, 
                        usart_clock_polarity_type clk_pol,
                        usart_clock_phase_type clk_pha, 
                        usart_lbcp_type clk_lb);

/* Enable/disable clock output */
void usart_clock_enable(usart_type* usart_x, confirm_state new_state);
```

### Hardware Flow Control

```c
/* Set hardware flow control mode */
void usart_hardware_flow_control_set(usart_type* usart_x,
                                     usart_hardware_flow_control_type flow_state);
```

### Multi-processor Communication

```c
/* Set wakeup ID for address matching */
void usart_wakeup_id_set(usart_type* usart_x, uint8_t usart_id);

/* Set wakeup mode (idle frame or address match) */
void usart_wakeup_mode_set(usart_type* usart_x, usart_wakeup_mode_type wakeup_mode);

/* Enable/disable receiver mute */
void usart_receiver_mute_enable(usart_type* usart_x, confirm_state new_state);
```

### Half-Duplex Mode

```c
/* Enable/disable single-line half-duplex mode */
void usart_single_line_halfduplex_select(usart_type* usart_x, confirm_state new_state);
```

### IrDA Mode

```c
/* Enable/disable IrDA mode */
void usart_irda_mode_enable(usart_type* usart_x, confirm_state new_state);

/* Enable/disable IrDA low power mode */
void usart_irda_low_power_enable(usart_type* usart_x, confirm_state new_state);

/* Set IrDA/SmartCard prescaler division */
void usart_irda_smartcard_division_set(usart_type* usart_x, uint8_t div_val);
```

### SmartCard Mode

```c
/* Enable/disable SmartCard mode */
void usart_smartcard_mode_enable(usart_type* usart_x, confirm_state new_state);

/* Enable/disable SmartCard NACK */
void usart_smartcard_nack_set(usart_type* usart_x, confirm_state new_state);

/* Set SmartCard guard time */
void usart_smartcard_guard_time_set(usart_type* usart_x, uint8_t guard_time_val);
```

### LIN Mode

```c
/* Enable/disable LIN mode */
void usart_lin_mode_enable(usart_type* usart_x, confirm_state new_state);

/* Set break detection length (10 or 11 bits) */
void usart_break_bit_num_set(usart_type* usart_x, usart_break_bit_num_type break_bit);

/* Send break character */
void usart_break_send(usart_type* usart_x);
```

### Data Transfer

```c
/* Transmit data */
void usart_data_transmit(usart_type* usart_x, uint16_t data);

/* Receive data */
uint16_t usart_data_receive(usart_type* usart_x);
```

### DMA Support

```c
/* Enable/disable DMA transmitter */
void usart_dma_transmitter_enable(usart_type* usart_x, confirm_state new_state);

/* Enable/disable DMA receiver */
void usart_dma_receiver_enable(usart_type* usart_x, confirm_state new_state);
```

### Interrupts and Flags

```c
/* Enable/disable interrupt */
void usart_interrupt_enable(usart_type* usart_x, uint32_t usart_int, 
                            confirm_state new_state);

/* Get flag status */
flag_status usart_flag_get(usart_type* usart_x, uint32_t flag);

/* Get interrupt flag status */
flag_status usart_interrupt_flag_get(usart_type* usart_x, uint32_t flag);

/* Clear flag */
void usart_flag_clear(usart_type* usart_x, uint32_t flag);
```

---

## Usage Examples

### Example 1: Basic Polling Mode

```c
#define BUFFER_SIZE  64

uint8_t tx_buffer[] = "Hello USART!";
uint8_t rx_buffer[BUFFER_SIZE];

void usart_polling_example(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  
  /* Configure GPIO */
  gpio_default_para_init(&gpio_init_struct);
  
  /* TX pin (PA2) */
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_2;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* RX pin (PA3) */
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_3;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure USART2: 115200 baud, 8 data bits, 1 stop bit, no parity */
  usart_init(USART2, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_parity_selection_config(USART2, USART_PARITY_NONE);
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  usart_enable(USART2, TRUE);
  
  /* Transmit data */
  uint8_t tx_index = 0;
  while(tx_buffer[tx_index] != '\0')
  {
    /* Wait for transmit buffer empty */
    while(usart_flag_get(USART2, USART_TDBE_FLAG) == RESET);
    usart_data_transmit(USART2, tx_buffer[tx_index++]);
  }
  
  /* Wait for transmission complete */
  while(usart_flag_get(USART2, USART_TDC_FLAG) == RESET);
  
  /* Receive data */
  uint8_t rx_index = 0;
  while(rx_index < BUFFER_SIZE)
  {
    /* Wait for receive buffer full */
    while(usart_flag_get(USART2, USART_RDBF_FLAG) == RESET);
    rx_buffer[rx_index++] = usart_data_receive(USART2);
  }
}
```

### Example 2: Interrupt-Driven Communication

```c
#define BUFFER_SIZE  64

volatile uint8_t tx_buffer[] = "Interrupt Mode!";
volatile uint8_t rx_buffer[BUFFER_SIZE];
volatile uint8_t tx_index = 0;
volatile uint8_t rx_index = 0;

void usart_interrupt_example(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  
  /* Configure GPIO (same as polling example) */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_2;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_3;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure NVIC */
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  nvic_irq_enable(USART2_IRQn, 0, 0);
  
  /* Configure USART */
  usart_init(USART2, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  
  /* Enable interrupts */
  usart_interrupt_enable(USART2, USART_RDBF_INT, TRUE);
  usart_interrupt_enable(USART2, USART_TDBE_INT, TRUE);
  
  usart_enable(USART2, TRUE);
}

/* USART2 Interrupt Handler */
void USART2_IRQHandler(void)
{
  /* Transmit interrupt */
  if(usart_interrupt_flag_get(USART2, USART_TDBE_FLAG) != RESET)
  {
    if(tx_buffer[tx_index] != '\0')
    {
      usart_data_transmit(USART2, tx_buffer[tx_index++]);
    }
    else
    {
      usart_interrupt_enable(USART2, USART_TDBE_INT, FALSE);
    }
  }
  
  /* Receive interrupt */
  if(usart_interrupt_flag_get(USART2, USART_RDBF_FLAG) != RESET)
  {
    if(rx_index < BUFFER_SIZE)
    {
      rx_buffer[rx_index++] = usart_data_receive(USART2);
    }
  }
}
```

### Example 3: DMA Transfer

```c
#define TX_BUFFER_SIZE  60
#define RX_BUFFER_SIZE  60

uint8_t tx_buffer[] = "USART transfer using DMA for efficient data handling!";
uint8_t rx_buffer[RX_BUFFER_SIZE];

void usart_dma_example(void)
{
  gpio_init_type gpio_init_struct;
  dma_init_type dma_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
  
  /* Configure GPIO */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_2;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_3;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure USART */
  usart_init(USART2, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  usart_dma_transmitter_enable(USART2, TRUE);
  usart_dma_receiver_enable(USART2, TRUE);
  usart_enable(USART2, TRUE);
  
  /* Configure DMA for TX (DMA1 Channel1) */
  dma_reset(DMA1_CHANNEL1);
  dma_default_para_init(&dma_init_struct);
  dma_init_struct.buffer_size = TX_BUFFER_SIZE;
  dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
  dma_init_struct.memory_base_addr = (uint32_t)tx_buffer;
  dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_BYTE;
  dma_init_struct.memory_inc_enable = TRUE;
  dma_init_struct.peripheral_base_addr = (uint32_t)&USART2->dt;
  dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE;
  dma_init_struct.peripheral_inc_enable = FALSE;
  dma_init_struct.priority = DMA_PRIORITY_MEDIUM;
  dma_init_struct.loop_mode_enable = FALSE;
  dma_init(DMA1_CHANNEL1, &dma_init_struct);
  
  /* Configure flexible DMA for USART2 TX */
  dma_flexible_config(DMA1, FLEX_CHANNEL1, DMA_FLEXIBLE_UART2_TX);
  
  /* Configure DMA for RX (DMA1 Channel2) */
  dma_reset(DMA1_CHANNEL2);
  dma_init_struct.buffer_size = RX_BUFFER_SIZE;
  dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
  dma_init_struct.memory_base_addr = (uint32_t)rx_buffer;
  dma_init(DMA1_CHANNEL2, &dma_init_struct);
  
  /* Configure flexible DMA for USART2 RX */
  dma_flexible_config(DMA1, FLEX_CHANNEL2, DMA_FLEXIBLE_UART2_RX);
  
  /* Enable DMA channels */
  dma_channel_enable(DMA1_CHANNEL2, TRUE); /* RX first */
  dma_channel_enable(DMA1_CHANNEL1, TRUE); /* Then TX */
  
  /* Wait for DMA transfer complete */
  while(dma_flag_get(DMA1_FDT1_FLAG) == RESET);
  while(dma_flag_get(DMA1_FDT2_FLAG) == RESET);
}
```

### Example 4: Single-Wire Half-Duplex Mode

```c
void usart_halfduplex_example(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  
  /* Configure TX pin as Open-Drain for half-duplex */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_OPEN_DRAIN;  /* Open-drain! */
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_2;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure USART */
  usart_init(USART2, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  
  /* Enable single-wire half-duplex mode */
  usart_single_line_halfduplex_select(USART2, TRUE);
  
  usart_enable(USART2, TRUE);
  
  /* Now both TX and RX happen on the same pin (PA2) */
}
```

### Example 5: Hardware Flow Control (RTS/CTS)

```c
void usart_flow_control_example(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOD_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
  
  /* Configure TX (PD5) and RTS (PD4) as output */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_4 | GPIO_PINS_5;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOD, &gpio_init_struct);
  
  /* Configure RX (PD6) and CTS (PD3) as input */
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_3 | GPIO_PINS_6;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOD, &gpio_init_struct);
  
  /* Remap USART2 to GPIOD */
  gpio_pin_remap_config(USART2_GMUX_0001, TRUE);
  
  /* Configure USART */
  usart_init(USART2, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  
  /* Enable hardware flow control */
  usart_hardware_flow_control_set(USART2, USART_HARDWARE_FLOW_RTS_CTS);
  
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  usart_enable(USART2, TRUE);
}
```

### Example 6: IrDA Mode

```c
void usart_irda_example(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  
  /* Configure GPIO */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_2;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_3;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure USART */
  usart_init(USART2, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  
  /* Configure IrDA */
  usart_irda_smartcard_division_set(USART2, 0x01);  /* Prescaler */
  usart_irda_mode_enable(USART2, TRUE);
  /* usart_irda_low_power_enable(USART2, TRUE); // For low-power mode */
  
  usart_enable(USART2, TRUE);
  
  /* Transmit IrDA data */
  while(usart_flag_get(USART2, USART_TDBE_FLAG) == RESET);
  usart_data_transmit(USART2, 0x55);
}
```

### Example 7: SmartCard Mode (ISO 7816-3)

```c
#define SC_USART          USART3
#define SC_USART_DIV_VAL  20       /* PCLK/(2*DIV_VAL) = 1-5 MHz */
#define SC_F_DIV_D        372      /* Baud = CLK_freq / 372 */

void usart_smartcard_example(void)
{
  gpio_init_type gpio_init_struct;
  crm_clocks_freq_type crm_clocks;
  uint32_t sc_clock_freq, sc_baud_rate;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART3_PERIPH_CLOCK, TRUE);
  
  /* Configure CK pin (PB12) - SmartCard clock output */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_12;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* Configure TX pin (PB10) - Open-drain for bidirectional I/O */
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_OPEN_DRAIN;
  gpio_init_struct.gpio_pins = GPIO_PINS_10;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* Calculate baud rate: CLK_freq = PCLK / (2 * DIV_VAL), Baud = CLK / 372 */
  crm_clocks_freq_get(&crm_clocks);
  sc_clock_freq = crm_clocks.apb1_freq / (2 * SC_USART_DIV_VAL);
  sc_baud_rate = sc_clock_freq / SC_F_DIV_D;
  
  /* Configure prescaler and guard time */
  usart_irda_smartcard_division_set(SC_USART, SC_USART_DIV_VAL);
  usart_smartcard_guard_time_set(SC_USART, 0x02);  /* 2-bit guard time */
  
  /* Enable clock output */
  usart_clock_enable(SC_USART, TRUE);
  
  /* Configure USART: 9 data bits, 1.5 stop bits, even parity */
  usart_init(SC_USART, sc_baud_rate, USART_DATA_9BITS, USART_STOP_1_5_BIT);
  usart_parity_selection_config(SC_USART, USART_PARITY_EVEN);
  usart_transmitter_enable(SC_USART, TRUE);
  usart_receiver_enable(SC_USART, TRUE);
  
  /* Enable parity error interrupt for NACK handling */
  usart_interrupt_enable(SC_USART, USART_PERR_INT, TRUE);
  
  usart_enable(SC_USART, TRUE);
  
  /* Enable SmartCard NACK and mode */
  usart_smartcard_nack_set(SC_USART, TRUE);
  usart_smartcard_mode_enable(SC_USART, TRUE);
}
```

### Example 8: Synchronous Mode (USART Master with SPI Slave)

```c
void usart_synchronous_example(void)
{
  gpio_init_type gpio_init_struct;
  spi_init_type spi_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_SPI2_PERIPH_CLOCK, TRUE);
  
  /* Configure USART2 TX (PA2), RX (PA3), CK (PA4) */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_2 | GPIO_PINS_4;  /* TX + CK */
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_3;  /* RX */
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure SPI2 MOSI (PB15), MISO (PB14), SCK (PB13) as slave */
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_13 | GPIO_PINS_15;  /* SCK + MOSI */
  gpio_init(GPIOB, &gpio_init_struct);
  
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_14;  /* MISO */
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* Configure USART2 in synchronous master mode */
  usart_init(USART2, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_clock_config(USART2, USART_CLOCK_POLARITY_HIGH, 
                     USART_CLOCK_PHASE_2EDGE, USART_CLOCK_LAST_BIT_OUTPUT);
  usart_clock_enable(USART2, TRUE);
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  usart_enable(USART2, TRUE);
  
  /* Configure SPI2 as slave */
  spi_default_para_init(&spi_init_struct);
  spi_init_struct.transmission_mode = SPI_TRANSMIT_FULL_DUPLEX;
  spi_init_struct.master_slave_mode = SPI_MODE_SLAVE;
  spi_init_struct.first_bit_transmission = SPI_FIRST_BIT_LSB;
  spi_init_struct.frame_bit_num = SPI_FRAME_8BIT;
  spi_init_struct.clock_polarity = SPI_CLOCK_POLARITY_HIGH;
  spi_init_struct.clock_phase = SPI_CLOCK_PHASE_2EDGE;
  spi_init_struct.cs_mode_selection = SPI_CS_SOFTWARE_MODE;
  spi_init(SPI2, &spi_init_struct);
  spi_enable(SPI2, TRUE);
}
```

### Example 9: Multi-processor Communication with Receiver Mute

```c
#define MY_ADDRESS  0x01  /* This device's address */

void usart_multiprocessor_example(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART3_PERIPH_CLOCK, TRUE);
  
  /* Configure GPIO */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_11;  /* RX */
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* Configure NVIC */
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  nvic_irq_enable(USART3_IRQn, 0, 0);
  
  /* Configure USART */
  usart_init(USART3, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_receiver_enable(USART3, TRUE);
  usart_interrupt_enable(USART3, USART_RDBF_INT, TRUE);
  
  /* Configure multi-processor mode */
  usart_wakeup_id_set(USART3, MY_ADDRESS);  /* Set device address */
  usart_wakeup_mode_set(USART3, USART_WAKEUP_BY_MATCHING_ID);
  usart_receiver_mute_enable(USART3, TRUE);  /* Enter mute mode */
  
  usart_enable(USART3, TRUE);
  
  /* USART3 will only wake up when it receives MY_ADDRESS (0x81 = 0x01 | 0x80) */
}
```

### Example 10: RS-485 Communication with Direction Control

```c
#define RS485_DE_PIN  GPIO_PINS_1  /* PA1 as direction enable */

void rs485_send_data(uint8_t* buf, uint16_t len)
{
  /* Set DE high for transmit mode */
  gpio_bits_set(GPIOA, RS485_DE_PIN);
  
  while(len--)
  {
    while(usart_flag_get(USART2, USART_TDBE_FLAG) == RESET);
    usart_data_transmit(USART2, *buf++);
  }
  
  /* Wait for transmission complete */
  while(usart_flag_get(USART2, USART_TDC_FLAG) == RESET);
  
  /* Set DE low for receive mode */
  gpio_bits_reset(GPIOA, RS485_DE_PIN);
}

void usart_rs485_example(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  
  /* Configure TX (PA2), RX (PA3), DE (PA1) */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_2;  /* TX */
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_3;  /* RX */
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Direction Enable pin as GPIO output */
  gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pins = RS485_DE_PIN;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Start in receive mode (DE low) */
  gpio_bits_reset(GPIOA, RS485_DE_PIN);
  
  /* Configure USART */
  usart_init(USART2, 9600, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  usart_enable(USART2, TRUE);
}
```

### Example 11: IDLE Line Detection for Variable-Length Reception

```c
#define BUFFER_SIZE  256

volatile uint8_t rx_buffer[BUFFER_SIZE];
volatile uint16_t rx_index = 0;
volatile uint8_t frame_complete = 0;

void usart_idle_detection_example(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART2_PERIPH_CLOCK, TRUE);
  
  /* Configure GPIO */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_2;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_3;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure NVIC */
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  nvic_irq_enable(USART2_IRQn, 0, 0);
  
  /* Configure USART */
  usart_init(USART2, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  
  /* Enable IDLE interrupt for frame detection */
  usart_interrupt_enable(USART2, USART_IDLE_INT, TRUE);
  usart_interrupt_enable(USART2, USART_RDBF_INT, TRUE);
  
  usart_enable(USART2, TRUE);
}

void USART2_IRQHandler(void)
{
  /* IDLE flag - frame complete */
  if(usart_interrupt_flag_get(USART2, USART_IDLEF_FLAG) != RESET)
  {
    /* Clear IDLE flag by reading STS then DT */
    usart_flag_get(USART2, USART_IDLEF_FLAG);
    usart_data_receive(USART2);
    
    frame_complete = 1;  /* Signal that a complete frame was received */
  }
  
  /* Receive data */
  if(usart_interrupt_flag_get(USART2, USART_RDBF_FLAG) != RESET)
  {
    if(rx_index < BUFFER_SIZE)
    {
      rx_buffer[rx_index++] = usart_data_receive(USART2);
    }
  }
}
```

### Example 12: Printf Retargeting

```c
/* Retarget fputc for printf support */
int fputc(int ch, FILE *f)
{
  while(usart_flag_get(USART1, USART_TDBE_FLAG) == RESET);
  usart_data_transmit(USART1, (uint8_t)ch);
  return ch;
}

void usart_printf_example(void)
{
  /* Initialize USART1 for printf (using uart_print_init from BSP) */
  uart_print_init(115200);
  
  /* Now printf outputs to USART1 */
  printf("USART printf example: System started!\r\n");
  
  uint32_t counter = 0;
  while(1)
  {
    printf("Counter value: %u\r\n", counter++);
    delay_sec(1);
  }
}
```

---

## Baud Rate Calculation

The baud rate is calculated as:

```
Baud Rate = fPCLK / DIV
```

Where:
- **fPCLK** = APB1 or APB2 clock frequency (depending on USART)
- **DIV** = Value written to BAUDR register

The driver calculates this automatically:

```c
void usart_init(usart_type* usart_x, uint32_t baud_rate, ...)
{
  crm_clocks_freq_type clocks_freq;
  uint32_t apb_clock, temp_val;
  
  crm_clocks_freq_get(&clocks_freq);
  
  /* Select APB clock based on USART */
  if((usart_x == USART1) || (usart_x == USART6) || (usart_x == UART7) || ...)
    apb_clock = clocks_freq.apb2_freq;
  else
    apb_clock = clocks_freq.apb1_freq;
  
  /* Calculate divider with rounding */
  temp_val = (apb_clock * 10 / baud_rate);
  if((temp_val % 10) < 5)
    temp_val = temp_val / 10;
  else
    temp_val = (temp_val / 10) + 1;
  
  usart_x->baudr_bit.div = temp_val;
}
```

## Flag Clearing Notes

Different flags require different clearing procedures:

| Flag | Clearing Method |
|------|-----------------|
| `USART_PERR_FLAG`, `USART_FERR_FLAG`, `USART_NERR_FLAG`, `USART_ROERR_FLAG`, `USART_IDLEF_FLAG` | Read STS, then read DT |
| `USART_RDBF_FLAG` | Read DT or read STS then DT |
| `USART_TDC_FLAG` | Read STS, then write DT |
| `USART_TDBE_FLAG` | Write to DT only |
| `USART_BFF_FLAG`, `USART_CTSCF_FLAG` | Write 0 to flag bit in STS |

## Common Issues and Solutions

### Issue: Data Corruption at High Baud Rates

**Solution**: Ensure APB clock is high enough to support the desired baud rate with acceptable error. Use DMA for high-speed transfers.

### Issue: Overrun Errors

**Solution**: 
- Enable DMA reception for continuous data
- Use IDLE interrupt for frame detection
- Increase interrupt priority

### Issue: Half-Duplex Not Working

**Solution**: Configure TX pin as **open-drain** output, not push-pull.

### Issue: SmartCard Communication Fails

**Solution**:
- Use 9 data bits, 1.5 stop bits, even parity
- Configure clock output (1-5 MHz for ISO 7816-3)
- Enable NACK for error handling
- Set appropriate guard time

## Related Peripherals

- **DMA**: For efficient data transfers
- **GPIO**: For pin configuration and RS-485 direction control
- **SPI**: For synchronous mode communication with SPI slaves
- **CRM**: For clock configuration and peripheral enable
- **NVIC**: For interrupt management

## References

- AT32F403A/407 Reference Manual - USART Chapter
- AT32F403A/407 Datasheet - Electrical Characteristics
- ISO 7816-3 - SmartCard T=0 Protocol
- IrDA SIR Physical Layer Specification

