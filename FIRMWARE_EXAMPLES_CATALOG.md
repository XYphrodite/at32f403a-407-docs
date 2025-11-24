# AT32F403A/407 Firmware Library Examples Catalog

**Purpose:** Comprehensive catalog of firmware examples with code snippets for Context7 indexing  
**Library Version:** v2.2.1  
**Total Examples:** 1,985 files (937 F403A + 1,048 F407)  
**Date:** November 2024

---

## 📑 Table of Contents

- [ADC Examples](#adc-examples)
- [CAN Examples](#can-examples)
- [Flash Memory Examples](#flash-memory-examples)
- [PWC Power Control Examples](#pwc-power-control-examples)
- [Timer Examples](#timer-examples)
- [USART Examples](#usart-examples)
- [I2C Examples](#i2c-examples)
- [SPI Examples](#spi-examples)
- [USB Device Examples](#usb-device-examples)
- [GPIO Examples](#gpio-examples)
- [DMA Examples](#dma-examples)

---

## ADC Examples

### ADC Internal Temperature Sensor

**Path:** `project/at_start_f403a/examples/adc/internal_temperature_sensor/`

**Description:**  
Demonstrates how to use the internal temperature sensor (ADC Channel 16) with DMA for continuous temperature monitoring.

**Hardware Setup:**
- Uses ADC1 Channel 16 (internal temperature sensor)
- DMA1 Channel 1 for data transfer
- UART output at 115200 baud

**Key Configuration:**

```c
#define ADC_VREF                         (3.3)
#define ADC_TEMP_BASE                    (1.28)
#define ADC_TEMP_SLOPE                   (-0.00426)

static void adc_config(void)
{
  adc_base_config_type adc_base_struct;
  crm_periph_clock_enable(CRM_ADC1_PERIPH_CLOCK, TRUE);
  crm_adc_clock_div_set(CRM_ADC_DIV_6);

  /* Select independent mode */
  adc_combine_mode_select(ADC_INDEPENDENT_MODE);
  adc_base_default_para_init(&adc_base_struct);
  adc_base_struct.sequence_mode = FALSE;
  adc_base_struct.repeat_mode = TRUE;
  adc_base_struct.data_align = ADC_RIGHT_ALIGNMENT;
  adc_base_struct.ordinary_channel_length = 1;
  adc_base_config(ADC1, &adc_base_struct);
  
  /* Configure channel 16 (temperature sensor) */
  adc_ordinary_channel_set(ADC1, ADC_CHANNEL_16, 1, ADC_SAMPLETIME_239_5);
  adc_ordinary_conversion_trigger_set(ADC1, ADC12_ORDINARY_TRIG_SOFTWARE, TRUE);
  adc_dma_mode_enable(ADC1, TRUE);
  adc_tempersensor_vintrv_enable(TRUE);

  /* Enable and calibrate ADC */
  adc_enable(ADC1, TRUE);
  adc_calibration_init(ADC1);
  while(adc_calibration_init_status_get(ADC1));
  adc_calibration_start(ADC1);
  while(adc_calibration_status_get(ADC1));
}
```

**Temperature Calculation:**

```c
/* Calculate temperature in degrees Celsius */
float temperature = (ADC_TEMP_BASE - (double)adc1_ordinary_value * ADC_VREF / 4096) 
                    / ADC_TEMP_SLOPE + 25;

printf("internal_temperature = %f deg C\r\n", temperature);
```

**DMA Configuration:**

```c
static void dma_config(void)
{
  dma_init_type dma_init_struct;
  crm_periph_clock_enable(CRM_DMA1_PERIPH_CLOCK, TRUE);
  dma_reset(DMA1_CHANNEL1);
  dma_default_para_init(&dma_init_struct);
  
  dma_init_struct.buffer_size = 1;
  dma_init_struct.direction = DMA_DIR_PERIPHERAL_TO_MEMORY;
  dma_init_struct.memory_base_addr = (uint32_t)&adc1_ordinary_value;
  dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_HALFWORD;
  dma_init_struct.memory_inc_enable = FALSE;
  dma_init_struct.peripheral_base_addr = (uint32_t)&(ADC1->odt);
  dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_HALFWORD;
  dma_init_struct.peripheral_inc_enable = FALSE;
  dma_init_struct.priority = DMA_PRIORITY_HIGH;
  dma_init_struct.loop_mode_enable = TRUE;
  
  dma_init(DMA1_CHANNEL1, &dma_init_struct);
  dma_channel_enable(DMA1_CHANNEL1, TRUE);
}
```

---

### ADC Voltage Monitoring

**Path:** `project/at_start_f403a/examples/adc/voltage_monitoring/`

**Description:**  
Uses ADC analog watchdog to monitor voltage levels and trigger interrupts when voltage exceeds thresholds.

**Features:**
- Analog watchdog configuration
- Interrupt-based voltage monitoring
- Configurable high/low thresholds

---

### ADC Dual Mode - Triple ADC Synchronous Trigger

**Path:** `project/at_start_f403a/examples/adc/triple_adc_synchro_trigger/`

**Description:**  
Demonstrates synchronous operation of three ADCs (ADC1, ADC2, ADC3) with simultaneous sampling.

**Important Note:**  
⚠️ **Errata Workaround Required:** When using dual/triple ADC mode, ADC2 must be enabled before ADC1 calibration to prevent program hang. See ES0002 section 5.1.2.

**Correct Initialization Sequence:**

```c
/* Enable both ADCs BEFORE calibration */
adc_enable(ADC1, TRUE);
adc_enable(ADC2, TRUE);

/* Calibrate ADC1 first */
adc_calibration_init(ADC1);
while(adc_calibration_init_status_get(ADC1));
adc_calibration_start(ADC1);
while(adc_calibration_status_get(ADC1));

/* Then calibrate ADC2 */
adc_calibration_init(ADC2);
while(adc_calibration_init_status_get(ADC2));
adc_calibration_start(ADC2);
while(adc_calibration_status_get(ADC2));
```

---

### ADC DMA Continuous Conversion

**Path:** `project/at_start_f403a/examples/adc/repeat_conversion_loop_transfer/`

**Description:**  
Continuous ADC conversion with DMA in loop mode for high-speed data acquisition.

**Features:**
- Continuous conversion mode
- DMA circular buffer
- Multiple channel scanning

---

### ADC Software Trigger Repeat

**Path:** `project/at_start_f403a/examples/adc/software_trigger_repeat/`

**Description:**  
Software-triggered ADC conversions in repeat mode.

---

### ADC Timer Trigger with Preempted Channels

**Path:** `project/at_start_f403a/examples/adc/tmr_trigger_automatic_preempted/`

**Description:**  
Uses timer to trigger ADC with automatic preempted channel insertion for priority sampling.

---

## CAN Examples

### CAN Communication Mode

**Path:** `project/at_start_f403a/examples/can/communication_mode/`

**Description:**  
Basic CAN communication with transmit and receive functionality. Transmits a message every 1 second and blinks LED4. On receive, blinks LED2 (ID 0x400) or LED3 (other IDs).

**Hardware Setup:**
- CAN TX → PB9
- CAN RX → PB8
- Requires CAN transceiver

**Application Note:** AN0095

**Important Errata Workarounds:**
- ⚠️ **ES0002 1.1.2.1:** CAN reception failure during retransmission (requires mailbox priority configuration)
- ⚠️ **ES0002 1.1.2.2:** Manual bus-off recovery needed
- ⚠️ **ES0002 1.1.2.3:** Bit stuffing error recovery required

**Basic CAN Transmit:**

```c
void can_transmit_message(void)
{
  can_tx_message_type tx_message;
  
  /* Configure message */
  tx_message.standard_id = 0x400;
  tx_message.extended_id = 0;
  tx_message.id_type = CAN_ID_STANDARD;
  tx_message.frame_type = CAN_TFT_DATA;
  tx_message.dlc = 8;
  
  /* Fill data */
  for(uint8_t i = 0; i < 8; i++)
  {
    tx_message.data[i] = i + 0x10;
  }
  
  /* Transmit */
  can_message_transmit(CAN1, &tx_message);
}
```

**CAN Reception with Interrupt:**

```c
void CAN1_RX0_IRQHandler(void)
{
  can_rx_message_type rx_message;
  
  if(can_flag_get(CAN1, CAN_RF0MN_FLAG) != RESET)
  {
    can_message_receive(CAN1, CAN_RX_FIFO0, &rx_message);
    
    /* Only process data frames (workaround for ES0002 1.1.2.4) */
    if((rx_message.id_type == CAN_ID_STANDARD) && 
       (rx_message.frame_type == CAN_TFT_DATA))
    {
      if(rx_message.standard_id == 0x400)
      {
        at32_led_toggle(LED2);
      }
      else
      {
        at32_led_toggle(LED3);
      }
    }
  }
}
```

**CAN Bit Stuffing Error Recovery (ES0002 Workaround):**

```c
/* Enable CAN error interrupt with highest priority */
nvic_irq_enable(CAN1_SE_IRQn, 0x00, 0x00);
can_interrupt_enable(CAN1, CAN_ETRIEN_INT, TRUE);
can_interrupt_enable(CAN1, CAN_EOIEN_INT, TRUE);

void CAN1_SE_IRQHandler(void)
{
  __IO uint32_t err_index = 0;
  
  if(can_flag_get(CAN1, CAN_ETR_FLAG) != RESET)
  {
    err_index = CAN1->ests & 0x70;
    can_flag_clear(CAN1, CAN_ETR_FLAG);
    
    /* Check for bit stuffing error (error code 0x10) */
    if(err_index == 0x00000010)
    {
      can_reset(CAN1);
      can_initialization(); /* Re-initialize CAN peripheral */
    }
  }
}
```

---

### CAN Filter Configuration

**Path:** `project/at_start_f403a/examples/can/filter/`

**Description:**  
Demonstrates CAN filter configuration for selective message reception using identifier masks and lists.

**Filter Modes:**
- ID mask mode
- ID list mode
- 16-bit and 32-bit configurations

**Filter Configuration Example:**

```c
void can_filter_config(void)
{
  can_filter_init_type filter_init_struct;
  
  /* Configure filter 0 for specific ID */
  filter_init_struct.filter_activate_enable = TRUE;
  filter_init_struct.filter_mode = CAN_FILTER_MODE_ID_MASK;
  filter_init_struct.filter_fifo = CAN_FILTER_FIFO0;
  filter_init_struct.filter_number = 0;
  filter_init_struct.filter_bit = CAN_FILTER_32BIT;
  filter_init_struct.filter_id_high = (0x400 << 5);
  filter_init_struct.filter_id_low = 0;
  filter_init_struct.filter_mask_high = (0x7FF << 5); /* Match exact ID */
  filter_init_struct.filter_mask_low = 0;
  
  can_filter_init(CAN1, &filter_init_struct);
}
```

---

### CAN Loopback Mode

**Path:** `project/at_start_f403a/examples/can/loopback_mode/`

**Description:**  
Self-test mode where transmitted messages are received internally without external CAN bus connection.

**Use Cases:**
- Hardware testing
- Software validation
- No external transceiver required

---

## Flash Memory Examples

### Flash Write and Read

**Path:** `project/at_start_f403a/examples/flash/flash_write_read/`

**Description:**  
Demonstrates Flash memory write and read operations with data verification.

**Test Parameters:**
- Test buffer size: 3000 half-words
- Test address: 0x08000000 + 10KB offset
- LEDs indicate success (all 3 LEDs on)

**Important Errata:**
- ⚠️ **ES0002 1.1.12.1:** sLib must be in Zero-Wait (ZW) area
- ⚠️ **ES0002 1.1.12.2:** Disable interrupts during NZW erase
- ⚠️ **ES0002 1.1.12.3:** SPIM erase requires interrupt protection
- ⚠️ **ES0002 1.1.12.4:** Buffer UID/F_SIZE registers at startup

**Flash Write Function:**

```c
#define TEST_BUFFER_SIZE                 3000
#define TEST_FLASH_ADDRESS_START         (0x08000000 + 1024 * 10)

uint16_t buffer_write[TEST_BUFFER_SIZE];
uint16_t buffer_read[TEST_BUFFER_SIZE];

int main(void)
{
  uint32_t index = 0;
  error_status err_status;
  
  system_clock_config();
  at32_board_init();
  
  /* Fill buffer with test data */
  for(index = 0; index < TEST_BUFFER_SIZE; index++)
  {
    buffer_write[index] = index;
  }

  /* Write data to flash */
  err_status = flash_write(TEST_FLASH_ADDRESS_START, buffer_write, TEST_BUFFER_SIZE);

  /* Read data from flash */
  flash_read(TEST_FLASH_ADDRESS_START, buffer_read, TEST_BUFFER_SIZE);

  /* Compare buffers */
  if((buffer_compare(buffer_write, buffer_read, TEST_BUFFER_SIZE) == SUCCESS) 
     && (err_status == SUCCESS))
  {
    at32_led_on(LED2);
    at32_led_on(LED3);
    at32_led_on(LED4);
  }

  while(1) { }
}
```

**Safe Flash Erase with Interrupt Protection (ES0002 Workaround):**

```c
error_status flash_erase_safe(uint32_t address)
{
  error_status status;
  
  /* Disable interrupts to prevent NZW area access during erase */
  __disable_irq();
  
  /* Unlock flash */
  flash_unlock();
  
  /* Erase sector */
  status = flash_sector_erase(address);
  
  /* Wait for completion */
  while(flash_flag_get(FLASH_OBF_FLAG) != RESET);
  
  /* Lock flash */
  flash_lock();
  
  /* Re-enable interrupts */
  __enable_irq();
  
  return status;
}
```

**UID/F_SIZE Register Buffering (ES0002 Workaround):**

```c
/* Global buffers for UID and Flash size */
uint32_t uid_buf[3] = {0};
uint32_t fsize = 0;

void system_init(void)
{
  /* Read UID and F_SIZE during initialization */
  uid_buf[0] = *(uint32_t*)0x1FFFF7E8;
  uid_buf[1] = *(uint32_t*)0x1FFFF7EC;
  uid_buf[2] = *(uint32_t*)0x1FFFF7F0;
  fsize = *(uint32_t*)0x1FFFF7E0;

  /* Use uid_buf[] and fsize throughout program
     instead of reading registers directly */
}
```

---

### Flash SPIM (SPI Flash) Operations

**Path:** `project/at_start_f403a/examples/flash/operate_spim/`

**Description:**  
Demonstrates operations on external SPI Flash memory through SPIM interface.

**Features:**
- External Flash read/write
- SPIM mode configuration
- Memory mapping

---

### Flash Run in SPIM Mode

**Path:** `project/at_start_f403a/examples/flash/run_in_spim/`

**Description:**  
Executes code directly from external SPIM Flash memory.

**Use Case:**
- Expanding code space beyond internal Flash
- XIP (Execute In Place) from external memory

---

## PWC Power Control Examples

### PWC Deepsleep with RTC Wakeup

**Path:** `project/at_start_f403a/examples/pwc/deepsleep_rtc/`

**Description:**  
Demonstrates entering Deepsleep mode and waking up using RTC alarm.

**Important Errata:**
- ⚠️ **ES0002 1.1.6.1:** Remove AHB frequency division before Deepsleep
- ⚠️ **ES0002 1.1.6.2:** Disable Systick before Deepsleep
- ⚠️ **ES0002 1.1.6.3:** Ensure WFI completes atomically
- ⚠️ **ES0002 1.1.7.1:** Set CLKOUT to NOCLK before Deepsleep

**Correct Deepsleep Entry (with Errata Workarounds):**

```c
void enter_deepsleep_safe(void)
{
  /* Workaround for ES0002 1.1.6.1: Remove AHB division */
  crm_ahb_div_set(CRM_AHB_DIV_1);
  
  /* Workaround for ES0002 1.1.6.2: Disable Systick */
  systick_clock_source_config(SYSTICK_CLOCK_SOURCE_AHBCLK_DIV8);
  SysTick->CTRL &= ~SysTick_CTRL_ENABLE_Msk;
  
  /* Workaround for ES0002 1.1.7.1: Set CLKOUT to NOCLK */
  crm_clock_out_set(CRM_CLKOUT_NOCLK);
  
  /* Configure wakeup source (RTC alarm) */
  rtc_alarm_config();
  exint_line17_config();  /* RTC alarm uses EXINT line 17 */
  
  /* Enable PWC clock */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
  
  /* Enter Deepsleep mode */
  pwc_deep_sleep_mode_enter(PWC_DEEP_SLEEP_ENTER_WFI);
  
  /* After wakeup: Restore system configuration */
  system_clock_config();
}
```

**RTC Wakeup Configuration:**

```c
void rtc_alarm_wakeup_config(uint32_t seconds)
{
  /* Enable PWC and BPR clocks */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
  
  /* Allow access to BPR domain */
  pwc_battery_powered_domain_access(TRUE);
  
  /* Configure RTC */
  rtc_wait_config_finish();
  rtc_divider_set(32767);  /* 32.768kHz crystal */
  rtc_wait_config_finish();
  
  /* Set alarm */
  uint32_t current_counter = rtc_counter_get();
  rtc_alarm_set(current_counter + seconds);
  rtc_wait_config_finish();
  
  /* Enable RTC alarm interrupt */
  rtc_interrupt_enable(RTC_TA_INT, TRUE);
  
  /* Configure EXINT line 17 for RTC alarm */
  exint_init_type exint_init_struct;
  exint_init_struct.line_enable = TRUE;
  exint_init_struct.line_mode = EXINT_LINE_INTERRUPUT;
  exint_init_struct.line_select = EXINT_LINE_17;
  exint_init_struct.line_polarity = EXINT_TRIGGER_RISING_EDGE;
  exint_init(&exint_init_struct);
}
```

---

### PWC Standby with Wakeup Pin

**Path:** `project/at_start_f403a/examples/pwc/standby_wakeup_pin/`

**Description:**  
Demonstrates Standby mode (lowest power) with wakeup via external pin (PA0).

**Important Errata:**
- ⚠️ **ES0002 1.1.6.4:** Configure GPIO as pull-down input before enabling wakeup pin

**Correct Wakeup Pin Configuration (ES0002 Workaround):**

```c
void configure_wakeup_pin_safe(void)
{
  gpio_init_type gpio_init_struct;

  /* Enable GPIO clock */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);

  /* Set default parameters */
  gpio_default_para_init(&gpio_init_struct);

  /* Configure wakeup pin as input with pull-down */
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_0;  /* PA0 = Wakeup pin */
  gpio_init_struct.gpio_pull = GPIO_PULL_DOWN;  /* Important! */
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Enable PWC clock */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
  
  /* Enable wakeup pin PA0 */
  pwc_wakeup_pin_enable(PWC_WAKEUP_PIN_1, TRUE);
}

void enter_standby_mode(void)
{
  /* Clear standby flag */
  pwc_flag_clear(PWC_STANDBY_FLAG);
  
  /* Enter Standby mode */
  pwc_standby_mode_enter();
  
  /* Device will reset on wakeup */
}
```

---

### PWC Sleep Mode with USART Wakeup

**Path:** `project/at_start_f403a/examples/pwc/sleep_usart1/`

**Description:**  
Enters Sleep mode and wakes up on USART receive interrupt.

**Features:**
- Lower power than run mode
- Fastest wakeup response
- All peripherals remain active

---

### PWC Sleep Mode with Timer Wakeup

**Path:** `project/at_start_f403a/examples/pwc/sleep_tmr2/`

**Description:**  
Sleep mode with TMR2 interrupt wakeup.

---

### PWC Power Voltage Monitor

**Path:** `project/at_start_f403a/examples/pwc/power_voltage_monitor/`

**Description:**  
Monitors supply voltage using PWC voltage detector (PVD).

---

## Timer Examples

### TMR Basic Timer

**Path:** `project/at_start_f403a/examples/tmr/timer_base/`

**Description:**  
Basic timer configuration with interrupt for periodic events.

---

### TMR PWM Output

**Path:** `project/at_start_f403a/examples/tmr/pwm_output_tmr3/`

**Description:**  
Generates PWM signals with configurable frequency and duty cycle.

**PWM Configuration Example:**

```c
void tmr_pwm_config(void)
{
  crm_clocks_freq_type crm_clocks;
  tmr_output_config_type tmr_output_struct;
  
  /* Enable TMR3 clock */
  crm_periph_clock_enable(CRM_TMR3_PERIPH_CLOCK, TRUE);
  
  /* Get system clocks */
  crm_clocks_freq_get(&crm_clocks);
  
  /* Configure TMR3 for 1kHz PWM */
  tmr_base_init(TMR3, 999, (crm_clocks.apb1_freq * 2) / 1000 - 1);
  tmr_cnt_dir_set(TMR3, TMR_COUNT_UP);
  
  /* Configure PWM mode */
  tmr_output_default_para_init(&tmr_output_struct);
  tmr_output_struct.oc_mode = TMR_OUTPUT_CONTROL_PWM_MODE_A;
  tmr_output_struct.oc_output_state = TRUE;
  tmr_output_struct.oc_polarity = TMR_OUTPUT_ACTIVE_HIGH;
  tmr_output_struct.oc_idle_state = FALSE;
  
  /* Configure channel 1 (50% duty cycle) */
  tmr_output_channel_config(TMR3, TMR_SELECT_CHANNEL_1, &tmr_output_struct);
  tmr_channel_value_set(TMR3, TMR_SELECT_CHANNEL_1, 500);
  tmr_output_channel_buffer_enable(TMR3, TMR_SELECT_CHANNEL_1, TRUE);
  
  /* Enable counter */
  tmr_counter_enable(TMR3, TRUE);
}
```

---

### TMR Encoder Mode

**Path:** `project/at_start_f403a/examples/tmr/encoder_tmr2/`

**Description:**  
Encoder interface for incremental encoders (quadrature decoding).

**Important Errata:**
- ⚠️ **ES0002 1.1.4.1:** Encoder mode counter may skip or repeat values at boundaries
- **Workaround:** Use 32-bit timer mode or capture/compare overflow detection

**Encoder Configuration:**

```c
void tmr_encoder_config(void)
{
  tmr_input_config_type tmr_input_struct;
  
  /* Enable TMR2 clock */
  crm_periph_clock_enable(CRM_TMR2_PERIPH_CLOCK, TRUE);
  
  /* Configure encoder mode */
  tmr_encoder_mode_config(TMR2, 
                          TMR_ENCODER_MODE_AB,
                          TMR_INPUT_RISING_EDGE,
                          TMR_INPUT_RISING_EDGE);
  
  /* Set period to maximum */
  tmr_period_value_set(TMR2, 0xFFFF);
  
  /* Enable counter */
  tmr_counter_enable(TMR2, TRUE);
}
```

**32-Bit Encoder Mode (ES0002 Workaround):**

```c
void tmr_encoder_32bit_init(void)
{
  /* Use enhanced mode timer with 32-bit counter */
  tmr_32_bit_function_enable(TMR2, TRUE);

  /* Set period value to maximum 32-bit */
  tmr_period_value_set(TMR2, 0xFFFFFFFF);

  /* Set initial counter to PR/2 for bidirectional counting */
  tmr_counter_value_set(TMR2, 0x7FFFFFFF);

  /* Configure encoder mode */
  tmr_encoder_mode_config(TMR2, TMR_ENCODER_MODE_AB, 
                          TMR_INPUT_RISING_EDGE, TMR_INPUT_RISING_EDGE);
  
  /* Enable counter */
  tmr_counter_enable(TMR2, TRUE);
}
```

---

### TMR Input Capture

**Path:** `project/at_start_f403a/examples/tmr/input_capture/`

**Description:**  
Captures external signal timing using input capture channels.

**Applications:**
- Frequency measurement
- Pulse width measurement
- Signal period calculation

---

### TMR Complementary PWM with Dead Time

**Path:** `project/at_start_f403a/examples/tmr/complementary_signals/`

**Description:**  
Generates complementary PWM signals with dead-time insertion for motor control and power electronics.

**Features:**
- Complementary outputs (CHx and CHxN)
- Dead-time generator
- Break input protection

---

### TMR 6-Step Commutation

**Path:** `project/at_start_f403a/examples/tmr/6_steps/`

**Description:**  
Six-step commutation pattern for BLDC motor control.

---

### TMR 32-Bit Extended Counter

**Path:** `project/at_start_f403a/examples/tmr/tmr2_32bit/`

**Description:**  
Demonstrates TMR2's 32-bit mode for extended range timing.

---

### TMR One Cycle Mode

**Path:** `project/at_start_f403a/examples/tmr/one_cycle/`

**Description:**  
Single-shot timer mode that stops after one cycle.

---

### TMR DMA Burst Transfer

**Path:** `project/at_start_f403a/examples/tmr/dma_burst/`

**Description:**  
Uses DMA burst mode to update multiple timer registers efficiently.

---

## USART Examples

### USART Polling Mode

**Path:** `project/at_start_f403a/examples/usart/polling/`

**Description:**  
Basic USART transmit and receive using polling method.

**Simple USART Echo Example:**

```c
void usart_config(void)
{
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_USART1_PERIPH_CLOCK, TRUE);
  
  /* Configure USART1 TX (PA9) */
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_pins = GPIO_PINS_9;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure USART1 RX (PA10) */
  gpio_init_struct.gpio_pins = GPIO_PINS_10;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure USART */
  usart_init(USART1, 115200, USART_DATA_8BITS, USART_STOP_1_BIT);
  usart_parity_selection_config(USART1, USART_PARITY_NONE);
  usart_transmitter_enable(USART1, TRUE);
  usart_receiver_enable(USART1, TRUE);
  usart_enable(USART1, TRUE);
}

/* Echo received characters */
void usart_echo(void)
{
  uint16_t data;
  
  while(1)
  {
    /* Wait for data */
    while(usart_flag_get(USART1, USART_RDBF_FLAG) == RESET);
    
    /* Read received data */
    data = usart_data_receive(USART1);
    
    /* Echo back */
    while(usart_flag_get(USART1, USART_TDBE_FLAG) == RESET);
    usart_data_transmit(USART1, data);
  }
}
```

---

### USART Interrupt Mode

**Path:** `project/at_start_f403a/examples/usart/interrupt/`

**Description:**  
USART communication using interrupt-driven approach for better efficiency.

---

### USART DMA Mode

**Path:** `project/at_start_f403a/examples/usart/transfer_by_dma_interrupt/`

**Description:**  
High-speed USART transfers using DMA for both TX and RX.

---

### USART Printf Retargeting

**Path:** `project/at_start_f403a/examples/usart/printf/`

**Description:**  
Redirects printf() output to USART for easy debugging.

---

### USART RS485 Mode

**Path:** `project/at_start_f403a/examples/usart/rs485/`

**Description:**  
USART configured for RS485 half-duplex communication with automatic DE control.

---

### USART Hardware Flow Control

**Path:** `project/at_start_f403a/examples/usart/hw_flow_control/`

**Description:**  
Uses RTS/CTS hardware flow control for reliable high-speed communication.

---

### USART Synchronous Mode

**Path:** `project/at_start_f403a/examples/usart/synchronous/`

**Description:**  
USART in synchronous mode with clock output for SPI-like communication.

---

### USART Smart Card Mode

**Path:** `project/at_start_f403a/examples/usart/smartcard/`

**Description:**  
ISO 7816 Smart Card interface using USART Smart Card mode.

---

### USART IrDA Mode

**Path:** `project/at_start_f403a/examples/usart/irda/`

**Description:**  
Infrared communication using IrDA protocol.

---

### USART Half Duplex Mode

**Path:** `project/at_start_f403a/examples/usart/half_duplex/`

**Description:**  
Single-wire half-duplex communication.

---

### USART Idle Detection

**Path:** `project/at_start_f403a/examples/usart/idle_detection/`

**Description:**  
Detects idle line condition for frame-based protocols.

---

### USART Receiver Mute Mode

**Path:** `project/at_start_f403a/examples/usart/receiver_mute/`

**Description:**  
Mutes receiver for multi-drop network implementations.

---

## I2C Examples

### I2C Communication Polling

**Path:** `project/at_start_f403a/examples/i2c/communication_poll/`

**Description:**  
Basic I2C master/slave communication using polling method.

**Important Errata:**
- ⚠️ **ES0002 1.1.3.1:** I2C slave may not respond if APB clock ≤ 4MHz (for 400kHz I2C)
- **Workaround:** Ensure APB1 clock ≥ 8MHz or reduce I2C speed to 100kHz

**I2C Master Configuration:**

```c
void i2c_config(void)
{
  i2c_init_type i2c_init_struct;
  gpio_init_type gpio_init_struct;
  crm_clocks_freq_type crm_clocks;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_I2C1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  
  /* Verify APB1 clock for I2C slave (ES0002 1.1.3.1 workaround) */
  crm_clocks_freq_get(&crm_clocks);
  if(crm_clocks.apb1_freq <= 4000000)
  {
    /* APB clock too low for 400kHz I2C - use 100kHz instead */
  }
  
  /* Configure I2C pins (PB6=SCL, PB7=SDA) */
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_OPEN_DRAIN;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_pins = GPIO_PINS_6 | GPIO_PINS_7;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* Configure I2C */
  i2c_init_struct.mode = I2C_MODE_MASTER;
  i2c_init_struct.speed = I2C_SPEED_STANDARD;  /* 100kHz */
  i2c_init_struct.clock_speed = 100000;
  i2c_init_struct.duty_cycle = I2C_DUTYCYCLE_2;
  i2c_init_struct.own_address1 = 0x00;
  i2c_init_struct.bus_mode = I2C_BUSMODE_I2C;
  i2c_init_struct.address_mode = I2C_ADDRESS_MODE_7BIT;
  i2c_init(I2C1, &i2c_init_struct);
  
  i2c_enable(I2C1, TRUE);
}
```

**I2C Write Data:**

```c
error_status i2c_write(uint8_t slave_addr, uint8_t* data, uint16_t len)
{
  uint16_t i;
  
  /* Send START condition */
  i2c_start_generate(I2C1, TRUE);
  while(!i2c_flag_get(I2C1, I2C_STARTF_FLAG));
  
  /* Send slave address for write */
  i2c_7bit_address_send(I2C1, slave_addr << 1, I2C_DIRECTION_TRANSMIT);
  while(!i2c_flag_get(I2C1, I2C_ADDRF_FLAG));
  i2c_flag_clear(I2C1, I2C_ADDRF_FLAG);
  
  /* Send data */
  for(i = 0; i < len; i++)
  {
    while(!i2c_flag_get(I2C1, I2C_TDBE_FLAG));
    i2c_data_send(I2C1, data[i]);
  }
  
  /* Wait for transfer complete */
  while(!i2c_flag_get(I2C1, I2C_TDC_FLAG));
  
  /* Send STOP condition */
  i2c_stop_generate(I2C1, TRUE);
  
  return SUCCESS;
}
```

---

### I2C Communication Interrupt

**Path:** `project/at_start_f403a/examples/i2c/communication_int/`

**Description:**  
I2C communication using interrupt-driven approach.

---

### I2C Communication DMA

**Path:** `project/at_start_f403a/examples/i2c/communication_dma/`

**Description:**  
High-speed I2C transfers using DMA.

---

### I2C EEPROM Example

**Path:** `project/at_start_f403a/examples/i2c/eeprom/`

**Description:**  
Complete I2C EEPROM driver with page write and sequential read.

---

### I2C Memory Write

**Path:** `project/at_start_f403a/examples/i2c/memory_write/`

**Description:**  
Demonstrates I2C memory device access patterns.

---

## SPI Examples

### SPI Full Duplex Polling

**Path:** `project/at_start_f403a/examples/spi/fullduplex_polling/`

**Description:**  
Basic SPI master/slave communication in full-duplex mode using polling.

**SPI Master Configuration:**

```c
void spi_config(void)
{
  spi_init_type spi_init_struct;
  gpio_init_type gpio_init_struct;
  
  /* Enable clocks */
  crm_periph_clock_enable(CRM_SPI1_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  
  /* Configure SPI pins */
  /* SCK (PA5), MOSI (PA7) */
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_pins = GPIO_PINS_5 | GPIO_PINS_7;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* MISO (PA6) */
  gpio_init_struct.gpio_pins = GPIO_PINS_6;
  gpio_init(GPIOA, &gpio_init_struct);
  
  /* Configure SPI */
  spi_default_para_init(&spi_init_struct);
  spi_init_struct.transmission_mode = SPI_TRANSMIT_FULL_DUPLEX;
  spi_init_struct.master_slave_mode = SPI_MODE_MASTER;
  spi_init_struct.mclk_freq_division = SPI_MCLK_DIV_8;
  spi_init_struct.first_bit_transmission = SPI_FIRST_BIT_MSB;
  spi_init_struct.frame_bit_num = SPI_FRAME_8BIT;
  spi_init_struct.clock_polarity = SPI_CLOCK_POLARITY_LOW;
  spi_init_struct.clock_phase = SPI_CLOCK_PHASE_1EDGE;
  spi_init_struct.cs_mode_selection = SPI_CS_SOFTWARE_MODE;
  
  spi_init(SPI1, &spi_init_struct);
  spi_enable(SPI1, TRUE);
}
```

**Important Errata:**
- ⚠️ **ES0002 1.1.1.1:** SPI slave CS synchronization issue
- **Workaround:** Use CRC checking or software CS control

**SPI Slave with CRC (ES0002 Workaround):**

```c
void spi_slave_init_with_crc(void)
{
  spi_init_type spi_init_struct;

  /* Configure SPI slave mode */
  spi_default_para_init(&spi_init_struct);
  spi_init_struct.transmission_mode = SPI_TRANSMIT_FULL_DUPLEX;
  spi_init_struct.master_slave_mode = SPI_MODE_SLAVE;
  spi_init_struct.mclk_freq_division = SPI_MCLK_DIV_8;
  spi_init_struct.first_bit_transmission = SPI_FIRST_BIT_MSB;
  spi_init_struct.frame_bit_num = SPI_FRAME_8BIT;
  spi_init_struct.clock_polarity = SPI_CLOCK_POLARITY_LOW;
  spi_init_struct.clock_phase = SPI_CLOCK_PHASE_1EDGE;
  spi_init_struct.cs_mode_selection = SPI_CS_HARDWARE_MODE;

  spi_init(SPI2, &spi_init_struct);

  /* Enable CRC calculation to detect errors */
  spi_crc_enable(SPI2, TRUE);

  spi_enable(SPI2, TRUE);
}
```

---

### SPI Half Duplex

**Path:** `project/at_start_f403a/examples/spi/halfduplex_interrupt/`

**Description:**  
SPI in half-duplex mode with bidirectional data line.

---

### SPI DMA Transfer

**Path:** `project/at_start_f403a/examples/spi/fullduplex_dma_jtagpin/`

**Description:**  
High-speed SPI transfers using DMA on JTAG pins (PA15, PB3, PB4).

---

### SPI W25Q Flash Memory

**Path:** `project/at_start_f403a/examples/spi/w25q_flash/`

**Description:**  
Complete driver for W25Q series SPI Flash memory.

**Features:**
- Read, write, erase operations
- Sector and block erase
- Status register handling
- Write protection

---

### SPI CRC Transfer

**Path:** `project/at_start_f403a/examples/spi/crc_transfer_polling/`

**Description:**  
SPI communication with CRC error detection.

---

### SPI Receive Only Mode

**Path:** `project/at_start_f403a/examples/spi/only_receive_mode_polling/`

**Description:**  
SPI configured for receive-only operation.

---

## USB Device Examples

### USB Virtual COM Port (VCP)

**Path:** `project/at_start_f403a/examples/usb_device/virtual_comport/`

**Description:**  
USB CDC (Communication Device Class) for virtual serial port functionality.

**Features:**
- Appears as COM port on PC
- Standard baud rate configuration
- Compatible with terminal programs

**Important Errata:**
- ⚠️ **ES0002 1.1.8.1:** USB HUB broadcast - APB1 clock must be ≤ 48MHz
- ⚠️ **ES0002 1.1.8.2:** USB IN transfer - use endpoints 2, 6, 12, or 14 only

**USB Endpoint Configuration (ES0002 Workaround):**

```c
void usb_endpoint_config(void)
{
  /* Use only endpoint numbers 2, 6, 12, or 14 for IN transfers */
  usb_endpoint_init(USB_EPT2, USB_EPT_TYPE_BULK, USB_EPT_IN, 64);
  usb_endpoint_init(USB_EPT6, USB_EPT_TYPE_INTERRUPT, USB_EPT_IN, 64);
  
  /* Avoid other endpoint numbers for IN transfers */
}
```

**USB HUB Compatible Initialization (ES0002 Workaround):**

```c
void usb_init_hub_compatible(void)
{
  /* Configure APB1 clock to 48MHz or below */
  crm_apb1_div_set(CRM_APB1_DIV_2); /* Set APB1 = SYSCLK / 2 */

  /* Verify APB1 clock frequency */
  crm_clocks_freq_type crm_clocks;
  crm_clocks_freq_get(&crm_clocks);
  if(crm_clocks.apb1_freq > 48000000)
  {
    /* Adjust divider further if needed */
    crm_apb1_div_set(CRM_APB1_DIV_4);
  }

  /* Initialize USB peripheral */
  usb_init();
}
```

---

### USB Mass Storage (MSC)

**Path:** `project/at_start_f403a/examples/usb_device/msc/`

**Description:**  
USB Mass Storage Class for SD card or Flash storage access.

**Features:**
- Appears as removable disk drive
- SCSI command support
- Compatible with all operating systems

---

### USB HID Keyboard

**Path:** `project/at_start_f403a/examples/usb_device/keyboard/`

**Description:**  
USB HID (Human Interface Device) keyboard implementation.

---

### USB HID Mouse

**Path:** `project/at_start_f403a/examples/usb_device/mouse/`

**Description:**  
USB HID mouse with button and movement reporting.

---

### USB Custom HID

**Path:** `project/at_start_f403a/examples/usb_device/custom_hid/`

**Description:**  
Custom HID device for bidirectional data transfer.

---

### USB Composite VCP + MSC

**Path:** `project/at_start_f403a/examples/usb_device/composite_vcp_msc/`

**Description:**  
Composite device with both Virtual COM Port and Mass Storage.

---

### USB Composite VCP + Keyboard

**Path:** `project/at_start_f403a/examples/usb_device/composite_vcp_keyboard/`

**Description:**  
Composite device with Virtual COM Port and Keyboard functionality.

---

### USB Audio Device

**Path:** `project/at_start_f403a/examples/usb_device/audio/`

**Description:**  
USB Audio Class for audio streaming.

---

### USB Composite Audio + HID

**Path:** `project/at_start_f403a/examples/usb_device/composite_audio_hid/`

**Description:**  
Composite Audio and HID device.

---

### USB Printer Class

**Path:** `project/at_start_f403a/examples/usb_device/printer/`

**Description:**  
USB Printer Class implementation.

---

### USB WinUSB

**Path:** `project/at_start_f403a/examples/usb_device/winusb/`

**Description:**  
WinUSB device for driver-less communication on Windows.

---

### USB VCP Loopback

**Path:** `project/at_start_f403a/examples/usb_device/vcp_loopback/`

**Description:**  
Virtual COM Port with loopback test functionality.

---

### USB Virtual MSC IAP (In-Application Programming)

**Path:** `project/at_start_f403a/examples/usb_device/virtual_msc_iap/`

**Description:**  
Firmware update via USB Mass Storage interface.

---

## GPIO Examples

### GPIO LED Toggle

**Path:** `project/at_start_f403a/examples/gpio/led_toggle/`

**Description:**  
Basic GPIO output control for LED blinking.

---

### GPIO I/O Toggle

**Path:** `project/at_start_f403a/examples/gpio/io_toggle/`

**Description:**  
High-speed GPIO toggle demonstration.

---

### GPIO SWJTAG Remap

**Path:** `project/at_start_f403a/examples/gpio/swjtag_remap/`

**Description:**  
Remapping JTAG/SWD pins for GPIO usage.

**Important:** Disabling debug pins requires special recovery procedures!

---

## DMA Examples

### DMA Flash to SRAM

**Path:** `project/at_start_f403a/examples/dma/flash_to_sram/`

**Description:**  
DMA transfer from Flash memory to SRAM.

---

### DMA Data to GPIO (Flexible)

**Path:** `project/at_start_f403a/examples/dma/data_to_gpio_flexible/`

**Description:**  
DMA flexible transfer for GPIO port manipulation.

---

## Additional Peripheral Examples

### DAC Examples

**Paths:**
- `dac/one_dac_noisewave` - Noise wave generation
- `dac/one_dac_dma_escalator` - DMA-driven waveform
- `dac/two_dac_trianglewave` - Dual DAC triangle wave
- `dac/double_mode_dma_sinewave` - Sine wave generation
- `dac/double_mode_dma_squarewave` - Square wave generation

---

### RTC Examples

**Paths:**
- `rtc/calendar` - RTC calendar functionality
- `rtc/lick_calibration` - Internal RC calibration

**Important Errata:**
- ⚠️ **ES0002 1.1.9.1:** RTC counter may be off by one
- **Workaround:** Set divider before programming counter

**Correct RTC Initialization (ES0002 Workaround):**

```c
void rtc_config(void)
{
  /* Enable clocks */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_BPR_PERIPH_CLOCK, TRUE);
  
  /* Allow access to BPR domain */
  pwc_battery_powered_domain_access(TRUE);
  
  /* Wait for configuration */
  rtc_wait_config_finish();
  
  /* Set divider FIRST (workaround for ES0002 1.1.9.1) */
  rtc_divider_set(32767);  /* For 32.768kHz crystal */
  
  rtc_wait_config_finish();
  
  /* THEN set counter value */
  rtc_counter_set(0);
  
  rtc_wait_config_finish();
}
```

---

### EXINT Examples

**Paths:**
- `exint/exint_config` - External interrupt configuration
- `exint/exint_software_trigger` - Software trigger

**Important Errata:**
- ⚠️ **ES0002 1.1.10.1:** Software trigger generates double interrupt
- **Workaround:** Clear flag twice for software trigger

**EXINT Flag Clear (ES0002 Workaround):**

```c
void exint_flag_clear_safe(uint32_t exint_line)
{
  if((EXINT->swtrg & exint_line) == exint_line)
  {
    /* Software trigger - clear flag TWICE */
    EXINT->intsts = exint_line;
    EXINT->intsts = exint_line;
  }
  else
  {
    /* Hardware trigger - clear once */
    EXINT->intsts = exint_line;
  }
}
```

---

### WWDT Example

**Path:** `wdt/wwdt_reset`

**Description:**  
Window Watchdog Timer with interrupt.

**Important Errata:**
- ⚠️ **ES0002 1.1.11.1:** RLDF flag cannot be cleared unless watchdog is fed first

**Correct WWDT Interrupt Handler (ES0002 Workaround):**

```c
void WWDT_IRQHandler(void)
{
  /* Feed watchdog FIRST */
  wwdt_counter_set(127);
  
  /* THEN clear RLDF flag */
  wwdt_flag_clear();
  
  /* Add other interrupt handling logic */
}
```

---

### WDT Example

**Paths:**
- `wdt/wdt_reset` - Independent watchdog reset
- `wdt/wdt_standby` - WDT in standby mode

---

### CRC Example

**Path:** `crc/calculation`

**Description:**  
Hardware CRC calculation engine.

---

### BPR (Backup Register) Examples

**Paths:**
- `bpr/bpr_data` - Backup data registers
- `bpr/tamper` - Tamper detection

---

### SDIO Examples

**Paths:**
- `sdio/sd_mmc_card` - SD/MMC card interface
- `sdio/emmc_card` - eMMC interface
- `sdio/sdio_fatfs` - FAT file system on SD card

---

### XMC (External Memory Controller) Examples

**Paths:**
- `xmc/nand/nand` - NAND Flash interface
- `xmc/nand/ecc` - NAND with ECC
- `xmc/psram` - PSRAM interface
- `xmc/lcd_8bit` - 8-bit LCD interface
- `xmc/lcd_touch_16bit` - 16-bit LCD with touch

---

### I2S Examples

**Paths:**
- `i2s/fullduplex_dma` - Full duplex I2S with DMA
- `i2s/halfduplex_dma` - Half duplex I2S
- `i2s/halfduplex_interrupt` - I2S with interrupts
- `i2s/spii2s_switch_halfduplex_polling` - SPI/I2S mode switching

**Important Errata:**
- ⚠️ **ES0002 1.1.5.x:** I2S has 5 known issues (all fixed in Revision B)

---

### Cortex-M4 Examples

**Paths:**
- `cortex_m4/bit_band` - Bit-banding demonstration
- `cortex_m4/systick_interrupt` - SysTick timer
- `cortex_m4/fpu` - Floating Point Unit usage
- `cortex_m4/cmsis_dsp` - CMSIS-DSP library examples

---

### CRM (Clock and Reset Management) Examples

**Paths:**
- `crm/sysclk_switch` - System clock switching
- `crm/clock_failure_detection` - Clock security system

---

### Debug Example

**Path:** `debug/tmr1`

**Description:**  
MCU debug features with timer freeze on halt.

---

### ACC (Auto Calibration Clock) Example

**Path:** `acc/calibration`

**Description:**  
Automatic clock calibration using external reference.

---

## 📊 Example Statistics

### By Peripheral

| Peripheral | Example Count | Description |
|------------|---------------|-------------|
| **TMR** | 25 | PWM, encoder, input capture, complementary output |
| **USART** | 13 | Polling, interrupt, DMA, RS485, SmartCard, IrDA |
| **USB Device** | 13 | VCP, MSC, HID, Audio, Composite |
| **SPI** | 8 | Full/half duplex, W25Q Flash, CRC |
| **ADC** | 9 | Single, dual, triple, DMA, temperature sensor |
| **I2C** | 5 | Polling, interrupt, DMA, EEPROM |
| **CAN** | 3 | Communication, filter, loopback |
| **PWC** | 6 | Sleep, deepsleep, standby, voltage monitor |
| **Flash** | 3 | Write/read, SPIM operations |
| **GPIO** | 3 | LED toggle, I/O control, JTAG remap |
| **DAC** | 5 | Noise, triangle, sine, square waves |
| **I2S** | 4 | Full/half duplex with DMA |
| **XMC** | 5 | NAND, PSRAM, LCD interfaces |
| **DMA** | 2 | Flash to SRAM, data to GPIO |
| **RTC** | 2 | Calendar, calibration |
| **EXINT** | 2 | Configuration, software trigger |
| **Others** | 15+ | SDIO, WDT, WWDT, CRC, BPR, Debug, etc. |

### Total File Count

- **C source files (.c):** ~700+
- **Header files (.h):** ~700+
- **Documentation (.txt):** ~125
- **Total:** 1,985 files

---

## 🔗 Related Documentation

- **[Errata Sheet](ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md)** - All 41 device limitations with workarounds
- **[FAQ](FAQ.md)** - Frequently asked questions
- **[README](README.md)** - Repository overview
- **[Firmware Library README](AT32F403A_407_Firmware_Library/README_CONTEXT7.md)** - Library structure

---

## 📝 Using These Examples

### Getting Started

1. **Select the appropriate example** for your peripheral
2. **Check the errata sheet** for known issues
3. **Read the readme.txt** in the example directory
4. **Examine main.c** for initialization and main loop
5. **Check configuration headers** for peripheral settings
6. **Apply errata workarounds** if applicable

### Common Include Files

All examples use these standard includes:

```c
#include "at32f403a_407_board.h"      /* Board support functions */
#include "at32f403a_407_clock.h"      /* Clock configuration */
#include "at32f403a_407_conf.h"       /* Peripheral configuration */
#include "at32f403a_407_int.h"        /* Interrupt handlers */
```

### Standard Initialization Pattern

```c
int main(void)
{
  /* Initialize system */
  system_clock_config();
  at32_board_init();
  
  /* Configure peripherals */
  peripheral_config();
  
  /* Main loop */
  while(1)
  {
    /* Application code */
  }
}
```

---

## ⚠️ Important Errata Reminders

When using these examples, remember these critical device limitations:

1. **Flash (ES0002 1.1.12.x):**
   - Disable interrupts during NZW erase
   - Buffer UID/F_SIZE at startup
   - Place sLib in ZW area only

2. **CAN (ES0002 1.1.2.x):**
   - Implement reception failure workaround
   - Handle bit stuffing errors
   - Configure proper baudrate for noise immunity

3. **PWC (ES0002 1.1.6.x):**
   - Remove AHB division before deepsleep
   - Disable Systick before deepsleep
   - Configure wakeup pin as pull-down

4. **ADC (ES0002 1.1.5.2):**
   - Enable ADC2 before ADC1 calibration in dual mode

5. **USB (ES0002 1.1.8.x):**
   - APB1 ≤ 48MHz for HUB compatibility
   - Use only endpoints 2, 6, 12, 14 for IN transfers

6. **I2C (ES0002 1.1.3.1):**
   - APB1 ≥ 8MHz for 400kHz slave mode

7. **SPI (ES0002 1.1.1.1):**
   - Use CRC for slave CS synchronization

8. **TMR Encoder (ES0002 1.1.4.1):**
   - Use 32-bit mode or overflow detection

9. **RTC (ES0002 1.1.9.1):**
   - Set divider before counter

10. **EXINT (ES0002 1.1.10.1):**
    - Clear flag twice for software trigger

11. **WWDT (ES0002 1.1.11.1):**
    - Feed watchdog before clearing RLDF

---

## 📚 Application Notes Referenced

- **AN0095** - CAN Application
- **AN0112** - ADC Application and Temperature Sensor

---

**Last Updated:** November 2024  
**Library Version:** v2.2.1  
**Total Examples:** 1,985 files  
**Context7 Optimized:** ✅

---

**For detailed peripheral register information, see the AT32F403A/407 Reference Manual.**  
**For electrical specifications, see the AT32F403A/407 Datasheet.**  
**For device limitations and workarounds, see the ES0002 Errata Sheet.**

