# TMR (Timer) - AT32F403A/407

## Overview

The AT32F403A/407 microcontroller features a comprehensive timer system with **14 timer units** offering various capabilities from basic timing and counting to advanced PWM generation, motor control, and encoder interfaces. The timers are categorized into Advanced Timers, General-Purpose Timers, and Basic Timers.

## Timer Categories

| Category | Timers | Channels | Complementary Outputs | Resolution |
|----------|--------|----------|----------------------|------------|
| **Advanced Timers** | TMR1, TMR8 | 4 | Yes (3 channels) | 16-bit |
| **General-Purpose (Full)** | TMR2, TMR3, TMR4, TMR5 | 4 | No | 16-bit / 32-bit (TMR2, TMR5) |
| **General-Purpose (Reduced)** | TMR9, TMR12 | 2 | No | 16-bit |
| **General-Purpose (Single)** | TMR10, TMR11, TMR13, TMR14 | 1 | No | 16-bit |
| **Basic Timers** | TMR6, TMR7 | 0 | No | 16-bit |

## Key Features

- **Counting Modes**: Up, Down, Center-aligned (3 modes)
- **Clock Sources**: Internal clock, External clock (Mode 1 & 2), Internal trigger inputs
- **32-bit Operation**: TMR2 and TMR5 support 32-bit counter mode
- **PWM Generation**: Edge-aligned and center-aligned modes
- **Input Capture**: Measure pulse widths and frequencies
- **Output Compare**: Generate precise timing events
- **Encoder Interface**: Quadrature encoder decoding (Mode A, B, C)
- **One-Pulse Mode**: Single-shot output generation
- **Hall Sensor Interface**: XOR function for BLDC motor commutation
- **Complementary Outputs**: Dead-time insertion for motor control
- **Break Function**: Emergency shutdown for safety-critical applications
- **DMA Support**: Efficient data transfer without CPU intervention
- **Synchronization**: Master-slave timer chaining

---

## Register Structure

### TMR Register Map

```c
typedef struct
{
  __IO uint32_t ctrl1;    /* Control register 1,        offset: 0x00 */
  __IO uint32_t ctrl2;    /* Control register 2,        offset: 0x04 */
  __IO uint32_t stctrl;   /* Slave mode control,        offset: 0x08 */
  __IO uint32_t iden;     /* DMA/Interrupt enable,      offset: 0x0C */
  __IO uint32_t ists;     /* Interrupt status,          offset: 0x10 */
  __IO uint32_t swevt;    /* Software event generation, offset: 0x14 */
  __IO uint32_t cm1;      /* Channel mode 1,            offset: 0x18 */
  __IO uint32_t cm2;      /* Channel mode 2,            offset: 0x1C */
  __IO uint32_t cctrl;    /* Capture/Compare enable,    offset: 0x20 */
  __IO uint32_t cval;     /* Counter value,             offset: 0x24 */
  __IO uint32_t div;      /* Prescaler,                 offset: 0x28 */
  __IO uint32_t pr;       /* Period register,           offset: 0x2C */
  __IO uint32_t rpr;      /* Repetition counter,        offset: 0x30 */
  __IO uint32_t c1dt;     /* Channel 1 data,            offset: 0x34 */
  __IO uint32_t c2dt;     /* Channel 2 data,            offset: 0x38 */
  __IO uint32_t c3dt;     /* Channel 3 data,            offset: 0x3C */
  __IO uint32_t c4dt;     /* Channel 4 data,            offset: 0x40 */
  __IO uint32_t brk;      /* Break and dead-time,       offset: 0x44 */
  __IO uint32_t dmactrl;  /* DMA control,               offset: 0x48 */
  __IO uint32_t dmadt;    /* DMA address for burst,     offset: 0x4C */
} tmr_type;
```

### Timer Base Addresses

```c
#define TMR1   ((tmr_type *) TMR1_BASE)
#define TMR2   ((tmr_type *) TMR2_BASE)
#define TMR3   ((tmr_type *) TMR3_BASE)
#define TMR4   ((tmr_type *) TMR4_BASE)
#define TMR5   ((tmr_type *) TMR5_BASE)
#define TMR6   ((tmr_type *) TMR6_BASE)
#define TMR7   ((tmr_type *) TMR7_BASE)
#define TMR8   ((tmr_type *) TMR8_BASE)
#define TMR9   ((tmr_type *) TMR9_BASE)
#define TMR10  ((tmr_type *) TMR10_BASE)
#define TMR11  ((tmr_type *) TMR11_BASE)
#define TMR12  ((tmr_type *) TMR12_BASE)
#define TMR13  ((tmr_type *) TMR13_BASE)
#define TMR14  ((tmr_type *) TMR14_BASE)
```

---

## Configuration Types

### Clock Division

```c
typedef enum
{
  TMR_CLOCK_DIV1 = 0x00,  /* No division */
  TMR_CLOCK_DIV2 = 0x01,  /* Divide by 2 */
  TMR_CLOCK_DIV4 = 0x02   /* Divide by 4 */
} tmr_clock_division_type;
```

### Counter Modes

```c
typedef enum
{
  TMR_COUNT_UP        = 0x00,  /* Up counter */
  TMR_COUNT_DOWN      = 0x01,  /* Down counter */
  TMR_COUNT_TWO_WAY_1 = 0x02,  /* Center-aligned mode 1 */
  TMR_COUNT_TWO_WAY_2 = 0x04,  /* Center-aligned mode 2 */
  TMR_COUNT_TWO_WAY_3 = 0x06   /* Center-aligned mode 3 */
} tmr_count_mode_type;
```

### Output Control Modes

```c
typedef enum
{
  TMR_OUTPUT_CONTROL_OFF        = 0x00,  /* Frozen */
  TMR_OUTPUT_CONTROL_HIGH       = 0x01,  /* Set active on match */
  TMR_OUTPUT_CONTROL_LOW        = 0x02,  /* Set inactive on match */
  TMR_OUTPUT_CONTROL_SWITCH     = 0x03,  /* Toggle on match */
  TMR_OUTPUT_CONTROL_FORCE_LOW  = 0x04,  /* Force inactive */
  TMR_OUTPUT_CONTROL_FORCE_HIGH = 0x05,  /* Force active */
  TMR_OUTPUT_CONTROL_PWM_MODE_A = 0x06,  /* PWM mode 1 */
  TMR_OUTPUT_CONTROL_PWM_MODE_B = 0x07   /* PWM mode 2 */
} tmr_output_control_mode_type;
```

### Input Polarity

```c
typedef enum
{
  TMR_INPUT_RISING_EDGE  = 0x00,  /* Rising edge trigger */
  TMR_INPUT_FALLING_EDGE = 0x01,  /* Falling edge trigger */
  TMR_INPUT_BOTH_EDGE    = 0x03   /* Both edges trigger */
} tmr_input_polarity_type;
```

### Channel Selection

```c
typedef enum
{
  TMR_SELECT_CHANNEL_1  = 0x00,  /* Channel 1 */
  TMR_SELECT_CHANNEL_1C = 0x01,  /* Channel 1 complementary */
  TMR_SELECT_CHANNEL_2  = 0x02,  /* Channel 2 */
  TMR_SELECT_CHANNEL_2C = 0x03,  /* Channel 2 complementary */
  TMR_SELECT_CHANNEL_3  = 0x04,  /* Channel 3 */
  TMR_SELECT_CHANNEL_3C = 0x05,  /* Channel 3 complementary */
  TMR_SELECT_CHANNEL_4  = 0x06   /* Channel 4 */
} tmr_channel_select_type;
```

### Subordinate (Slave) Modes

```c
typedef enum
{
  TMR_SUB_MODE_DIABLE          = 0x00,  /* Slave mode disabled */
  TMR_SUB_ENCODER_MODE_A       = 0x01,  /* Encoder mode A */
  TMR_SUB_ENCODER_MODE_B       = 0x02,  /* Encoder mode B */
  TMR_SUB_ENCODER_MODE_C       = 0x03,  /* Encoder mode C */
  TMR_SUB_RESET_MODE           = 0x04,  /* Reset mode */
  TMR_SUB_HANG_MODE            = 0x05,  /* Gated mode */
  TMR_SUB_TRIGGER_MODE         = 0x06,  /* Trigger mode */
  TMR_SUB_EXTERNAL_CLOCK_MODE_A = 0x07  /* External clock mode A */
} tmr_sub_mode_select_type;
```

### Primary (Master) Mode Selection

```c
typedef enum
{
  TMR_PRIMARY_SEL_RESET    = 0x00,  /* Reset */
  TMR_PRIMARY_SEL_ENABLE   = 0x01,  /* Enable */
  TMR_PRIMARY_SEL_OVERFLOW = 0x02,  /* Update event */
  TMR_PRIMARY_SEL_COMPARE  = 0x03,  /* Compare pulse */
  TMR_PRIMARY_SEL_C1ORAW   = 0x04,  /* OC1REF */
  TMR_PRIMARY_SEL_C2ORAW   = 0x05,  /* OC2REF */
  TMR_PRIMARY_SEL_C3ORAW   = 0x06,  /* OC3REF */
  TMR_PRIMARY_SEL_C4ORAW   = 0x07   /* OC4REF */
} tmr_primary_select_type;
```

### Trigger Input Selection

```c
typedef enum
{
  TMR_SUB_INPUT_SEL_IS0   = 0x00,  /* Internal trigger 0 */
  TMR_SUB_INPUT_SEL_IS1   = 0x01,  /* Internal trigger 1 */
  TMR_SUB_INPUT_SEL_IS2   = 0x02,  /* Internal trigger 2 */
  TMR_SUB_INPUT_SEL_IS3   = 0x03,  /* Internal trigger 3 */
  TMR_SUB_INPUT_SEL_C1INC = 0x04,  /* TI1 edge detector */
  TMR_SUB_INPUT_SEL_C1DF1 = 0x05,  /* Filtered TI1 */
  TMR_SUB_INPUT_SEL_C2DF2 = 0x06,  /* Filtered TI2 */
  TMR_SUB_INPUT_SEL_EXTIN = 0x07   /* External trigger input */
} sub_tmr_input_sel_type;
```

---

## Configuration Structures

### Output Configuration

```c
typedef struct
{
  tmr_output_control_mode_type oc_mode;           /* Output mode */
  confirm_state                oc_idle_state;     /* Idle state level */
  confirm_state                occ_idle_state;    /* Complementary idle state */
  tmr_output_polarity_type     oc_polarity;       /* Output polarity */
  tmr_output_polarity_type     occ_polarity;      /* Complementary polarity */
  confirm_state                oc_output_state;   /* Output enable */
  confirm_state                occ_output_state;  /* Complementary enable */
} tmr_output_config_type;
```

### Input Configuration

```c
typedef struct
{
  tmr_channel_select_type        input_channel_select;   /* Channel selection */
  tmr_input_polarity_type        input_polarity_select;  /* Edge selection */
  tmr_input_direction_mapped_type input_mapped_select;   /* Direct/indirect mapping */
  uint8_t                        input_filter_value;     /* Input filter (0-15) */
} tmr_input_config_type;
```

### Break and Dead-Time Configuration

```c
typedef struct
{
  uint8_t               deadtime;            /* Dead-time value (0-255) */
  tmr_brk_polarity_type brk_polarity;        /* Break input polarity */
  tmr_wp_level_type     wp_level;            /* Write protection level */
  confirm_state         auto_output_enable;  /* Automatic output enable */
  confirm_state         fcsoen_state;        /* Off-state when output enabled */
  confirm_state         fcsodis_state;       /* Off-state when output disabled */
  confirm_state         brk_enable;          /* Break enable */
} tmr_brkdt_config_type;
```

---

## Flags and Interrupts

### TMR Flags

```c
#define TMR_OVF_FLAG           0x000001  /* Overflow flag */
#define TMR_C1_FLAG            0x000002  /* Channel 1 capture/compare flag */
#define TMR_C2_FLAG            0x000004  /* Channel 2 capture/compare flag */
#define TMR_C3_FLAG            0x000008  /* Channel 3 capture/compare flag */
#define TMR_C4_FLAG            0x000010  /* Channel 4 capture/compare flag */
#define TMR_HALL_FLAG          0x000020  /* Hall/Commutation flag */
#define TMR_TRIGGER_FLAG       0x000040  /* Trigger flag */
#define TMR_BRK_FLAG           0x000080  /* Break flag */
#define TMR_C1_RECAPTURE_FLAG  0x000200  /* Channel 1 recapture flag */
#define TMR_C2_RECAPTURE_FLAG  0x000400  /* Channel 2 recapture flag */
#define TMR_C3_RECAPTURE_FLAG  0x000800  /* Channel 3 recapture flag */
#define TMR_C4_RECAPTURE_FLAG  0x001000  /* Channel 4 recapture flag */
```

### TMR Interrupts

```c
#define TMR_OVF_INT     0x000001  /* Overflow interrupt */
#define TMR_C1_INT      0x000002  /* Channel 1 interrupt */
#define TMR_C2_INT      0x000004  /* Channel 2 interrupt */
#define TMR_C3_INT      0x000008  /* Channel 3 interrupt */
#define TMR_C4_INT      0x000010  /* Channel 4 interrupt */
#define TMR_HALL_INT    0x000020  /* Hall interrupt */
#define TMR_TRIGGER_INT 0x000040  /* Trigger interrupt */
#define TMR_BRK_INT     0x000080  /* Break interrupt */
```

### DMA Requests

```c
#define TMR_OVERFLOW_DMA_REQUEST 0x00000100  /* Overflow DMA request */
#define TMR_C1_DMA_REQUEST       0x00000200  /* Channel 1 DMA request */
#define TMR_C2_DMA_REQUEST       0x00000400  /* Channel 2 DMA request */
#define TMR_C3_DMA_REQUEST       0x00000800  /* Channel 3 DMA request */
#define TMR_C4_DMA_REQUEST       0x00001000  /* Channel 4 DMA request */
#define TMR_HALL_DMA_REQUEST     0x00002000  /* Hall DMA request */
#define TMR_TRIGGER_DMA_REQUEST  0x00004000  /* Trigger DMA request */
```

---

## API Functions

### Initialization Functions

```c
/* Reset timer to default state */
void tmr_reset(tmr_type *tmr_x);

/* Initialize timer base (period and prescaler) */
void tmr_base_init(tmr_type* tmr_x, uint32_t tmr_pr, uint32_t tmr_div);

/* Enable/disable timer counter */
void tmr_counter_enable(tmr_type *tmr_x, confirm_state new_state);

/* Set counter direction */
void tmr_cnt_dir_set(tmr_type *tmr_x, tmr_count_mode_type tmr_cnt_dir);

/* Set clock division */
void tmr_clock_source_div_set(tmr_type *tmr_x, tmr_clock_division_type tmr_clock_div);

/* Enable 32-bit mode (TMR2/TMR5 only) */
void tmr_32_bit_function_enable(tmr_type *tmr_x, confirm_state new_state);
```

### Counter/Period Functions

```c
/* Set/get counter value */
void tmr_counter_value_set(tmr_type *tmr_x, uint32_t tmr_cnt_value);
uint32_t tmr_counter_value_get(tmr_type *tmr_x);

/* Set/get prescaler */
void tmr_div_value_set(tmr_type *tmr_x, uint32_t tmr_div_value);
uint32_t tmr_div_value_get(tmr_type *tmr_x);

/* Set/get period */
void tmr_period_value_set(tmr_type *tmr_x, uint32_t tmr_pr_value);
uint32_t tmr_period_value_get(tmr_type *tmr_x);

/* Enable period buffer (auto-reload preload) */
void tmr_period_buffer_enable(tmr_type *tmr_x, confirm_state new_state);

/* Set repetition counter (TMR1/TMR8 only) */
void tmr_repetition_counter_set(tmr_type *tmr_x, uint8_t tmr_rpr_value);
```

### Output Channel Functions

```c
/* Initialize output channel default parameters */
void tmr_output_default_para_init(tmr_output_config_type *tmr_output_struct);

/* Configure output channel */
void tmr_output_channel_config(tmr_type *tmr_x, tmr_channel_select_type tmr_channel,
                               tmr_output_config_type *tmr_output_struct);

/* Select output channel mode */
void tmr_output_channel_mode_select(tmr_type *tmr_x, tmr_channel_select_type tmr_channel,
                                    tmr_output_control_mode_type oc_mode);

/* Set/get channel compare value */
void tmr_channel_value_set(tmr_type *tmr_x, tmr_channel_select_type tmr_channel,
                           uint32_t tmr_channel_value);
uint32_t tmr_channel_value_get(tmr_type *tmr_x, tmr_channel_select_type tmr_channel);

/* Enable channel output buffer (preload) */
void tmr_output_channel_buffer_enable(tmr_type *tmr_x, tmr_channel_select_type tmr_channel,
                                      confirm_state new_state);

/* Set output channel polarity */
void tmr_output_channel_polarity_set(tmr_type *tmr_x, tmr_channel_select_type tmr_channel,
                                     tmr_polarity_active_type oc_polarity);

/* Enable channel */
void tmr_channel_enable(tmr_type *tmr_x, tmr_channel_select_type tmr_channel,
                        confirm_state new_state);

/* Force output level */
void tmr_force_output_set(tmr_type *tmr_x, tmr_channel_select_type tmr_channel,
                          tmr_force_output_type force_output);

/* Enable main output (TMR1/TMR8 - required for advanced timers) */
void tmr_output_enable(tmr_type *tmr_x, confirm_state new_state);
```

### Input Channel Functions

```c
/* Initialize input channel default parameters */
void tmr_input_default_para_init(tmr_input_config_type *tmr_input_struct);

/* Configure input channel */
void tmr_input_channel_init(tmr_type *tmr_x, tmr_input_config_type *input_struct,
                            tmr_channel_input_divider_type divider_factor);

/* Configure PWM input mode */
void tmr_pwm_input_config(tmr_type *tmr_x, tmr_input_config_type *input_struct,
                          tmr_channel_input_divider_type divider_factor);

/* Set input channel filter */
void tmr_input_channel_filter_set(tmr_type *tmr_x, tmr_channel_select_type tmr_channel,
                                  uint16_t filter_value);

/* Set input channel divider */
void tmr_input_channel_divider_set(tmr_type *tmr_x, tmr_channel_select_type tmr_channel,
                                   tmr_channel_input_divider_type divider_factor);

/* Select channel 1 input source (normal or XOR) */
void tmr_channel1_input_select(tmr_type *tmr_x, tmr_channel1_input_connected_type ch1_connect);
```

### Slave Mode Functions

```c
/* Select slave mode */
void tmr_sub_mode_select(tmr_type *tmr_x, tmr_sub_mode_select_type sub_mode);

/* Select trigger input */
void tmr_trigger_input_select(tmr_type *tmr_x, sub_tmr_input_sel_type trigger_select);

/* Enable slave synchronization mode */
void tmr_sub_sync_mode_set(tmr_type *tmr_x, confirm_state new_state);

/* Select primary mode (master output) */
void tmr_primary_mode_select(tmr_type *tmr_x, tmr_primary_select_type primary_mode);

/* Use internal clock */
void tmr_internal_clock_set(tmr_type *tmr_x);
```

### External Clock Functions

```c
/* Configure external clock parameters */
void tmr_external_clock_config(tmr_type *tmr_x, tmr_external_signal_divider_type es_divide,
                               tmr_external_signal_polarity_type es_polarity, uint16_t es_filter);

/* Configure external clock mode 1 */
void tmr_external_clock_mode1_config(tmr_type *tmr_x, tmr_external_signal_divider_type es_divide,
                                     tmr_external_signal_polarity_type es_polarity, uint16_t es_filter);

/* Configure external clock mode 2 */
void tmr_external_clock_mode2_config(tmr_type *tmr_x, tmr_external_signal_divider_type es_divide,
                                     tmr_external_signal_polarity_type es_polarity, uint16_t es_filter);
```

### Encoder Functions

```c
/* Configure encoder mode */
void tmr_encoder_mode_config(tmr_type *tmr_x, tmr_encoder_mode_type encoder_mode,
                             tmr_input_polarity_type ic1_polarity,
                             tmr_input_polarity_type ic2_polarity);
```

### Special Modes

```c
/* Enable one-cycle (one-pulse) mode */
void tmr_one_cycle_mode_enable(tmr_type *tmr_x, confirm_state new_state);

/* Enable Hall sensor mode */
void tmr_hall_select(tmr_type *tmr_x, confirm_state new_state);

/* Enable channel buffer (Hall commutation) */
void tmr_channel_buffer_enable(tmr_type *tmr_x, confirm_state new_state);
```

### Break and Dead-Time Functions

```c
/* Initialize break/dead-time default parameters */
void tmr_brkdt_default_para_init(tmr_brkdt_config_type *tmr_brkdt_struct);

/* Configure break and dead-time */
void tmr_brkdt_config(tmr_type *tmr_x, tmr_brkdt_config_type *brkdt_struct);
```

### DMA Functions

```c
/* Enable DMA request */
void tmr_dma_request_enable(tmr_type *tmr_x, tmr_dma_request_type dma_request,
                            confirm_state new_state);

/* Select DMA request source */
void tmr_channel_dma_select(tmr_type *tmr_x, tmr_dma_request_source_type cc_dma_select);

/* Configure DMA burst mode */
void tmr_dma_control_config(tmr_type *tmr_x, tmr_dma_transfer_length_type dma_length,
                            tmr_dma_address_type dma_base_address);
```

### Interrupt and Flag Functions

```c
/* Enable/disable interrupt */
void tmr_interrupt_enable(tmr_type *tmr_x, uint32_t tmr_interrupt, confirm_state new_state);

/* Get interrupt flag status */
flag_status tmr_interrupt_flag_get(tmr_type *tmr_x, uint32_t tmr_flag);

/* Get flag status */
flag_status tmr_flag_get(tmr_type *tmr_x, uint32_t tmr_flag);

/* Clear flag */
void tmr_flag_clear(tmr_type *tmr_x, uint32_t tmr_flag);

/* Generate software event */
void tmr_event_sw_trigger(tmr_type *tmr_x, tmr_event_trigger_type tmr_event);
```

---

## Usage Examples

### Example 1: Basic Timer with Interrupt (1Hz LED Toggle)

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

crm_clocks_freq_type crm_clocks_freq_struct = {0};

void TMR1_OVF_TMR10_IRQHandler(void)
{
  if(tmr_interrupt_flag_get(TMR1, TMR_OVF_FLAG) != RESET)
  {
    at32_led_toggle(LED3);
    tmr_flag_clear(TMR1, TMR_OVF_FLAG);
  }
}

int main(void)
{
  system_clock_config();
  at32_board_init();
  
  /* Get system clock frequency */
  crm_clocks_freq_get(&crm_clocks_freq_struct);
  
  /* Enable TMR1 clock */
  crm_periph_clock_enable(CRM_TMR1_PERIPH_CLOCK, TRUE);
  
  /* Configure TMR1 for 1Hz interrupt
   * Timer frequency = SystemClock / (DIV+1) / (PR+1)
   * 1Hz = 240MHz / (24000) / (10000) */
  tmr_base_init(TMR1, 9999, (crm_clocks_freq_struct.ahb_freq / 10000) - 1);
  tmr_cnt_dir_set(TMR1, TMR_COUNT_UP);
  
  /* Enable overflow interrupt */
  tmr_interrupt_enable(TMR1, TMR_OVF_INT, TRUE);
  
  /* Configure NVIC */
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  nvic_irq_enable(TMR1_OVF_TMR10_IRQn, 0, 0);
  
  /* Enable counter */
  tmr_counter_enable(TMR1, TRUE);
  
  while(1)
  {
  }
}
```

### Example 2: PWM Output Generation

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

tmr_output_config_type tmr_oc_init_structure;

uint16_t ccr1_val = 333;  /* 50% duty cycle */
uint16_t ccr2_val = 249;  /* 37.5% duty cycle */
uint16_t ccr3_val = 166;  /* 25% duty cycle */
uint16_t ccr4_val = 83;   /* 12.5% duty cycle */

void gpio_configuration(void)
{
  gpio_init_type gpio_init_struct;
  
  gpio_default_para_init(&gpio_init_struct);
  
  /* TMR3 CH1/CH2 on PA6/PA7 */
  gpio_init_struct.gpio_pins = GPIO_PINS_6 | GPIO_PINS_7;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* TMR3 CH3/CH4 on PB0/PB1 */
  gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1;
  gpio_init(GPIOB, &gpio_init_struct);
}

int main(void)
{
  uint16_t prescaler_value;
  
  system_clock_config();
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR3_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  
  gpio_configuration();
  
  /* Compute prescaler for 24MHz timer clock */
  prescaler_value = (uint16_t)(system_core_clock / 24000000) - 1;
  
  /* TMR3 time base configuration
   * PWM frequency = 24MHz / (665+1) = 36kHz */
  tmr_base_init(TMR3, 665, prescaler_value);
  tmr_cnt_dir_set(TMR3, TMR_COUNT_UP);
  tmr_clock_source_div_set(TMR3, TMR_CLOCK_DIV1);
  
  /* Configure output channels */
  tmr_output_default_para_init(&tmr_oc_init_structure);
  tmr_oc_init_structure.oc_mode = TMR_OUTPUT_CONTROL_PWM_MODE_A;
  tmr_oc_init_structure.oc_idle_state = FALSE;
  tmr_oc_init_structure.oc_polarity = TMR_OUTPUT_ACTIVE_HIGH;
  tmr_oc_init_structure.oc_output_state = TRUE;
  
  /* Channel 1 */
  tmr_output_channel_config(TMR3, TMR_SELECT_CHANNEL_1, &tmr_oc_init_structure);
  tmr_channel_value_set(TMR3, TMR_SELECT_CHANNEL_1, ccr1_val);
  tmr_output_channel_buffer_enable(TMR3, TMR_SELECT_CHANNEL_1, TRUE);
  
  /* Channel 2 */
  tmr_output_channel_config(TMR3, TMR_SELECT_CHANNEL_2, &tmr_oc_init_structure);
  tmr_channel_value_set(TMR3, TMR_SELECT_CHANNEL_2, ccr2_val);
  tmr_output_channel_buffer_enable(TMR3, TMR_SELECT_CHANNEL_2, TRUE);
  
  /* Channel 3 */
  tmr_output_channel_config(TMR3, TMR_SELECT_CHANNEL_3, &tmr_oc_init_structure);
  tmr_channel_value_set(TMR3, TMR_SELECT_CHANNEL_3, ccr3_val);
  tmr_output_channel_buffer_enable(TMR3, TMR_SELECT_CHANNEL_3, TRUE);
  
  /* Channel 4 */
  tmr_output_channel_config(TMR3, TMR_SELECT_CHANNEL_4, &tmr_oc_init_structure);
  tmr_channel_value_set(TMR3, TMR_SELECT_CHANNEL_4, ccr4_val);
  tmr_output_channel_buffer_enable(TMR3, TMR_SELECT_CHANNEL_4, TRUE);
  
  /* Enable auto-reload preload */
  tmr_period_buffer_enable(TMR3, TRUE);
  
  /* Enable counter */
  tmr_counter_enable(TMR3, TRUE);
  
  while(1)
  {
  }
}
```

### Example 3: PWM Input Mode (Frequency/Duty Cycle Measurement)

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"
#include <stdio.h>

tmr_input_config_type tmr_ic_init_structure;
__IO uint16_t duty_cycle = 0;
__IO uint32_t frequency = 0;

void TMR3_GLOBAL_IRQHandler(void)
{
  if(tmr_interrupt_flag_get(TMR3, TMR_C2_FLAG) != RESET)
  {
    /* Get period from channel 2 (rising edge captures period) */
    uint32_t ic2value = tmr_channel_value_get(TMR3, TMR_SELECT_CHANNEL_2);
    
    if(ic2value != 0)
    {
      /* Calculate frequency */
      frequency = system_core_clock / ic2value;
      
      /* Get pulse width from channel 1 (falling edge captures pulse) */
      uint32_t ic1value = tmr_channel_value_get(TMR3, TMR_SELECT_CHANNEL_1);
      
      /* Calculate duty cycle */
      duty_cycle = (ic1value * 100) / ic2value;
    }
    
    tmr_flag_clear(TMR3, TMR_C2_FLAG);
  }
}

int main(void)
{
  system_clock_config();
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR3_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  
  /* Configure PA7 as input for TMR3 CH2 */
  gpio_init_type gpio_init_struct;
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_7;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure NVIC */
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  nvic_irq_enable(TMR3_GLOBAL_IRQn, 0, 0);
  
  /* Configure PWM input mode on channel 2 */
  tmr_input_default_para_init(&tmr_ic_init_structure);
  tmr_ic_init_structure.input_filter_value = 0;
  tmr_ic_init_structure.input_channel_select = TMR_SELECT_CHANNEL_2;
  tmr_ic_init_structure.input_mapped_select = TMR_CC_CHANNEL_MAPPED_DIRECT;
  tmr_ic_init_structure.input_polarity_select = TMR_INPUT_RISING_EDGE;
  
  tmr_pwm_input_config(TMR3, &tmr_ic_init_structure, TMR_CHANNEL_INPUT_DIV_1);
  
  /* Select trigger input: TI2FP2 */
  tmr_trigger_input_select(TMR3, TMR_SUB_INPUT_SEL_C2DF2);
  
  /* Select reset mode - counter resets on trigger */
  tmr_sub_mode_select(TMR3, TMR_SUB_RESET_MODE);
  
  /* Enable slave sync mode */
  tmr_sub_sync_mode_set(TMR3, TRUE);
  
  /* Enable counter */
  tmr_counter_enable(TMR3, TRUE);
  
  /* Enable channel 2 interrupt */
  tmr_interrupt_enable(TMR3, TMR_C2_INT, TRUE);
  
  while(1)
  {
    printf("Frequency = %dHz, Duty Cycle = %d%%\r\n", frequency, duty_cycle);
  }
}
```

### Example 4: Input Capture Mode

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"
#include <stdio.h>

crm_clocks_freq_type crm_clocks_freq_struct = {0};
tmr_input_config_type tmr_input_config_struct;

__IO uint32_t tmr3freq = 0;
__IO uint16_t capturenumber = 0;
__IO uint16_t ic3readvalue1 = 0, ic3readvalue2 = 0;
__IO uint32_t capture = 0;

void TMR3_GLOBAL_IRQHandler(void)
{
  if(tmr_interrupt_flag_get(TMR3, TMR_C2_FLAG) != RESET)
  {
    tmr_flag_clear(TMR3, TMR_C2_FLAG);
    
    if(capturenumber == 0)
    {
      /* First capture */
      ic3readvalue1 = tmr_channel_value_get(TMR3, TMR_SELECT_CHANNEL_2);
      capturenumber = 1;
    }
    else if(capturenumber == 1)
    {
      /* Second capture */
      ic3readvalue2 = tmr_channel_value_get(TMR3, TMR_SELECT_CHANNEL_2);
      
      /* Calculate period between captures */
      if(ic3readvalue2 > ic3readvalue1)
      {
        capture = (ic3readvalue2 - ic3readvalue1);
      }
      else
      {
        capture = ((0x10000 - ic3readvalue1) + ic3readvalue2);
      }
      
      /* Calculate frequency */
      tmr3freq = (uint32_t)crm_clocks_freq_struct.sclk_freq / capture;
      capturenumber = 0;
    }
  }
}

int main(void)
{
  system_clock_config();
  at32_board_init();
  
  crm_clocks_freq_get(&crm_clocks_freq_struct);
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR3_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  
  /* Configure PA7 as input */
  gpio_init_type gpio_init_struct = {0};
  gpio_init_struct.gpio_pins = GPIO_PINS_7;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* TMR3 base configuration - free running */
  tmr_base_init(TMR3, 0xFFFF, 0);
  tmr_cnt_dir_set(TMR3, TMR_COUNT_UP);
  
  /* Configure input capture on channel 2 */
  tmr_input_config_struct.input_channel_select = TMR_SELECT_CHANNEL_2;
  tmr_input_config_struct.input_mapped_select = TMR_CC_CHANNEL_MAPPED_DIRECT;
  tmr_input_config_struct.input_polarity_select = TMR_INPUT_RISING_EDGE;
  tmr_input_channel_init(TMR3, &tmr_input_config_struct, TMR_CHANNEL_INPUT_DIV_1);
  
  /* Enable channel 2 interrupt */
  tmr_interrupt_enable(TMR3, TMR_C2_INT, TRUE);
  
  /* Configure NVIC */
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  nvic_irq_enable(TMR3_GLOBAL_IRQn, 0, 0);
  
  /* Enable counter */
  tmr_counter_enable(TMR3, TRUE);
  
  while(1)
  {
    printf("External signal frequency: %d Hz\r\n", tmr3freq);
  }
}
```

### Example 5: Encoder Interface Mode

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

uint32_t encoder_count;

int main(void)
{
  gpio_init_type gpio_init_struct = {0};
  
  system_clock_config();
  at32_board_init();
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  
  /* Configure PA0/PA1 as encoder inputs (TMR2 CH1/CH2) */
  gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Enable 32-bit mode for extended range */
  tmr_32_bit_function_enable(TMR2, TRUE);
  
  /* Configure timer base */
  tmr_base_init(TMR2, 0xFFFFFFFF, 0);
  tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
  
  /* Configure encoder mode C (count on both edges of both channels) */
  tmr_encoder_mode_config(TMR2, TMR_ENCODER_MODE_C, 
                          TMR_INPUT_RISING_EDGE, 
                          TMR_INPUT_RISING_EDGE);
  
  /* Enable counter */
  tmr_counter_enable(TMR2, TRUE);
  
  while(1)
  {
    /* Read encoder position */
    encoder_count = tmr_counter_value_get(TMR2);
  }
}
```

### Example 6: Complementary PWM with Dead-Time

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

tmr_output_config_type tmr_output_struct;
tmr_brkdt_config_type tmr_brkdt_config_struct;
crm_clocks_freq_type crm_clocks_freq_struct = {0};

uint16_t timer_period = 0;
uint16_t channel1_pulse = 0, channel2_pulse = 0, channel3_pulse = 0;

int main(void)
{
  gpio_init_type gpio_init_struct = {0};
  
  system_clock_config();
  at32_board_init();
  crm_clocks_freq_get(&crm_clocks_freq_struct);
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  
  /* TMR1 CH1/CH2/CH3 outputs on PA8/PA9/PA10 */
  gpio_init_struct.gpio_pins = GPIO_PINS_8 | GPIO_PINS_9 | GPIO_PINS_10;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* TMR1 CH1N/CH2N/CH3N outputs on PB13/PB14/PB15 */
  gpio_init_struct.gpio_pins = GPIO_PINS_13 | GPIO_PINS_14 | GPIO_PINS_15;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* Break input on PB12 */
  gpio_init_struct.gpio_pins = GPIO_PINS_12;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* Calculate period for 17.57kHz PWM */
  timer_period = (crm_clocks_freq_struct.sclk_freq / 17570) - 1;
  
  /* Calculate duty cycles */
  channel1_pulse = (uint16_t)(((uint32_t)50 * (timer_period - 1)) / 100);   /* 50% */
  channel2_pulse = (uint16_t)(((uint32_t)25 * (timer_period - 1)) / 100);   /* 25% */
  channel3_pulse = (uint16_t)(((uint32_t)125 * (timer_period - 1)) / 1000); /* 12.5% */
  
  /* Configure timer base */
  tmr_base_init(TMR1, timer_period, 0);
  tmr_cnt_dir_set(TMR1, TMR_COUNT_UP);
  
  /* Configure output channels with complementary outputs */
  tmr_output_default_para_init(&tmr_output_struct);
  tmr_output_struct.oc_mode = TMR_OUTPUT_CONTROL_PWM_MODE_B;
  tmr_output_struct.oc_output_state = TRUE;
  tmr_output_struct.oc_polarity = TMR_OUTPUT_ACTIVE_LOW;
  tmr_output_struct.oc_idle_state = TRUE;
  tmr_output_struct.occ_output_state = TRUE;        /* Enable complementary */
  tmr_output_struct.occ_polarity = TMR_OUTPUT_ACTIVE_LOW;
  tmr_output_struct.occ_idle_state = FALSE;
  
  /* Configure channels */
  tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_1, &tmr_output_struct);
  tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_1, channel1_pulse);
  
  tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_2, &tmr_output_struct);
  tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_2, channel2_pulse);
  
  tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_3, &tmr_output_struct);
  tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_3, channel3_pulse);
  
  /* Configure break and dead-time */
  tmr_brkdt_default_para_init(&tmr_brkdt_config_struct);
  tmr_brkdt_config_struct.brk_enable = TRUE;
  tmr_brkdt_config_struct.auto_output_enable = TRUE;
  tmr_brkdt_config_struct.deadtime = 11;            /* Dead-time value */
  tmr_brkdt_config_struct.fcsodis_state = TRUE;     /* Force off-state when disabled */
  tmr_brkdt_config_struct.fcsoen_state = TRUE;      /* Force off-state when enabled */
  tmr_brkdt_config_struct.brk_polarity = TMR_BRK_INPUT_ACTIVE_HIGH;
  tmr_brkdt_config_struct.wp_level = TMR_WP_LEVEL_3; /* Write protection */
  tmr_brkdt_config(TMR1, &tmr_brkdt_config_struct);
  
  /* Enable main output */
  tmr_output_enable(TMR1, TRUE);
  
  /* Enable counter */
  tmr_counter_enable(TMR1, TRUE);
  
  while(1)
  {
  }
}
```

### Example 7: Hall Sensor Interface (XOR Mode)

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

void TMR2_GLOBAL_IRQHandler(void)
{
  if(tmr_interrupt_flag_get(TMR2, TMR_TRIGGER_FLAG) != RESET)
  {
    /* Hall state changed - handle commutation */
    GPIOA->odt ^= GPIO_PINS_8;  /* Toggle indicator */
    tmr_flag_clear(TMR2, TMR_TRIGGER_FLAG);
  }
}

int main(void)
{
  gpio_init_type gpio_init_struct = {0};
  tmr_input_config_type tmr_input_config_struct;
  
  system_clock_config();
  at32_board_init();
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  
  /* Configure PA0/PA1/PA2 as Hall sensor inputs (TMR2 CH1/CH2/CH3) */
  gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1 | GPIO_PINS_2;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Enable 32-bit mode */
  tmr_32_bit_function_enable(TMR2, TRUE);
  
  /* Configure timer base */
  tmr_base_init(TMR2, 0xFFFFFFFF, 0);
  tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
  
  /* Configure channel 1 as input mapped to TRC (XOR output) */
  tmr_input_config_struct.input_channel_select = TMR_SELECT_CHANNEL_1;
  tmr_input_config_struct.input_mapped_select = TMR_CC_CHANNEL_MAPPED_STI;
  tmr_input_config_struct.input_polarity_select = TMR_INPUT_RISING_EDGE;
  tmr_input_channel_init(TMR2, &tmr_input_config_struct, TMR_CHANNEL_INPUT_DIV_1);
  
  /* Enable XOR function (CH1, CH2, CH3 XORed to TI1) */
  tmr_channel1_input_select(TMR2, TMR_CHANEL1_2_3_CONNECTED_C1IRAW_XOR);
  
  /* Select trigger input: TI1 edge detector */
  tmr_trigger_input_select(TMR2, TMR_SUB_INPUT_SEL_C1INC);
  
  /* Select reset mode - counter resets on Hall state change */
  tmr_sub_mode_select(TMR2, TMR_SUB_RESET_MODE);
  
  /* Enable trigger interrupt */
  tmr_interrupt_enable(TMR2, TMR_TRIGGER_INT, TRUE);
  
  /* Configure NVIC */
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  nvic_irq_enable(TMR2_GLOBAL_IRQn, 0, 0);
  
  /* Enable counter */
  tmr_counter_enable(TMR2, TRUE);
  
  while(1)
  {
  }
}
```

### Example 8: 6-Step BLDC Motor Commutation

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

tmr_output_config_type tmr_output_struct;
tmr_brkdt_config_type tmr_brkdt_config_struct;
__IO uint32_t step = 1;

/* Commutation table for 6-step motor control:
 * Step | CH1 | CH1N | CH2 | CH2N | CH3 | CH3N
 *   1  |  1  |   0  |  0  |   1  |  0  |   0
 *   2  |  1  |   0  |  0  |   0  |  0  |   1
 *   3  |  0  |   0  |  1  |   0  |  0  |   1
 *   4  |  0  |   1  |  1  |   0  |  0  |   0
 *   5  |  0  |   1  |  0  |   0  |  1  |   0
 *   6  |  0  |   0  |  0  |   1  |  1  |   0
 */

void TMR1_TRG_HALL_TMR11_IRQHandler(void)
{
  tmr_flag_clear(TMR1, TMR_HALL_FLAG);
  
  switch(step)
  {
    case 1:
      /* Step 2 configuration */
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_3, FALSE);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_3C, FALSE);
      
      tmr_output_channel_mode_select(TMR1, TMR_SELECT_CHANNEL_1, TMR_OUTPUT_CONTROL_PWM_MODE_A);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_1, TRUE);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_1C, FALSE);
      
      tmr_output_channel_mode_select(TMR1, TMR_SELECT_CHANNEL_2, TMR_OUTPUT_CONTROL_PWM_MODE_A);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_2, FALSE);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_2C, TRUE);
      step = 2;
      break;
      
    case 2:
      /* Step 3 configuration */
      tmr_output_channel_mode_select(TMR1, TMR_SELECT_CHANNEL_2, TMR_OUTPUT_CONTROL_PWM_MODE_A);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_2, FALSE);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_2C, TRUE);
      
      tmr_output_channel_mode_select(TMR1, TMR_SELECT_CHANNEL_3, TMR_OUTPUT_CONTROL_PWM_MODE_A);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_3, TRUE);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_3C, FALSE);
      
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_1, FALSE);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_1C, FALSE);
      step = 3;
      break;
      
    /* ... steps 4, 5, 6 follow similar pattern ... */
    
    default:
      /* Back to step 1 */
      tmr_output_channel_mode_select(TMR1, TMR_SELECT_CHANNEL_1, TMR_OUTPUT_CONTROL_PWM_MODE_A);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_1, TRUE);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_1C, FALSE);
      
      tmr_output_channel_mode_select(TMR1, TMR_SELECT_CHANNEL_3, TMR_OUTPUT_CONTROL_PWM_MODE_A);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_3, FALSE);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_3C, TRUE);
      
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_2, FALSE);
      tmr_channel_enable(TMR1, TMR_SELECT_CHANNEL_2C, FALSE);
      step = 1;
      break;
  }
}

int main(void)
{
  /* ... GPIO and clock configuration ... */
  
  /* Configure timer base */
  tmr_base_init(TMR1, 4095, 0);
  tmr_cnt_dir_set(TMR1, TMR_COUNT_UP);
  
  /* Configure output channels */
  tmr_output_default_para_init(&tmr_output_struct);
  tmr_output_struct.oc_mode = TMR_OUTPUT_CONTROL_OFF;
  tmr_output_struct.oc_output_state = TRUE;
  tmr_output_struct.oc_polarity = TMR_OUTPUT_ACTIVE_HIGH;
  tmr_output_struct.oc_idle_state = TRUE;
  tmr_output_struct.occ_output_state = TRUE;
  tmr_output_struct.occ_polarity = TMR_OUTPUT_ACTIVE_HIGH;
  tmr_output_struct.occ_idle_state = TRUE;
  
  /* Configure all channels */
  tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_1, &tmr_output_struct);
  tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_1, 2047);
  tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_2, &tmr_output_struct);
  tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_2, 1023);
  tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_3, &tmr_output_struct);
  tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_3, 511);
  
  /* Configure break and dead-time */
  tmr_brkdt_default_para_init(&tmr_brkdt_config_struct);
  tmr_brkdt_config_struct.brk_enable = TRUE;
  tmr_brkdt_config_struct.auto_output_enable = TRUE;
  tmr_brkdt_config_struct.deadtime = 0;
  tmr_brkdt_config_struct.fcsodis_state = TRUE;
  tmr_brkdt_config_struct.fcsoen_state = TRUE;
  tmr_brkdt_config_struct.brk_polarity = TMR_BRK_INPUT_ACTIVE_HIGH;
  tmr_brkdt_config_struct.wp_level = TMR_WP_OFF;
  tmr_brkdt_config(TMR1, &tmr_brkdt_config_struct);
  
  /* Enable channel buffer for commutation */
  tmr_channel_buffer_enable(TMR1, TRUE);
  
  /* Enable Hall interrupt */
  tmr_interrupt_enable(TMR1, TMR_HALL_INT, TRUE);
  nvic_irq_enable(TMR1_TRG_HALL_TMR11_IRQn, 0, 0);
  
  /* Enable main output */
  tmr_output_enable(TMR1, TRUE);
  
  /* Enable counter */
  tmr_counter_enable(TMR1, TRUE);
  
  while(1)
  {
  }
}
```

### Example 9: One-Cycle (One-Pulse) Mode

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

tmr_output_config_type tmr_oc_init_structure;
tmr_input_config_type tmr_ic_init_structure;

int main(void)
{
  gpio_init_type gpio_init_struct;
  uint16_t prescaler_value;
  
  system_clock_config();
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR4_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  
  gpio_default_para_init(&gpio_init_struct);
  
  /* PB7 as trigger input (TMR4 CH2) */
  gpio_init_struct.gpio_pins = GPIO_PINS_7;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* PB6 as pulse output (TMR4 CH1) */
  gpio_init_struct.gpio_pins = GPIO_PINS_6;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* Compute prescaler for 24MHz timer clock */
  prescaler_value = (uint16_t)(system_core_clock / 24000000) - 1;
  
  /* Timer base configuration */
  tmr_base_init(TMR4, 65535, prescaler_value);
  tmr_cnt_dir_set(TMR4, TMR_COUNT_UP);
  tmr_clock_source_div_set(TMR4, TMR_CLOCK_DIV1);
  
  /* Configure output channel 1 for pulse generation */
  tmr_output_default_para_init(&tmr_oc_init_structure);
  tmr_oc_init_structure.oc_mode = TMR_OUTPUT_CONTROL_PWM_MODE_B;
  tmr_oc_init_structure.oc_idle_state = FALSE;
  tmr_oc_init_structure.oc_polarity = TMR_OUTPUT_ACTIVE_HIGH;
  tmr_oc_init_structure.oc_output_state = TRUE;
  tmr_output_channel_config(TMR4, TMR_SELECT_CHANNEL_1, &tmr_oc_init_structure);
  tmr_channel_value_set(TMR4, TMR_SELECT_CHANNEL_1, 16383);  /* Pulse width */
  
  /* Configure input channel 2 as trigger */
  tmr_input_default_para_init(&tmr_ic_init_structure);
  tmr_ic_init_structure.input_filter_value = 0;
  tmr_ic_init_structure.input_channel_select = TMR_SELECT_CHANNEL_2;
  tmr_ic_init_structure.input_mapped_select = TMR_CC_CHANNEL_MAPPED_DIRECT;
  tmr_ic_init_structure.input_polarity_select = TMR_INPUT_RISING_EDGE;
  tmr_input_channel_init(TMR4, &tmr_ic_init_structure, TMR_CHANNEL_INPUT_DIV_1);
  
  /* Enable one-cycle mode */
  tmr_one_cycle_mode_enable(TMR4, TRUE);
  
  /* Select trigger input: TI2FP2 */
  tmr_trigger_input_select(TMR4, TMR_SUB_INPUT_SEL_C2DF2);
  
  /* Select trigger mode - start on trigger */
  tmr_sub_mode_select(TMR4, TMR_SUB_TRIGGER_MODE);
  
  /* Timer will start automatically on trigger and generate one pulse */
  
  while(1)
  {
  }
}
```

### Example 10: Timer Cascade Synchronization

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

tmr_output_config_type tmr_output_struct;

int main(void)
{
  gpio_init_type gpio_init_struct = {0};
  
  system_clock_config();
  at32_board_init();
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_TMR3_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_TMR4_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  
  /* Configure output pins */
  gpio_init_struct.gpio_pins = GPIO_PINS_6 | GPIO_PINS_0;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init(GPIOA, &gpio_init_struct);
  
  gpio_init_struct.gpio_pins = GPIO_PINS_6;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* TMR2: Master timer - 1MHz */
  tmr_base_init(TMR2, 239, 0);
  tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
  
  /* TMR3: Slave of TMR2, Master for TMR4 */
  tmr_base_init(TMR3, 23, 0);
  tmr_cnt_dir_set(TMR3, TMR_COUNT_UP);
  
  /* TMR4: Slave of TMR3 */
  tmr_base_init(TMR4, 23, 0);
  tmr_cnt_dir_set(TMR4, TMR_COUNT_UP);
  
  /* Configure PWM outputs */
  tmr_output_default_para_init(&tmr_output_struct);
  tmr_output_struct.oc_mode = TMR_OUTPUT_CONTROL_PWM_MODE_A;
  tmr_output_struct.oc_output_state = TRUE;
  tmr_output_struct.oc_polarity = TMR_OUTPUT_ACTIVE_LOW;
  
  /* TMR2 Channel 1 */
  tmr_output_channel_config(TMR2, TMR_SELECT_CHANNEL_1, &tmr_output_struct);
  tmr_channel_value_set(TMR2, TMR_SELECT_CHANNEL_1, 59);  /* 25% duty */
  
  /* TMR2 as master - output overflow event */
  tmr_primary_mode_select(TMR2, TMR_PRIMARY_SEL_OVERFLOW);
  tmr_sub_sync_mode_set(TMR2, TRUE);
  
  /* TMR3 Channel 1 */
  tmr_output_channel_config(TMR3, TMR_SELECT_CHANNEL_1, &tmr_output_struct);
  tmr_channel_value_set(TMR3, TMR_SELECT_CHANNEL_1, 5);
  
  /* TMR3 as slave of TMR2 (IS1 = TMR2 trigger output) */
  tmr_sub_mode_select(TMR3, TMR_SUB_HANG_MODE);  /* Gated mode */
  tmr_trigger_input_select(TMR3, TMR_SUB_INPUT_SEL_IS1);
  
  /* TMR3 as master for TMR4 */
  tmr_primary_mode_select(TMR3, TMR_PRIMARY_SEL_OVERFLOW);
  tmr_sub_sync_mode_set(TMR3, TRUE);
  
  /* TMR4 Channel 1 */
  tmr_output_channel_config(TMR4, TMR_SELECT_CHANNEL_1, &tmr_output_struct);
  tmr_channel_value_set(TMR4, TMR_SELECT_CHANNEL_1, 5);
  
  /* TMR4 as slave of TMR3 (IS2 = TMR3 trigger output) */
  tmr_sub_mode_select(TMR4, TMR_SUB_HANG_MODE);
  tmr_trigger_input_select(TMR4, TMR_SUB_INPUT_SEL_IS2);
  
  /* Enable all timers */
  tmr_counter_enable(TMR2, TRUE);
  tmr_counter_enable(TMR3, TRUE);
  tmr_counter_enable(TMR4, TRUE);
  
  while(1)
  {
  }
}
```

### Example 11: DMA Burst Mode

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

tmr_output_config_type tmr_output_struct;
dma_init_type dma_init_struct;

/* Buffer for DMA burst: PR, RPR, C1DT (3 registers starting from PR address) */
uint16_t src_buffer[3] = {0x0FFF, 0x0000, 0x0555};

int main(void)
{
  gpio_init_type gpio_init_struct = {0};
  crm_clocks_freq_type crm_clocks_freq_struct;
  
  system_clock_config();
  at32_board_init();
  crm_clocks_freq_get(&crm_clocks_freq_struct);
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  
  /* Configure PA8 as TMR1 CH1 output */
  gpio_init_struct.gpio_pins = GPIO_PINS_8;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure timer base */
  tmr_base_init(TMR1, 0xFFFF, (crm_clocks_freq_struct.sclk_freq / 24000000) - 1);
  tmr_cnt_dir_set(TMR1, TMR_COUNT_UP);
  
  /* Configure output channel 1 */
  tmr_output_default_para_init(&tmr_output_struct);
  tmr_output_struct.oc_mode = TMR_OUTPUT_CONTROL_PWM_MODE_B;
  tmr_output_struct.oc_output_state = TRUE;
  tmr_output_struct.oc_polarity = TMR_OUTPUT_ACTIVE_LOW;
  tmr_output_struct.oc_idle_state = TRUE;
  tmr_output_channel_config(TMR1, TMR_SELECT_CHANNEL_1, &tmr_output_struct);
  tmr_channel_value_set(TMR1, TMR_SELECT_CHANNEL_1, 0xFFF);
  
  /* Enable overflow DMA request */
  tmr_dma_request_enable(TMR1, TMR_OVERFLOW_DMA_REQUEST, TRUE);
  
  /* Configure DMA burst: transfer 3 registers starting from PR */
  tmr_dma_control_config(TMR1, TMR_DMA_TRANSFER_3BYTES, TMR_PR_ADDRESS);
  
  /* Configure DMA1 Channel 5 for TMR1 overflow */
  dma_reset(DMA1_CHANNEL5);
  dma_init_struct.buffer_size = 3;
  dma_init_struct.direction = DMA_DIR_MEMORY_TO_PERIPHERAL;
  dma_init_struct.memory_base_addr = (uint32_t)src_buffer;
  dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_HALFWORD;
  dma_init_struct.memory_inc_enable = TRUE;
  dma_init_struct.peripheral_base_addr = (uint32_t)&TMR1->dmadt;
  dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD;
  dma_init_struct.peripheral_inc_enable = FALSE;
  dma_init_struct.priority = DMA_PRIORITY_MEDIUM;
  dma_init_struct.loop_mode_enable = TRUE;  /* Circular mode */
  dma_init(DMA1_CHANNEL5, &dma_init_struct);
  
  dma_channel_enable(DMA1_CHANNEL5, TRUE);
  
  /* Enable main output */
  tmr_output_enable(TMR1, TRUE);
  
  /* Enable counter */
  tmr_counter_enable(TMR1, TRUE);
  
  while(1)
  {
  }
}
```

### Example 12: 32-bit Timer Mode (TMR2/TMR5)

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

tmr_output_config_type tmr_oc_init_structure;

uint32_t ccr1_val = 0x7FFFF;   /* 32-bit compare values */
uint32_t ccr2_val = 0x3FFFF;
uint32_t ccr3_val = 0x1FFFF;
uint32_t ccr4_val = 0xFFFF;

int main(void)
{
  gpio_init_type gpio_init_struct;
  
  system_clock_config();
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  
  /* Configure PA0-PA3 as TMR2 CH1-CH4 outputs */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1 | GPIO_PINS_2 | GPIO_PINS_3;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Enable 32-bit mode (TMR2/TMR5 only) */
  tmr_32_bit_function_enable(TMR2, TRUE);
  
  /* Configure timer with 32-bit period */
  tmr_base_init(TMR2, 0xFFFFF, 0);  /* 20-bit period example */
  tmr_cnt_dir_set(TMR2, TMR_COUNT_UP);
  tmr_clock_source_div_set(TMR2, TMR_CLOCK_DIV1);
  
  /* Configure PWM outputs */
  tmr_output_default_para_init(&tmr_oc_init_structure);
  tmr_oc_init_structure.oc_mode = TMR_OUTPUT_CONTROL_PWM_MODE_A;
  tmr_oc_init_structure.oc_idle_state = FALSE;
  tmr_oc_init_structure.oc_polarity = TMR_OUTPUT_ACTIVE_HIGH;
  tmr_oc_init_structure.oc_output_state = TRUE;
  
  /* Configure channels with 32-bit compare values */
  tmr_output_channel_config(TMR2, TMR_SELECT_CHANNEL_1, &tmr_oc_init_structure);
  tmr_channel_value_set(TMR2, TMR_SELECT_CHANNEL_1, ccr1_val);
  tmr_output_channel_buffer_enable(TMR2, TMR_SELECT_CHANNEL_1, TRUE);
  
  tmr_output_channel_config(TMR2, TMR_SELECT_CHANNEL_2, &tmr_oc_init_structure);
  tmr_channel_value_set(TMR2, TMR_SELECT_CHANNEL_2, ccr2_val);
  tmr_output_channel_buffer_enable(TMR2, TMR_SELECT_CHANNEL_2, TRUE);
  
  tmr_output_channel_config(TMR2, TMR_SELECT_CHANNEL_3, &tmr_oc_init_structure);
  tmr_channel_value_set(TMR2, TMR_SELECT_CHANNEL_3, ccr3_val);
  tmr_output_channel_buffer_enable(TMR2, TMR_SELECT_CHANNEL_3, TRUE);
  
  tmr_output_channel_config(TMR2, TMR_SELECT_CHANNEL_4, &tmr_oc_init_structure);
  tmr_channel_value_set(TMR2, TMR_SELECT_CHANNEL_4, ccr4_val);
  tmr_output_channel_buffer_enable(TMR2, TMR_SELECT_CHANNEL_4, TRUE);
  
  tmr_period_buffer_enable(TMR2, TRUE);
  
  /* Enable counter */
  tmr_counter_enable(TMR2, TRUE);
  
  while(1)
  {
  }
}
```

---

## Timer Interconnection Map

### Internal Trigger Connections

| Slave Timer | IS0 | IS1 | IS2 | IS3 |
|-------------|-----|-----|-----|-----|
| TMR1 | TMR5 | TMR2 | TMR3 | TMR4 |
| TMR2 | TMR1 | TMR8 | TMR3 | TMR4 |
| TMR3 | TMR1 | TMR2 | TMR5 | TMR4 |
| TMR4 | TMR1 | TMR2 | TMR3 | TMR8 |
| TMR5 | TMR2 | TMR3 | TMR4 | TMR8 |
| TMR8 | TMR1 | TMR2 | TMR4 | TMR5 |
| TMR9 | TMR2 | TMR3 | TMR10 | TMR11 |
| TMR12 | TMR4 | TMR5 | TMR13 | TMR14 |

---

## Important Notes

1. **Advanced Timer Output Enable**: TMR1 and TMR8 require `tmr_output_enable(TMRx, TRUE)` to activate outputs.

2. **32-bit Mode**: Only TMR2 and TMR5 support 32-bit counter operation via `tmr_32_bit_function_enable()`.

3. **Complementary Outputs**: Only TMR1 and TMR8 have complementary outputs with dead-time insertion.

4. **Break Function**: Only available on TMR1 and TMR8 for safety applications.

5. **Repetition Counter**: Only TMR1 and TMR8 have RPR register for advanced PWM patterns.

6. **Clock Division**: Used for dead-time and filter sampling, available on most timers except TMR6/TMR7.

7. **Buffer Registers**: Enable preload with `tmr_period_buffer_enable()` and `tmr_output_channel_buffer_enable()` for glitch-free updates.

8. **Hall Sensor Mode**: Combine XOR function (`tmr_channel1_input_select()`) with commutation events for BLDC control.

9. **Encoder Modes**:
   - Mode A: Count on TI1 edges only
   - Mode B: Count on TI2 edges only
   - Mode C: Count on both TI1 and TI2 edges (4x resolution)

10. **DMA Burst Mode**: Allows updating multiple consecutive registers with a single DMA trigger.

---

## Timer IRQ Handlers

| Timer | IRQ Handler |
|-------|-------------|
| TMR1 Overflow + TMR10 | `TMR1_OVF_TMR10_IRQHandler` |
| TMR1 Break | `TMR1_BRK_TMR9_IRQHandler` |
| TMR1 Trigger + Hall + TMR11 | `TMR1_TRG_HALL_TMR11_IRQHandler` |
| TMR1 Channel | `TMR1_CH_IRQHandler` |
| TMR2 | `TMR2_GLOBAL_IRQHandler` |
| TMR3 | `TMR3_GLOBAL_IRQHandler` |
| TMR4 | `TMR4_GLOBAL_IRQHandler` |
| TMR5 | `TMR5_GLOBAL_IRQHandler` |
| TMR6 | `TMR6_GLOBAL_IRQHandler` |
| TMR7 | `TMR7_GLOBAL_IRQHandler` |
| TMR8 Overflow + TMR13 | `TMR8_OVF_TMR13_IRQHandler` |
| TMR8 Break + TMR12 | `TMR8_BRK_TMR12_IRQHandler` |
| TMR8 Trigger + Hall + TMR14 | `TMR8_TRG_HALL_TMR14_IRQHandler` |
| TMR8 Channel | `TMR8_CH_IRQHandler` |

---

## Related Peripherals

- **CRM**: Clock configuration for timer peripherals
- **GPIO**: Timer input/output pin configuration
- **DMA**: Efficient data transfer for timer operations
- **NVIC**: Interrupt configuration for timer events

