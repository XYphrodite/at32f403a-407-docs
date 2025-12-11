# CRM - Clock and Reset Management

## Overview

The **Clock and Reset Management (CRM)** peripheral controls the system clock tree, peripheral clock distribution, and reset sources for the AT32F403A/407 microcontroller. It provides flexible clock configuration to achieve optimal performance and power consumption.

| Feature | Specification |
|---------|---------------|
| **Max System Clock** | 240 MHz |
| **Clock Sources** | HICK, HEXT, PLL, LICK, LEXT |
| **HICK Frequency** | 8 MHz / 48 MHz |
| **HEXT Range** | 4-25 MHz |
| **PLL Multipliers** | 2-64× |
| **Bus Clocks** | AHB (max 240 MHz), APB1/APB2 (max 120 MHz) |

---

## Clock Tree Architecture

```
                    ┌─────────────┐
     HICK (8/48MHz) │             │
    ───────────────►│             │     ┌──────────┐
                    │             │     │          │
     HEXT (4-25MHz) │  PLL        │────►│  SCLK    │──► AHB ──► APB2 ──► Peripherals
    ───────────────►│  ×2-64      │     │  Switch  │         └► APB1 ──► Peripherals
          │         │             │     │          │
          └─►/2-5───►│             │     └──────────┘
                    └─────────────┘           ▲
                                             │
                         HICK/HEXT ──────────┘
```

---

## Clock Sources

### HICK - High-Speed Internal Clock

| Parameter | Value |
|-----------|-------|
| **Default Frequency** | 8 MHz |
| **Extended Frequency** | 48 MHz (with HICKDIV = NODIV) |
| **Accuracy** | ±1% @ 25°C |
| **Startup Time** | ~2 µs |
| **Calibration** | 6-bit trimming, 8-bit calibration |

### HEXT - High-Speed External Crystal

| Parameter | Value |
|-----------|-------|
| **Frequency Range** | 4-25 MHz |
| **Typical Value** | 8 MHz |
| **Startup Timeout** | HEXT_STARTUP_TIMEOUT cycles |
| **Bypass Mode** | External clock input supported |
| **Divider** | /2, /3, /4, /5 for PLL input |

### LICK - Low-Speed Internal Clock

| Parameter | Value |
|-----------|-------|
| **Frequency** | ~40 kHz |
| **Accuracy** | ±30% |
| **Usage** | Watchdog timer, RTC |

### LEXT - Low-Speed External Crystal

| Parameter | Value |
|-----------|-------|
| **Frequency** | 32.768 kHz |
| **Accuracy** | Crystal dependent |
| **Usage** | RTC clock source |

---

## PLL Configuration

### PLL Input Sources

```c
typedef enum
{
  CRM_PLL_SOURCE_HICK      = 0x00,  // HICK/2 = 4 MHz (or 24 MHz if 48 MHz mode)
  CRM_PLL_SOURCE_HEXT      = 0x01,  // HEXT direct
  CRM_PLL_SOURCE_HEXT_DIV  = 0x02   // HEXT / (2-5)
} crm_pll_clock_source_type;
```

### PLL Multiplication Factors

```c
typedef enum
{
  CRM_PLL_MULT_2  = 0,   CRM_PLL_MULT_3  = 1,   CRM_PLL_MULT_4  = 2,
  CRM_PLL_MULT_5  = 3,   CRM_PLL_MULT_6  = 4,   CRM_PLL_MULT_7  = 5,
  // ... continues to:
  CRM_PLL_MULT_62 = 61,  CRM_PLL_MULT_63 = 62,  CRM_PLL_MULT_64 = 63
} crm_pll_mult_type;
```

### PLL Output Range

```c
typedef enum
{
  CRM_PLL_OUTPUT_RANGE_LE72MHZ = 0x00,  // PLL output ≤ 72 MHz
  CRM_PLL_OUTPUT_RANGE_GT72MHZ = 0x01   // PLL output > 72 MHz
} crm_pll_output_range_type;
```

### PLL Frequency Calculation

```
PLL_OUT = PLL_INPUT × PLL_MULT

Where:
- PLL_INPUT = HICK/2 (4 MHz) or HEXT or HEXT/(2-5)
- PLL_MULT = 2 to 64
- PLL_OUT_MAX = 240 MHz
```

**Example Configurations:**

| Config | Source | Input | Mult | Output |
|--------|--------|-------|------|--------|
| 240 MHz HICK | HICK/2 | 4 MHz | 60 | 240 MHz |
| 240 MHz HEXT | HEXT/2 | 4 MHz | 60 | 240 MHz |
| 144 MHz HEXT | HEXT | 8 MHz | 18 | 144 MHz |
| 120 MHz HEXT | HEXT | 8 MHz | 15 | 120 MHz |
| 72 MHz HEXT | HEXT | 8 MHz | 9 | 72 MHz |

---

## Bus Clock Dividers

### AHB Divider

```c
typedef enum
{
  CRM_AHB_DIV_1   = 0x00,  // SCLK / 1
  CRM_AHB_DIV_2   = 0x08,  // SCLK / 2
  CRM_AHB_DIV_4   = 0x09,  // SCLK / 4
  CRM_AHB_DIV_8   = 0x0A,  // SCLK / 8
  CRM_AHB_DIV_16  = 0x0B,  // SCLK / 16
  CRM_AHB_DIV_64  = 0x0C,  // SCLK / 64
  CRM_AHB_DIV_128 = 0x0D,  // SCLK / 128
  CRM_AHB_DIV_256 = 0x0E,  // SCLK / 256
  CRM_AHB_DIV_512 = 0x0F   // SCLK / 512
} crm_ahb_div_type;
```

### APB1 Divider (Max 120 MHz)

```c
typedef enum
{
  CRM_APB1_DIV_1  = 0x00,  // AHB / 1
  CRM_APB1_DIV_2  = 0x04,  // AHB / 2
  CRM_APB1_DIV_4  = 0x05,  // AHB / 4
  CRM_APB1_DIV_8  = 0x06,  // AHB / 8
  CRM_APB1_DIV_16 = 0x07   // AHB / 16
} crm_apb1_div_type;
```

### APB2 Divider (Max 120 MHz)

```c
typedef enum
{
  CRM_APB2_DIV_1  = 0x00,  // AHB / 1
  CRM_APB2_DIV_2  = 0x04,  // AHB / 2
  CRM_APB2_DIV_4  = 0x05,  // AHB / 4
  CRM_APB2_DIV_8  = 0x06,  // AHB / 8
  CRM_APB2_DIV_16 = 0x07   // AHB / 16
} crm_apb2_div_type;
```

### ADC Clock Divider

```c
typedef enum
{
  CRM_ADC_DIV_2  = 0x00,  // APB2 / 2
  CRM_ADC_DIV_4  = 0x01,  // APB2 / 4
  CRM_ADC_DIV_6  = 0x02,  // APB2 / 6
  CRM_ADC_DIV_8  = 0x03,  // APB2 / 8
  CRM_ADC_DIV_12 = 0x05,  // APB2 / 12
  CRM_ADC_DIV_16 = 0x07   // APB2 / 16
} crm_adc_div_type;
```

### USB Clock Divider

```c
typedef enum
{
  CRM_USB_DIV_1_5 = 0x00,  // PLL / 1.5 (96 MHz → 64 MHz)
  CRM_USB_DIV_1   = 0x01,  // PLL / 1 (48 MHz → 48 MHz)
  CRM_USB_DIV_2_5 = 0x02,  // PLL / 2.5 (120 MHz → 48 MHz)
  CRM_USB_DIV_2   = 0x03,  // PLL / 2 (96 MHz → 48 MHz)
  CRM_USB_DIV_3_5 = 0x04,  // PLL / 3.5 (168 MHz → 48 MHz)
  CRM_USB_DIV_3   = 0x05,  // PLL / 3 (144 MHz → 48 MHz)
  CRM_USB_DIV_4   = 0x06   // PLL / 4 (192 MHz → 48 MHz)
} crm_usb_div_type;
```

---

## Peripheral Clocks

### AHB Peripherals

| Peripheral | Clock Enable Constant |
|------------|----------------------|
| DMA1 | `CRM_DMA1_PERIPH_CLOCK` |
| DMA2 | `CRM_DMA2_PERIPH_CLOCK` |
| CRC | `CRM_CRC_PERIPH_CLOCK` |
| XMC | `CRM_XMC_PERIPH_CLOCK` |
| SDIO1 | `CRM_SDIO1_PERIPH_CLOCK` |
| SDIO2 | `CRM_SDIO2_PERIPH_CLOCK` |
| EMAC* | `CRM_EMAC_PERIPH_CLOCK` |
| EMAC TX* | `CRM_EMACTX_PERIPH_CLOCK` |
| EMAC RX* | `CRM_EMACRX_PERIPH_CLOCK` |
| EMAC PTP* | `CRM_EMACPTP_PERIPH_CLOCK` |

*AT32F407 only

### APB2 Peripherals

| Peripheral | Clock Enable Constant |
|------------|----------------------|
| IOMUX | `CRM_IOMUX_PERIPH_CLOCK` |
| GPIOA-E | `CRM_GPIOx_PERIPH_CLOCK` |
| ADC1-3 | `CRM_ADCx_PERIPH_CLOCK` |
| TMR1 | `CRM_TMR1_PERIPH_CLOCK` |
| TMR8-11 | `CRM_TMRx_PERIPH_CLOCK` |
| SPI1 | `CRM_SPI1_PERIPH_CLOCK` |
| USART1 | `CRM_USART1_PERIPH_CLOCK` |
| USART6 | `CRM_USART6_PERIPH_CLOCK` |
| UART7-8 | `CRM_UARTx_PERIPH_CLOCK` |
| ACC | `CRM_ACC_PERIPH_CLOCK` |
| I2C3 | `CRM_I2C3_PERIPH_CLOCK` |

### APB1 Peripherals

| Peripheral | Clock Enable Constant |
|------------|----------------------|
| TMR2-7 | `CRM_TMRx_PERIPH_CLOCK` |
| TMR12-14 | `CRM_TMRx_PERIPH_CLOCK` |
| WWDT | `CRM_WWDT_PERIPH_CLOCK` |
| SPI2-4 | `CRM_SPIx_PERIPH_CLOCK` |
| USART2-3 | `CRM_USARTx_PERIPH_CLOCK` |
| UART4-5 | `CRM_UARTx_PERIPH_CLOCK` |
| I2C1-2 | `CRM_I2Cx_PERIPH_CLOCK` |
| USB | `CRM_USB_PERIPH_CLOCK` |
| CAN1-2 | `CRM_CANx_PERIPH_CLOCK` |
| BPR | `CRM_BPR_PERIPH_CLOCK` |
| PWC | `CRM_PWC_PERIPH_CLOCK` |
| DAC | `CRM_DAC_PERIPH_CLOCK` |

---

## System Clock Switch

### System Clock Sources

```c
typedef enum
{
  CRM_SCLK_HICK = 0x00,  // HICK as system clock
  CRM_SCLK_HEXT = 0x01,  // HEXT as system clock
  CRM_SCLK_PLL  = 0x02   // PLL as system clock
} crm_sclk_type;
```

### Clock Output (CLKOUT)

Configure PA8 to output various clocks for debugging:

```c
typedef enum
{
  CRM_CLKOUT_NOCLK      = 0x00,  // No clock output
  CRM_CLKOUT_LICK       = 0x02,  // LICK (~40 kHz)
  CRM_CLKOUT_LEXT       = 0x03,  // LEXT (32.768 kHz)
  CRM_CLKOUT_SCLK       = 0x04,  // System clock
  CRM_CLKOUT_HICK       = 0x05,  // HICK (8/48 MHz)
  CRM_CLKOUT_HEXT       = 0x06,  // HEXT
  CRM_CLKOUT_PLL_DIV_2  = 0x07,  // PLL / 2
  CRM_CLKOUT_PLL_DIV_4  = 0x0C,  // PLL / 4
  CRM_CLKOUT_USB        = 0x0D,  // USB clock (48 MHz)
  CRM_CLKOUT_ADC        = 0x0E   // ADC clock
} crm_clkout_select_type;
```

### Clock Output Divider

```c
typedef enum
{
  CRM_CLKOUT_DIV_1   = 0x00,
  CRM_CLKOUT_DIV_2   = 0x08,
  CRM_CLKOUT_DIV_4   = 0x09,
  CRM_CLKOUT_DIV_8   = 0x0A,
  CRM_CLKOUT_DIV_16  = 0x0B,
  CRM_CLKOUT_DIV_64  = 0x0C,
  CRM_CLKOUT_DIV_128 = 0x0D,
  CRM_CLKOUT_DIV_256 = 0x0E,
  CRM_CLKOUT_DIV_512 = 0x0F
} crm_clkout_div_type;
```

---

## Flags and Interrupts

### Status Flags

```c
// Clock stability flags
CRM_HICK_STABLE_FLAG        // HICK oscillator stable
CRM_HEXT_STABLE_FLAG        // HEXT crystal stable
CRM_PLL_STABLE_FLAG         // PLL locked
CRM_LEXT_STABLE_FLAG        // LEXT crystal stable
CRM_LICK_STABLE_FLAG        // LICK oscillator stable

// Reset source flags
CRM_ALL_RESET_FLAG          // All reset flags
CRM_NRST_RESET_FLAG         // NRST pin reset
CRM_POR_RESET_FLAG          // Power-on reset
CRM_SW_RESET_FLAG           // Software reset
CRM_WDT_RESET_FLAG          // Watchdog timer reset
CRM_WWDT_RESET_FLAG         // Window watchdog reset
CRM_LOWPOWER_RESET_FLAG     // Low power reset

// Interrupt flags
CRM_LICK_READY_INT_FLAG     // LICK ready interrupt
CRM_LEXT_READY_INT_FLAG     // LEXT ready interrupt
CRM_HICK_READY_INT_FLAG     // HICK ready interrupt
CRM_HEXT_READY_INT_FLAG     // HEXT ready interrupt
CRM_PLL_READY_INT_FLAG      // PLL ready interrupt
CRM_CLOCK_FAILURE_INT_FLAG  // Clock failure detected
```

### Interrupts

```c
CRM_LICK_STABLE_INT     // LICK stable interrupt enable
CRM_LEXT_STABLE_INT     // LEXT stable interrupt enable
CRM_HICK_STABLE_INT     // HICK stable interrupt enable
CRM_HEXT_STABLE_INT     // HEXT stable interrupt enable
CRM_PLL_STABLE_INT      // PLL stable interrupt enable
CRM_CLOCK_FAILURE_INT   // Clock failure interrupt enable
```

---

## RTC Clock Selection

```c
typedef enum
{
  CRM_RTC_CLOCK_NOCLK    = 0x00,  // No clock
  CRM_RTC_CLOCK_LEXT     = 0x01,  // LEXT (32.768 kHz)
  CRM_RTC_CLOCK_LICK     = 0x02,  // LICK (~40 kHz)
  CRM_RTC_CLOCK_HEXT_DIV = 0x03   // HEXT / 128
} crm_rtc_clock_type;
```

---

## API Reference

### Reset Functions

#### crm_reset

Reset all CRM registers to default values.

```c
void crm_reset(void);
```

**Example:**
```c
crm_reset();  // Reset clock configuration to defaults
```

---

### Clock Source Control

#### crm_clock_source_enable

Enable or disable a clock source.

```c
void crm_clock_source_enable(crm_clock_source_type source, confirm_state new_state);
```

| Parameter | Description |
|-----------|-------------|
| source | `CRM_CLOCK_SOURCE_HICK`, `HEXT`, `PLL`, `LEXT`, `LICK` |
| new_state | `TRUE` or `FALSE` |

**Example:**
```c
// Enable HEXT
crm_clock_source_enable(CRM_CLOCK_SOURCE_HEXT, TRUE);

// Wait for stability
while(crm_flag_get(CRM_HEXT_STABLE_FLAG) != SET);
```

---

#### crm_hext_stable_wait

Wait for HEXT to stabilize with timeout.

```c
error_status crm_hext_stable_wait(void);
```

| Return | Description |
|--------|-------------|
| SUCCESS | HEXT stable |
| ERROR | Timeout |

**Example:**
```c
crm_clock_source_enable(CRM_CLOCK_SOURCE_HEXT, TRUE);
if(crm_hext_stable_wait() == ERROR)
{
    // HEXT failed to start - use HICK instead
}
```

---

### PLL Configuration

#### crm_pll_config

Configure PLL parameters.

```c
void crm_pll_config(crm_pll_clock_source_type clock_source,
                    crm_pll_mult_type mult_value,
                    crm_pll_output_range_type pll_range);
```

| Parameter | Description |
|-----------|-------------|
| clock_source | `CRM_PLL_SOURCE_HICK`, `HEXT`, `HEXT_DIV` |
| mult_value | `CRM_PLL_MULT_2` to `CRM_PLL_MULT_64` |
| pll_range | `CRM_PLL_OUTPUT_RANGE_LE72MHZ` or `GT72MHZ` |

**Example:**
```c
// Configure PLL: HICK/2 × 60 = 240 MHz
crm_pll_config(CRM_PLL_SOURCE_HICK, CRM_PLL_MULT_60, CRM_PLL_OUTPUT_RANGE_GT72MHZ);
```

---

### Clock Dividers

#### crm_ahb_div_set / crm_apb1_div_set / crm_apb2_div_set

Set bus clock dividers.

```c
void crm_ahb_div_set(crm_ahb_div_type value);
void crm_apb1_div_set(crm_apb1_div_type value);
void crm_apb2_div_set(crm_apb2_div_type value);
```

**Example:**
```c
crm_ahb_div_set(CRM_AHB_DIV_1);    // AHB = SCLK
crm_apb2_div_set(CRM_APB2_DIV_2);  // APB2 = AHB/2 = 120 MHz
crm_apb1_div_set(CRM_APB1_DIV_2);  // APB1 = AHB/2 = 120 MHz
```

---

#### crm_adc_clock_div_set

Set ADC clock divider.

```c
void crm_adc_clock_div_set(crm_adc_div_type div_value);
```

**Example:**
```c
// ADC clock = APB2 / 6 = 20 MHz
crm_adc_clock_div_set(CRM_ADC_DIV_6);
```

---

#### crm_usb_clock_div_set

Set USB clock divider (must result in 48 MHz).

```c
void crm_usb_clock_div_set(crm_usb_div_type div_value);
```

**Example:**
```c
// PLL = 144 MHz, USB = 144/3 = 48 MHz
crm_usb_clock_div_set(CRM_USB_DIV_3);
```

---

### System Clock Switch

#### crm_sysclk_switch

Switch system clock source.

```c
void crm_sysclk_switch(crm_sclk_type value);
```

**Example:**
```c
// Switch to PLL
crm_sysclk_switch(CRM_SCLK_PLL);

// Wait for switch to complete
while(crm_sysclk_switch_status_get() != CRM_SCLK_PLL);
```

---

#### crm_sysclk_switch_status_get

Get current system clock source.

```c
crm_sclk_type crm_sysclk_switch_status_get(void);
```

---

### Peripheral Clock Control

#### crm_periph_clock_enable

Enable or disable peripheral clock.

```c
void crm_periph_clock_enable(crm_periph_clock_type value, confirm_state new_state);
```

**Example:**
```c
// Enable GPIO and USART clocks
crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
crm_periph_clock_enable(CRM_USART1_PERIPH_CLOCK, TRUE);
```

---

#### crm_periph_reset

Reset a peripheral.

```c
void crm_periph_reset(crm_periph_reset_type value, confirm_state new_state);
```

**Example:**
```c
// Reset USART1
crm_periph_reset(CRM_USART1_PERIPH_RESET, TRUE);
crm_periph_reset(CRM_USART1_PERIPH_RESET, FALSE);
```

---

### Clock Frequency Query

#### crm_clocks_freq_get

Get all clock frequencies.

```c
void crm_clocks_freq_get(crm_clocks_freq_type *clocks_struct);
```

**Structure:**
```c
typedef struct
{
  uint32_t sclk_freq;  // System clock frequency
  uint32_t ahb_freq;   // AHB bus clock frequency
  uint32_t apb2_freq;  // APB2 bus clock frequency
  uint32_t apb1_freq;  // APB1 bus clock frequency
  uint32_t adc_freq;   // ADC clock frequency
} crm_clocks_freq_type;
```

**Example:**
```c
crm_clocks_freq_type clocks;
crm_clocks_freq_get(&clocks);

printf("SCLK: %lu Hz\n", clocks.sclk_freq);
printf("AHB:  %lu Hz\n", clocks.ahb_freq);
printf("APB2: %lu Hz\n", clocks.apb2_freq);
printf("APB1: %lu Hz\n", clocks.apb1_freq);
printf("ADC:  %lu Hz\n", clocks.adc_freq);
```

---

### Clock Output

#### crm_clock_out_set

Configure clock output on PA8.

```c
void crm_clock_out_set(crm_clkout_select_type clkout);
```

**Example:**
```c
// Output PLL/4 on PA8
crm_clock_out_set(CRM_CLKOUT_PLL_DIV_4);
```

---

#### crm_clkout_div_set

Set clock output divider.

```c
void crm_clkout_div_set(crm_clkout_div_type clkout_div);
```

---

### Clock Failure Detection

#### crm_clock_failure_detection_enable

Enable/disable clock failure detection (CSS).

```c
void crm_clock_failure_detection_enable(confirm_state new_state);
```

**Example:**
```c
// Enable clock failure detection
crm_clock_failure_detection_enable(TRUE);
```

---

### Auto Step Mode

#### crm_auto_step_mode_enable

Enable automatic frequency stepping for safe clock switching.

```c
void crm_auto_step_mode_enable(confirm_state new_state);
```

**Example:**
```c
// Enable auto-step before switching to high-speed PLL
crm_auto_step_mode_enable(TRUE);
crm_sysclk_switch(CRM_SCLK_PLL);
while(crm_sysclk_switch_status_get() != CRM_SCLK_PLL);
crm_auto_step_mode_enable(FALSE);
```

---

### HICK Configuration

#### crm_hick_clock_trimming_set

Fine-tune HICK frequency.

```c
void crm_hick_clock_trimming_set(uint8_t trim_value);  // 0x00-0x3F
```

---

#### crm_hick_divider_select

Select HICK 48 MHz divider.

```c
void crm_hick_divider_select(crm_hick_div_6_type value);
```

| Value | Result |
|-------|--------|
| `CRM_HICK48_DIV6` | HICK = 48/6 = 8 MHz |
| `CRM_HICK48_NODIV` | HICK = 48 MHz |

---

#### crm_hick_sclk_frequency_select

Select HICK system clock frequency.

```c
void crm_hick_sclk_frequency_select(crm_hick_sclk_frequency_type value);
```

| Value | Result |
|-------|--------|
| `CRM_HICK_SCLK_8MHZ` | HICK = 8 MHz as SCLK |
| `CRM_HICK_SCLK_48MHZ` | HICK = 48 MHz as SCLK |

---

### Flag and Interrupt Functions

#### crm_flag_get / crm_flag_clear

```c
flag_status crm_flag_get(uint32_t flag);
void crm_flag_clear(uint32_t flag);
```

#### crm_interrupt_enable

```c
void crm_interrupt_enable(uint32_t crm_int, confirm_state new_state);
```

---

## Usage Examples

### Example 1: 240 MHz from HICK

Configure system clock to 240 MHz using internal oscillator.

```c
void sclk_240m_hick_config(void)
{
    // Reset CRM
    crm_reset();
    
    // Enable HICK
    crm_clock_source_enable(CRM_CLOCK_SOURCE_HICK, TRUE);
    while(crm_flag_get(CRM_HICK_STABLE_FLAG) != SET);
    
    // Configure PLL: HICK/2 × 60 = 4 MHz × 60 = 240 MHz
    crm_pll_config(CRM_PLL_SOURCE_HICK, CRM_PLL_MULT_60, CRM_PLL_OUTPUT_RANGE_GT72MHZ);
    
    // Enable PLL
    crm_clock_source_enable(CRM_CLOCK_SOURCE_PLL, TRUE);
    while(crm_flag_get(CRM_PLL_STABLE_FLAG) != SET);
    
    // Configure bus dividers
    crm_ahb_div_set(CRM_AHB_DIV_1);     // AHB = 240 MHz
    crm_apb2_div_set(CRM_APB2_DIV_2);   // APB2 = 120 MHz
    crm_apb1_div_set(CRM_APB1_DIV_2);   // APB1 = 120 MHz
    
    // Enable auto-step for safe switching
    crm_auto_step_mode_enable(TRUE);
    
    // Switch to PLL
    crm_sysclk_switch(CRM_SCLK_PLL);
    while(crm_sysclk_switch_status_get() != CRM_SCLK_PLL);
    
    // Disable auto-step
    crm_auto_step_mode_enable(FALSE);
    
    // Update system clock variable
    system_core_clock_update();
}
```

---

### Example 2: 240 MHz from HEXT (8 MHz Crystal)

Configure system clock to 240 MHz using external crystal.

```c
void sclk_240m_hext_config(void)
{
    crm_reset();
    
    // Enable HEXT
    crm_clock_source_enable(CRM_CLOCK_SOURCE_HEXT, TRUE);
    if(crm_hext_stable_wait() == ERROR)
    {
        // HEXT failed - fallback to HICK
        return;
    }
    
    // Configure HEXT divider: 8 MHz / 2 = 4 MHz
    crm_hext_clock_div_set(CRM_HEXT_DIV_2);
    
    // Configure PLL: 4 MHz × 60 = 240 MHz
    crm_pll_config(CRM_PLL_SOURCE_HEXT_DIV, CRM_PLL_MULT_60, CRM_PLL_OUTPUT_RANGE_GT72MHZ);
    
    // Enable PLL
    crm_clock_source_enable(CRM_CLOCK_SOURCE_PLL, TRUE);
    while(crm_flag_get(CRM_PLL_STABLE_FLAG) != SET);
    
    // Configure dividers
    crm_ahb_div_set(CRM_AHB_DIV_1);
    crm_apb2_div_set(CRM_APB2_DIV_2);
    crm_apb1_div_set(CRM_APB1_DIV_2);
    
    // Switch to PLL with auto-step
    crm_auto_step_mode_enable(TRUE);
    crm_sysclk_switch(CRM_SCLK_PLL);
    while(crm_sysclk_switch_status_get() != CRM_SCLK_PLL);
    crm_auto_step_mode_enable(FALSE);
    
    system_core_clock_update();
}
```

---

### Example 3: Clock Failure Detection

Automatically switch to HICK if HEXT fails.

```c
// Called from NMI_Handler or FLASH_IRQHandler
void clock_failure_detection_handler(void)
{
    if(crm_flag_get(CRM_CLOCK_FAILURE_INT_FLAG) != RESET)
    {
        // Disable clock failure detection
        crm_clock_failure_detection_enable(FALSE);
        
        // Switch to HICK-based PLL
        sclk_240m_hick_config();
        
        // Clear flag
        crm_flag_clear(CRM_CLOCK_FAILURE_INT_FLAG);
        
        // Re-enable detection for future failures
        crm_clock_failure_detection_enable(TRUE);
    }
}

int main(void)
{
    // Configure system clock from HEXT
    system_clock_config();
    
    // Enable clock failure detection
    crm_clock_failure_detection_enable(TRUE);
    
    while(1)
    {
        // Application code
    }
}
```

---

### Example 4: Dynamic Clock Switching

Switch between different clock configurations at runtime.

```c
void sclk_64m_hick_config(void)
{
    crm_reset();
    
    crm_clock_source_enable(CRM_CLOCK_SOURCE_HICK, TRUE);
    while(crm_flag_get(CRM_HICK_STABLE_FLAG) != SET);
    
    // 4 MHz × 16 = 64 MHz
    crm_pll_config(CRM_PLL_SOURCE_HICK, CRM_PLL_MULT_16, CRM_PLL_OUTPUT_RANGE_LE72MHZ);
    
    crm_clock_source_enable(CRM_CLOCK_SOURCE_PLL, TRUE);
    while(crm_flag_get(CRM_PLL_STABLE_FLAG) != SET);
    
    crm_ahb_div_set(CRM_AHB_DIV_1);
    crm_apb2_div_set(CRM_APB2_DIV_2);
    crm_apb1_div_set(CRM_APB1_DIV_2);
    
    crm_auto_step_mode_enable(TRUE);
    crm_sysclk_switch(CRM_SCLK_PLL);
    while(crm_sysclk_switch_status_get() != CRM_SCLK_PLL);
    crm_auto_step_mode_enable(FALSE);
    
    system_core_clock_update();
    delay_init();
}

void sclk_96m_hext_config(void)
{
    crm_reset();
    
    crm_clock_source_enable(CRM_CLOCK_SOURCE_HEXT, TRUE);
    while(crm_hext_stable_wait() == ERROR);
    
    // 4 MHz × 24 = 96 MHz
    crm_hext_clock_div_set(CRM_HEXT_DIV_2);
    crm_pll_config(CRM_PLL_SOURCE_HEXT_DIV, CRM_PLL_MULT_24, CRM_PLL_OUTPUT_RANGE_GT72MHZ);
    
    crm_clock_source_enable(CRM_CLOCK_SOURCE_PLL, TRUE);
    while(crm_flag_get(CRM_PLL_STABLE_FLAG) != SET);
    
    crm_ahb_div_set(CRM_AHB_DIV_1);
    crm_apb2_div_set(CRM_APB2_DIV_2);
    crm_apb1_div_set(CRM_APB1_DIV_2);
    
    crm_auto_step_mode_enable(TRUE);
    crm_sysclk_switch(CRM_SCLK_PLL);
    while(crm_sysclk_switch_status_get() != CRM_SCLK_PLL);
    crm_auto_step_mode_enable(FALSE);
    
    system_core_clock_update();
    delay_init();
}

void switch_system_clock(void)
{
    if(CRM->cfg_bit.pllrcs == RESET)
    {
        // Currently HICK - switch to HEXT
        sclk_96m_hext_config();
    }
    else
    {
        // Currently HEXT - switch to HICK
        sclk_64m_hick_config();
    }
}

int main(void)
{
    system_clock_config();
    at32_board_init();
    
    // Configure clock output on PA8
    clkout_config();
    
    while(1)
    {
        if(at32_button_press() == USER_BUTTON)
        {
            switch_system_clock();
            at32_led_toggle(LED4);
        }
        at32_led_toggle(LED2);
        delay_ms(100);
    }
}
```

---

### Example 5: Clock Output Configuration

Output system clock on PA8 for debugging.

```c
void clkout_config(void)
{
    gpio_init_type gpio_init_struct;
    
    // Enable GPIOA clock
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Configure PA8 as alternate function
    gpio_default_para_init(&gpio_init_struct);
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
    gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
    gpio_init_struct.gpio_pins = GPIO_PINS_8;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);
    
    // Configure clock output divider
    crm_clkout_div_set(CRM_CLKOUT_DIV_1);
    
    // Output PLL/4 (240/4 = 60 MHz)
    crm_clock_out_set(CRM_CLKOUT_PLL_DIV_4);
}
```

---

### Example 6: USB Clock Configuration

Configure USB clock to 48 MHz.

```c
void usb_clock_config(void)
{
    // Option 1: From PLL (144 MHz / 3 = 48 MHz)
    crm_usb_clock_div_set(CRM_USB_DIV_3);
    crm_usb_clock_source_select(CRM_USB_CLOCK_SOURCE_PLL);
    
    // Option 2: From HICK 48 MHz
    // crm_usb_clock_source_select(CRM_USB_CLOCK_SOURCE_HICK);
    
    // Enable USB clock
    crm_periph_clock_enable(CRM_USB_PERIPH_CLOCK, TRUE);
}
```

---

## Typical Clock Configurations

| SCLK | Source | PLL Mult | AHB | APB2 | APB1 | USB Div |
|------|--------|----------|-----|------|------|---------|
| 240 MHz | HICK/2 | 60 | /1 | /2 | /2 | /5 (48M) |
| 240 MHz | HEXT/2 | 60 | /1 | /2 | /2 | /5 (48M) |
| 192 MHz | HICK/2 | 48 | /1 | /2 | /2 | /4 (48M) |
| 144 MHz | HEXT | 18 | /1 | /2 | /2 | /3 (48M) |
| 120 MHz | HEXT | 15 | /1 | /1 | /1 | /2.5 (48M) |
| 96 MHz | HEXT/2 | 24 | /1 | /1 | /1 | /2 (48M) |
| 72 MHz | HEXT | 9 | /1 | /1 | /1 | /1.5 (48M) |
| 48 MHz | HICK | - | /1 | /1 | /1 | /1 (48M) |

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| HEXT won't start | Crystal problem | Check crystal, capacitors, bypass option |
| PLL won't lock | Wrong range setting | Use GT72MHZ for outputs > 72 MHz |
| System hangs on switch | No auto-step | Enable auto-step before switching |
| USB not working | Wrong USB clock | Verify USB clock = 48 MHz exactly |
| APB peripherals fail | Clock too high | APB1/APB2 max = 120 MHz |
| ADC inaccurate | ADC clock too high | ADC clock should be ≤ 28 MHz |

### Debug Tips

1. **Use CLKOUT** to verify clock frequencies on PA8
2. **Check flags** before and after operations
3. **Use auto-step mode** for all high-speed switches
4. **Verify PLL range** matches output frequency

---

## Related Peripherals

| Peripheral | Relationship |
|------------|--------------|
| **PWC** | Power control affects clock domains |
| **ACC** | Auto-calibrates HICK using USB SOF |
| **RTC** | Uses LEXT/LICK/HEXT for timekeeping |
| **WDT** | Uses LICK as clock source |
| **USB** | Requires precise 48 MHz clock |

---

## See Also

- [PWC - Power Control](PWC_Power_Control.md)
- [ACC - Auto Clock Calibration](ACC_Auto_Clock_Calibration.md)
- [RTC - Real-Time Clock](RTC_Real_Time_Clock.md)
- AN0082 - Clock Configuration Application Note

