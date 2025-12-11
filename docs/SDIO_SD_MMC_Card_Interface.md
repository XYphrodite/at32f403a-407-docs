# SDIO (SD/MMC Card Interface) Peripheral - AT32F403A/407

## Table of Contents

1. [Overview](#overview)
2. [Key Features](#key-features)
3. [Supported Card Types](#supported-card-types)
4. [Hardware Interface](#hardware-interface)
5. [Bus Width Modes](#bus-width-modes)
6. [Transfer Modes](#transfer-modes)
7. [Configuration Types](#configuration-types)
8. [Status Flags and Interrupts](#status-flags-and-interrupts)
9. [Register Overview](#register-overview)
10. [Low-Level API Reference](#low-level-api-reference)
11. [SD Card Library API](#sd-card-library-api)
12. [Card Information Structures](#card-information-structures)
13. [Practical Examples](#practical-examples)
14. [DMA Integration](#dma-integration)
15. [Error Handling](#error-handling)
16. [Clock Configuration](#clock-configuration)
17. [FatFs Integration](#fatfs-integration)
18. [Troubleshooting](#troubleshooting)
19. [Important Notes](#important-notes)

---

## Overview

The SDIO (Secure Digital Input Output) peripheral on the AT32F403A/407 microcontroller provides a high-speed interface for SD, SDHC, MMC, and eMMC memory cards. The AT32F403A_R/V and AT32F407 variants include two SDIO interfaces (SDIO1 and SDIO2), while other variants have SDIO2 only.

The SDIO interface supports the SD Memory Card specification, MultiMediaCard specification, and provides flexible data transfer options including polling, interrupt, and DMA modes.

### Key Responsibilities

- **Card Initialization**: Detect card type and initialize communication
- **Data Transfer**: Read/write single or multiple blocks
- **Command Handling**: Send SD/MMC commands and process responses
- **Bus Management**: Configure bus width and clock speed
- **Error Detection**: CRC checking and timeout handling

---

## Key Features

- **Dual SDIO Controllers** (AT32F403A_R/V, AT32F407):
  - SDIO1: Full-featured controller
  - SDIO2: Available on all AT32F403A/407 variants

- **Bus Width Support**:
  - 1-bit data bus (D0)
  - 4-bit data bus (D0-D3)
  - 8-bit data bus (D0-D7) - MMC only

- **Clock Speed**:
  - Initialization: ≤400 kHz
  - Normal operation: Up to 25 MHz
  - High-speed mode: Up to 50 MHz (SD cards)

- **Data Transfer**:
  - Block transfer mode (fixed block sizes)
  - Stream transfer mode (MMC cards)
  - Maximum block size: 16 KB
  - Maximum data length: 16 MB

- **Transfer Options**:
  - Polling mode
  - DMA mode (recommended for performance)

- **Error Detection**:
  - CRC7 for commands
  - CRC16 for data
  - Command/data timeout detection

---

## Supported Card Types

### SD Cards

| Type | Designation | Capacity | Addressing |
|------|-------------|----------|------------|
| SDSC V1.1 | Standard Capacity | Up to 2 GB | Byte addressing |
| SDSC V2.0 | Standard Capacity | Up to 2 GB | Byte addressing |
| SDHC | High Capacity | 2 GB - 32 GB | Block addressing |

### MMC Cards

| Type | Designation | Notes |
|------|-------------|-------|
| MMC | MultiMediaCard | Legacy |
| MMC V4.2+ | High-Speed MMC | Up to 52 MHz |
| eMMC | Embedded MMC | High-capacity, soldered |

### Card Type Enumeration

```c
typedef enum
{
    SDIO_STD_CAPACITY_SD_CARD_V1_1  = 0,   /* SDSC V1.1 */
    SDIO_STD_CAPACITY_SD_CARD_V2_0  = 1,   /* SDSC V2.0 */
    SDIO_HIGH_CAPACITY_SD_CARD      = 2,   /* SDHC */
    SDIO_MULTIMEDIA_CARD            = 3,   /* MMC */
    SDIO_SECURE_DIGITAL_IO_CARD     = 4,   /* SDIO card */
    SDIO_HIGH_SPEED_MULTIMEDIA_CARD = 5,   /* MMC V4.2+ */
    SDIO_SECURE_DIGITAL_IO_COMBO_CARD = 6, /* Combo card */
    SDIO_HIGH_CAPACITY_MMC_CARD     = 7,   /* eMMC */
    SDIO_SDIO_CARD                  = 8    /* SDIO only */
} sd_memory_card_type;
```

---

## Hardware Interface

### Pin Configuration

| Signal | SDIO1 Pin | SDIO2 Pin | Description |
|--------|-----------|-----------|-------------|
| CLK | PC12 | PC6 | Clock output |
| CMD | PD2 | PC7 | Command/response |
| D0 | PC8 | PB0 | Data line 0 |
| D1 | PC9 | PA9 | Data line 1 (4-bit mode) |
| D2 | PC10 | PA10 | Data line 2 (4-bit mode) |
| D3 | PC11 | PB2 | Data line 3 (4-bit mode) |
| D4-D7 | - | - | 8-bit mode (MMC only) |

### GPIO Configuration

```c
void sdio_gpio_config(void)
{
    gpio_init_type gpio_init_struct = {0};
    
    /* Enable GPIO clocks */
    crm_periph_clock_enable(CRM_GPIOC_PERIPH_CLOCK, TRUE);
    crm_periph_clock_enable(CRM_GPIOD_PERIPH_CLOCK, TRUE);
    
    /* Configure PC8-PC12: D0, D1, D2, D3, CLK */
    gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
    gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
    gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
    gpio_init_struct.gpio_pins = GPIO_PINS_8 | GPIO_PINS_9 | GPIO_PINS_10 | 
                                  GPIO_PINS_11 | GPIO_PINS_12;
    gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
    gpio_init(GPIOC, &gpio_init_struct);
    
    /* Configure PD2: CMD */
    gpio_init_struct.gpio_pins = GPIO_PINS_2;
    gpio_init(GPIOD, &gpio_init_struct);
}
```

---

## Bus Width Modes

### Available Bus Widths

```c
typedef enum
{
    SDIO_BUS_WIDTH_D1 = 0x00,  /* 1-bit data bus */
    SDIO_BUS_WIDTH_D4 = 0x01,  /* 4-bit data bus */
    SDIO_BUS_WIDTH_D8 = 0x02   /* 8-bit data bus (MMC only) */
} sdio_bus_width_type;
```

### Bus Width Selection

| Mode | Lines | Performance | Card Support |
|------|-------|-------------|--------------|
| 1-bit | D0 only | Baseline | All cards |
| 4-bit | D0-D3 | 4x throughput | SD, SDHC, some MMC |
| 8-bit | D0-D7 | 8x throughput | MMC/eMMC only |

### Configuring Bus Width

```c
/* Configure 4-bit bus width for SD card */
sd_error_status_type status;
status = sd_wide_bus_operation_config(SDIO_BUS_WIDTH_D4);
if(status != SD_OK)
{
    /* Handle error */
}
```

---

## Transfer Modes

### Block Transfer Mode

Used for SD cards and standard MMC operations.

```c
typedef enum
{
    SDIO_DATA_BLOCK_TRANSFER  = 0x00,  /* Block transfer mode */
    SDIO_DATA_STREAM_TRANSFER = 0x01   /* Stream transfer mode */
} sdio_transfer_mode_type;
```

### Block Sizes

```c
typedef enum
{
    SDIO_DATA_BLOCK_SIZE_1B     = 0x00,  /* 1 byte */
    SDIO_DATA_BLOCK_SIZE_2B     = 0x01,  /* 2 bytes */
    SDIO_DATA_BLOCK_SIZE_4B     = 0x02,  /* 4 bytes */
    SDIO_DATA_BLOCK_SIZE_8B     = 0x03,  /* 8 bytes */
    SDIO_DATA_BLOCK_SIZE_16B    = 0x04,  /* 16 bytes */
    SDIO_DATA_BLOCK_SIZE_32B    = 0x05,  /* 32 bytes */
    SDIO_DATA_BLOCK_SIZE_64B    = 0x06,  /* 64 bytes */
    SDIO_DATA_BLOCK_SIZE_128B   = 0x07,  /* 128 bytes */
    SDIO_DATA_BLOCK_SIZE_256B   = 0x08,  /* 256 bytes */
    SDIO_DATA_BLOCK_SIZE_512B   = 0x09,  /* 512 bytes (standard) */
    SDIO_DATA_BLOCK_SIZE_1024B  = 0x0A,  /* 1024 bytes */
    SDIO_DATA_BLOCK_SIZE_2048B  = 0x0B,  /* 2048 bytes */
    SDIO_DATA_BLOCK_SIZE_4096B  = 0x0C,  /* 4096 bytes */
    SDIO_DATA_BLOCK_SIZE_8192B  = 0x0D,  /* 8192 bytes */
    SDIO_DATA_BLOCK_SIZE_16384B = 0x0E   /* 16384 bytes */
} sdio_block_size_type;
```

**Note**: Standard SD cards use 512-byte blocks.

### Transfer Direction

```c
typedef enum
{
    SDIO_DATA_TRANSFER_TO_CARD       = 0x00,  /* Write to card */
    SDIO_DATA_TRANSFER_TO_CONTROLLER = 0x01   /* Read from card */
} sdio_transfer_direction_type;
```

---

## Configuration Types

### Power State

```c
typedef enum
{
    SDIO_POWER_OFF = 0x00,  /* Power off, clock stopped */
    SDIO_POWER_ON  = 0x03   /* Power on, card is clocked */
} sdio_power_state_type;
```

### Clock Edge

```c
typedef enum
{
    SDIO_CLOCK_EDGE_RISING  = 0x00,  /* Clock on rising edge */
    SDIO_CLOCK_EDGE_FALLING = 0x01   /* Clock on falling edge */
} sdio_edge_phase_type;
```

### Response Type

```c
typedef enum
{
    SDIO_RESPONSE_NO    = 0x00,  /* No response */
    SDIO_RESPONSE_SHORT = 0x01,  /* Short response (48 bits) */
    SDIO_RESPONSE_LONG  = 0x03   /* Long response (136 bits) */
} sdio_reponse_type;
```

### Command Structure

```c
typedef struct
{
    uint32_t           argument;   /* Command argument */
    uint8_t            cmd_index;  /* Command index (0-63) */
    sdio_reponse_type  rsp_type;   /* Response type */
    sdio_wait_type     wait_type;  /* Wait condition */
} sdio_command_struct_type;
```

### Data Structure

```c
typedef struct
{
    uint32_t                       timeout;            /* Data timeout */
    uint32_t                       data_length;        /* Total data length */
    sdio_block_size_type           block_size;         /* Block size */
    sdio_transfer_mode_type        transfer_mode;      /* Block or stream */
    sdio_transfer_direction_type   transfer_direction; /* Read or write */
} sdio_data_struct_type;
```

---

## Status Flags and Interrupts

### Status Flags

```c
/* Command Flags */
#define SDIO_CMDFAIL_FLAG      ((uint32_t)0x00000001)  /* Command CRC failed */
#define SDIO_CMDTIMEOUT_FLAG   ((uint32_t)0x00000004)  /* Command timeout */
#define SDIO_CMDRSPCMPL_FLAG   ((uint32_t)0x00000040)  /* Response received */
#define SDIO_CMDCMPL_FLAG      ((uint32_t)0x00000080)  /* Command sent */

/* Data Flags */
#define SDIO_DTFAIL_FLAG       ((uint32_t)0x00000002)  /* Data CRC failed */
#define SDIO_DTTIMEOUT_FLAG    ((uint32_t)0x00000008)  /* Data timeout */
#define SDIO_TXERRU_FLAG       ((uint32_t)0x00000010)  /* TX underrun */
#define SDIO_RXERRO_FLAG       ((uint32_t)0x00000020)  /* RX overrun */
#define SDIO_DTCMPL_FLAG       ((uint32_t)0x00000100)  /* Data complete */
#define SDIO_SBITERR_FLAG      ((uint32_t)0x00000200)  /* Start bit error */
#define SDIO_DTBLKCMPL_FLAG    ((uint32_t)0x00000400)  /* Data block complete */

/* Buffer Flags */
#define SDIO_TXBUFH_FLAG       ((uint32_t)0x00004000)  /* TX buffer half empty */
#define SDIO_RXBUFH_FLAG       ((uint32_t)0x00008000)  /* RX buffer half full */
#define SDIO_TXBUFF_FLAG       ((uint32_t)0x00010000)  /* TX buffer full */
#define SDIO_RXBUFF_FLAG       ((uint32_t)0x00020000)  /* RX buffer full */
#define SDIO_TXBUFE_FLAG       ((uint32_t)0x00040000)  /* TX buffer empty */
#define SDIO_RXBUFE_FLAG       ((uint32_t)0x00080000)  /* RX buffer empty */
#define SDIO_TXBUF_FLAG        ((uint32_t)0x00100000)  /* TX data available */
#define SDIO_RXBUF_FLAG        ((uint32_t)0x00200000)  /* RX data available */
```

### Interrupt Enables

Matching interrupt enables exist for all flags:

```c
#define SDIO_CMDFAIL_INT       ((uint32_t)0x00000001)
#define SDIO_DTFAIL_INT        ((uint32_t)0x00000002)
#define SDIO_CMDTIMEOUT_INT    ((uint32_t)0x00000004)
#define SDIO_DTTIMEOUT_INT     ((uint32_t)0x00000008)
/* ... etc ... */
```

---

## Register Overview

### SDIO Register Structure

```c
typedef struct
{
    union {
        __IO uint32_t pwrctrl;     /* Power control, offset: 0x00 */
        struct {
            __IO uint32_t ps : 2;   /* Power state */
            __IO uint32_t reserved1 : 30;
        } pwrctrl_bit;
    };
    
    union {
        __IO uint32_t clkctrl;     /* Clock control, offset: 0x04 */
        struct {
            __IO uint32_t clkdiv_l : 8;  /* Clock divider [7:0] */
            __IO uint32_t clkoen   : 1;  /* Clock output enable */
            __IO uint32_t pwrsven  : 1;  /* Power saving enable */
            __IO uint32_t bypsen   : 1;  /* Bypass enable */
            __IO uint32_t busws    : 2;  /* Bus width select */
            __IO uint32_t clkegs   : 1;  /* Clock edge select */
            __IO uint32_t hfcen    : 1;  /* Hardware flow control */
            __IO uint32_t clkdiv_h : 2;  /* Clock divider [9:8] */
            __IO uint32_t reserved1 : 15;
        } clkctrl_bit;
    };
    
    __IO uint32_t argu;            /* Argument register, offset: 0x08 */
    
    union {
        __IO uint32_t cmdctrl;     /* Command control, offset: 0x0C */
        struct {
            __IO uint32_t cmdidx : 6;   /* Command index */
            __IO uint32_t rspwt  : 2;   /* Response type */
            __IO uint32_t intwt  : 1;   /* Interrupt wait */
            __IO uint32_t pndwt  : 1;   /* Pending wait */
            __IO uint32_t ccsmen : 1;   /* CCSM enable */
            __IO uint32_t iosusp : 1;   /* IO suspend */
            __IO uint32_t reserved1 : 20;
        } cmdctrl_bit;
    };
    
    __IO uint32_t rspcmd;          /* Response command, offset: 0x10 */
    __IO uint32_t rsp1;            /* Response 1, offset: 0x14 */
    __IO uint32_t rsp2;            /* Response 2, offset: 0x18 */
    __IO uint32_t rsp3;            /* Response 3, offset: 0x1C */
    __IO uint32_t rsp4;            /* Response 4, offset: 0x20 */
    __IO uint32_t dttmr;           /* Data timeout, offset: 0x24 */
    __IO uint32_t dtlen;           /* Data length, offset: 0x28 */
    
    union {
        __IO uint32_t dtctrl;      /* Data control, offset: 0x2C */
        struct {
            __IO uint32_t tfren   : 1;  /* Transfer enable */
            __IO uint32_t tfrdir  : 1;  /* Transfer direction */
            __IO uint32_t tfrmode : 1;  /* Transfer mode */
            __IO uint32_t dmaen   : 1;  /* DMA enable */
            __IO uint32_t blksize : 4;  /* Block size */
            __IO uint32_t rdwtstart : 1;
            __IO uint32_t rdwtstop  : 1;
            __IO uint32_t rdwtmode  : 1;
            __IO uint32_t ioen      : 1;
            __IO uint32_t reserved1 : 20;
        } dtctrl_bit;
    };
    
    __IO uint32_t dtcnt;           /* Data count, offset: 0x30 */
    __IO uint32_t sts;             /* Status, offset: 0x34 */
    __IO uint32_t intclr;          /* Interrupt clear, offset: 0x38 */
    __IO uint32_t inten;           /* Interrupt enable, offset: 0x3C */
    __IO uint32_t reserved1[2];    /* Reserved, offset: 0x40-0x44 */
    __IO uint32_t bufcnt;          /* Buffer count, offset: 0x48 */
    __IO uint32_t reserved2[13];   /* Reserved, offset: 0x4C-0x7C */
    __IO uint32_t buf;             /* Data buffer (FIFO), offset: 0x80 */
} sdio_type;

#define SDIO1  ((sdio_type *) SDIO1_BASE)
#define SDIO2  ((sdio_type *) SDIO2_BASE)
```

---

## Low-Level API Reference

### Power Control

```c
void sdio_reset(sdio_type *sdio_x);
void sdio_power_set(sdio_type *sdio_x, sdio_power_state_type power_state);
sdio_power_state_type sdio_power_status_get(sdio_type *sdio_x);
```

### Clock Configuration

```c
void sdio_clock_config(sdio_type *sdio_x, uint16_t clk_div, sdio_edge_phase_type clk_edg);
void sdio_clock_bypass(sdio_type *sdio_x, confirm_state new_state);
void sdio_power_saving_mode_enable(sdio_type *sdio_x, confirm_state new_state);
void sdio_flow_control_enable(sdio_type *sdio_x, confirm_state new_state);
void sdio_clock_enable(sdio_type *sdio_x, confirm_state new_state);
```

### Bus Configuration

```c
void sdio_bus_width_config(sdio_type *sdio_x, sdio_bus_width_type width);
```

### Command Functions

```c
void sdio_command_config(sdio_type *sdio_x, sdio_command_struct_type *command_struct);
void sdio_command_state_machine_enable(sdio_type *sdio_x, confirm_state new_state);
uint8_t sdio_command_response_get(sdio_type *sdio_x);
uint32_t sdio_response_get(sdio_type *sdio_x, sdio_rsp_index_type reg_index);
```

### Data Functions

```c
void sdio_data_config(sdio_type *sdio_x, sdio_data_struct_type *data_struct);
void sdio_data_state_machine_enable(sdio_type *sdio_x, confirm_state new_state);
uint32_t sdio_data_counter_get(sdio_type *sdio_x);
uint32_t sdio_data_read(sdio_type *sdio_x);
void sdio_data_write(sdio_type *sdio_x, uint32_t data);
uint32_t sdio_buffer_counter_get(sdio_type *sdio_x);
```

### DMA and Interrupts

```c
void sdio_dma_enable(sdio_type *sdio_x, confirm_state new_state);
void sdio_interrupt_enable(sdio_type *sdio_x, uint32_t int_opt, confirm_state new_state);
flag_status sdio_flag_get(sdio_type *sdio_x, uint32_t flag);
flag_status sdio_interrupt_flag_get(sdio_type *sdio_x, uint32_t flag);
void sdio_flag_clear(sdio_type *sdio_x, uint32_t flag);
```

---

## SD Card Library API

The application-level SD card library provides high-level functions for card operations.

### Initialization

```c
/* Initialize SD/MMC card and SDIO peripheral */
sd_error_status_type sd_init(void);

/* Power on card and detect type */
sd_error_status_type sd_power_on(void);

/* Power off card */
sd_error_status_type sd_power_off(void);

/* Initialize card (get CID, CSD, RCA) */
sd_error_status_type sd_card_init(void);

/* Get card information */
sd_error_status_type sd_card_info_get(sd_card_info_struct_type *card_info);
```

### Configuration

```c
/* Configure bus width (1-bit, 4-bit, or 8-bit) */
sd_error_status_type sd_wide_bus_operation_config(sdio_bus_width_type mode);

/* Set transfer mode (polling or DMA) */
sd_error_status_type sd_device_mode_set(uint32_t mode);

/* Select/deselect card */
sd_error_status_type sd_deselect_select(uint32_t addr);
```

### Read Operations

```c
/* Read single block (512 bytes) */
sd_error_status_type sd_block_read(uint8_t *buf, long long addr, uint16_t blk_size);

/* Read multiple blocks */
sd_error_status_type sd_mult_blocks_read(uint8_t *buf, long long addr, 
                                          uint16_t blk_size, uint32_t nblks);

/* Read MMC stream data */
sd_error_status_type mmc_stream_read(uint8_t *buf, long long addr, uint32_t len);
```

### Write Operations

```c
/* Write single block (512 bytes) */
sd_error_status_type sd_block_write(const uint8_t *buf, long long addr, uint16_t blk_size);

/* Write multiple blocks */
sd_error_status_type sd_mult_blocks_write(const uint8_t *buf, long long addr, 
                                           uint16_t blk_size, uint32_t nblks);

/* Write MMC stream data */
sd_error_status_type mmc_stream_write(uint8_t *buf, long long addr, uint32_t len);
```

### Erase and Status

```c
/* Erase blocks */
sd_error_status_type sd_blocks_erase(long long addr, uint32_t nblks);

/* Get card status */
sd_error_status_type sd_status_send(uint32_t *p_card_status);

/* Get card state */
sd_card_state_type sd_state_get(void);
```

### Interrupt Service

```c
/* SDIO interrupt handler */
sd_error_status_type sd_irq_service(void);
```

---

## Card Information Structures

### Card Information

```c
typedef struct
{
    sd_csd_struct_type sd_csd_reg;   /* CSD register data */
    sd_cid_struct_type sd_cid_reg;   /* CID register data */
    sd_scr_struct_type sd_scr_reg;   /* SCR register data (SD only) */
    long long card_capacity;          /* Card capacity in bytes */
    uint32_t card_blk_size;           /* Block size */
    uint16_t rca;                     /* Relative card address */
    uint8_t card_type;                /* Card type enumeration */
} sd_card_info_struct_type;

extern sd_card_info_struct_type sd_card_info;
```

### CSD Register

```c
typedef struct
{
    uint8_t  csd_struct;               /* CSD structure version */
    uint8_t  spec_version;             /* System specification version */
    uint8_t  taac;                     /* Data read access time 1 */
    uint8_t  nsac;                     /* Data read access time 2 (CLK cycles) */
    uint8_t  max_bus_clk_freq;         /* Max bus clock frequency */
    uint16_t card_cmd_classes;         /* Card command classes */
    uint8_t  max_read_blk_length;      /* Max read block length */
    uint32_t device_size;              /* Device size */
    uint8_t  device_size_mult;         /* Device size multiplier */
    /* ... additional fields ... */
} sd_csd_struct_type;
```

### CID Register

```c
typedef struct
{
    uint8_t  manufacturer_id;          /* Manufacturer ID */
    uint16_t oem_app_id;               /* OEM/Application ID */
    uint32_t product_name1;            /* Product name part 1 */
    uint8_t  product_name2;            /* Product name part 2 */
    uint8_t  product_reversion;        /* Product revision */
    uint32_t product_sn;               /* Product serial number */
    uint16_t manufact_date;            /* Manufacturing date */
    uint8_t  cid_crc;                  /* CID CRC */
} sd_cid_struct_type;
```

---

## Practical Examples

### Example 1: Basic SD Card Initialization and Read/Write

```c
#include "at32_sdio.h"

#define BLOCK_SIZE 512

uint8_t write_buffer[BLOCK_SIZE];
uint8_t read_buffer[BLOCK_SIZE];

int main(void)
{
    sd_error_status_type status;
    
    system_clock_config();
    at32_board_init();
    
    /* Configure NVIC for SDIO interrupt */
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    nvic_irq_enable(SDIO1_IRQn, 1, 0);
    
    uart_print_init(115200);
    printf("SD Card Test\r\n");
    
    /* Initialize SD card */
    status = sd_init();
    if(status != SD_OK)
    {
        printf("SD init failed: %d\r\n", status);
        while(1);
    }
    printf("SD init OK\r\n");
    
    /* Print card information */
    printf("Card Type: %d\r\n", sd_card_info.card_type);
    printf("Capacity: %u MB\r\n", (uint32_t)(sd_card_info.card_capacity >> 20));
    printf("Block Size: %d\r\n", sd_card_info.card_blk_size);
    
    /* Prepare test data */
    for(int i = 0; i < BLOCK_SIZE; i++)
    {
        write_buffer[i] = i & 0xFF;
    }
    
    /* Write single block to address 0 */
    status = sd_block_write(write_buffer, 0, BLOCK_SIZE);
    if(status != SD_OK)
    {
        printf("Write failed: %d\r\n", status);
        while(1);
    }
    printf("Write OK\r\n");
    
    /* Read single block from address 0 */
    status = sd_block_read(read_buffer, 0, BLOCK_SIZE);
    if(status != SD_OK)
    {
        printf("Read failed: %d\r\n", status);
        while(1);
    }
    printf("Read OK\r\n");
    
    /* Verify data */
    if(memcmp(write_buffer, read_buffer, BLOCK_SIZE) == 0)
    {
        printf("Data verification PASSED\r\n");
    }
    else
    {
        printf("Data verification FAILED\r\n");
    }
    
    while(1);
}
```

### Example 2: Multiple Block Read/Write

```c
#define BLOCKS_NUMBER 64
#define MULTI_BUFFER_SIZE (BLOCK_SIZE * BLOCKS_NUMBER)

uint8_t mblock_tbuffer[MULTI_BUFFER_SIZE];
uint8_t mblock_rbuffer[MULTI_BUFFER_SIZE];

void multiple_block_test(void)
{
    sd_error_status_type status;
    
    /* Fill buffer with test pattern */
    memset(mblock_tbuffer, 0x3C, MULTI_BUFFER_SIZE);
    memset(mblock_rbuffer, 0, MULTI_BUFFER_SIZE);
    
    /* Configure 4-bit bus width for better performance */
    status = sd_wide_bus_operation_config(SDIO_BUS_WIDTH_D4);
    if(status != SD_OK)
    {
        printf("Bus width config failed\r\n");
        return;
    }
    
    /* Write multiple blocks (64 blocks = 32KB) */
    status = sd_mult_blocks_write(mblock_tbuffer, 0, BLOCK_SIZE, BLOCKS_NUMBER);
    if(status != SD_OK)
    {
        printf("Multi-block write failed: %d\r\n", status);
        return;
    }
    printf("Multi-block write OK\r\n");
    
    /* Read multiple blocks */
    status = sd_mult_blocks_read(mblock_rbuffer, 0, BLOCK_SIZE, BLOCKS_NUMBER);
    if(status != SD_OK)
    {
        printf("Multi-block read failed: %d\r\n", status);
        return;
    }
    printf("Multi-block read OK\r\n");
    
    /* Verify */
    if(memcmp(mblock_tbuffer, mblock_rbuffer, MULTI_BUFFER_SIZE) == 0)
    {
        printf("Multi-block verification PASSED\r\n");
    }
}
```

### Example 3: Displaying Card Information

```c
void show_card_info(void)
{
    printf("---------------------\r\n");
    
    /* Display card type */
    switch(sd_card_info.card_type)
    {
        case SDIO_STD_CAPACITY_SD_CARD_V1_1:  
            printf("Card Type: SDSC V1.1\r\n"); break;
        case SDIO_STD_CAPACITY_SD_CARD_V2_0:  
            printf("Card Type: SDSC V2.0\r\n"); break;
        case SDIO_HIGH_CAPACITY_SD_CARD:      
            printf("Card Type: SDHC V2.0\r\n"); break;
        case SDIO_MULTIMEDIA_CARD:            
            printf("Card Type: MMC\r\n"); break;
        case SDIO_HIGH_SPEED_MULTIMEDIA_CARD: 
            printf("Card Type: MMC V4.2+\r\n"); break;
        case SDIO_HIGH_CAPACITY_MMC_CARD:     
            printf("Card Type: eMMC\r\n"); break;
        default:
            printf("Card Type: Unknown\r\n"); break;
    }
    
    printf("Manufacturer ID: %d\r\n", sd_card_info.sd_cid_reg.manufacturer_id);
    printf("RCA: 0x%X\r\n", sd_card_info.rca);
    printf("Device Size: %u\r\n", sd_card_info.sd_csd_reg.device_size);
    printf("Capacity: %u MB\r\n", (uint32_t)(sd_card_info.card_capacity >> 20));
    printf("Block Size: %d bytes\r\n", sd_card_info.card_blk_size);
    printf("---------------------\r\n");
}
```

### Example 4: SDIO Interrupt Handler

```c
void SDIO1_IRQHandler(void)
{
    sd_irq_service();
}

void SDIO2_IRQHandler(void)
{
    sd_irq_service();
}

/* The sd_irq_service() function handles:
 * - Data transfer complete
 * - Data CRC error
 * - Data timeout
 * - RX overrun
 * - TX underrun
 * - Start bit error
 */
```

---

## DMA Integration

### DMA Configuration for SDIO

```c
void sd_dma_config(uint32_t *mbuf, uint32_t buf_size, dma_dir_type dir)
{
    dma_init_type dma_init_struct;
    dma_default_para_init(&dma_init_struct);
    
    /* Enable DMA2 clock */
    crm_periph_clock_enable(CRM_DMA2_PERIPH_CLOCK, TRUE);
    
    /* Reset and configure DMA2 Channel 4 for SDIO1 */
    dma_reset(DMA2_CHANNEL4);
    dma_channel_enable(DMA2_CHANNEL4, FALSE);
    
    dma_init_struct.peripheral_base_addr = (uint32_t)&SDIO1->buf;
    dma_init_struct.memory_base_addr = (uint32_t)mbuf;
    dma_init_struct.direction = dir;  /* DMA_DIR_PERIPHERAL_TO_MEMORY or DMA_DIR_MEMORY_TO_PERIPHERAL */
    dma_init_struct.buffer_size = buf_size / 4;  /* Word count */
    dma_init_struct.peripheral_inc_enable = FALSE;
    dma_init_struct.memory_inc_enable = TRUE;
    dma_init_struct.peripheral_data_width = DMA_PERIPHERAL_DATA_WIDTH_WORD;
    dma_init_struct.memory_data_width = DMA_MEMORY_DATA_WIDTH_WORD;
    dma_init_struct.loop_mode_enable = FALSE;
    dma_init_struct.priority = DMA_PRIORITY_HIGH;
    dma_init(DMA2_CHANNEL4, &dma_init_struct);
    
    dma_channel_enable(DMA2_CHANNEL4, TRUE);
}
```

### DMA Channel Mapping

| SDIO | DMA | Channel | Notes |
|------|-----|---------|-------|
| SDIO1 | DMA2 | Channel 4 | Default mapping |
| SDIO2 | DMA2 | Flexible | Use DMA flexible function |

---

## Error Handling

### Error Status Enumeration

```c
typedef enum
{
    SD_OK = 0,                      /* No error */
    
    /* SDIO specific errors */
    SD_CMD_FAIL = 1,                /* Command CRC failed */
    SD_DATA_FAIL = 2,               /* Data CRC failed */
    SD_CMD_RSP_TIMEOUT = 3,         /* Command response timeout */
    SD_DATA_TIMEOUT = 4,            /* Data timeout */
    SD_TX_UNDERRUN = 5,             /* TX FIFO underrun */
    SD_RX_OVERRUN = 6,              /* RX FIFO overrun */
    SD_START_BIT_ERR = 7,           /* Start bit error */
    
    /* Card errors */
    SD_CMD_OUT_OF_RANGE = 8,        /* Argument out of range */
    SD_ADDR_MISALIGNED = 9,         /* Misaligned address */
    SD_BLK_LEN_ERR = 10,            /* Block length error */
    SD_ERASE_SEQ_ERR = 11,          /* Erase sequence error */
    SD_WR_PROTECT_VIOLATION = 13,   /* Write protect violation */
    SD_LOCK_UNLOCK_ERROR = 14,      /* Lock/unlock failed */
    SD_ILLEGAL_CMD = 16,            /* Illegal command */
    SD_CARD_ECC_ERROR = 17,         /* Card ECC failed */
    
    /* Driver errors */
    SD_INVALID_PARAMETER = 37,      /* Invalid parameter */
    SD_UNSUPPORTED_FEATURE = 38,    /* Unsupported feature */
    SD_ERROR = 40                   /* General error */
} sd_error_status_type;
```

### Error Handling Pattern

```c
sd_error_status_type status;

status = sd_block_write(buffer, address, BLOCK_SIZE);

switch(status)
{
    case SD_OK:
        /* Success */
        break;
    case SD_CMD_RSP_TIMEOUT:
        printf("Card not responding - check connection\r\n");
        sd_init();  /* Try reinitializing */
        break;
    case SD_DATA_TIMEOUT:
        printf("Data timeout - card may be busy\r\n");
        break;
    case SD_WR_PROTECT_VIOLATION:
        printf("Card is write protected\r\n");
        break;
    default:
        printf("Error: %d\r\n", status);
        break;
}
```

---

## Clock Configuration

### Clock Speed Requirements

| Phase | Maximum Clock | Notes |
|-------|---------------|-------|
| Initialization | 400 kHz | Card identification |
| Normal Speed SD | 25 MHz | Standard operation |
| High-Speed SD | 50 MHz | CMD6 switch required |
| MMC | 26 MHz | Standard MMC |
| High-Speed MMC | 52 MHz | EXT_CSD switch required |

### Clock Divider Calculation

```c
/* SDIO_CK = AHB_CLK / (clk_div + 2) */

/* For 200 kHz initialization (assuming 240 MHz AHB): */
uint32_t init_div = (240000000 / 200000) - 2;  /* = 1198 */

/* For 25 MHz operation: */
uint32_t normal_div = (240000000 / 25000000) - 2;  /* = 7.6 ≈ 8 */

/* Set clock divider */
void sdio_clock_set(uint32_t clk_div)
{
    SDIOx->clkctrl_bit.clkdiv_l = (clk_div & 0xFF);
    SDIOx->clkctrl_bit.clkdiv_h = ((clk_div & 0x300) >> 8);
}
```

---

## FatFs Integration

The SDIO peripheral can be integrated with FatFs filesystem library. A separate example (`sdio_fatfs`) demonstrates this integration.

### FatFs Disk I/O Functions

```c
/* diskio.c implementation */
DSTATUS disk_initialize(BYTE pdrv)
{
    if(sd_init() == SD_OK)
        return RES_OK;
    return STA_NOINIT;
}

DRESULT disk_read(BYTE pdrv, BYTE* buff, LBA_t sector, UINT count)
{
    sd_error_status_type status;
    
    if(count == 1)
    {
        status = sd_block_read(buff, sector * 512, 512);
    }
    else
    {
        status = sd_mult_blocks_read(buff, sector * 512, 512, count);
    }
    
    return (status == SD_OK) ? RES_OK : RES_ERROR;
}

DRESULT disk_write(BYTE pdrv, const BYTE* buff, LBA_t sector, UINT count)
{
    sd_error_status_type status;
    
    if(count == 1)
    {
        status = sd_block_write(buff, sector * 512, 512);
    }
    else
    {
        status = sd_mult_blocks_write(buff, sector * 512, 512, count);
    }
    
    return (status == SD_OK) ? RES_OK : RES_ERROR;
}
```

---

## Troubleshooting

### Common Issues and Solutions

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| Init fails | Card not inserted | Check physical connection |
| | Wrong voltage | Verify 3.3V supply |
| | Clock too fast | Reduce init clock to 200 kHz |
| | Incorrect GPIO | Verify pin configuration |
| CMD timeout | Card not responding | Check card, try different card |
| | Clock not running | Verify clock enable |
| Data CRC error | Signal integrity | Add pull-up resistors (10K-50K) |
| | Clock too fast | Reduce clock speed |
| | Long wiring | Shorten connections |
| TX underrun | DMA not configured | Enable DMA mode |
| | Buffer not ready | Ensure data available before transfer |
| RX overrun | CPU too slow | Use DMA mode |
| | Not reading fast enough | Increase priority or use DMA |
| 4-bit mode fails | Card doesn't support | Verify SCR register |
| | Incorrect configuration | Check ACMD6 response |

### Debug Checklist

1. **Power**: Verify 3.3V supply to card
2. **Clock**: Check SDIO_CK signal with oscilloscope
3. **CMD Line**: Verify command/response timing
4. **Pull-ups**: Install 10K-47K pull-ups on D0-D3 and CMD
5. **Initialization**: Ensure clock ≤400 kHz during init
6. **Card Type**: Check if card type is detected correctly
7. **Addressing**: Use block addresses for SDHC, byte for SDSC

---

## Important Notes

1. **Initialization Clock**: Always use ≤400 kHz for card identification. Increase after card is initialized.

2. **Block Alignment**: For SDHC cards, addresses are block-aligned (multiply by 512 internally). The library handles this automatically.

3. **DMA Mode Recommended**: For multi-block transfers, DMA mode provides better performance and reliability.

4. **4-bit Bus Width**: Always try to use 4-bit mode for better throughput. Check SCR register to verify card support.

5. **Card Busy State**: After write operations, the card may be busy. The library waits for ready state.

6. **Power Cycling**: Some cards may require power cycling for recovery from error states.

7. **SDHC vs SDSC Addressing**:
   - SDSC: Byte addressing
   - SDHC/SDXC: Block addressing (512-byte blocks)
   - The library handles this transparently

8. **eMMC Support**: eMMC cards use MMC protocol. Check `sd_card_info.card_type` for `SDIO_HIGH_CAPACITY_MMC_CARD`.

9. **Hardware Flow Control**: Enable for reliable high-speed transfers to prevent buffer overrun/underrun.

10. **Multiple SDIO Controllers**: AT32F403A_R/V and AT32F407 have SDIO1 and SDIO2. Choose based on pin availability.

---

## References

- AT32F403A/407 Reference Manual
- AT32F403A/407 Datasheet
- SD Specifications Part 1 - Physical Layer Simplified Specification
- MultiMediaCard System Specification
- FatFs Generic FAT Filesystem Module

