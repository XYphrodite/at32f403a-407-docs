# GPIO - General Purpose Input/Output

## Overview

The **General Purpose Input/Output (GPIO)** peripheral provides flexible digital I/O functionality for the AT32F403A/407 microcontrollers. Each GPIO port consists of 16 pins that can be individually configured as input, output, analog, or alternate function. The GPIO peripheral also includes an I/O Multiplexer (IOMUX) for pin remapping and external interrupt configuration.

| Feature | Specification |
|---------|---------------|
| **GPIO Ports** | GPIOA, GPIOB, GPIOC, GPIOD, GPIOE |
| **Pins per Port** | 16 (Pin0 - Pin15) |
| **Operating Modes** | Input, Output, Analog, Alternate Function (MUX) |
| **Output Types** | Push-Pull, Open-Drain |
| **Pull Configuration** | None, Pull-Up, Pull-Down |
| **Drive Strength** | Stronger, Moderate |
| **Special Features** | Huge Drive Mode, Write Protection, Event Output |
| **Pin Remapping** | Extensive IOMUX remapping options |

---

## Key Features

- **Four Operating Modes**:
  - **Input Mode**: Read external signals with configurable pull-up/pull-down.
  - **Output Mode**: Drive pins high or low with configurable output type.
  - **Analog Mode**: Connect to ADC/DAC or other analog peripherals.
  - **Alternate Function (MUX)**: Connect to peripheral signals (USART, SPI, I2C, etc.).

- **Flexible Output Configuration**:
  - **Push-Pull**: Active high and low drive.
  - **Open-Drain**: Active low drive only, external pull-up required for high.

- **Drive Strength Options**:
  - **Stronger**: Higher current sourcing/sinking capability.
  - **Moderate**: Lower current for reduced noise and power.
  - **Huge Drive Mode**: Maximum current capability for high-speed signals.

- **Write Protection**: Lock GPIO configuration to prevent accidental changes.

- **Atomic Bit Operations**: Dedicated set/clear registers for atomic bit manipulation.

- **Event Output**: Generate events on specific pins for synchronization.

- **Extensive Pin Remapping**: IOMUX allows flexible peripheral pin assignment.

---

## GPIO Configuration Types

### Mode Types

```c
typedef enum
{
  GPIO_MODE_INPUT   = 0x00, // GPIO input mode
  GPIO_MODE_OUTPUT  = 0x10, // GPIO output mode
  GPIO_MODE_MUX     = 0x08, // GPIO alternate function mode
  GPIO_MODE_ANALOG  = 0x03  // GPIO analog in/out mode
} gpio_mode_type;
```

### Output Types

```c
typedef enum
{
  GPIO_OUTPUT_PUSH_PULL  = 0x00, // Output push-pull
  GPIO_OUTPUT_OPEN_DRAIN = 0x04  // Output open-drain
} gpio_output_type;
```

### Pull Types

```c
typedef enum
{
  GPIO_PULL_NONE = 0x0004, // Floating for input, no pull for output
  GPIO_PULL_UP   = 0x0018, // Pull-up resistor enabled
  GPIO_PULL_DOWN = 0x0028  // Pull-down resistor enabled
} gpio_pull_type;
```

### Drive Strength Types

```c
typedef enum
{
  GPIO_DRIVE_STRENGTH_STRONGER  = 0x01, // Stronger sourcing/sinking strength
  GPIO_DRIVE_STRENGTH_MODERATE  = 0x02  // Moderate sourcing/sinking strength
} gpio_drive_type;
```

---

## Pin Definitions

```c
#define GPIO_PINS_0    0x0001  // Pin 0
#define GPIO_PINS_1    0x0002  // Pin 1
#define GPIO_PINS_2    0x0004  // Pin 2
#define GPIO_PINS_3    0x0008  // Pin 3
#define GPIO_PINS_4    0x0010  // Pin 4
#define GPIO_PINS_5    0x0020  // Pin 5
#define GPIO_PINS_6    0x0040  // Pin 6
#define GPIO_PINS_7    0x0080  // Pin 7
#define GPIO_PINS_8    0x0100  // Pin 8
#define GPIO_PINS_9    0x0200  // Pin 9
#define GPIO_PINS_10   0x0400  // Pin 10
#define GPIO_PINS_11   0x0800  // Pin 11
#define GPIO_PINS_12   0x1000  // Pin 12
#define GPIO_PINS_13   0x2000  // Pin 13
#define GPIO_PINS_14   0x4000  // Pin 14
#define GPIO_PINS_15   0x8000  // Pin 15
#define GPIO_PINS_ALL  0xFFFF  // All pins
```

---

## Register Overview

### Configuration Registers (CFGLR, CFGHR)

Configure pin mode, output type, and drive strength for pins 0-7 (CFGLR) and 8-15 (CFGHR).

| Bits per Pin | Field | Description |
|--------------|-------|-------------|
| `[1:0]` | IOMC | I/O Mode Configuration |
| `[3:2]` | IOFC | I/O Function Configuration |

### Input Data Register (IDT)

Read the current state of all input pins.

### Output Data Register (ODT)

Read/write the current output state of all pins.

### Set/Clear Register (SCR)

| Bits | Field | Description |
|------|-------|-------------|
| `[15:0]` | IOSB | Set output bits (write 1 to set) |
| `[31:16]` | IOCB | Clear output bits (write 1 to clear) |

### Clear Register (CLR)

Dedicated register to clear output bits (write 1 to clear).

### Write Protection Register (WPR)

Lock pin configuration to prevent changes until reset.

### Huge Drive Register (HDRV)

Enable/disable huge drive mode for individual pins.

---

## API Reference

### Initialization Functions

#### `void gpio_reset(gpio_type *gpio_x)`
Resets the specified GPIO port to its default state.

```c
gpio_reset(GPIOA); // Reset GPIOA to defaults
```

#### `void gpio_iomux_reset(void)`
Resets the IOMUX (remap, event control, EXINT configuration) to default values.

#### `void gpio_default_para_init(gpio_init_type *gpio_init_struct)`
Fills a `gpio_init_type` structure with default values.

Default values:
- `gpio_pins`: `GPIO_PINS_ALL`
- `gpio_mode`: `GPIO_MODE_INPUT`
- `gpio_out_type`: `GPIO_OUTPUT_PUSH_PULL`
- `gpio_pull`: `GPIO_PULL_NONE`
- `gpio_drive_strength`: `GPIO_DRIVE_STRENGTH_STRONGER`

#### `void gpio_init(gpio_type *gpio_x, gpio_init_type *gpio_init_struct)`
Initializes GPIO pins according to the specified structure.

```c
gpio_init_type gpio_init_struct;

gpio_default_para_init(&gpio_init_struct);
gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1;
gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
gpio_init_struct.gpio_pull = GPIO_PULL_NONE;

gpio_init(GPIOA, &gpio_init_struct);
```

---

### Input/Output Functions

#### `flag_status gpio_input_data_bit_read(gpio_type *gpio_x, uint16_t pins)`
Reads the input state of a specific pin.

- Returns: `SET` if pin is high, `RESET` if pin is low.

```c
if (gpio_input_data_bit_read(GPIOA, GPIO_PINS_0) == SET)
{
  // PA0 is high
}
```

#### `uint16_t gpio_input_data_read(gpio_type *gpio_x)`
Reads the entire input data register (all 16 pins).

```c
uint16_t port_value = gpio_input_data_read(GPIOA);
```

#### `flag_status gpio_output_data_bit_read(gpio_type *gpio_x, uint16_t pins)`
Reads the current output state of a specific pin.

#### `uint16_t gpio_output_data_read(gpio_type *gpio_x)`
Reads the entire output data register.

---

### Output Control Functions

#### `void gpio_bits_set(gpio_type *gpio_x, uint16_t pins)`
Sets specified pins high (atomic operation).

```c
gpio_bits_set(GPIOA, GPIO_PINS_0 | GPIO_PINS_1); // Set PA0 and PA1 high
```

#### `void gpio_bits_reset(gpio_type *gpio_x, uint16_t pins)`
Sets specified pins low (atomic operation).

```c
gpio_bits_reset(GPIOA, GPIO_PINS_0); // Set PA0 low
```

#### `void gpio_bits_toggle(gpio_type *gpio_x, uint16_t pins)`
Toggles specified pins.

```c
gpio_bits_toggle(GPIOA, GPIO_PINS_0); // Toggle PA0
```

#### `void gpio_bits_write(gpio_type *gpio_x, uint16_t pins, confirm_state bit_state)`
Sets or clears specified pins based on `bit_state`.

```c
gpio_bits_write(GPIOA, GPIO_PINS_0, TRUE);  // Set PA0 high
gpio_bits_write(GPIOA, GPIO_PINS_0, FALSE); // Set PA0 low
```

#### `void gpio_port_write(gpio_type *gpio_x, uint16_t port_value)`
Writes a 16-bit value directly to the output data register.

```c
gpio_port_write(GPIOA, 0x00FF); // Set PA0-PA7 high, PA8-PA15 low
```

---

### Advanced Functions

#### `void gpio_pin_wp_config(gpio_type *gpio_x, uint16_t pins)`
Enables write protection for specified pins. Once locked, the configuration cannot be changed until reset.

```c
gpio_pin_wp_config(GPIOA, GPIO_PINS_0 | GPIO_PINS_1); // Lock PA0 and PA1 configuration
```

#### `void gpio_pins_huge_driven_config(gpio_type *gpio_x, uint16_t pins, confirm_state new_state)`
Enables or disables huge drive mode for maximum current capability.

```c
gpio_pins_huge_driven_config(GPIOA, GPIO_PINS_0, TRUE); // Enable huge drive on PA0
```

---

### Event Output Functions

#### `void gpio_event_output_config(gpio_port_source_type gpio_port_source, gpio_pins_source_type gpio_pin_source)`
Configures the pin used for event output.

```c
gpio_event_output_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE0);
```

#### `void gpio_event_output_enable(confirm_state new_state)`
Enables or disables event output.

---

### Pin Remapping Functions

#### `void gpio_pin_remap_config(uint32_t gpio_remap, confirm_state new_state)`
Configures pin remapping for peripheral signals.

```c
// Remap USART1 TX to PB6, RX to PB7
gpio_pin_remap_config(USART1_MUX, TRUE);
```

#### `void gpio_exint_line_config(gpio_port_source_type gpio_port_source, gpio_pins_source_type gpio_pin_source)`
Configures the GPIO port source for EXINT line.

```c
// Configure PA0 as EXINT0 source
gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE0);
```

---

## Common Pin Remap Options

### Debug Interface (SWJ-DP) Remapping

| Remap Option | Description | Released Pins |
|--------------|-------------|---------------|
| `SWJTAG_MUX_001` | Full SWJ (JTAG-DP + SW-DP) without JTRST | PB4 |
| `SWJTAG_MUX_010` | JTAG-DP disabled, SW-DP enabled | PA15, PB3, PB4 |
| `SWJTAG_MUX_100` | Full SWJ disabled | PA13, PA14, PA15, PB3, PB4 |

### USART Remapping

| Peripheral | Default Pins | Remapped Pins | Remap Option |
|------------|--------------|---------------|--------------|
| USART1 | PA9 (TX), PA10 (RX) | PB6 (TX), PB7 (RX) | `USART1_MUX` |
| USART2 | PA2 (TX), PA3 (RX) | PD5 (TX), PD6 (RX) | `USART2_MUX` |
| USART3 | PB10 (TX), PB11 (RX) | PC10 (TX), PC11 (RX) | `USART3_MUX_01` |
| USART3 | PB10 (TX), PB11 (RX) | PD8 (TX), PD9 (RX) | `USART3_MUX_11` |

### SPI Remapping

| Peripheral | Default Pins | Remapped Pins | Remap Option |
|------------|--------------|---------------|--------------|
| SPI1 | PA4 (CS), PA5 (SCK), PA6 (MISO), PA7 (MOSI) | PA15 (CS), PB3 (SCK), PB4 (MISO), PB5 (MOSI) | `SPI1_MUX_01` |

### Timer Remapping

| Peripheral | Remap Option | Pin Configuration |
|------------|--------------|-------------------|
| TMR1 | `TMR1_MUX_01` | CH1(PA8), CH2(PA9), CH3(PA10), CH4(PA11) |
| TMR1 | `TMR1_MUX_11` | CH1(PE9), CH2(PE11), CH3(PE13), CH4(PE14) |
| TMR2 | `TMR2_MUX_01` | CH1(PA15), CH2(PB3), CH3(PA2), CH4(PA3) |
| TMR2 | `TMR2_MUX_10` | CH1(PA0), CH2(PA1), CH3(PB10), CH4(PB11) |
| TMR3 | `TMR3_MUX_10` | CH1(PB4), CH2(PB5), CH3(PB0), CH4(PB1) |
| TMR3 | `TMR3_MUX_11` | CH1(PC6), CH2(PC7), CH3(PC8), CH4(PC9) |
| TMR4 | `TMR4_MUX` | CH1(PD12), CH2(PD13), CH3(PD14), CH4(PD15) |

### CAN Remapping

| Peripheral | Default Pins | Remapped Pins | Remap Option |
|------------|--------------|---------------|--------------|
| CAN1 | PA11 (RX), PA12 (TX) | PB8 (RX), PB9 (TX) | `CAN_MUX_10` |
| CAN1 | PA11 (RX), PA12 (TX) | PD0 (RX), PD1 (TX) | `CAN_MUX_11` |

### I2C Remapping

| Peripheral | Default Pins | Remapped Pins | Remap Option |
|------------|--------------|---------------|--------------|
| I2C1 | PB6 (SCL), PB7 (SDA) | PB8 (SCL), PB9 (SDA) | `I2C1_MUX` |

---

## Usage Examples

### 1. Basic GPIO Output (LED Toggle)

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

void gpio_output_config(void)
{
  gpio_init_type gpio_init_struct;

  // Enable GPIOA clock
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);

  // Configure PA0 as output push-pull
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_0;
  gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
}

int main(void)
{
  system_clock_config();
  gpio_output_config();

  while (1)
  {
    gpio_bits_toggle(GPIOA, GPIO_PINS_0);
    delay_ms(500);
  }
}
```

### 2. GPIO Input with Pull-Up

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

void gpio_input_config(void)
{
  gpio_init_type gpio_init_struct;

  // Enable GPIOA and GPIOB clocks
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  // Configure PA0 as input with pull-up (button)
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_0;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);

  // Configure PB0 as output (LED)
  gpio_init_struct.gpio_pins = GPIO_PINS_0;
  gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOB, &gpio_init_struct);
}

int main(void)
{
  system_clock_config();
  gpio_input_config();

  while (1)
  {
    // Read button state (active low with pull-up)
    if (gpio_input_data_bit_read(GPIOA, GPIO_PINS_0) == RESET)
    {
      gpio_bits_set(GPIOB, GPIO_PINS_0);   // LED on
    }
    else
    {
      gpio_bits_reset(GPIOB, GPIO_PINS_0); // LED off
    }
  }
}
```

### 3. High-Speed GPIO Toggle (Direct Register Access)

This example demonstrates maximum toggle speed using direct register access.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

void gpio_fast_config(void)
{
  gpio_init_type gpio_init_struct;

  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);

  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_1;
  gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
}

int main(void)
{
  system_clock_config();
  gpio_fast_config();

  while (1)
  {
    // Direct register access for maximum speed
    GPIOA->scr = GPIO_PINS_1; // Set PA1 high
    GPIOA->clr = GPIO_PINS_1; // Set PA1 low

    GPIOA->scr = GPIO_PINS_1; // Set PA1 high
    GPIOA->clr = GPIO_PINS_1; // Set PA1 low

    // ... repeat for continuous toggling
  }
}
```

### 4. SWJ-DP Pin Remapping (Release Debug Pins)

This example releases JTAG pins for GPIO use while keeping SWD functional.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

void release_jtag_pins(void)
{
  gpio_init_type gpio_init_struct;

  // Enable required clocks
  crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  // Disable JTAG, keep SWD enabled (releases PA15, PB3, PB4)
  gpio_pin_remap_config(SWJTAG_MUX_010, TRUE);

  // Now configure PA15, PB3, PB4 as outputs
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_15;
  gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init(GPIOA, &gpio_init_struct);

  gpio_init_struct.gpio_pins = GPIO_PINS_3 | GPIO_PINS_4;
  gpio_init(GPIOB, &gpio_init_struct);
}

void disable_all_debug_pins(void)
{
  gpio_init_type gpio_init_struct;

  crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  // Disable both JTAG and SWD (releases PA13, PA14, PA15, PB3, PB4)
  // WARNING: After this, debug probe cannot connect!
  gpio_pin_remap_config(SWJTAG_MUX_100, TRUE);

  // Configure all released pins as outputs
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_13 | GPIO_PINS_14 | GPIO_PINS_15;
  gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init(GPIOA, &gpio_init_struct);

  gpio_init_struct.gpio_pins = GPIO_PINS_3 | GPIO_PINS_4;
  gpio_init(GPIOB, &gpio_init_struct);
}

int main(void)
{
  system_clock_config();
  at32_board_init();

  // Wait for button press before disabling debug
  while (at32_button_press() != USER_BUTTON);

  // Release JTAG pins (keep SWD)
  release_jtag_pins();

  at32_led_on(LED3); // Indicate remap complete

  while (1)
  {
    // Toggle released pins
    gpio_bits_toggle(GPIOA, GPIO_PINS_15);
    delay_us(200);
    gpio_bits_toggle(GPIOB, GPIO_PINS_3);
    delay_us(200);
    gpio_bits_toggle(GPIOB, GPIO_PINS_4);
    delay_us(200);
  }
}
```

### 5. Alternate Function Configuration (USART TX/RX)

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

void usart_gpio_config(void)
{
  gpio_init_type gpio_init_struct;

  // Enable clocks
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART1_PERIPH_CLOCK, TRUE);

  // Configure PA9 as USART1_TX (alternate function push-pull)
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_9;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init(GPIOA, &gpio_init_struct);

  // Configure PA10 as USART1_RX (input with pull-up)
  gpio_init_struct.gpio_pins = GPIO_PINS_10;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);
}
```

### 6. Open-Drain Output (I2C Style)

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

void open_drain_config(void)
{
  gpio_init_type gpio_init_struct;

  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  // Configure PB6, PB7 as open-drain outputs with pull-up
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_6 | GPIO_PINS_7;
  gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_OPEN_DRAIN;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOB, &gpio_init_struct);
}

// Bit-bang I2C example
void i2c_start(void)
{
  gpio_bits_set(GPIOB, GPIO_PINS_6 | GPIO_PINS_7);   // SDA and SCL high
  delay_us(5);
  gpio_bits_reset(GPIOB, GPIO_PINS_7);               // SDA low (start condition)
  delay_us(5);
  gpio_bits_reset(GPIOB, GPIO_PINS_6);               // SCL low
}
```

### 7. GPIO Port Write (Parallel Data Output)

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

void parallel_output_config(void)
{
  gpio_init_type gpio_init_struct;

  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  // Configure PB0-PB7 as outputs (8-bit data bus)
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1 | GPIO_PINS_2 | GPIO_PINS_3 |
                               GPIO_PINS_4 | GPIO_PINS_5 | GPIO_PINS_6 | GPIO_PINS_7;
  gpio_init_struct.gpio_mode = GPIO_MODE_OUTPUT;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init(GPIOB, &gpio_init_struct);
}

void write_parallel_data(uint8_t data)
{
  // Read current port value, mask lower 8 bits, OR with new data
  uint16_t port_value = gpio_output_data_read(GPIOB);
  port_value = (port_value & 0xFF00) | data;
  gpio_port_write(GPIOB, port_value);
}

int main(void)
{
  system_clock_config();
  parallel_output_config();

  uint8_t counter = 0;
  while (1)
  {
    write_parallel_data(counter++);
    delay_ms(100);
  }
}
```

### 8. External Interrupt Configuration

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

void exint_gpio_config(void)
{
  gpio_init_type gpio_init_struct;
  exint_init_type exint_init_struct;

  // Enable clocks
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);

  // Configure PA0 as input with pull-up (button)
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_0;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOA, &gpio_init_struct);

  // Select PA0 as EXINT0 source
  gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE0);

  // Configure EXINT0 for falling edge trigger
  exint_default_para_init(&exint_init_struct);
  exint_init_struct.line_enable = TRUE;
  exint_init_struct.line_mode = EXINT_LINE_INTERRUPUT;
  exint_init_struct.line_select = EXINT_LINE_0;
  exint_init_struct.line_polarity = EXINT_TRIGGER_FALLING_EDGE;
  exint_init(&exint_init_struct);

  // Enable EXINT0 interrupt in NVIC
  nvic_irq_enable(EXINT0_IRQn, 1, 0);
}

void EXINT0_IRQHandler(void)
{
  if (exint_flag_get(EXINT_LINE_0) != RESET)
  {
    // Handle button press
    gpio_bits_toggle(GPIOB, GPIO_PINS_0); // Toggle LED

    // Clear interrupt flag
    exint_flag_clear(EXINT_LINE_0);
  }
}
```

---

## Troubleshooting

### Pin Not Responding

- **Enable GPIO clock**: Ensure `crm_periph_clock_enable(CRM_GPIOx_PERIPH_CLOCK, TRUE)` is called.
- **Check mode configuration**: Verify the pin is configured for the correct mode.
- **Check alternate function**: If using peripherals, ensure pin is in `GPIO_MODE_MUX`.

### Debug Probe Cannot Connect

- **Avoid disabling SWD unintentionally**: Use `SWJTAG_MUX_010` to keep SWD while releasing JTAG.
- **Recovery**: If SWD is disabled, use boot mode pins to enter bootloader and reflash.

### Unexpected Pin State

- **Check pull configuration**: Input pins without pull may float.
- **Check write protection**: `gpio_pin_wp_config()` locks configuration until reset.
- **Check remapping**: Some pins may be remapped to different functions.

### Low Output Current

- **Enable huge drive mode**: Use `gpio_pins_huge_driven_config()` for high-current applications.
- **Check drive strength**: Use `GPIO_DRIVE_STRENGTH_STRONGER` for higher current.

---

## Related Peripherals

- **CRM**: Clock and Reset Management - enables GPIO clocks.
- **EXINT**: External Interrupt - connects GPIO to interrupt controller.
- **IOMUX**: I/O Multiplexer - handles pin remapping.

---

## Important Notes

1. **Enable clock before configuration**: GPIO clock must be enabled before any configuration.
2. **IOMUX clock for remapping**: Enable `CRM_IOMUX_PERIPH_CLOCK` before using remapping functions.
3. **Atomic operations**: Use `gpio_bits_set()` and `gpio_bits_reset()` for atomic bit manipulation.
4. **Debug pins are special**: PA13/PA14 (SWD) and PA15/PB3/PB4 (JTAG) require remapping to use as GPIO.
5. **Write protection is permanent**: Once enabled, write protection cannot be disabled until reset.
6. **Open-drain needs pull-up**: Open-drain outputs require external or internal pull-up for high state.

