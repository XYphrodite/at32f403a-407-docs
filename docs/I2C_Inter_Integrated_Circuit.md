# I2C - Inter-Integrated Circuit

## Overview

The **Inter-Integrated Circuit (I2C)** peripheral provides a multi-master, multi-slave serial communication interface using only two wires (SCL clock and SDA data). The AT32F403A/407 features three independent I2C controllers (I2C1, I2C2, I2C3) that support both standard mode (up to 100 kHz) and fast mode (up to 400 kHz) operation.

| Feature | Specification |
|---------|---------------|
| **I2C Controllers** | I2C1, I2C2, I2C3 |
| **Speed Modes** | Standard (100 kHz), Fast (400 kHz) |
| **Address Modes** | 7-bit, 10-bit |
| **Own Addresses** | 2 (Address1 and Address2) |
| **Operating Modes** | Master, Slave, Multi-master |
| **DMA Support** | Yes (TX and RX channels) |
| **Interrupts** | Event, Error, Data |
| **SMBus Support** | Yes (Device and Host modes) |
| **PEC Support** | Yes (Packet Error Checking) |
| **Clock Stretching** | Supported |

---

## Key Features

- **Multi-master capability**: Multiple masters can share the same bus.
- **Master and Slave modes**: Each I2C can operate as master or slave.
- **7-bit and 10-bit addressing**: Supports both addressing modes.
- **Dual address support**: Two slave addresses per I2C peripheral.
- **General Call support**: Respond to broadcast address (0x00).
- **Programmable clock speeds**: Standard mode (≤100 kHz) and fast mode (≤400 kHz).
- **Fast mode duty cycle**: Configurable 2:1 or 16:9 duty cycle.
- **DMA support**: Reduces CPU overhead for data transfers.
- **Interrupt-driven operation**: Event, error, and data interrupts.
- **SMBus compatibility**: System Management Bus support.
- **PEC calculation**: Hardware Packet Error Checking.
- **Clock stretching**: Slave can hold SCL low to pause communication.

---

## Pin Configuration

### Default Pin Mapping

| I2C | SCL Pin | SDA Pin | APB Bus |
|-----|---------|---------|---------|
| I2C1 | PB6 | PB7 | APB1 |
| I2C2 | PB10 | PB11 | APB1 |
| I2C3 | PA8 | PB4 | APB2 |

### Remapped Pin Mapping

| I2C | Remap Option | SCL Pin | SDA Pin |
|-----|--------------|---------|---------|
| I2C1 | `I2C1_MUX` | PB8 | PB9 |
| I2C3 | `I2C3_MUX` | PA8 | PB4 |

### DMA Channel Mapping

| I2C | TX Channel | RX Channel |
|-----|------------|------------|
| I2C1 | DMA1_CHANNEL6 | DMA1_CHANNEL7 |
| I2C2 | DMA1_CHANNEL4 | DMA1_CHANNEL5 |

---

## Configuration Types

### Fast Mode Duty Cycle

```c
typedef enum
{
  I2C_FSMODE_DUTY_2_1  = 0x00, // Duty cycle 2:1 (T_low:T_high)
  I2C_FSMODE_DUTY_16_9 = 0x01  // Duty cycle 16:9 (T_low:T_high)
} i2c_fsmode_duty_cycle_type;
```

### Address Mode

```c
typedef enum
{
  I2C_ADDRESS_MODE_7BIT  = 0x00, // 7-bit address mode
  I2C_ADDRESS_MODE_10BIT = 0x01  // 10-bit address mode
} i2c_address_mode_type;
```

### Transfer Direction

```c
typedef enum
{
  I2C_DIRECTION_TRANSMIT = 0x00, // Transmit mode (write)
  I2C_DIRECTION_RECEIVE  = 0x01  // Receive mode (read)
} i2c_direction_type;
```

### Memory Address Width (Application Library)

```c
typedef enum
{
  I2C_MEM_ADDR_WIDIH_8  = 0x01, // 8-bit memory address
  I2C_MEM_ADDR_WIDIH_16 = 0x02  // 16-bit memory address
} i2c_mem_address_width_type;
```

### Status Codes (Application Library)

```c
typedef enum
{
  I2C_OK = 0,          // No error
  I2C_ERR_STEP_1,      // Step 1 error
  I2C_ERR_STEP_2,      // Step 2 error
  // ... more step errors
  I2C_ERR_ACKFAIL,     // Acknowledge failure
  I2C_ERR_TIMEOUT,     // Timeout error
  I2C_ERR_INTERRUPT,   // Interrupt error
} i2c_status_type;
```

---

## Status Flags

### STS1 Register Flags

| Flag | Description |
|------|-------------|
| `I2C_STARTF_FLAG` | Start condition generated |
| `I2C_ADDR7F_FLAG` | 7-bit address match |
| `I2C_TDC_FLAG` | Transmit data complete |
| `I2C_ADDRHF_FLAG` | 10-bit address header match |
| `I2C_STOPF_FLAG` | Stop condition detected |
| `I2C_RDBF_FLAG` | Receive data buffer full |
| `I2C_TDBE_FLAG` | Transmit data buffer empty |
| `I2C_BUSERR_FLAG` | Bus error |
| `I2C_ARLOST_FLAG` | Arbitration lost |
| `I2C_ACKFAIL_FLAG` | Acknowledge failure |
| `I2C_OUF_FLAG` | Overflow/Underflow |
| `I2C_PECERR_FLAG` | PEC error |
| `I2C_TMOUT_FLAG` | SMBus timeout |
| `I2C_ALERTF_FLAG` | SMBus alert |

### STS2 Register Flags

| Flag | Description |
|------|-------------|
| `I2C_TRMODE_FLAG` | Transmission mode (master) |
| `I2C_BUSYF_FLAG` | Bus busy |
| `I2C_DIRF_FLAG` | Direction (transmit/receive) |
| `I2C_GCADDRF_FLAG` | General call address received |
| `I2C_DEVADDRF_FLAG` | SMBus device address received |
| `I2C_HOSTADDRF_FLAG` | SMBus host address received |
| `I2C_ADDR2_FLAG` | Own address 2 match |

---

## Interrupt Sources

| Interrupt | Enable Bit | Description |
|-----------|------------|-------------|
| `I2C_DATA_INT` | DATAIEN | Data transmission interrupt |
| `I2C_EVT_INT` | EVTIEN | Event interrupt (START, ADDR, STOP, TDC) |
| `I2C_ERR_INT` | ERRIEN | Error interrupt |

---

## Register Overview

### Control Register 1 (CTRL1)

| Bit | Name | Description |
|-----|------|-------------|
| 0 | I2CEN | I2C enable |
| 1 | PERMODE | Peripheral mode (I2C/SMBus) |
| 3 | SMBMODE | SMBus mode (Device/Host) |
| 4 | ARPEN | ARP enable |
| 5 | PECEN | PEC calculation enable |
| 6 | GCAEN | General call enable |
| 7 | STRETCH | Clock stretch disable |
| 8 | GENSTART | Generate START |
| 9 | GENSTOP | Generate STOP |
| 10 | ACKEN | ACK enable |
| 11 | MACKCTRL | Master ACK control position |
| 12 | PECTEN | PEC transmit enable |
| 13 | SMBALERT | SMBus alert pin level |
| 15 | RESET | Software reset |

### Control Register 2 (CTRL2)

| Bit | Name | Description |
|-----|------|-------------|
| 7:0 | CLKFREQ | APB clock frequency (MHz) |
| 8 | ERRIEN | Error interrupt enable |
| 9 | EVTIEN | Event interrupt enable |
| 10 | DATAIEN | Data interrupt enable |
| 11 | DMAEN | DMA enable |
| 12 | DMAEND | DMA last transfer |

### Clock Control Register (CLKCTRL)

| Bit | Name | Description |
|-----|------|-------------|
| 11:0 | SPEED | SCL clock speed |
| 14 | DUTYMODE | Fast mode duty cycle |
| 15 | SPEEDMODE | Speed mode (Standard/Fast) |

---

## Low-Level API Reference

### Initialization Functions

#### `void i2c_reset(i2c_type *i2c_x)`
Resets the I2C peripheral to default state.

#### `void i2c_software_reset(i2c_type *i2c_x, confirm_state new_state)`
Performs a software reset of the I2C peripheral.

#### `void i2c_init(i2c_type *i2c_x, i2c_fsmode_duty_cycle_type duty, uint32_t speed)`
Initializes I2C with specified duty cycle and speed.

```c
// Initialize I2C1 at 100kHz (standard mode)
i2c_init(I2C1, I2C_FSMODE_DUTY_2_1, 100000);

// Initialize I2C2 at 400kHz (fast mode)
i2c_init(I2C2, I2C_FSMODE_DUTY_2_1, 400000);
```

#### `void i2c_enable(i2c_type *i2c_x, confirm_state new_state)`
Enables or disables the I2C peripheral.

---

### Address Configuration

#### `void i2c_own_address1_set(i2c_type *i2c_x, i2c_address_mode_type mode, uint16_t address)`
Sets the primary own address.

```c
// Set 7-bit own address to 0xA0
i2c_own_address1_set(I2C1, I2C_ADDRESS_MODE_7BIT, 0xA0);
```

#### `void i2c_own_address2_set(i2c_type *i2c_x, uint8_t address)`
Sets the secondary own address (7-bit only).

#### `void i2c_own_address2_enable(i2c_type *i2c_x, confirm_state new_state)`
Enables or disables the secondary address.

---

### Communication Control

#### `void i2c_start_generate(i2c_type *i2c_x)`
Generates a START condition.

#### `void i2c_stop_generate(i2c_type *i2c_x)`
Generates a STOP condition.

#### `void i2c_7bit_address_send(i2c_type *i2c_x, uint8_t address, i2c_direction_type direction)`
Sends a 7-bit slave address with direction bit.

```c
// Send address for write operation
i2c_7bit_address_send(I2C1, 0xA0, I2C_DIRECTION_TRANSMIT);

// Send address for read operation
i2c_7bit_address_send(I2C1, 0xA0, I2C_DIRECTION_RECEIVE);
```

#### `void i2c_data_send(i2c_type *i2c_x, uint8_t data)`
Sends a data byte.

#### `uint8_t i2c_data_receive(i2c_type *i2c_x)`
Receives a data byte.

#### `void i2c_ack_enable(i2c_type *i2c_x, confirm_state new_state)`
Enables or disables ACK generation.

#### `void i2c_master_receive_ack_set(i2c_type *i2c_x, i2c_master_ack_type pos)`
Sets ACK position for master receiver mode.

---

### Interrupt and DMA Control

#### `void i2c_interrupt_enable(i2c_type *i2c_x, uint16_t source, confirm_state new_state)`
Enables or disables I2C interrupts.

```c
// Enable event and error interrupts
i2c_interrupt_enable(I2C1, I2C_EVT_INT | I2C_ERR_INT, TRUE);

// Enable data interrupt
i2c_interrupt_enable(I2C1, I2C_DATA_INT, TRUE);
```

#### `void i2c_dma_enable(i2c_type *i2c_x, confirm_state new_state)`
Enables or disables DMA requests.

#### `void i2c_dma_end_transfer_set(i2c_type *i2c_x, confirm_state new_state)`
Sets the DMA end transfer flag.

---

### Flag and Status Functions

#### `flag_status i2c_flag_get(i2c_type *i2c_x, uint32_t flag)`
Gets the status of a specific flag.

#### `flag_status i2c_interrupt_flag_get(i2c_type *i2c_x, uint32_t flag)`
Gets the interrupt flag status.

#### `void i2c_flag_clear(i2c_type *i2c_x, uint32_t flag)`
Clears the specified flag(s).

---

### SMBus Functions

#### `void i2c_smbus_enable(i2c_type *i2c_x, confirm_state new_state)`
Enables SMBus mode.

#### `void i2c_smbus_mode_set(i2c_type *i2c_x, i2c_smbus_mode_set_type mode)`
Sets SMBus device or host mode.

#### `void i2c_smbus_alert_set(i2c_type *i2c_x, i2c_smbus_alert_set_type level)`
Sets SMBus alert pin level.

---

### PEC Functions

#### `void i2c_pec_calculate_enable(i2c_type *i2c_x, confirm_state new_state)`
Enables PEC calculation.

#### `void i2c_pec_transmit_enable(i2c_type *i2c_x, confirm_state new_state)`
Enables PEC transmission.

#### `uint8_t i2c_pec_value_get(i2c_type *i2c_x)`
Gets the current PEC value.

---

## Application Library API Reference

The application library provides higher-level functions that simplify I2C communication.

### Handle Structure

```c
typedef struct
{
  i2c_type        *i2cx;           // I2C peripheral
  uint8_t         *pbuff;          // Data buffer pointer
  uint16_t        psize;           // Transfer size
  uint16_t        pcount;          // Transfer counter
  uint32_t        mode;            // Communication mode
  uint32_t        status;          // Communication status
  i2c_status_type error_code;      // Error code
  dma_channel_type *dma_tx_channel; // DMA TX channel
  dma_channel_type *dma_rx_channel; // DMA RX channel
  dma_init_type   dma_init_struct; // DMA init struct
} i2c_handle_type;
```

### Initialization

#### `void i2c_config(i2c_handle_type* hi2c)`
Configures the I2C peripheral (calls `i2c_lowlevel_init`).

#### `void i2c_lowlevel_init(i2c_handle_type* hi2c)`
User-implemented function for low-level initialization.

### Polling Mode Functions

#### `i2c_status_type i2c_master_transmit(hi2c, address, pdata, size, timeout)`
Master transmit in polling mode.

#### `i2c_status_type i2c_master_receive(hi2c, address, pdata, size, timeout)`
Master receive in polling mode.

#### `i2c_status_type i2c_slave_transmit(hi2c, pdata, size, timeout)`
Slave transmit in polling mode.

#### `i2c_status_type i2c_slave_receive(hi2c, pdata, size, timeout)`
Slave receive in polling mode.

### Interrupt Mode Functions

#### `i2c_status_type i2c_master_transmit_int(hi2c, address, pdata, size, timeout)`
Master transmit with interrupts.

#### `i2c_status_type i2c_master_receive_int(hi2c, address, pdata, size, timeout)`
Master receive with interrupts.

#### `i2c_status_type i2c_slave_transmit_int(hi2c, pdata, size, timeout)`
Slave transmit with interrupts.

#### `i2c_status_type i2c_slave_receive_int(hi2c, pdata, size, timeout)`
Slave receive with interrupts.

### DMA Mode Functions

#### `i2c_status_type i2c_master_transmit_dma(hi2c, address, pdata, size, timeout)`
Master transmit with DMA.

#### `i2c_status_type i2c_master_receive_dma(hi2c, address, pdata, size, timeout)`
Master receive with DMA.

#### `i2c_status_type i2c_slave_transmit_dma(hi2c, pdata, size, timeout)`
Slave transmit with DMA.

#### `i2c_status_type i2c_slave_receive_dma(hi2c, pdata, size, timeout)`
Slave receive with DMA.

### Memory Read/Write Functions

#### `i2c_status_type i2c_memory_write(hi2c, mem_width, address, mem_addr, pdata, size, timeout)`
Write to memory device (EEPROM, etc.) in polling mode.

#### `i2c_status_type i2c_memory_read(hi2c, mem_width, address, mem_addr, pdata, size, timeout)`
Read from memory device in polling mode.

#### `i2c_status_type i2c_memory_write_int/dma(...)`
Memory write with interrupt or DMA.

#### `i2c_status_type i2c_memory_read_int/dma(...)`
Memory read with interrupt or DMA.

### Utility Functions

#### `i2c_status_type i2c_wait_end(i2c_handle_type* hi2c, uint32_t timeout)`
Waits for communication to complete (used with interrupt/DMA modes).

#### `i2c_status_type i2c_wait_flag(hi2c, flag, event_check, timeout)`
Waits for a specific flag.

### Interrupt Handlers

#### `void i2c_evt_irq_handler(i2c_handle_type* hi2c)`
Event interrupt handler - call from I2Cx_EVT_IRQHandler.

#### `void i2c_err_irq_handler(i2c_handle_type* hi2c)`
Error interrupt handler - call from I2Cx_ERR_IRQHandler.

#### `void i2c_dma_tx_irq_handler(i2c_handle_type* hi2c)`
DMA TX complete handler.

#### `void i2c_dma_rx_irq_handler(i2c_handle_type* hi2c)`
DMA RX complete handler.

---

## Usage Examples

### 1. Basic I2C Master - Polling Mode

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"
#include "i2c_application.h"

#define I2C_TIMEOUT   0xFFFFFFFF
#define I2C_SPEED     100000
#define I2C_ADDRESS   0xA0
#define BUF_SIZE      8

uint8_t tx_buf[BUF_SIZE] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
uint8_t rx_buf[BUF_SIZE] = {0};

i2c_handle_type hi2c;

void i2c_lowlevel_init(i2c_handle_type* hi2c)
{
  gpio_init_type gpio_init_struct;

  // Enable clocks
  crm_periph_clock_enable(CRM_I2C1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  // Configure I2C GPIO pins
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_OPEN_DRAIN;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;

  // SCL - PB6
  gpio_init_struct.gpio_pins = GPIO_PINS_6;
  gpio_init(GPIOB, &gpio_init_struct);

  // SDA - PB7
  gpio_init_struct.gpio_pins = GPIO_PINS_7;
  gpio_init(GPIOB, &gpio_init_struct);

  // Initialize I2C
  i2c_init(hi2c->i2cx, I2C_FSMODE_DUTY_2_1, I2C_SPEED);
  i2c_own_address1_set(hi2c->i2cx, I2C_ADDRESS_MODE_7BIT, I2C_ADDRESS);
}

int main(void)
{
  i2c_status_type status;

  system_clock_config();
  at32_board_init();

  hi2c.i2cx = I2C1;
  i2c_config(&hi2c);

  while (1)
  {
    // Wait for button press
    while (at32_button_press() != USER_BUTTON);

    // Transmit data
    status = i2c_master_transmit(&hi2c, I2C_ADDRESS, tx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK)
    {
      // Handle error
      at32_led_toggle(LED2);
      continue;
    }

    delay_ms(10);

    // Receive data
    status = i2c_master_receive(&hi2c, I2C_ADDRESS, rx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK)
    {
      at32_led_toggle(LED2);
      continue;
    }

    // Success
    at32_led_on(LED3);
  }
}
```

### 2. I2C Master - Interrupt Mode

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"
#include "i2c_application.h"

#define I2C_TIMEOUT   0xFFFFFFFF
#define I2C_SPEED     100000
#define I2C_ADDRESS   0xA0
#define BUF_SIZE      8

uint8_t tx_buf[BUF_SIZE] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
uint8_t rx_buf[BUF_SIZE] = {0};

i2c_handle_type hi2c;

void i2c_lowlevel_init(i2c_handle_type* hi2c)
{
  gpio_init_type gpio_init_struct;

  // Enable clocks
  crm_periph_clock_enable(CRM_I2C1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  // Configure GPIO
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_OPEN_DRAIN;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;

  gpio_init_struct.gpio_pins = GPIO_PINS_6;
  gpio_init(GPIOB, &gpio_init_struct);

  gpio_init_struct.gpio_pins = GPIO_PINS_7;
  gpio_init(GPIOB, &gpio_init_struct);

  // Enable I2C interrupts
  nvic_irq_enable(I2C1_EVT_IRQn, 0, 0);
  nvic_irq_enable(I2C1_ERR_IRQn, 0, 0);

  // Initialize I2C
  i2c_init(hi2c->i2cx, I2C_FSMODE_DUTY_2_1, I2C_SPEED);
  i2c_own_address1_set(hi2c->i2cx, I2C_ADDRESS_MODE_7BIT, I2C_ADDRESS);
}

// I2C1 Event Interrupt Handler
void I2C1_EVT_IRQHandler(void)
{
  i2c_evt_irq_handler(&hi2c);
}

// I2C1 Error Interrupt Handler
void I2C1_ERR_IRQHandler(void)
{
  i2c_err_irq_handler(&hi2c);
}

int main(void)
{
  i2c_status_type status;

  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  system_clock_config();
  at32_board_init();

  hi2c.i2cx = I2C1;
  i2c_config(&hi2c);

  while (1)
  {
    while (at32_button_press() != USER_BUTTON);

    // Start transmit (non-blocking)
    status = i2c_master_transmit_int(&hi2c, I2C_ADDRESS, tx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK) continue;

    // Wait for completion
    if (i2c_wait_end(&hi2c, I2C_TIMEOUT) != I2C_OK) continue;

    delay_ms(10);

    // Start receive (non-blocking)
    status = i2c_master_receive_int(&hi2c, I2C_ADDRESS, rx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK) continue;

    // Wait for completion
    if (i2c_wait_end(&hi2c, I2C_TIMEOUT) != I2C_OK) continue;

    at32_led_on(LED3);
  }
}
```

### 3. I2C Master - DMA Mode

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"
#include "i2c_application.h"

#define I2C_TIMEOUT   0xFFFFFFFF
#define I2C_SPEED     100000
#define I2C_ADDRESS   0xA0
#define BUF_SIZE      8

uint8_t tx_buf[BUF_SIZE] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
uint8_t rx_buf[BUF_SIZE] = {0};

i2c_handle_type hi2c;

void i2c_lowlevel_init(i2c_handle_type* hi2c)
{
  gpio_init_type gpio_init_struct;

  // Enable clocks
  crm_periph_clock_enable(CRM_I2C1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);

  // Configure GPIO
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_OPEN_DRAIN;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;

  gpio_init_struct.gpio_pins = GPIO_PINS_6;
  gpio_init(GPIOB, &gpio_init_struct);

  gpio_init_struct.gpio_pins = GPIO_PINS_7;
  gpio_init(GPIOB, &gpio_init_struct);

  // Enable interrupts
  nvic_irq_enable(DMA1_Channel6_IRQn, 0, 0); // TX
  nvic_irq_enable(DMA1_Channel7_IRQn, 0, 0); // RX
  nvic_irq_enable(I2C1_EVT_IRQn, 0, 0);
  nvic_irq_enable(I2C1_ERR_IRQn, 0, 0);

  // Configure DMA channels
  hi2c->dma_tx_channel = DMA1_CHANNEL6;
  hi2c->dma_rx_channel = DMA1_CHANNEL7;

  dma_reset(hi2c->dma_tx_channel);
  dma_reset(hi2c->dma_rx_channel);

  dma_default_para_init(&hi2c->dma_init_struct);
  hi2c->dma_init_struct.peripheral_inc_enable = FALSE;
  hi2c->dma_init_struct.memory_inc_enable = TRUE;
  hi2c->dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE;
  hi2c->dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_BYTE;
  hi2c->dma_init_struct.loop_mode_enable = FALSE;
  hi2c->dma_init_struct.priority = DMA_PRIORITY_LOW;
  hi2c->dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;

  dma_init(hi2c->dma_tx_channel, &hi2c->dma_init_struct);
  dma_init(hi2c->dma_rx_channel, &hi2c->dma_init_struct);

  // Initialize I2C
  i2c_init(hi2c->i2cx, I2C_FSMODE_DUTY_2_1, I2C_SPEED);
  i2c_own_address1_set(hi2c->i2cx, I2C_ADDRESS_MODE_7BIT, I2C_ADDRESS);
}

void DMA1_Channel6_IRQHandler(void)
{
  i2c_dma_tx_irq_handler(&hi2c);
}

void DMA1_Channel7_IRQHandler(void)
{
  i2c_dma_rx_irq_handler(&hi2c);
}

void I2C1_EVT_IRQHandler(void)
{
  i2c_evt_irq_handler(&hi2c);
}

void I2C1_ERR_IRQHandler(void)
{
  i2c_err_irq_handler(&hi2c);
}

int main(void)
{
  i2c_status_type status;

  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  system_clock_config();
  at32_board_init();

  hi2c.i2cx = I2C1;
  i2c_config(&hi2c);

  while (1)
  {
    while (at32_button_press() != USER_BUTTON);

    // DMA transmit
    status = i2c_master_transmit_dma(&hi2c, I2C_ADDRESS, tx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK) continue;
    if (i2c_wait_end(&hi2c, I2C_TIMEOUT) != I2C_OK) continue;

    delay_ms(10);

    // DMA receive
    status = i2c_master_receive_dma(&hi2c, I2C_ADDRESS, rx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK) continue;
    if (i2c_wait_end(&hi2c, I2C_TIMEOUT) != I2C_OK) continue;

    at32_led_on(LED3);
  }
}
```

### 4. I2C Slave Mode

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"
#include "i2c_application.h"

#define I2C_TIMEOUT   0xFFFFFFFF
#define I2C_SPEED     100000
#define I2C_ADDRESS   0xA0
#define BUF_SIZE      8

uint8_t tx_buf[BUF_SIZE] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
uint8_t rx_buf[BUF_SIZE] = {0};

i2c_handle_type hi2c;

void i2c_lowlevel_init(i2c_handle_type* hi2c)
{
  gpio_init_type gpio_init_struct;

  crm_periph_clock_enable(CRM_I2C1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_OPEN_DRAIN;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;

  gpio_init_struct.gpio_pins = GPIO_PINS_6;
  gpio_init(GPIOB, &gpio_init_struct);

  gpio_init_struct.gpio_pins = GPIO_PINS_7;
  gpio_init(GPIOB, &gpio_init_struct);

  i2c_init(hi2c->i2cx, I2C_FSMODE_DUTY_2_1, I2C_SPEED);
  i2c_own_address1_set(hi2c->i2cx, I2C_ADDRESS_MODE_7BIT, I2C_ADDRESS);
}

int main(void)
{
  i2c_status_type status;

  system_clock_config();
  at32_board_init();

  hi2c.i2cx = I2C1;
  i2c_config(&hi2c);

  while (1)
  {
    // Wait for button press
    while (at32_button_press() != USER_BUTTON);

    // Receive data from master
    status = i2c_slave_receive(&hi2c, rx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK) continue;

    // Transmit data to master
    status = i2c_slave_transmit(&hi2c, tx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK) continue;

    at32_led_on(LED3);
  }
}
```

### 5. EEPROM Read/Write

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"
#include "eeprom.h"

#define I2C_TIMEOUT   0xFFFFFFFF
#define I2C_SPEED     100000
#define I2C_ADDRESS   0xA0
#define BUF_SIZE      12

uint8_t tx_buf[BUF_SIZE] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                            0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C};
uint8_t rx_buf[BUF_SIZE] = {0};

i2c_handle_type hi2c;

// Low-level init (see DMA example for full implementation)
void i2c_lowlevel_init(i2c_handle_type* hi2c)
{
  // ... GPIO, DMA, and I2C initialization ...
}

int main(void)
{
  i2c_status_type status;

  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  system_clock_config();
  at32_board_init();

  hi2c.i2cx = I2C2;
  i2c_config(&hi2c);

  while (1)
  {
    while (at32_button_press() != USER_BUTTON);

    // Write to EEPROM (8-bit memory address, poll mode)
    status = eeprom_write_buffer(&hi2c, EE_MODE_POLL, I2C_MEM_ADDR_WIDIH_8,
                                 I2C_ADDRESS, 0x00, tx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK) continue;

    delay_ms(10); // Wait for EEPROM write cycle

    // Read from EEPROM
    status = eeprom_read_buffer(&hi2c, EE_MODE_POLL, I2C_MEM_ADDR_WIDIH_8,
                                I2C_ADDRESS, 0x00, rx_buf, BUF_SIZE, I2C_TIMEOUT);
    if (status != I2C_OK) continue;

    // Verify data
    if (memcmp(tx_buf, rx_buf, BUF_SIZE) == 0)
    {
      at32_led_on(LED3); // Success
    }
    else
    {
      at32_led_on(LED2); // Error
    }
  }
}
```

### 6. Low-Level I2C Communication

```c
#include "at32f403a_407.h"

// Simple polling-based I2C write (for understanding the protocol)
i2c_status_type i2c_write_byte(i2c_type* i2cx, uint8_t address, uint8_t data)
{
  uint32_t timeout = 0x1000;

  // Wait until bus is free
  while (i2c_flag_get(i2cx, I2C_BUSYF_FLAG) == SET && --timeout);
  if (timeout == 0) return I2C_ERR_TIMEOUT;

  // Generate START
  i2c_start_generate(i2cx);

  // Wait for START flag
  timeout = 0x1000;
  while (i2c_flag_get(i2cx, I2C_STARTF_FLAG) == RESET && --timeout);
  if (timeout == 0) return I2C_ERR_STEP_1;

  // Send address + write bit
  i2c_7bit_address_send(i2cx, address, I2C_DIRECTION_TRANSMIT);

  // Wait for address sent
  timeout = 0x1000;
  while (i2c_flag_get(i2cx, I2C_ADDR7F_FLAG) == RESET && --timeout);
  if (timeout == 0) return I2C_ERR_STEP_2;

  // Clear ADDR flag (read STS1 then STS2)
  i2c_flag_clear(i2cx, I2C_ADDR7F_FLAG);

  // Wait for TX buffer empty
  timeout = 0x1000;
  while (i2c_flag_get(i2cx, I2C_TDBE_FLAG) == RESET && --timeout);
  if (timeout == 0) return I2C_ERR_STEP_3;

  // Send data byte
  i2c_data_send(i2cx, data);

  // Wait for transfer complete
  timeout = 0x1000;
  while (i2c_flag_get(i2cx, I2C_TDC_FLAG) == RESET && --timeout);
  if (timeout == 0) return I2C_ERR_STEP_4;

  // Generate STOP
  i2c_stop_generate(i2cx);

  return I2C_OK;
}

// Simple polling-based I2C read
i2c_status_type i2c_read_byte(i2c_type* i2cx, uint8_t address, uint8_t* data)
{
  uint32_t timeout = 0x1000;

  // Wait until bus is free
  while (i2c_flag_get(i2cx, I2C_BUSYF_FLAG) == SET && --timeout);
  if (timeout == 0) return I2C_ERR_TIMEOUT;

  // Enable ACK
  i2c_ack_enable(i2cx, TRUE);

  // Generate START
  i2c_start_generate(i2cx);

  timeout = 0x1000;
  while (i2c_flag_get(i2cx, I2C_STARTF_FLAG) == RESET && --timeout);
  if (timeout == 0) return I2C_ERR_STEP_1;

  // Send address + read bit
  i2c_7bit_address_send(i2cx, address, I2C_DIRECTION_RECEIVE);

  timeout = 0x1000;
  while (i2c_flag_get(i2cx, I2C_ADDR7F_FLAG) == RESET && --timeout);
  if (timeout == 0) return I2C_ERR_STEP_2;

  // Disable ACK (for single byte receive)
  i2c_ack_enable(i2cx, FALSE);

  // Clear ADDR flag
  i2c_flag_clear(i2cx, I2C_ADDR7F_FLAG);

  // Generate STOP
  i2c_stop_generate(i2cx);

  // Wait for data
  timeout = 0x1000;
  while (i2c_flag_get(i2cx, I2C_RDBF_FLAG) == RESET && --timeout);
  if (timeout == 0) return I2C_ERR_STEP_3;

  // Read data
  *data = i2c_data_receive(i2cx);

  return I2C_OK;
}
```

---

## I2C Protocol Overview

### Write Operation (Master → Slave)

```
START → Address + W → ACK → Data0 → ACK → Data1 → ACK → ... → STOP
  ↓         ↓         ↓       ↓       ↓
Master   Master    Slave  Master   Slave
```

### Read Operation (Slave → Master)

```
START → Address + R → ACK → Data0 → ACK → Data1 → NACK → STOP
  ↓         ↓         ↓       ↓       ↓       ↓
Master   Master    Slave   Slave  Master  Master
```

### Memory Read (Combined Write/Read)

```
START → Addr + W → ACK → MemAddr → ACK → RESTART → Addr + R → ACK → Data → NACK → STOP
  ↓        ↓        ↓       ↓        ↓       ↓        ↓        ↓      ↓      ↓
Master  Master   Slave   Master   Slave  Master   Master   Slave  Slave  Master
```

---

## Troubleshooting

### Bus Stuck (SDA or SCL Low)

- **Cause**: Incomplete transfer, slave holding bus.
- **Solution**: Toggle SCL manually to release slave, or reset I2C peripheral.

```c
// Software reset
i2c_software_reset(I2C1, TRUE);
delay_us(10);
i2c_software_reset(I2C1, FALSE);
```

### ACKFAIL Error

- **Cause**: Slave not responding, wrong address, slave busy.
- **Solution**: Check slave address, verify slave is powered, check pull-up resistors.

### Arbitration Lost (Multi-Master)

- **Cause**: Another master took control of the bus.
- **Solution**: Retry transmission after detecting arbitration loss.

### No Pull-Up Resistors

- **Cause**: I2C requires external pull-up resistors (typically 4.7kΩ).
- **Solution**: Add pull-up resistors to VDD on SCL and SDA lines.

### Clock Stretching Issues

- **Cause**: Slave stretching clock too long.
- **Solution**: Increase timeout values, verify slave operation.

---

## Important Notes

1. **GPIO Configuration**: I2C pins must be configured as open-drain with alternate function.
2. **Pull-Up Resistors**: External 4.7kΩ pull-ups required on SCL and SDA lines.
3. **Clock Enable**: Enable I2C and GPIO clocks before configuration.
4. **Interrupt Priority**: Configure NVIC priority before enabling interrupts.
5. **DMA Channels**: Each I2C has specific DMA channel assignments.
6. **Address Format**: 7-bit addresses include R/W bit in LSB when sent on bus.
7. **Bus Recovery**: Implement bus recovery mechanism for robust applications.
8. **EEPROM Write Cycle**: Wait for EEPROM internal write cycle (typically 5-10ms).

