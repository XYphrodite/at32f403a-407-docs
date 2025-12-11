# ADC - Analog to Digital Converter

## Overview

The **Analog to Digital Converter (ADC)** peripheral provides 12-bit resolution analog-to-digital conversion with multiple channels, flexible triggering options, and DMA support. The AT32F403A/407 features up to three ADC units (ADC1, ADC2, ADC3) that can operate independently or in combined modes for simultaneous sampling.

| Feature | Specification |
|---------|---------------|
| **Resolution** | 12-bit |
| **Channels** | 18 channels (16 external + 2 internal) |
| **ADC Units** | ADC1, ADC2, ADC3 |
| **Conversion Time** | 1 µs @ 12 MHz ADC clock |
| **Input Voltage Range** | 0V to VREF+ (typically 3.3V) |
| **Sample Time** | 1.5 to 239.5 ADC cycles (configurable) |

---

## Key Features

- **12-bit resolution** with selectable data alignment (left/right)
- **18 multiplexed channels:**
  - 16 external analog inputs (ADC_CHANNEL_0 to ADC_CHANNEL_15)
  - 1 internal temperature sensor (ADC_CHANNEL_16)
  - 1 internal reference voltage VINTRV (ADC_CHANNEL_17)
- **Two conversion groups:**
  - **Ordinary group:** Up to 16 channels in programmable sequence
  - **Preempt group:** Up to 4 channels with higher priority (can interrupt ordinary)
- **Multiple trigger sources:** Software, timer events, external interrupts
- **Combined modes:** Simultaneous, interleaved, or independent operation
- **Voltage monitoring:** Configurable high/low threshold watchdog
- **DMA support:** Automatic data transfer without CPU intervention
- **Calibration:** Built-in self-calibration for improved accuracy

---

## Channel Mapping

### External Channels (ADC1/ADC2/ADC3)

| Channel | ADC1 Pin | ADC2 Pin | ADC3 Pin |
|---------|----------|----------|----------|
| ADC_CHANNEL_0 | PA0 | PA0 | PA0 |
| ADC_CHANNEL_1 | PA1 | PA1 | PA1 |
| ADC_CHANNEL_2 | PA2 | PA2 | PA2 |
| ADC_CHANNEL_3 | PA3 | PA3 | PA3 |
| ADC_CHANNEL_4 | PA4 | PA4 | PF6 |
| ADC_CHANNEL_5 | PA5 | PA5 | PF7 |
| ADC_CHANNEL_6 | PA6 | PA6 | PF8 |
| ADC_CHANNEL_7 | PA7 | PA7 | PF9 |
| ADC_CHANNEL_8 | PB0 | PB0 | PF10 |
| ADC_CHANNEL_9 | PB1 | PB1 | - |
| ADC_CHANNEL_10 | PC0 | PC0 | PC0 |
| ADC_CHANNEL_11 | PC1 | PC1 | PC1 |
| ADC_CHANNEL_12 | PC2 | PC2 | PC2 |
| ADC_CHANNEL_13 | PC3 | PC3 | PC3 |
| ADC_CHANNEL_14 | PC4 | PC4 | - |
| ADC_CHANNEL_15 | PC5 | PC5 | - |

### Internal Channels (ADC1 only)

| Channel | Function | Description |
|---------|----------|-------------|
| ADC_CHANNEL_16 | Temperature Sensor | Internal die temperature measurement |
| ADC_CHANNEL_17 | VINTRV | Internal reference voltage (~1.2V) |

---

## Sample Time Configuration

| Sample Time | ADC Cycles | Total Conversion Time* |
|-------------|------------|------------------------|
| `ADC_SAMPLETIME_1_5` | 1.5 | 14 cycles |
| `ADC_SAMPLETIME_7_5` | 7.5 | 20 cycles |
| `ADC_SAMPLETIME_13_5` | 13.5 | 26 cycles |
| `ADC_SAMPLETIME_28_5` | 28.5 | 41 cycles |
| `ADC_SAMPLETIME_41_5` | 41.5 | 54 cycles |
| `ADC_SAMPLETIME_55_5` | 55.5 | 68 cycles |
| `ADC_SAMPLETIME_71_5` | 71.5 | 84 cycles |
| `ADC_SAMPLETIME_239_5` | 239.5 | 252 cycles |

*Total conversion time = Sample time + 12.5 cycles (conversion)

**Note:** For temperature sensor and internal reference, use `ADC_SAMPLETIME_239_5` for accurate readings.

---

## Combined (Dual ADC) Modes

The AT32F403A/407 supports multiple combined ADC modes for advanced applications:

| Mode | Description |
|------|-------------|
| `ADC_INDEPENDENT_MODE` | ADC1, ADC2, ADC3 operate independently |
| `ADC_ORDINARY_SMLT_ONLY_MODE` | Ordinary channels simultaneous conversion |
| `ADC_PREEMPT_SMLT_ONLY_MODE` | Preempt channels simultaneous conversion |
| `ADC_ORDINARY_SMLT_PREEMPT_SMLT_MODE` | Both ordinary and preempt simultaneous |
| `ADC_ORDINARY_SHORTSHIFT_ONLY_MODE` | Short interleaved mode |
| `ADC_ORDINARY_LONGSHIFT_ONLY_MODE` | Long interleaved mode |
| `ADC_PREEMPT_INTERLTRIG_ONLY_MODE` | Alternate trigger mode |

### Combined Mode Data Format

In combined modes, ADC1's ODT register contains both ADC1 and ADC2 results:

```
ODT Register (32-bit):
[31:16] = ADC2 conversion result
[15:0]  = ADC1 conversion result
```

Use `adc_combine_ordinary_conversion_data_get()` to read both values.

---

## Trigger Sources

### Ordinary Group Triggers (ADC1/ADC2)

| Trigger | Description |
|---------|-------------|
| `ADC12_ORDINARY_TRIG_TMR1CH1` | Timer 1 Channel 1 |
| `ADC12_ORDINARY_TRIG_TMR1CH2` | Timer 1 Channel 2 |
| `ADC12_ORDINARY_TRIG_TMR1CH3` | Timer 1 Channel 3 |
| `ADC12_ORDINARY_TRIG_TMR2CH2` | Timer 2 Channel 2 |
| `ADC12_ORDINARY_TRIG_TMR3TRGOUT` | Timer 3 TRGO |
| `ADC12_ORDINARY_TRIG_TMR4CH4` | Timer 4 Channel 4 |
| `ADC12_ORDINARY_TRIG_EXINT11_TMR8TRGOUT` | EXINT11 / Timer 8 TRGO |
| `ADC12_ORDINARY_TRIG_SOFTWARE` | Software trigger |
| `ADC12_ORDINARY_TRIG_TMR1TRGOUT` | Timer 1 TRGO |
| `ADC12_ORDINARY_TRIG_TMR8CH1` | Timer 8 Channel 1 |
| `ADC12_ORDINARY_TRIG_TMR8CH2` | Timer 8 Channel 2 |

### Preempt Group Triggers (ADC1/ADC2)

| Trigger | Description |
|---------|-------------|
| `ADC12_PREEMPT_TRIG_TMR1TRGOUT` | Timer 1 TRGO |
| `ADC12_PREEMPT_TRIG_TMR1CH4` | Timer 1 Channel 4 |
| `ADC12_PREEMPT_TRIG_TMR2TRGOUT` | Timer 2 TRGO |
| `ADC12_PREEMPT_TRIG_TMR2CH1` | Timer 2 Channel 1 |
| `ADC12_PREEMPT_TRIG_TMR3CH4` | Timer 3 Channel 4 |
| `ADC12_PREEMPT_TRIG_TMR4TRGOUT` | Timer 4 TRGO |
| `ADC12_PREEMPT_TRIG_EXINT15_TMR8CH4` | EXINT15 / Timer 8 Channel 4 |
| `ADC12_PREEMPT_TRIG_SOFTWARE` | Software trigger |

---

## API Reference

### Initialization Functions

#### adc_reset

```c
void adc_reset(adc_type *adc_x);
```

Reset ADC peripheral to default state.

| Parameter | Description |
|-----------|-------------|
| `adc_x` | `ADC1`, `ADC2`, or `ADC3` |

---

#### adc_base_default_para_init

```c
void adc_base_default_para_init(adc_base_config_type *adc_base_struct);
```

Initialize ADC configuration structure with default values.

**Default values:**
- `sequence_mode` = FALSE
- `repeat_mode` = FALSE
- `data_align` = ADC_RIGHT_ALIGNMENT
- `ordinary_channel_length` = 1

---

#### adc_base_config

```c
void adc_base_config(adc_type *adc_x, adc_base_config_type *adc_base_struct);
```

Configure ADC base parameters.

**Configuration structure:**

```c
typedef struct {
  confirm_state sequence_mode;           /* Enable sequence mode (multiple channels) */
  confirm_state repeat_mode;             /* Enable continuous conversion */
  adc_data_align_type data_align;        /* Data alignment */
  uint8_t ordinary_channel_length;       /* Number of channels in ordinary sequence (1-16) */
} adc_base_config_type;
```

---

#### adc_enable

```c
void adc_enable(adc_type *adc_x, confirm_state new_state);
```

Enable or disable ADC peripheral.

**Note:** After enabling, setting ADCEN again will start an ordinary conversion.

---

### Calibration Functions

#### adc_calibration_init / adc_calibration_start

```c
void adc_calibration_init(adc_type *adc_x);
flag_status adc_calibration_init_status_get(adc_type *adc_x);
void adc_calibration_start(adc_type *adc_x);
flag_status adc_calibration_status_get(adc_type *adc_x);
```

Perform ADC calibration (recommended after power-up).

**Example:**

```c
adc_enable(ADC1, TRUE);
adc_calibration_init(ADC1);
while(adc_calibration_init_status_get(ADC1));  /* Wait for init */
adc_calibration_start(ADC1);
while(adc_calibration_status_get(ADC1));       /* Wait for calibration */
```

---

### Channel Configuration

#### adc_ordinary_channel_set

```c
void adc_ordinary_channel_set(adc_type *adc_x, 
                              adc_channel_select_type adc_channel, 
                              uint8_t adc_sequence, 
                              adc_sampletime_select_type adc_sampletime);
```

Configure ordinary channel sequence position and sample time.

| Parameter | Description |
|-----------|-------------|
| `adc_x` | ADC instance |
| `adc_channel` | Channel (ADC_CHANNEL_0 to ADC_CHANNEL_17) |
| `adc_sequence` | Position in sequence (1-16) |
| `adc_sampletime` | Sample time setting |

---

#### adc_preempt_channel_set

```c
void adc_preempt_channel_length_set(adc_type *adc_x, uint8_t adc_channel_lenght);
void adc_preempt_channel_set(adc_type *adc_x, 
                             adc_channel_select_type adc_channel, 
                             uint8_t adc_sequence, 
                             adc_sampletime_select_type adc_sampletime);
```

Configure preempt channel sequence (up to 4 channels).

---

### Trigger Configuration

#### adc_ordinary_conversion_trigger_set

```c
void adc_ordinary_conversion_trigger_set(adc_type *adc_x, 
                                         adc_ordinary_trig_select_type adc_ordinary_trig, 
                                         confirm_state new_state);
```

Set ordinary group trigger source.

---

#### adc_ordinary_software_trigger_enable

```c
void adc_ordinary_software_trigger_enable(adc_type *adc_x, confirm_state new_state);
```

Start ordinary conversion by software trigger.

---

### Data Acquisition

#### adc_ordinary_conversion_data_get

```c
uint16_t adc_ordinary_conversion_data_get(adc_type *adc_x);
```

Get ordinary channel conversion result (12-bit).

---

#### adc_combine_ordinary_conversion_data_get

```c
uint32_t adc_combine_ordinary_conversion_data_get(void);
```

Get combined ADC1+ADC2 conversion results (32-bit).

---

#### adc_preempt_conversion_data_get

```c
uint16_t adc_preempt_conversion_data_get(adc_type *adc_x, 
                                         adc_preempt_channel_type adc_preempt_channel);
```

Get preempt channel conversion result.

---

### Voltage Monitoring

#### adc_voltage_monitor_enable

```c
void adc_voltage_monitor_enable(adc_type *adc_x, 
                                adc_voltage_monitoring_type adc_voltage_monitoring);
```

Enable voltage monitoring (watchdog) on specified channels.

| Mode | Description |
|------|-------------|
| `ADC_VMONITOR_SINGLE_ORDINARY` | Monitor single ordinary channel |
| `ADC_VMONITOR_SINGLE_PREEMPT` | Monitor single preempt channel |
| `ADC_VMONITOR_ALL_ORDINARY` | Monitor all ordinary channels |
| `ADC_VMONITOR_ALL_PREEMPT` | Monitor all preempt channels |
| `ADC_VMONITOR_ALL_ORDINARY_PREEMPT` | Monitor all channels |
| `ADC_VMONITOR_NONE` | Disable monitoring |

---

#### adc_voltage_monitor_threshold_value_set

```c
void adc_voltage_monitor_threshold_value_set(adc_type *adc_x, 
                                             uint16_t adc_high_threshold, 
                                             uint16_t adc_low_threshold);
```

Set voltage monitoring thresholds (12-bit values, 0x000-0xFFF).

---

### DMA and Interrupts

#### adc_dma_mode_enable

```c
void adc_dma_mode_enable(adc_type *adc_x, confirm_state new_state);
```

Enable DMA request generation. **Note:** Only ADC1 and ADC3 support DMA.

---

#### adc_interrupt_enable

```c
void adc_interrupt_enable(adc_type *adc_x, uint32_t adc_int, confirm_state new_state);
```

Enable ADC interrupts.

| Interrupt | Description |
|-----------|-------------|
| `ADC_CCE_INT` | Ordinary channel conversion end |
| `ADC_PCCE_INT` | Preempt channel conversion end |
| `ADC_VMOR_INT` | Voltage monitoring out of range |

---

### Internal Channels

#### adc_tempersensor_vintrv_enable

```c
void adc_tempersensor_vintrv_enable(confirm_state new_state);
```

Enable temperature sensor and internal reference voltage (ADC1 only).

---

## Usage Examples

### Example 1: Basic Single Channel Conversion

```c
void adc_single_channel_init(void)
{
  adc_base_config_type adc_base_struct;
  gpio_init_type gpio_initstructure;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_ADC1_PERIPH_CLOCK, TRUE);
  crm_adc_clock_div_set(CRM_ADC_DIV_6);  /* ADC clock = PCLK2/6 */
  
  /* Configure PA4 as analog input */
  gpio_default_para_init(&gpio_initstructure);
  gpio_initstructure.gpio_mode = GPIO_MODE_ANALOG;
  gpio_initstructure.gpio_pins = GPIO_PINS_4;
  gpio_init(GPIOA, &gpio_initstructure);
  
  /* Configure ADC */
  adc_combine_mode_select(ADC_INDEPENDENT_MODE);
  adc_base_default_para_init(&adc_base_struct);
  adc_base_struct.sequence_mode = FALSE;
  adc_base_struct.repeat_mode = FALSE;
  adc_base_struct.data_align = ADC_RIGHT_ALIGNMENT;
  adc_base_struct.ordinary_channel_length = 1;
  adc_base_config(ADC1, &adc_base_struct);
  
  /* Configure channel */
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_4, 1, ADC_SAMPLETIME_239_5);
  adc_ordinary_conversion_trigger_set(ADC1, ADC12_ORDINARY_TRIG_SOFTWARE, TRUE);
  
  /* Enable and calibrate */
  adc_enable(ADC1, TRUE);
  adc_calibration_init(ADC1);
  while(adc_calibration_init_status_get(ADC1));
  adc_calibration_start(ADC1);
  while(adc_calibration_status_get(ADC1));
}

uint16_t adc_read_channel(void)
{
  adc_ordinary_software_trigger_enable(ADC1, TRUE);
  while(adc_flag_get(ADC1, ADC_CCE_FLAG) == RESET);
  return adc_ordinary_conversion_data_get(ADC1);
}
```

---

### Example 2: Multi-Channel with DMA

```c
__IO uint16_t adc_values[3] = {0};

void adc_multichannel_dma_init(void)
{
  adc_base_config_type adc_base_struct;
  dma_init_type dma_init_struct;
  gpio_init_type gpio_initstructure;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_ADC1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
  crm_adc_clock_div_set(CRM_ADC_DIV_6);
  
  /* Configure PA4, PA5, PA6 as analog */
  gpio_default_para_init(&gpio_initstructure);
  gpio_initstructure.gpio_mode = GPIO_MODE_ANALOG;
  gpio_initstructure.gpio_pins = GPIO_PINS_4 | GPIO_PINS_5 | GPIO_PINS_6;
  gpio_init(GPIOA, &gpio_initstructure);
  
  /* Configure DMA */
  dma_reset(DMA1_CHANNEL1);
  dma_default_para_init(&dma_init_struct);
  dma_init_struct.buffer_size = 3;
  dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
  dma_init_struct.memory_base_addr = (uint32_t)adc_values;
  dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_HALFWORD;
  dma_init_struct.memory_inc_enable = TRUE;
  dma_init_struct.peripheral_base_addr = (uint32_t)&(ADC1->odt);
  dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD;
  dma_init_struct.peripheral_inc_enable = FALSE;
  dma_init_struct.priority = DMA_PRIORITY_HIGH;
  dma_init_struct.loop_mode_enable = TRUE;  /* Circular mode */
  dma_init(DMA1_CHANNEL1, &dma_init_struct);
  dma_channel_enable(DMA1_CHANNEL1, TRUE);
  
  /* Configure ADC */
  adc_combine_mode_select(ADC_INDEPENDENT_MODE);
  adc_base_default_para_init(&adc_base_struct);
  adc_base_struct.sequence_mode = TRUE;     /* Multi-channel */
  adc_base_struct.repeat_mode = TRUE;       /* Continuous */
  adc_base_struct.data_align = ADC_RIGHT_ALIGNMENT;
  adc_base_struct.ordinary_channel_length = 3;
  adc_base_config(ADC1, &adc_base_struct);
  
  /* Configure channels in sequence */
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_4, 1, ADC_SAMPLETIME_239_5);
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_5, 2, ADC_SAMPLETIME_239_5);
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_6, 3, ADC_SAMPLETIME_239_5);
  adc_ordinary_conversion_trigger_set(ADC1, ADC12_ORDINARY_TRIG_SOFTWARE, TRUE);
  adc_dma_mode_enable(ADC1, TRUE);
  
  /* Enable and calibrate */
  adc_enable(ADC1, TRUE);
  adc_calibration_init(ADC1);
  while(adc_calibration_init_status_get(ADC1));
  adc_calibration_start(ADC1);
  while(adc_calibration_status_get(ADC1));
  
  /* Start continuous conversion */
  adc_ordinary_software_trigger_enable(ADC1, TRUE);
}
```

---

### Example 3: Internal Temperature Sensor

```c
#define ADC_VREF        3.3       /* Reference voltage */
#define ADC_TEMP_BASE   1.28      /* Voltage at 25°C */
#define ADC_TEMP_SLOPE  (-0.00426) /* mV/°C slope */

float read_internal_temperature(void)
{
  uint16_t adc_value;
  float voltage, temperature;
  
  /* Read ADC value from channel 16 */
  adc_ordinary_software_trigger_enable(ADC1, TRUE);
  while(adc_flag_get(ADC1, ADC_CCE_FLAG) == RESET);
  adc_value = adc_ordinary_conversion_data_get(ADC1);
  
  /* Convert to temperature */
  voltage = (float)adc_value * ADC_VREF / 4096.0;
  temperature = (ADC_TEMP_BASE - voltage) / ADC_TEMP_SLOPE + 25.0;
  
  return temperature;
}

void temperature_sensor_init(void)
{
  adc_base_config_type adc_base_struct;
  
  crm_periph_clock_enable(CRM_ADC1_PERIPH_CLOCK, TRUE);
  crm_adc_clock_div_set(CRM_ADC_DIV_6);
  
  adc_combine_mode_select(ADC_INDEPENDENT_MODE);
  adc_base_default_para_init(&adc_base_struct);
  adc_base_struct.sequence_mode = FALSE;
  adc_base_struct.repeat_mode = FALSE;
  adc_base_struct.data_align = ADC_RIGHT_ALIGNMENT;
  adc_base_struct.ordinary_channel_length = 1;
  adc_base_config(ADC1, &adc_base_struct);
  
  /* Configure temperature sensor channel with long sample time */
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_16, 1, ADC_SAMPLETIME_239_5);
  adc_ordinary_conversion_trigger_set(ADC1, ADC12_ORDINARY_TRIG_SOFTWARE, TRUE);
  
  /* Enable temperature sensor */
  adc_tempersensor_vintrv_enable(TRUE);
  
  /* Enable and calibrate ADC */
  adc_enable(ADC1, TRUE);
  adc_calibration_init(ADC1);
  while(adc_calibration_init_status_get(ADC1));
  adc_calibration_start(ADC1);
  while(adc_calibration_status_get(ADC1));
}
```

---

### Example 4: Voltage Monitoring (Watchdog)

```c
__IO uint16_t vmor_flag = 0;

void ADC1_2_IRQHandler(void)
{
  if(adc_interrupt_flag_get(ADC1, ADC_VMOR_FLAG) != RESET)
  {
    vmor_flag = 1;
    adc_flag_clear(ADC1, ADC_VMOR_FLAG);
  }
}

void voltage_monitor_init(void)
{
  adc_base_config_type adc_base_struct;
  
  /* ... GPIO and clock configuration ... */
  
  nvic_irq_enable(ADC1_2_IRQn, 0, 0);
  
  adc_combine_mode_select(ADC_INDEPENDENT_MODE);
  adc_base_default_para_init(&adc_base_struct);
  adc_base_struct.sequence_mode = FALSE;
  adc_base_struct.repeat_mode = FALSE;
  adc_base_struct.ordinary_channel_length = 1;
  adc_base_config(ADC1, &adc_base_struct);
  
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_5, 1, ADC_SAMPLETIME_239_5);
  adc_ordinary_conversion_trigger_set(ADC1, ADC12_ORDINARY_TRIG_SOFTWARE, TRUE);
  
  /* Configure voltage monitor */
  adc_voltage_monitor_enable(ADC1, ADC_VMONITOR_SINGLE_ORDINARY);
  adc_voltage_monitor_threshold_value_set(ADC1, 0xBBB, 0xAAA);  /* High=0xBBB, Low=0xAAA */
  adc_voltage_monitor_single_channel_select(ADC1, ADC_CHANNEL_5);
  adc_interrupt_enable(ADC1, ADC_VMOR_INT, TRUE);
  
  /* Enable and calibrate */
  adc_enable(ADC1, TRUE);
  adc_calibration_init(ADC1);
  while(adc_calibration_init_status_get(ADC1));
  adc_calibration_start(ADC1);
  while(adc_calibration_status_get(ADC1));
}
```

---

### Example 5: Dual ADC Simultaneous Mode

```c
__IO uint32_t adc_combined_values[3];

void dual_adc_init(void)
{
  adc_base_config_type adc_base_struct;
  
  /* Enable ADC1 and ADC2 clocks */
  crm_periph_clock_enable(CRM_ADC1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_ADC2_PERIPH_CLOCK, TRUE);
  crm_adc_clock_div_set(CRM_ADC_DIV_6);
  
  /* Select simultaneous mode */
  adc_combine_mode_select(ADC_ORDINARY_SMLT_ONLY_MODE);
  
  /* Configure ADC1 */
  adc_base_default_para_init(&adc_base_struct);
  adc_base_struct.sequence_mode = TRUE;
  adc_base_struct.repeat_mode = FALSE;
  adc_base_struct.data_align = ADC_RIGHT_ALIGNMENT;
  adc_base_struct.ordinary_channel_length = 3;
  adc_base_config(ADC1, &adc_base_struct);
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_4, 1, ADC_SAMPLETIME_239_5);
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_5, 2, ADC_SAMPLETIME_239_5);
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_6, 3, ADC_SAMPLETIME_239_5);
  adc_ordinary_conversion_trigger_set(ADC1, ADC12_ORDINARY_TRIG_SOFTWARE, TRUE);
  adc_dma_mode_enable(ADC1, TRUE);
  
  /* Configure ADC2 (same sequence length) */
  adc_base_config(ADC2, &adc_base_struct);
  adc_ordinary_channel_set(ADC2, ADC_CHANNEL_7, 1, ADC_SAMPLETIME_239_5);
  adc_ordinary_channel_set(ADC2, ADC_CHANNEL_8, 2, ADC_SAMPLETIME_239_5);
  adc_ordinary_channel_set(ADC2, ADC_CHANNEL_9, 3, ADC_SAMPLETIME_239_5);
  adc_ordinary_conversion_trigger_set(ADC2, ADC12_ORDINARY_TRIG_SOFTWARE, TRUE);
  
  /* Enable and calibrate both ADCs */
  adc_enable(ADC1, TRUE);
  adc_enable(ADC2, TRUE);
  /* ... calibration for both ... */
}

/* Read combined data:
 * adc_combined_values[n] contains:
 *   [31:16] = ADC2 result
 *   [15:0]  = ADC1 result
 */
```

---

### Example 6: Timer-Triggered Conversion with Preempt

```c
__IO uint16_t ordinary_values[3];
__IO uint16_t preempt_values[3];

void adc_timer_trigger_init(void)
{
  adc_base_config_type adc_base_struct;
  
  /* Configure Timer 1 to trigger ADC every 100ms */
  crm_periph_clock_enable(CRM_TMR1_PERIPH_CLOCK, TRUE);
  tmr_base_init(TMR1, 999, (system_core_clock/10000 - 1));
  tmr_output_config_type oc_config;
  tmr_output_default_para_init(&oc_config);
  oc_config.oc_mode = TMR_OUTPUT_CONTROL_PWM_MODE_A;
  oc_config.oc_output_state = TRUE;
  tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_1, &oc_config);
  tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_1, 500);
  
  /* Configure ADC */
  adc_combine_mode_select(ADC_INDEPENDENT_MODE);
  adc_base_default_para_init(&adc_base_struct);
  adc_base_struct.sequence_mode = TRUE;
  adc_base_struct.repeat_mode = FALSE;
  adc_base_struct.ordinary_channel_length = 3;
  adc_base_config(ADC1, &adc_base_struct);
  
  /* Ordinary channels triggered by Timer 1 CH1 */
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_4, 1, ADC_SAMPLETIME_239_5);
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_5, 2, ADC_SAMPLETIME_239_5);
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_6, 3, ADC_SAMPLETIME_239_5);
  adc_ordinary_conversion_trigger_set(ADC1, ADC12_ORDINARY_TRIG_TMR1CH1, TRUE);
  
  /* Preempt channels with automatic mode (runs after ordinary) */
  adc_preempt_channel_length_set(ADC1, 3);
  adc_preempt_channel_set(ADC1, ADC_CHANNEL_7, 1, ADC_SAMPLETIME_239_5);
  adc_preempt_channel_set(ADC1, ADC_CHANNEL_8, 2, ADC_SAMPLETIME_239_5);
  adc_preempt_channel_set(ADC1, ADC_CHANNEL_9, 3, ADC_SAMPLETIME_239_5);
  adc_preempt_auto_mode_enable(ADC1, TRUE);  /* Auto-trigger after ordinary */
  
  /* Enable ADC and start timer */
  adc_enable(ADC1, TRUE);
  /* ... calibration ... */
  tmr_counter_enable(TMR1, TRUE);
  tmr_output_enable(TMR1, TRUE);
}
```

---

## Conversion Time Calculation

**Total conversion time per channel:**

```
T_conversion = (Sample_time + 12.5) × T_ADC_CLK
```

**Example:** With ADC clock = 12 MHz and sample time = 239.5 cycles:

```
T_conversion = (239.5 + 12.5) / 12,000,000 = 21 µs per channel
```

**For a 3-channel sequence:**

```
T_total = 3 × 21 µs = 63 µs
```

---

## DMA Channel Mapping

| ADC | DMA Channel |
|-----|-------------|
| ADC1 | DMA1_CHANNEL1 |
| ADC3 | DMA2_CHANNEL5 |

**Note:** ADC2 does not have DMA support. Use combined mode with ADC1 for DMA transfers.

---

## Troubleshooting

### Issue: ADC Readings Are Incorrect

**Solutions:**
1. Always calibrate ADC after power-up
2. Use appropriate sample time (longer for high-impedance sources)
3. Verify ADC clock is within specification (≤14 MHz)
4. Check that GPIO is configured as analog input

### Issue: DMA Transfer Not Working

**Solutions:**
1. Verify DMA clock is enabled
2. Check peripheral and memory addresses
3. Ensure ADC DMA mode is enabled
4. Verify buffer size matches sequence length

### Issue: Voltage Monitor Not Triggering

**Solutions:**
1. Verify thresholds are correct (12-bit values)
2. Check that interrupt is enabled
3. Ensure monitored channel is in the conversion sequence
4. Clear VMOR flag in interrupt handler

---

## Example Files

| Example | Description | Path |
|---------|-------------|------|
| **software_trigger_repeat** | Software-triggered continuous conversion with DMA | `examples/adc/software_trigger_repeat/` |
| **voltage_monitoring** | Voltage watchdog with interrupt | `examples/adc/voltage_monitoring/` |
| **internal_temperature_sensor** | Die temperature measurement | `examples/adc/internal_temperature_sensor/` |
| **tmr_trigger_automatic_preempted** | Timer trigger with preempt auto-conversion | `examples/adc/tmr_trigger_automatic_preempted/` |
| **combine_mode_ordinary_simult** | Dual ADC simultaneous mode | `examples/adc/combine_mode_ordinary_simult/` |
| **repeat_conversion_loop_transfer** | Continuous DMA circular mode | `examples/adc/repeat_conversion_loop_transfer/` |
| **exint_trigger_partitioned** | External interrupt trigger with partitioned mode | `examples/adc/exint_trigger_partitioned/` |
| **current_vref_value_check** | Internal reference voltage check | `examples/adc/current_vref_value_check/` |
| **triple_adc_synchro_trigger** | Triple ADC synchronized conversion | `examples/adc/triple_adc_synchro_trigger/` |

---

## Related Peripherals

| Peripheral | Relationship |
|------------|--------------|
| **CRM** | Provides ADC clock (max 14 MHz) |
| **DMA** | Automatic data transfer |
| **GPIO** | Analog input pins |
| **TMR** | External trigger sources |
| **NVIC** | Interrupt handling |

---

## References

- **AN0112** - AT32 ADC Application Note
- **AT32F403A/407 Reference Manual** - ADC Chapter
- **AT32F403A/407 Datasheet** - Electrical characteristics

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2024-11 | Initial documentation |

---

**Author:** Generated from AT32F403A_407_Firmware_Library v2.2.1  
**Target MCU:** AT32F403A/407 Series  
**Peripheral:** ADC (Analog to Digital Converter)

