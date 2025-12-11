# DEBUG - Debug Support

## Overview

The AT32F403A/407 DEBUG peripheral provides control over MCU behavior during debugging sessions. It allows pausing timers, watchdogs, and other time-sensitive peripherals when the core is halted by a debugger, making it easier to debug real-time applications.

### Key Features

| Feature | Description |
|---------|-------------|
| **Device ID** | Read unique device identification |
| **Sleep Debug** | Keep debug active during sleep mode |
| **Deep Sleep Debug** | Keep debug active during deep sleep mode |
| **Standby Debug** | Keep debug active during standby mode |
| **Peripheral Freeze** | Pause timers, watchdogs, CAN, I2C during debug halt |
| **Trace Output** | Configure trace pin functionality |

---

## Block Diagram

```
                    ┌─────────────────────────────────────────┐
                    │           DEBUG Controller              │
                    │                                         │
  JTAG/SWD ─────────┤  ┌──────────┐                          │
  Debugger          │  │  Debug   │──── Device ID (PID)      │
                    │  │  Logic   │                          │
                    │  └────┬─────┘                          │
                    │       │                                │
                    │       ▼                                │
                    │  ┌─────────────────────────────────┐   │
                    │  │      Peripheral Freeze Control  │   │
                    │  └─────────────────────────────────┘   │
                    │       │                                │
                    │       ├──► TMR1/2/3/4/5/6/7/8/9/10/11  │
                    │       │    TMR12/13/14 PAUSE           │
                    │       │                                │
                    │       ├──► WDT/WWDT PAUSE              │
                    │       │                                │
                    │       ├──► CAN1/CAN2 PAUSE             │
                    │       │                                │
                    │       └──► I2C1/2/3 SMBus Timeout      │
                    │                                        │
                    └────────────────────────────────────────┘
```

---

## Register Map

| Register | Offset | Description |
|----------|--------|-------------|
| **PID** | 0x00 | Device ID register |
| **CTRL** | 0x04 | Debug control register |

### CTRL Register Bit Fields

| Bit | Field | Description |
|-----|-------|-------------|
| 0 | `sleep_debug` | Debug during sleep mode |
| 1 | `deepsleep_debug` | Debug during deep sleep mode |
| 2 | `standby_debug` | Debug during standby mode |
| 5 | `trace_ioen` | Trace I/O enable |
| 7:6 | `trace_mode` | Trace pin assignment mode |
| 8 | `wdt_pause` | Watchdog timer pause |
| 9 | `wwdt_pause` | Window watchdog timer pause |
| 10 | `tmr1_pause` | Timer 1 pause |
| 11 | `tmr2_pause` | Timer 2 pause |
| 12 | `tmr3_pause` | Timer 3 pause |
| 13 | `tmr4_pause` | Timer 4 pause |
| 14 | `can1_pause` | CAN1 pause |
| 15 | `i2c1_smbus_timeout` | I2C1 SMBus timeout freeze |
| 16 | `i2c2_smbus_timeout` | I2C2 SMBus timeout freeze |
| 17 | `tmr8_pause` | Timer 8 pause |
| 18 | `tmr5_pause` | Timer 5 pause |
| 19 | `tmr6_pause` | Timer 6 pause |
| 20 | `tmr7_pause` | Timer 7 pause |
| 21 | `can2_pause` | CAN2 pause |
| 25 | `tmr12_pause` | Timer 12 pause |
| 26 | `tmr13_pause` | Timer 13 pause |
| 27 | `tmr14_pause` | Timer 14 pause |
| 28 | `tmr9_pause` | Timer 9 pause |
| 29 | `tmr10_pause` | Timer 10 pause |
| 30 | `tmr11_pause` | Timer 11 pause |
| 31 | `i2c3_smbus_timeout` | I2C3 SMBus timeout freeze |

---

## Debug Mode Constants

### Low-Power Mode Debug

```c
#define DEBUG_SLEEP              0x00000001  // Debug sleep mode
#define DEBUG_DEEPSLEEP          0x00000002  // Debug deep sleep mode
#define DEBUG_STANDBY            0x00000004  // Debug standby mode
```

### Timer Pause

```c
#define DEBUG_TMR1_PAUSE         0x00000400  // Timer 1 pause
#define DEBUG_TMR2_PAUSE         0x00000800  // Timer 2 pause
#define DEBUG_TMR3_PAUSE         0x00001000  // Timer 3 pause
#define DEBUG_TMR4_PAUSE         0x00002000  // Timer 4 pause
#define DEBUG_TMR5_PAUSE         0x00040000  // Timer 5 pause
#define DEBUG_TMR6_PAUSE         0x00080000  // Timer 6 pause
#define DEBUG_TMR7_PAUSE         0x00100000  // Timer 7 pause
#define DEBUG_TMR8_PAUSE         0x00020000  // Timer 8 pause
#define DEBUG_TMR9_PAUSE         0x10000000  // Timer 9 pause
#define DEBUG_TMR10_PAUSE        0x20000000  // Timer 10 pause
#define DEBUG_TMR11_PAUSE        0x40000000  // Timer 11 pause
#define DEBUG_TMR12_PAUSE        0x02000000  // Timer 12 pause
#define DEBUG_TMR13_PAUSE        0x04000000  // Timer 13 pause
#define DEBUG_TMR14_PAUSE        0x08000000  // Timer 14 pause
```

### Watchdog Pause

```c
#define DEBUG_WDT_PAUSE          0x00000100  // Watchdog timer pause
#define DEBUG_WWDT_PAUSE         0x00000200  // Window watchdog timer pause
```

### CAN Pause

```c
#define DEBUG_CAN1_PAUSE         0x00004000  // CAN1 pause
#define DEBUG_CAN2_PAUSE         0x00200000  // CAN2 pause
```

### I2C SMBus Timeout Freeze

```c
#define DEBUG_I2C1_SMBUS_TIMEOUT 0x00008000  // I2C1 SMBus timeout
#define DEBUG_I2C2_SMBUS_TIMEOUT 0x00010000  // I2C2 SMBus timeout
#define DEBUG_I2C3_SMBUS_TIMEOUT 0x80000000  // I2C3 SMBus timeout
```

---

## Peripheral Freeze Summary

When the debugger halts the core, enabled peripherals will freeze:

| Category | Peripherals | Effect |
|----------|-------------|--------|
| **Timers** | TMR1-14 | Counter stops, no overflow/compare events |
| **Watchdogs** | WDT, WWDT | Counter stops, no reset triggered |
| **CAN** | CAN1, CAN2 | Transmit/receive frozen, no timeout |
| **I2C** | I2C1-3 | SMBus timeout counter frozen |

---

## API Reference

### `debug_device_id_get()`

Read the device identification code.

```c
uint32_t debug_device_id_get(void);
```

**Returns**: 32-bit device identification value (PID)

**Device ID Values**:

| Device | Expected PID |
|--------|--------------|
| AT32F403A | 0x700xx0xx |
| AT32F407 | 0x700xx0xx |

### `debug_periph_mode_set()`

Enable or disable debug mode for specified peripherals.

```c
void debug_periph_mode_set(uint32_t periph_debug_mode, confirm_state new_state);
```

| Parameter | Description |
|-----------|-------------|
| `periph_debug_mode` | Debug mode flags (can be OR'd together) |
| `new_state` | `TRUE` to enable, `FALSE` to disable |

**Example**:

```c
// Enable debug pause for multiple peripherals
debug_periph_mode_set(DEBUG_TMR1_PAUSE | DEBUG_WDT_PAUSE | DEBUG_WWDT_PAUSE, TRUE);
```

---

## Usage Examples

### Example 1: Timer Debug Pause

Pause TMR1 counter when debugger halts execution.

```c
#include "at32f403a_407.h"

void debug_timer_example(void)
{
    crm_clocks_freq_type crm_clocks_freq_struct = {0};
    
    // Get system clock frequency
    crm_clocks_freq_get(&crm_clocks_freq_struct);
    
    // Enable TMR1 clock
    crm_periph_clock_enable(CRM_TMR1_PERIPH_CLOCK, TRUE);
    
    // Enable TMR1 debug pause mode
    // When debugger halts, TMR1 counter will stop
    debug_periph_mode_set(DEBUG_TMR1_PAUSE, TRUE);
    
    // Configure TMR1
    tmr_base_init(TMR1, 10000, 0);
    tmr_cnt_dir_set(TMR1, TMR_COUNT_UP);
    
    // Enable overflow interrupt
    tmr_interrupt_enable(TMR1, TMR_OVF_INT, TRUE);
    
    // Configure NVIC
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    nvic_irq_enable(TMR1_OVF_TMR10_IRQn, 1, 0);
    
    // Start timer
    tmr_counter_enable(TMR1, TRUE);
    
    while(1)
    {
        // When halted by debugger, timer stops
        // Counter value remains constant at breakpoint
        uint16_t counter = tmr_counter_value_get(TMR1);
    }
}

void TMR1_OVF_TMR10_IRQHandler(void)
{
    if(tmr_interrupt_flag_get(TMR1, TMR_OVF_FLAG) != RESET)
    {
        // Handle overflow
        tmr_flag_clear(TMR1, TMR_OVF_FLAG);
    }
}
```

### Example 2: Watchdog Debug Pause

Prevent watchdog reset during debugging.

```c
#include "at32f403a_407.h"

void debug_watchdog_example(void)
{
    // Enable watchdog debug pause
    // Prevents WDT reset while stepping through code
    debug_periph_mode_set(DEBUG_WDT_PAUSE, TRUE);
    
    // Configure watchdog
    wdt_register_write_enable(TRUE);
    wdt_divider_set(WDT_CLK_DIV_32);
    wdt_reload_value_set(1250);  // ~1 second timeout
    wdt_enable();
    
    while(1)
    {
        // Normal operation: feed watchdog
        wdt_counter_reload();
        
        // During debug: watchdog won't reset MCU
        // even if reload is missed at breakpoint
        delay_ms(500);
    }
}
```

### Example 3: Multiple Peripheral Debug Mode

Configure debug pause for all time-sensitive peripherals.

```c
#include "at32f403a_407.h"

void debug_full_setup(void)
{
    // Enable debug pause for all critical peripherals
    uint32_t debug_modes = DEBUG_TMR1_PAUSE  |
                           DEBUG_TMR2_PAUSE  |
                           DEBUG_TMR3_PAUSE  |
                           DEBUG_TMR4_PAUSE  |
                           DEBUG_TMR5_PAUSE  |
                           DEBUG_WDT_PAUSE   |
                           DEBUG_WWDT_PAUSE  |
                           DEBUG_CAN1_PAUSE  |
                           DEBUG_CAN2_PAUSE  |
                           DEBUG_I2C1_SMBUS_TIMEOUT |
                           DEBUG_I2C2_SMBUS_TIMEOUT;
    
    debug_periph_mode_set(debug_modes, TRUE);
}
```

### Example 4: Read Device ID

Identify the device for runtime checks.

```c
#include "at32f403a_407.h"

void read_device_info(void)
{
    uint32_t device_id = debug_device_id_get();
    
    // Extract device info
    uint16_t dev_id = device_id & 0x0FFF;
    uint16_t rev_id = (device_id >> 16) & 0xFFFF;
    
    printf("Device ID: 0x%03X\n", dev_id);
    printf("Revision:  0x%04X\n", rev_id);
    printf("Full PID:  0x%08X\n", device_id);
}
```

### Example 5: Low-Power Debug Mode

Keep debug active during sleep modes.

```c
#include "at32f403a_407.h"

void debug_low_power_example(void)
{
    // Enable debug during all low-power modes
    debug_periph_mode_set(DEBUG_SLEEP | DEBUG_DEEPSLEEP | DEBUG_STANDBY, TRUE);
    
    // Now debugger stays connected during:
    // - Sleep mode (WFI/WFE)
    // - Deep sleep mode
    // - Standby mode
    
    // Note: This increases power consumption in low-power modes
    // Disable for production to minimize power
}
```

### Example 6: CAN Debug Pause

Pause CAN peripheral during debugging to prevent bus errors.

```c
#include "at32f403a_407.h"

void debug_can_example(void)
{
    // Enable CAN1 and CAN2 debug pause
    // Prevents CAN timeout errors during debug halts
    debug_periph_mode_set(DEBUG_CAN1_PAUSE | DEBUG_CAN2_PAUSE, TRUE);
    
    // Initialize CAN1
    crm_periph_clock_enable(CRM_CAN1_PERIPH_CLOCK, TRUE);
    
    // ... CAN configuration ...
    
    // When debugger halts:
    // - CAN transmit paused
    // - CAN receive paused
    // - No ACK errors due to timeout
}
```

### Example 7: I2C SMBus Timeout Freeze

Prevent SMBus timeout during I2C debugging.

```c
#include "at32f403a_407.h"

void debug_i2c_smbus_example(void)
{
    // Enable I2C1 SMBus timeout freeze
    // SMBus operations won't timeout during debug halt
    debug_periph_mode_set(DEBUG_I2C1_SMBUS_TIMEOUT, TRUE);
    
    // Initialize I2C1
    crm_periph_clock_enable(CRM_I2C1_PERIPH_CLOCK, TRUE);
    
    // ... I2C configuration ...
    
    // SMBus timeout counter freezes when debugger halts
    // Resumes counting when code execution continues
}
```

---

## Debug Configuration Matrix

### Timer Debug Modes

| Timer | Debug Constant | Bit Position |
|-------|----------------|--------------|
| TMR1 | `DEBUG_TMR1_PAUSE` | 10 |
| TMR2 | `DEBUG_TMR2_PAUSE` | 11 |
| TMR3 | `DEBUG_TMR3_PAUSE` | 12 |
| TMR4 | `DEBUG_TMR4_PAUSE` | 13 |
| TMR5 | `DEBUG_TMR5_PAUSE` | 18 |
| TMR6 | `DEBUG_TMR6_PAUSE` | 19 |
| TMR7 | `DEBUG_TMR7_PAUSE` | 20 |
| TMR8 | `DEBUG_TMR8_PAUSE` | 17 |
| TMR9 | `DEBUG_TMR9_PAUSE` | 28 |
| TMR10 | `DEBUG_TMR10_PAUSE` | 29 |
| TMR11 | `DEBUG_TMR11_PAUSE` | 30 |
| TMR12 | `DEBUG_TMR12_PAUSE` | 25 |
| TMR13 | `DEBUG_TMR13_PAUSE` | 26 |
| TMR14 | `DEBUG_TMR14_PAUSE` | 27 |

### Complete Debug Mode Reference

| Mode | Constant | Bit | Value |
|------|----------|-----|-------|
| Sleep Debug | `DEBUG_SLEEP` | 0 | 0x00000001 |
| Deep Sleep Debug | `DEBUG_DEEPSLEEP` | 1 | 0x00000002 |
| Standby Debug | `DEBUG_STANDBY` | 2 | 0x00000004 |
| WDT Pause | `DEBUG_WDT_PAUSE` | 8 | 0x00000100 |
| WWDT Pause | `DEBUG_WWDT_PAUSE` | 9 | 0x00000200 |
| TMR1 Pause | `DEBUG_TMR1_PAUSE` | 10 | 0x00000400 |
| TMR2 Pause | `DEBUG_TMR2_PAUSE` | 11 | 0x00000800 |
| TMR3 Pause | `DEBUG_TMR3_PAUSE` | 12 | 0x00001000 |
| TMR4 Pause | `DEBUG_TMR4_PAUSE` | 13 | 0x00002000 |
| CAN1 Pause | `DEBUG_CAN1_PAUSE` | 14 | 0x00004000 |
| I2C1 SMBus | `DEBUG_I2C1_SMBUS_TIMEOUT` | 15 | 0x00008000 |
| I2C2 SMBus | `DEBUG_I2C2_SMBUS_TIMEOUT` | 16 | 0x00010000 |
| TMR8 Pause | `DEBUG_TMR8_PAUSE` | 17 | 0x00020000 |
| TMR5 Pause | `DEBUG_TMR5_PAUSE` | 18 | 0x00040000 |
| TMR6 Pause | `DEBUG_TMR6_PAUSE` | 19 | 0x00080000 |
| TMR7 Pause | `DEBUG_TMR7_PAUSE` | 20 | 0x00100000 |
| CAN2 Pause | `DEBUG_CAN2_PAUSE` | 21 | 0x00200000 |
| TMR12 Pause | `DEBUG_TMR12_PAUSE` | 25 | 0x02000000 |
| TMR13 Pause | `DEBUG_TMR13_PAUSE` | 26 | 0x04000000 |
| TMR14 Pause | `DEBUG_TMR14_PAUSE` | 27 | 0x08000000 |
| TMR9 Pause | `DEBUG_TMR9_PAUSE` | 28 | 0x10000000 |
| TMR10 Pause | `DEBUG_TMR10_PAUSE` | 29 | 0x20000000 |
| TMR11 Pause | `DEBUG_TMR11_PAUSE` | 30 | 0x40000000 |
| I2C3 SMBus | `DEBUG_I2C3_SMBUS_TIMEOUT` | 31 | 0x80000000 |

---

## Best Practices

### Development vs Production

```c
// Development: Enable all debug features
#ifdef DEBUG
void debug_development_init(void)
{
    debug_periph_mode_set(
        DEBUG_SLEEP | DEBUG_DEEPSLEEP |
        DEBUG_WDT_PAUSE | DEBUG_WWDT_PAUSE |
        DEBUG_TMR1_PAUSE | DEBUG_TMR2_PAUSE |
        DEBUG_CAN1_PAUSE | DEBUG_I2C1_SMBUS_TIMEOUT,
        TRUE
    );
}
#endif

// Production: Disable debug features for security
#ifdef RELEASE
void debug_production_init(void)
{
    // Clear all debug modes
    DEBUGMCU->ctrl = 0;
}
#endif
```

### Motor Control Safety

```c
void debug_motor_safety(void)
{
    // IMPORTANT: Pause motor control timers during debug
    // Prevents unexpected motor behavior when halted
    debug_periph_mode_set(
        DEBUG_TMR1_PAUSE |  // Advanced motor control timer
        DEBUG_TMR8_PAUSE,   // Secondary motor control timer
        TRUE
    );
}
```

### Communication Protocol Debug

```c
void debug_communication_init(void)
{
    // Freeze communication peripherals
    debug_periph_mode_set(
        DEBUG_CAN1_PAUSE | DEBUG_CAN2_PAUSE |     // CAN buses
        DEBUG_I2C1_SMBUS_TIMEOUT |                // I2C1
        DEBUG_I2C2_SMBUS_TIMEOUT |                // I2C2
        DEBUG_I2C3_SMBUS_TIMEOUT,                 // I2C3
        TRUE
    );
}
```

---

## Troubleshooting

### Issue: Watchdog Reset During Debugging

**Symptom**: MCU resets when setting breakpoints

**Solution**:
```c
// Enable watchdog pause before initializing watchdog
debug_periph_mode_set(DEBUG_WDT_PAUSE | DEBUG_WWDT_PAUSE, TRUE);
```

### Issue: Timer Counter Changes During Step

**Symptom**: Timer values different than expected during single-step

**Solution**:
```c
// Enable timer pause for accurate debugging
debug_periph_mode_set(DEBUG_TMR1_PAUSE, TRUE);
```

### Issue: CAN Bus Errors During Debug

**Symptom**: CAN error frames when halted at breakpoint

**Solution**:
```c
// Pause CAN during debug to prevent timeout errors
debug_periph_mode_set(DEBUG_CAN1_PAUSE, TRUE);
```

### Issue: Cannot Read Device ID

**Symptom**: `debug_device_id_get()` returns 0

**Solution**:
- Ensure DEBUG module is enabled in `at32f403a_407_conf.h`:
```c
#define DEBUG_MODULE_ENABLED
```

### Issue: Debug Disconnects in Low Power

**Symptom**: Debugger loses connection during sleep

**Solution**:
```c
// Keep debug active during sleep modes
debug_periph_mode_set(DEBUG_SLEEP | DEBUG_DEEPSLEEP, TRUE);
```

---

## Security Considerations

> ⚠️ **Warning**: Debug features can be a security risk in production devices.

### Disable Debug for Production

1. **Clear debug control register** at startup
2. **Enable read protection** (RDP) to prevent debug access
3. **Disable JTAG/SWD pins** in option bytes if not needed

```c
#ifndef DEBUG
void security_disable_debug(void)
{
    // Clear all debug settings
    DEBUGMCU->ctrl = 0;
    
    // Consider enabling flash read protection
    // to prevent debug access entirely
}
#endif
```

---

## Related Peripherals

| Peripheral | Relationship |
|------------|--------------|
| **TMR1-14** | Can be frozen during debug |
| **WDT/WWDT** | Can be paused to prevent reset |
| **CAN1/CAN2** | Can be paused to prevent bus errors |
| **I2C1-3** | SMBus timeout can be frozen |
| **PWR** | Low-power mode debug control |

