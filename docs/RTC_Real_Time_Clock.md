# RTC (Real-Time Clock) Peripheral - AT32F403A/407

## Table of Contents

1. [Overview](#overview)
2. [Key Features](#key-features)
3. [Clock Sources](#clock-sources)
4. [RTC Architecture](#rtc-architecture)
5. [Interrupts and Flags](#interrupts-and-flags)
6. [Register Overview](#register-overview)
7. [Low-Level API Reference](#low-level-api-reference)
8. [Calendar Implementation](#calendar-implementation)
9. [Practical Examples](#practical-examples)
10. [LICK Calibration](#lick-calibration)
11. [Alarm Functionality](#alarm-functionality)
12. [RTC Output Options](#rtc-output-options)
13. [Battery Backup Domain](#battery-backup-domain)
14. [Low-Power Mode Integration](#low-power-mode-integration)
15. [Troubleshooting](#troubleshooting)
16. [Important Notes](#important-notes)

---

## Overview

The RTC (Real-Time Clock) peripheral on the AT32F403A/407 microcontroller provides a 32-bit counter that can be used for timekeeping. Unlike newer MCUs with built-in calendar hardware, this RTC uses a simple counter-based approach where software converts the counter value to calendar format (year, month, day, hour, minute, second).

The RTC operates independently of the main system clock and can continue running when the main power is off, using VBAT backup power. This makes it ideal for maintaining time information across power cycles.

### Key Responsibilities

- **Timekeeping**: Maintain accurate time using a 32-bit counter
- **Alarm Generation**: Trigger alarms at specific counter values
- **Low-Power Wakeup**: Wake the system from sleep/standby modes
- **Calendar Conversion**: Software conversion between counter and calendar format

---

## Key Features

- **32-bit Counter**: Count from 0 to 0xFFFFFFFF (over 136 years at 1 Hz)
- **Programmable Prescaler**: 20-bit divider for flexible clock division
- **Multiple Clock Sources**:
  - LEXT (32.768 kHz external crystal)
  - LICK (~40 kHz internal RC oscillator)
  - HEXT/128 (external crystal divided by 128)

- **Interrupt Sources**:
  - Time Second (1 Hz tick)
  - Alarm match
  - Counter overflow

- **Battery Backup**: Continues operation on VBAT when VDD is off
- **Tamper Detection**: Integration with BPR tamper pin
- **Output Options**: Second pulse or alarm output on tamper pin

---

## Clock Sources

### Available Clock Sources

| Source | Frequency | Accuracy | Notes |
|--------|-----------|----------|-------|
| LEXT | 32.768 kHz | ±20 ppm typical | Best accuracy, requires crystal |
| LICK | ~40 kHz | ±10% typical | No external components, needs calibration |
| HEXT/128 | Variable | Depends on HEXT | Not available during sleep modes |

### Clock Source Selection

```c
/* Select LEXT as RTC clock source (recommended for accuracy) */
crm_rtc_clock_select(CRM_RTC_CLOCK_LEXT);

/* Select LICK as RTC clock source (internal, less accurate) */
crm_rtc_clock_select(CRM_RTC_CLOCK_LICK);

/* Select HEXT/128 as RTC clock source */
crm_rtc_clock_select(CRM_RTC_CLOCK_HEXT_DIV_128);
```

### Prescaler Configuration

To achieve 1 Hz (1 second) tick from the clock source:

```c
/* For LEXT (32.768 kHz): Divider = 32768 - 1 = 32767 */
rtc_divider_set(32767);

/* For LICK (~40 kHz): Divider = 40000 - 1 = 39999 (adjust after calibration) */
rtc_divider_set(39999);
```

**Formula**: `RTC_Tick = RTC_Clock / (Prescaler + 1)`

---

## RTC Architecture

### Block Diagram

```
                    ┌─────────────────────────────────────────┐
                    │              RTC Peripheral              │
                    │                                         │
    Clock Source ──►│  ┌──────────┐    ┌──────────────────┐  │
    (LEXT/LICK/     │  │ 20-bit   │    │    32-bit        │  │
     HEXT÷128)      │  │ Prescaler│───►│    Counter       │  │
                    │  │ (DIV)    │    │    (CNT)         │  │
                    │  └──────────┘    └────────┬─────────┘  │
                    │                           │            │
                    │                  ┌────────▼─────────┐  │
                    │                  │    32-bit        │  │
                    │                  │    Alarm (TA)    │  │
                    │                  └────────┬─────────┘  │
                    │                           │            │
                    │  ┌────────────────────────▼─────────┐  │
                    │  │        Interrupt Flags           │  │
                    │  │  TS (Second) │ TA (Alarm) │ OVF  │  │
                    │  └──────────────────────────────────┘  │
                    │                           │            │
                    └───────────────────────────┼────────────┘
                                                │
                                                ▼
                                          IRQ to NVIC
```

### Counter Operation

1. Clock source feeds the prescaler
2. Prescaler divides clock to 1 Hz (typically)
3. Each prescaler overflow increments the 32-bit counter
4. Counter represents seconds since epoch (typically 1970-01-01)
5. Software converts counter to calendar format

---

## Interrupts and Flags

### Interrupt Types

```c
#define RTC_TS_INT   ((uint16_t)0x0001)  /* Time Second interrupt */
#define RTC_TA_INT   ((uint16_t)0x0002)  /* Time Alarm interrupt */
#define RTC_OVF_INT  ((uint16_t)0x0004)  /* Overflow interrupt */
```

| Interrupt | Description | Trigger Condition |
|-----------|-------------|-------------------|
| `RTC_TS_INT` | Time Second | Prescaler overflow (1 Hz) |
| `RTC_TA_INT` | Time Alarm | Counter matches alarm value |
| `RTC_OVF_INT` | Overflow | Counter overflows from 0xFFFFFFFF to 0 |

### Status Flags

```c
#define RTC_TS_FLAG    ((uint16_t)0x0001)  /* Time Second flag */
#define RTC_TA_FLAG    ((uint16_t)0x0002)  /* Time Alarm flag */
#define RTC_OVF_FLAG   ((uint16_t)0x0004)  /* Overflow flag */
#define RTC_UPDF_FLAG  ((uint16_t)0x0008)  /* Update finish flag */
#define RTC_CFGF_FLAG  ((uint16_t)0x0020)  /* Configuration finish flag */
```

| Flag | Description | Usage |
|------|-------------|-------|
| `RTC_TS_FLAG` | Set every second | Poll or use interrupt |
| `RTC_TA_FLAG` | Set when alarm matches | Alarm notification |
| `RTC_OVF_FLAG` | Set on counter overflow | Rarely used (136 years) |
| `RTC_UPDF_FLAG` | Set when registers updated | Wait after APB read |
| `RTC_CFGF_FLAG` | Set when config complete | Wait after register write |

### NVIC Configuration

```c
/* Enable RTC interrupt in NVIC */
nvic_irq_enable(RTC_IRQn, 0, 0);

/* For alarm wakeup from deep sleep, also configure EXINT line 17 */
nvic_irq_enable(RTCAlarm_IRQn, 0, 0);
```

---

## Register Overview

### RTC Register Structure

```c
typedef struct
{
    union
    {
        __IO uint32_t ctrlh;        /* Control High register, offset: 0x00 */
        struct
        {
            __IO uint32_t tsien  : 1;  /* [0] Time second interrupt enable */
            __IO uint32_t taien  : 1;  /* [1] Time alarm interrupt enable */
            __IO uint32_t ovfien : 1;  /* [2] Overflow interrupt enable */
            __IO uint32_t reserved1 : 29;
        } ctrlh_bit;
    };
    
    union
    {
        __IO uint32_t ctrll;        /* Control Low register, offset: 0x04 */
        struct
        {
            __IO uint32_t tsf    : 1;  /* [0] Time second flag */
            __IO uint32_t taf    : 1;  /* [1] Time alarm flag */
            __IO uint32_t ovff   : 1;  /* [2] Overflow flag */
            __IO uint32_t updf   : 1;  /* [3] Update finish flag */
            __IO uint32_t cfgen  : 1;  /* [4] Configuration enable */
            __IO uint32_t cfgf   : 1;  /* [5] Configuration finish flag */
            __IO uint32_t reserved1 : 26;
        } ctrll_bit;
    };
    
    union
    {
        __IO uint32_t divh;         /* Divider High register, offset: 0x08 */
        struct
        {
            __IO uint32_t div : 4;     /* [3:0] Prescaler high bits */
            __IO uint32_t reserved1 : 28;
        } divh_bit;
    };
    
    union
    {
        __IO uint32_t divl;         /* Divider Low register, offset: 0x0C */
        struct
        {
            __IO uint32_t div : 16;    /* [15:0] Prescaler low bits */
            __IO uint32_t reserved1 : 16;
        } divl_bit;
    };
    
    union
    {
        __IO uint32_t divcnth;      /* Divider Counter High, offset: 0x10 */
        struct
        {
            __IO uint32_t divcnt : 4;  /* [3:0] Current divider count high */
            __IO uint32_t reserved1 : 28;
        } divcnth_bit;
    };
    
    union
    {
        __IO uint32_t divcntl;      /* Divider Counter Low, offset: 0x14 */
        struct
        {
            __IO uint32_t divcnt : 16; /* [15:0] Current divider count low */
            __IO uint32_t reserved1 : 16;
        } divcntl_bit;
    };
    
    union
    {
        __IO uint32_t cnth;         /* Counter High register, offset: 0x18 */
        struct
        {
            __IO uint32_t cnt : 16;    /* [15:0] Counter high bits */
            __IO uint32_t reserved1 : 16;
        } cnth_bit;
    };
    
    union
    {
        __IO uint32_t cntl;         /* Counter Low register, offset: 0x1C */
        struct
        {
            __IO uint32_t cnt : 16;    /* [15:0] Counter low bits */
            __IO uint32_t reserved1 : 16;
        } cntl_bit;
    };
    
    union
    {
        __IO uint32_t tah;          /* Time Alarm High register, offset: 0x20 */
        struct
        {
            __IO uint32_t ta : 16;     /* [15:0] Alarm high bits */
            __IO uint32_t reserved1 : 16;
        } tah_bit;
    };
    
    union
    {
        __IO uint32_t tal;          /* Time Alarm Low register, offset: 0x24 */
        struct
        {
            __IO uint32_t ta : 16;     /* [15:0] Alarm low bits */
            __IO uint32_t reserved1 : 16;
        } tal_bit;
    };
} rtc_type;

#define RTC  ((rtc_type *) RTC_BASE)
```

### Register Access Sequence

Writing to RTC registers requires entering configuration mode:

```c
/* Enter configuration mode */
RTC->ctrll = 0x003F;  /* Set CFGEN bit */

/* Modify registers here */

/* Exit configuration mode */
RTC->ctrll = 0x000F;  /* Clear CFGEN bit */
```

---

## Low-Level API Reference

### Counter Functions

```c
/* Set the 32-bit counter value */
void rtc_counter_set(uint32_t counter_value);

/* Get the current counter value (with double-read for consistency) */
uint32_t rtc_counter_get(void);
```

### Prescaler Functions

```c
/* Set the 20-bit prescaler divider value */
void rtc_divider_set(uint32_t div_value);

/* Get the current prescaler counter value */
uint32_t rtc_divider_get(void);
```

### Alarm Functions

```c
/* Set the 32-bit alarm value */
void rtc_alarm_set(uint32_t alarm_value);
```

### Interrupt Functions

```c
/* Enable/disable RTC interrupts */
void rtc_interrupt_enable(uint16_t source, confirm_state new_state);
```

### Flag Functions

```c
/* Get flag status */
flag_status rtc_flag_get(uint16_t flag);

/* Get interrupt flag status (checks both flag and interrupt enable) */
flag_status rtc_interrupt_flag_get(uint16_t flag);

/* Clear flag */
void rtc_flag_clear(uint16_t flag);
```

### Synchronization Functions

```c
/* Wait for RTC registers to be updated from APB domain */
void rtc_wait_update_finish(void);

/* Wait for configuration write to complete */
void rtc_wait_config_finish(void);
```

---

## Calendar Implementation

Since the AT32F403A/407 RTC is counter-based, calendar functionality requires software conversion. The following implementation provides a complete calendar system.

### Calendar Structure

```c
typedef struct
{
    __IO uint16_t year;   /* 1970 - 2099 */
    __IO uint8_t  month;  /* 1 - 12 */
    __IO uint8_t  date;   /* 1 - 31 */
    __IO uint8_t  hour;   /* 0 - 23 */
    __IO uint8_t  min;    /* 0 - 59 */
    __IO uint8_t  sec;    /* 0 - 59 */
    __IO uint8_t  week;   /* 0 - 6 (Sunday - Saturday) */
} calendar_type;

extern calendar_type calendar;
```

### Epoch Reference

The calendar implementation uses Unix epoch (January 1, 1970, 00:00:00 UTC) as the reference point. The 32-bit counter stores seconds since this epoch.

### Time Constants

```c
/* Seconds per day: 24 * 60 * 60 = 86400 */
#define SECONDS_PER_DAY     86400

/* Seconds per hour: 60 * 60 = 3600 */
#define SECONDS_PER_HOUR    3600

/* Seconds per common year: 365 * 86400 = 31536000 */
#define SECONDS_PER_YEAR    31536000

/* Seconds per leap year: 366 * 86400 = 31622400 */
#define SECONDS_PER_LEAP    31622400
```

### Leap Year Detection

```c
uint8_t is_leap_year(uint16_t year)
{
    if(year % 4 == 0)
    {
        if(year % 100 == 0)
        {
            if(year % 400 == 0)
                return 1;  /* Leap year */
            else
                return 0;  /* Common year */
        }
        else
        {
            return 1;      /* Leap year */
        }
    }
    else
    {
        return 0;          /* Common year */
    }
}
```

### Days Per Month Table

```c
/* Days in each month (common year) */
const uint8_t mon_table[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

/* Week day correction table */
const uint8_t table_week[12] = {0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5};
```

### Calendar to Counter Conversion

```c
uint8_t rtc_time_set(calendar_type *calendar)
{
    uint32_t t;
    uint32_t seccount = 0;
    
    /* Validate year range */
    if(calendar->year < 1970 || calendar->year > 2099)
        return 1;
    
    /* Add seconds for complete years */
    for(t = 1970; t < calendar->year; t++)
    {
        if(is_leap_year(t))
            seccount += 31622400;  /* Leap year */
        else
            seccount += 31536000;  /* Common year */
    }
    
    /* Add seconds for complete months */
    for(t = 0; t < calendar->month - 1; t++)
    {
        seccount += mon_table[t] * 86400;
        if(is_leap_year(calendar->year) && t == 1)
            seccount += 86400;  /* February in leap year */
    }
    
    /* Add seconds for complete days */
    seccount += (calendar->date - 1) * 86400;
    
    /* Add hours, minutes, seconds */
    seccount += calendar->hour * 3600;
    seccount += calendar->min * 60;
    seccount += calendar->sec;
    
    /* Set the counter */
    rtc_counter_set(seccount);
    rtc_wait_config_finish();
    
    return 0;
}
```

### Counter to Calendar Conversion

```c
void rtc_time_get(void)
{
    static uint16_t daycnt = 0;
    uint32_t timecount = 0;
    uint32_t temp = 0;
    uint32_t temp1 = 0;
    
    timecount = rtc_counter_get();
    temp = timecount / 86400;  /* Days since epoch */
    
    if(daycnt != temp)
    {
        daycnt = temp;
        temp1 = 1970;
        
        /* Calculate year */
        while(temp >= 365)
        {
            if(is_leap_year(temp1))
            {
                if(temp >= 366)
                    temp -= 366;
                else
                    break;
            }
            else
            {
                temp -= 365;
            }
            temp1++;
        }
        calendar.year = temp1;
        
        /* Calculate month */
        temp1 = 0;
        while(temp >= 28)
        {
            if(is_leap_year(calendar.year) && temp1 == 1)
            {
                if(temp >= 29)
                    temp -= 29;
                else
                    break;
            }
            else
            {
                if(temp >= mon_table[temp1])
                    temp -= mon_table[temp1];
                else
                    break;
            }
            temp1++;
        }
        calendar.month = temp1 + 1;
        calendar.date = temp + 1;
    }
    
    /* Calculate time of day */
    temp = timecount % 86400;
    calendar.hour = temp / 3600;
    calendar.min = (temp % 3600) / 60;
    calendar.sec = (temp % 3600) % 60;
    
    /* Calculate day of week */
    calendar.week = rtc_week_get(calendar.year, calendar.month, calendar.date);
}
```

### Day of Week Calculation

```c
uint8_t rtc_week_get(uint16_t year, uint8_t month, uint8_t day)
{
    uint16_t temp2;
    uint8_t yearh, yearl;
    
    yearh = year / 100;
    yearl = year % 100;
    
    if(yearh > 19)
        yearl += 100;
    
    temp2 = yearl + yearl / 4;
    temp2 = temp2 % 7;
    temp2 = temp2 + day + table_week[month - 1];
    
    if(yearl % 4 == 0 && month < 3)
        temp2--;
    
    return(temp2 % 7);
}
```

---

## Practical Examples

### Example 1: Basic RTC Initialization with LEXT

Initialize RTC with external 32.768 kHz crystal.

```c
uint8_t rtc_init(calendar_type *init_time)
{
    /* Enable PWC and BPR clocks */
    crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
    
    /* Enable battery-powered domain write access */
    pwc_battery_powered_domain_access(TRUE);
    
    /* Check if RTC is already initialized (using backup register) */
    if(bpr_data_read(BPR_DATA1) != 0x1234)
    {
        /* First time initialization - reset backup domain */
        bpr_reset();
        
        /* Enable LEXT oscillator */
        crm_clock_source_enable(CRM_CLOCK_SOURCE_LEXT, TRUE);
        while(crm_flag_get(CRM_LEXT_STABLE_FLAG) == RESET);
        
        /* Select LEXT as RTC clock source */
        crm_rtc_clock_select(CRM_RTC_CLOCK_LEXT);
        
        /* Enable RTC clock */
        crm_rtc_clock_enable(TRUE);
        
        /* Wait for RTC registers to synchronize */
        rtc_wait_update_finish();
        rtc_wait_config_finish();
        
        /* Set prescaler for 1 Hz (32768 - 1 = 32767) */
        rtc_divider_set(32767);
        rtc_wait_config_finish();
        
        /* Set initial time */
        rtc_time_set(init_time);
        
        /* Mark as initialized */
        bpr_data_write(BPR_DATA1, 0x1234);
        
        return 1;  /* New initialization */
    }
    else
    {
        /* Already initialized - just wait for sync */
        rtc_wait_update_finish();
        rtc_wait_config_finish();
        
        return 0;  /* Already initialized */
    }
}
```

### Example 2: Calendar Display Application

Display calendar information every second.

```c
char const weekday_table[7][10] = {
    "Sunday", "Monday", "Tuesday", "Wednesday", 
    "Thursday", "Friday", "Saturday"
};

int main(void)
{
    calendar_type time_struct;
    
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    system_clock_config();
    at32_board_init();
    uart_print_init(115200);
    
    /* Set initial time: 2024-01-15 12:00:00 */
    time_struct.year  = 2024;
    time_struct.month = 1;
    time_struct.date  = 15;
    time_struct.hour  = 12;
    time_struct.min   = 0;
    time_struct.sec   = 0;
    rtc_init(&time_struct);
    
    printf("RTC Calendar Demo\r\n");
    
    while(1)
    {
        /* Check for second flag */
        if(rtc_flag_get(RTC_TS_FLAG) != RESET)
        {
            at32_led_toggle(LED3);
            
            /* Get current time */
            rtc_time_get();
            
            /* Print calendar */
            printf("%04d/%02d/%02d %02d:%02d:%02d %s\r\n",
                   calendar.year, calendar.month, calendar.date,
                   calendar.hour, calendar.min, calendar.sec,
                   weekday_table[calendar.week]);
            
            /* Clear flag */
            rtc_wait_config_finish();
            rtc_flag_clear(RTC_TS_FLAG);
            rtc_wait_config_finish();
        }
    }
}
```

### Example 3: Alarm Clock

Set an alarm and trigger interrupt when time matches.

```c
void alarm_init(void)
{
    calendar_type alarm_time;
    
    /* Clear alarm flag */
    rtc_flag_clear(RTC_TA_FLAG);
    rtc_wait_config_finish();
    
    /* Enable alarm interrupt */
    nvic_irq_enable(RTC_IRQn, 0, 0);
    rtc_interrupt_enable(RTC_TA_INT, TRUE);
    rtc_wait_config_finish();
    
    /* Set alarm for 12:00:05 on 2024-01-15 */
    alarm_time.year  = 2024;
    alarm_time.month = 1;
    alarm_time.date  = 15;
    alarm_time.hour  = 12;
    alarm_time.min   = 0;
    alarm_time.sec   = 5;
    
    rtc_alarm_clock_set(&alarm_time);
}

/* Alarm clock set helper (converts calendar to counter) */
uint8_t rtc_alarm_clock_set(calendar_type *alarm)
{
    uint16_t t;
    uint32_t seccount = 0;
    
    if(alarm->year < 1970 || alarm->year > 2099)
        return 1;
    
    /* Calculate seconds since epoch (same as rtc_time_set) */
    for(t = 1970; t < alarm->year; t++)
    {
        if(is_leap_year(t))
            seccount += 31622400;
        else
            seccount += 31536000;
    }
    
    for(t = 0; t < alarm->month - 1; t++)
    {
        seccount += mon_table[t] * 86400;
        if(is_leap_year(alarm->year) && t == 1)
            seccount += 86400;
    }
    
    seccount += (alarm->date - 1) * 86400;
    seccount += alarm->hour * 3600;
    seccount += alarm->min * 60;
    seccount += alarm->sec;
    
    /* Set alarm value */
    rtc_alarm_set(seccount);
    rtc_wait_config_finish();
    
    return 0;
}

void RTC_IRQHandler(void)
{
    if(rtc_interrupt_flag_get(RTC_TA_FLAG) != RESET)
    {
        at32_led_toggle(LED4);  /* Alarm indicator */
        rtc_flag_clear(RTC_TA_FLAG);
        
        /* Optionally set next alarm */
    }
}

int main(void)
{
    calendar_type time_struct;
    
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    system_clock_config();
    at32_board_init();
    
    /* Initialize RTC */
    time_struct.year  = 2024;
    time_struct.month = 1;
    time_struct.date  = 15;
    time_struct.hour  = 12;
    time_struct.min   = 0;
    time_struct.sec   = 0;
    rtc_init(&time_struct);
    
    /* Initialize alarm */
    alarm_init();
    
    while(1)
    {
        /* Application code */
    }
}
```

### Example 4: Second Interrupt

Use second interrupt for periodic tasks.

```c
volatile uint32_t second_counter = 0;

void rtc_second_interrupt_init(void)
{
    /* Enable RTC interrupt in NVIC */
    nvic_irq_enable(RTC_IRQn, 0, 0);
    
    /* Enable second interrupt */
    rtc_interrupt_enable(RTC_TS_INT, TRUE);
    rtc_wait_config_finish();
}

void RTC_IRQHandler(void)
{
    if(rtc_interrupt_flag_get(RTC_TS_FLAG) != RESET)
    {
        second_counter++;
        at32_led_toggle(LED3);
        
        rtc_flag_clear(RTC_TS_FLAG);
    }
}
```

---

## LICK Calibration

The internal LICK oscillator (~40 kHz) has significant variation. For accurate timekeeping, calibration is necessary.

### Calibration Method

Use a timer (TMR5) to measure the actual LICK frequency by comparing against the system clock.

### Calibration Implementation

```c
crm_clocks_freq_type crm_clocks;
__IO uint32_t periodvalue = 0;
__IO uint32_t lickfreq = 0;
__IO uint32_t operationcomplete = 0;
uint16_t tmpCC4[2] = {0, 0};

void rtc_lick_calibration(void)
{
    tmr_input_config_type tmr_ic_init_structure;
    
    /* RTC configuration with LICK and initial divider */
    crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
    pwc_battery_powered_domain_access(TRUE);
    bpr_reset();
    
    crm_clock_source_enable(CRM_CLOCK_SOURCE_LICK, TRUE);
    while(crm_flag_get(CRM_LICK_STABLE_FLAG) == RESET);
    crm_rtc_clock_select(CRM_RTC_CLOCK_LICK);
    crm_rtc_clock_enable(TRUE);
    
    rtc_wait_update_finish();
    rtc_wait_config_finish();
    
    /* Set initial divider (will be adjusted after calibration) */
    rtc_divider_set(40000);
    rtc_wait_config_finish();
    
    /* Enable second output on tamper pin for measurement */
    bpr_tamper_pin_enable(FALSE);
    bpr_rtc_output_select(BPR_RTC_OUTPUT_SECOND);
    
    /* Get system frequency */
    crm_clocks_freq_get(&crm_clocks);
    
    /* Enable TMR5 for measurement */
    crm_periph_clock_enable(CRM_TMR5_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
    
    /* Route LICK to TMR5_CH4 internally */
    gpio_pin_remap_config(TMR5CH4_MUX, TRUE);
    
    /* Configure TMR5 */
    tmr_base_init(TMR5, 0xFFFF, 0);
    tmr_cnt_dir_set(TMR5, TMR_COUNT_UP);
    tmr_clock_source_div_set(TMR5, TMR_CLOCK_DIV1);
    
    /* Configure input capture on channel 4 */
    tmr_input_default_para_init(&tmr_ic_init_structure);
    tmr_ic_init_structure.input_channel_select = TMR_SELECT_CHANNEL_4;
    tmr_ic_init_structure.input_polarity_select = TMR_INPUT_RISING_EDGE;
    tmr_ic_init_structure.input_mapped_select = TMR_CC_CHANNEL_MAPPED_DIRECT;
    tmr_ic_init_structure.input_filter_value = 0;
    tmr_input_channel_init(TMR5, &tmr_ic_init_structure, TMR_CHANNEL_INPUT_DIV_1);
    
    /* Reset measurement state */
    operationcomplete = 0;
    
    /* Start timer and enable interrupt */
    tmr_counter_enable(TMR5, TRUE);
    tmr_flag_get(TMR5, TMR_C4_FLAG);
    tmr_interrupt_enable(TMR5, TMR_C4_INT, TRUE);
    
    nvic_irq_enable(TMR5_GLOBAL_IRQn, 0, 0);
    
    /* Wait for measurement to complete (two captures) */
    while(operationcomplete != 2);
    
    /* Calculate actual LICK frequency */
    /* TMR5 runs at APB1*2, period is in timer ticks */
    if(periodvalue != 0)
    {
        lickfreq = (uint32_t)((crm_clocks.apb1_freq * 2) / periodvalue);
    }
    
    printf("Measured LICK frequency: %d Hz\r\n", lickfreq);
    
    /* Adjust RTC prescaler for accurate 1 Hz */
    rtc_divider_set(lickfreq - 1);
    rtc_wait_config_finish();
}

void TMR5_GLOBAL_IRQHandler(void)
{
    if(tmr_interrupt_flag_get(TMR5, TMR_C4_FLAG) == SET)
    {
        tmpCC4[operationcomplete++] = (uint16_t)(TMR5->c4dt);
        tmr_flag_clear(TMR5, TMR_C4_FLAG);
        
        if(operationcomplete >= 2)
        {
            /* Calculate period between two captures */
            periodvalue = (uint16_t)(tmpCC4[1] - tmpCC4[0] + 1);
            
            /* Disable further interrupts */
            tmr_interrupt_enable(TMR5, TMR_C4_INT, FALSE);
            tmr_counter_enable(TMR5, FALSE);
        }
    }
}
```

---

## Alarm Functionality

### Alarm Operation

- Alarm value is a 32-bit register compared against counter
- When counter equals alarm, RTC_TA_FLAG is set
- If RTC_TA_INT enabled, interrupt is generated

### Setting Alarm (Counter Value)

```c
/* Set alarm to trigger 10 seconds from now */
uint32_t current = rtc_counter_get();
rtc_alarm_set(current + 10);
rtc_wait_config_finish();
```

### Setting Alarm (Calendar Format)

```c
/* Set alarm for specific date/time */
calendar_type alarm;
alarm.year  = 2024;
alarm.month = 1;
alarm.date  = 15;
alarm.hour  = 14;
alarm.min   = 30;
alarm.sec   = 0;
rtc_alarm_clock_set(&alarm);
```

### Alarm Wakeup from Deep Sleep

```c
void rtc_alarm_wakeup_init(void)
{
    exint_init_type exint_init_struct;
    
    /* Configure EXINT line 17 for RTC alarm */
    exint_init_struct.line_select = EXINT_LINE_17;
    exint_init_struct.line_enable = TRUE;
    exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_init_struct.line_polarity = EXINT_TRIGGER_RISING_EDGE;
    exint_init(&exint_init_struct);
    
    /* Enable RTC alarm interrupt */
    nvic_irq_enable(RTCAlarm_IRQn, 0, 0);
    rtc_interrupt_enable(RTC_TA_INT, TRUE);
    rtc_wait_config_finish();
}

void RTCAlarm_IRQHandler(void)
{
    if(rtc_flag_get(RTC_TA_FLAG) != RESET)
    {
        rtc_flag_clear(RTC_TA_FLAG);
        exint_flag_clear(EXINT_LINE_17);
        
        /* System woken from deep sleep */
    }
}
```

---

## RTC Output Options

The RTC can output signals on the tamper pin (PC13).

### Output Selection

```c
typedef enum
{
    BPR_RTC_OUTPUT_NONE     = 0x00,  /* No output */
    BPR_RTC_OUTPUT_CLOCK    = 0x80,  /* RTC clock output (after prescaler) */
    BPR_RTC_OUTPUT_ALARM    = 0x100, /* Alarm output */
    BPR_RTC_OUTPUT_SECOND   = 0x300  /* Second pulse output */
} bpr_rtc_output_type;
```

### Configuration

```c
/* Disable tamper pin function */
bpr_tamper_pin_enable(FALSE);

/* Select RTC output */
bpr_rtc_output_select(BPR_RTC_OUTPUT_SECOND);  /* 1 Hz output */
```

---

## Battery Backup Domain

### Power Domains

```
    VDD (Main Power)          VBAT (Backup Power)
          │                          │
          ▼                          ▼
    ┌─────────────┐           ┌──────────────┐
    │   Main      │           │   Backup     │
    │   System    │           │   Domain     │
    │             │           │              │
    │  - CPU      │           │  - RTC       │
    │  - SRAM     │◄──────────│  - BPR       │
    │  - Flash    │           │  - LEXT OSC  │
    │  - Periph   │           │              │
    └─────────────┘           └──────────────┘
```

### Backup Domain Access

```c
/* Enable access to backup domain */
crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
pwc_battery_powered_domain_access(TRUE);

/* Now can access RTC and BPR registers */
```

### Using Backup Registers

```c
/* Store initialization flag */
bpr_data_write(BPR_DATA1, 0x1234);

/* Check if already initialized */
if(bpr_data_read(BPR_DATA1) == 0x1234)
{
    /* RTC already configured, just sync */
}
```

---

## Low-Power Mode Integration

### RTC Behavior in Low-Power Modes

| Mode | RTC Running | Clock Source | Wakeup |
|------|-------------|--------------|--------|
| Sleep | Yes | Any | TS/TA interrupt |
| Deep Sleep | Yes | LEXT/LICK | TA via EXINT17 |
| Standby | Yes | LEXT/LICK | TA wakeup |

### Deep Sleep Wakeup with RTC Alarm

```c
void enter_deep_sleep_with_rtc_wakeup(uint32_t seconds)
{
    /* Configure alarm */
    rtc_alarm_set(rtc_counter_get() + seconds);
    rtc_wait_config_finish();
    
    /* Configure EXINT for alarm wakeup */
    exint_init_type exint_struct;
    exint_struct.line_select = EXINT_LINE_17;
    exint_struct.line_enable = TRUE;
    exint_struct.line_mode = EXINT_LINE_INTERRUPT;
    exint_struct.line_polarity = EXINT_TRIGGER_RISING_EDGE;
    exint_init(&exint_struct);
    
    nvic_irq_enable(RTCAlarm_IRQn, 0, 0);
    rtc_interrupt_enable(RTC_TA_INT, TRUE);
    rtc_wait_config_finish();
    
    /* Enter deep sleep */
    pwc_voltage_regulate_set(PWC_REGULATOR_LOW_POWER);
    pwc_deep_sleep_mode_enter(PWC_DEEP_SLEEP_ENTER_WFI);
    
    /* Woken up by RTC alarm */
}
```

---

## Troubleshooting

### Common Issues and Solutions

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| RTC not running | Clock source not enabled | Enable LEXT/LICK and wait for stable |
| | RTC clock not enabled | Call `crm_rtc_clock_enable(TRUE)` |
| | Wrong prescaler | Set prescaler for 1 Hz output |
| Time resets on power cycle | Backup domain not configured | Use VBAT and backup register flag |
| | BPR reset called unnecessarily | Only reset on first init |
| Inaccurate time | Using LICK without calibration | Calibrate LICK or use LEXT |
| | Wrong prescaler value | Match prescaler to clock source |
| Alarm not triggering | Alarm value in past | Set alarm to future counter value |
| | Interrupt not enabled | Enable RTC_TA_INT and NVIC |
| Register writes fail | Configuration mode not entered | Use library functions that handle this |
| | Config finish not waited | Call `rtc_wait_config_finish()` |

### Register Write Sequence

Always follow this sequence when modifying RTC registers:

```c
/* 1. Wait for any pending operation */
rtc_wait_config_finish();

/* 2. Enter config mode (handled by library) */
/* 3. Modify registers */
rtc_divider_set(32767);

/* 4. Wait for completion */
rtc_wait_config_finish();
```

### Debugging Tips

1. **Check clock source**: Verify LEXT/LICK is running
2. **Verify prescaler**: Counter should increment every ~1 second
3. **Use backup register**: Mark initialization to avoid repeated setup
4. **Monitor flags**: Check RTC_TS_FLAG toggles every second

---

## Important Notes

1. **Register Access**: RTC registers require special access sequence. Always use library functions or properly enter/exit configuration mode.

2. **Double Read**: Counter value must be read twice to ensure consistency (handled by `rtc_counter_get()`).

3. **Synchronization**: After APB domain read, wait for update finish flag. After write, wait for configuration finish flag.

4. **Battery Backup**: For time retention across power cycles:
   - Connect 3V battery to VBAT pin
   - Use LEXT or LICK (not HEXT/128)
   - Store initialization flag in backup register

5. **Clock Source Selection**:
   - LEXT: Best accuracy, requires external 32.768 kHz crystal
   - LICK: Convenient but needs calibration (~10% accuracy)
   - HEXT/128: Not available in sleep/standby modes

6. **Epoch Considerations**: Standard implementation uses Unix epoch (1970). Valid range is 1970-2099 for 32-bit counter.

7. **Y2038 Problem**: 32-bit Unix timestamp overflows on 2038-01-19. For applications running past this date, consider alternative epoch.

8. **Alarm Limitation**: Single alarm register. For multiple alarms, reprogram after each trigger.

9. **Tamper Pin Conflicts**: PC13 is shared between tamper input and RTC output. Configure appropriately.

10. **First Configuration**: Only reset backup domain and configure clock source on first power-up (check backup register flag).

---

## References

- AT32F403A/407 Reference Manual
- AT32F403A/407 Datasheet
- Application Note AN0111 - RTC Calendar
- Application Note AN0100 - Low Power Modes

