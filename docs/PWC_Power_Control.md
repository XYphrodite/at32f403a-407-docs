# PWC (Power Control) Peripheral - AT32F403A/407

## Table of Contents

1. [Overview](#overview)
2. [Key Features](#key-features)
3. [Power Modes](#power-modes)
4. [Power Mode Comparison](#power-mode-comparison)
5. [Wakeup Sources](#wakeup-sources)
6. [Power Voltage Monitor (PVM)](#power-voltage-monitor-pvm)
7. [Configuration Types](#configuration-types)
8. [Status Flags](#status-flags)
9. [Register Overview](#register-overview)
10. [Low-Level API Reference](#low-level-api-reference)
11. [Practical Examples](#practical-examples)
12. [Clock Recovery After Low-Power Modes](#clock-recovery-after-low-power-modes)
13. [Battery-Powered Domain](#battery-powered-domain)
14. [Power Consumption Optimization](#power-consumption-optimization)
15. [Troubleshooting](#troubleshooting)
16. [Important Notes](#important-notes)

---

## Overview

The PWC (Power Control) peripheral on the AT32F403A/407 microcontroller provides comprehensive power management capabilities to optimize power consumption in various operating scenarios. It supports multiple low-power modes, power voltage monitoring, and wakeup mechanisms.

The PWC peripheral allows the MCU to enter different low-power states to reduce power consumption during periods of inactivity while maintaining the ability to quickly resume normal operation when needed.

### Key Responsibilities

- **Low-Power Mode Management**: Sleep, Deep Sleep, and Standby modes
- **Power Voltage Monitoring**: Monitor VDD for brown-out conditions
- **Wakeup Control**: Configure wakeup sources and pins
- **Voltage Regulator Control**: Optimize regulator for low-power modes
- **Battery-Powered Domain Access**: Control access to RTC and backup registers

---

## Key Features

- **Three Low-Power Modes**:
  - Sleep Mode: CPU clock stopped, peripherals running
  - Deep Sleep Mode: CPU and most peripherals stopped, fast wakeup
  - Standby Mode: Lowest power, full system reset on wakeup

- **Power Voltage Monitor (PVM)**:
  - Programmable voltage thresholds: 2.3V to 2.9V
  - Interrupt on voltage threshold crossing
  - Real-time voltage monitoring output

- **Wakeup Sources**:
  - External interrupts (EXINT)
  - Wakeup pin (PA0/WKUP)
  - RTC alarm
  - Timer interrupts
  - USART receive

- **Voltage Regulator Control**:
  - Normal mode for active operation
  - Low-power mode for deep sleep

- **Battery-Powered Domain**:
  - Access control to RTC and BPR registers
  - Maintains data during main power loss

---

## Power Modes

### Run Mode (Normal Operation)

- CPU and all peripherals active
- Full clock frequency
- Highest power consumption
- Used for normal application execution

### Sleep Mode

- **Entry**: `pwc_sleep_mode_enter()`
- **CPU**: Stopped
- **Peripherals**: Running
- **Clocks**: System clocks running
- **SRAM/Registers**: Retained
- **Wakeup Time**: Immediate (no clock recovery needed)
- **Wakeup Sources**: Any interrupt

```c
/* Enter sleep mode using WFI */
pwc_sleep_mode_enter(PWC_SLEEP_ENTER_WFI);
```

### Deep Sleep Mode

- **Entry**: `pwc_deep_sleep_mode_enter()`
- **CPU**: Stopped
- **Peripherals**: Stopped (except RTC, IWDG if enabled)
- **Clocks**: HEXT and PLL stopped, LEXT/LICK can run
- **SRAM/Registers**: Retained
- **Wakeup Time**: Depends on clock recovery
- **Wakeup Sources**: EXINT, RTC alarm, IWDG

```c
/* Configure voltage regulator for low power */
pwc_voltage_regulate_set(PWC_REGULATOR_LOW_POWER);

/* Enter deep sleep mode using WFI */
pwc_deep_sleep_mode_enter(PWC_DEEP_SLEEP_ENTER_WFI);
```

### Standby Mode

- **Entry**: `pwc_standby_mode_enter()`
- **CPU**: Stopped
- **Peripherals**: Stopped (except RTC, IWDG if enabled)
- **Clocks**: All stopped except LEXT/LICK
- **SRAM/Registers**: Lost (except backup domain)
- **Wakeup Time**: Similar to reset
- **Wakeup Sources**: WKUP pin, RTC alarm, IWDG, NRST pin

```c
/* Enable wakeup pin */
pwc_wakeup_pin_enable(PWC_WAKEUP_PIN_1, TRUE);

/* Enter standby mode (no return - system resets on wakeup) */
pwc_standby_mode_enter();
```

---

## Power Mode Comparison

| Feature | Run | Sleep | Deep Sleep | Standby |
|---------|-----|-------|------------|---------|
| CPU | Running | Stopped | Stopped | Stopped |
| Peripherals | Running | Running | Stopped | Stopped |
| HEXT/PLL | Running | Running | Stopped | Stopped |
| HICK | Running | Running | Running¹ | Stopped |
| LEXT/LICK | Running | Running | Running | Running |
| SRAM | Retained | Retained | Retained | Lost |
| I/O States | Active | Active | Active | Hi-Z |
| Wakeup Latency | N/A | Immediate | ~µs | ~ms |
| Regulator | Normal | Normal | Normal/LP | Off |

¹ HICK resumes automatically on wakeup from deep sleep

---

## Wakeup Sources

### Sleep Mode Wakeup

Any enabled interrupt can wake the CPU from sleep mode:

- Timer interrupts (TMR2, TMR3, etc.)
- USART receive interrupt
- External interrupts (EXINT)
- DMA interrupts
- Any peripheral interrupt

### Deep Sleep Mode Wakeup

Limited wakeup sources:

| Source | EXINT Line | Notes |
|--------|------------|-------|
| RTC Alarm | EXINT_LINE_17 | Requires RTC configuration |
| External Pin | EXINT_LINE_0-15 | GPIO configured as EXINT |
| IWDG | - | If IWDG enabled |

### Standby Mode Wakeup

Most restricted wakeup sources:

| Source | Description |
|--------|-------------|
| WKUP Pin (PA0) | Rising edge on PA0 |
| RTC Alarm | Configured RTC alarm event |
| IWDG Reset | Independent watchdog timeout |
| NRST Pin | External reset |

### Wakeup Pin Configuration

```c
/* PWC_WAKEUP_PIN_1 corresponds to PA0 */
#define PWC_WAKEUP_PIN_1  ((uint32_t)0x00000100)

/* Enable wakeup pin for standby mode */
pwc_wakeup_pin_enable(PWC_WAKEUP_PIN_1, TRUE);
```

---

## Power Voltage Monitor (PVM)

The PVM monitors the VDD voltage and can generate an interrupt when VDD crosses a programmable threshold.

### Voltage Thresholds

```c
typedef enum
{
    PWC_PVM_VOLTAGE_2V3 = 0x01,  /* 2.3V threshold */
    PWC_PVM_VOLTAGE_2V4 = 0x02,  /* 2.4V threshold */
    PWC_PVM_VOLTAGE_2V5 = 0x03,  /* 2.5V threshold */
    PWC_PVM_VOLTAGE_2V6 = 0x04,  /* 2.6V threshold */
    PWC_PVM_VOLTAGE_2V7 = 0x05,  /* 2.7V threshold */
    PWC_PVM_VOLTAGE_2V8 = 0x06,  /* 2.8V threshold */
    PWC_PVM_VOLTAGE_2V9 = 0x07   /* 2.9V threshold */
} pwc_pvm_voltage_type;
```

### PVM Output Flag

- `PWC_PVM_OUTPUT_FLAG = SET`: VDD is below the threshold
- `PWC_PVM_OUTPUT_FLAG = RESET`: VDD is above the threshold

### PVM Interrupt (EXINT_LINE_16)

The PVM can trigger an interrupt via EXINT line 16:

```c
void pvm_exint_config(void)
{
    exint_init_type exint_init_struct;
    
    /* Configure EXINT line 16 for PVM */
    exint_init_struct.line_select = EXINT_LINE_16;
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_polarity = EXINT_TRIGGER_BOTH_EDGE;
    exint_init(&exint_init_struct);
}
```

### PVM Configuration Example

```c
/* Enable PWC clock */
crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);

/* Set voltage threshold to 2.9V */
pwc_pvm_level_select(PWC_PVM_VOLTAGE_2V9);

/* Enable PVM */
pwc_power_voltage_monitor_enable(TRUE);

/* Configure EXINT for PVM interrupt */
pvm_exint_config();

/* Enable PVM interrupt in NVIC */
nvic_irq_enable(PVM_IRQn, 0, 0);
```

---

## Configuration Types

### Sleep Enter Type

```c
typedef enum
{
    PWC_SLEEP_ENTER_WFI = 0x00,  /* Enter sleep with WFI instruction */
    PWC_SLEEP_ENTER_WFE = 0x01   /* Enter sleep with WFE instruction */
} pwc_sleep_enter_type;
```

### Deep Sleep Enter Type

```c
typedef enum
{
    PWC_DEEP_SLEEP_ENTER_WFI = 0x00,  /* Enter deep sleep with WFI */
    PWC_DEEP_SLEEP_ENTER_WFE = 0x01   /* Enter deep sleep with WFE */
} pwc_deep_sleep_enter_type;
```

### Voltage Regulator Type

```c
typedef enum
{
    PWC_REGULATOR_ON        = 0x00,  /* Regulator on during deep sleep */
    PWC_REGULATOR_LOW_POWER = 0x01   /* Regulator in low-power mode */
} pwc_regulator_type;
```

### WFI vs WFE

| Instruction | Description | Wakeup Condition |
|-------------|-------------|------------------|
| WFI | Wait For Interrupt | Any pending interrupt |
| WFE | Wait For Event | Pending event or interrupt |

**Note:** WFE is useful when you want to wait for events without necessarily generating interrupts.

---

## Status Flags

### Flag Definitions

```c
#define PWC_WAKEUP_FLAG      ((uint32_t)0x00000001)  /* Wakeup event flag */
#define PWC_STANDBY_FLAG     ((uint32_t)0x00000002)  /* Standby mode flag */
#define PWC_PVM_OUTPUT_FLAG  ((uint32_t)0x00000004)  /* PVM output flag */
```

### Flag Descriptions

| Flag | Description | Clear Method |
|------|-------------|--------------|
| `PWC_WAKEUP_FLAG` | Set when wakeup event occurs | Write 1 to CLSWEF |
| `PWC_STANDBY_FLAG` | Set when waking from standby | Write 1 to CLSEF |
| `PWC_PVM_OUTPUT_FLAG` | Current PVM output state | Read-only |

### Flag Usage Example

```c
/* Check if waking from standby mode */
if(pwc_flag_get(PWC_STANDBY_FLAG) != RESET)
{
    /* Woke up from standby mode */
    pwc_flag_clear(PWC_STANDBY_FLAG);
    
    /* Restore application state from backup domain */
}

/* Check if wakeup event occurred */
if(pwc_flag_get(PWC_WAKEUP_FLAG) != RESET)
{
    /* Wakeup event (e.g., WKUP pin rising edge) */
    pwc_flag_clear(PWC_WAKEUP_FLAG);
}

/* Check current PVM status */
if(pwc_flag_get(PWC_PVM_OUTPUT_FLAG) == SET)
{
    /* VDD is below threshold - take action */
}
```

---

## Register Overview

### PWC Register Structure

```c
typedef struct
{
    union
    {
        __IO uint32_t ctrl;       /* Control register, offset: 0x00 */
        struct
        {
            __IO uint32_t vrsel   : 1;  /* [0] Voltage regulator select */
            __IO uint32_t lpsel   : 1;  /* [1] Low-power mode select */
            __IO uint32_t clswef  : 1;  /* [2] Clear standby wakeup flag */
            __IO uint32_t clsef   : 1;  /* [3] Clear standby flag */
            __IO uint32_t pvmen   : 1;  /* [4] PVM enable */
            __IO uint32_t pvmsel  : 3;  /* [7:5] PVM level select */
            __IO uint32_t bpwen   : 1;  /* [8] Battery-powered domain write enable */
            __IO uint32_t reserved1 : 23;
        } ctrl_bit;
    };
    
    union
    {
        __IO uint32_t ctrlsts;    /* Control/Status register, offset: 0x04 */
        struct
        {
            __IO uint32_t swef    : 1;  /* [0] Standby wakeup event flag */
            __IO uint32_t sef     : 1;  /* [1] Standby flag */
            __IO uint32_t pvmof   : 1;  /* [2] PVM output flag */
            __IO uint32_t reserved1 : 5;
            __IO uint32_t swpen   : 1;  /* [8] Standby wakeup pin enable */
            __IO uint32_t reserved2 : 23;
        } ctrlsts_bit;
    };
} pwc_type;

#define PWC  ((pwc_type *) PWC_BASE)
```

### Register Bit Descriptions

#### CTRL Register (0x00)

| Bit | Name | Description |
|-----|------|-------------|
| 0 | VRSEL | 0: Regulator ON, 1: Regulator low-power in deep sleep |
| 1 | LPSEL | 0: Deep sleep, 1: Standby mode |
| 2 | CLSWEF | Write 1 to clear SWEF flag |
| 3 | CLSEF | Write 1 to clear SEF flag |
| 4 | PVMEN | PVM enable |
| 7:5 | PVMSEL | PVM threshold selection |
| 8 | BPWEN | Battery-powered domain write enable |

#### CTRLSTS Register (0x04)

| Bit | Name | Description |
|-----|------|-------------|
| 0 | SWEF | Standby wakeup event flag |
| 1 | SEF | Standby flag |
| 2 | PVMOF | PVM output flag (read-only) |
| 8 | SWPEN | Standby wakeup pin enable |

---

## Low-Level API Reference

### Initialization Functions

```c
/* Reset PWC peripheral */
void pwc_reset(void);
```

### Battery-Powered Domain Access

```c
/* Enable/disable access to battery-powered domain (RTC, BPR) */
void pwc_battery_powered_domain_access(confirm_state new_state);
```

### Power Voltage Monitor Functions

```c
/* Select PVM voltage threshold */
void pwc_pvm_level_select(pwc_pvm_voltage_type pvm_voltage);

/* Enable/disable PVM */
void pwc_power_voltage_monitor_enable(confirm_state new_state);
```

### Low-Power Mode Functions

```c
/* Enter sleep mode */
void pwc_sleep_mode_enter(pwc_sleep_enter_type pwc_sleep_enter);

/* Enter deep sleep mode */
void pwc_deep_sleep_mode_enter(pwc_deep_sleep_enter_type pwc_deep_sleep_enter);

/* Set voltage regulator mode for deep sleep */
void pwc_voltage_regulate_set(pwc_regulator_type pwc_regulator);

/* Enter standby mode (does not return) */
void pwc_standby_mode_enter(void);
```

### Wakeup Pin Functions

```c
/* Enable/disable wakeup pin for standby mode */
void pwc_wakeup_pin_enable(uint32_t pin_num, confirm_state new_state);
```

### Flag Functions

```c
/* Get PWC flag status */
flag_status pwc_flag_get(uint32_t pwc_flag);

/* Clear PWC flag */
void pwc_flag_clear(uint32_t pwc_flag);
```

---

## Practical Examples

### Example 1: Sleep Mode with Timer Wakeup

Wake from sleep mode using TMR2 overflow interrupt.

```c
void tmr2_config(void)
{
    crm_clocks_freq_type crm_clocks_freq_struct = {0};
    
    /* Enable TMR2 clock */
    crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
    
    /* Get system clock */
    crm_clocks_freq_get(&crm_clocks_freq_struct);
    
    /* Configure for 1 second overflow: (sclk/10000)/10000 = 1Hz */
    tmr_base_init(TMR2, 9999, (crm_clocks_freq_struct.sclk_freq/10000 - 1));
    tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
    tmr_clock_source_div_set(TMR2, TMR_CLOCK_DIV1);
    
    /* Enable overflow interrupt */
    tmr_interrupt_enable(TMR2, TMR_OVF_INT, TRUE);
    nvic_irq_enable(TMR2_GLOBAL_IRQn, 0, 0);
    
    /* Start timer */
    tmr_counter_enable(TMR2, TRUE);
}

int main(void)
{
    __IO uint32_t systick_index = 0;
    
    system_clock_config();
    at32_board_init();
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    
    /* Enable PWC clock */
    crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
    
    /* Configure TMR2 for wakeup */
    tmr2_config();
    
    while(1)
    {
        at32_led_off(LED2);
        
        /* Save and disable SysTick */
        systick_index = SysTick->CTRL;
        systick_index &= ~((uint32_t)0xFFFFFFFE);
        SysTick->CTRL &= (uint32_t)0xFFFFFFFE;
        
        /* Enter sleep mode */
        pwc_sleep_mode_enter(PWC_SLEEP_ENTER_WFI);
        
        /* Restore SysTick */
        SysTick->CTRL |= systick_index;
        
        /* Woken up by TMR2 interrupt */
        at32_led_on(LED2);
        delay_ms(500);
    }
}

void TMR2_GLOBAL_IRQHandler(void)
{
    if(tmr_flag_get(TMR2, TMR_OVF_FLAG) != RESET)
    {
        tmr_flag_clear(TMR2, TMR_OVF_FLAG);
        /* Interrupt handler - CPU resumes after WFI */
    }
}
```

### Example 2: Sleep Mode with USART Wakeup

Wake from sleep mode when data is received on USART1.

```c
void usart1_config(uint32_t baudrate)
{
    gpio_init_type gpio_init_struct;
    
    crm_periph_clock_enable(CRM_USART1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    /* Configure TX pin (PA9) */
    gpio_default_para_init(&gpio_init_struct);
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
    gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init_struct.gpio_pins = GPIO_PINS_9;
    gpio_init(GPIOA, &gpio_init_struct);
    
    /* Configure RX pin (PA10) */
    gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
    gpio_init_struct.gpio_pull = GPIO_PULL_UP;
    gpio_init_struct.gpio_pins = GPIO_PINS_10;
    gpio_init(GPIOA, &gpio_init_struct);
    
    /* Configure USART */
    nvic_irq_enable(USART1_IRQn, 0, 0);
    usart_init(USART1, baudrate, USART_DATA_8BITS, USART_STOP_1_BIT);
    usart_parity_selection_config(USART1, USART_PARITY_NONE);
    usart_transmitter_enable(USART1, TRUE);
    usart_receiver_enable(USART1, TRUE);
    usart_hardware_flow_control_set(USART1, USART_HARDWARE_FLOW_NONE);
    
    /* Enable receive interrupt */
    usart_interrupt_enable(USART1, USART_RDBF_INT, TRUE);
    usart_enable(USART1, TRUE);
}

int main(void)
{
    __IO uint32_t systick_index = 0;
    
    system_clock_config();
    at32_board_init();
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    
    crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
    usart1_config(115200);
    
    printf("Exit sleep mode by USART1 RDBF interrupt\r\n");
    
    while(1)
    {
        at32_led_off(LED2);
        printf("Now entering sleep mode\r\n");
        
        /* Save and disable SysTick */
        systick_index = SysTick->CTRL;
        systick_index &= ~((uint32_t)0xFFFFFFFE);
        SysTick->CTRL &= (uint32_t)0xFFFFFFFE;
        
        /* Enter sleep mode */
        pwc_sleep_mode_enter(PWC_SLEEP_ENTER_WFI);
        
        /* Restore SysTick */
        SysTick->CTRL |= systick_index;
        
        printf("Woken up by USART1 receive\r\n");
        at32_led_on(LED2);
        delay_ms(500);
    }
}

void USART1_IRQHandler(void)
{
    if(usart_flag_get(USART1, USART_RDBF_FLAG) != RESET)
    {
        uint8_t data = usart_data_receive(USART1);
        /* Process received data */
    }
}
```

### Example 3: Deep Sleep Mode with RTC Alarm Wakeup

Wake from deep sleep mode using RTC alarm after 3 seconds.

```c
void rtc_config(void)
{
    exint_init_type exint_init_struct;
    
    /* Configure EXINT line 17 for RTC alarm */
    exint_init_struct.line_select = EXINT_LINE_17;
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_polarity = EXINT_TRIGGER_RISING_EDGE;
    exint_init(&exint_init_struct);
    
    /* Enable battery-powered domain access */
    pwc_battery_powered_domain_access(TRUE);
    
    /* Reset BPR */
    bpr_reset();
    
    /* Enable LICK */
    crm_clock_source_enable(CRM_CLOCK_SOURCE_LICK, TRUE);
    while(crm_flag_get(CRM_LICK_STABLE_FLAG) == RESET);
    
    /* Select RTC clock source */
    crm_rtc_clock_select(CRM_RTC_CLOCK_LICK);
    crm_rtc_clock_enable(TRUE);
    
    /* Wait for RTC registers update */
    rtc_wait_update_finish();
    
    /* Set RTC divider for 1 second period */
    rtc_divider_set(32767);
    rtc_wait_config_finish();
    
    /* Enable alarm interrupt */
    rtc_interrupt_enable(RTC_TA_INT, TRUE);
    rtc_wait_config_finish();
    
    nvic_irq_enable(RTCAlarm_IRQn, 0, 0);
}

void system_clock_recover(void)
{
    /* Enable HEXT */
    crm_clock_source_enable(CRM_CLOCK_SOURCE_HEXT, TRUE);
    while(crm_hext_stable_wait() == ERROR);
    
    /* Enable PLL */
    crm_clock_source_enable(CRM_CLOCK_SOURCE_PLL, TRUE);
    while(crm_flag_get(CRM_PLL_STABLE_FLAG) == RESET);
    
    /* Enable auto step mode */
    crm_auto_step_mode_enable(TRUE);
    
    /* Switch to PLL */
    crm_sysclk_switch(CRM_SCLK_PLL);
    while(crm_sysclk_switch_status_get() != CRM_SCLK_PLL);
}

int main(void)
{
    crm_clocks_freq_type crm_clocks_freq_struct = {0};
    __IO uint32_t systick_index = 0;
    
    system_clock_config();
    crm_clocks_freq_get(&crm_clocks_freq_struct);
    at32_board_init();
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    
    /* Enable PWC and BPR clocks */
    crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
    
    rtc_config();
    
    while(1)
    {
        /* Wait for RTC second flag */
        rtc_flag_clear(RTC_TS_FLAG);
        while(rtc_flag_get(RTC_TS_FLAG) == RESET);
        
        /* Set alarm for 3 seconds from now */
        rtc_alarm_set(rtc_counter_get() + 3);
        rtc_wait_config_finish();
        
        at32_led_off(LED2);
        
        /* Save and disable SysTick */
        systick_index = SysTick->CTRL;
        systick_index &= ~((uint32_t)0xFFFFFFFE);
        SysTick->CTRL &= (uint32_t)0xFFFFFFFE;
        
        /* Configure voltage regulator for low power */
        pwc_voltage_regulate_set(PWC_REGULATOR_LOW_POWER);
        
        /* Enter deep sleep mode */
        pwc_deep_sleep_mode_enter(PWC_DEEP_SLEEP_ENTER_WFI);
        
        /* Restore SysTick */
        SysTick->CTRL |= systick_index;
        
        /* Wait for clock stabilization after wakeup */
        /* System clock returns to HICK after deep sleep */
        if((CRM->misc3_bit.hick_to_sclk == TRUE) && (CRM->misc1_bit.hickdiv == TRUE))
        {
            delay_us(((120 * 6 * HICK_VALUE) / crm_clocks_freq_struct.sclk_freq) + 1);
        }
        else
        {
            delay_us(((120 * HICK_VALUE) / crm_clocks_freq_struct.sclk_freq) + 1);
        }
        
        /* Recover system clock to PLL */
        system_clock_recover();
        
        at32_led_on(LED2);
        delay_ms(500);
    }
}

void RTCAlarm_IRQHandler(void)
{
    if(rtc_flag_get(RTC_TA_FLAG) != RESET)
    {
        rtc_flag_clear(RTC_TA_FLAG);
        exint_flag_clear(EXINT_LINE_17);
    }
}
```

### Example 4: Standby Mode with Wakeup Pin

Enter standby mode and wake up via WKUP pin (PA0) rising edge.

```c
int main(void)
{
    system_clock_config();
    at32_board_init();
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    
    at32_led_off(LED2);
    at32_led_off(LED3);
    at32_led_off(LED4);
    
    /* Enable PWC clock */
    crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
    
    /* Check if waking from standby mode */
    if(pwc_flag_get(PWC_STANDBY_FLAG) != RESET)
    {
        pwc_flag_clear(PWC_STANDBY_FLAG);
        at32_led_on(LED2);  /* Indicate standby wakeup */
    }
    
    /* Check if wakeup event occurred */
    if(pwc_flag_get(PWC_WAKEUP_FLAG) != RESET)
    {
        pwc_flag_clear(PWC_WAKEUP_FLAG);
        at32_led_on(LED3);  /* Indicate wakeup event */
    }
    
    at32_led_on(LED4);  /* Indicate running */
    
    /* Wait to observe LED states */
    delay_ms(1000);
    
    /* Enable wakeup pin (PA0) */
    pwc_wakeup_pin_enable(PWC_WAKEUP_PIN_1, TRUE);
    
    /* Enter standby mode (does not return) */
    pwc_standby_mode_enter();
    
    /* Code never reaches here */
    while(1);
}
```

### Example 5: Standby Mode with RTC Alarm Wakeup

Enter standby mode and wake up after 10 seconds via RTC alarm.

```c
void rtc_config(void)
{
    pwc_battery_powered_domain_access(TRUE);
    bpr_reset();
    
    crm_clock_source_enable(CRM_CLOCK_SOURCE_LICK, TRUE);
    while(crm_flag_get(CRM_LICK_STABLE_FLAG) == RESET);
    
    crm_rtc_clock_select(CRM_RTC_CLOCK_LICK);
    crm_rtc_clock_enable(TRUE);
    
    rtc_wait_update_finish();
    rtc_divider_set(32767);
    rtc_wait_config_finish();
}

void rtc_alarm_config(uint8_t alarm_time)
{
    rtc_flag_clear(RTC_TS_FLAG);
    while(rtc_flag_get(RTC_TS_FLAG) == RESET);
    
    rtc_alarm_set(rtc_counter_get() + alarm_time);
    rtc_wait_config_finish();
}

int main(void)
{
    system_clock_config();
    at32_board_init();
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    
    at32_led_off(LED2);
    at32_led_off(LED3);
    at32_led_off(LED4);
    
    /* Enable PWC and BPR clocks */
    crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
    
    /* Check wakeup source */
    if(pwc_flag_get(PWC_STANDBY_FLAG) != RESET)
    {
        pwc_flag_clear(PWC_STANDBY_FLAG);
        at32_led_on(LED2);
    }
    
    if(pwc_flag_get(PWC_WAKEUP_FLAG) != RESET)
    {
        pwc_flag_clear(PWC_WAKEUP_FLAG);
        at32_led_on(LED3);
    }
    
    /* Configure RTC */
    rtc_config();
    
    at32_led_on(LED4);
    delay_ms(1000);
    
    /* Set alarm for 10 seconds */
    rtc_alarm_config(10);
    
    /* Enter standby mode */
    pwc_standby_mode_enter();
    
    while(1);
}
```

### Example 6: Power Voltage Monitor

Monitor power supply voltage and generate interrupt on threshold crossing.

```c
void pvm_exint_config(void)
{
    exint_init_type exint_init_struct;
    
    exint_init_struct.line_select = EXINT_LINE_16;
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_polarity = EXINT_TRIGGER_BOTH_EDGE;
    exint_init(&exint_init_struct);
}

int main(void)
{
    system_clock_config();
    at32_board_init();
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    
    at32_led_on(LED2);
    at32_led_on(LED3);
    at32_led_on(LED4);
    
    /* Enable PWC clock */
    crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
    
    /* Set voltage threshold to 2.9V */
    pwc_pvm_level_select(PWC_PVM_VOLTAGE_2V9);
    
    /* Enable PVM */
    pwc_power_voltage_monitor_enable(TRUE);
    
    /* Configure EXINT for PVM */
    pvm_exint_config();
    
    /* Enable PVM interrupt */
    nvic_irq_enable(PVM_IRQn, 0, 0);
    
    while(1)
    {
        /* Main application - PVM runs in background */
    }
}

void PVM_IRQHandler(void)
{
    if(exint_flag_get(EXINT_LINE_16) != RESET)
    {
        exint_flag_clear(EXINT_LINE_16);
        
        if(pwc_flag_get(PWC_PVM_OUTPUT_FLAG) == SET)
        {
            /* VDD below threshold - power failing */
            at32_led_on(LED3);   /* Warning LED */
            /* Save critical data, prepare for shutdown */
        }
        else
        {
            /* VDD above threshold - power restored */
            at32_led_off(LED3);
        }
    }
}
```

---

## Clock Recovery After Low-Power Modes

### After Sleep Mode

No clock recovery needed - clocks continue running during sleep.

### After Deep Sleep Mode

When waking from deep sleep:
1. HEXT and PLL are stopped
2. System clock switches to HICK (8 MHz or 48 MHz depending on configuration)
3. Must reconfigure PLL and switch clock source

```c
void system_clock_recover(void)
{
    /* Enable HEXT */
    crm_clock_source_enable(CRM_CLOCK_SOURCE_HEXT, TRUE);
    while(crm_hext_stable_wait() == ERROR);
    
    /* Enable PLL */
    crm_clock_source_enable(CRM_CLOCK_SOURCE_PLL, TRUE);
    while(crm_flag_get(CRM_PLL_STABLE_FLAG) == RESET);
    
    /* Enable auto step mode for safe frequency transition */
    crm_auto_step_mode_enable(TRUE);
    
    /* Switch to PLL */
    crm_sysclk_switch(CRM_SCLK_PLL);
    while(crm_sysclk_switch_status_get() != CRM_SCLK_PLL);
}
```

### After Standby Mode

Full system reset occurs - no clock recovery needed, but application must reinitialize everything.

---

## Battery-Powered Domain

The battery-powered domain contains:
- RTC (Real-Time Clock)
- BPR (Backup Registers)

These are powered by VBAT and retain data when main power (VDD) is lost.

### Accessing Battery-Powered Domain

```c
/* Enable PWC and BPR clocks */
crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);

/* Enable write access to battery-powered domain */
pwc_battery_powered_domain_access(TRUE);

/* Now can configure RTC and write to backup registers */
bpr_data_write(BPR_DATA1, 0x1234);  /* Store data in backup register */

/* Optionally disable write access when done */
pwc_battery_powered_domain_access(FALSE);
```

---

## Power Consumption Optimization

### Tips for Reducing Power Consumption

1. **Disable Unused Peripherals**
   ```c
   crm_periph_clock_enable(CRM_UNUSED_PERIPH_CLOCK, FALSE);
   ```

2. **Use Low-Power Regulator in Deep Sleep**
   ```c
   pwc_voltage_regulate_set(PWC_REGULATOR_LOW_POWER);
   ```

3. **Configure Unused GPIO as Analog Input**
   ```c
   gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
   ```

4. **Disable SysTick Before Low-Power Mode**
   ```c
   SysTick->CTRL &= (uint32_t)0xFFFFFFFE;
   ```

5. **Use Standby Mode for Longest Sleep Periods**

6. **Use LICK Instead of LEXT if Accuracy Not Critical**

### Power Mode Selection Guide

| Wakeup Time | Data Retention | Recommended Mode |
|-------------|----------------|------------------|
| Immediate | All | Sleep |
| ~µs to ms | All | Deep Sleep |
| ~ms (reset) | Backup only | Standby |

---

## Troubleshooting

### Common Issues and Solutions

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| Won't enter low-power mode | Pending interrupts | Clear all pending interrupts |
| | Debug probe connected | Disconnect debugger |
| Won't wake up | Wakeup source not configured | Configure EXINT/RTC properly |
| | Interrupt not enabled in NVIC | Enable interrupt |
| Clock issues after wakeup | PLL not reconfigured | Call clock recovery function |
| | HEXT not stable | Wait for HEXT stable flag |
| RTC not working | BPR domain access disabled | Enable `pwc_battery_powered_domain_access(TRUE)` |
| | RTC clock not enabled | Enable RTC clock in CRM |
| PVM not triggering | Wrong threshold | Adjust threshold level |
| | EXINT not configured | Configure EXINT_LINE_16 |

### Debug Considerations

- Debug probe may prevent entering low-power modes
- Use LED indicators to confirm mode entry/exit
- Check flags after wakeup to identify source

---

## Important Notes

1. **Standby Mode Reset**: Waking from standby mode causes a system reset. All SRAM contents are lost except backup registers.

2. **Wakeup Pin**: PA0 serves as WKUP pin. Ensure it's not used for other purposes when standby wakeup is needed.

3. **Debug Mode**: Low-power modes may not work correctly when debugger is connected. The `DEBUG` peripheral can freeze some behaviors.

4. **SysTick**: Disable SysTick before entering low-power modes to prevent unintended wakeups.

5. **IWDG**: If Independent Watchdog is enabled, it will reset the MCU in standby mode unless configured for standby operation.

6. **Clock Recovery Time**: After deep sleep, wait for LICK cycles (~120µs max) before accessing peripherals.

7. **PVM Hysteresis**: PVM has built-in hysteresis to prevent oscillation at threshold boundary.

8. **Write Access**: Battery-powered domain write access must be explicitly enabled before configuring RTC or writing to BPR.

9. **WFI vs WFE**:
   - WFI wakes on any pending interrupt
   - WFE wakes on events (can be used without interrupt handler)

10. **Regulator Selection**: Low-power regulator reduces power but increases wakeup latency slightly.

---

## References

- AT32F403A/407 Reference Manual
- AT32F403A/407 Datasheet
- Application Note AN0100 - Low Power Modes
- ARM Cortex-M4 Technical Reference Manual (WFI/WFE instructions)

