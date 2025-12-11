# DAC - Digital-to-Analog Converter

## Overview

The AT32F403A/407 features a **dual-channel 12-bit DAC** with buffered voltage output. The DAC converts digital values to analog voltages that can drive external circuits, generate waveforms, or provide reference voltages.

### Key Features

| Feature | Specification |
|---------|---------------|
| **Resolution** | 12-bit (0-4095) or 8-bit (0-255) |
| **Channels** | 2 independent channels (DAC1, DAC2) |
| **Output Pins** | PA4 (DAC1), PA5 (DAC2) |
| **Output Range** | 0V to VREF+ |
| **Output Buffer** | Integrated buffer amplifier (optional) |
| **Trigger Sources** | Software, Timer, External interrupt |
| **Wave Generation** | None, Noise (LFSR), Triangle |
| **DMA Support** | Yes, for continuous waveform generation |
| **Settling Time** | ~3 µs (typical) |

---

## Block Diagram

```
                    ┌─────────────────────────────────────────┐
                    │              DAC Block                   │
                    │                                          │
  Data Register     │   ┌──────────┐    ┌─────────┐           │
  ─────────────────►│──►│  12-bit  │───►│ Output  │───► PA4   │
  (DHRx)            │   │   DAC1   │    │ Buffer  │   (DAC1_OUT)
                    │   └──────────┘    └─────────┘           │
                    │         ▲                               │
                    │         │ Trigger                       │
  Trigger Source ───┼─────────┴────────────────────┐          │
  (TMR/SW/EXTI)     │                              │          │
                    │   ┌──────────┐    ┌─────────┐│          │
                    │──►│  12-bit  │───►│ Output  │├──► PA5   │
  Data Register     │   │   DAC2   │    │ Buffer  │   (DAC2_OUT)
  ─────────────────►│   └──────────┘    └─────────┘           │
  (DHRx)            │         ▲                               │
                    │         │                               │
                    │   ┌─────┴─────┐                         │
                    │   │ Wave Gen  │                         │
                    │   │(Noise/Tri)│                         │
                    │   └───────────┘                         │
                    └─────────────────────────────────────────┘
```

---

## Register Map

| Register | Offset | Description |
|----------|--------|-------------|
| **CTRL** | 0x00 | DAC control register |
| **SWTRG** | 0x04 | Software trigger register |
| **D1DTH12R** | 0x08 | DAC1 12-bit right-aligned data |
| **D1DTH12L** | 0x0C | DAC1 12-bit left-aligned data |
| **D1DTH8R** | 0x10 | DAC1 8-bit right-aligned data |
| **D2DTH12R** | 0x14 | DAC2 12-bit right-aligned data |
| **D2DTH12L** | 0x18 | DAC2 12-bit left-aligned data |
| **D2DTH8R** | 0x1C | DAC2 8-bit right-aligned data |
| **DDTH12R** | 0x20 | Dual 12-bit right-aligned data |
| **DDTH12L** | 0x24 | Dual 12-bit left-aligned data |
| **DDTH8R** | 0x28 | Dual 8-bit right-aligned data |
| **D1ODT** | 0x2C | DAC1 output data register |
| **D2ODT** | 0x30 | DAC2 output data register |

### CTRL Register Bit Fields

| Bits | DAC1 | DAC2 | Description |
|------|------|------|-------------|
| [0]/[16] | D1EN | D2EN | DAC channel enable |
| [1]/[17] | D1OBDIS | D2OBDIS | Output buffer disable |
| [2]/[18] | D1TRGEN | D2TRGEN | Trigger enable |
| [5:3]/[21:19] | D1TRGSEL | D2TRGSEL | Trigger source selection |
| [7:6]/[23:22] | D1NM | D2NM | Noise/wave mode |
| [11:8]/[27:24] | D1NBSEL | D2NBSEL | Noise/triangle amplitude |
| [12]/[28] | D1DMAEN | D2DMAEN | DMA enable |

---

## Data Alignment

The DAC supports three data alignment modes for flexible data loading:

### 12-bit Right-Aligned (Default)

```
┌────────────────────────────────────┐
│ 31        16 │ 15  12 │ 11       0 │
├──────────────┼────────┼────────────┤
│   Reserved   │  0000  │  DAC Data  │
└────────────────────────────────────┘
```

### 12-bit Left-Aligned

```
┌────────────────────────────────────┐
│ 31        16 │ 15       4 │ 3    0 │
├──────────────┼────────────┼────────┤
│   Reserved   │  DAC Data  │  0000  │
└────────────────────────────────────┘
```

### 8-bit Right-Aligned

```
┌────────────────────────────────────┐
│ 31                 8 │ 7        0  │
├──────────────────────┼─────────────┤
│      Reserved        │  DAC Data   │
└────────────────────────────────────┘
```

### Data Register Addresses

| Channel | Format | Enum | Address |
|---------|--------|------|---------|
| DAC1 | 12-bit Right | `DAC1_12BIT_RIGHT` | 0x40007408 |
| DAC1 | 12-bit Left | `DAC1_12BIT_LEFT` | 0x4000740C |
| DAC1 | 8-bit Right | `DAC1_8BIT_RIGHT` | 0x40007410 |
| DAC2 | 12-bit Right | `DAC2_12BIT_RIGHT` | 0x40007414 |
| DAC2 | 12-bit Left | `DAC2_12BIT_LEFT` | 0x40007418 |
| DAC2 | 8-bit Right | `DAC2_8BIT_RIGHT` | 0x4000741C |
| Dual | 12-bit Right | `DAC_DUAL_12BIT_RIGHT` | 0x40007420 |
| Dual | 12-bit Left | `DAC_DUAL_12BIT_LEFT` | 0x40007424 |
| Dual | 8-bit Right | `DAC_DUAL_8BIT_RIGHT` | 0x40007428 |

---

## Trigger Sources

The DAC can operate in triggered or non-triggered mode. In triggered mode, data transfer from the holding register to the output register occurs on trigger events.

```c
typedef enum
{
  DAC_TMR6_TRGOUT_EVENT          = 0x00,  // Timer6 TRGOUT event
  DAC_TMR8_TRGOUT_EVENT          = 0x01,  // Timer8 TRGOUT event
  DAC_TMR7_TRGOUT_EVENT          = 0x02,  // Timer7 TRGOUT event
  DAC_TMR5_TRGOUT_EVENT          = 0x03,  // Timer5 TRGOUT event
  DAC_TMR2_TRGOUT_EVENT          = 0x04,  // Timer2 TRGOUT event
  DAC_TMR4_TRGOUT_EVENT          = 0x05,  // Timer4 TRGOUT event
  DAC_EXTERNAL_INTERRUPT_LINE_9  = 0x06,  // External line 9
  DAC_SOFTWARE_TRIGGER           = 0x07   // Software trigger
} dac_trigger_type;
```

### Trigger Mode Selection

| Mode | Use Case | Example |
|------|----------|---------|
| **No Trigger** | Static voltage output | Reference voltage |
| **Timer** | Periodic waveform generation | Sine wave, PWM |
| **Software** | On-demand updates | Interactive control |
| **EXTI Line 9** | External event sync | Sensor-triggered output |

---

## Wave Generation

The DAC includes built-in wave generators for noise and triangle waveforms.

### Wave Types

```c
typedef enum
{
  DAC_WAVE_GENERATE_NONE     = 0x00,  // No wave generation
  DAC_WAVE_GENERATE_NOISE    = 0x01,  // Noise wave (LFSR-based)
  DAC_WAVE_GENERATE_TRIANGLE = 0x02   // Triangle wave
} dac_wave_type;
```

### Mask/Amplitude Settings

The amplitude selector controls the noise mask bits or triangle amplitude:

```c
typedef enum
{
  DAC_LSFR_BIT0_AMPLITUDE_1     = 0x00,  // LFSR bit[0], Triangle amp = 1
  DAC_LSFR_BIT10_AMPLITUDE_3    = 0x01,  // LFSR bit[1:0], Triangle amp = 3
  DAC_LSFR_BIT20_AMPLITUDE_7    = 0x02,  // LFSR bit[2:0], Triangle amp = 7
  DAC_LSFR_BIT30_AMPLITUDE_15   = 0x03,  // LFSR bit[3:0], Triangle amp = 15
  DAC_LSFR_BIT40_AMPLITUDE_31   = 0x04,  // LFSR bit[4:0], Triangle amp = 31
  DAC_LSFR_BIT50_AMPLITUDE_63   = 0x05,  // LFSR bit[5:0], Triangle amp = 63
  DAC_LSFR_BIT60_AMPLITUDE_127  = 0x06,  // LFSR bit[6:0], Triangle amp = 127
  DAC_LSFR_BIT70_AMPLITUDE_255  = 0x07,  // LFSR bit[7:0], Triangle amp = 255
  DAC_LSFR_BIT80_AMPLITUDE_511  = 0x08,  // LFSR bit[8:0], Triangle amp = 511
  DAC_LSFR_BIT90_AMPLITUDE_1023 = 0x09,  // LFSR bit[9:0], Triangle amp = 1023
  DAC_LSFR_BITA0_AMPLITUDE_2047 = 0x0A,  // LFSR bit[10:0], Triangle amp = 2047
  DAC_LSFR_BITB0_AMPLITUDE_4095 = 0x0B   // LFSR bit[11:0], Triangle amp = 4095
} dac_mask_amplitude_type;
```

### Triangle Wave Formula

The triangle wave output is calculated as:

```
Output = Data_Register + Triangle_Counter

Where:
- Triangle_Counter oscillates between 0 and (2^(amplitude_bits+1) - 1)
- Counter increments on each trigger event
- Counter direction reverses at max amplitude
```

### Noise Wave Formula

The noise output uses a Linear Feedback Shift Register (LFSR):

```
Output = Data_Register + LFSR_Value

Where:
- LFSR generates pseudo-random values
- Mask determines which LFSR bits contribute
- LFSR advances on each trigger event
```

---

## Output Buffer

Each DAC channel has an optional output buffer amplifier:

| Buffer State | Output Impedance | Current Drive | Use Case |
|--------------|------------------|---------------|----------|
| **Enabled** | Low (~15Ω) | Higher | Direct load drive |
| **Disabled** | High (~1MΩ) | Lower | External buffer/op-amp |

> ⚠️ **Note**: The output buffer cannot drive the full rail-to-rail range. For full 0-VREF+ output, disable the buffer and use an external op-amp.

---

## API Reference

### Initialization Functions

#### `dac_reset()`
Reset DAC peripheral to default state.

```c
void dac_reset(void);
```

#### `dac_enable()`
Enable or disable a DAC channel.

```c
void dac_enable(dac_select_type dac_select, confirm_state new_state);
```

| Parameter | Description |
|-----------|-------------|
| `dac_select` | `DAC1_SELECT` or `DAC2_SELECT` |
| `new_state` | `TRUE` (enable) or `FALSE` (disable) |

#### `dac_output_buffer_enable()`
Enable or disable the output buffer.

```c
void dac_output_buffer_enable(dac_select_type dac_select, confirm_state new_state);
```

### Trigger Functions

#### `dac_trigger_enable()`
Enable or disable trigger mode.

```c
void dac_trigger_enable(dac_select_type dac_select, confirm_state new_state);
```

#### `dac_trigger_select()`
Select the trigger source.

```c
void dac_trigger_select(dac_select_type dac_select, dac_trigger_type dac_trigger_source);
```

#### `dac_software_trigger_generate()`
Generate a software trigger for one channel.

```c
void dac_software_trigger_generate(dac_select_type dac_select);
```

#### `dac_dual_software_trigger_generate()`
Generate a software trigger for both channels simultaneously.

```c
void dac_dual_software_trigger_generate(void);
```

### Wave Generation Functions

#### `dac_wave_generate()`
Configure wave generation mode.

```c
void dac_wave_generate(dac_select_type dac_select, dac_wave_type dac_wave);
```

#### `dac_mask_amplitude_select()`
Set noise mask or triangle amplitude.

```c
void dac_mask_amplitude_select(dac_select_type dac_select, 
                               dac_mask_amplitude_type dac_mask_amplitude);
```

### DMA Functions

#### `dac_dma_enable()`
Enable or disable DMA requests.

```c
void dac_dma_enable(dac_select_type dac_select, confirm_state new_state);
```

### Data Functions

#### `dac_1_data_set()`
Set DAC1 output data.

```c
void dac_1_data_set(dac1_aligned_data_type dac1_aligned, uint16_t dac1_data);
```

| Parameter | Description |
|-----------|-------------|
| `dac1_aligned` | `DAC1_12BIT_RIGHT`, `DAC1_12BIT_LEFT`, `DAC1_8BIT_RIGHT` |
| `dac1_data` | Data value (0-4095 for 12-bit, 0-255 for 8-bit) |

#### `dac_2_data_set()`
Set DAC2 output data.

```c
void dac_2_data_set(dac2_aligned_data_type dac2_aligned, uint16_t dac2_data);
```

#### `dac_dual_data_set()`
Set both DAC channels simultaneously.

```c
void dac_dual_data_set(dac_dual_data_type dac_dual, uint16_t data1, uint16_t data2);
```

| Parameter | Description |
|-----------|-------------|
| `dac_dual` | `DAC_DUAL_12BIT_RIGHT`, `DAC_DUAL_12BIT_LEFT`, `DAC_DUAL_8BIT_RIGHT` |
| `data1` | DAC1 data value |
| `data2` | DAC2 data value |

#### `dac_data_output_get()`
Read the current DAC output value.

```c
uint16_t dac_data_output_get(dac_select_type dac_select);
```

---

## Usage Examples

### Example 1: Simple DC Voltage Output

Output a fixed voltage on PA4.

```c
#include "at32f403a_407.h"

void dac_simple_voltage(void)
{
    gpio_init_type gpio_init_struct = {0};
    
    // Enable clocks
    crm_periph_clock_enable(CRM_DAC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Configure PA4 as analog
    gpio_init_struct.gpio_pins = GPIO_PINS_4;
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);
    
    // Configure DAC1
    dac_output_buffer_enable(DAC1_SELECT, TRUE);
    dac_enable(DAC1_SELECT, TRUE);
    
    // Set output to ~1.65V (half of 3.3V)
    // 2048 / 4096 * 3.3V = 1.65V
    dac_1_data_set(DAC1_12BIT_RIGHT, 2048);
}
```

### Example 2: Triangle Wave Generation

Generate triangle waves on PA4 and PA5 with different amplitudes using TMR2 trigger.

```c
#include "at32f403a_407.h"

void dac_triangle_wave(void)
{
    gpio_init_type gpio_init_struct = {0};
    crm_clocks_freq_type crm_clocks_freq_struct = {0};
    
    // Enable clocks
    crm_periph_clock_enable(CRM_DAC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Configure PA4, PA5 as analog
    gpio_init_struct.gpio_pins = GPIO_PINS_4 | GPIO_PINS_5;
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);
    
    // Get system clock for timer calculation
    crm_clocks_freq_get(&crm_clocks_freq_struct);
    
    // Configure TMR2 for 10 kHz trigger rate
    // (SCLK / prescaler) / period = trigger_freq
    tmr_base_init(TMR2, 99, (crm_clocks_freq_struct.sclk_freq / 1000000 - 1));
    tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
    tmr_primary_mode_select(TMR2, TMR_PRIMARY_SEL_OVERFLOW);
    
    // Configure DAC1: Triangle with amplitude 1023
    dac_trigger_select(DAC1_SELECT, DAC_TMR2_TRGOUT_EVENT);
    dac_trigger_enable(DAC1_SELECT, TRUE);
    dac_wave_generate(DAC1_SELECT, DAC_WAVE_GENERATE_TRIANGLE);
    dac_mask_amplitude_select(DAC1_SELECT, DAC_LSFR_BIT90_AMPLITUDE_1023);
    dac_output_buffer_enable(DAC1_SELECT, FALSE);
    dac_enable(DAC1_SELECT, TRUE);
    
    // Configure DAC2: Triangle with amplitude 2047
    dac_trigger_select(DAC2_SELECT, DAC_TMR2_TRGOUT_EVENT);
    dac_trigger_enable(DAC2_SELECT, TRUE);
    dac_wave_generate(DAC2_SELECT, DAC_WAVE_GENERATE_TRIANGLE);
    dac_mask_amplitude_select(DAC2_SELECT, DAC_LSFR_BITA0_AMPLITUDE_2047);
    dac_output_buffer_enable(DAC2_SELECT, FALSE);
    dac_enable(DAC2_SELECT, TRUE);
    
    // Set DC offset (base value for triangle)
    dac_dual_data_set(DAC_DUAL_12BIT_RIGHT, 0x100, 0x100);
    
    // Start timer
    tmr_counter_enable(TMR2, TRUE);
}
```

### Example 3: Noise Wave Generation

Generate noise using software trigger on PA4.

```c
#include "at32f403a_407.h"

void dac_noise_wave(void)
{
    gpio_init_type gpio_init_struct = {0};
    
    // Enable clocks
    crm_periph_clock_enable(CRM_DAC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Configure PA4 as analog
    gpio_init_struct.gpio_pins = GPIO_PINS_4;
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);
    
    // Configure DAC1 for noise generation
    dac_trigger_select(DAC1_SELECT, DAC_SOFTWARE_TRIGGER);
    dac_trigger_enable(DAC1_SELECT, TRUE);
    dac_wave_generate(DAC1_SELECT, DAC_WAVE_GENERATE_NOISE);
    dac_mask_amplitude_select(DAC1_SELECT, DAC_LSFR_BITB0_AMPLITUDE_4095);
    dac_output_buffer_enable(DAC1_SELECT, TRUE);
    dac_enable(DAC1_SELECT, TRUE);
    
    // Main loop: generate noise continuously
    while(1)
    {
        dac_software_trigger_generate(DAC1_SELECT);
        delay_us(1);  // Adjust for desired noise bandwidth
    }
}
```

### Example 4: DMA Escalator Waveform

Generate a staircase waveform using DMA.

```c
#include "at32f403a_407.h"

// Escalator pattern: 6 steps
const uint8_t escalator8bit[6] = {0x00, 0x33, 0x66, 0x99, 0xCC, 0xFF};

void dac_dma_escalator(void)
{
    gpio_init_type gpio_init_struct = {0};
    dma_init_type dma_init_struct = {0};
    crm_clocks_freq_type crm_clocks_freq_struct = {0};
    
    // Enable clocks
    crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_DAC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Configure PA4 as analog
    gpio_init_struct.gpio_pins = GPIO_PINS_4;
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);
    
    // Get system clock
    crm_clocks_freq_get(&crm_clocks_freq_struct);
    
    // Configure TMR2 for 1 kHz trigger rate
    tmr_base_init(TMR2, 999, (crm_clocks_freq_struct.sclk_freq / 1000000 - 1));
    tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
    tmr_primary_mode_select(TMR2, TMR_PRIMARY_SEL_OVERFLOW);
    
    // Configure DAC1
    dac_trigger_select(DAC1_SELECT, DAC_TMR2_TRGOUT_EVENT);
    dac_trigger_enable(DAC1_SELECT, TRUE);
    dac_wave_generate(DAC1_SELECT, DAC_WAVE_GENERATE_NONE);
    dac_output_buffer_enable(DAC1_SELECT, FALSE);
    dac_dma_enable(DAC1_SELECT, TRUE);
    
    // Configure DMA1 Channel 2 for DAC1
    dma_reset(DMA1_CHANNEL2);
    dma_init_struct.buffer_size = 6;
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_base_addr = (uint32_t)escalator8bit;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_BYTE;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)DAC1_8BIT_RIGHT;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_BYTE;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_MEDIUM;
    dma_init_struct.loop_mode_enable = TRUE;  // Circular mode
    dma_init(DMA1_CHANNEL2, &dma_init_struct);
    
    // Enable flexible DMA mapping for DAC1
    dma_flexible_config(DMA1, FLEX_CHANNEL2, DMA_FLEXIBLE_DAC1);
    
    dma_channel_enable(DMA1_CHANNEL2, TRUE);
    dac_enable(DAC1_SELECT, TRUE);
    tmr_counter_enable(TMR2, TRUE);
}
```

### Example 5: Dual DAC Sine Wave with DMA

Generate synchronized sine waves on both channels.

```c
#include "at32f403a_407.h"

// 32-point sine wave lookup table (12-bit values)
const uint16_t sine12bit[32] = {
    2047, 2447, 2831, 3185, 3498, 3750, 3939, 4056,
    4095, 4056, 3939, 3750, 3495, 3185, 2831, 2447,
    2047, 1647, 1263, 909,  599,  344,  155,  38,
    0,    38,   155,  344,  599,  909,  1263, 1647
};

uint32_t dualsine12bit[32];  // Packed dual-channel data

void dac_dual_sine_wave(void)
{
    gpio_init_type gpio_init_struct = {0};
    dma_init_type dma_init_struct = {0};
    crm_clocks_freq_type crm_clocks_freq_struct = {0};
    uint32_t idx;
    
    // Enable clocks
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_DAC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Configure PA4, PA5 as analog
    gpio_init_struct.gpio_pins = GPIO_PINS_4 | GPIO_PINS_5;
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);
    
    // Get system clock
    crm_clocks_freq_get(&crm_clocks_freq_struct);
    
    // Configure TMR2 for 10 kHz trigger rate
    // Sine frequency = 10000 / 32 = 312.5 Hz
    tmr_base_init(TMR2, 99, (crm_clocks_freq_struct.sclk_freq / 1000000 - 1));
    tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
    tmr_primary_mode_select(TMR2, TMR_PRIMARY_SEL_OVERFLOW);
    
    // Configure both DAC channels
    dac_trigger_select(DAC1_SELECT, DAC_TMR2_TRGOUT_EVENT);
    dac_trigger_select(DAC2_SELECT, DAC_TMR2_TRGOUT_EVENT);
    dac_trigger_enable(DAC1_SELECT, TRUE);
    dac_trigger_enable(DAC2_SELECT, TRUE);
    dac_wave_generate(DAC1_SELECT, DAC_WAVE_GENERATE_NONE);
    dac_wave_generate(DAC2_SELECT, DAC_WAVE_GENERATE_NONE);
    dac_output_buffer_enable(DAC1_SELECT, FALSE);
    dac_output_buffer_enable(DAC2_SELECT, FALSE);
    dac_dma_enable(DAC1_SELECT, TRUE);
    dac_dma_enable(DAC2_SELECT, TRUE);
    
    // Pack sine data for dual-channel output
    // Format: [DAC2_data << 16 | DAC1_data]
    for(idx = 0; idx < 32; idx++)
    {
        dualsine12bit[idx] = (sine12bit[idx] << 16) | sine12bit[idx];
    }
    
    // Configure DMA1 Channel 1 for dual DAC
    dma_reset(DMA1_CHANNEL1);
    dma_init_struct.buffer_size = 32;
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_base_addr = (uint32_t)dualsine12bit;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_WORD;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)DAC_DUAL_12BIT_RIGHT;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_WORD;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_MEDIUM;
    dma_init_struct.loop_mode_enable = TRUE;
    dma_init(DMA1_CHANNEL1, &dma_init_struct);
    
    // Enable flexible DMA mapping for DAC2
    dma_flexible_config(DMA1, FLEX_CHANNEL1, DMA_FLEXIBLE_DAC2);
    
    dma_channel_enable(DMA1_CHANNEL1, TRUE);
    dac_enable(DAC1_SELECT, TRUE);
    dac_enable(DAC2_SELECT, TRUE);
    tmr_counter_enable(TMR2, TRUE);
}
```

### Example 6: Dual Square Wave with Software Trigger

Generate synchronized square waves using software triggers and DMA.

```c
#include "at32f403a_407.h"

// Square wave pattern: HIGH then LOW
uint32_t dualsquare12bit[2] = {
    (0xFFF | (0xFFF << 16)),  // Both channels HIGH (3.3V)
    0                          // Both channels LOW (0V)
};

void dac_dual_square_wave(void)
{
    gpio_init_type gpio_init_struct = {0};
    dma_init_type dma_init_struct = {0};
    
    // Enable clocks
    crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_DAC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
    
    // Configure PA4, PA5 as analog
    gpio_init_struct.gpio_pins = GPIO_PINS_4 | GPIO_PINS_5;
    gpio_init_struct.gpio_mode = GPIO_MODE_ANALOG;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init(GPIOA, &gpio_init_struct);
    
    // Configure both DAC channels with software trigger
    dac_trigger_select(DAC1_SELECT, DAC_SOFTWARE_TRIGGER);
    dac_trigger_select(DAC2_SELECT, DAC_SOFTWARE_TRIGGER);
    dac_trigger_enable(DAC1_SELECT, TRUE);
    dac_trigger_enable(DAC2_SELECT, TRUE);
    dac_wave_generate(DAC1_SELECT, DAC_WAVE_GENERATE_NONE);
    dac_wave_generate(DAC2_SELECT, DAC_WAVE_GENERATE_NONE);
    dac_output_buffer_enable(DAC1_SELECT, TRUE);
    dac_output_buffer_enable(DAC2_SELECT, TRUE);
    dac_dma_enable(DAC1_SELECT, TRUE);
    dac_dma_enable(DAC2_SELECT, TRUE);
    
    // Configure DMA for dual DAC
    dma_reset(DMA1_CHANNEL1);
    dma_init_struct.buffer_size = 2;
    dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_base_addr = (uint32_t)dualsquare12bit;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_WORD;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_base_addr = (uint32_t)DAC_DUAL_12BIT_RIGHT;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_WORD;
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_MEDIUM;
    dma_init_struct.loop_mode_enable = TRUE;
    dma_init(DMA1_CHANNEL1, &dma_init_struct);
    
    dma_flexible_config(DMA1, FLEX_CHANNEL1, DMA_FLEXIBLE_DAC2);
    dma_channel_enable(DMA1_CHANNEL1, TRUE);
    
    dac_enable(DAC1_SELECT, TRUE);
    dac_enable(DAC2_SELECT, TRUE);
    
    // Main loop: toggle output at 5 kHz
    while(1)
    {
        delay_us(100);  // 10 kHz update rate = 5 kHz square wave
        dac_software_trigger_generate(DAC1_SELECT);
        dac_software_trigger_generate(DAC2_SELECT);
    }
}
```

---

## DMA Configuration Summary

### DMA Channel Mapping

| DAC Channel | DMA | Flexible Request |
|-------------|-----|------------------|
| DAC1 | DMA1 | `DMA_FLEXIBLE_DAC1` |
| DAC2 | DMA1 | `DMA_FLEXIBLE_DAC2` |
| Dual | DMA1 | `DMA_FLEXIBLE_DAC2` |

### Data Width Settings

| DAC Format | Memory Width | Peripheral Width |
|------------|--------------|------------------|
| 8-bit | `BYTE` | `BYTE` |
| 12-bit | `HALFWORD` | `HALFWORD` |
| Dual | `WORD` | `WORD` |

---

## Voltage Calculations

### Output Voltage Formula

```
V_OUT = (DAC_DATA / 4096) × V_REF+

For V_REF+ = 3.3V:
V_OUT = DAC_DATA × 0.000806 V
```

### DAC Value from Desired Voltage

```
DAC_DATA = (V_DESIRED / V_REF+) × 4096

For 1.0V output with V_REF+ = 3.3V:
DAC_DATA = (1.0 / 3.3) × 4096 = 1241
```

### Common Voltage Values

| Voltage | 12-bit Value | 8-bit Value |
|---------|--------------|-------------|
| 0.0V | 0 | 0 |
| 0.825V | 1024 | 64 |
| 1.65V | 2048 | 128 |
| 2.475V | 3072 | 192 |
| 3.3V | 4095 | 255 |

---

## Waveform Frequency Calculation

### For Timer-Triggered DAC with DMA

```
f_waveform = f_trigger / samples_per_period

Where:
f_trigger = SCLK / ((prescaler + 1) × (period + 1))
```

### Example: 1 kHz Sine Wave

```
Requirements:
- 32-point sine table
- f_waveform = 1 kHz

Calculation:
f_trigger = f_waveform × 32 = 32 kHz

For SCLK = 240 MHz, prescaler = 239:
period = (240 MHz / 240) / 32 kHz - 1 = 31.25 - 1 ≈ 30

Result: TMR_ARR = 30, TMR_PSC = 239
```

---

## Troubleshooting

### No Output on DAC Pin

| Issue | Solution |
|-------|----------|
| DAC clock not enabled | Call `crm_periph_clock_enable(CRM_DAC_PERIPH_CLOCK, TRUE)` |
| GPIO not in analog mode | Configure PA4/PA5 as `GPIO_MODE_ANALOG` |
| DAC channel not enabled | Call `dac_enable(DAC1_SELECT, TRUE)` |
| Trigger not enabled | Call `dac_trigger_enable()` if using triggers |

### Output Stuck at 0V or Vref

| Issue | Solution |
|-------|----------|
| Data register empty | Write valid data to DHR register |
| Software trigger not generated | Call `dac_software_trigger_generate()` |
| Timer not running | Enable timer with `tmr_counter_enable(TMR2, TRUE)` |

### Clipped Output Voltage

| Issue | Solution |
|-------|----------|
| Buffer limiting range | Disable buffer with `dac_output_buffer_enable(DAC1_SELECT, FALSE)` |
| External load too heavy | Use external buffer amplifier |

### DMA Not Working

| Issue | Solution |
|-------|----------|
| DMA clock not enabled | Enable `CRM_DMA1_PERIPH_CLOCK` |
| Wrong DMA channel | Use flexible DMA mapping |
| Peripheral address wrong | Use correct DHR address constant |
| Loop mode not enabled | Set `loop_mode_enable = TRUE` for continuous operation |

### Noise on Output

| Issue | Solution |
|-------|----------|
| Ground loops | Improve PCB grounding |
| Power supply noise | Add decoupling capacitors |
| High-frequency interference | Use output filter (RC low-pass) |

---

## Hardware Design Tips

### Output Filtering

For clean analog output, add an RC low-pass filter:

```
           R = 1kΩ
DAC_OUT ──/\/\/\──┬── Filtered Output
                  │
                 ═╧═ C = 100nF
                  │
                 GND

Cutoff frequency: fc = 1 / (2π × R × C) ≈ 1.6 kHz
```

### External Buffer

For full rail-to-rail output with high current drive:

```
                   Vcc
                    │
            ┌───────┴───────┐
            │    OP-AMP     │
DAC_OUT ────┤+              ├──── Buffered Output
            │      -        │
            │      │        │
            └──────┼────────┘
                   │
                   └────────────── (feedback)
```

### Decoupling

```
VREF+ pin:
- 10µF electrolytic + 100nF ceramic to GND

VDDA pin:
- 10µF electrolytic + 100nF ceramic to GND
- Ferrite bead to VDD
```

---

## Related Peripherals

| Peripheral | Relationship |
|------------|--------------|
| **TMR2/4/5/6/7/8** | Hardware trigger sources |
| **DMA1** | Data transfer for continuous waveforms |
| **GPIO** | Output pins PA4, PA5 |
| **ADC** | Can sample DAC output for verification |
| **EXTI** | External trigger via line 9 |

