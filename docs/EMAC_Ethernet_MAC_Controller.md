# EMAC (Ethernet MAC Controller) - AT32F407

## Overview

The AT32F407 microcontroller features an integrated **Ethernet MAC (EMAC)** controller that provides IEEE 802.3 compliant Ethernet connectivity. The EMAC supports both MII and RMII physical layer interfaces, enabling 10/100 Mbps Ethernet communication.

> **Note**: The EMAC is only available on the **AT32F407** variant. It is **NOT** available on the AT32F403A.

## Key Features

- **IEEE 802.3 Compliant**: Full compliance with Ethernet standards
- **Speed Support**: 10 Mbps and 100 Mbps operation
- **Duplex Mode**: Half-duplex and full-duplex support
- **PHY Interfaces**: 
  - MII (Media Independent Interface)
  - RMII (Reduced Media Independent Interface)
- **Auto-Negotiation**: Hardware support for speed/duplex negotiation
- **Checksum Offload**: IPv4 header checksum calculation/verification in hardware
- **DMA Engine**: Dedicated DMA for efficient data transfer
- **Multiple MAC Addresses**: Up to 4 MAC address filters
- **Frame Filtering**: 
  - Perfect address filtering
  - Hash table filtering (multicast/unicast)
  - Promiscuous mode
- **Flow Control**: IEEE 802.3x pause frame support
- **VLAN Support**: VLAN tag identification
- **Power Management**: Magic packet and wake-up frame detection
- **IEEE 1588 PTP**: Precision Time Protocol support
- **Statistics Counters**: MAC Management Counters (MMC)

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          AT32F407 EMAC                                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────────────┐ │
│  │   LwIP /    │    │   EMAC      │    │     DMA Engine              │ │
│  │   TCP/IP    │◄──►│   Core      │◄──►│  ┌─────────┐ ┌─────────┐   │ │
│  │   Stack     │    │   (MAC)     │    │  │   TX    │ │   RX    │   │ │
│  └─────────────┘    └─────────────┘    │  │   DMA   │ │   DMA   │   │ │
│         │                  │           │  └────┬────┘ └────┬────┘   │ │
│         │                  │           │       │           │        │ │
│         ▼                  ▼           └───────┼───────────┼────────┘ │
│  ┌─────────────────────────────────────────────┼───────────┼────────┐ │
│  │              TX/RX Descriptor Rings         │           │        │ │
│  │         (Memory - DMA Descriptors)          ▼           ▼        │ │
│  │        ┌──────────────────────────────────────────────────┐      │ │
│  │        │           TX/RX Buffers (Memory)                 │      │ │
│  │        └──────────────────────────────────────────────────┘      │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│                           ┌──────────┐                                  │
│                           │   SMI    │◄──► MDIO/MDC to PHY              │
│                           │ (MII Mgmt)│                                  │
│                           └──────────┘                                  │
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                    MII / RMII Interface                          │  │
│  │  TX: TXD[0:3], TX_EN, TX_CLK                                     │  │
│  │  RX: RXD[0:3], RX_DV, RX_CLK, RX_ER                              │  │
│  │  Control: CRS, COL (MII only)                                    │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                    │                                    │
└────────────────────────────────────┼────────────────────────────────────┘
                                     │
                                     ▼
                              ┌─────────────┐
                              │  External   │
                              │    PHY      │
                              │ (e.g. DP83848)│
                              └─────────────┘
                                     │
                                     ▼
                              ┌─────────────┐
                              │  Ethernet   │
                              │   Network   │
                              └─────────────┘
```

---

## Memory Map

| Register Block | Base Address | Description |
|----------------|--------------|-------------|
| EMAC (MAC)     | 0x40028000   | MAC core registers |
| EMAC_MMC       | 0x40028100   | MAC Management Counters |
| EMAC_PTP       | 0x40028700   | IEEE 1588 PTP registers |
| EMAC_DMA       | 0x40029000   | DMA engine registers |

---

## Register Structure

### MAC Core Registers

| Offset | Register | Description |
|--------|----------|-------------|
| 0x00 | CTRL | MAC Control Register |
| 0x04 | FRMF | Frame Filter Register |
| 0x08 | HTH | Hash Table High Register |
| 0x0C | HTL | Hash Table Low Register |
| 0x10 | MIIADDR | MII Address Register |
| 0x14 | MIIDT | MII Data Register |
| 0x18 | FCTRL | Flow Control Register |
| 0x1C | VLT | VLAN Tag Register |
| 0x28 | RWFF | Remote Wake-up Frame Filter |
| 0x2C | PMTCTRLSTS | PMT Control and Status |
| 0x38 | ISTS | Interrupt Status Register |
| 0x3C | IMR | Interrupt Mask Register |
| 0x40 | A0H | MAC Address 0 High |
| 0x44 | A0L | MAC Address 0 Low |
| 0x48-0x5C | A1H-A3L | MAC Address 1-3 Filters |

### DMA Registers

| Offset | Register | Description |
|--------|----------|-------------|
| 0x1000 | BM | Bus Mode Register |
| 0x1004 | TPD | Transmit Poll Demand |
| 0x1008 | RPD | Receive Poll Demand |
| 0x100C | RDLADDR | Receive Descriptor List Address |
| 0x1010 | TDLADDR | Transmit Descriptor List Address |
| 0x1014 | STS | Status Register |
| 0x1018 | OPM | Operation Mode Register |
| 0x101C | IE | Interrupt Enable Register |
| 0x1020 | MFBOCNT | Missed Frame/Buffer Overflow Counter |
| 0x1048 | CTD | Current TX Descriptor Address |
| 0x104C | CRD | Current RX Descriptor Address |
| 0x1050 | CTBADDR | Current TX Buffer Address |
| 0x1054 | CRBADDR | Current RX Buffer Address |

---

## Configuration Types

### Speed Configuration

```c
typedef enum
{
  EMAC_SPEED_10MBPS  = 0x00,  /* 10 Mbps */
  EMAC_SPEED_100MBPS = 0x01   /* 100 Mbps */
} emac_speed_type;
```

### Duplex Mode

```c
typedef enum
{
  EMAC_HALF_DUPLEX = 0x00,  /* Half duplex */
  EMAC_FULL_DUPLEX = 0x01   /* Full duplex */
} emac_duplex_type;
```

### Auto-Negotiation

```c
typedef enum
{
  EMAC_AUTO_NEGOTIATION_OFF = 0x00,  /* Manual configuration */
  EMAC_AUTO_NEGOTIATION_ON  = 0x01   /* Auto-negotiation enabled */
} emac_auto_negotiation_type;
```

### DMA Programmable Burst Length

```c
typedef enum
{
  EMAC_DMA_PBL_1  = 0x01,  /* 1 beat per DMA transaction */
  EMAC_DMA_PBL_2  = 0x02,  /* 2 beats per DMA transaction */
  EMAC_DMA_PBL_4  = 0x04,  /* 4 beats per DMA transaction */
  EMAC_DMA_PBL_8  = 0x08,  /* 8 beats per DMA transaction */
  EMAC_DMA_PBL_16 = 0x10,  /* 16 beats per DMA transaction */
  EMAC_DMA_PBL_32 = 0x20   /* 32 beats per DMA transaction */
} emac_dma_pbl_type;
```

### DMA RX/TX Priority Ratio

```c
typedef enum
{
  EMAC_DMA_1_RX_1_TX = 0x00,  /* RX:TX = 1:1 */
  EMAC_DMA_2_RX_1_TX = 0x01,  /* RX:TX = 2:1 */
  EMAC_DMA_3_RX_1_TX = 0x02,  /* RX:TX = 3:1 */
  EMAC_DMA_4_RX_1_TX = 0x03   /* RX:TX = 4:1 */
} emac_dma_rx_tx_ratio_type;
```

### DMA Interrupt Types

```c
typedef enum
{
  EMAC_DMA_INTERRUPT_TX               = 0x00,  /* Transmit interrupt */
  EMAC_DMA_INTERRUPT_TX_STOP          = 0x01,  /* Transmit process stopped */
  EMAC_DMA_INTERRUPT_TX_UNAVAILABLE   = 0x02,  /* TX buffer unavailable */
  EMAC_DMA_INTERRUPT_TX_JABBER        = 0x03,  /* Transmit jabber timeout */
  EMAC_DMA_INTERRUPT_RX_OVERFLOW      = 0x04,  /* Receive overflow */
  EMAC_DMA_INTERRUPT_TX_UNDERFLOW     = 0x05,  /* Transmit underflow */
  EMAC_DMA_INTERRUPT_RX               = 0x06,  /* Receive interrupt */
  EMAC_DMA_INTERRUPT_RX_UNAVAILABLE   = 0x07,  /* RX buffer unavailable */
  EMAC_DMA_INTERRUPT_RX_STOP          = 0x08,  /* Receive process stopped */
  EMAC_DMA_INTERRUPT_RX_TIMEOUT       = 0x09,  /* Receive watchdog timeout */
  EMAC_DMA_INTERRUPT_TX_EARLY         = 0x0A,  /* Early transmit interrupt */
  EMAC_DMA_INTERRUPT_FATAL_BUS_ERROR  = 0x0B,  /* Fatal bus error */
  EMAC_DMA_INTERRUPT_RX_EARLY         = 0x0C,  /* Early receive interrupt */
  EMAC_DMA_INTERRUPT_ABNORMAL_SUMMARY = 0x0D,  /* Abnormal interrupt summary */
  EMAC_DMA_INTERRUPT_NORMAL_SUMMARY   = 0x0E   /* Normal interrupt summary */
} emac_dma_interrupt_type;
```

---

## Initialization Structures

### MAC Control Configuration

```c
typedef struct
{
  emac_auto_negotiation_type auto_nego;          /* Auto negotiation enable */
  confirm_state              deferral_check;     /* Deferral check enable */
  emac_bol_type              back_off_limit;     /* Back-off limit */
  confirm_state              auto_pad_crc_strip; /* Auto pad/CRC strip enable */
  confirm_state              retry_disable;      /* Retry disable */
  confirm_state              ipv4_checksum_offload; /* IPv4 checksum offload */
  emac_duplex_type           duplex_mode;        /* Duplex mode */
  confirm_state              loopback_mode;      /* Loopback mode enable */
  confirm_state              receive_own_disable;/* Receive own disable */
  emac_speed_type            fast_ethernet_speed;/* Speed (10/100 Mbps) */
  confirm_state              carrier_sense_disable; /* Carrier sense disable */
  emac_intergrame_gap_type   interframe_gap;     /* Interframe gap */
  confirm_state              jabber_disable;     /* Jabber disable */
  confirm_state              watchdog_disable;   /* Watchdog disable */
} emac_control_config_type;
```

### DMA Configuration

```c
typedef struct
{
  confirm_state                 aab_enable;       /* Address-aligned beats */
  confirm_state                 usp_enable;       /* Separate PBL enable */
  emac_dma_pbl_type             rx_dma_pal;       /* RX DMA PBL */
  confirm_state                 fb_enable;        /* Fixed burst enable */
  emac_dma_pbl_type             tx_dma_pal;       /* TX DMA PBL */
  uint8_t                       desc_skip_length; /* Descriptor skip length */
  confirm_state                 da_enable;        /* DMA arbitration enable */
  emac_dma_rx_tx_ratio_type     priority_ratio;   /* RX/TX priority ratio */
  confirm_state                 dt_disable;       /* Drop TCP/IP error disable */
  confirm_state                 rsf_enable;       /* RX store and forward */
  confirm_state                 flush_rx_disable; /* Disable RX flushing */
  confirm_state                 tsf_enable;       /* TX store and forward */
  emac_dma_transmit_threshold_type tx_threshold;  /* TX threshold */
  confirm_state                 fef_enable;       /* Forward error frames */
  confirm_state                 fugf_enable;      /* Forward undersized frames */
  emac_dma_receive_threshold_type rx_threshold;   /* RX threshold */
  confirm_state                 osf_enable;       /* Operate on second frame */
} emac_dma_config_type;
```

### DMA Descriptor

```c
typedef struct {
  uint32_t status;           /* Status/control and buffer lengths */
  uint32_t controlsize;      /* Control and buffer1, buffer2 lengths */
  uint32_t buf1addr;         /* Buffer1 address pointer */
  uint32_t buf2nextdescaddr; /* Buffer2 or next descriptor address */
  uint32_t extendedstatus;   /* Extended status (enhanced descriptor) */
  uint32_t reserved1;
  uint32_t timestamp_l;      /* Timestamp low (PTP) */
  uint32_t timestamp_h;      /* Timestamp high (PTP) */
} emac_dma_desc_type;
```

---

## API Functions

### Initialization Functions

```c
/**
 * @brief  Reset EMAC peripheral
 */
void emac_reset(void);

/**
 * @brief  Set MDC clock range based on HCLK
 */
void emac_clock_range_set(void);

/**
 * @brief  Initialize MAC control parameters to default
 */
void emac_control_para_init(emac_control_config_type *control_para);

/**
 * @brief  Configure MAC control settings
 */
void emac_control_config(emac_control_config_type *control_struct);

/**
 * @brief  Initialize DMA parameters to default
 */
void emac_dma_para_init(emac_dma_config_type *control_para);

/**
 * @brief  Configure DMA settings
 */
void emac_dma_config(emac_dma_config_type *control_para);
```

### DMA Software Reset

```c
/**
 * @brief  Trigger DMA software reset
 */
void emac_dma_software_reset_set(void);

/**
 * @brief  Get DMA software reset status
 * @return SET if reset in progress, RESET when complete
 */
flag_status emac_dma_software_reset_get(void);
```

### Start/Stop Operations

```c
/**
 * @brief  Start EMAC and DMA transmission/reception
 */
void emac_start(void);

/**
 * @brief  Stop EMAC and DMA transmission/reception
 */
void emac_stop(void);

/**
 * @brief  Enable/disable MAC receiver
 */
void emac_receiver_enable(confirm_state new_state);

/**
 * @brief  Enable/disable MAC transmitter
 */
void emac_trasmitter_enable(confirm_state new_state);
```

### PHY Register Access

```c
/**
 * @brief  Write to PHY register via MDIO
 * @param  address: PHY address (0-31)
 * @param  reg: Register address (0-31)
 * @param  data: Data to write
 * @return SUCCESS or ERROR
 */
error_status emac_phy_register_write(uint8_t address, uint8_t reg, uint16_t data);

/**
 * @brief  Read from PHY register via MDIO
 * @param  address: PHY address (0-31)
 * @param  reg: Register address (0-31)
 * @param  data: Pointer to store read data
 * @return SUCCESS or ERROR
 */
error_status emac_phy_register_read(uint8_t address, uint8_t reg, uint16_t *data);
```

### Speed and Duplex Configuration

```c
/**
 * @brief  Set Ethernet speed (10/100 Mbps)
 */
void emac_fast_speed_set(emac_speed_type speed);

/**
 * @brief  Set duplex mode (half/full)
 */
void emac_duplex_mode_set(emac_duplex_type duplex_mode);
```

### MAC Address Configuration

```c
/**
 * @brief  Set local MAC address (MAC0)
 * @param  address: 6-byte MAC address array
 */
void emac_local_address_set(uint8_t *address);

/**
 * @brief  Configure MAC address filter (MAC1-3)
 */
void emac_address_filter_set(emac_address_type mac, 
                             emac_address_filter_type filter, 
                             emac_address_mask_type mask_bit, 
                             confirm_state new_state);
```

### DMA Descriptor Management

```c
/**
 * @brief  Set TX/RX descriptor list address and initialize descriptors
 * @param  transfer_type: EMAC_DMA_TRANSMIT or EMAC_DMA_RECEIVE
 * @param  dma_desc_tab: Pointer to descriptor array
 * @param  buff: Pointer to buffer array
 * @param  buffer_count: Number of buffers/descriptors
 */
void emac_dma_descriptor_list_address_set(emac_dma_tx_rx_type transfer_type, 
                                          emac_dma_desc_type *dma_desc_tab, 
                                          uint8_t *buff, 
                                          uint32_t buffer_count);

/**
 * @brief  Get received packet size
 */
uint32_t emac_received_packet_size_get(void);

/**
 * @brief  Get frame length from RX descriptor
 */
uint32_t emac_dmarxdesc_frame_length_get(emac_dma_desc_type *dma_rx_desc);
```

### DMA Interrupt Management

```c
/**
 * @brief  Enable/disable DMA interrupt
 */
void emac_dma_interrupt_enable(emac_dma_interrupt_type it, confirm_state new_state);

/**
 * @brief  Get DMA flag status
 */
flag_status emac_dma_flag_get(uint32_t dma_flag);

/**
 * @brief  Get DMA interrupt flag status
 */
flag_status emac_dma_interrupt_flag_get(uint32_t dma_flag);

/**
 * @brief  Clear DMA flag
 */
void emac_dma_flag_clear(uint32_t dma_flag);
```

### Flow Control

```c
/**
 * @brief  Enable/disable transmit flow control
 */
void emac_transmit_flow_control_enable(confirm_state new_state);

/**
 * @brief  Enable/disable receive flow control
 */
void emac_receive_flow_control_enable(confirm_state new_state);

/**
 * @brief  Set pause time for flow control
 */
void emac_pause_time_set(uint16_t pause_time);
```

### Frame Filtering

```c
/**
 * @brief  Enable/disable promiscuous mode
 */
void emac_promiscuous_mode_set(confirm_state new_state);

/**
 * @brief  Enable/disable hash unicast filtering
 */
void emac_hash_unicast_set(confirm_state new_state);

/**
 * @brief  Enable/disable hash multicast filtering
 */
void emac_hash_multicast_set(confirm_state new_state);

/**
 * @brief  Set hash table high 32 bits
 */
void emac_hash_table_high32bits_set(uint32_t high32bits);

/**
 * @brief  Set hash table low 32 bits
 */
void emac_hash_table_low32bits_set(uint32_t low32bits);

/**
 * @brief  Disable broadcast frames
 */
void emac_broadcast_frames_disable(confirm_state new_state);
```

### Power Management

```c
/**
 * @brief  Enable/disable power down mode
 */
void emac_power_down_set(confirm_state new_state);

/**
 * @brief  Enable/disable magic packet detection
 */
void emac_magic_packet_enable(confirm_state new_state);

/**
 * @brief  Enable/disable wake-up frame detection
 */
void emac_wakeup_frame_enable(confirm_state new_state);
```

---

## Usage Examples

### Example 1: Basic EMAC Initialization with LwIP

```c
#include "at32f403a_407.h"
#include "at32_emac.h"
#include "lwip/netif.h"

/* MAC address */
uint8_t mac_address[6] = {0x00, 0x11, 0x22, 0x33, 0x44, 0x55};

/* DMA descriptors and buffers */
#define ETH_RXBUFNB  4
#define ETH_TXBUFNB  4

emac_dma_desc_type dma_rx_desc_tab[ETH_RXBUFNB] __attribute__((aligned(4)));
emac_dma_desc_type dma_tx_desc_tab[ETH_TXBUFNB] __attribute__((aligned(4)));
uint8_t rx_buff[ETH_RXBUFNB][EMAC_MAX_PACKET_LENGTH] __attribute__((aligned(4)));
uint8_t tx_buff[ETH_TXBUFNB][EMAC_MAX_PACKET_LENGTH] __attribute__((aligned(4)));

/**
 * @brief  Initialize EMAC system
 */
error_status emac_system_init(void)
{
  emac_control_config_type mac_control;
  emac_dma_config_type dma_control;

  /* Enable EMAC clocks */
  crm_periph_clock_enable(CRM_EMAC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_EMACTX_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_EMACRX_PERIPH_CLOCK, TRUE);

  /* Configure GPIO for EMAC */
  emac_pins_configuration();

  /* Select MII or RMII mode */
  #ifdef RMII_MODE
  gpio_pin_remap_config(MII_RMII_SEL_GMUX, TRUE);
  #else
  gpio_pin_remap_config(MII_RMII_SEL_GMUX, FALSE);
  #endif

  /* Reset EMAC */
  emac_reset();

  /* Software reset DMA */
  emac_dma_software_reset_set();
  while(emac_dma_software_reset_get() == SET);

  /* Set MDC clock based on system clock */
  emac_clock_range_set();

  /* Initialize MAC control parameters */
  emac_control_para_init(&mac_control);
  mac_control.auto_nego = EMAC_AUTO_NEGOTIATION_ON;
  mac_control.ipv4_checksum_offload = TRUE;
  emac_control_config(&mac_control);

  /* Reset and configure PHY */
  if(emac_phy_init(&mac_control) == ERROR)
  {
    return ERROR;
  }

  /* Set MAC address */
  emac_local_address_set(mac_address);

  /* Initialize DMA parameters */
  emac_dma_para_init(&dma_control);
  dma_control.rsf_enable = TRUE;       /* RX store and forward */
  dma_control.tsf_enable = TRUE;       /* TX store and forward */
  dma_control.osf_enable = TRUE;       /* Operate on second frame */
  dma_control.aab_enable = TRUE;       /* Address aligned beats */
  dma_control.usp_enable = TRUE;       /* Separate PBL */
  dma_control.fb_enable = TRUE;        /* Fixed burst */
  dma_control.flush_rx_disable = TRUE;
  dma_control.rx_dma_pal = EMAC_DMA_PBL_32;
  dma_control.tx_dma_pal = EMAC_DMA_PBL_32;
  dma_control.priority_ratio = EMAC_DMA_2_RX_1_TX;
  emac_dma_config(&dma_control);

  /* Initialize DMA descriptors */
  emac_dma_descriptor_list_address_set(EMAC_DMA_TRANSMIT, 
                                       dma_tx_desc_tab, 
                                       &tx_buff[0][0], 
                                       ETH_TXBUFNB);
  emac_dma_descriptor_list_address_set(EMAC_DMA_RECEIVE, 
                                       dma_rx_desc_tab, 
                                       &rx_buff[0][0], 
                                       ETH_RXBUFNB);

  /* Enable DMA interrupts */
  emac_dma_interrupt_enable(EMAC_DMA_INTERRUPT_NORMAL_SUMMARY, TRUE);
  emac_dma_interrupt_enable(EMAC_DMA_INTERRUPT_RX, TRUE);

  /* Start EMAC */
  emac_start();

  return SUCCESS;
}
```

### Example 2: PHY Initialization and Auto-Negotiation

```c
/* PHY Register Addresses (common for most PHYs) */
#define PHY_CONTROL_REG         0x00
#define PHY_STATUS_REG          0x01
#define PHY_ID1_REG             0x02
#define PHY_ID2_REG             0x03
#define PHY_AUTONEG_ADV_REG     0x04
#define PHY_SPECIFIED_CS_REG    0x1F

/* PHY Control Register bits */
#define PHY_RESET_BIT           0x8000
#define PHY_AUTO_NEGOTIATION_BIT 0x1000
#define PHY_SPEED_100_BIT       0x2000
#define PHY_FULL_DUPLEX_BIT     0x0100

/* PHY Status Register bits */
#define PHY_LINKED_STATUS_BIT   0x0004
#define PHY_NEGO_COMPLETE_BIT   0x0020

#define PHY_ADDRESS             0x01  /* PHY address on MDIO bus */

/**
 * @brief  Reset PHY and wait for completion
 */
error_status emac_phy_register_reset(void)
{
  uint16_t data = 0;
  uint32_t timeout = 0;

  /* Write reset bit */
  if(emac_phy_register_write(PHY_ADDRESS, PHY_CONTROL_REG, PHY_RESET_BIT) == ERROR)
  {
    return ERROR;
  }

  /* Wait for reset to complete */
  do
  {
    timeout++;
    if(emac_phy_register_read(PHY_ADDRESS, PHY_CONTROL_REG, &data) == ERROR)
    {
      return ERROR;
    }
  } while((data & PHY_RESET_BIT) && (timeout < PHY_TIMEOUT));

  if(timeout == PHY_TIMEOUT)
  {
    return ERROR;
  }
  return SUCCESS;
}

/**
 * @brief  Initialize PHY with auto-negotiation
 */
error_status emac_phy_init(emac_control_config_type *control_para)
{
  uint16_t data = 0;
  uint32_t timeout = 0;

  /* Set MDC clock range */
  emac_clock_range_set();

  /* Reset PHY */
  if(emac_phy_register_reset() == ERROR)
  {
    return ERROR;
  }

  /* Configure MAC control */
  emac_control_config(control_para);

  if(control_para->auto_nego == EMAC_AUTO_NEGOTIATION_ON)
  {
    /* Wait for link */
    do
    {
      timeout++;
      if(emac_phy_register_read(PHY_ADDRESS, PHY_STATUS_REG, &data) == ERROR)
      {
        return ERROR;
      }
    } while(!(data & PHY_LINKED_STATUS_BIT) && (timeout < PHY_TIMEOUT));

    if(timeout == PHY_TIMEOUT) return ERROR;

    /* Start auto-negotiation */
    if(emac_phy_register_write(PHY_ADDRESS, PHY_CONTROL_REG, 
                               PHY_AUTO_NEGOTIATION_BIT) == ERROR)
    {
      return ERROR;
    }

    /* Wait for negotiation complete */
    timeout = 0;
    do
    {
      timeout++;
      if(emac_phy_register_read(PHY_ADDRESS, PHY_STATUS_REG, &data) == ERROR)
      {
        return ERROR;
      }
    } while(!(data & PHY_NEGO_COMPLETE_BIT) && (timeout < PHY_TIMEOUT));

    if(timeout == PHY_TIMEOUT) return ERROR;

    /* Read negotiation result and configure MAC */
    if(emac_phy_register_read(PHY_ADDRESS, PHY_SPECIFIED_CS_REG, &data) == ERROR)
    {
      return ERROR;
    }

    /* Set speed and duplex based on PHY result */
    if(data & 0x0010)  /* Full duplex */
      emac_duplex_mode_set(EMAC_FULL_DUPLEX);
    else
      emac_duplex_mode_set(EMAC_HALF_DUPLEX);

    if(data & 0x0008)  /* 10 Mbps */
      emac_fast_speed_set(EMAC_SPEED_10MBPS);
    else
      emac_fast_speed_set(EMAC_SPEED_100MBPS);
  }

  return SUCCESS;
}
```

### Example 3: Transmit Frame

```c
extern emac_dma_desc_type *dma_tx_desc_to_set;

/**
 * @brief  Transmit an Ethernet frame
 * @param  buffer: Pointer to frame data
 * @param  length: Frame length
 * @return SUCCESS or ERROR
 */
error_status emac_frame_transmit(uint8_t *buffer, uint32_t length)
{
  uint32_t i;
  uint8_t *dest;

  /* Check if descriptor is available (owned by CPU) */
  if(dma_tx_desc_to_set->status & EMAC_DMATXDESC_OWN)
  {
    return ERROR;  /* Descriptor busy */
  }

  /* Get buffer address from descriptor */
  dest = (uint8_t *)dma_tx_desc_to_set->buf1addr;

  /* Copy frame data to TX buffer */
  for(i = 0; i < length; i++)
  {
    dest[i] = buffer[i];
  }

  /* Set frame length */
  dma_tx_desc_to_set->controlsize = (length & 0x1FFF);

  /* Set first and last segment, enable interrupt, checksum insertion */
  dma_tx_desc_to_set->status = EMAC_DMATXDESC_TCH | 
                               EMAC_DMATXDESC_FS | 
                               EMAC_DMATXDESC_LS |
                               EMAC_DMATXDESC_IC |
                               EMAC_DMATXDESC_CIC_TUI_FULL;

  /* Transfer ownership to DMA */
  dma_tx_desc_to_set->status |= EMAC_DMATXDESC_OWN;

  /* Resume DMA transmission if suspended */
  if(EMAC_DMA->sts & EMAC_DMA_TBU_FLAG)
  {
    emac_dma_flag_clear(EMAC_DMA_TBU_FLAG);
    emac_dma_poll_demand_set(EMAC_DMA_TRANSMIT, 0);
  }

  /* Move to next descriptor */
  dma_tx_desc_to_set = (emac_dma_desc_type *)dma_tx_desc_to_set->buf2nextdescaddr;

  return SUCCESS;
}
```

### Example 4: Receive Frame

```c
extern emac_dma_desc_type *dma_rx_desc_to_get;

/**
 * @brief  Receive an Ethernet frame
 * @param  buffer: Buffer to store received frame
 * @param  length: Pointer to store frame length
 * @return SUCCESS if frame received, ERROR if no frame
 */
error_status emac_frame_receive(uint8_t *buffer, uint32_t *length)
{
  uint32_t frame_length = 0;
  uint32_t i;
  uint8_t *src;

  /* Check if frame received (descriptor owned by CPU) */
  if(dma_rx_desc_to_get->status & EMAC_DMARXDESC_OWN)
  {
    return ERROR;  /* No frame available */
  }

  /* Check for errors */
  if(dma_rx_desc_to_get->status & EMAC_DMARXDESC_ES)
  {
    /* Error frame - discard */
    frame_length = 0;
  }
  else
  {
    /* Get frame length (subtract CRC) */
    frame_length = ((dma_rx_desc_to_get->status & EMAC_DMARXDESC_FL) >> 16) - 4;
    
    if(frame_length > 0 && frame_length <= EMAC_MAX_PACKET_LENGTH)
    {
      /* Get buffer address */
      src = (uint8_t *)dma_rx_desc_to_get->buf1addr;

      /* Copy frame data */
      for(i = 0; i < frame_length; i++)
      {
        buffer[i] = src[i];
      }
    }
  }

  *length = frame_length;

  /* Set buffer size and give descriptor back to DMA */
  dma_rx_desc_to_get->controlsize = EMAC_DMARXDESC_RCH | EMAC_MAX_PACKET_LENGTH;
  dma_rx_desc_to_get->status = EMAC_DMARXDESC_OWN;

  /* Resume DMA reception if suspended */
  if(EMAC_DMA->sts & EMAC_DMA_RBU_FLAG)
  {
    emac_dma_flag_clear(EMAC_DMA_RBU_FLAG);
    emac_dma_poll_demand_set(EMAC_DMA_RECEIVE, 0);
  }

  /* Move to next descriptor */
  dma_rx_desc_to_get = (emac_dma_desc_type *)dma_rx_desc_to_get->buf2nextdescaddr;

  return (frame_length > 0) ? SUCCESS : ERROR;
}
```

### Example 5: DMA Interrupt Handler

```c
/**
 * @brief  EMAC interrupt handler
 */
void EMAC_IRQHandler(void)
{
  /* Handle receive interrupt */
  if(emac_dma_interrupt_flag_get(EMAC_DMA_RI_FLAG))
  {
    /* Process received frames */
    lwip_rx_loop_handler();  /* LwIP receive handler */
    
    /* Clear flag */
    emac_dma_flag_clear(EMAC_DMA_RI_FLAG);
    emac_dma_flag_clear(EMAC_DMA_NIS_FLAG);
  }

  /* Handle transmit interrupt */
  if(emac_dma_interrupt_flag_get(EMAC_DMA_TI_FLAG))
  {
    /* TX complete - can send more frames */
    emac_dma_flag_clear(EMAC_DMA_TI_FLAG);
    emac_dma_flag_clear(EMAC_DMA_NIS_FLAG);
  }

  /* Handle abnormal interrupts */
  if(emac_dma_flag_get(EMAC_DMA_AIS_FLAG))
  {
    /* Check for specific errors */
    if(emac_dma_flag_get(EMAC_DMA_RBU_FLAG))
    {
      /* RX buffer unavailable - resume reception */
      emac_dma_flag_clear(EMAC_DMA_RBU_FLAG);
      emac_dma_poll_demand_set(EMAC_DMA_RECEIVE, 0);
    }

    if(emac_dma_flag_get(EMAC_DMA_TBU_FLAG))
    {
      /* TX buffer unavailable */
      emac_dma_flag_clear(EMAC_DMA_TBU_FLAG);
    }

    emac_dma_flag_clear(EMAC_DMA_AIS_FLAG);
  }
}
```

---

## GPIO Pin Mapping

### MII Mode

| Signal | GPIO Pin | Function |
|--------|----------|----------|
| MDC | PC1 | Management Data Clock |
| MDIO | PA2 | Management Data I/O |
| TX_CLK | PC3 | Transmit Clock (input) |
| TX_EN | PB11 | Transmit Enable |
| TXD0 | PB12 | Transmit Data 0 |
| TXD1 | PB13 | Transmit Data 1 |
| TXD2 | PC2 | Transmit Data 2 |
| TXD3 | PB8 | Transmit Data 3 |
| RX_CLK | PA1 | Receive Clock (input) |
| RX_DV | PA7 / PD8 | Receive Data Valid |
| RXD0 | PC4 / PD9 | Receive Data 0 |
| RXD1 | PC5 / PD10 | Receive Data 1 |
| RXD2 | PB0 / PD11 | Receive Data 2 |
| RXD3 | PB1 / PD12 | Receive Data 3 |
| RX_ER | PB10 | Receive Error |
| CRS | PA0 | Carrier Sense |
| COL | PA3 | Collision Detect |

### RMII Mode

| Signal | GPIO Pin | Function |
|--------|----------|----------|
| MDC | PC1 | Management Data Clock |
| MDIO | PA2 | Management Data I/O |
| REF_CLK | PA1 | Reference Clock (50 MHz input) |
| TX_EN | PB11 | Transmit Enable |
| TXD0 | PB12 | Transmit Data 0 |
| TXD1 | PB13 | Transmit Data 1 |
| CRS_DV | PA7 / PD8 | Carrier Sense / Data Valid |
| RXD0 | PC4 / PD9 | Receive Data 0 |
| RXD1 | PC5 / PD10 | Receive Data 1 |

---

## DMA Descriptor Status Bits

### TX Descriptor Status (TDES0)

| Bit | Name | Description |
|-----|------|-------------|
| 31 | OWN | Owned by DMA (1) or CPU (0) |
| 30 | IC | Interrupt on Completion |
| 29 | LS | Last Segment |
| 28 | FS | First Segment |
| 27 | DC | Disable CRC |
| 26 | DP | Disable Padding |
| 25 | TTSE | Transmit Time Stamp Enable |
| 23:22 | CIC | Checksum Insertion Control |
| 21 | TER | Transmit End of Ring |
| 20 | TCH | Second Address Chained |
| 17 | TTSS | TX Time Stamp Status |
| 15 | ES | Error Summary |
| 14 | JT | Jabber Timeout |
| 1 | UF | Underflow Error |
| 0 | DB | Deferred Bit |

### RX Descriptor Status (RDES0)

| Bit | Name | Description |
|-----|------|-------------|
| 31 | OWN | Owned by DMA (1) or CPU (0) |
| 30 | AFM | Destination Address Filter Fail |
| 29:16 | FL | Frame Length |
| 15 | ES | Error Summary |
| 14 | DE | Descriptor Error |
| 9 | FS | First Descriptor of Frame |
| 8 | LS | Last Descriptor of Frame |
| 7 | IPV4HCE | IPv4 Header Checksum Error |
| 6 | LC | Late Collision |
| 5 | FT | Frame Type (Ethernet) |
| 2 | CE | CRC Error |
| 0 | MAMPCE | MAC Address/Payload Checksum Error |

---

## Application Examples

The firmware library includes complete examples:

| Example | Description |
|---------|-------------|
| tcp_client | TCP client socket application |
| tcp_server | TCP server socket application |
| http_server | HTTP web server |
| dns_client | DNS lookup client |
| mqtt_client | MQTT IoT messaging |
| iperf | Network performance testing |
| telnet | Telnet server |
| wake_on_lan | Wake-on-LAN functionality |

All examples use the **LwIP** (Lightweight IP) TCP/IP stack.

---

## Best Practices

### 1. Clock Configuration

```c
/* EMAC requires multiple clocks */
crm_periph_clock_enable(CRM_EMAC_PERIPH_CLOCK, TRUE);
crm_periph_clock_enable(CRM_EMACTX_PERIPH_CLOCK, TRUE);
crm_periph_clock_enable(CRM_EMACRX_PERIPH_CLOCK, TRUE);

/* For RMII: External 50 MHz clock or MCO output */
```

### 2. Buffer Alignment

```c
/* DMA descriptors and buffers must be 4-byte aligned */
emac_dma_desc_type descriptors[N] __attribute__((aligned(4)));
uint8_t buffers[N][SIZE] __attribute__((aligned(4)));
```

### 3. Descriptor Ring Management

```c
/* Always check OWN bit before accessing descriptor */
if(!(desc->status & EMAC_DMATXDESC_OWN))
{
  /* Safe to use descriptor */
}
```

### 4. Error Handling

```c
/* Check for errors in received frames */
if(rx_desc->status & EMAC_DMARXDESC_ES)
{
  /* Discard frame, check specific error bits */
}
```

---

## Troubleshooting

### Common Issues

1. **No Link**
   - Check PHY reset timing
   - Verify PHY address on MDIO bus
   - Check cable connection
   - Verify MDC clock rate

2. **TX/RX Stuck**
   - Check DMA descriptors for OWN bit
   - Verify buffer addresses are valid
   - Check for buffer overflow/underflow
   - Resume DMA if suspended

3. **Checksum Errors**
   - Enable checksum offload in both MAC and descriptors
   - Verify CIC bits in TX descriptor
   - Check IPC bit in MAC control register

4. **Performance Issues**
   - Increase DMA burst length (PBL)
   - Enable store-and-forward mode
   - Optimize interrupt handling
   - Use DMA interrupts instead of polling

---

## See Also

- [CRM (Clock and Reset Management)](CRM_Clock_Reset_Management.md)
- [GPIO (General Purpose I/O)](GPIO_General_Purpose_IO.md)
- [DMA (Direct Memory Access)](DMA_Direct_Memory_Access.md)
- [EXINT (External Interrupt)](EXINT_External_Interrupt.md)

