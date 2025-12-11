# WDT (Watchdog Timer) - AT32F403A/407

## Overview

The AT32F403A/407 microcontroller features an **Independent Watchdog Timer (WDT)** that provides system recovery from software failures. The WDT is clocked by an independent Low-Speed Internal RC oscillator (LICK) running at approximately **40 kHz**, ensuring it operates independently of the main system clock. Once enabled, the WDT cannot be disabled except by a system reset.

## Key Features

- **Independent Clock Source**: Clocked by LICK (~40 kHz)
- **12-bit Down Counter**: Reload value range 0x000 to 0xFFF (0-4095)
- **Programmable Prescaler**: 7 divider options (4 to 256)
- **Hardware Reset Generation**: Resets MCU when counter reaches zero
- **Write Protection**: Registers protected from accidental modification
- **Low-Power Operation**: Continues running in Sleep, Stop, and Standby modes
- **Cannot Be Disabled**: Once started, only reset can stop the WDT

## Timeout Calculation

The WDT timeout period is calculated using the formula:

```
Timeout (seconds) = Reload_Value × (Divider / LICK_Frequency)
```

Where:
- **Reload_Value**: 12-bit value (0 to 4095)
- **Divider**: Prescaler value (4, 8, 16, 32, 64, 128, or 256)
- **LICK_Frequency**: ~40,000 Hz (40 kHz)

### Timeout Range Table

| Divider | Min Timeout (RLD=0) | Max Timeout (RLD=4095) |
|---------|---------------------|------------------------|
| 4       | 0.1 ms              | 409.5 ms               |
| 8       | 0.2 ms              | 819.0 ms               |
| 16      | 0.4 ms              | 1.638 s                |
| 32      | 0.8 ms              | 3.276 s                |
| 64      | 1.6 ms              | 6.553 s                |
| 128     | 3.2 ms              | 13.107 s               |
| 256     | 6.4 ms              | 26.214 s               |

### Example Calculations

```c
/* Example 1: 300ms timeout */
// LICK = 40000 Hz, Divider = 4, Reload = 3000
// Timeout = 3000 × (4 / 40000) = 0.3s = 300ms

/* Example 2: 1 second timeout */
// LICK = 40000 Hz, Divider = 16, Reload = 2500
// Timeout = 2500 × (16 / 40000) = 1.0s

/* Example 3: Maximum timeout (~26 seconds) */
// LICK = 40000 Hz, Divider = 256, Reload = 4095
// Timeout = 4095 × (256 / 40000) = 26.2s
```

---

## Register Structure

### Base Address

| Peripheral | Base Address |
|------------|--------------|
| WDT        | 0x40003000   |

### Register Map

| Offset | Register | Description |
|--------|----------|-------------|
| 0x00   | CMD      | Command Register |
| 0x04   | DIV      | Divider Register |
| 0x08   | RLD      | Reload Register |
| 0x0C   | STS      | Status Register |

### Register Definitions

```c
/**
 * @brief WDT Register Structure
 */
typedef struct
{
  /**
   * @brief WDT CMD register, offset: 0x00
   */
  union
  {
    __IO uint32_t cmd;
    struct
    {
      __IO uint32_t cmd       : 16; /* [15:0] Command value */
      __IO uint32_t reserved1 : 16; /* [31:16] Reserved */
    } cmd_bit;
  };

  /**
   * @brief WDT DIV register, offset: 0x04
   */
  union
  {
    __IO uint32_t div;
    struct
    {
      __IO uint32_t div       : 3;  /* [2:0] Divider selection */
      __IO uint32_t reserved1 : 29; /* [31:3] Reserved */
    } div_bit;
  };

  /**
   * @brief WDT RLD register, offset: 0x08
   */
  union
  {
    __IO uint32_t rld;
    struct
    {
      __IO uint32_t rld       : 12; /* [11:0] Reload value */
      __IO uint32_t reserved1 : 20; /* [31:12] Reserved */
    } rld_bit;
  };

  /**
   * @brief WDT STS register, offset: 0x0C
   */
  union
  {
    __IO uint32_t sts;
    struct
    {
      __IO uint32_t divf      : 1;  /* [0] Divider update flag */
      __IO uint32_t rldf      : 1;  /* [1] Reload update flag */
      __IO uint32_t reserved1 : 30; /* [31:2] Reserved */
    } sts_bit;
  };

} wdt_type;

#define WDT  ((wdt_type *) 0x40003000)
```

---

## Configuration Types

### Clock Divider Selection

```c
/**
 * @brief WDT clock divider values
 */
typedef enum
{
  WDT_CLK_DIV_4   = 0x00,  /* Clock divided by 4   (10 kHz)   */
  WDT_CLK_DIV_8   = 0x01,  /* Clock divided by 8   (5 kHz)    */
  WDT_CLK_DIV_16  = 0x02,  /* Clock divided by 16  (2.5 kHz)  */
  WDT_CLK_DIV_32  = 0x03,  /* Clock divided by 32  (1.25 kHz) */
  WDT_CLK_DIV_64  = 0x04,  /* Clock divided by 64  (625 Hz)   */
  WDT_CLK_DIV_128 = 0x05,  /* Clock divided by 128 (312.5 Hz) */
  WDT_CLK_DIV_256 = 0x06   /* Clock divided by 256 (156.25 Hz)*/
} wdt_division_type;
```

### Command Values

```c
/**
 * @brief WDT command values
 */
typedef enum
{
  WDT_CMD_LOCK   = 0x0000,  /* Lock registers (disable write)   */
  WDT_CMD_UNLOCK = 0x5555,  /* Unlock registers (enable write)  */
  WDT_CMD_ENABLE = 0xCCCC,  /* Enable WDT and start counter     */
  WDT_CMD_RELOAD = 0xAAAA   /* Reload counter with RLD value    */
} wdt_cmd_value_type;
```

### Status Flags

```c
/**
 * @brief WDT status flags
 */
#define WDT_DIVF_UPDATE_FLAG  ((uint16_t)0x0001)  /* Divider update complete  */
#define WDT_RLDF_UPDATE_FLAG  ((uint16_t)0x0002)  /* Reload update complete   */
```

---

## API Functions

### Initialization and Control

```c
/**
 * @brief  Enable WDT - starts the watchdog counter
 * @note   Once enabled, WDT cannot be disabled except by reset
 * @note   The reload value is automatically loaded to counter
 */
void wdt_enable(void);

/**
 * @brief  Reload WDT counter (feed the watchdog)
 * @note   Must be called periodically before timeout
 * @note   Writes 0xAAAA to CMD register
 */
void wdt_counter_reload(void);
```

### Configuration Functions

```c
/**
 * @brief  Set WDT reload value
 * @param  reload_value: 12-bit value (0x0000 to 0x0FFF)
 * @note   Reload value is loaded to counter on wdt_counter_reload()
 */
void wdt_reload_value_set(uint16_t reload_value);

/**
 * @brief  Set WDT clock divider
 * @param  division: Divider selection
 *         - WDT_CLK_DIV_4:   Divide by 4
 *         - WDT_CLK_DIV_8:   Divide by 8
 *         - WDT_CLK_DIV_16:  Divide by 16
 *         - WDT_CLK_DIV_32:  Divide by 32
 *         - WDT_CLK_DIV_64:  Divide by 64
 *         - WDT_CLK_DIV_128: Divide by 128
 *         - WDT_CLK_DIV_256: Divide by 256
 */
void wdt_divider_set(wdt_division_type division);

/**
 * @brief  Enable or disable WDT register write access
 * @param  new_state: TRUE = unlock (enable write), FALSE = lock
 * @note   Must unlock before modifying DIV or RLD registers
 */
void wdt_register_write_enable(confirm_state new_state);
```

### Status Functions

```c
/**
 * @brief  Get WDT flag status
 * @param  wdt_flag: Flag to check
 *         - WDT_DIVF_UPDATE_FLAG: Divider update complete
 *         - WDT_RLDF_UPDATE_FLAG: Reload update complete
 * @retval SET or RESET
 * @note   Flags indicate when register updates are complete
 */
flag_status wdt_flag_get(uint16_t wdt_flag);
```

---

## Basic Usage Examples

### Example 1: Basic WDT Reset Protection

This example demonstrates basic WDT usage with periodic counter reload.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

int main(void)
{
  system_clock_config();
  at32_board_init();

  /* Check if reset was caused by WDT */
  if(crm_flag_get(CRM_WDT_RESET_FLAG) != RESET)
  {
    /* Reset from WDT - clear flag and indicate */
    crm_flag_clear(CRM_WDT_RESET_FLAG);
    at32_led_on(LED4);  /* Visual indication of WDT reset */
  }
  else
  {
    /* Reset from other source */
    at32_led_off(LED4);
  }

  /* Unlock WDT registers for writing */
  wdt_register_write_enable(TRUE);

  /* Set clock divider to 4 (LICK/4 = 10kHz) */
  wdt_divider_set(WDT_CLK_DIV_4);

  /* Set reload value for 300ms timeout
   * Timeout = reload × (divider / LICK)
   * Timeout = 3000 × (4 / 40000) = 0.3s = 300ms
   */
  wdt_reload_value_set(3000 - 1);

  /* Initial counter reload */
  wdt_counter_reload();
  
  /* Enable WDT - cannot be disabled after this! */
  wdt_enable();

  while(1)
  {
    /* Feed the watchdog - must be called before timeout */
    wdt_counter_reload();

    /* Normal application processing */
    at32_led_toggle(LED3);
    delay_ms(200);  /* Must be less than WDT timeout (300ms) */

    /* Simulate software hang on button press */
    if(at32_button_press() == USER_BUTTON)
    {
      while(1);  /* Infinite loop - WDT will reset the MCU */
    }
  }
}
```

### Example 2: WDT with Standby Mode Wakeup

This example shows WDT operation during standby mode for periodic wakeup.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

int main(void)
{
  system_clock_config();
  at32_board_init();

  /* Enable PWC clock for standby mode */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);

  /* Check if wakeup was from WDT reset */
  if(crm_flag_get(CRM_WDT_RESET_FLAG) != RESET)
  {
    /* Woke up from WDT reset during standby */
    crm_flag_clear(CRM_WDT_RESET_FLAG);
    at32_led_on(LED4);  /* Indicate WDT wakeup */
  }
  else
  {
    /* Initial power-on or other reset source */
    at32_led_off(LED4);
  }

  delay_ms(100);  /* Brief delay for LED visibility */

  /* Configure WDT for periodic wakeup */
  wdt_register_write_enable(TRUE);
  wdt_divider_set(WDT_CLK_DIV_4);
  
  /* 300ms timeout for periodic wakeup */
  wdt_reload_value_set(3000 - 1);
  
  wdt_counter_reload();
  wdt_enable();

  /* Enter standby mode
   * WDT continues running and will cause reset after timeout
   * This creates a periodic wakeup pattern
   */
  pwc_standby_mode_enter();

  /* Code never reaches here - MCU resets before this */
  while(1)
  {
  }
}
```

### Example 3: WDT with Different Timeout Periods

```c
#include "at32f403a_407.h"

/* Timeout configuration presets */
typedef struct {
  wdt_division_type divider;
  uint16_t reload;
  const char* description;
} wdt_timeout_config_t;

const wdt_timeout_config_t wdt_configs[] = {
  { WDT_CLK_DIV_4,   1000, "100ms timeout"  },
  { WDT_CLK_DIV_4,   4000, "400ms timeout"  },
  { WDT_CLK_DIV_16,  2500, "1 second timeout" },
  { WDT_CLK_DIV_32,  2500, "2 second timeout" },
  { WDT_CLK_DIV_64,  3125, "5 second timeout" },
  { WDT_CLK_DIV_256, 4095, "Maximum ~26s timeout" }
};

/**
 * @brief Configure WDT with preset timeout
 * @param config_index: Index into wdt_configs array
 */
void wdt_configure_timeout(uint8_t config_index)
{
  if(config_index >= sizeof(wdt_configs)/sizeof(wdt_configs[0]))
    return;
    
  const wdt_timeout_config_t* cfg = &wdt_configs[config_index];
  
  wdt_register_write_enable(TRUE);
  wdt_divider_set(cfg->divider);
  wdt_reload_value_set(cfg->reload);
  wdt_counter_reload();
}

/**
 * @brief Calculate reload value for desired timeout
 * @param timeout_ms: Desired timeout in milliseconds
 * @param divider: Clock divider to use
 * @return Reload value (clamped to 0-4095)
 */
uint16_t wdt_calculate_reload(uint32_t timeout_ms, wdt_division_type divider)
{
  /* Divider values: 4, 8, 16, 32, 64, 128, 256 */
  static const uint16_t div_values[] = {4, 8, 16, 32, 64, 128, 256};
  uint16_t div = div_values[divider];
  
  /* reload = timeout_ms × LICK / (1000 × divider)
   * reload = timeout_ms × 40000 / (1000 × divider)
   * reload = timeout_ms × 40 / divider
   */
  uint32_t reload = (timeout_ms * 40) / div;
  
  /* Clamp to 12-bit maximum */
  if(reload > 4095) reload = 4095;
  
  return (uint16_t)reload;
}
```

### Example 4: WDT Initialization Sequence with Status Checks

```c
#include "at32f403a_407.h"

/**
 * @brief Initialize WDT with timeout and wait for register updates
 * @param timeout_ms: Desired timeout in milliseconds (approximate)
 * @return TRUE if initialization successful
 */
confirm_state wdt_init_with_timeout(uint32_t timeout_ms)
{
  uint32_t timeout_counter = 0;
  const uint32_t timeout_max = 0xFFFF;
  
  /* Calculate appropriate divider and reload */
  wdt_division_type divider;
  uint16_t reload;
  
  if(timeout_ms <= 410) {
    divider = WDT_CLK_DIV_4;
    reload = (timeout_ms * 40) / 4;
  } else if(timeout_ms <= 820) {
    divider = WDT_CLK_DIV_8;
    reload = (timeout_ms * 40) / 8;
  } else if(timeout_ms <= 1640) {
    divider = WDT_CLK_DIV_16;
    reload = (timeout_ms * 40) / 16;
  } else if(timeout_ms <= 3280) {
    divider = WDT_CLK_DIV_32;
    reload = (timeout_ms * 40) / 32;
  } else if(timeout_ms <= 6550) {
    divider = WDT_CLK_DIV_64;
    reload = (timeout_ms * 40) / 64;
  } else if(timeout_ms <= 13100) {
    divider = WDT_CLK_DIV_128;
    reload = (timeout_ms * 40) / 128;
  } else {
    divider = WDT_CLK_DIV_256;
    reload = (timeout_ms * 40) / 256;
  }
  
  /* Clamp reload to valid range */
  if(reload > 4095) reload = 4095;
  if(reload < 1) reload = 1;
  
  /* Unlock registers */
  wdt_register_write_enable(TRUE);
  
  /* Set divider and wait for update */
  wdt_divider_set(divider);
  timeout_counter = 0;
  while(wdt_flag_get(WDT_DIVF_UPDATE_FLAG) == SET)
  {
    if(++timeout_counter > timeout_max)
      return FALSE;  /* Divider update timeout */
  }
  
  /* Set reload value and wait for update */
  wdt_reload_value_set(reload);
  timeout_counter = 0;
  while(wdt_flag_get(WDT_RLDF_UPDATE_FLAG) == SET)
  {
    if(++timeout_counter > timeout_max)
      return FALSE;  /* Reload update timeout */
  }
  
  /* Load counter and enable */
  wdt_counter_reload();
  wdt_enable();
  
  return TRUE;
}
```

---

## WDT in Low-Power Modes

The WDT behavior in different power modes:

| Power Mode | WDT Status | Clock Source | Reset Capability |
|------------|------------|--------------|------------------|
| Run        | Running    | LICK         | Yes              |
| Sleep      | Running    | LICK         | Yes              |
| Stop       | Running    | LICK         | Yes (wakeup)     |
| Standby    | Running    | LICK         | Yes (reset)      |

### Important Notes

1. **Standby Mode**: WDT timeout causes full system reset (not just wakeup)
2. **Stop Mode**: WDT timeout wakes up the MCU from stop mode
3. **LICK Independence**: WDT runs independently of main system clock
4. **No Disable**: Once enabled, WDT cannot be disabled - only reset stops it

---

## Detecting WDT Reset

Check the CRM (Clock and Reset Management) flags to determine reset source:

```c
#include "at32f403a_407.h"

typedef enum {
  RESET_SOURCE_POR,      /* Power-on reset */
  RESET_SOURCE_NRST,     /* External reset pin */
  RESET_SOURCE_WDT,      /* Watchdog timer reset */
  RESET_SOURCE_WWDT,     /* Window watchdog reset */
  RESET_SOURCE_SOFTWARE, /* Software reset */
  RESET_SOURCE_UNKNOWN
} reset_source_type;

/**
 * @brief Determine the source of last reset
 * @return Reset source type
 */
reset_source_type get_reset_source(void)
{
  reset_source_type source = RESET_SOURCE_UNKNOWN;
  
  if(crm_flag_get(CRM_POR_RESET_FLAG) != RESET)
  {
    source = RESET_SOURCE_POR;
    crm_flag_clear(CRM_POR_RESET_FLAG);
  }
  else if(crm_flag_get(CRM_NRST_RESET_FLAG) != RESET)
  {
    source = RESET_SOURCE_NRST;
    crm_flag_clear(CRM_NRST_RESET_FLAG);
  }
  else if(crm_flag_get(CRM_WDT_RESET_FLAG) != RESET)
  {
    source = RESET_SOURCE_WDT;
    crm_flag_clear(CRM_WDT_RESET_FLAG);
  }
  else if(crm_flag_get(CRM_WWDT_RESET_FLAG) != RESET)
  {
    source = RESET_SOURCE_WWDT;
    crm_flag_clear(CRM_WWDT_RESET_FLAG);
  }
  else if(crm_flag_get(CRM_SW_RESET_FLAG) != RESET)
  {
    source = RESET_SOURCE_SOFTWARE;
    crm_flag_clear(CRM_SW_RESET_FLAG);
  }
  
  return source;
}

/**
 * @brief Log reset source for debugging
 */
void log_reset_source(void)
{
  switch(get_reset_source())
  {
    case RESET_SOURCE_POR:
      printf("Reset: Power-on\r\n");
      break;
    case RESET_SOURCE_NRST:
      printf("Reset: External pin\r\n");
      break;
    case RESET_SOURCE_WDT:
      printf("Reset: Watchdog (WDT)\r\n");
      break;
    case RESET_SOURCE_WWDT:
      printf("Reset: Window Watchdog (WWDT)\r\n");
      break;
    case RESET_SOURCE_SOFTWARE:
      printf("Reset: Software\r\n");
      break;
    default:
      printf("Reset: Unknown\r\n");
      break;
  }
}
```

---

## Best Practices

### 1. Watchdog Feeding Strategy

```c
/* GOOD: Feed watchdog at start of main loop */
while(1)
{
  wdt_counter_reload();  /* First action in loop */
  
  /* Application processing */
  process_inputs();
  update_state();
  drive_outputs();
}

/* BAD: Don't feed in interrupt - masks main loop hangs */
void SysTick_Handler(void)
{
  wdt_counter_reload();  /* Dangerous! */
}
```

### 2. Timeout Selection

```c
/* Choose timeout based on worst-case main loop execution time */
/* Add margin for interrupt latency and processing variations */

#define MAIN_LOOP_MAX_TIME_MS  50   /* Worst-case loop time */
#define SAFETY_MARGIN_MS       100  /* Additional margin */
#define WDT_TIMEOUT_MS         (MAIN_LOOP_MAX_TIME_MS + SAFETY_MARGIN_MS)
```

### 3. Debug Considerations

```c
/* Longer timeout during development */
#ifdef DEBUG
  #define WDT_TIMEOUT_MS  5000  /* 5 seconds for debugging */
#else
  #define WDT_TIMEOUT_MS  500   /* 500ms for production */
#endif
```

### 4. Multi-Task Watchdog Pattern

```c
/* For systems with multiple tasks, use task flags */
volatile uint32_t task_flags = 0;

#define TASK1_FLAG  0x01
#define TASK2_FLAG  0x02
#define TASK3_FLAG  0x04
#define ALL_TASKS   (TASK1_FLAG | TASK2_FLAG | TASK3_FLAG)

void task1(void) {
  /* Task 1 processing */
  task_flags |= TASK1_FLAG;
}

void task2(void) {
  /* Task 2 processing */
  task_flags |= TASK2_FLAG;
}

void task3(void) {
  /* Task 3 processing */
  task_flags |= TASK3_FLAG;
}

void watchdog_supervisor(void) {
  /* Only feed watchdog if all tasks have run */
  if((task_flags & ALL_TASKS) == ALL_TASKS) {
    wdt_counter_reload();
    task_flags = 0;  /* Reset for next cycle */
  }
}
```

---

## WDT vs WWDT Comparison

| Feature | WDT (Independent) | WWDT (Window) |
|---------|-------------------|---------------|
| Clock Source | LICK (~40 kHz) | APB1 (PCLK1) |
| Counter | 12-bit down | 7-bit down |
| Window | No | Yes (configurable) |
| Timeout Range | 0.1ms - 26.2s | Depends on APB1 clock |
| Can Disable | No | Yes (before window expires) |
| Interrupt | No | Yes (early warning) |
| Low-Power | Runs in all modes | Stops in Stop/Standby |
| Use Case | System recovery | Timing-critical tasks |

---

## Troubleshooting

### Common Issues

1. **WDT Resets Too Quickly**
   - Increase reload value or use larger divider
   - Check that wdt_counter_reload() is called frequently enough
   - Verify LICK frequency (can vary ±10%)

2. **WDT Not Resetting When Expected**
   - Verify WDT is actually enabled (check after wdt_enable())
   - Ensure main loop isn't feeding WDT unintentionally
   - Check for wdt_counter_reload() calls in ISRs

3. **Register Updates Not Taking Effect**
   - Must call wdt_register_write_enable(TRUE) before modifications
   - Wait for DIVF and RLDF flags to clear before enabling

4. **Cannot Stop WDT**
   - This is by design - WDT cannot be disabled once started
   - Only a system reset will stop the WDT

### Debug Checklist

- [ ] CRM clock for WDT is independent (no enable needed)
- [ ] Registers unlocked before modification
- [ ] Reload value within valid range (0-4095)
- [ ] Counter reload called before enable
- [ ] Main loop executes faster than WDT timeout
- [ ] No watchdog feeding in interrupts (unless intentional)

---

## Application Notes

- **AN0069**: Artery MCU Reset and Boot Guide
- **AN0001**: Getting Started with AT32F403A/407

---

## See Also

- [WWDT (Window Watchdog Timer)](WWDT_Window_Watchdog_Timer.md)
- [PWC (Power Control)](PWC_Power_Control.md)
- [CRM (Clock and Reset Management)](CRM_Clock_Reset_Management.md)

