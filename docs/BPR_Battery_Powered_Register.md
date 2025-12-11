# BPR - Battery Powered Register

## Overview

The **Battery Powered Register (BPR)** peripheral provides non-volatile data storage that retains its contents when the main power supply (VDD) is switched off, as long as a battery is connected to the VBAT pin. It also provides a tamper detection feature for security applications.

| Feature | Specification |
|---------|---------------|
| **Data Registers** | 42 × 16-bit registers (84 bytes total) |
| **Power Domain** | Battery-powered (VBAT) |
| **Data Retention** | Retained while VBAT is powered |
| **Tamper Detection** | Dedicated tamper input pin (PC13) |
| **RTC Output** | Configurable clock/alarm/second output |
| **RTC Calibration** | 7-bit calibration value |

---

## Key Features

- **42 backup data registers** (16-bit each) for user data storage
- **Battery-powered domain** - data retained when VDD is off
- **Tamper detection** with interrupt capability
- **Configurable tamper pin polarity** (active high/low)
- **Automatic data reset** on tamper event
- **RTC clock output** with calibration support
- **RTC calibration** for crystal frequency compensation

---

## Memory Map

| Register | Offset | Description |
|----------|--------|-------------|
| DT1 | 0x04 | Data register 1 |
| DT2 | 0x08 | Data register 2 |
| DT3 | 0x0C | Data register 3 |
| DT4 | 0x10 | Data register 4 |
| DT5 | 0x14 | Data register 5 |
| DT6 | 0x18 | Data register 6 |
| DT7 | 0x1C | Data register 7 |
| DT8 | 0x20 | Data register 8 |
| DT9 | 0x24 | Data register 9 |
| DT10 | 0x28 | Data register 10 |
| RTCCAL | 0x2C | RTC calibration register |
| CTRL | 0x30 | Control register |
| CTRLSTS | 0x34 | Control/status register |
| DT11-DT42 | 0x40-0xBC | Data registers 11-42 |

---

## Register Details

### RTCCAL - RTC Calibration Register (0x2C)

| Bits | Name | Description |
|------|------|-------------|
| [6:0] | CALVAL | Calibration value (0-127) |
| [7] | CALOUT | Calibration clock output enable |
| [8] | OUTEN | Output enable |
| [9] | OUTSEL | Output selection (alarm/second) |
| [10] | CCOS | Calibration clock output selection |
| [11] | OUTM | Output mode (pulse/toggle) |

### CTRL - Control Register (0x30)

| Bits | Name | Description |
|------|------|-------------|
| [0] | TPEN | Tamper pin enable |
| [1] | TPP | Tamper pin polarity |

### CTRLSTS - Control/Status Register (0x34)

| Bits | Name | Description |
|------|------|-------------|
| [0] | TPEFCLR | Tamper event flag clear (write-only) |
| [1] | TPIFCLR | Tamper interrupt flag clear (write-only) |
| [2] | TPIEN | Tamper interrupt enable |
| [8] | TPEF | Tamper event flag (read-only) |
| [9] | TPIF | Tamper interrupt flag (read-only) |

---

## Data Register Enumeration

```c
typedef enum
{
  BPR_DATA1  = 0x04,   BPR_DATA2  = 0x08,   BPR_DATA3  = 0x0C,
  BPR_DATA4  = 0x10,   BPR_DATA5  = 0x14,   BPR_DATA6  = 0x18,
  BPR_DATA7  = 0x1C,   BPR_DATA8  = 0x20,   BPR_DATA9  = 0x24,
  BPR_DATA10 = 0x28,   BPR_DATA11 = 0x40,   BPR_DATA12 = 0x44,
  BPR_DATA13 = 0x48,   BPR_DATA14 = 0x4C,   BPR_DATA15 = 0x50,
  BPR_DATA16 = 0x54,   BPR_DATA17 = 0x58,   BPR_DATA18 = 0x5C,
  BPR_DATA19 = 0x60,   BPR_DATA20 = 0x64,   BPR_DATA21 = 0x68,
  BPR_DATA22 = 0x6C,   BPR_DATA23 = 0x70,   BPR_DATA24 = 0x74,
  BPR_DATA25 = 0x78,   BPR_DATA26 = 0x7C,   BPR_DATA27 = 0x80,
  BPR_DATA28 = 0x84,   BPR_DATA29 = 0x88,   BPR_DATA30 = 0x8C,
  BPR_DATA31 = 0x90,   BPR_DATA32 = 0x94,   BPR_DATA33 = 0x98,
  BPR_DATA34 = 0x9C,   BPR_DATA35 = 0xA0,   BPR_DATA36 = 0xA4,
  BPR_DATA37 = 0xA8,   BPR_DATA38 = 0xAC,   BPR_DATA39 = 0xB0,
  BPR_DATA40 = 0xB4,   BPR_DATA41 = 0xB8,   BPR_DATA42 = 0xBC
} bpr_data_type;
```

---

## RTC Output Types

```c
typedef enum
{
  BPR_RTC_OUTPUT_NONE             = 0x000, /* Output disabled */
  BPR_RTC_OUTPUT_CLOCK_CAL_BEFORE = 0x080, /* Clock before calibration */
  BPR_RTC_OUTPUT_ALARM            = 0x100, /* Alarm event (pulse mode) */
  BPR_RTC_OUTPUT_SECOND           = 0x300, /* Second event (pulse mode) */
  BPR_RTC_OUTPUT_CLOCK_CAL_AFTER  = 0x480, /* Clock after calibration */
  BPR_RTC_OUTPUT_ALARM_TOGGLE     = 0x900, /* Alarm event (toggle mode) */
  BPR_RTC_OUTPUT_SECOND_TOGGLE    = 0xB00  /* Second event (toggle mode) */
} bpr_rtc_output_type;
```

---

## Tamper Pin Configuration

```c
typedef enum
{
  BPR_TAMPER_PIN_ACTIVE_HIGH = 0x00, /* Tamper triggers on high level */
  BPR_TAMPER_PIN_ACTIVE_LOW  = 0x01  /* Tamper triggers on low level */
} bpr_tamper_pin_active_level_type;
```

---

## Flag Definitions

```c
#define BPR_TAMPER_INTERRUPT_FLAG  ((uint32_t)0x00000001) /* Tamper interrupt flag */
#define BPR_TAMPER_EVENT_FLAG      ((uint32_t)0x00000002) /* Tamper event flag */
```

---

## API Reference

### bpr_reset

Reset the BPR domain (clears all data registers).

```c
void bpr_reset(void);
```

**Example:**

```c
/* Reset BPR domain - clears all 42 data registers */
bpr_reset();
```

**Implementation Note:** Internally calls `crm_battery_powered_domain_reset()`.

---

### bpr_flag_get

Get the status of a BPR flag.

```c
flag_status bpr_flag_get(uint32_t flag);
```

| Parameter | Description |
|-----------|-------------|
| `flag` | `BPR_TAMPER_INTERRUPT_FLAG` or `BPR_TAMPER_EVENT_FLAG` |

**Returns:** `SET` or `RESET`

**Example:**

```c
if (bpr_flag_get(BPR_TAMPER_EVENT_FLAG) == SET)
{
  /* Tamper event detected */
}
```

---

### bpr_interrupt_flag_get

Get the interrupt flag status (checks both flag and interrupt enable).

```c
flag_status bpr_interrupt_flag_get(uint32_t flag);
```

| Parameter | Description |
|-----------|-------------|
| `flag` | `BPR_TAMPER_INTERRUPT_FLAG` or `BPR_TAMPER_EVENT_FLAG` |

**Returns:** `SET` if flag is set AND interrupt is enabled, otherwise `RESET`

---

### bpr_flag_clear

Clear a BPR flag.

```c
void bpr_flag_clear(uint32_t flag);
```

| Parameter | Description |
|-----------|-------------|
| `flag` | `BPR_TAMPER_INTERRUPT_FLAG` or `BPR_TAMPER_EVENT_FLAG` |

**Example:**

```c
/* Clear tamper event flag */
bpr_flag_clear(BPR_TAMPER_EVENT_FLAG);
```

---

### bpr_interrupt_enable

Enable or disable the tamper interrupt.

```c
void bpr_interrupt_enable(confirm_state new_state);
```

| Parameter | Description |
|-----------|-------------|
| `new_state` | `TRUE` to enable, `FALSE` to disable |

**Example:**

```c
/* Enable tamper interrupt */
bpr_interrupt_enable(TRUE);
```

---

### bpr_data_read

Read data from a BPR data register.

```c
uint16_t bpr_data_read(bpr_data_type bpr_data);
```

| Parameter | Description |
|-----------|-------------|
| `bpr_data` | Register to read (`BPR_DATA1` to `BPR_DATA42`) |

**Returns:** 16-bit data value

**Example:**

```c
/* Read configuration from BPR_DATA1 */
uint16_t config = bpr_data_read(BPR_DATA1);
```

---

### bpr_data_write

Write data to a BPR data register.

```c
void bpr_data_write(bpr_data_type bpr_data, uint16_t data_value);
```

| Parameter | Description |
|-----------|-------------|
| `bpr_data` | Register to write (`BPR_DATA1` to `BPR_DATA42`) |
| `data_value` | 16-bit value to write (0x0000-0xFFFF) |

**Example:**

```c
/* Store configuration in BPR_DATA1 */
bpr_data_write(BPR_DATA1, 0x1234);
```

---

### bpr_rtc_output_select

Select the RTC output source.

```c
void bpr_rtc_output_select(bpr_rtc_output_type output_source);
```

| Parameter | Description |
|-----------|-------------|
| `output_source` | See RTC Output Types enumeration |

**Example:**

```c
/* Output 1Hz second pulse */
bpr_rtc_output_select(BPR_RTC_OUTPUT_SECOND);
```

---

### bpr_rtc_clock_calibration_value_set

Set the RTC clock calibration value.

```c
void bpr_rtc_clock_calibration_value_set(uint8_t calibration_value);
```

| Parameter | Description |
|-----------|-------------|
| `calibration_value` | Calibration value (0x00-0x7F) |

**Example:**

```c
/* Set calibration to compensate for crystal drift */
bpr_rtc_clock_calibration_value_set(32);
```

---

### bpr_tamper_pin_enable

Enable or disable the tamper pin detection.

```c
void bpr_tamper_pin_enable(confirm_state new_state);
```

| Parameter | Description |
|-----------|-------------|
| `new_state` | `TRUE` to enable, `FALSE` to disable |

**Example:**

```c
/* Enable tamper detection */
bpr_tamper_pin_enable(TRUE);
```

---

### bpr_tamper_pin_active_level_set

Set the tamper pin active level (polarity).

```c
void bpr_tamper_pin_active_level_set(bpr_tamper_pin_active_level_type active_level);
```

| Parameter | Description |
|-----------|-------------|
| `active_level` | `BPR_TAMPER_PIN_ACTIVE_HIGH` or `BPR_TAMPER_PIN_ACTIVE_LOW` |

**Example:**

```c
/* Tamper triggers on low level (pull-down to trigger) */
bpr_tamper_pin_active_level_set(BPR_TAMPER_PIN_ACTIVE_LOW);
```

---

## Usage Examples

### Example 1: Basic Data Storage

Store and retrieve user data that persists across power cycles.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

#define BPR_DR_NUMBER  42

bpr_data_type bpr_addr_tab[BPR_DR_NUMBER] =
{
  BPR_DATA1,  BPR_DATA2,  BPR_DATA3,  BPR_DATA4,  BPR_DATA5,
  BPR_DATA6,  BPR_DATA7,  BPR_DATA8,  BPR_DATA9,  BPR_DATA10,
  BPR_DATA11, BPR_DATA12, BPR_DATA13, BPR_DATA14, BPR_DATA15,
  BPR_DATA16, BPR_DATA17, BPR_DATA18, BPR_DATA19, BPR_DATA20,
  BPR_DATA21, BPR_DATA22, BPR_DATA23, BPR_DATA24, BPR_DATA25,
  BPR_DATA26, BPR_DATA27, BPR_DATA28, BPR_DATA29, BPR_DATA30,
  BPR_DATA31, BPR_DATA32, BPR_DATA33, BPR_DATA34, BPR_DATA35,
  BPR_DATA36, BPR_DATA37, BPR_DATA38, BPR_DATA39, BPR_DATA40,
  BPR_DATA41, BPR_DATA42
};

void bpr_reg_write(void)
{
  uint32_t index;
  for (index = 0; index < BPR_DR_NUMBER; index++)
  {
    bpr_data_write(bpr_addr_tab[index], 0x5A00 | bpr_addr_tab[index]);
  }
}

uint8_t bpr_reg_check(void)
{
  uint32_t index;
  for (index = 0; index < BPR_DR_NUMBER; index++)
  {
    if (bpr_data_read(bpr_addr_tab[index]) != (0x5A00 | bpr_addr_tab[index]))
    {
      return FALSE;
    }
  }
  return TRUE;
}

int main(void)
{
  system_clock_config();
  uart_print_init(115200);

  /* Enable PWC and BPR clocks */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);

  /* Enable write access to BPR domain */
  pwc_battery_powered_domain_access(TRUE);

  /* Clear tamper pin event pending flag */
  bpr_flag_clear(BPR_TAMPER_EVENT_FLAG);

  /* Check if data survived power cycle */
  if (bpr_reg_check() == TRUE)
  {
    printf("BPR data retained from previous session\r\n");
  }
  else
  {
    printf("BPR data was reset - writing new data\r\n");
    bpr_reset();
    bpr_reg_write();
  }

  /* Verify write */
  if (bpr_reg_check() == TRUE)
  {
    printf("BPR write successful\r\n");
  }
  else
  {
    printf("BPR write failed\r\n");
  }

  /* Disable clocks for power saving */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, FALSE);
  crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, FALSE);

  while (1) { }
}
```

---

### Example 2: Tamper Detection with Interrupt

Configure tamper pin detection to protect sensitive data.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

#define BPR_DR_NUMBER  42

bpr_data_type bpr_addr_tab[BPR_DR_NUMBER] = { /* ... same as above */ };

void bpr_reg_write(void)
{
  uint32_t index;
  for (index = 0; index < BPR_DR_NUMBER; index++)
  {
    bpr_data_write(bpr_addr_tab[index], 0x5A00 | bpr_addr_tab[index]);
  }
}

uint32_t bpr_reg_judge(void)
{
  uint32_t index;
  for (index = 0; index < BPR_DR_NUMBER; index++)
  {
    if (bpr_data_read(bpr_addr_tab[index]) != 0x0000)
    {
      return (index + 1);  /* Return first non-zero register */
    }
  }
  return 0;  /* All registers are zero (reset) */
}

int main(void)
{
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  system_clock_config();
  at32_board_init();

  /* Configure NVIC for tamper interrupt */
  nvic_irq_enable(TAMPER_IRQn, 0, 0);

  /* Enable PWC and BPR clocks */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);

  /* Enable write access to BPR domain */
  pwc_battery_powered_domain_access(TRUE);

  /* Configure tamper detection - MUST follow this sequence */
  bpr_tamper_pin_enable(FALSE);           /* 1. Disable tamper pin first */
  bpr_interrupt_enable(FALSE);            /* 2. Disable interrupt */
  bpr_tamper_pin_active_level_set(BPR_TAMPER_PIN_ACTIVE_LOW);  /* 3. Set polarity */
  bpr_flag_clear(BPR_TAMPER_EVENT_FLAG);  /* 4. Clear pending flags */

  /* Write data to protect */
  bpr_reg_write();

  /* Enable tamper protection */
  bpr_interrupt_enable(TRUE);             /* 5. Enable interrupt */
  bpr_tamper_pin_enable(TRUE);            /* 6. Enable tamper pin */

  /* Indicate successful initialization */
  if (bpr_reg_check() == TRUE)
  {
    at32_led_on(LED2);  /* Data written successfully */
  }

  while (1) { }
}

/* Tamper interrupt handler */
void TAMPER_IRQHandler(void)
{
  if (bpr_flag_get(BPR_TAMPER_INTERRUPT_FLAG) == SET)
  {
    /* Tamper detected! All BPR data has been erased automatically */
    bpr_flag_clear(BPR_TAMPER_INTERRUPT_FLAG);
    bpr_flag_clear(BPR_TAMPER_EVENT_FLAG);

    /* Indicate tamper event */
    at32_led_on(LED3);

    /* Re-enable tamper detection for next event */
    bpr_tamper_pin_enable(FALSE);
    bpr_tamper_pin_enable(TRUE);
  }
}
```

---

### Example 3: Simple Configuration Storage

Store application configuration that survives power cycles.

```c
/* Application configuration structure */
typedef struct
{
  uint16_t magic;           /* Magic number to validate data */
  uint16_t brightness;      /* Display brightness */
  uint16_t volume;          /* Audio volume */
  uint16_t language;        /* Language setting */
  uint16_t checksum;        /* Simple checksum */
} app_config_t;

#define CONFIG_MAGIC  0xA5A5

void config_save(app_config_t *config)
{
  /* Enable BPR access */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
  pwc_battery_powered_domain_access(TRUE);

  /* Calculate checksum */
  config->magic = CONFIG_MAGIC;
  config->checksum = config->magic ^ config->brightness ^
                     config->volume ^ config->language;

  /* Write configuration */
  bpr_data_write(BPR_DATA1, config->magic);
  bpr_data_write(BPR_DATA2, config->brightness);
  bpr_data_write(BPR_DATA3, config->volume);
  bpr_data_write(BPR_DATA4, config->language);
  bpr_data_write(BPR_DATA5, config->checksum);
}

uint8_t config_load(app_config_t *config)
{
  uint16_t checksum;

  /* Enable BPR access */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
  pwc_battery_powered_domain_access(TRUE);

  /* Read configuration */
  config->magic      = bpr_data_read(BPR_DATA1);
  config->brightness = bpr_data_read(BPR_DATA2);
  config->volume     = bpr_data_read(BPR_DATA3);
  config->language   = bpr_data_read(BPR_DATA4);
  config->checksum   = bpr_data_read(BPR_DATA5);

  /* Validate */
  if (config->magic != CONFIG_MAGIC)
  {
    return FALSE;  /* Invalid magic number */
  }

  checksum = config->magic ^ config->brightness ^
             config->volume ^ config->language;

  if (checksum != config->checksum)
  {
    return FALSE;  /* Checksum mismatch */
  }

  return TRUE;
}
```

---

## Hardware Configuration

### Tamper Pin (PC13)

| Pin | Function | Description |
|-----|----------|-------------|
| PC13 | TAMPER | Tamper detection input |

**Connection Options:**

1. **Open-drain switch** - Connect to GND when tamper occurs
2. **Microswitch** - Mechanical enclosure tamper detection
3. **Light sensor** - Detect case opening
4. **External monitoring IC** - Integration with security systems

### VBAT Connection

| Pin | Typical Connection |
|-----|-------------------|
| VBAT | 3V coin cell battery (CR2032) |

**Requirements:**
- Voltage range: 1.65V to 3.6V
- Recommended: 3.0V lithium coin cell
- Add 100nF capacitor close to VBAT pin

---

## Important Notes

### Access Sequence

1. **Enable clocks** before any BPR operation:
   ```c
   crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
   crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
   ```

2. **Enable battery domain access** for write operations:
   ```c
   pwc_battery_powered_domain_access(TRUE);
   ```

### Tamper Configuration Sequence

**Critical:** Follow this exact sequence when configuring tamper detection:

1. Disable tamper pin: `bpr_tamper_pin_enable(FALSE)`
2. Disable tamper interrupt: `bpr_interrupt_enable(FALSE)`
3. Set active level: `bpr_tamper_pin_active_level_set(...)`
4. Clear flags: `bpr_flag_clear(BPR_TAMPER_EVENT_FLAG)`
5. Enable interrupt: `bpr_interrupt_enable(TRUE)`
6. Enable tamper pin: `bpr_tamper_pin_enable(TRUE)`

### Data Retention

- Data is **retained** when VDD is off if VBAT is powered
- Data is **cleared** on:
  - Tamper event (if tamper detection enabled)
  - Software reset via `bpr_reset()`
  - VBAT power loss

---

## Power Considerations

| Mode | PWC Clock | BPR Clock | Current |
|------|-----------|-----------|---------|
| Active read/write | Enabled | Enabled | Normal |
| Standby | Disabled | Disabled | VBAT only |

**Power Saving:**

```c
/* Disable clocks after BPR operations */
crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, FALSE);
crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, FALSE);
```

---

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| Data not retained | VBAT not connected | Connect battery to VBAT |
| Write has no effect | Domain access disabled | Call `pwc_battery_powered_domain_access(TRUE)` |
| Data cleared unexpectedly | Tamper event | Check tamper pin connection |
| Tamper not triggering | Wrong polarity | Verify active level setting |
| All registers read 0 | BPR was reset | Check for tamper events or power loss |

---

## See Also

- [PWC - Power Controller](PWC_Power_Controller.md)
- [RTC - Real Time Clock](RTC_Real_Time_Clock.md)
- [CRM - Clock and Reset Management](CRM_Clock_Reset_Management.md)

---

## File References

| File | Description |
|------|-------------|
| `at32f403a_407_bpr.h` | BPR driver header |
| `at32f403a_407_bpr.c` | BPR driver implementation |
| `examples/bpr/bpr_data/` | Data storage example |
| `examples/bpr/tamper/` | Tamper detection example |

