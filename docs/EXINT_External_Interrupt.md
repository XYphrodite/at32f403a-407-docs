# EXINT - External Interrupt/Event Controller

## Overview

The AT32F403A/407 External Interrupt/Event Controller (EXINT) manages **20 interrupt/event lines** for external and internal event sources. It provides configurable edge detection, software triggering, and can wake the CPU from low-power modes.

### Key Features

| Feature | Specification |
|---------|---------------|
| **Interrupt Lines** | 20 lines (0-19) |
| **GPIO Lines** | Lines 0-15 (mapped from any GPIO port) |
| **Internal Lines** | Lines 16-19 (PVM, RTC, USB, COMP) |
| **Trigger Modes** | Rising edge, Falling edge, Both edges |
| **Output Modes** | Interrupt request or Event pulse |
| **Software Trigger** | Generate interrupt/event by software |
| **Wake-up** | Can wake CPU from Sleep/Stop modes |

---

## Block Diagram

```
                    ┌────────────────────────────────────────────────┐
                    │           EXINT Controller                      │
                    │                                                 │
  GPIO Pin ─────────┤──┐                                             │
  (PA0-PG15)        │  │     ┌───────────────┐                       │
                    │  ├────►│ Edge Detector │                       │
  Software ─────────┤──┘     │ (Rising/Fall) │                       │
  Trigger (SWTRG)   │        └───────┬───────┘                       │
                    │                │                               │
                    │        ┌───────▼───────┐     ┌──────────┐      │
                    │        │  Pending Bit  │────►│ NVIC IRQ │──────┼──► CPU
                    │        │   (INTSTS)    │     └──────────┘      │
                    │        └───────┬───────┘                       │
                    │                │                               │
                    │        ┌───────▼───────┐                       │
                    │        │  Event Pulse  │─────────────────────────► Peripherals
                    │        │   (EVTEN)     │                       │   (Wake-up)
                    │        └───────────────┘                       │
                    └────────────────────────────────────────────────┘
```

---

## Interrupt Line Mapping

### GPIO Lines (0-15)

Each EXINT line 0-15 can be connected to any GPIO port's corresponding pin:

```
EXINT_LINE_0  ←── PA0, PB0, PC0, PD0, PE0, PF0, PG0 (selectable)
EXINT_LINE_1  ←── PA1, PB1, PC1, PD1, PE1, PF1, PG1 (selectable)
...
EXINT_LINE_15 ←── PA15, PB15, PC15, PD15, PE15, PF15, PG15 (selectable)
```

### Internal Lines (16-19)

| Line | Source | Description |
|------|--------|-------------|
| **EXINT_LINE_16** | PVM | Programmable Voltage Monitor output |
| **EXINT_LINE_17** | RTC Alarm | RTC alarm event |
| **EXINT_LINE_18** | USB FS | USB Device wakeup from suspend |
| **EXINT_LINE_19** | COMP1 | Comparator 1 output |

---

## Register Map

| Register | Offset | Description |
|----------|--------|-------------|
| **INTEN** | 0x00 | Interrupt enable register |
| **EVTEN** | 0x04 | Event enable register |
| **POLCFG1** | 0x08 | Rising edge trigger selection |
| **POLCFG2** | 0x0C | Falling edge trigger selection |
| **SWTRG** | 0x10 | Software trigger register |
| **INTSTS** | 0x14 | Interrupt/event pending status |

### Register Bit Layout

All registers use bits [19:0] for lines 0-19:

```
┌────────────────────────────────────────────┐
│ 31     20 │ 19  18  17  16 │ 15 ... 1   0 │
├───────────┼────────────────┼──────────────┤
│  Reserved │ COMP USB RTC PVM│ GPIO Lines  │
└────────────────────────────────────────────┘
```

---

## Line Definitions

```c
#define EXINT_LINE_NONE    0x000000  // No line selected
#define EXINT_LINE_0       0x000001  // GPIO pin x0
#define EXINT_LINE_1       0x000002  // GPIO pin x1
#define EXINT_LINE_2       0x000004  // GPIO pin x2
#define EXINT_LINE_3       0x000008  // GPIO pin x3
#define EXINT_LINE_4       0x000010  // GPIO pin x4
#define EXINT_LINE_5       0x000020  // GPIO pin x5
#define EXINT_LINE_6       0x000040  // GPIO pin x6
#define EXINT_LINE_7       0x000080  // GPIO pin x7
#define EXINT_LINE_8       0x000100  // GPIO pin x8
#define EXINT_LINE_9       0x000200  // GPIO pin x9
#define EXINT_LINE_10      0x000400  // GPIO pin x10
#define EXINT_LINE_11      0x000800  // GPIO pin x11
#define EXINT_LINE_12      0x001000  // GPIO pin x12
#define EXINT_LINE_13      0x002000  // GPIO pin x13
#define EXINT_LINE_14      0x004000  // GPIO pin x14
#define EXINT_LINE_15      0x008000  // GPIO pin x15
#define EXINT_LINE_16      0x010000  // PVM output
#define EXINT_LINE_17      0x020000  // RTC alarm
#define EXINT_LINE_18      0x040000  // USB wakeup
#define EXINT_LINE_19      0x080000  // COMP1 output
```

---

## Line Modes

### Interrupt vs Event Mode

```c
typedef enum
{
  EXINT_LINE_INTERRUPT = 0x00,  // Generate NVIC interrupt
  EXINT_LINE_EVENT     = 0x01   // Generate event pulse (no CPU interrupt)
} exint_line_mode_type;
```

| Mode | CPU Interrupt | Event Pulse | Use Case |
|------|---------------|-------------|----------|
| **Interrupt** | Yes | No | Normal interrupt handling |
| **Event** | No | Yes | Wake from sleep, trigger DMA |

### Trigger Polarity

```c
typedef enum
{
  EXINT_TRIGGER_RISING_EDGE  = 0x00,  // Trigger on rising edge
  EXINT_TRIGGER_FALLING_EDGE = 0x01,  // Trigger on falling edge
  EXINT_TRIGGER_BOTH_EDGE    = 0x02   // Trigger on both edges
} exint_polarity_config_type;
```

---

## NVIC IRQ Mapping

### Individual Handlers (Lines 0-4)

| Line | IRQ Handler | IRQn |
|------|-------------|------|
| EXINT_LINE_0 | `EXINT0_IRQHandler` | `EXINT0_IRQn` |
| EXINT_LINE_1 | `EXINT1_IRQHandler` | `EXINT1_IRQn` |
| EXINT_LINE_2 | `EXINT2_IRQHandler` | `EXINT2_IRQn` |
| EXINT_LINE_3 | `EXINT3_IRQHandler` | `EXINT3_IRQn` |
| EXINT_LINE_4 | `EXINT4_IRQHandler` | `EXINT4_IRQn` |

### Grouped Handlers (Lines 5-15)

| Lines | IRQ Handler | IRQn |
|-------|-------------|------|
| EXINT_LINE_5..9 | `EXINT9_5_IRQHandler` | `EXINT9_5_IRQn` |
| EXINT_LINE_10..15 | `EXINT15_10_IRQHandler` | `EXINT15_10_IRQn` |

> **Note**: Grouped handlers must check individual flags to determine which line triggered.

---

## Initialization Structure

```c
typedef struct
{
  exint_line_mode_type      line_mode;     // Interrupt or Event mode
  uint32_t                  line_select;   // Line(s) to configure (can OR multiple)
  exint_polarity_config_type line_polarity; // Edge trigger selection
  confirm_state             line_enable;   // Enable or disable
} exint_init_type;
```

---

## API Reference

### Initialization Functions

#### `exint_reset()`
Reset all EXINT registers to default state.

```c
void exint_reset(void);
```

#### `exint_default_para_init()`
Initialize structure with default values.

```c
void exint_default_para_init(exint_init_type *exint_struct);
```

**Default values**:
- `line_enable` = FALSE
- `line_select` = EXINT_LINE_NONE
- `line_polarity` = EXINT_TRIGGER_FALLING_EDGE
- `line_mode` = EXINT_LINE_EVENT

#### `exint_init()`
Configure EXINT line(s) with specified parameters.

```c
void exint_init(exint_init_type *exint_struct);
```

### Enable/Disable Functions

#### `exint_interrupt_enable()`
Enable or disable interrupt for specified line(s).

```c
void exint_interrupt_enable(uint32_t exint_line, confirm_state new_state);
```

#### `exint_event_enable()`
Enable or disable event for specified line(s).

```c
void exint_event_enable(uint32_t exint_line, confirm_state new_state);
```

### Flag Functions

#### `exint_flag_get()`
Check if flag is set for a line.

```c
flag_status exint_flag_get(uint32_t exint_line);
```

#### `exint_interrupt_flag_get()`
Check if interrupt flag is set (flag AND interrupt enabled).

```c
flag_status exint_interrupt_flag_get(uint32_t exint_line);
```

#### `exint_flag_clear()`
Clear pending flag for specified line(s).

```c
void exint_flag_clear(uint32_t exint_line);
```

### Software Trigger

#### `exint_software_interrupt_event_generate()`
Generate software interrupt or event.

```c
void exint_software_interrupt_event_generate(uint32_t exint_line);
```

---

## Usage Examples

### Example 1: Basic GPIO Interrupt (Rising Edge)

Configure PA0 to generate interrupt on rising edge.

```c
#include "at32f403a_407.h"

void exint_gpio_interrupt_example(void)
{
    exint_init_type exint_init_struct;
    
    // Enable clocks
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Map PA0 to EXINT line 0
    gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE0);
    
    // Configure EXINT line 0
    exint_default_para_init(&exint_init_struct);
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_select = EXINT_LINE_0;
    exint_init_struct.line_polarity = EXINT_TRIGGER_RISING_EDGE;
    exint_init(&exint_init_struct);
    
    // Enable NVIC interrupt
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    nvic_irq_enable(EXINT0_IRQn, 1, 0);
}

void EXINT0_IRQHandler(void)
{
    if(exint_interrupt_flag_get(EXINT_LINE_0) != RESET)
    {
        // Handle interrupt
        // ... your code here ...
        
        exint_flag_clear(EXINT_LINE_0);
    }
}
```

### Example 2: Button with Falling Edge (Debounced)

Configure button input with falling edge trigger.

```c
#include "at32f403a_407.h"

void button_interrupt_example(void)
{
    gpio_init_type gpio_init_struct;
    exint_init_type exint_init_struct;
    
    // Enable clocks
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Configure PA0 as input with pull-up
    gpio_init_struct.gpio_pins = GPIO_PINS_0;
    gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
    gpio_init_struct.gpio_pull = GPIO_PULL_UP;
    gpio_init(GPIOA, &gpio_init_struct);
    
    // Map PA0 to EXINT line 0
    gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE0);
    
    // Configure for falling edge (button press)
    exint_default_para_init(&exint_init_struct);
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_select = EXINT_LINE_0;
    exint_init_struct.line_polarity = EXINT_TRIGGER_FALLING_EDGE;
    exint_init(&exint_init_struct);
    
    nvic_irq_enable(EXINT0_IRQn, 2, 0);
}

volatile uint32_t last_press_time = 0;
#define DEBOUNCE_MS 50

void EXINT0_IRQHandler(void)
{
    if(exint_interrupt_flag_get(EXINT_LINE_0) != RESET)
    {
        uint32_t current_time = get_system_tick();  // Your tick function
        
        // Simple debounce
        if((current_time - last_press_time) > DEBOUNCE_MS)
        {
            // Valid button press
            button_pressed_callback();
            last_press_time = current_time;
        }
        
        exint_flag_clear(EXINT_LINE_0);
    }
}
```

### Example 3: Both Edge Detection (Encoder)

Detect both rising and falling edges for rotary encoder.

```c
#include "at32f403a_407.h"

volatile int32_t encoder_count = 0;

void encoder_interrupt_example(void)
{
    gpio_init_type gpio_init_struct;
    exint_init_type exint_init_struct;
    
    // Enable clocks
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Configure PA0 (Channel A) and PA1 (Channel B) as inputs
    gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1;
    gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
    gpio_init_struct.gpio_pull = GPIO_PULL_UP;
    gpio_init(GPIOA, &gpio_init_struct);
    
    // Map PA0 to EXINT line 0
    gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE0);
    
    // Configure for both edges
    exint_default_para_init(&exint_init_struct);
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_select = EXINT_LINE_0;
    exint_init_struct.line_polarity = EXINT_TRIGGER_BOTH_EDGE;
    exint_init(&exint_init_struct);
    
    nvic_irq_enable(EXINT0_IRQn, 1, 0);
}

void EXINT0_IRQHandler(void)
{
    if(exint_interrupt_flag_get(EXINT_LINE_0) != RESET)
    {
        // Read channel B to determine direction
        if(gpio_input_data_bit_read(GPIOA, GPIO_PINS_1))
        {
            encoder_count++;   // Clockwise
        }
        else
        {
            encoder_count--;   // Counter-clockwise
        }
        
        exint_flag_clear(EXINT_LINE_0);
    }
}
```

### Example 4: Software Trigger

Generate EXINT interrupt from software (e.g., from timer ISR).

```c
#include "at32f403a_407.h"

void software_trigger_example(void)
{
    exint_init_type exint_init_struct;
    
    // Enable IOMUX clock (required for EXINT)
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
    
    // Configure EXINT line 4 for software trigger
    // Note: No GPIO mapping needed for software trigger
    exint_default_para_init(&exint_init_struct);
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_select = EXINT_LINE_4;
    exint_init_struct.line_polarity = EXINT_TRIGGER_RISING_EDGE;
    exint_init(&exint_init_struct);
    
    nvic_irq_enable(EXINT4_IRQn, 1, 0);
}

// Called from Timer ISR
void TMR1_OVF_TMR10_IRQHandler(void)
{
    if(tmr_interrupt_flag_get(TMR1, TMR_OVF_FLAG) != RESET)
    {
        // Generate software interrupt on EXINT line 4
        exint_software_interrupt_event_generate(EXINT_LINE_4);
        
        tmr_flag_clear(TMR1, TMR_OVF_FLAG);
    }
}

void EXINT4_IRQHandler(void)
{
    if(exint_interrupt_flag_get(EXINT_LINE_4) != RESET)
    {
        // Handle software-triggered interrupt
        process_periodic_task();
        
        exint_flag_clear(EXINT_LINE_4);
    }
}
```

### Example 5: Multiple Lines with Grouped Handler

Handle lines 5-9 in a single ISR.

```c
#include "at32f403a_407.h"

void multiple_lines_example(void)
{
    exint_init_type exint_init_struct;
    
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Map PA5, PA6, PA7 to EXINT lines
    gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE5);
    gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE6);
    gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE7);
    
    // Configure all three lines at once
    exint_default_para_init(&exint_init_struct);
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_select = EXINT_LINE_5 | EXINT_LINE_6 | EXINT_LINE_7;
    exint_init_struct.line_polarity = EXINT_TRIGGER_FALLING_EDGE;
    exint_init(&exint_init_struct);
    
    // Single NVIC enable for lines 5-9
    nvic_irq_enable(EXINT9_5_IRQn, 1, 0);
}

void EXINT9_5_IRQHandler(void)
{
    // Check each line individually
    if(exint_interrupt_flag_get(EXINT_LINE_5) != RESET)
    {
        handle_line5_event();
        exint_flag_clear(EXINT_LINE_5);
    }
    
    if(exint_interrupt_flag_get(EXINT_LINE_6) != RESET)
    {
        handle_line6_event();
        exint_flag_clear(EXINT_LINE_6);
    }
    
    if(exint_interrupt_flag_get(EXINT_LINE_7) != RESET)
    {
        handle_line7_event();
        exint_flag_clear(EXINT_LINE_7);
    }
}
```

### Example 6: Event Mode (Wake from Sleep)

Use event mode to wake CPU without interrupt overhead.

```c
#include "at32f403a_407.h"

void wakeup_event_example(void)
{
    exint_init_type exint_init_struct;
    
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Map wakeup pin
    gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOA, GPIO_PINS_SOURCE0);
    
    // Configure as EVENT (not interrupt)
    exint_default_para_init(&exint_init_struct);
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_EVENT;  // Event mode
    exint_init_struct.line_select = EXINT_LINE_0;
    exint_init_struct.line_polarity = EXINT_TRIGGER_RISING_EDGE;
    exint_init(&exint_init_struct);
    
    // No NVIC needed for event mode
}

void enter_sleep_with_wakeup(void)
{
    // Configure event mode (already done above)
    
    // Enter sleep - will wake on EXINT event
    __WFE();  // Wait For Event
    
    // CPU wakes here when PA0 rising edge occurs
    // No interrupt handler executed
}
```

### Example 7: RTC Alarm Wakeup

Configure RTC alarm to wake from low-power mode.

```c
#include "at32f403a_407.h"

void rtc_alarm_wakeup_example(void)
{
    exint_init_type exint_init_struct;
    
    // Configure EXINT line 17 for RTC alarm
    exint_default_para_init(&exint_init_struct);
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_select = EXINT_LINE_17;
    exint_init_struct.line_polarity = EXINT_TRIGGER_RISING_EDGE;
    exint_init(&exint_init_struct);
    
    nvic_irq_enable(RTCAlarm_IRQn, 0, 0);
}

void RTCAlarm_IRQHandler(void)
{
    if(exint_interrupt_flag_get(EXINT_LINE_17) != RESET)
    {
        // Handle RTC alarm
        rtc_alarm_callback();
        
        exint_flag_clear(EXINT_LINE_17);
    }
}
```

---

## GPIO Port Selection

Use `gpio_exint_line_config()` to select which GPIO port drives each EXINT line:

```c
// Select PB3 for EXINT line 3
gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOB, GPIO_PINS_SOURCE3);

// Select PC5 for EXINT line 5
gpio_exint_line_config(GPIO_PORT_SOURCE_GPIOC, GPIO_PINS_SOURCE5);
```

### Port Source Constants

| Constant | Port |
|----------|------|
| `GPIO_PORT_SOURCE_GPIOA` | Port A |
| `GPIO_PORT_SOURCE_GPIOB` | Port B |
| `GPIO_PORT_SOURCE_GPIOC` | Port C |
| `GPIO_PORT_SOURCE_GPIOD` | Port D |
| `GPIO_PORT_SOURCE_GPIOE` | Port E |
| `GPIO_PORT_SOURCE_GPIOF` | Port F |
| `GPIO_PORT_SOURCE_GPIOG` | Port G |

### Pin Source Constants

| Constant | Pin Number |
|----------|------------|
| `GPIO_PINS_SOURCE0` | Pin 0 |
| `GPIO_PINS_SOURCE1` | Pin 1 |
| ... | ... |
| `GPIO_PINS_SOURCE15` | Pin 15 |

---

## Interrupt vs Event Comparison

| Feature | Interrupt Mode | Event Mode |
|---------|---------------|------------|
| **CPU Execution** | ISR runs | No ISR |
| **NVIC Required** | Yes | No |
| **Wake from Sleep** | Yes | Yes |
| **Latency** | Higher (ISR overhead) | Lower (immediate) |
| **Use Case** | Process data in ISR | Fast wake-up, DMA trigger |

---

## Troubleshooting

### Interrupt Not Triggering

| Issue | Solution |
|-------|----------|
| IOMUX clock not enabled | `crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE)` |
| GPIO not mapped | Call `gpio_exint_line_config()` |
| NVIC not enabled | Call `nvic_irq_enable()` with correct IRQn |
| Wrong polarity | Check signal levels match trigger setting |
| Line not enabled | Set `line_enable = TRUE` |

### Interrupt Fires Continuously

| Issue | Solution |
|-------|----------|
| Flag not cleared | Call `exint_flag_clear()` in ISR |
| Noise on input | Add hardware debounce or software filter |
| Wrong edge setting | Use `EXINT_TRIGGER_BOTH_EDGE` if signal bounces |

### Multiple Interrupts from One Event

| Issue | Solution |
|-------|----------|
| Contact bounce | Add RC filter on input |
| Noisy signal | Use Schmitt trigger input |
| Software bounce | Add debounce delay in ISR |

### Grouped Handler Issues

| Issue | Solution |
|-------|----------|
| Not all lines handled | Check all possible flags in ISR |
| Wrong line cleared | Use correct `EXINT_LINE_x` constant |

---

## Best Practices

1. **Always clear flags** at the end of ISR (not beginning)
2. **Use `exint_interrupt_flag_get()`** instead of `exint_flag_get()` in ISRs
3. **Configure GPIO as input** before setting up EXINT
4. **Enable IOMUX clock** before configuring GPIO-to-EXINT mapping
5. **Use event mode** for simple wake-up without ISR overhead
6. **Implement debouncing** for mechanical switches
7. **Keep ISRs short** - defer processing to main loop if possible

---

## Related Peripherals

| Peripheral | Relationship |
|------------|--------------|
| **GPIO** | Source for EXINT lines 0-15 |
| **NVIC** | Handles EXINT interrupt requests |
| **PWR** | EXINT can wake from low-power modes |
| **RTC** | Line 17 for RTC alarm |
| **USB** | Line 18 for USB wakeup |
| **COMP** | Line 19 for comparator events |
| **PVM** | Line 16 for voltage monitoring |

