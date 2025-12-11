# WWDT (Window Watchdog Timer) - AT32F403A/407

## Overview

The AT32F403A/407 microcontroller features a **Window Watchdog Timer (WWDT)** that provides precise timing control over software execution. Unlike the independent WDT, the WWDT requires counter refresh to occur within a specific **time window** - not too early (before the window opens) and not too late (after timeout). This mechanism ensures software executes within expected timing bounds, making it ideal for detecting timing anomalies and real-time deadline violations.

## Key Features

- **System Clock Based**: Clocked from PCLK1 (APB1 clock)
- **7-bit Down Counter**: Valid range 0x40 to 0x7F (64 to 127)
- **Programmable Window**: Defines earliest allowed refresh time
- **Programmable Prescaler**: 4 divider options (4096 to 32768)
- **Early Warning Interrupt**: Fires when counter reaches 0x40
- **Can Be Disabled**: Via peripheral reset before enabling
- **Dual Reset Conditions**:
  - Counter reaches 0x3F (timeout)
  - Counter refresh when CNT > WIN (too early)

## Window Watchdog Concept

```
Counter Value
    0x7F ┌───────────────────────────────────────┐
         │                                       │ ← Counter starts here
         │     FORBIDDEN ZONE                    │
         │     (Reload causes reset)             │
    WIN  ├───────────────────────────────────────┤ ← Window opens here
         │                                       │
         │     ALLOWED WINDOW                    │
         │     (Safe to reload counter)          │
         │                                       │
    0x40 ├───────────────────────────────────────┤ ← Early warning interrupt
         │     DANGER ZONE                       │
    0x3F │     (Reset imminent!)                 │ ← Reset occurs here
         └───────────────────────────────────────┘

Time →   [Start]        [Window Opens]    [Interrupt]  [Reset!]
```

### Reset Conditions

1. **Timeout Reset**: Counter decrements below 0x40 (reaches 0x3F)
2. **Window Violation Reset**: Counter reloaded when CNT > WIN (too early)

---

## Timeout Calculation

The WWDT timing is calculated using these formulas:

```
WWDT_Clock = PCLK1 / (4096 × Prescaler)

Timeout = (Counter_Value - 0x3F) × (1 / WWDT_Clock)
        = (Counter_Value - 0x3F) × (4096 × Prescaler / PCLK1)

Window_Delay = (0x7F - Window_Value) × (4096 × Prescaler / PCLK1)
```

Where:
- **PCLK1**: APB1 peripheral clock frequency
- **Prescaler**: 1, 2, 4, or 8 (total divider: 4096, 8192, 16384, 32768)
- **Counter_Value**: Starting count (0x40 to 0x7F)
- **Window_Value**: Window threshold (0x40 to 0x7F)

### Timeout Range Tables

#### At PCLK1 = 120 MHz

| Divider | Min Timeout (CNT=0x40) | Max Timeout (CNT=0x7F) |
|---------|------------------------|------------------------|
| 4096    | 34.1 µs                | 2.18 ms                |
| 8192    | 68.3 µs                | 4.37 ms                |
| 16384   | 136.5 µs               | 8.74 ms                |
| 32768   | 273.1 µs               | 17.48 ms               |

#### At PCLK1 = 60 MHz

| Divider | Min Timeout (CNT=0x40) | Max Timeout (CNT=0x7F) |
|---------|------------------------|------------------------|
| 4096    | 68.3 µs                | 4.37 ms                |
| 8192    | 136.5 µs               | 8.74 ms                |
| 16384   | 273.1 µs               | 17.48 ms               |
| 32768   | 546.1 µs               | 34.95 ms               |

### Example Calculation

```c
/* Configuration from example:
 * PCLK1 = 120 MHz
 * Divider = 32768
 * Counter = 0x7F (127)
 * Window = 0x6F (111)
 *
 * Timeout ticks = 0x7F - 0x3F = 64
 * Window delay ticks = 0x7F - 0x6F = 16
 *
 * Timeout = 64 × (32768 / 120,000,000) = 17.4 ms
 * Window delay = 16 × (32768 / 120,000,000) = 4.4 ms
 *
 * Refresh must occur:
 * - AFTER 4.4 ms (window opens)
 * - BEFORE 17.4 ms (timeout)
 */
```

---

## Register Structure

### Base Address

| Peripheral | Base Address |
|------------|--------------|
| WWDT       | 0x40002C00   |

### Register Map

| Offset | Register | Description |
|--------|----------|-------------|
| 0x00   | CTRL     | Control Register |
| 0x04   | CFG      | Configuration Register |
| 0x08   | STS      | Status Register |

### Register Definitions

```c
/**
 * @brief WWDT Register Structure
 */
typedef struct
{
  /**
   * @brief WWDT CTRL register, offset: 0x00
   */
  union
  {
    __IO uint32_t ctrl;
    struct
    {
      __IO uint32_t cnt       : 7;  /* [6:0] 7-bit counter value */
      __IO uint32_t wwdten    : 1;  /* [7] WWDT enable */
      __IO uint32_t reserved1 : 24; /* [31:8] Reserved */
    } ctrl_bit;
  };

  /**
   * @brief WWDT CFG register, offset: 0x04
   */
  union
  {
    __IO uint32_t cfg;
    struct
    {
      __IO uint32_t win       : 7;  /* [6:0] Window value */
      __IO uint32_t div       : 2;  /* [8:7] Clock divider */
      __IO uint32_t rldien    : 1;  /* [9] Reload interrupt enable */
      __IO uint32_t reserved1 : 22; /* [31:10] Reserved */
    } cfg_bit;
  };

  /**
   * @brief WWDT STS register, offset: 0x08
   */
  union
  {
    __IO uint32_t sts;
    struct
    {
      __IO uint32_t rldf      : 1;  /* [0] Reload (early warning) flag */
      __IO uint32_t reserved1 : 31; /* [31:1] Reserved */
    } sts_bit;
  };

} wwdt_type;

#define WWDT  ((wwdt_type *) 0x40002C00)
```

### CTRL Register Details

| Bits | Name | Access | Description |
|------|------|--------|-------------|
| 6:0  | CNT  | R/W    | 7-bit down counter (0x40-0x7F valid) |
| 7    | WWDTEN | R/W  | WWDT Enable (1=enabled, cannot clear by software) |
| 31:8 | -    | -      | Reserved |

### CFG Register Details

| Bits | Name | Access | Description |
|------|------|--------|-------------|
| 6:0  | WIN  | R/W    | Window value - reload allowed when CNT < WIN |
| 8:7  | DIV  | R/W    | Prescaler: 00=/4096, 01=/8192, 10=/16384, 11=/32768 |
| 9    | RLDIEN | R/W  | Reload interrupt enable |
| 31:10| -    | -      | Reserved |

### STS Register Details

| Bits | Name | Access | Description |
|------|------|--------|-------------|
| 0    | RLDF | R/W0   | Reload flag (early warning), write 0 to clear |
| 31:1 | -    | -      | Reserved |

---

## Configuration Types

### Clock Divider Selection

```c
/**
 * @brief WWDT clock divider values
 * @note Base divider is always 4096, these add additional division
 */
typedef enum
{
  WWDT_PCLK1_DIV_4096  = 0x00,  /* PCLK1 / 4096 (÷1)  */
  WWDT_PCLK1_DIV_8192  = 0x01,  /* PCLK1 / 8192 (÷2)  */
  WWDT_PCLK1_DIV_16384 = 0x02,  /* PCLK1 / 16384 (÷4) */
  WWDT_PCLK1_DIV_32768 = 0x03   /* PCLK1 / 32768 (÷8) */
} wwdt_division_type;
```

### Enable Bit Definition

```c
#define WWDT_EN_BIT  ((uint32_t)0x00000080)  /* Bit 7 - WWDT enable */
```

---

## API Functions

### Reset and Initialization

```c
/**
 * @brief  Reset WWDT peripheral via CRM
 * @note   Can only reset WWDT before it is enabled
 * @note   Once WWDTEN bit is set, only system reset can disable WWDT
 */
void wwdt_reset(void);

/**
 * @brief  Enable WWDT and load initial counter value
 * @param  wwdt_cnt: Initial counter value (0x40 to 0x7F)
 * @note   Also sets WWDTEN bit which cannot be cleared by software
 */
void wwdt_enable(uint8_t wwdt_cnt);
```

### Configuration Functions

```c
/**
 * @brief  Set WWDT clock divider
 * @param  division: Clock divider selection
 *         - WWDT_PCLK1_DIV_4096:  Divide by 4096
 *         - WWDT_PCLK1_DIV_8192:  Divide by 8192
 *         - WWDT_PCLK1_DIV_16384: Divide by 16384
 *         - WWDT_PCLK1_DIV_32768: Divide by 32768
 * @note   Should be configured before enabling WWDT
 */
void wwdt_divider_set(wwdt_division_type division);

/**
 * @brief  Set WWDT window counter value
 * @param  window_cnt: Window threshold (0x40 to 0x7F)
 * @note   Reload is only allowed when CNT < window_cnt
 * @note   Higher value = larger allowed window
 */
void wwdt_window_counter_set(uint8_t window_cnt);

/**
 * @brief  Reload WWDT counter value
 * @param  wwdt_cnt: New counter value (0x40 to 0x7F)
 * @warning Must be called only when CNT < WIN, otherwise reset occurs!
 */
void wwdt_counter_set(uint8_t wwdt_cnt);
```

### Interrupt Functions

```c
/**
 * @brief  Enable WWDT early warning interrupt
 * @note   Interrupt fires when counter reaches 0x40
 * @note   Must also configure NVIC for WWDT_IRQn
 */
void wwdt_interrupt_enable(void);

/**
 * @brief  Get WWDT reload flag status
 * @retval SET if counter reached 0x40, RESET otherwise
 */
flag_status wwdt_flag_get(void);

/**
 * @brief  Get WWDT interrupt flag (flag AND interrupt enabled)
 * @retval SET if interrupt pending, RESET otherwise
 */
flag_status wwdt_interrupt_flag_get(void);

/**
 * @brief  Clear WWDT reload flag
 * @note   Must clear flag in interrupt handler
 */
void wwdt_flag_clear(void);
```

---

## Basic Usage Examples

### Example 1: Basic WWDT Reset Protection

This example demonstrates basic WWDT usage with window-constrained refresh.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

int main(void)
{
  system_clock_config();
  at32_board_init();

  /* Check if reset was caused by WWDT */
  if(crm_flag_get(CRM_WWDT_RESET_FLAG) != RESET)
  {
    /* Reset from WWDT - clear flag and indicate */
    crm_flag_clear(CRM_WWDT_RESET_FLAG);
    at32_led_on(LED4);  /* Visual indication of WWDT reset */
  }
  else
  {
    /* Reset from other source */
    at32_led_off(LED4);
  }

  /* Enable WWDT clock */
  crm_periph_clock_enable(CRM_WWDT_PERIPH_CLOCK, TRUE);

  /* Set clock divider (PCLK1/32768)
   * At PCLK1=120MHz: WWDT_CLK = 3662 Hz, tick = 273 µs
   */
  wwdt_divider_set(WWDT_PCLK1_DIV_32768);

  /* Set window value to 0x6F
   * Window opens after: (0x7F - 0x6F) × 273µs = 4.4 ms
   */
  wwdt_window_counter_set(0x6F);

  /* Enable WWDT with counter = 0x7F
   * Timeout occurs after: (0x7F - 0x3F) × 273µs = 17.4 ms
   *
   * Refresh timing:
   * - Window opens: 4.4 ms after start
   * - Timeout: 17.4 ms after start
   * - Safe refresh period: 4.4ms to 17.4ms
   */
  wwdt_enable(0x7F);

  while(1)
  {
    at32_led_toggle(LED3);

    /* Wait until within the window (must be > 4.4ms)
     * Using 6ms to be safely inside the window
     */
    delay_ms(6);

    /* Refresh counter - must be done when CNT < WIN */
    wwdt_counter_set(0x7F);

    /* Simulate software hang on button press */
    if(at32_button_press() == USER_BUTTON)
    {
      while(1);  /* Infinite loop - WWDT will reset the MCU */
    }
  }
}
```

### Example 2: WWDT with Early Warning Interrupt

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

volatile uint32_t wwdt_warning_count = 0;

/**
 * @brief WWDT interrupt handler (early warning)
 */
void WWDT_IRQHandler(void)
{
  if(wwdt_interrupt_flag_get() != RESET)
  {
    /* Clear the flag first */
    wwdt_flag_clear();
    
    /* Counter reached 0x40 - refresh immediately! */
    wwdt_counter_set(0x7F);
    
    /* Track how many times we got the warning */
    wwdt_warning_count++;
    
    /* Toggle LED to indicate interrupt fired */
    at32_led_toggle(LED2);
  }
}

int main(void)
{
  system_clock_config();
  at32_board_init();

  /* Enable WWDT clock */
  crm_periph_clock_enable(CRM_WWDT_PERIPH_CLOCK, TRUE);

  /* Configure NVIC for WWDT interrupt */
  nvic_irq_enable(WWDT_IRQn, 0, 0);  /* Highest priority */

  /* Configure WWDT */
  wwdt_divider_set(WWDT_PCLK1_DIV_32768);
  wwdt_window_counter_set(0x50);  /* Window opens at 0x50 */
  
  /* Enable early warning interrupt */
  wwdt_interrupt_enable();
  
  /* Enable WWDT */
  wwdt_enable(0x7F);

  while(1)
  {
    /* Main loop can do other work
     * WWDT refresh is handled by interrupt
     * This is useful as a safety net, but normal code
     * should still refresh in the main loop
     */
    at32_led_toggle(LED3);
    delay_ms(100);
    
    /* Normal refresh in main loop */
    if(WWDT->ctrl_bit.cnt < 0x50)  /* Within window */
    {
      wwdt_counter_set(0x7F);
    }
  }
}
```

### Example 3: WWDT Configuration Helper Functions

```c
#include "at32f403a_407.h"

/**
 * @brief WWDT configuration structure
 */
typedef struct {
  wwdt_division_type divider;
  uint8_t counter;
  uint8_t window;
  float timeout_ms;
  float window_delay_ms;
} wwdt_config_t;

/**
 * @brief Calculate WWDT timing for given PCLK1 frequency
 * @param pclk1_hz: PCLK1 frequency in Hz
 * @param divider: Clock divider selection
 * @param counter: Initial counter value (0x40-0x7F)
 * @param window: Window threshold (0x40-0x7F)
 * @param config: Output configuration structure
 */
void wwdt_calculate_timing(uint32_t pclk1_hz, wwdt_division_type divider,
                           uint8_t counter, uint8_t window,
                           wwdt_config_t* config)
{
  static const uint16_t div_values[] = {4096, 8192, 16384, 32768};
  uint16_t total_div = div_values[divider];
  
  float tick_period_ms = (float)total_div / pclk1_hz * 1000.0f;
  
  config->divider = divider;
  config->counter = counter;
  config->window = window;
  config->timeout_ms = (counter - 0x3F) * tick_period_ms;
  config->window_delay_ms = (0x7F - window) * tick_period_ms;
}

/**
 * @brief Find optimal WWDT configuration for desired timeout
 * @param pclk1_hz: PCLK1 frequency in Hz
 * @param desired_timeout_ms: Desired timeout in milliseconds
 * @param window_percent: Window delay as percentage of timeout (e.g., 25)
 * @param config: Output configuration structure
 * @return TRUE if valid configuration found
 */
confirm_state wwdt_find_config(uint32_t pclk1_hz, float desired_timeout_ms,
                               uint8_t window_percent, wwdt_config_t* config)
{
  static const uint16_t div_values[] = {4096, 8192, 16384, 32768};
  
  for(int d = 0; d < 4; d++)
  {
    float tick_ms = (float)div_values[d] / pclk1_hz * 1000.0f;
    
    /* Calculate required counter value */
    float counter_f = (desired_timeout_ms / tick_ms) + 0x3F;
    
    if(counter_f >= 0x40 && counter_f <= 0x7F)
    {
      uint8_t counter = (uint8_t)counter_f;
      
      /* Calculate window value for desired percentage */
      float window_ticks = (counter - 0x3F) * window_percent / 100.0f;
      uint8_t window = 0x7F - (uint8_t)window_ticks;
      
      /* Clamp window to valid range */
      if(window < 0x40) window = 0x40;
      if(window > counter) window = counter;
      
      wwdt_calculate_timing(pclk1_hz, (wwdt_division_type)d, 
                           counter, window, config);
      return TRUE;
    }
  }
  
  return FALSE;  /* No valid configuration found */
}

/**
 * @brief Initialize WWDT with configuration structure
 * @param config: WWDT configuration
 */
void wwdt_init_with_config(const wwdt_config_t* config)
{
  crm_periph_clock_enable(CRM_WWDT_PERIPH_CLOCK, TRUE);
  wwdt_divider_set(config->divider);
  wwdt_window_counter_set(config->window);
  wwdt_enable(config->counter);
}

/* Usage example */
void example_usage(void)
{
  wwdt_config_t config;
  
  /* Find config for 15ms timeout with 25% window delay */
  if(wwdt_find_config(120000000, 15.0f, 25, &config))
  {
    printf("WWDT Config Found:\n");
    printf("  Timeout: %.2f ms\n", config.timeout_ms);
    printf("  Window delay: %.2f ms\n", config.window_delay_ms);
    printf("  Counter: 0x%02X\n", config.counter);
    printf("  Window: 0x%02X\n", config.window);
    
    wwdt_init_with_config(&config);
  }
}
```

### Example 4: Safe WWDT Refresh Function

```c
#include "at32f403a_407.h"

/**
 * @brief Check if WWDT refresh is currently safe (within window)
 * @retval TRUE if refresh is safe, FALSE if outside window
 */
confirm_state wwdt_is_refresh_safe(void)
{
  uint8_t current_cnt = WWDT->ctrl_bit.cnt;
  uint8_t window_val = WWDT->cfg_bit.win;
  
  /* Safe to refresh when CNT < WIN */
  return (current_cnt < window_val) ? TRUE : FALSE;
}

/**
 * @brief Safely refresh WWDT counter
 * @param wwdt_cnt: New counter value (0x40-0x7F)
 * @retval TRUE if refresh successful, FALSE if outside window
 * @note Does NOT refresh if outside window (would cause reset)
 */
confirm_state wwdt_safe_refresh(uint8_t wwdt_cnt)
{
  if(wwdt_is_refresh_safe())
  {
    wwdt_counter_set(wwdt_cnt);
    return TRUE;
  }
  return FALSE;  /* Don't refresh - would cause reset! */
}

/**
 * @brief Get remaining time until timeout (approximate)
 * @param pclk1_hz: PCLK1 frequency in Hz
 * @return Remaining time in microseconds
 */
uint32_t wwdt_get_remaining_us(uint32_t pclk1_hz)
{
  static const uint16_t div_values[] = {4096, 8192, 16384, 32768};
  
  uint8_t current_cnt = WWDT->ctrl_bit.cnt;
  uint8_t divider_idx = WWDT->cfg_bit.div;
  uint16_t total_div = div_values[divider_idx];
  
  if(current_cnt < 0x40)
    return 0;  /* Already in danger zone */
    
  uint32_t remaining_ticks = current_cnt - 0x3F;
  uint64_t tick_us = (uint64_t)total_div * 1000000 / pclk1_hz;
  
  return (uint32_t)(remaining_ticks * tick_us);
}

/**
 * @brief Get remaining time until window opens (approximate)
 * @param pclk1_hz: PCLK1 frequency in Hz
 * @return Time until window opens in microseconds, 0 if already in window
 */
uint32_t wwdt_get_window_wait_us(uint32_t pclk1_hz)
{
  static const uint16_t div_values[] = {4096, 8192, 16384, 32768};
  
  uint8_t current_cnt = WWDT->ctrl_bit.cnt;
  uint8_t window_val = WWDT->cfg_bit.win;
  uint8_t divider_idx = WWDT->cfg_bit.div;
  
  if(current_cnt < window_val)
    return 0;  /* Already in window */
    
  uint16_t total_div = div_values[divider_idx];
  uint32_t wait_ticks = current_cnt - window_val + 1;
  uint64_t tick_us = (uint64_t)total_div * 1000000 / pclk1_hz;
  
  return (uint32_t)(wait_ticks * tick_us);
}
```

---

## Detecting WWDT Reset

Check the CRM (Clock and Reset Management) flags to determine reset source:

```c
#include "at32f403a_407.h"

/**
 * @brief Check and handle WWDT reset
 * @return TRUE if last reset was from WWDT
 */
confirm_state check_wwdt_reset(void)
{
  if(crm_flag_get(CRM_WWDT_RESET_FLAG) != RESET)
  {
    /* Clear the flag */
    crm_flag_clear(CRM_WWDT_RESET_FLAG);
    
    /* Log or handle WWDT reset */
    /* This indicates either:
     * 1. Software execution took too long (timeout)
     * 2. Software executed too fast (window violation)
     */
    return TRUE;
  }
  return FALSE;
}

/**
 * @brief Determine reset source type
 */
typedef enum {
  RESET_WWDT_TIMEOUT,    /* Timeout - counter reached 0x3F */
  RESET_WWDT_WINDOW,     /* Window violation - early refresh */
  RESET_WWDT_UNKNOWN     /* Could be either */
} wwdt_reset_type;

/* Note: Hardware doesn't distinguish between timeout and window violation.
 * To determine the cause, you would need to log application state
 * before reset and analyze it after restart. */
```

---

## WWDT vs WDT Comparison

| Feature | WWDT (Window) | WDT (Independent) |
|---------|---------------|-------------------|
| **Clock Source** | PCLK1 (APB1) | LICK (~40 kHz) |
| **Counter** | 7-bit (0x40-0x7F) | 12-bit (0-4095) |
| **Timing Window** | Yes (programmable) | No |
| **Timeout Range** | 34µs - 35ms @ 120MHz | 0.1ms - 26.2s |
| **Early Warning** | Yes (interrupt at 0x40) | No |
| **Can Disable** | Via CRM reset (before enable) | No |
| **Low-Power Modes** | Stops in Stop/Standby | Runs in all modes |
| **Reset Trigger** | Timeout OR early refresh | Timeout only |
| **Use Case** | Timing-critical applications | General system recovery |

### When to Use WWDT

- **Real-time systems** requiring precise timing validation
- **Safety-critical applications** where timing matters
- **Motor control** where PWM timing must be exact
- **Communication protocols** with strict timing requirements
- **Applications where "too fast" is as bad as "too slow"**

### When to Use WDT

- **General system recovery** from crashes
- **Background monitoring** of main loop execution
- **Low-power applications** needing watchdog during sleep
- **Applications only concerned with "too slow" execution**

---

## NVIC Configuration

```c
/**
 * @brief Configure NVIC for WWDT interrupt
 * @note WWDT interrupt should typically have high priority
 */
void wwdt_nvic_config(void)
{
  /* WWDT_IRQn = 0 (position 0 in vector table) */
  nvic_irq_enable(WWDT_IRQn, 0, 0);  /* Preemption=0, Sub=0 (highest) */
}

/* Interrupt handler prototype */
void WWDT_IRQHandler(void);
```

---

## Best Practices

### 1. Configure Before Enabling

```c
/* GOOD: Configure everything before enabling */
crm_periph_clock_enable(CRM_WWDT_PERIPH_CLOCK, TRUE);
wwdt_divider_set(WWDT_PCLK1_DIV_32768);
wwdt_window_counter_set(0x6F);
wwdt_enable(0x7F);  /* Enable last */

/* BAD: Changing config after enable */
wwdt_enable(0x7F);
wwdt_divider_set(WWDT_PCLK1_DIV_32768);  /* Too late! */
```

### 2. Know Your Window Timing

```c
/* Calculate and document your timing window */
#define PCLK1_FREQ          120000000UL
#define WWDT_DIVIDER        32768
#define WWDT_TICK_US        ((WWDT_DIVIDER * 1000000UL) / PCLK1_FREQ)  /* 273 µs */

#define WWDT_COUNTER        0x7F
#define WWDT_WINDOW         0x6F

/* Window opens after (0x7F - 0x6F) × 273µs = 4.4 ms */
#define WINDOW_OPEN_MS      ((0x7F - WWDT_WINDOW) * WWDT_TICK_US / 1000)

/* Timeout after (0x7F - 0x3F) × 273µs = 17.4 ms */
#define TIMEOUT_MS          ((WWDT_COUNTER - 0x3F) * WWDT_TICK_US / 1000)
```

### 3. Use Early Warning Interrupt as Safety Net

```c
/* Enable interrupt as backup refresh mechanism */
wwdt_interrupt_enable();
nvic_irq_enable(WWDT_IRQn, 0, 0);

void WWDT_IRQHandler(void)
{
  if(wwdt_interrupt_flag_get() != RESET)
  {
    wwdt_flag_clear();
    wwdt_counter_set(0x7F);
    
    /* Log that main loop missed refresh deadline */
    error_log("WWDT: Main loop timing exceeded!");
  }
}
```

### 4. Avoid Refresh in Uncontrolled Contexts

```c
/* BAD: Refresh in random interrupt can mask timing issues */
void TIM2_GLOBAL_IRQHandler(void)
{
  wwdt_counter_set(0x7F);  /* Hides main loop problems */
}

/* GOOD: Only refresh in main loop or dedicated handler */
while(1)
{
  process_tasks();
  
  if(wwdt_is_refresh_safe())
    wwdt_counter_set(0x7F);
}
```

---

## Troubleshooting

### Common Issues

1. **Immediate Reset After Enable**
   - Counter or window value outside valid range (0x40-0x7F)
   - Trying to refresh before window opens

2. **Unexpected Resets During Normal Operation**
   - Main loop execution time varies beyond window
   - Interrupt taking too long, delaying refresh
   - Refresh called too early (before window opens)

3. **Early Warning Interrupt Not Firing**
   - Forgot to enable interrupt (`wwdt_interrupt_enable()`)
   - NVIC not configured for WWDT_IRQn
   - Counter refreshed before reaching 0x40

4. **Cannot Disable WWDT**
   - By design - once WWDTEN is set, only system reset can clear it
   - Use `wwdt_reset()` via CRM before enabling if needed

### Debug Checklist

- [ ] WWDT peripheral clock enabled
- [ ] Divider configured before enable
- [ ] Window value set before enable
- [ ] Counter and window values in range (0x40-0x7F)
- [ ] Window value ≤ counter value
- [ ] Main loop executes within window timing
- [ ] No early refresh (wait for CNT < WIN)
- [ ] NVIC configured if using interrupt
- [ ] Interrupt handler clears flag

### Timing Debug

```c
/* Add timing instrumentation */
volatile uint32_t loop_start_tick;
volatile uint32_t loop_end_tick;
volatile uint32_t max_loop_time = 0;

while(1)
{
  loop_start_tick = systick_get();
  
  /* Main loop processing */
  process_tasks();
  
  loop_end_tick = systick_get();
  uint32_t loop_time = loop_end_tick - loop_start_tick;
  
  if(loop_time > max_loop_time)
  {
    max_loop_time = loop_time;
    printf("New max loop time: %lu\n", max_loop_time);
  }
  
  /* Refresh WWDT */
  if(wwdt_is_refresh_safe())
    wwdt_counter_set(0x7F);
}
```

---

## Application Notes

- **AN0069**: Artery MCU Reset and Boot Guide
- **AN0001**: Getting Started with AT32F403A/407

---

## See Also

- [WDT (Independent Watchdog Timer)](WDT_Watchdog_Timer.md)
- [CRM (Clock and Reset Management)](CRM_Clock_Reset_Management.md)
- [TMR (Timer)](TMR_Timer.md)

