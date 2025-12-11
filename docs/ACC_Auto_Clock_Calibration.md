# ACC - Auto Clock Calibration Controller

## Overview

The **Auto Clock Calibration (ACC)** peripheral provides automatic calibration of the internal High-Speed Internal Clock (HICK) using an external reference signal, typically the USB Start of Frame (SOF) signal. This ensures that the HICK frequency meets the precise timing requirements needed for USB communication.

| Feature | Description |
|---------|-------------|
| **Purpose** | Calibrate HICK oscillator for USB compliance |
| **Reference Signal** | USB SOF (1ms period, 1kHz) |
| **Calibration Modes** | HICKCAL (coarse) and HICKTRIM (fine) |
| **Accuracy** | ±0.25% when properly calibrated |
| **Target Frequency** | 48 MHz (USB requirement) |

---

## Key Features

- **Automatic calibration** using USB SOF as reference
- **Two calibration modes:**
  - **HICKCAL Mode**: Coarse calibration, ±40 kHz per step
  - **HICKTRIM Mode**: Fine calibration, ±20 kHz per step (higher accuracy)
- **Interrupt support** for calibration ready and reference signal lost events
- **Three boundary registers** (C1, C2, C3) for calibration tolerance window
- **Real-time status monitoring** via flags

---

## Register Map

| Register | Offset | Description |
|----------|--------|-------------|
| **STS** | 0x00 | Status register |
| **CTRL1** | 0x04 | Control register 1 |
| **CTRL2** | 0x08 | Control register 2 (calibration values) |
| **C1** | 0x0C | Comparison register 1 (lower boundary) |
| **C2** | 0x10 | Comparison register 2 (center value) |
| **C3** | 0x14 | Comparison register 3 (upper boundary) |

### STS Register (Status)

| Bit | Name | Description |
|-----|------|-------------|
| 0 | CALRDY | Calibration ready flag |
| 1 | RSLOST | Reference signal lost flag |

### CTRL1 Register (Control)

| Bit | Name | Description |
|-----|------|-------------|
| 0 | CALON | Calibration on/off |
| 1 | ENTRIM | Enable TRIM mode (0=HICKCAL, 1=HICKTRIM) |
| 4 | EIEN | Reference signal lost interrupt enable |
| 5 | CALRDYIEN | Calibration ready interrupt enable |
| 11:8 | STEP | Calibration step value |

### CTRL2 Register (Calibration Values)

| Bit | Name | Description |
|-----|------|-------------|
| 7:0 | HICKCAL | HICK calibration value (read-only factory value) |
| 13:8 | HICKTRIM | HICK trim value (adjustable) |

---

## Calibration Theory

### USB SOF Reference

The USB SOF signal occurs every **1 ms (1000 µs)** with a frequency of **1 kHz**. The ACC uses this precise timing to measure and calibrate the HICK oscillator.

### Calibration Formula

For a target USB clock of **48 MHz**:

```
Expected HICK cycles per SOF period = 48,000,000 Hz × 0.001 s = 48,000 cycles
```

The comparison registers define the acceptable range:
- **C1**: Lower boundary (e.g., 47,990 for TRIM mode)
- **C2**: Center value (e.g., 48,000)
- **C3**: Upper boundary (e.g., 48,010 for TRIM mode)

### Calibration Window

| Mode | Step Resolution | C1/C2/C3 Offset | Typical Window |
|------|-----------------|-----------------|----------------|
| **HICKCAL** | ±40 kHz | ±20 cycles | C2 ± 20 |
| **HICKTRIM** | ±20 kHz | ±10 cycles | C2 ± 10 |

---

## API Reference

### Constants

```c
/* Calibration mode selection */
#define ACC_CAL_HICKCAL              ((uint16_t)0x0000)  /* Coarse calibration */
#define ACC_CAL_HICKTRIM             ((uint16_t)0x0002)  /* Fine calibration */

/* Status flags */
#define ACC_RSLOST_FLAG              ((uint16_t)0x0002)  /* Reference signal lost */
#define ACC_CALRDY_FLAG              ((uint16_t)0x0001)  /* Calibration ready */

/* Interrupt enables */
#define ACC_CALRDYIEN_INT            ((uint16_t)0x0020)  /* Calibration ready interrupt */
#define ACC_EIEN_INT                 ((uint16_t)0x0010)  /* Reference signal lost interrupt */
```

### Functions

#### acc_calibration_mode_enable

```c
void acc_calibration_mode_enable(uint16_t acc_trim, confirm_state new_state);
```

Enable or disable ACC calibration.

| Parameter | Description |
|-----------|-------------|
| `acc_trim` | `ACC_CAL_HICKCAL` or `ACC_CAL_HICKTRIM` |
| `new_state` | `TRUE` to enable, `FALSE` to disable |

**Example:**
```c
// Enable fine calibration mode (HICKTRIM)
acc_calibration_mode_enable(ACC_CAL_HICKTRIM, TRUE);
```

---

#### acc_step_set

```c
void acc_step_set(uint8_t step_value);
```

Set the calibration step value (stored in CTRL1.STEP).

| Parameter | Description |
|-----------|-------------|
| `step_value` | Step value (4-bit, 0-15) |

---

#### acc_interrupt_enable

```c
void acc_interrupt_enable(uint16_t acc_int, confirm_state new_state);
```

Enable or disable ACC interrupts.

| Parameter | Description |
|-----------|-------------|
| `acc_int` | `ACC_CALRDYIEN_INT` or `ACC_EIEN_INT` |
| `new_state` | `TRUE` to enable, `FALSE` to disable |

**Example:**
```c
// Enable calibration ready interrupt
acc_interrupt_enable(ACC_CALRDYIEN_INT, TRUE);

// Enable reference signal lost interrupt  
acc_interrupt_enable(ACC_EIEN_INT, TRUE);
```

---

#### acc_write_c1 / acc_write_c2 / acc_write_c3

```c
void acc_write_c1(uint16_t acc_c1_value);
void acc_write_c2(uint16_t acc_c2_value);
void acc_write_c3(uint16_t acc_c3_value);
```

Write values to comparison registers.

| Parameter | Description |
|-----------|-------------|
| `acc_cX_value` | 16-bit comparison value |

**Example:**
```c
// Configure for HICKTRIM mode (±10 cycles window)
uint32_t center = 8000;  // SOF period in HICK cycles / 6
acc_write_c1(center - 10);  // Lower boundary: 7990
acc_write_c2(center);       // Center value: 8000
acc_write_c3(center + 10);  // Upper boundary: 8010
```

---

#### acc_read_c1 / acc_read_c2 / acc_read_c3

```c
uint16_t acc_read_c1(void);
uint16_t acc_read_c2(void);
uint16_t acc_read_c3(void);
```

Read current comparison register values.

---

#### acc_hicktrim_get / acc_hickcal_get

```c
uint8_t acc_hicktrim_get(void);
uint8_t acc_hickcal_get(void);
```

Get current calibration values from CTRL2 register.

| Function | Returns |
|----------|---------|
| `acc_hicktrim_get()` | Current HICKTRIM value (6-bit) |
| `acc_hickcal_get()` | Factory HICKCAL value (8-bit, read-only) |

---

#### acc_flag_get / acc_interrupt_flag_get

```c
flag_status acc_flag_get(uint16_t acc_flag);
flag_status acc_interrupt_flag_get(uint16_t acc_flag);
```

Check status flags.

| Parameter | Description |
|-----------|-------------|
| `acc_flag` | `ACC_CALRDY_FLAG` or `ACC_RSLOST_FLAG` |

| Function | Returns |
|----------|---------|
| `acc_flag_get()` | Raw flag status |
| `acc_interrupt_flag_get()` | Flag AND interrupt enable status |

---

#### acc_flag_clear

```c
void acc_flag_clear(uint16_t acc_flag);
```

Clear status flags.

| Parameter | Description |
|-----------|-------------|
| `acc_flag` | `ACC_CALRDY_FLAG`, `ACC_RSLOST_FLAG`, or both (OR'd) |

---

## Usage Example: USB HICK Calibration

This example demonstrates calibrating the HICK oscillator for USB CDC (Virtual COM Port) communication.

### Step 1: Configure System Clock from HICK

```c
void system_clock_config_for_acc(void)
{
  /* Reset CRM */
  crm_reset();

  /* Enable HICK */
  crm_clock_source_enable(CRM_CLOCK_SOURCE_HICK, TRUE);
  while(SET != crm_flag_get(CRM_HICK_STABLE_FLAG)) { }

  /* Configure PLL: HICK × 60 = 480 MHz internal, /2 = 240 MHz system */
  crm_pll_config(CRM_PLL_SOURCE_HICK, CRM_PLL_MULT_60, CRM_PLL_OUTPUT_RANGE_GT72MHZ);

  /* Enable PLL */
  crm_clock_source_enable(CRM_CLOCK_SOURCE_PLL, TRUE);
  while(SET != crm_flag_get(CRM_PLL_STABLE_FLAG)) { }

  /* Configure bus clocks */
  crm_ahb_div_set(CRM_AHB_DIV_1);      /* AHB = 240 MHz */
  crm_apb2_div_set(CRM_APB2_DIV_2);    /* APB2 = 120 MHz */
  crm_apb1_div_set(CRM_APB1_DIV_2);    /* APB1 = 120 MHz */

  /* Switch to PLL */
  crm_auto_step_mode_enable(TRUE);
  crm_sysclk_switch(CRM_SCLK_PLL);
  while(CRM_SCLK_PLL != crm_sysclk_switch_status_get()) { }
  crm_auto_step_mode_enable(FALSE);

  system_core_clock_update();
}
```

### Step 2: Configure USB Clock Source

```c
void usb_clock48m_select(usb_clk48_s clk_s)
{
  if(clk_s == USB_CLK_HICK)
  {
    /* Use HICK directly for USB 48 MHz */
    crm_usb_clock_source_select(CRM_USB_CLOCK_SOURCE_HICK);
  }
  else
  {
    /* Derive USB clock from system clock */
    switch(system_core_clock)
    {
      case 48000000:  crm_usb_clock_div_set(CRM_USB_DIV_1);   break;
      case 72000000:  crm_usb_clock_div_set(CRM_USB_DIV_1_5); break;
      case 96000000:  crm_usb_clock_div_set(CRM_USB_DIV_2);   break;
      case 120000000: crm_usb_clock_div_set(CRM_USB_DIV_2_5); break;
      case 144000000: crm_usb_clock_div_set(CRM_USB_DIV_3);   break;
      case 168000000: crm_usb_clock_div_set(CRM_USB_DIV_3_5); break;
      case 192000000: crm_usb_clock_div_set(CRM_USB_DIV_4);   break;
      default:
        crm_usb_clock_source_select(CRM_USB_CLOCK_SOURCE_HICK);
        break;
    }
  }
}
```

### Step 3: Configure ACC for Calibration

```c
void acc_calibration_init(void)
{
  uint32_t acc_c2_value = 8000;  /* Center value for 48 MHz */

  /* Enable ACC peripheral clock */
  crm_periph_clock_enable(CRM_ACC_PERIPH_CLOCK, TRUE);

  /* Enable interrupts */
  acc_interrupt_enable(ACC_CALRDYIEN_INT, TRUE);  /* Calibration ready */
  acc_interrupt_enable(ACC_EIEN_INT, TRUE);       /* Reference signal lost */

  /* Configure NVIC for ACC interrupt */
  nvic_irq_enable(ACC_IRQn, 2, 0);

  /* Set comparison values for HICKTRIM mode (±10 cycles) */
  acc_write_c1(acc_c2_value - 10);  /* Lower boundary: 7990 */
  acc_write_c2(acc_c2_value);       /* Center: 8000 */
  acc_write_c3(acc_c2_value + 10);  /* Upper boundary: 8010 */

  /* Enable HICKTRIM calibration mode */
  acc_calibration_mode_enable(ACC_CAL_HICKTRIM, TRUE);
}
```

### Step 4: ACC Interrupt Handler

```c
void ACC_IRQHandler(void)
{
  /* Check calibration ready flag */
  if(acc_interrupt_flag_get(ACC_CALRDY_FLAG) != RESET)
  {
    /* Calibration complete - HICK is now within tolerance */
    at32_led_toggle(LED2);  /* Visual indicator */
    
    /* Clear flag */
    acc_flag_clear(ACC_CALRDY_FLAG);
  }

  /* Check reference signal lost flag */
  if(acc_interrupt_flag_get(ACC_RSLOST_FLAG) != RESET)
  {
    /* USB SOF signal lost - USB may be disconnected */
    at32_led_toggle(LED3);  /* Error indicator */
    
    /* Clear flag */
    acc_flag_clear(ACC_RSLOST_FLAG);
  }
}
```

### Step 5: Complete Main Application

```c
int main(void)
{
  /* Configure NVIC priority grouping */
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);

  /* Configure system clock from HICK (240 MHz) */
  system_clock_config_for_acc();

  /* Initialize board peripherals */
  at32_board_init();

  /* Configure USB clock from HICK */
  usb_clock48m_select(USB_CLK_HICK);

  /* Enable USB peripheral clock */
  crm_periph_clock_enable(CRM_USB_PERIPH_CLOCK, TRUE);

  /* Configure USB NVIC */
  nvic_irq_enable(USBFS_L_CAN1_RX0_IRQn, 1, 0);

  /* Initialize USB device (CDC class) */
  usbd_core_init(&usb_core_dev, USB, &cdc_class_handler, &cdc_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  /* Initialize ACC calibration */
  acc_calibration_init();

  /* Main loop */
  while(1)
  {
    /* USB CDC echo example */
    uint16_t data_len = usb_vcp_get_rxdata(&usb_core_dev, usb_buffer);
    if(data_len > 0)
    {
      usb_vcp_send_data(&usb_core_dev, usb_buffer, data_len);
    }
  }
}
```

---

## Clock Output for Debugging

To verify the calibrated USB clock, output it on PA8 (CLKOUT):

```c
void clkout_config(void)
{
  gpio_init_type gpio_init_struct;

  /* Enable GPIOA clock */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);

  /* Configure PA8 as alternate function (CLKOUT) */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_8;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);

  /* Output USB clock on PA8 */
  crm_clkout_div_set(CRM_CLKOUT_DIV_1);
  crm_clock_out_set(CRM_CLKOUT_USB);
}
```

Use an oscilloscope on PA8 to verify the 48 MHz USB clock.

---

## Calibration Mode Comparison

| Feature | HICKCAL Mode | HICKTRIM Mode |
|---------|--------------|---------------|
| **Step Resolution** | ±40 kHz | ±20 kHz |
| **Accuracy** | Lower | Higher |
| **Calibration Speed** | Faster | Slower |
| **C1/C3 Offset** | ±20 cycles | ±10 cycles |
| **Use Case** | Initial coarse adjustment | Fine-tuning for USB |

**Recommendation:** Use `ACC_CAL_HICKTRIM` for USB applications requiring higher accuracy.

---

## Sequence Diagram

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│  Main   │     │   ACC   │     │   USB   │     │  HICK   │
└────┬────┘     └────┬────┘     └────┬────┘     └────┬────┘
     │               │               │               │
     │ Enable ACC    │               │               │
     │──────────────>│               │               │
     │               │               │               │
     │ Set C1/C2/C3  │               │               │
     │──────────────>│               │               │
     │               │               │               │
     │ Enable TRIM   │               │               │
     │──────────────>│               │               │
     │               │               │               │
     │               │  SOF Signal   │               │
     │               │<──────────────│               │
     │               │               │               │
     │               │ Count HICK    │               │
     │               │ cycles        │               │
     │               │───────────────────────────────>
     │               │               │               │
     │               │ Compare with  │               │
     │               │ C1/C2/C3      │               │
     │               │               │               │
     │               │ Adjust TRIM   │               │
     │               │───────────────────────────────>
     │               │               │               │
     │  CALRDY IRQ   │               │               │
     │<──────────────│               │               │
     │               │               │               │
     │ HICK now      │               │               │
     │ calibrated    │               │               │
     ▼               ▼               ▼               ▼
```

---

## Troubleshooting

### Issue: ACC_RSLOST_FLAG Set

**Cause:** USB SOF reference signal is lost.

**Solutions:**
1. Verify USB cable is connected
2. Check USB device enumeration completed
3. Verify USB peripheral clock is enabled
4. Check if USB host is providing SOF signals

### Issue: Calibration Never Completes

**Cause:** HICK frequency is outside adjustment range.

**Solutions:**
1. Check comparison register values (C1, C2, C3)
2. Verify HICK is enabled and stable
3. Try using HICKCAL mode for larger initial adjustment
4. Check system clock configuration

### Issue: USB Communication Errors

**Cause:** Clock drift or instability.

**Solutions:**
1. Verify ACC calibration is running (check CALRDY flag)
2. Increase calibration window (C1-C3 range)
3. Check for EMI interference affecting HICK
4. Consider using external crystal (HEXT) for critical applications

---

## Related Peripherals

| Peripheral | Relationship |
|------------|--------------|
| **CRM** | Provides ACC clock, USB clock source selection |
| **USB** | Provides SOF reference signal for calibration |
| **NVIC** | Handles ACC interrupts |
| **GPIO** | Optional CLKOUT for debugging |

---

## Example Files

| Example | Description | Path |
|---------|-------------|------|
| **calibration** | USB CDC with ACC calibration | `examples/acc/calibration/` |

---

## References

- **AN0107** - AT32 Auto Clock Calibration Application Note
- **AT32F403A/407 Reference Manual** - ACC Chapter
- **AT32F403A/407 Datasheet** - Clock system specifications

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2024-11 | Initial documentation |

---

**Author:** Generated from AT32F403A_407_Firmware_Library v2.2.1  
**Target MCU:** AT32F403A/407 Series  
**Peripheral:** ACC (Auto Clock Calibration Controller)

