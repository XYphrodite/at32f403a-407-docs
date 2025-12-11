# CAN - Controller Area Network

## Overview

The **Controller Area Network (CAN)** peripheral provides a robust serial communication protocol designed for automotive and industrial applications. The AT32F403A/407 features two independent CAN controllers (CAN1, CAN2) that comply with the CAN 2.0A and CAN 2.0B specifications.

| Feature | Specification |
|---------|---------------|
| **CAN Controllers** | CAN1, CAN2 |
| **Protocol** | CAN 2.0A (11-bit ID), CAN 2.0B (29-bit ID) |
| **Max Baudrate** | 1 Mbps |
| **TX Mailboxes** | 3 per controller |
| **RX FIFOs** | 2 per controller (3 messages each) |
| **Filters** | 14 configurable filters |
| **Operating Modes** | Normal, Loopback, Listen-only, Doze |

---

## Key Features

- **Dual CAN controllers** operating independently
- **3 transmit mailboxes** with configurable priority
- **2 receive FIFOs** with 3-message depth each
- **14 configurable filters** (mask or list mode)
- **Standard (11-bit)** and **Extended (29-bit)** identifiers
- **Automatic retransmission** on error
- **Automatic bus-off recovery**
- **Time-triggered communication** (TTC) mode
- **Doze mode** for power saving
- **Error handling** with detailed status

---

## Baudrate Calculation

The CAN baudrate is calculated using:

```
Baudrate = PCLK / (baudrate_div × (1 + BTS1 + BTS2))
```

Where:
- **PCLK** = Peripheral clock frequency
- **baudrate_div** = Baudrate prescaler (1-4096)
- **BTS1** = Bit Time Segment 1 (1-16 TQ)
- **BTS2** = Bit Time Segment 2 (1-8 TQ)

### Common Baudrate Settings (PCLK = 120 MHz)

| Baudrate | DIV | BTS1 | BTS2 | Sample Point |
|----------|-----|------|------|--------------|
| 1 Mbps | 10 | 8 TQ | 3 TQ | 75% |
| 500 kbps | 20 | 8 TQ | 3 TQ | 75% |
| 250 kbps | 40 | 8 TQ | 3 TQ | 75% |
| 125 kbps | 80 | 8 TQ | 3 TQ | 75% |
| 100 kbps | 100 | 8 TQ | 3 TQ | 75% |

> **Important:** CAN protocol requires oscillator tolerance ≤1.58%. Use HEXT (external crystal) as clock source, not HICK (internal RC oscillator).

---

## Operating Modes

### Mode Selection

```c
typedef enum
{
  CAN_MODE_COMMUNICATE           = 0x00, /* Normal communication */
  CAN_MODE_LOOPBACK              = 0x01, /* Internal loopback */
  CAN_MODE_LISTENONLY            = 0x02, /* Listen only (no TX) */
  CAN_MODE_LISTENONLY_LOOPBACK   = 0x03  /* Combined listen-only + loopback */
} can_mode_type;
```

### Operating Mode States

```c
typedef enum
{
  CAN_OPERATINGMODE_FREEZE       = 0x00, /* Freeze mode (configuration) */
  CAN_OPERATINGMODE_DOZE         = 0x01, /* Low power mode */
  CAN_OPERATINGMODE_COMMUNICATE  = 0x02  /* Normal operation */
} can_operating_mode_type;
```

---

## Bit Timing Configuration

### Resynchronization Adjust Width (RSAW)

```c
typedef enum
{
  CAN_RSAW_1TQ = 0x00,  /* 1 time quantum */
  CAN_RSAW_2TQ = 0x01,  /* 2 time quantum */
  CAN_RSAW_3TQ = 0x02,  /* 3 time quantum */
  CAN_RSAW_4TQ = 0x03   /* 4 time quantum */
} can_rsaw_type;
```

### Bit Time Segment 1 (BTS1)

```c
typedef enum
{
  CAN_BTS1_1TQ  = 0x00,  CAN_BTS1_2TQ  = 0x01,  CAN_BTS1_3TQ  = 0x02,
  CAN_BTS1_4TQ  = 0x03,  CAN_BTS1_5TQ  = 0x04,  CAN_BTS1_6TQ  = 0x05,
  CAN_BTS1_7TQ  = 0x06,  CAN_BTS1_8TQ  = 0x07,  CAN_BTS1_9TQ  = 0x08,
  CAN_BTS1_10TQ = 0x09,  CAN_BTS1_11TQ = 0x0A,  CAN_BTS1_12TQ = 0x0B,
  CAN_BTS1_13TQ = 0x0C,  CAN_BTS1_14TQ = 0x0D,  CAN_BTS1_15TQ = 0x0E,
  CAN_BTS1_16TQ = 0x0F
} can_bts1_type;
```

### Bit Time Segment 2 (BTS2)

```c
typedef enum
{
  CAN_BTS2_1TQ = 0x00,  CAN_BTS2_2TQ = 0x01,  CAN_BTS2_3TQ = 0x02,
  CAN_BTS2_4TQ = 0x03,  CAN_BTS2_5TQ = 0x04,  CAN_BTS2_6TQ = 0x05,
  CAN_BTS2_7TQ = 0x06,  CAN_BTS2_8TQ = 0x07
} can_bts2_type;
```

---

## Filter Configuration

### Filter Modes

```c
typedef enum
{
  CAN_FILTER_MODE_ID_MASK = 0x00, /* Identifier/Mask mode */
  CAN_FILTER_MODE_ID_LIST = 0x01  /* Identifier List mode */
} can_filter_mode_type;
```

### Filter Bit Width

```c
typedef enum
{
  CAN_FILTER_16BIT = 0x00, /* Two 16-bit filters */
  CAN_FILTER_32BIT = 0x01  /* One 32-bit filter */
} can_filter_bit_width_type;
```

### Filter FIFO Assignment

```c
typedef enum
{
  CAN_FILTER_FIFO0 = 0x00, /* Route to FIFO 0 */
  CAN_FILTER_FIFO1 = 0x01  /* Route to FIFO 1 */
} can_filter_fifo_type;
```

### Filter Configuration Structure

```c
typedef struct
{
  confirm_state filter_activate_enable;  /* Enable/disable filter */
  can_filter_mode_type filter_mode;      /* Mask or List mode */
  can_filter_fifo_type filter_fifo;      /* FIFO0 or FIFO1 */
  uint8_t filter_number;                 /* Filter number (0-13) */
  can_filter_bit_width_type filter_bit;  /* 16-bit or 32-bit */
  uint16_t filter_id_high;               /* ID high word */
  uint16_t filter_id_low;                /* ID low word */
  uint16_t filter_mask_high;             /* Mask/ID2 high word */
  uint16_t filter_mask_low;              /* Mask/ID2 low word */
} can_filter_init_type;
```

### Filter ID Encoding

**32-bit Filter (Extended ID):**
```c
filter_id_high = ((EXT_ID << 3) >> 16) & 0xFFFF;
filter_id_low  = ((EXT_ID << 3) & 0xFFFF) | 0x04;  /* 0x04 = IDE bit */
```

**32-bit Filter (Standard ID):**
```c
filter_id_high = STD_ID << 5;
filter_id_low  = 0;
```

**16-bit Filter (Standard ID):**
```c
filter_id_low = (STD_ID << 5) | (RTR << 4);
```

---

## Message Structures

### TX Message

```c
typedef struct
{
  uint32_t standard_id;           /* 11-bit standard ID (0-0x7FF) */
  uint32_t extended_id;           /* 29-bit extended ID (0-0x1FFFFFFF) */
  can_identifier_type id_type;    /* CAN_ID_STANDARD or CAN_ID_EXTENDED */
  can_trans_frame_type frame_type;/* CAN_TFT_DATA or CAN_TFT_REMOTE */
  uint8_t dlc;                    /* Data length (0-8) */
  uint8_t data[8];                /* Data bytes */
} can_tx_message_type;
```

### RX Message

```c
typedef struct
{
  uint32_t standard_id;           /* Received standard ID */
  uint32_t extended_id;           /* Received extended ID */
  can_identifier_type id_type;    /* ID type of received message */
  can_trans_frame_type frame_type;/* Frame type of received message */
  uint8_t dlc;                    /* Received data length */
  uint8_t data[8];                /* Received data bytes */
  uint8_t filter_index;           /* Which filter matched (0-13) */
} can_rx_message_type;
```

---

## Flags and Interrupts

### Status Flags

```c
#define CAN_EAF_FLAG       0x01  /* Error Active flag */
#define CAN_EPF_FLAG       0x02  /* Error Passive flag */
#define CAN_BOF_FLAG       0x03  /* Bus-Off flag */
#define CAN_ETR_FLAG       0x04  /* Error Type Record flag */
#define CAN_EOIF_FLAG      0x05  /* Error Occur Interrupt flag */
#define CAN_TM0TCF_FLAG    0x06  /* TX Mailbox 0 Complete flag */
#define CAN_TM1TCF_FLAG    0x07  /* TX Mailbox 1 Complete flag */
#define CAN_TM2TCF_FLAG    0x08  /* TX Mailbox 2 Complete flag */
#define CAN_RF0MN_FLAG     0x09  /* RX FIFO 0 Message Number flag */
#define CAN_RF0FF_FLAG     0x0A  /* RX FIFO 0 Full flag */
#define CAN_RF0OF_FLAG     0x0B  /* RX FIFO 0 Overflow flag */
#define CAN_RF1MN_FLAG     0x0C  /* RX FIFO 1 Message Number flag */
#define CAN_RF1FF_FLAG     0x0D  /* RX FIFO 1 Full flag */
#define CAN_RF1OF_FLAG     0x0E  /* RX FIFO 1 Overflow flag */
#define CAN_QDZIF_FLAG     0x0F  /* Quit Doze Interrupt flag */
#define CAN_EDZC_FLAG      0x10  /* Enter Doze Confirm flag */
#define CAN_TMEF_FLAG      0x11  /* TX Mailbox Empty flag */
```

### Interrupt Sources

```c
#define CAN_TCIEN_INT      0x00000001  /* TX Complete interrupt */
#define CAN_RF0MIEN_INT    0x00000002  /* RX FIFO 0 Message interrupt */
#define CAN_RF0FIEN_INT    0x00000004  /* RX FIFO 0 Full interrupt */
#define CAN_RF0OIEN_INT    0x00000008  /* RX FIFO 0 Overflow interrupt */
#define CAN_RF1MIEN_INT    0x00000010  /* RX FIFO 1 Message interrupt */
#define CAN_RF1FIEN_INT    0x00000020  /* RX FIFO 1 Full interrupt */
#define CAN_RF1OIEN_INT    0x00000040  /* RX FIFO 1 Overflow interrupt */
#define CAN_EAIEN_INT      0x00000100  /* Error Active interrupt */
#define CAN_EPIEN_INT      0x00000200  /* Error Passive interrupt */
#define CAN_BOIEN_INT      0x00000400  /* Bus-Off interrupt */
#define CAN_ETRIEN_INT     0x00000800  /* Error Type Record interrupt */
#define CAN_EOIEN_INT      0x00008000  /* Error Occur interrupt */
#define CAN_QDZIEN_INT     0x00010000  /* Quit Doze interrupt */
#define CAN_EDZIEN_INT     0x00020000  /* Enter Doze interrupt */
```

---

## Error Types

```c
typedef enum
{
  CAN_ERRORRECORD_NOERR           = 0x00, /* No error */
  CAN_ERRORRECORD_STUFFERR        = 0x01, /* Bit stuffing error */
  CAN_ERRORRECORD_FORMERR         = 0x02, /* Form error */
  CAN_ERRORRECORD_ACKERR          = 0x03, /* Acknowledgment error */
  CAN_ERRORRECORD_BITRECESSIVEERR = 0x04, /* Bit recessive error */
  CAN_ERRORRECORD_BITDOMINANTERR  = 0x05, /* Bit dominant error */
  CAN_ERRORRECORD_CRCERR          = 0x06, /* CRC error */
  CAN_ERRORRECORD_SOFTWARESETERR  = 0x07  /* Software set error */
} can_error_record_type;
```

---

## API Reference

### Initialization Functions

#### can_reset

Reset CAN peripheral to default state.

```c
void can_reset(can_type* can_x);
```

#### can_default_para_init

Initialize CAN base configuration structure with defaults.

```c
void can_default_para_init(can_base_type* can_base_struct);
```

**Default values:**
- `mode_selection` = `CAN_MODE_COMMUNICATE`
- `ttc_enable` = `FALSE`
- `aebo_enable` = `FALSE`
- `aed_enable` = `FALSE`
- `prsf_enable` = `FALSE`
- `mdrsel_selection` = `CAN_DISCARDING_FIRST_RECEIVED`
- `mmssr_selection` = `CAN_SENDING_BY_ID`

#### can_base_init

Initialize CAN base configuration.

```c
error_status can_base_init(can_type* can_x, can_base_type* can_base_struct);
```

**Returns:** `SUCCESS` or `ERROR`

#### can_baudrate_default_para_init

Initialize baudrate structure with defaults.

```c
void can_baudrate_default_para_init(can_baudrate_type* can_baudrate_struct);
```

**Default values:**
- `baudrate_div` = 1
- `rsaw_size` = `CAN_RSAW_2TQ`
- `bts1_size` = `CAN_BTS1_4TQ`
- `bts2_size` = `CAN_BTS2_3TQ`

#### can_baudrate_set

Set CAN baudrate.

```c
error_status can_baudrate_set(can_type* can_x, can_baudrate_type* can_baudrate_struct);
```

**Returns:** `SUCCESS` or `ERROR`

---

### Filter Functions

#### can_filter_default_para_init

Initialize filter structure with defaults.

```c
void can_filter_default_para_init(can_filter_init_type* can_filter_init_struct);
```

#### can_filter_init

Configure a CAN filter.

```c
void can_filter_init(can_type* can_x, can_filter_init_type* can_filter_init_struct);
```

---

### Transmission Functions

#### can_message_transmit

Transmit a CAN message.

```c
uint8_t can_message_transmit(can_type* can_x, can_tx_message_type* tx_message_struct);
```

**Returns:** Mailbox number used (0-2) or `CAN_TX_STATUS_NO_EMPTY`

#### can_transmit_status_get

Get transmission status of a mailbox.

```c
can_transmit_status_type can_transmit_status_get(can_type* can_x, can_tx_mailbox_num_type transmit_mailbox);
```

**Returns:**
- `CAN_TX_STATUS_SUCCESSFUL`
- `CAN_TX_STATUS_FAILED`
- `CAN_TX_STATUS_PENDING`

#### can_transmit_cancel

Cancel a pending transmission.

```c
void can_transmit_cancel(can_type* can_x, can_tx_mailbox_num_type transmit_mailbox);
```

---

### Reception Functions

#### can_message_receive

Receive a CAN message from FIFO.

```c
void can_message_receive(can_type* can_x, can_rx_fifo_num_type fifo_number, can_rx_message_type* rx_message_struct);
```

#### can_receive_message_pending_get

Get number of pending messages in FIFO.

```c
uint8_t can_receive_message_pending_get(can_type* can_x, can_rx_fifo_num_type fifo_number);
```

#### can_receive_fifo_release

Release a FIFO entry.

```c
void can_receive_fifo_release(can_type* can_x, can_rx_fifo_num_type fifo_number);
```

---

### Mode Control Functions

#### can_operating_mode_set

Set operating mode.

```c
error_status can_operating_mode_set(can_type* can_x, can_operating_mode_type can_operating_mode);
```

#### can_doze_mode_enter

Enter low-power doze mode.

```c
can_enter_doze_status_type can_doze_mode_enter(can_type* can_x);
```

#### can_doze_mode_exit

Exit doze mode.

```c
can_quit_doze_status_type can_doze_mode_exit(can_type* can_x);
```

---

### Error Handling Functions

#### can_error_type_record_get

Get the last error type.

```c
can_error_record_type can_error_type_record_get(can_type* can_x);
```

#### can_receive_error_counter_get

Get receive error counter.

```c
uint8_t can_receive_error_counter_get(can_type* can_x);
```

#### can_transmit_error_counter_get

Get transmit error counter.

```c
uint8_t can_transmit_error_counter_get(can_type* can_x);
```

---

### Interrupt and Flag Functions

#### can_interrupt_enable

Enable or disable CAN interrupts.

```c
void can_interrupt_enable(can_type* can_x, uint32_t can_int, confirm_state new_state);
```

#### can_flag_get

Get flag status.

```c
flag_status can_flag_get(can_type* can_x, uint32_t can_flag);
```

#### can_interrupt_flag_get

Get interrupt flag status (checks interrupt enable).

```c
flag_status can_interrupt_flag_get(can_type* can_x, uint32_t can_flag);
```

#### can_flag_clear

Clear a flag.

```c
void can_flag_clear(can_type* can_x, uint32_t can_flag);
```

---

## Usage Examples

### Example 1: Loopback Mode (Self-Test)

Test CAN functionality without external hardware.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

static void can_gpio_config(void)
{
  gpio_init_type gpio_init_struct;

  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
  gpio_pin_remap_config(CAN1_GMUX_0010, TRUE);

  gpio_default_para_init(&gpio_init_struct);
  
  /* CAN TX: PB9 */
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pins = GPIO_PINS_9;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init(GPIOB, &gpio_init_struct);
  
  /* CAN RX: PB8 */
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init_struct.gpio_pins = GPIO_PINS_8;
  gpio_init_struct.gpio_pull = GPIO_PULL_UP;
  gpio_init(GPIOB, &gpio_init_struct);
}

error_status can_configuration(void)
{
  can_base_type can_base_struct;
  can_baudrate_type can_baudrate_struct;
  can_filter_init_type can_filter_init_struct;

  /* Check HEXT is stable (required for CAN) */
  if (crm_flag_get(CRM_HEXT_STABLE_FLAG) != SET)
  {
    return ERROR;
  }

  crm_periph_clock_enable(CRM_CAN1_PERIPH_CLOCK, TRUE);

  /* CAN base configuration */
  can_default_para_init(&can_base_struct);
  can_base_struct.mode_selection = CAN_MODE_LOOPBACK;  /* Loopback mode */
  can_base_struct.ttc_enable = FALSE;
  can_base_struct.aebo_enable = TRUE;   /* Auto exit bus-off */
  can_base_struct.aed_enable = TRUE;    /* Auto exit doze */
  can_base_struct.prsf_enable = FALSE;
  can_base_struct.mdrsel_selection = CAN_DISCARDING_FIRST_RECEIVED;
  can_base_struct.mmssr_selection = CAN_SENDING_BY_ID;
  can_base_init(CAN1, &can_base_struct);

  /* Baudrate: PCLK / (10 × (1 + 8 + 3)) = PCLK / 120 */
  can_baudrate_struct.baudrate_div = 10;
  can_baudrate_struct.rsaw_size = CAN_RSAW_3TQ;
  can_baudrate_struct.bts1_size = CAN_BTS1_8TQ;
  can_baudrate_struct.bts2_size = CAN_BTS2_3TQ;
  if (can_baudrate_set(CAN1, &can_baudrate_struct) != SUCCESS)
  {
    return ERROR;
  }

  /* Filter: Accept all messages */
  can_filter_init_struct.filter_activate_enable = TRUE;
  can_filter_init_struct.filter_mode = CAN_FILTER_MODE_ID_MASK;
  can_filter_init_struct.filter_fifo = CAN_FILTER_FIFO0;
  can_filter_init_struct.filter_number = 0;
  can_filter_init_struct.filter_bit = CAN_FILTER_32BIT;
  can_filter_init_struct.filter_id_high = 0;
  can_filter_init_struct.filter_id_low = 0;
  can_filter_init_struct.filter_mask_high = 0;  /* 0 = don't care */
  can_filter_init_struct.filter_mask_low = 0;
  can_filter_init(CAN1, &can_filter_init_struct);

  /* Enable RX FIFO 0 interrupt */
  nvic_irq_enable(USBFS_L_CAN1_RX0_IRQn, 0, 0);
  can_interrupt_enable(CAN1, CAN_RF0MIEN_INT, TRUE);

  return SUCCESS;
}

void can_transmit_data(void)
{
  uint8_t transmit_mailbox;
  can_tx_message_type tx_message_struct;

  tx_message_struct.standard_id = 0x400;
  tx_message_struct.extended_id = 0;
  tx_message_struct.id_type = CAN_ID_STANDARD;
  tx_message_struct.frame_type = CAN_TFT_DATA;
  tx_message_struct.dlc = 8;
  tx_message_struct.data[0] = 0x11;
  tx_message_struct.data[1] = 0x22;
  tx_message_struct.data[2] = 0x33;
  tx_message_struct.data[3] = 0x44;
  tx_message_struct.data[4] = 0x55;
  tx_message_struct.data[5] = 0x66;
  tx_message_struct.data[6] = 0x77;
  tx_message_struct.data[7] = 0x88;

  transmit_mailbox = can_message_transmit(CAN1, &tx_message_struct);
  
  /* Wait for transmission complete */
  while (can_transmit_status_get(CAN1, (can_tx_mailbox_num_type)transmit_mailbox) 
         != CAN_TX_STATUS_SUCCESSFUL);
}

void USBFS_L_CAN1_RX0_IRQHandler(void)
{
  can_rx_message_type rx_message_struct;
  
  if (can_interrupt_flag_get(CAN1, CAN_RF0MN_FLAG) != RESET)
  {
    can_message_receive(CAN1, CAN_RX_FIFO0, &rx_message_struct);
    
    if (rx_message_struct.standard_id == 0x400)
    {
      at32_led_toggle(LED2);  /* Message received successfully */
    }
  }
}

int main(void)
{
  system_clock_config();
  at32_board_init();
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
  
  can_gpio_config();
  
  if (can_configuration() == ERROR)
  {
    while (1) { }  /* Clock error */
  }

  while (1)
  {
    can_transmit_data();
    at32_led_toggle(LED4);
    delay_sec(1);
  }
}
```

---

### Example 2: Filter Configuration (ID List Mode)

Configure filters to accept specific IDs only.

```c
#define FILTER_EXT_ID1  ((uint32_t)0x18F5F100)
#define FILTER_EXT_ID2  ((uint32_t)0x18F5F200)
#define FILTER_STD_ID1  ((uint16_t)0x04F6)
#define FILTER_STD_ID2  ((uint16_t)0x04F7)

error_status can_filter_configuration(void)
{
  can_filter_init_type can_filter_init_struct;

  /* Filter 0: Extended ID List (accepts EXT_ID1 and EXT_ID2) */
  can_filter_init_struct.filter_activate_enable = TRUE;
  can_filter_init_struct.filter_mode = CAN_FILTER_MODE_ID_LIST;
  can_filter_init_struct.filter_fifo = CAN_FILTER_FIFO0;
  can_filter_init_struct.filter_number = 0;
  can_filter_init_struct.filter_bit = CAN_FILTER_32BIT;
  
  /* Extended ID encoding: shift left 3 bits, set IDE bit */
  can_filter_init_struct.filter_id_high = ((FILTER_EXT_ID1 << 3) >> 16) & 0xFFFF;
  can_filter_init_struct.filter_id_low = ((FILTER_EXT_ID1 << 3) & 0xFFFF) | 0x04;
  can_filter_init_struct.filter_mask_high = ((FILTER_EXT_ID2 << 3) >> 16) & 0xFFFF;
  can_filter_init_struct.filter_mask_low = ((FILTER_EXT_ID2 << 3) & 0xFFFF) | 0x04;
  can_filter_init(CAN1, &can_filter_init_struct);

  /* Filter 1: Standard ID List (accepts STD_ID1 and STD_ID2) */
  can_filter_init_struct.filter_activate_enable = TRUE;
  can_filter_init_struct.filter_mode = CAN_FILTER_MODE_ID_LIST;
  can_filter_init_struct.filter_fifo = CAN_FILTER_FIFO0;
  can_filter_init_struct.filter_number = 1;
  can_filter_init_struct.filter_bit = CAN_FILTER_32BIT;
  
  /* Standard ID encoding: shift left 5 bits */
  can_filter_init_struct.filter_id_high = FILTER_STD_ID1 << 5;
  can_filter_init_struct.filter_id_low = 0;
  can_filter_init_struct.filter_mask_high = FILTER_STD_ID2 << 5;
  can_filter_init_struct.filter_mask_low = 0;
  can_filter_init(CAN1, &can_filter_init_struct);

  return SUCCESS;
}
```

---

### Example 3: Communication Mode (Two Nodes)

Normal communication between two CAN nodes.

```c
error_status can_communication_configuration(void)
{
  can_base_type can_base_struct;
  can_baudrate_type can_baudrate_struct;
  can_filter_init_type can_filter_init_struct;

  if (crm_flag_get(CRM_HEXT_STABLE_FLAG) != SET)
  {
    return ERROR;
  }

  crm_periph_clock_enable(CRM_CAN1_PERIPH_CLOCK, TRUE);

  /* Communication mode (not loopback) */
  can_default_para_init(&can_base_struct);
  can_base_struct.mode_selection = CAN_MODE_COMMUNICATE;
  can_base_struct.aebo_enable = TRUE;
  can_base_struct.aed_enable = TRUE;
  can_base_init(CAN1, &can_base_struct);

  /* Baudrate: 500 kbps @ 120 MHz PCLK */
  can_baudrate_struct.baudrate_div = 20;
  can_baudrate_struct.rsaw_size = CAN_RSAW_3TQ;
  can_baudrate_struct.bts1_size = CAN_BTS1_8TQ;
  can_baudrate_struct.bts2_size = CAN_BTS2_3TQ;
  if (can_baudrate_set(CAN1, &can_baudrate_struct) != SUCCESS)
  {
    return ERROR;
  }

  /* Accept all messages */
  can_filter_init_struct.filter_activate_enable = TRUE;
  can_filter_init_struct.filter_mode = CAN_FILTER_MODE_ID_MASK;
  can_filter_init_struct.filter_fifo = CAN_FILTER_FIFO0;
  can_filter_init_struct.filter_number = 0;
  can_filter_init_struct.filter_bit = CAN_FILTER_32BIT;
  can_filter_init_struct.filter_id_high = 0;
  can_filter_init_struct.filter_id_low = 0;
  can_filter_init_struct.filter_mask_high = 0;
  can_filter_init_struct.filter_mask_low = 0;
  can_filter_init(CAN1, &can_filter_init_struct);

  /* Enable interrupts */
  nvic_irq_enable(CAN1_SE_IRQn, 0, 0);
  nvic_irq_enable(USBFS_L_CAN1_RX0_IRQn, 0, 0);
  can_interrupt_enable(CAN1, CAN_RF0MIEN_INT, TRUE);
  can_interrupt_enable(CAN1, CAN_ETRIEN_INT, TRUE);
  can_interrupt_enable(CAN1, CAN_EOIEN_INT, TRUE);

  return SUCCESS;
}
```

---

### Example 4: Error Handling

Handle CAN errors in interrupt.

```c
void CAN1_SE_IRQHandler(void)
{
  __IO uint32_t err_index = 0;
  
  if (can_interrupt_flag_get(CAN1, CAN_ETR_FLAG) != RESET)
  {
    err_index = CAN1->ests & 0x70;  /* Get error type bits */
    can_flag_clear(CAN1, CAN_ETR_FLAG);

    switch (err_index >> 4)
    {
      case 0x01:  /* Stuff error */
        /* Restart CAN or send high-priority message */
        break;
      case 0x02:  /* Form error */
        break;
      case 0x03:  /* ACK error */
        break;
      case 0x04:  /* Bit recessive error */
        break;
      case 0x05:  /* Bit dominant error */
        break;
      case 0x06:  /* CRC error */
        break;
      default:
        break;
    }
  }
  
  /* Check for bus-off */
  if (can_flag_get(CAN1, CAN_BOF_FLAG) == SET)
  {
    /* Bus-off recovery is automatic if aebo_enable = TRUE */
  }
}
```

---

## Hardware Configuration

### GPIO Pin Mapping

| CAN | TX Pin | RX Pin | Remap |
|-----|--------|--------|-------|
| CAN1 | PA12 | PA11 | Default |
| CAN1 | PB9 | PB8 | CAN1_GMUX_0010 |
| CAN1 | PD1 | PD0 | CAN1_GMUX_0011 |
| CAN2 | PB13 | PB12 | Default |
| CAN2 | PB6 | PB5 | CAN2_GMUX_0001 |

### CAN Transceiver Connection

```
MCU                     Transceiver              CAN Bus
TX (PB9) ───────────► TXD ──────────────────► CANH
RX (PB8) ◄─────────── RXD ◄──────────────────┤ CANL
                                              │
                                         120Ω termination
```

**Required:**
- CAN transceiver IC (e.g., TJA1050, MCP2551)
- 120Ω termination resistor at each end of bus
- Proper ground connection

---

## NVIC Interrupt Mapping

| IRQ Handler | CAN1 | CAN2 | Description |
|-------------|------|------|-------------|
| USBFS_L_CAN1_RX0 | ✓ | - | RX FIFO 0 |
| CAN1_RX1 | ✓ | - | RX FIFO 1 |
| CAN1_SE | ✓ | - | Status/Error |
| CAN1_TX | ✓ | - | TX Complete |
| CAN2_RX0 | - | ✓ | RX FIFO 0 |
| CAN2_RX1 | - | ✓ | RX FIFO 1 |
| CAN2_SE | - | ✓ | Status/Error |
| CAN2_TX | - | ✓ | TX Complete |

---

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| TX always fails | No ACK from receiver | Check transceiver, termination, another node |
| No RX messages | Filter rejects all | Set mask to 0 (accept all) for testing |
| Bus-off state | Too many errors | Check wiring, baudrate match, termination |
| ACK errors | Baudrate mismatch | Ensure all nodes use same baudrate |
| Stuff errors | Signal integrity | Check cable length, shielding, termination |
| Clock error on init | HICK used | Use HEXT (external crystal) for CAN |

---

## Important Notes

1. **Clock Source:** Always use HEXT for CAN applications. HICK accuracy (±1.5%) exceeds CAN tolerance (±1.58%).

2. **Filter Configuration:** Must be done in freeze mode. The driver handles this automatically.

3. **Termination:** 120Ω termination required at both ends of CAN bus.

4. **Bus-Off Recovery:** Enable `aebo_enable` for automatic recovery, or handle manually.

5. **Message Priority:** Lower ID = higher priority. Use `mmssr_selection` to control TX priority.

---

## See Also

- [GPIO - General Purpose I/O](GPIO_General_Purpose_IO.md)
- [CRM - Clock and Reset Management](CRM_Clock_Reset_Management.md)
- [NVIC - Nested Vectored Interrupt Controller](NVIC_Interrupt_Controller.md)

---

## File References

| File | Description |
|------|-------------|
| `at32f403a_407_can.h` | CAN driver header |
| `at32f403a_407_can.c` | CAN driver implementation |
| `examples/can/loopback_mode/` | Loopback self-test example |
| `examples/can/filter/` | Filter configuration example |
| `examples/can/communication_mode/` | Normal communication example |

