# USB Device (Universal Serial Bus) - AT32F403A/407

## Overview

The AT32F403A/407 microcontroller features a **USB Full-Speed Device Controller** (USBFS) that supports the USB 2.0 Full-Speed specification (12 Mbps). The USB peripheral provides a flexible framework for implementing various USB device classes including CDC (Virtual COM Port), HID (Human Interface Device), MSC (Mass Storage Class), Audio, Printer, and custom devices.

## Key Features

- **USB 2.0 Full-Speed** compliant (12 Mbps)
- **8 Bidirectional Endpoints** (EP0-EP7)
- **Dedicated Packet Buffer Memory**: 512 bytes (expandable to 768-1280 bytes)
- **Transfer Types**: Control, Bulk, Interrupt, Isochronous
- **Double Buffering** support for bulk and isochronous endpoints
- **Suspend/Resume** with remote wakeup support
- **Low-Power Mode** with wakeup capability
- **Internal 1.5kΩ Pull-up** on D+ line (software controlled)
- **48 MHz Clock Sources**: HEXT (with divider) or HICK (with ACC calibration)
- **Shared Interrupt** with CAN1 (USBFS_L_CAN1_RX0_IRQn)

## Supported USB Device Classes

| Class | Description | Example |
|-------|-------------|---------|
| **CDC** | Communications Device Class | Virtual COM Port (VCP) |
| **HID** | Human Interface Device | Mouse, Keyboard, Custom HID |
| **MSC** | Mass Storage Class | USB Flash Drive |
| **Audio** | Audio Device Class | USB Speaker/Microphone |
| **Printer** | Printer Class | USB Printer |
| **WinUSB** | Microsoft WinUSB | Custom bulk device |
| **Composite** | Multiple classes | VCP + MSC, VCP + Keyboard, Audio + HID |

---

## Hardware Configuration

### USB Pins

| Pin | Function | Description |
|-----|----------|-------------|
| PA11 | USB_DM | USB Data Minus (D-) |
| PA12 | USB_DP | USB Data Plus (D+) |

> **Note**: No external components required for USB D+/D- lines. The internal 1.5kΩ pull-up resistor is controlled by software.

---

## Register Structure

### USB Register Map

```c
/**
 * @brief USB Device register structure
 */
typedef struct
{
  /* Endpoint Registers (0x00 - 0x1C) */
  union {
    __IO uint32_t ept[8];           /* Endpoint 0-7 registers */
    struct {
      __IO uint32_t eptaddr    : 4;  /* [3:0]   Endpoint address */
      __IO uint32_t txsts      : 2;  /* [5:4]   TX status */
      __IO uint32_t txdts      : 1;  /* [6]     TX data toggle */
      __IO uint32_t txtc       : 1;  /* [7]     TX transfer complete */
      __IO uint32_t exf        : 1;  /* [8]     Extended function (double buffer) */
      __IO uint32_t trans_type : 2;  /* [10:9]  Transfer type */
      __IO uint32_t setuptc    : 1;  /* [11]    Setup transaction complete */
      __IO uint32_t rxsts      : 2;  /* [13:12] RX status */
      __IO uint32_t rxdts      : 1;  /* [14]    RX data toggle */
      __IO uint32_t rxtc       : 1;  /* [15]    RX transfer complete */
      __IO uint32_t reserved1  : 16; /* [31:16] Reserved */
    } ept_bit[8];
  };

  __IO uint32_t reserved1[8];        /* 0x20 - 0x3C Reserved */

  /* Control Register (0x40) */
  union {
    __IO uint32_t ctrl;
    struct {
      __IO uint32_t csrst    : 1;    /* [0]  Core software reset */
      __IO uint32_t disusb   : 1;    /* [1]  Disable USB PHY */
      __IO uint32_t lpm      : 1;    /* [2]  Low power mode */
      __IO uint32_t ssp      : 1;    /* [3]  Suspend set pending */
      __IO uint32_t gresume  : 1;    /* [4]  Generate resume */
      __IO uint32_t reserved1: 3;    /* [7:5] Reserved */
      __IO uint32_t lsofien  : 1;    /* [8]  Lost SOF interrupt enable */
      __IO uint32_t sofien   : 1;    /* [9]  SOF interrupt enable */
      __IO uint32_t rstien   : 1;    /* [10] Reset interrupt enable */
      __IO uint32_t spien    : 1;    /* [11] Suspend interrupt enable */
      __IO uint32_t wkien    : 1;    /* [12] Wakeup interrupt enable */
      __IO uint32_t beien    : 1;    /* [13] Bus error interrupt enable */
      __IO uint32_t ucforien : 1;    /* [14] Core FIFO overrun interrupt enable */
      __IO uint32_t tcien    : 1;    /* [15] Transfer complete interrupt enable */
      __IO uint32_t reserved2: 16;   /* [31:16] Reserved */
    } ctrl_bit;
  };

  /* Interrupt Status Register (0x44) */
  union {
    __IO uint32_t intsts;
    struct {
      __IO uint32_t ept_num   : 4;   /* [3:0]  Endpoint number */
      __IO uint32_t inout     : 1;   /* [4]    IN/OUT transaction */
      __IO uint32_t reserved1 : 3;   /* [7:5]  Reserved */
      __IO uint32_t lsof      : 1;   /* [8]    Lost SOF */
      __IO uint32_t sof       : 1;   /* [9]    Start of frame */
      __IO uint32_t rst       : 1;   /* [10]   Reset */
      __IO uint32_t sp        : 1;   /* [11]   Suspend */
      __IO uint32_t wk        : 1;   /* [12]   Wakeup */
      __IO uint32_t be        : 1;   /* [13]   Bus error */
      __IO uint32_t ucfor     : 1;   /* [14]   Core FIFO overrun */
      __IO uint32_t tc        : 1;   /* [15]   Transfer complete */
      __IO uint32_t reserved2 : 16;  /* [31:16] Reserved */
    } intsts_bit;
  };

  /* Frame Number Register (0x48) */
  union {
    __IO uint32_t sofrnum;
    struct {
      __IO uint32_t sofnum    : 11;  /* [10:0] SOF frame number */
      __IO uint32_t lsofnum   : 2;   /* [12:11] Lost SOF number */
      __IO uint32_t clck      : 1;   /* [13]   Clock locked */
      __IO uint32_t dmsts     : 1;   /* [14]   D- status */
      __IO uint32_t dpsts     : 1;   /* [15]   D+ status */
      __IO uint32_t reserved1 : 16;  /* [31:16] Reserved */
    } sofrnum_bit;
  };

  /* Device Address Register (0x4C) */
  union {
    __IO uint32_t devaddr;
    struct {
      __IO uint32_t addr      : 7;   /* [6:0]  Device address */
      __IO uint32_t cen       : 1;   /* [7]    Configuration enable */
      __IO uint32_t reserved1 : 24;  /* [31:8] Reserved */
    } devaddr_bit;
  };

  /* Buffer Table Register (0x50) */
  union {
    __IO uint32_t buftbl;
    struct {
      __IO uint32_t reserved1 : 3;   /* [2:0]  Reserved */
      __IO uint32_t btaddr    : 13;  /* [15:3] Buffer table address */
      __IO uint32_t reserved2 : 16;  /* [31:16] Reserved */
    } buftbl_bit;
  };

  __IO uint32_t reserved2[3];        /* 0x54 - 0x5C Reserved */

  /* Configuration Register (0x60) */
  union {
    __IO uint32_t cfg;
    struct {
      __IO uint32_t sofouten  : 1;   /* [0]    SOF output enable */
      __IO uint32_t puo       : 1;   /* [1]    Pull-up disable */
      __IO uint32_t reserved1 : 30;  /* [31:2] Reserved */
    } cfg_bit;
  };

} usbd_type;

#define USB  ((usbd_type *)USBFS_BASE)
```

### Base Address

| Peripheral | Base Address |
|------------|--------------|
| USB | 0x40005C00 |

### Packet Buffer Memory

| Configuration | Address | Size |
|---------------|---------|------|
| Default | 0x40006000 | 512 bytes |
| Extended (USBBUFS=1) | 0x40007800 | 768-1280 bytes |

> **Note**: Extended buffer size depends on CAN1/CAN2 configuration:
> - Both CAN disabled: 1280 bytes
> - One CAN enabled: 1024 bytes
> - Both CAN enabled: 768 bytes

---

## Interrupts and Flags

### USB Interrupts

| Interrupt | Bit | Description |
|-----------|-----|-------------|
| USB_LSOF_INT | 8 | Lost SOF interrupt |
| USB_SOF_INT | 9 | Start of Frame interrupt |
| USB_RST_INT | 10 | USB Reset interrupt |
| USB_SP_INT | 11 | Suspend interrupt |
| USB_WK_INT | 12 | Wakeup interrupt |
| USB_BE_INT | 13 | Bus Error interrupt |
| USB_UCFOR_INT | 14 | Core FIFO Overrun interrupt |
| USB_TC_INT | 15 | Transfer Complete interrupt |

### USB Flags

| Flag | Bit | Description |
|------|-----|-------------|
| USB_EPT_NUM_FLAG | [3:0] | Current endpoint number |
| USB_INOUT_FLAG | 4 | IN/OUT transaction direction |
| USB_LSOF_FLAG | 8 | Lost SOF flag |
| USB_SOF_FLAG | 9 | SOF received flag |
| USB_RST_FLAG | 10 | USB Reset detected |
| USB_SP_FLAG | 11 | Suspend detected |
| USB_WK_FLAG | 12 | Wakeup detected |
| USB_BE_FLAG | 13 | Bus error detected |
| USB_UCFOR_FLAG | 14 | FIFO overrun detected |
| USB_TC_FLAG | 15 | Transfer completed |

---

## Configuration Types

### Endpoint Numbers

```c
typedef enum
{
  USB_EPT0 = 0x00,  /* Endpoint 0 (Control) */
  USB_EPT1 = 0x01,  /* Endpoint 1 */
  USB_EPT2 = 0x02,  /* Endpoint 2 */
  USB_EPT3 = 0x03,  /* Endpoint 3 */
  USB_EPT4 = 0x04,  /* Endpoint 4 */
  USB_EPT5 = 0x05,  /* Endpoint 5 */
  USB_EPT6 = 0x06,  /* Endpoint 6 */
  USB_EPT7 = 0x07   /* Endpoint 7 */
} usb_ept_number_type;
```

### Transfer Types

```c
typedef enum
{
  EPT_CONTROL_TYPE = 0x00,  /* Control transfer */
  EPT_ISO_TYPE     = 0x01,  /* Isochronous transfer */
  EPT_BULK_TYPE    = 0x02,  /* Bulk transfer */
  EPT_INT_TYPE     = 0x03   /* Interrupt transfer */
} ept_trans_type;
```

### Endpoint Direction

```c
typedef enum
{
  EPT_IN  = 0x00,  /* IN endpoint (device to host) */
  EPT_OUT = 0x01   /* OUT endpoint (host to device) */
} ept_inout_type;
```

### Data Transfer Direction

```c
typedef enum
{
  DATA_TRANS_OUT = 0x00,  /* OUT transaction */
  DATA_TRANS_IN  = 0x01   /* IN transaction */
} data_trans_dir;
```

### USB Clock Source

```c
typedef enum
{
  USB_CLK_HICK,  /* Internal high-speed clock (48 MHz HICK) */
  USB_CLK_HEXT   /* External high-speed clock (with divider) */
} usb_clk48_s;
```

### Endpoint TX/RX Status

| Status | TX Value | RX Value | Description |
|--------|----------|----------|-------------|
| DISABLE | 0x0000 | 0x0000 | Endpoint disabled |
| STALL | 0x0010 | 0x1000 | Endpoint stalled |
| NAK | 0x0020 | 0x2000 | Endpoint NAK response |
| VALID | 0x0030 | 0x3000 | Endpoint ready |

---

## Endpoint Information Structure

```c
typedef struct
{
  uint8_t  eptn;             /* Endpoint register number (0~7) */
  uint8_t  ept_address;      /* Endpoint address */
  uint8_t  inout;            /* Endpoint direction */
  uint8_t  trans_type;       /* Transfer type */
  uint16_t tx_addr;          /* TX buffer offset address */
  uint16_t rx_addr;          /* RX buffer offset address */
  uint16_t maxpacket;        /* Maximum packet size */
  uint8_t  is_double_buffer; /* Double buffer flag */
  uint8_t  stall;            /* Stall state */
  uint16_t status;           /* Endpoint status */
  uint16_t total_len;        /* Total transfer length */
  uint16_t trans_len;        /* Current transfer length */
  uint8_t  *trans_buf;       /* Transfer buffer pointer */
  uint16_t last_len;         /* Last transfer length */
  uint16_t rem0_len;         /* Remaining length */
  uint16_t ept0_slen;        /* EP0 total length */
} usb_ept_info;
```

---

## API Functions

### Core Functions

```c
/* Initialize USB peripheral */
void usb_dev_init(usbd_type *usbx);

/* Connect USB device (enable D+ pull-up) */
void usb_connect(usbd_type *usbx);

/* Disconnect USB device (disable D+ pull-up) */
void usb_disconnect(usbd_type *usbx);

/* Enable/disable extended buffer mode */
void usb_usbbufs_enable(usbd_type *usbx, confirm_state state);

/* Set USB device address */
void usb_set_address(usbd_type *usbx, uint8_t address);
```

### Endpoint Functions

```c
/* Open/configure endpoint */
void usb_ept_open(usbd_type *usbx, usb_ept_info *ept_info);

/* Close endpoint */
void usb_ept_close(usbd_type *usbx, usb_ept_info *ept_info);

/* Set endpoint to stall state */
void usb_ept_stall(usbd_type *usbx, usb_ept_info *ept_info);
```

### Data Transfer Functions

```c
/* Write data to USB packet buffer */
void usb_write_packet(uint8_t *pusr_buf, uint16_t offset_addr, uint16_t nbytes);

/* Read data from USB packet buffer */
void usb_read_packet(uint8_t *pusr_buf, uint16_t offset_addr, uint16_t nbytes);

/* Auto-allocate endpoint buffer */
uint16_t usb_buffer_malloc(uint16_t maxpacket);

/* Free endpoint buffer allocations */
void usb_buffer_free(void);
```

### Interrupt Functions

```c
/* Enable/disable USB interrupts */
void usb_interrupt_enable(usbd_type *usbx, uint16_t interrupt, confirm_state new_state);

/* Get USB flag status */
flag_status usb_flag_get(usbd_type *usbx, uint16_t flag);

/* Get USB interrupt flag status */
flag_status usb_interrupt_flag_get(usbd_type *usbx, uint16_t flag);

/* Clear USB flag */
void usb_flag_clear(usbd_type *usbx, uint16_t flag);
```

### Power Management Functions

```c
/* Enter suspend mode */
void usb_enter_suspend(usbd_type *usbx);

/* Exit suspend mode */
void usb_exit_suspend(usbd_type *usbx);

/* Set remote wakeup signal */
void usb_remote_wkup_set(usbd_type *usbx);

/* Clear remote wakeup signal */
void usb_remote_wkup_clear(usbd_type *usbx);
```

---

## USB Clock Configuration

### Using External Crystal (HEXT)

The USB requires a 48 MHz clock. When using HEXT, configure the USB clock divider based on system clock:

```c
void usb_clock48m_select(usb_clk48_s clk_s)
{
  if(clk_s == USB_CLK_HEXT)
  {
    switch(system_core_clock)
    {
      case 48000000:   /* 48 MHz */
        crm_usb_clock_div_set(CRM_USB_DIV_1);
        break;
      case 72000000:   /* 72 MHz */
        crm_usb_clock_div_set(CRM_USB_DIV_1_5);
        break;
      case 96000000:   /* 96 MHz */
        crm_usb_clock_div_set(CRM_USB_DIV_2);
        break;
      case 120000000:  /* 120 MHz */
        crm_usb_clock_div_set(CRM_USB_DIV_2_5);
        break;
      case 144000000:  /* 144 MHz */
        crm_usb_clock_div_set(CRM_USB_DIV_3);
        break;
      case 168000000:  /* 168 MHz */
        crm_usb_clock_div_set(CRM_USB_DIV_3_5);
        break;
      case 192000000:  /* 192 MHz */
        crm_usb_clock_div_set(CRM_USB_DIV_4);
        break;
    }
  }
}
```

### Using Internal RC (HICK) with ACC Calibration

```c
void usb_clock48m_select(usb_clk48_s clk_s)
{
  if(clk_s == USB_CLK_HICK)
  {
    /* Select HICK as USB clock source */
    crm_usb_clock_source_select(CRM_USB_CLOCK_SOURCE_HICK);

    /* Enable ACC peripheral clock */
    crm_periph_clock_enable(CRM_ACC_PERIPH_CLOCK, TRUE);

    /* Configure ACC calibration values */
    acc_write_c1(7980);   /* Lower threshold */
    acc_write_c2(8000);   /* Target value */
    acc_write_c3(8020);   /* Upper threshold */

    /* Enable ACC calibration with HICK trimming */
    acc_calibration_mode_enable(ACC_CAL_HICKTRIM, TRUE);
  }
}
```

---

## USB Device Initialization

### Basic USB Device Setup

```c
usbd_core_type usb_core_dev;

int main(void)
{
  /* Configure NVIC priority group */
  nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);

  /* Configure system clock */
  system_clock_config();

  /* Select USB 48 MHz clock source */
  usb_clock48m_select(USB_CLK_HEXT);

  /* Enable USB peripheral clock */
  crm_periph_clock_enable(CRM_USB_PERIPH_CLOCK, TRUE);

  /* Enable USB interrupt */
  nvic_irq_enable(USBFS_L_CAN1_RX0_IRQn, 0, 0);

  /* Initialize USB core with class handler */
  usbd_core_init(&usb_core_dev, USB, &class_handler, &desc_handler, 0);

  /* Enable USB connection (D+ pull-up) */
  usbd_connect(&usb_core_dev);

  while(1)
  {
    /* Application code */
  }
}

/* USB interrupt handler */
void USBFS_L_CAN1_RX0_IRQHandler(void)
{
  usbd_irq_handler(&usb_core_dev);
}
```

---

## USB Device Classes

### CDC Virtual COM Port (VCP)

Implements USB-to-serial communication:

```c
#include "usbd_core.h"
#include "cdc_class.h"
#include "cdc_desc.h"
#include "usbd_int.h"

usbd_core_type usb_core_dev;
uint8_t usb_buffer[256];

int main(void)
{
  /* ... clock and NVIC configuration ... */

  /* Initialize USB as CDC device */
  usbd_core_init(&usb_core_dev, USB, &cdc_class_handler, &cdc_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    uint16_t data_len;

    /* Receive data from USB host */
    data_len = usb_vcp_get_rxdata(&usb_core_dev, usb_buffer);

    if(data_len > 0)
    {
      /* Process received data */
      /* ... */

      /* Send response back to host */
      usb_vcp_send_data(&usb_core_dev, usb_buffer, data_len);
    }
  }
}
```

### CDC with USART Bridge

```c
extern linecoding_type linecoding;

/* Configure USART based on USB line coding */
void usb_usart_config(linecoding_type linecoding)
{
  usart_stop_bit_num_type usart_stop_bit;
  usart_data_bit_num_type usart_data_bit;
  usart_parity_selection_type usart_parity_select;

  /* Map stop bits */
  switch(linecoding.format) {
    case 0x0: usart_stop_bit = USART_STOP_1_BIT; break;
    case 0x1: usart_stop_bit = USART_STOP_1_5_BIT; break;
    case 0x2: usart_stop_bit = USART_STOP_2_BIT; break;
  }

  /* Map parity */
  switch(linecoding.parity) {
    case 0x0: usart_parity_select = USART_PARITY_NONE; break;
    case 0x1: usart_parity_select = USART_PARITY_ODD; break;
    case 0x2: usart_parity_select = USART_PARITY_EVEN; break;
  }

  /* Configure USART */
  usart_init(USART2, linecoding.bitrate, usart_data_bit, usart_stop_bit);
  usart_parity_selection_config(USART2, usart_parity_select);
  usart_transmitter_enable(USART2, TRUE);
  usart_receiver_enable(USART2, TRUE);
  usart_enable(USART2, TRUE);
}
```

### HID Mouse

```c
#include "usbd_core.h"
#include "mouse_class.h"
#include "mouse_desc.h"
#include "usbd_int.h"

usbd_core_type usb_core_dev;

/* Mouse button definitions */
#define LEFT_BUTTON    0x01
#define RIGHT_BUTTON   0x02
#define MIDDLE_BUTTON  0x04
#define BUTTON_RELEASE 0x00

int main(void)
{
  /* ... initialization ... */

  usbd_core_init(&usb_core_dev, USB, &mouse_class_handler, &mouse_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    if(at32_button_press() == USER_BUTTON)
    {
      if(usbd_connect_state_get(&usb_core_dev) == USB_CONN_STATE_CONFIGURED)
      {
        /* Send mouse click */
        usb_hid_mouse_send(&usb_core_dev, RIGHT_BUTTON);
      }
    }
    else
    {
      /* Release button */
      usb_hid_mouse_send(&usb_core_dev, BUTTON_RELEASE);
    }
  }
}
```

### HID Keyboard

```c
#include "usbd_core.h"
#include "keyboard_class.h"
#include "keyboard_desc.h"
#include "usbd_int.h"

usbd_core_type usb_core_dev;

/* Send string as keyboard input */
void keyboard_send_string(void *udev, uint8_t *string, uint8_t len)
{
  uint8_t index = 0;
  usbd_core_type *pudev = (usbd_core_type *)udev;
  keyboard_type *pkeyboard = (keyboard_type *)pudev->class_handler->pdata;

  for(index = 0; index < len; index++)
  {
    /* Wait for TX complete */
    while(pkeyboard->g_u8tx_completed != 1);
    pkeyboard->g_u8tx_completed = 0;
    usb_hid_keyboard_send_char(udev, string[index]);

    /* Send key release (0x00) */
    while(pkeyboard->g_u8tx_completed != 1);
    pkeyboard->g_u8tx_completed = 0;
    usb_hid_keyboard_send_char(udev, 0x00);
  }
}

int main(void)
{
  /* ... initialization ... */

  usbd_core_init(&usb_core_dev, USB, &keyboard_class_handler, &keyboard_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    if(at32_button_press() == USER_BUTTON)
    {
      if(usbd_connect_state_get(&usb_core_dev) == USB_CONN_STATE_CONFIGURED)
      {
        keyboard_send_string(&usb_core_dev, (uint8_t *)" Keyboard Demo\r\n", 16);
      }
    }
  }
}
```

### Custom HID

```c
#include "usbd_core.h"
#include "custom_hid_class.h"
#include "custom_hid_desc.h"
#include "usbd_int.h"

usbd_core_type usb_core_dev;
uint8_t report_buf[USBD_CUSTOM_IN_MAXPACKET_SIZE];

int main(void)
{
  /* ... initialization ... */

  usbd_core_init(&usb_core_dev, USB, &custom_hid_class_handler, &custom_hid_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    if(at32_button_press() == USER_BUTTON)
    {
      /* Toggle report data */
      report_buf[1] = (~report_buf[1]) & 0x1;
      report_buf[0] = HID_REPORT_ID_5;

      /* Send custom HID report */
      custom_hid_class_send_report(&usb_core_dev, report_buf, USBD_CUSTOM_IN_MAXPACKET_SIZE);
    }
  }
}
```

### Mass Storage Class (MSC)

```c
#include "usbd_core.h"
#include "msc_class.h"
#include "msc_desc.h"
#include "usbd_int.h"

usbd_core_type usb_core_dev;

int main(void)
{
  /* ... initialization ... */

  /* Initialize USB as MSC device */
  usbd_core_init(&usb_core_dev, USB, &msc_class_handler, &msc_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    /* MSC operations handled in interrupt context */
  }
}
```

### USB Audio Device

```c
#include "usbd_core.h"
#include "audio_class.h"
#include "audio_desc.h"
#include "usbd_int.h"
#include "audio_codec.h"

usbd_core_type usb_core_dev;

int main(void)
{
  /* ... clock configuration ... */

  /* Initialize audio codec hardware */
  audio_codec_init();

  /* ... NVIC and USB clock configuration ... */

  /* Initialize USB as audio device */
  usbd_core_init(&usb_core_dev, USB, &audio_class_handler, &audio_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    /* Process audio data */
    audio_codec_loop();
    delay_ms(100);
  }
}
```

### WinUSB Device

```c
#include "usbd_core.h"
#include "winusb_class.h"
#include "winusb_desc.h"
#include "usbd_int.h"

usbd_core_type usb_core_dev;
uint8_t usb_buffer[256];

int main(void)
{
  /* ... initialization ... */

  usbd_core_init(&usb_core_dev, USB, &winusb_class_handler, &winusb_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    uint16_t data_len;

    /* Receive data from WinUSB host */
    data_len = usb_winusb_get_rxdata(&usb_core_dev, usb_buffer);

    if(data_len > 0)
    {
      uint32_t timeout = 5000000;
      do
      {
        /* Echo data back to host */
        if(usb_winusb_send_data(&usb_core_dev, usb_buffer, data_len) == SUCCESS)
          break;
      } while(timeout--);
    }
  }
}
```

### USB Printer Class

```c
#include "usbd_core.h"
#include "printer_class.h"
#include "printer_desc.h"
#include "usbd_int.h"

usbd_core_type usb_core_dev;
uint8_t usb_buffer[256];

int main(void)
{
  /* ... initialization ... */

  usbd_core_init(&usb_core_dev, USB, &printer_class_handler, &printer_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    uint32_t rx_len;

    /* Receive printer data from host */
    rx_len = usb_printer_get_rxdata(&usb_core_dev, usb_buffer);

    if(rx_len > 0)
    {
      /* Process print data */
    }
  }
}
```

---

## Composite USB Devices

### VCP + MSC Composite

```c
#include "usbd_core.h"
#include "cdc_msc_class.h"
#include "cdc_msc_desc.h"
#include "usbd_int.h"

usbd_core_type usb_core_dev;
uint8_t usb_buffer[256];

int main(void)
{
  /* ... initialization ... */

  /* Initialize as composite CDC + MSC device */
  usbd_core_init(&usb_core_dev, USB, &cdc_msc_class_handler, &cdc_msc_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    uint16_t data_len;

    /* Handle VCP data */
    data_len = usb_vcp_get_rxdata(&usb_core_dev, usb_buffer);

    if(data_len > 0)
    {
      /* Echo VCP data */
      usb_vcp_send_data(&usb_core_dev, usb_buffer, data_len);
    }

    /* MSC operations handled automatically */
  }
}
```

### Audio + HID Composite

```c
#include "usbd_core.h"
#include "audio_hid_class.h"
#include "audio_hid_desc.h"
#include "audio_codec.h"

usbd_core_type usb_core_dev;
uint8_t report_buf[USBD_AUHID_IN_MAXPACKET_SIZE];

int main(void)
{
  /* ... initialization ... */

  audio_codec_init();

  usbd_core_init(&usb_core_dev, USB, &audio_hid_class_handler, &audio_hid_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    /* Process audio */
    audio_codec_loop();

    /* Handle HID button */
    if(at32_button_press() == USER_BUTTON)
    {
      report_buf[0] = HID_REPORT_ID_5;
      report_buf[1] = (~report_buf[1]) & 0x1;
      audio_hid_class_send_report(&usb_core_dev, report_buf, USBD_AUHID_IN_MAXPACKET_SIZE);
    }

    delay_ms(100);
  }
}
```

---

## USB MSC IAP (In-Application Programming)

### Virtual FAT16 MSC for Firmware Update

```c
#include "usbd_core.h"
#include "msc_class.h"
#include "msc_desc.h"
#include "flash_fat16.h"

usbd_core_type usb_core_dev;
void (*pftarget)(void);

void jump_to_app(uint32_t address)
{
  uint32_t stkptr, jumpaddr;
  stkptr = *(uint32_t *)address;
  jumpaddr = *(uint32_t *)(address + sizeof(uint32_t));

  /* Disable USB clock and reset USB peripheral */
  crm_periph_clock_enable(CRM_USB_PERIPH_CLOCK, FALSE);
  crm_periph_reset(CRM_USB_PERIPH_RESET, TRUE);
  crm_periph_reset(CRM_USB_PERIPH_RESET, FALSE);

  /* Jump to application */
  __set_MSP(stkptr);
  pftarget = (void (*)(void))jumpaddr;
  pftarget();
}

int main(void)
{
  /* ... initialization ... */

  flash_fat16_init();

  /* Check if upgrade successful and no button pressed */
  if(flash_fat16_get_upgrade_flag() == IAP_SUCCESS &&
     (at32_button_press() == NO_BUTTON))
  {
    /* Jump to application */
    jump_to_app(flash_iap.flash_app_addr);
  }

  /* Stay in bootloader - initialize USB MSC */
  usbd_core_init(&usb_core_dev, USB, &msc_class_handler, &msc_desc_handler, 0);
  usbd_connect(&usb_core_dev);

  while(1)
  {
    /* Monitor upgrade status */
    flash_fat16_loop_status();
  }
}
```

---

## Low Power USB Operation

### USB Suspend and Remote Wakeup

```c
#ifdef USB_LOW_POWER_WAKUP

void usb_low_power_wakeup_config(void)
{
  exint_init_type exint_init_struct;

  exint_default_para_init(&exint_init_struct);
  exint_init_struct.line_enable = TRUE;
  exint_init_struct.line_mode = EXINT_LINE_INTERRUPT;
  exint_init_struct.line_select = EXINT_LINE_18;  /* USB wakeup line */
  exint_init_struct.line_polarity = EXINT_TRIGGER_RISING_EDGE;
  exint_init(&exint_init_struct);

  nvic_irq_enable(USBFSWakeUp_IRQn, 0, 0);
}

void USBFSWakeUp_IRQHandler(void)
{
  exint_flag_clear(EXINT_LINE_18);
}

void system_clock_recover(void)
{
  /* Re-enable HEXT */
  crm_clock_source_enable(CRM_CLOCK_SOURCE_HEXT, TRUE);
  while(crm_hext_stable_wait() == ERROR);

  /* Re-enable PLL */
  crm_clock_source_enable(CRM_CLOCK_SOURCE_PLL, TRUE);
  while(crm_flag_get(CRM_PLL_STABLE_FLAG) == RESET);

  /* Switch back to PLL */
  crm_auto_step_mode_enable(TRUE);
  crm_sysclk_switch(CRM_SCLK_PLL);
  while(crm_sysclk_switch_status_get() != CRM_SCLK_PLL);
}

int main(void)
{
  /* ... initialization ... */

  /* Enable PWC clock for low power */
  crm_periph_clock_enable(CRM_PWC_PERIPH_CLOCK, TRUE);
  usb_low_power_wakeup_config();

  while(1)
  {
    /* Check for suspend flag */
    if(((mouse_type *)(usb_core_dev.class_handler->pdata))->hid_suspend_flag == 1)
    {
      /* Configure low power mode */
      pwc_voltage_regulate_set(PWC_REGULATOR_LOW_POWER);

      /* Enter deep sleep */
      pwc_deep_sleep_mode_enter(PWC_DEEP_SLEEP_ENTER_WFI);

      /* Wake up - recover system clock */
      system_clock_recover();
      ((mouse_type *)(usb_core_dev.class_handler->pdata))->hid_suspend_flag = 0;
    }

    /* Handle remote wakeup */
    if(at32_button_press() == USER_BUTTON)
    {
      if(usbd_connect_state_get(&usb_core_dev) == USB_CONN_STATE_SUSPENDED &&
         usb_core_dev.remote_wakup == 1)
      {
        usbd_remote_wakeup(&usb_core_dev);
      }
    }
  }
}

#endif
```

---

## Endpoint Macros

### TX/RX Status Macros

```c
/* Set endpoint TX status */
#define USB_SET_TXSTS(ept_num, new_sts) { \
  register uint16_t epsts = (USB->ept[ept_num]) & USB_TX_MASK; \
  if((new_sts & USB_TXDTS0) != 0) epsts ^= USB_TXDTS0; \
  if((new_sts & USB_TXDTS1) != 0) epsts ^= USB_TXDTS1; \
  USB->ept[ept_num] = epsts | USB_RXTC | USB_TXTC; \
}

/* Set endpoint RX status */
#define USB_SET_RXSTS(ept_num, new_sts) { \
  register uint16_t epsts = (USB->ept[ept_num]) & USB_RX_MASK; \
  if((new_sts & USB_RXDTS0) != 0) epsts ^= USB_RXDTS0; \
  if((new_sts & USB_RXDTS1) != 0) epsts ^= USB_RXDTS1; \
  USB->ept[ept_num] = epsts | USB_RXTC | USB_TXTC; \
}
```

### Data Length Macros

```c
/* Get TX/RX length address */
#define GET_TX_LEN_ADDR(eptn) (uint32_t *)((USB->buftbl + eptn * 8 + 2) * 2 + g_usb_packet_address)
#define GET_RX_LEN_ADDR(eptn) (uint32_t *)((USB->buftbl + eptn * 8 + 6) * 2 + g_usb_packet_address)

/* Get TX/RX data length */
#define USB_GET_TX_LEN(eptn)  ((uint16_t)(*GET_TX_LEN_ADDR(eptn)) & 0x3ff)
#define USB_GET_RX_LEN(eptn)  ((uint16_t)(*GET_RX_LEN_ADDR(eptn)) & 0x3ff)

/* Set TX length */
#define USB_SET_TXLEN(eptn, len) (*(GET_TX_LEN_ADDR(eptn)) = (len))

/* Set RX length with block calculation */
#define USB_SET_RXLEN(eptn, len) { \
  uint32_t *rx_reg = GET_RX_LEN_ADDR(eptn); \
  USB_SET_RXLEN_REG(rx_reg, (len)); \
}
```

### Buffer Address Macros

```c
/* Set TX/RX buffer address */
#define USB_SET_TX_ADDRESS(eptn, address) \
  (*(uint32_t *)((USB->buftbl + eptn * 8) * 2 + g_usb_packet_address) = address)
#define USB_SET_RX_ADDRESS(eptn, address) \
  (*(uint32_t *)((USB->buftbl + eptn * 8 + 4) * 2 + g_usb_packet_address) = address)
```

### Data Toggle Macros

```c
/* Toggle TX/RX data toggle */
#define USB_TOGGLE_TXDTS(eptn) \
  (USB->ept[eptn] = ((USB->ept[eptn] & USB_EPT_BIT_MASK) | USB_TXDTS | USB_RXTC | USB_TXTC))
#define USB_TOGGLE_RXDTS(eptn) \
  (USB->ept[eptn] = ((USB->ept[eptn] & USB_EPT_BIT_MASK) | USB_RXDTS | USB_RXTC | USB_TXTC))

/* Clear TX/RX data toggle */
#define USB_CLEAR_TXDTS(eptn) { if(USB->ept_bit[eptn].txdts != 0) USB_TOGGLE_TXDTS(eptn); }
#define USB_CLEAR_RXDTS(eptn) { if(USB->ept_bit[eptn].rxdts != 0) USB_TOGGLE_RXDTS(eptn); }
```

### Double Buffer Macros

```c
/* Enable/disable double buffer mode */
#define USB_SET_EPT_DOUBLE_BUFFER(eptn)   USB_SET_EXF(eptn)
#define USB_CLEAR_EPT_DOUBLE_BUFFER(eptn) USB_CLEAR_EXF(eptn)

/* Double buffer address configuration */
#define USB_SET_DOUBLE_BUFF0_ADDRESS(eptn, address) USB_SET_TX_ADDRESS(eptn, address)
#define USB_SET_DOUBLE_BUFF1_ADDRESS(eptn, address) USB_SET_RX_ADDRESS(eptn, address)

/* Double buffer length access */
#define USB_DBUF0_GET_LEN(eptn) USB_GET_TX_LEN(eptn)
#define USB_DBUF1_GET_LEN(eptn) USB_GET_RX_LEN(eptn)
```

---

## Required Delay Functions

The USB middleware requires user-defined delay functions:

```c
/**
 * @brief USB delay in milliseconds
 */
void usb_delay_ms(uint32_t ms)
{
  delay_ms(ms);
}

/**
 * @brief USB delay in microseconds
 */
void usb_delay_us(uint32_t us)
{
  delay_us(us);
}
```

---

## Important Notes

1. **Clock Requirements**: USB requires precisely 48 MHz clock. Use either:
   - HEXT with appropriate divider
   - HICK with ACC calibration for crystal-less operation

2. **Interrupt Sharing**: USB shares interrupt vector with CAN1 (USBFS_L_CAN1_RX0_IRQn)

3. **Buffer Memory**: Default 512 bytes, expandable up to 1280 bytes (CAN dependent)

4. **Double Buffering**: Required for isochronous endpoints, optional for bulk

5. **D+ Pull-up**: Internal 1.5kΩ resistor controlled via `usb_connect()`/`usb_disconnect()`

6. **Endpoint 0**: Always used for control transfers (setup, status)

7. **Low Power**: USB wakeup uses EXINT Line 18

---

## Example Projects

| Example | Description |
|---------|-------------|
| `virtual_comport` | CDC VCP with USART bridge |
| `vcp_loopback` | CDC VCP data loopback |
| `mouse` | HID mouse with button |
| `keyboard` | HID keyboard typing |
| `custom_hid` | Custom HID reports |
| `msc` | USB mass storage |
| `audio` | USB audio device |
| `printer` | USB printer class |
| `winusb` | WinUSB bulk device |
| `composite_vcp_msc` | CDC + MSC composite |
| `composite_vcp_keyboard` | CDC + HID keyboard |
| `composite_audio_hid` | Audio + HID composite |
| `virtual_msc_iap` | MSC bootloader (IAP) |

---

## See Also

- [CRM - Clock and Reset Management](CRM_Clock_Reset_Management.md)
- [PWC - Power Control](PWC_Power_Control.md)
- [NVIC - Interrupt Configuration](CORTEX_M4_Core_Features.md)
- [ACC - Auto Clock Calibration](ACC_Auto_Clock_Calibration.md)

