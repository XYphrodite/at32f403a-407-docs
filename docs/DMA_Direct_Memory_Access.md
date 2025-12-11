# DMA - Direct Memory Access

## Overview

The AT32F403A/407 features **two DMA controllers** with **7 channels each**, providing high-speed data transfer between memory and peripherals without CPU intervention. A unique **Flexible Channel Mapping** feature allows any peripheral to be mapped to any DMA channel.

### Key Features

| Feature | Specification |
|---------|---------------|
| **DMA Controllers** | 2 (DMA1, DMA2) |
| **Channels per Controller** | 7 (14 total) |
| **Transfer Directions** | Memory↔Memory, Memory↔Peripheral |
| **Data Widths** | 8-bit, 16-bit, 32-bit |
| **Max Transfer Size** | 65535 data units per transfer |
| **Priority Levels** | Low, Medium, High, Very High |
| **Address Increment** | Source and/or destination |
| **Circular Mode** | Yes (auto-reload) |
| **Flexible Mapping** | Any peripheral → Any channel |
| **Interrupts** | Full transfer, Half transfer, Error |

---

## Block Diagram

```
                                    ┌─────────────────────────────────────┐
                                    │           DMA Controller            │
                                    │                                     │
    ┌──────────┐                    │   ┌─────────────────────────────┐   │
    │  Flash   │◄───────────────────┼───┤      Arbiter (Priority)     │   │
    │  Memory  │                    │   └─────────────┬───────────────┘   │
    └──────────┘                    │                 │                   │
                                    │   ┌─────────────┼───────────────┐   │
    ┌──────────┐                    │   │             │               │   │
    │   SRAM   │◄───────────────────┼───┤  Channel 1  │  Channel 2    │   │
    └──────────┘                    │   │  Channel 3  │  Channel 4    │   │
                                    │   │  Channel 5  │  Channel 6    │   │
    ┌──────────┐                    │   │  Channel 7  │               │   │
    │Peripherals│◄──────────────────┼───┤                             │   │
    │ADC,UART, │                    │   └─────────────────────────────┘   │
    │SPI,I2C...│                    │                 ▲                   │
    └──────────┘                    │                 │                   │
                                    │   ┌─────────────┴───────────────┐   │
                                    │   │   Flexible Request Mapper   │   │
                                    │   │  (Any Peripheral→Any Ch)    │   │
                                    │   └─────────────────────────────┘   │
                                    └─────────────────────────────────────┘
```

---

## Register Map

### DMA Controller Registers

| Register | Offset | Description |
|----------|--------|-------------|
| **STS** | 0x00 | Interrupt status register |
| **CLR** | 0x04 | Interrupt flag clear register |
| **SRC_SEL0** | 0xA0 | Flexible channel 1-4 source selection |
| **SRC_SEL1** | 0xA4 | Flexible channel 5-7 source + enable |

### Channel Registers (per channel)

| Register | Offset | Description |
|----------|--------|-------------|
| **CTRL** | 0x08 + 20×(n-1) | Channel control register |
| **DTCNT** | 0x0C + 20×(n-1) | Data transfer count |
| **PADDR** | 0x10 + 20×(n-1) | Peripheral address |
| **MADDR** | 0x14 + 20×(n-1) | Memory address |

### CTRL Register Bit Fields

| Bit | Field | Description |
|-----|-------|-------------|
| 0 | `chen` | Channel enable |
| 1 | `fdtien` | Full data transfer interrupt enable |
| 2 | `hdtien` | Half data transfer interrupt enable |
| 3 | `dterrien` | Data transfer error interrupt enable |
| 4 | `dtd` | Data transfer direction |
| 5 | `lm` | Loop mode (circular) enable |
| 6 | `pincm` | Peripheral address increment mode |
| 7 | `mincm` | Memory address increment mode |
| 9:8 | `pwidth` | Peripheral data width |
| 11:10 | `mwidth` | Memory data width |
| 13:12 | `chpl` | Channel priority level |
| 14 | `m2m` | Memory-to-memory mode |

---

## Transfer Directions

```c
typedef enum
{
  DMA_DIR_PERIPHERAL_TO_MEMORY = 0x0000,  // Peripheral → Memory (RX)
  DMA_DIR_MEMORY_TO_PERIPHERAL = 0x0010,  // Memory → Peripheral (TX)
  DMA_DIR_MEMORY_TO_MEMORY     = 0x4000   // Memory → Memory
} dma_dir_type;
```

### Direction Usage

| Direction | Source | Destination | Use Case |
|-----------|--------|-------------|----------|
| `PERIPHERAL_TO_MEMORY` | Peripheral register | Memory buffer | UART RX, ADC read |
| `MEMORY_TO_PERIPHERAL` | Memory buffer | Peripheral register | UART TX, DAC write |
| `MEMORY_TO_MEMORY` | Memory (PADDR) | Memory (MADDR) | Data copy, buffer init |

> **Note**: In Memory-to-Memory mode, `peripheral_base_addr` is the **source** and `memory_base_addr` is the **destination**.

---

## Data Widths

### Peripheral Data Width

```c
typedef enum
{
  DMA_PERIPHERAL_DATA_WIDTH_BYTE     = 0x00,  // 8-bit
  DMA_PERIPHERAL_DATA_WIDTH_HALFWORD = 0x01,  // 16-bit
  DMA_PERIPHERAL_DATA_WIDTH_WORD     = 0x02   // 32-bit
} dma_peripheral_data_size_type;
```

### Memory Data Width

```c
typedef enum
{
  DMA_MEMORY_DATA_WIDTH_BYTE     = 0x00,  // 8-bit
  DMA_MEMORY_DATA_WIDTH_HALFWORD = 0x01,  // 16-bit
  DMA_MEMORY_DATA_WIDTH_WORD     = 0x02   // 32-bit
} dma_memory_data_size_type;
```

### Width Matching

| Peripheral Width | Memory Width | Behavior |
|------------------|--------------|----------|
| BYTE | BYTE | 1:1 transfer |
| HALFWORD | HALFWORD | 1:1 transfer |
| WORD | WORD | 1:1 transfer |
| BYTE | WORD | Pack 4 bytes into 1 word |
| WORD | BYTE | Unpack 1 word into 4 bytes |

---

## Priority Levels

```c
typedef enum
{
  DMA_PRIORITY_LOW       = 0x00,  // Lowest priority
  DMA_PRIORITY_MEDIUM    = 0x01,  // Medium priority
  DMA_PRIORITY_HIGH      = 0x02,  // High priority
  DMA_PRIORITY_VERY_HIGH = 0x03   // Highest priority
} dma_priority_level_type;
```

### Arbitration Rules

1. **Software Priority**: Higher `chpl` value wins
2. **Hardware Priority**: Lower channel number wins (if same software priority)
3. **DMA1 vs DMA2**: Share the same bus matrix, arbitrated by system

---

## Flexible Channel Mapping

The AT32F403A/407 DMA supports **flexible peripheral-to-channel mapping**, allowing any peripheral DMA request to be routed to any channel.

### Flexible Channel IDs

```c
#define FLEX_CHANNEL1    0x01
#define FLEX_CHANNEL2    0x02
#define FLEX_CHANNEL3    0x03
#define FLEX_CHANNEL4    0x04
#define FLEX_CHANNEL5    0x05
#define FLEX_CHANNEL6    0x06
#define FLEX_CHANNEL7    0x07
```

### Flexible Request Types

#### ADC/DAC

| Peripheral | Request ID | Value |
|------------|------------|-------|
| ADC1 | `DMA_FLEXIBLE_ADC1` | 0x01 |
| ADC3 | `DMA_FLEXIBLE_ADC3` | 0x03 |
| DAC1 | `DMA_FLEXIBLE_DAC1` | 0x05 |
| DAC2 | `DMA_FLEXIBLE_DAC2` | 0x06 |

#### SPI/I2S

| Peripheral | Request ID | Value |
|------------|------------|-------|
| SPI1 RX | `DMA_FLEXIBLE_SPI1_RX` | 0x09 |
| SPI1 TX | `DMA_FLEXIBLE_SPI1_TX` | 0x0A |
| SPI2 RX | `DMA_FLEXIBLE_SPI2_RX` | 0x0B |
| SPI2 TX | `DMA_FLEXIBLE_SPI2_TX` | 0x0C |
| SPI3 RX | `DMA_FLEXIBLE_SPI3_RX` | 0x0D |
| SPI3 TX | `DMA_FLEXIBLE_SPI3_TX` | 0x0E |
| SPI4 RX | `DMA_FLEXIBLE_SPI4_RX` | 0x0F |
| SPI4 TX | `DMA_FLEXIBLE_SPI4_TX` | 0x10 |
| I2S2EXT RX | `DMA_FLEXIBLE_I2S2EXT_RX` | 0x11 |
| I2S2EXT TX | `DMA_FLEXIBLE_I2S2EXT_TX` | 0x12 |
| I2S3EXT RX | `DMA_FLEXIBLE_I2S3EXT_RX` | 0x13 |
| I2S3EXT TX | `DMA_FLEXIBLE_I2S3EXT_TX` | 0x14 |

#### UART

| Peripheral | Request ID | Value |
|------------|------------|-------|
| UART1 RX | `DMA_FLEXIBLE_UART1_RX` | 0x19 |
| UART1 TX | `DMA_FLEXIBLE_UART1_TX` | 0x1A |
| UART2 RX | `DMA_FLEXIBLE_UART2_RX` | 0x1B |
| UART2 TX | `DMA_FLEXIBLE_UART2_TX` | 0x1C |
| UART3 RX | `DMA_FLEXIBLE_UART3_RX` | 0x1D |
| UART3 TX | `DMA_FLEXIBLE_UART3_TX` | 0x1E |
| UART4 RX | `DMA_FLEXIBLE_UART4_RX` | 0x1F |
| UART4 TX | `DMA_FLEXIBLE_UART4_TX` | 0x20 |
| UART5 RX | `DMA_FLEXIBLE_UART5_RX` | 0x21 |
| UART5 TX | `DMA_FLEXIBLE_UART5_TX` | 0x22 |
| UART6 RX | `DMA_FLEXIBLE_UART6_RX` | 0x23 |
| UART6 TX | `DMA_FLEXIBLE_UART6_TX` | 0x24 |
| UART7 RX | `DMA_FLEXIBLE_UART7_RX` | 0x25 |
| UART7 TX | `DMA_FLEXIBLE_UART7_TX` | 0x26 |
| UART8 RX | `DMA_FLEXIBLE_UART8_RX` | 0x27 |
| UART8 TX | `DMA_FLEXIBLE_UART8_TX` | 0x28 |

#### I2C

| Peripheral | Request ID | Value |
|------------|------------|-------|
| I2C1 RX | `DMA_FLEXIBLE_I2C1_RX` | 0x29 |
| I2C1 TX | `DMA_FLEXIBLE_I2C1_TX` | 0x2A |
| I2C2 RX | `DMA_FLEXIBLE_I2C2_RX` | 0x2B |
| I2C2 TX | `DMA_FLEXIBLE_I2C2_TX` | 0x2C |
| I2C3 RX | `DMA_FLEXIBLE_I2C3_RX` | 0x2D |
| I2C3 TX | `DMA_FLEXIBLE_I2C3_TX` | 0x2E |

#### SDIO

| Peripheral | Request ID | Value |
|------------|------------|-------|
| SDIO1 | `DMA_FLEXIBLE_SDIO1` | 0x31 |
| SDIO2 | `DMA_FLEXIBLE_SDIO2` | 0x32 |

#### Timers

| Peripheral | Request ID | Value |
|------------|------------|-------|
| TMR1 TRIG | `DMA_FLEXIBLE_TMR1_TRIG` | 0x35 |
| TMR1 HALL | `DMA_FLEXIBLE_TMR1_HALL` | 0x36 |
| TMR1 OVERFLOW | `DMA_FLEXIBLE_TMR1_OVERFLOW` | 0x37 |
| TMR1 CH1 | `DMA_FLEXIBLE_TMR1_CH1` | 0x38 |
| TMR1 CH2 | `DMA_FLEXIBLE_TMR1_CH2` | 0x39 |
| TMR1 CH3 | `DMA_FLEXIBLE_TMR1_CH3` | 0x3A |
| TMR1 CH4 | `DMA_FLEXIBLE_TMR1_CH4` | 0x3B |
| TMR2 TRIG | `DMA_FLEXIBLE_TMR2_TRIG` | 0x3D |
| TMR2 OVERFLOW | `DMA_FLEXIBLE_TMR2_OVERFLOW` | 0x3F |
| TMR2 CH1-4 | `DMA_FLEXIBLE_TMR2_CHx` | 0x40-0x43 |
| TMR3 TRIG | `DMA_FLEXIBLE_TMR3_TRIG` | 0x45 |
| TMR3 OVERFLOW | `DMA_FLEXIBLE_TMR3_OVERFLOW` | 0x47 |
| TMR3 CH1-4 | `DMA_FLEXIBLE_TMR3_CHx` | 0x48-0x4B |
| TMR4 TRIG | `DMA_FLEXIBLE_TMR4_TRIG` | 0x4D |
| TMR4 OVERFLOW | `DMA_FLEXIBLE_TMR4_OVERFLOW` | 0x4F |
| TMR4 CH1-4 | `DMA_FLEXIBLE_TMR4_CHx` | 0x50-0x53 |
| TMR5 TRIG | `DMA_FLEXIBLE_TMR5_TRIG` | 0x55 |
| TMR5 OVERFLOW | `DMA_FLEXIBLE_TMR5_OVERFLOW` | 0x57 |
| TMR5 CH1-4 | `DMA_FLEXIBLE_TMR5_CHx` | 0x58-0x5B |
| TMR6 OVERFLOW | `DMA_FLEXIBLE_TMR6_OVERFLOW` | 0x5F |
| TMR7 OVERFLOW | `DMA_FLEXIBLE_TMR7_OVERFLOW` | 0x67 |
| TMR8 TRIG | `DMA_FLEXIBLE_TMR8_TRIG` | 0x6D |
| TMR8 HALL | `DMA_FLEXIBLE_TMR8_HALL` | 0x6E |
| TMR8 OVERFLOW | `DMA_FLEXIBLE_TMR8_OVERFLOW` | 0x6F |
| TMR8 CH1-4 | `DMA_FLEXIBLE_TMR8_CHx` | 0x70-0x73 |

---

## Flags & Interrupts

### Flag Definitions (per channel)

| Flag Type | DMA1 Channel 1 | Description |
|-----------|----------------|-------------|
| Global | `DMA1_GL1_FLAG` | Any interrupt occurred |
| Full Transfer | `DMA1_FDT1_FLAG` | Transfer complete |
| Half Transfer | `DMA1_HDT1_FLAG` | Half transfer complete |
| Error | `DMA1_DTERR1_FLAG` | Transfer error |

> Pattern: `DMAx_YYYn_FLAG` where x=1/2, YYY=GL/FDT/HDT/DTERR, n=1-7

### Interrupt Enable Constants

```c
#define DMA_FDT_INT    0x00000002  // Full data transfer interrupt
#define DMA_HDT_INT    0x00000004  // Half data transfer interrupt
#define DMA_DTERR_INT  0x00000008  // Data transfer error interrupt
```

---

## Initialization Structure

```c
typedef struct
{
  uint32_t                      peripheral_base_addr;   // Peripheral register address
  uint32_t                      memory_base_addr;       // Memory buffer address
  dma_dir_type                  direction;              // Transfer direction
  uint16_t                      buffer_size;            // Number of data units
  confirm_state                 peripheral_inc_enable;  // Peripheral addr increment
  confirm_state                 memory_inc_enable;      // Memory addr increment
  dma_peripheral_data_size_type peripheral_data_width;  // Peripheral data width
  dma_memory_data_size_type     memory_data_width;      // Memory data width
  confirm_state                 loop_mode_enable;       // Circular mode enable
  dma_priority_level_type       priority;               // Channel priority
} dma_init_type;
```

---

## API Reference

### Initialization Functions

#### `dma_reset()`
Reset DMA channel to default state.

```c
void dma_reset(dma_channel_type* dmax_channely);
```

#### `dma_default_para_init()`
Initialize structure with default values.

```c
void dma_default_para_init(dma_init_type* dma_init_struct);
```

#### `dma_init()`
Configure DMA channel with specified parameters.

```c
void dma_init(dma_channel_type* dmax_channely, dma_init_type* dma_init_struct);
```

### Control Functions

#### `dma_channel_enable()`
Enable or disable DMA channel.

```c
void dma_channel_enable(dma_channel_type* dmax_channely, confirm_state new_state);
```

#### `dma_data_number_set()`
Set number of data units to transfer.

```c
void dma_data_number_set(dma_channel_type* dmax_channely, uint16_t data_number);
```

#### `dma_data_number_get()`
Get remaining data units to transfer.

```c
uint16_t dma_data_number_get(dma_channel_type* dmax_channely);
```

### Flexible Mapping Function

#### `dma_flexible_config()`
Map peripheral request to DMA channel.

```c
void dma_flexible_config(dma_type* dma_x, uint8_t flex_channelx, 
                         dma_flexible_request_type flexible_request);
```

| Parameter | Description |
|-----------|-------------|
| `dma_x` | `DMA1` or `DMA2` |
| `flex_channelx` | `FLEX_CHANNEL1` to `FLEX_CHANNEL7` |
| `flexible_request` | Peripheral request ID |

### Interrupt Functions

#### `dma_interrupt_enable()`
Enable or disable DMA interrupts.

```c
void dma_interrupt_enable(dma_channel_type* dmax_channely, 
                          uint32_t dma_int, confirm_state new_state);
```

#### `dma_flag_get()`
Check DMA flag status.

```c
flag_status dma_flag_get(uint32_t dmax_flag);
```

#### `dma_interrupt_flag_get()`
Check DMA interrupt flag status.

```c
flag_status dma_interrupt_flag_get(uint32_t dmax_flag);
```

#### `dma_flag_clear()`
Clear DMA flag.

```c
void dma_flag_clear(uint32_t dmax_flag);
```

---

## Usage Examples

### Example 1: Memory-to-Memory Transfer (Flash to SRAM)

Copy data from Flash to SRAM using DMA with interrupt notification.

```c
#include "at32f403a_407.h"

#define BUFFER_SIZE  32

// Source data in Flash
const uint32_t src_buffer[BUFFER_SIZE] = {
    0x01020304, 0x05060708, 0x090A0B0C, 0x0D0E0F10,
    0x11121314, 0x15161718, 0x191A1B1C, 0x1D1E1F20,
    0x21222324, 0x25262728, 0x292A2B2C, 0x2D2E2F30,
    0x31323334, 0x35363738, 0x393A3B3C, 0x3D3E3F40,
    0x41424344, 0x45464748, 0x494A4B4C, 0x4D4E4F50,
    0x51525354, 0x55565758, 0x595A5B5C, 0x5D5E5F60,
    0x61626364, 0x65666768, 0x696A6B6C, 0x6D6E6F70,
    0x71727374, 0x75767778, 0x797A7B7C, 0x7D7E7F80
};

// Destination buffer in SRAM
uint32_t dst_buffer[BUFFER_SIZE];
volatile uint8_t transfer_complete = 0;

void DMA1_Channel1_IRQHandler(void)
{
    if(dma_interrupt_flag_get(DMA1_FDT1_FLAG) != RESET)
    {
        transfer_complete = 1;
        dma_flag_clear(DMA1_FDT1_FLAG);
    }
}

void dma_memory_to_memory_example(void)
{
    dma_init_type dma_init_struct;
    
    // Enable DMA1 clock
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    
    // Reset and configure DMA channel
    dma_reset(DMA1_CHANNEL1);
    
    dma_init_struct.buffer_size = BUFFER_SIZE;
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_MEMORY;
    dma_init_struct.memory_base_addr = (uint32_t)dst_buffer;      // Destination
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_WORD;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)src_buffer;  // Source
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_WORD;
    dma_init_struct.peripheral_inc_enable = TRUE;
    dma_init_struct.priority = DMA_PRIORITY_MEDIUM;
    dma_init_struct.loop_mode_enable = FALSE;
    
    dma_init(DMA1_CHANNEL1, &dma_init_struct);
    
    // Enable full transfer interrupt
    dma_interrupt_enable(DMA1_CHANNEL1, DMA_FDT_INT, TRUE);
    
    // Configure NVIC
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    nvic_irq_enable(DMA1_Channel1_IRQn, 1, 0);
    
    // Start transfer
    dma_channel_enable(DMA1_CHANNEL1, TRUE);
    
    // Wait for completion
    while(!transfer_complete);
    
    // Verify transfer (compare buffers)
}
```

### Example 2: Timer-Triggered GPIO Output (Flexible DMA)

Use TMR2 overflow to trigger DMA transfer to GPIO.

```c
#include "at32f403a_407.h"

#define BUFFER_SIZE  16

uint16_t gpio_pattern[BUFFER_SIZE] = {
    0x0001, 0x0002, 0x0004, 0x0008,
    0x0010, 0x0020, 0x0040, 0x0080,
    0x0100, 0x0200, 0x0400, 0x0800,
    0x1000, 0x2000, 0x4000, 0x8000
};

void dma_timer_gpio_example(void)
{
    gpio_init_type gpio_init_struct;
    dma_init_type dma_init_struct;
    
    // Enable clocks
    crm_periph_clock_enable(CRM_DMA2_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
    
    // Configure GPIOC all pins as output
    gpio_init_struct.gpio_pins = GPIO_PINS_ALL;
    gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
    gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
    gpio_init(GPIOC, &gpio_init_struct);
    
    // Configure TMR2
    tmr_base_init(TMR2, 0xFF, 0);  // Fast overflow
    tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
    tmr_dma_request_enable(TMR2, TMR_OVERFLOW_DMA_REQUEST, TRUE);
    
    // Configure DMA2 Channel 1
    dma_reset(DMA2_CHANNEL1);
    dma_init_struct.buffer_size = BUFFER_SIZE;
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_base_addr = (uint32_t)gpio_pattern;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_HALFWORD;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)&GPIOC->odt;  // GPIO output register
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_MEDIUM;
    dma_init_struct.loop_mode_enable = TRUE;  // Circular for continuous output
    dma_init(DMA2_CHANNEL1, &dma_init_struct);
    
    // Map TMR2 overflow to DMA2 Channel 1
    dma_flexible_config(DMA2, FLEX_CHANNEL1, DMA_FLEXIBLE_TMR2_OVERFLOW);
    
    // Enable DMA and Timer
    dma_channel_enable(DMA2_CHANNEL1, TRUE);
    tmr_counter_enable(TMR2, TRUE);
}
```

### Example 3: UART RX with DMA (Circular Buffer)

Receive UART data continuously using DMA circular mode.

```c
#include "at32f403a_407.h"

#define RX_BUFFER_SIZE  256

uint8_t uart_rx_buffer[RX_BUFFER_SIZE];

void dma_uart_rx_example(void)
{
    dma_init_type dma_init_struct;
    
    // Enable clocks
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_USART1_PERIPH_CLOCK, TRUE);
    
    // Configure UART1 (assumed already configured for RX)
    // ...
    
    // Configure DMA1 for UART1 RX
    dma_reset(DMA1_CHANNEL5);
    
    dma_init_struct.buffer_size = RX_BUFFER_SIZE;
    dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
    dma_init_struct.memory_base_addr = (uint32_t)uart_rx_buffer;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_BYTE;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)&USART1->dt;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_HIGH;
    dma_init_struct.loop_mode_enable = TRUE;  // Circular buffer
    
    dma_init(DMA1_CHANNEL5, &dma_init_struct);
    
    // Map UART1 RX to DMA1 Channel 5
    dma_flexible_config(DMA1, FLEX_CHANNEL5, DMA_FLEXIBLE_UART1_RX);
    
    // Enable half and full transfer interrupts
    dma_interrupt_enable(DMA1_CHANNEL5, DMA_HDT_INT | DMA_FDT_INT, TRUE);
    
    // Enable DMA channel
    dma_channel_enable(DMA1_CHANNEL5, TRUE);
    
    // Enable UART DMA receive
    usart_dma_receiver_enable(USART1, TRUE);
}

void DMA1_Channel5_IRQHandler(void)
{
    if(dma_interrupt_flag_get(DMA1_HDT5_FLAG) != RESET)
    {
        // Process first half of buffer
        dma_flag_clear(DMA1_HDT5_FLAG);
    }
    
    if(dma_interrupt_flag_get(DMA1_FDT5_FLAG) != RESET)
    {
        // Process second half of buffer
        dma_flag_clear(DMA1_FDT5_FLAG);
    }
}
```

### Example 4: ADC with DMA (Multiple Channels)

Read multiple ADC channels continuously.

```c
#include "at32f403a_407.h"

#define ADC_CHANNEL_COUNT  4

uint16_t adc_values[ADC_CHANNEL_COUNT];

void dma_adc_example(void)
{
    dma_init_type dma_init_struct;
    
    // Enable clocks
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_ADC1_PERIPH_CLOCK, TRUE);
    
    // Configure ADC1 for scan mode (assumed)
    // ...
    
    // Configure DMA for ADC
    dma_reset(DMA1_CHANNEL1);
    
    dma_init_struct.buffer_size = ADC_CHANNEL_COUNT;
    dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
    dma_init_struct.memory_base_addr = (uint32_t)adc_values;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_HALFWORD;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)&ADC1->odt;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_HIGH;
    dma_init_struct.loop_mode_enable = TRUE;  // Continuous conversion
    
    dma_init(DMA1_CHANNEL1, &dma_init_struct);
    
    // Map ADC1 to DMA1 Channel 1
    dma_flexible_config(DMA1, FLEX_CHANNEL1, DMA_FLEXIBLE_ADC1);
    
    // Enable DMA channel
    dma_channel_enable(DMA1_CHANNEL1, TRUE);
    
    // Enable ADC DMA mode
    adc_dma_mode_enable(ADC1, TRUE);
}
```

### Example 5: SPI TX/RX with DMA

Full-duplex SPI transfer using two DMA channels.

```c
#include "at32f403a_407.h"

#define SPI_BUFFER_SIZE  64

uint8_t spi_tx_buffer[SPI_BUFFER_SIZE];
uint8_t spi_rx_buffer[SPI_BUFFER_SIZE];

void dma_spi_example(void)
{
    dma_init_type dma_init_struct;
    
    // Enable clocks
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_SPI1_PERIPH_CLOCK, TRUE);
    
    // Configure DMA for SPI1 RX (Channel 2)
    dma_reset(DMA1_CHANNEL2);
    dma_init_struct.buffer_size = SPI_BUFFER_SIZE;
    dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
    dma_init_struct.memory_base_addr = (uint32_t)spi_rx_buffer;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_BYTE;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)&SPI1->dt;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_HIGH;
    dma_init_struct.loop_mode_enable = FALSE;
    dma_init(DMA1_CHANNEL2, &dma_init_struct);
    
    // Configure DMA for SPI1 TX (Channel 3)
    dma_reset(DMA1_CHANNEL3);
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_base_addr = (uint32_t)spi_tx_buffer;
    dma_init(DMA1_CHANNEL3, &dma_init_struct);
    
    // Map SPI1 to DMA channels
    dma_flexible_config(DMA1, FLEX_CHANNEL2, DMA_FLEXIBLE_SPI1_RX);
    dma_flexible_config(DMA1, FLEX_CHANNEL3, DMA_FLEXIBLE_SPI1_TX);
    
    // Enable DMA channels
    dma_channel_enable(DMA1_CHANNEL2, TRUE);  // RX first
    dma_channel_enable(DMA1_CHANNEL3, TRUE);  // TX second
    
    // Enable SPI DMA
    spi_i2s_dma_receiver_enable(SPI1, TRUE);
    spi_i2s_dma_transmitter_enable(SPI1, TRUE);
}
```

---

## Circular Mode (Double Buffering)

Circular mode enables continuous DMA transfers with automatic address reload.

```
┌─────────────────────────────────────────┐
│              Circular Buffer             │
├─────────────────┬───────────────────────┤
│    First Half   │     Second Half       │
│   (HDT interrupt│    (FDT interrupt)    │
│     Process)    │       Process)        │
└─────────────────┴───────────────────────┘
        ▲                    ▲
        │                    │
    DMA writes           DMA writes
    here first          here second
```

### Double Buffer Processing Pattern

```c
void DMA_IRQHandler(void)
{
    static uint8_t active_buffer = 0;
    
    if(dma_interrupt_flag_get(DMAx_HDTn_FLAG))
    {
        // First half complete - process buffer[0..SIZE/2-1]
        process_buffer(&buffer[0], BUFFER_SIZE/2);
        dma_flag_clear(DMAx_HDTn_FLAG);
    }
    
    if(dma_interrupt_flag_get(DMAx_FDTn_FLAG))
    {
        // Second half complete - process buffer[SIZE/2..SIZE-1]
        process_buffer(&buffer[BUFFER_SIZE/2], BUFFER_SIZE/2);
        dma_flag_clear(DMAx_FDTn_FLAG);
    }
}
```

---

## DMA Channel Summary

### DMA1 Channels

| Channel | IRQ Handler |
|---------|-------------|
| DMA1_CHANNEL1 | `DMA1_Channel1_IRQHandler` |
| DMA1_CHANNEL2 | `DMA1_Channel2_IRQHandler` |
| DMA1_CHANNEL3 | `DMA1_Channel3_IRQHandler` |
| DMA1_CHANNEL4 | `DMA1_Channel4_IRQHandler` |
| DMA1_CHANNEL5 | `DMA1_Channel5_IRQHandler` |
| DMA1_CHANNEL6 | `DMA1_Channel6_IRQHandler` |
| DMA1_CHANNEL7 | `DMA1_Channel7_IRQHandler` |

### DMA2 Channels

| Channel | IRQ Handler |
|---------|-------------|
| DMA2_CHANNEL1 | `DMA2_Channel1_IRQHandler` |
| DMA2_CHANNEL2 | `DMA2_Channel2_IRQHandler` |
| DMA2_CHANNEL3 | `DMA2_Channel3_IRQHandler` |
| DMA2_CHANNEL4_5 | `DMA2_Channel4_5_IRQHandler` |
| DMA2_CHANNEL6_7 | `DMA2_Channel6_7_IRQHandler` |

---

## Troubleshooting

### Transfer Not Starting

| Issue | Solution |
|-------|----------|
| DMA clock not enabled | `crm_periph_clock_enable(CRM_DMAx_PERIPH_CLOCK, TRUE)` |
| Channel not enabled | `dma_channel_enable(channel, TRUE)` |
| Buffer size is 0 | Set valid `buffer_size` > 0 |
| Peripheral not configured | Enable peripheral DMA request |

### Transfer Error (DTERR)

| Issue | Solution |
|-------|----------|
| Invalid address | Check memory/peripheral addresses |
| Bus conflict | Reduce DMA priority or transfer rate |
| Memory protection | Ensure target memory is writable |

### Data Corruption

| Issue | Solution |
|-------|----------|
| Width mismatch | Match peripheral and memory widths |
| Wrong increment mode | Check address increment settings |
| Buffer overflow | Ensure buffer_size matches actual buffer |

### Flexible Mapping Not Working

| Issue | Solution |
|-------|----------|
| Flex mode not enabled | `dma_flexible_config()` auto-enables |
| Wrong request ID | Verify peripheral request constant |
| Wrong DMA controller | Some peripherals may prefer DMA1/DMA2 |

### Circular Mode Issues

| Issue | Solution |
|-------|----------|
| Transfer stops | Ensure `loop_mode_enable = TRUE` |
| Buffer not aligned | Align buffer to data width boundary |
| Interrupt overrun | Process data faster in ISR |

---

## Performance Tips

1. **Use 32-bit transfers** when possible for maximum throughput
2. **Align buffers** to 4-byte boundaries for word transfers
3. **Use higher priority** for time-critical channels
4. **Enable circular mode** for continuous streaming
5. **Use half-transfer interrupt** for double-buffering
6. **Minimize ISR processing** time in DMA handlers

---

## Related Peripherals

| Peripheral | DMA Usage |
|------------|-----------|
| **ADC** | Continuous conversion results |
| **DAC** | Waveform generation |
| **UART** | High-speed serial transfer |
| **SPI/I2S** | Audio streaming, fast SPI |
| **I2C** | Large data block transfers |
| **SDIO** | SD card read/write |
| **Timers** | PWM update, capture values |

