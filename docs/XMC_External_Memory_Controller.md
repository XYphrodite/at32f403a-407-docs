# XMC (External Memory Controller) - AT32F403A/407

## Overview

The AT32F403A/407 microcontroller features an **External Memory Controller (XMC)** that provides a flexible interface for connecting various types of external memories and peripherals. The XMC supports NOR Flash, SRAM, PSRAM, and NAND Flash memories, as well as memory-mapped peripherals like LCDs.

## Key Features

- **Multiple Memory Banks**:
  - Bank1: NOR Flash / SRAM / PSRAM (Subbank1 and Subbank4)
  - Bank2: NAND Flash
- **Flexible Bus Width**: 8-bit or 16-bit data bus
- **Address/Data Multiplexing**: Reduces pin count for memories with multiplexed bus
- **Programmable Timing**: Configurable setup, hold, and access times
- **Multiple Access Modes**: A, B, C, D for different memory types
- **NAND Features**:
  - Hardware ECC calculation (256B to 8KB page sizes)
  - Wait operation support
  - Interrupt support (edge/level detection)
- **Burst Mode**: For synchronous memories
- **Wait Signal Support**: For slow memories

## Memory Map

| Bank | Subbank | Address Range | Size | Usage |
|------|---------|---------------|------|-------|
| Bank1 | NOR/SRAM1 | 0x6000_0000 - 0x63FF_FFFF | 64 MB | NOR/SRAM/PSRAM |
| Bank1 | NOR/SRAM2 | 0x6400_0000 - 0x67FF_FFFF | 64 MB | NOR/SRAM/PSRAM |
| Bank1 | NOR/SRAM3 | 0x6800_0000 - 0x6BFF_FFFF | 64 MB | NOR/SRAM/PSRAM |
| Bank1 | NOR/SRAM4 | 0x6C00_0000 - 0x6FFF_FFFF | 64 MB | NOR/SRAM/PSRAM/LCD |
| Bank2 | NAND | 0x7000_0000 - 0x73FF_FFFF | 64 MB | NAND Flash |

---

## Register Structure

### Base Addresses

| Register Bank | Base Address |
|---------------|--------------|
| XMC_BANK1     | 0xA0000000   |
| XMC_BANK2     | 0xA0000060   |

### Bank1 Register Map (NOR/SRAM)

| Offset | Register | Description |
|--------|----------|-------------|
| 0x00 + 0x08×n | BK1CTRL[n] | Bank1 Control Register (n=0,3) |
| 0x04 + 0x08×n | BK1TMG[n] | Bank1 Timing Register (n=0,3) |
| 0x104 + 0x08×n | BK1TMGWR[n] | Bank1 Write Timing Register (n=0,3) |
| 0x220 + 0x04×n | EXT[n] | Extended Timing Register (n=0,3) |

### Bank2 Register Map (NAND)

| Offset | Register | Description |
|--------|----------|-------------|
| 0x60 | BK2CTRL | Bank2 Control Register |
| 0x64 | BK2IS | Bank2 Interrupt Status Register |
| 0x68 | BK2TMGMEM | Bank2 Common Memory Timing Register |
| 0x6C | BK2TMGATT | Bank2 Attribute Memory Timing Register |
| 0x74 | BK2ECC | Bank2 ECC Result Register |

### Register Definitions

```c
/**
 * @brief XMC Bank1 Control and Timing Register Group
 */
typedef struct
{
  union
  {
    __IO uint32_t bk1ctrl;
    struct
    {
      __IO uint32_t en        : 1;  /* [0] Memory bank enable */
      __IO uint32_t admuxen   : 1;  /* [1] Address/data multiplexing enable */
      __IO uint32_t dev       : 2;  /* [3:2] Device type */
      __IO uint32_t extmdbw   : 2;  /* [5:4] External memory data bus width */
      __IO uint32_t noren     : 1;  /* [6] NOR Flash enable */
      __IO uint32_t reserved1 : 1;  /* [7] Reserved */
      __IO uint32_t syncben   : 1;  /* [8] Synchronous burst enable */
      __IO uint32_t nwpol     : 1;  /* [9] NWAIT polarity */
      __IO uint32_t wrapen    : 1;  /* [10] Wrapped mode enable */
      __IO uint32_t nwtcfg    : 1;  /* [11] NWAIT timing configuration */
      __IO uint32_t wen       : 1;  /* [12] Write enable */
      __IO uint32_t nwsen     : 1;  /* [13] NWAIT signal enable */
      __IO uint32_t rwtd      : 1;  /* [14] Read/write timing different */
      __IO uint32_t nwasen    : 1;  /* [15] Asynchronous wait enable */
      __IO uint32_t crpgs     : 3;  /* [18:16] CRAM page size */
      __IO uint32_t mwmc      : 1;  /* [19] Memory write mode control */
      __IO uint32_t reserved2 : 12; /* [31:20] Reserved */
    } bk1ctrl_bit;
  };

  union
  {
    __IO uint32_t bk1tmg;
    struct
    {
      __IO uint32_t addrst    : 4;  /* [3:0] Address setup time */
      __IO uint32_t addrht    : 4;  /* [7:4] Address hold time */
      __IO uint32_t dtst      : 8;  /* [15:8] Data setup time */
      __IO uint32_t buslat    : 4;  /* [19:16] Bus turnaround latency */
      __IO uint32_t clkpsc    : 4;  /* [23:20] Clock prescaler */
      __IO uint32_t dtlat     : 4;  /* [27:24] Data latency */
      __IO uint32_t asyncm    : 2;  /* [29:28] Access mode */
      __IO uint32_t reserved1 : 2;  /* [31:30] Reserved */
    } bk1tmg_bit;
  };
} xmc_bank1_ctrl_tmg_reg_type;

/**
 * @brief XMC Bank2 (NAND) Register Structure
 */
typedef struct
{
  union
  {
    __IO uint32_t bk2ctrl;
    struct
    {
      __IO uint32_t reserved1 : 1;  /* [0] Reserved */
      __IO uint32_t nwen      : 1;  /* [1] NAND wait enable */
      __IO uint32_t en        : 1;  /* [2] Memory bank enable */
      __IO uint32_t dev       : 1;  /* [3] Device type */
      __IO uint32_t extmdbw   : 2;  /* [5:4] External memory data bus width */
      __IO uint32_t eccen     : 1;  /* [6] ECC enable */
      __IO uint32_t reserved2 : 2;  /* [8:7] Reserved */
      __IO uint32_t tcr       : 4;  /* [12:9] CLE to RE delay */
      __IO uint32_t tar       : 4;  /* [16:13] ALE to RE delay */
      __IO uint32_t eccpgs    : 3;  /* [19:17] ECC page size */
      __IO uint32_t reserved3 : 12; /* [31:20] Reserved */
    } bk2ctrl_bit;
  };

  union
  {
    __IO uint32_t bk2is;
    struct
    {
      __IO uint32_t res       : 1;  /* [0] Rising edge status */
      __IO uint32_t hls       : 1;  /* [1] High-level status */
      __IO uint32_t fes       : 1;  /* [2] Falling edge status */
      __IO uint32_t reien     : 1;  /* [3] Rising edge interrupt enable */
      __IO uint32_t hlien     : 1;  /* [4] High-level interrupt enable */
      __IO uint32_t feien     : 1;  /* [5] Falling edge interrupt enable */
      __IO uint32_t fifoe     : 1;  /* [6] FIFO empty */
      __IO uint32_t reserved1 : 25; /* [31:7] Reserved */
    } bk2is_bit;
  };

  union
  {
    __IO uint32_t bk2tmgmem;
    struct
    {
      __IO uint32_t cmst      : 8;  /* [7:0] Common memory setup time */
      __IO uint32_t cmwt      : 8;  /* [15:8] Common memory wait time */
      __IO uint32_t cmht      : 8;  /* [23:16] Common memory hold time */
      __IO uint32_t cmdhizt   : 8;  /* [31:24] Common memory high-Z time */
    } bk2tmgmem_bit;
  };

  union
  {
    __IO uint32_t bk2tmgatt;
    struct
    {
      __IO uint32_t amst      : 8;  /* [7:0] Attribute memory setup time */
      __IO uint32_t amwt      : 8;  /* [15:8] Attribute memory wait time */
      __IO uint32_t amht      : 8;  /* [23:16] Attribute memory hold time */
      __IO uint32_t amdhizt   : 8;  /* [31:24] Attribute memory high-Z time */
    } bk2tmgatt_bit;
  };

  __IO uint32_t reserved1;

  union
  {
    __IO uint32_t bk2ecc;
    struct
    {
      __IO uint32_t ecc       : 32; /* [31:0] ECC computation result */
    } bk2ecc_bit;
  };
} xmc_bank2_type;

#define XMC_BANK1  ((xmc_bank1_type *) 0xA0000000)
#define XMC_BANK2  ((xmc_bank2_type *) 0xA0000060)
```

---

## Configuration Types

### NOR/SRAM Subbank Selection

```c
typedef enum
{
  XMC_BANK1_NOR_SRAM1 = 0x00,  /* NOR/SRAM Subbank 1 (0x60000000) */
  XMC_BANK1_NOR_SRAM4 = 0x03   /* NOR/SRAM Subbank 4 (0x6C000000) */
} xmc_nor_sram_subbank_type;
```

### Memory Device Type

```c
typedef enum
{
  XMC_DEVICE_SRAM  = 0x00000000,  /* SRAM device */
  XMC_DEVICE_PSRAM = 0x00000004,  /* PSRAM device */
  XMC_DEVICE_NOR   = 0x00000008   /* NOR Flash device */
} xmc_memory_type;
```

### Data Bus Width

```c
typedef enum
{
  XMC_BUSTYPE_8_BITS  = 0x00000000,  /* 8-bit data bus */
  XMC_BUSTYPE_16_BITS = 0x00000010   /* 16-bit data bus */
} xmc_data_width_type;
```

### Access Mode

```c
typedef enum
{
  XMC_ACCESS_MODE_A = 0x00000000,  /* Access mode A */
  XMC_ACCESS_MODE_B = 0x10000000,  /* Access mode B */
  XMC_ACCESS_MODE_C = 0x20000000,  /* Access mode C */
  XMC_ACCESS_MODE_D = 0x30000000   /* Access mode D */
} xmc_access_mode_type;
```

### Address/Data Multiplexing

```c
typedef enum
{
  XMC_DATA_ADDR_MUX_DISABLE = 0x00000000,  /* Address and data separate */
  XMC_DATA_ADDR_MUX_ENABLE  = 0x00000002   /* Address and data multiplexed */
} xmc_data_addr_mux_type;
```

### ECC Page Size (NAND)

```c
typedef enum
{
  XMC_ECC_PAGESIZE_256_BYTES  = 0x00000000,  /* 256 bytes per page */
  XMC_ECC_PAGESIZE_512_BYTES  = 0x00020000,  /* 512 bytes per page */
  XMC_ECC_PAGESIZE_1024_BYTES = 0x00040000,  /* 1024 bytes per page */
  XMC_ECC_PAGESIZE_2048_BYTES = 0x00060000,  /* 2048 bytes per page */
  XMC_ECC_PAGESIZE_4096_BYTES = 0x00080000,  /* 4096 bytes per page */
  XMC_ECC_PAGESIZE_8192_BYTES = 0x000A0000   /* 8192 bytes per page */
} xmc_ecc_pagesize_type;
```

### Interrupt Sources (NAND)

```c
typedef enum
{
  XMC_INT_RISING_EDGE  = 0x00000008,  /* Rising edge detection */
  XMC_INT_LEVEL        = 0x00000010,  /* High-level detection */
  XMC_INT_FALLING_EDGE = 0x00000020   /* Falling edge detection */
} xmc_interrupt_sources_type;

typedef enum
{
  XMC_RISINGEDGE_FLAG  = 0x00000001,  /* Rising edge flag */
  XMC_LEVEL_FLAG       = 0x00000002,  /* High-level flag */
  XMC_FALLINGEDGE_FLAG = 0x00000004,  /* Falling edge flag */
  XMC_FEMPT_FLAG       = 0x00000040   /* FIFO empty flag */
} xmc_interrupt_flag_type;
```

---

## Initialization Structures

### NOR/SRAM Initialization

```c
/**
 * @brief NOR/SRAM timing parameters
 */
typedef struct
{
  xmc_nor_sram_subbank_type subbank;          /* Subbank selection */
  xmc_extended_mode_type write_timing_enable; /* Write timing enable */
  uint32_t addr_setup_time;                   /* Address setup time (0-15) */
  uint32_t addr_hold_time;                    /* Address hold time (1-15) */
  uint32_t data_setup_time;                   /* Data setup time (1-255) */
  uint32_t bus_latency_time;                  /* Bus turnaround time (0-15) */
  uint32_t clk_psc;                           /* Clock prescaler (2-16) */
  uint32_t data_latency_time;                 /* Data latency (2-17) */
  xmc_access_mode_type mode;                  /* Access mode */
} xmc_norsram_timing_init_type;

/**
 * @brief NOR/SRAM initialization structure
 */
typedef struct
{
  xmc_nor_sram_subbank_type subbank;             /* Subbank selection */
  xmc_data_addr_mux_type data_addr_multiplex;    /* Address/data multiplexing */
  xmc_memory_type device;                        /* Memory device type */
  xmc_data_width_type bus_type;                  /* Data bus width */
  xmc_burst_access_mode_type burst_mode_enable;  /* Burst mode enable */
  xmc_asyn_wait_type asynwait_enable;            /* Async wait enable */
  xmc_wait_signal_polarity_type wait_signal_lv;  /* Wait signal polarity */
  xmc_wrap_mode_type wrapped_mode_enable;        /* Wrapped mode enable */
  xmc_wait_timing_type wait_signal_config;       /* Wait signal timing */
  xmc_write_operation_type write_enable;         /* Write operation enable */
  xmc_wait_signal_type wait_signal_enable;       /* Wait signal enable */
  xmc_extended_mode_type write_timing_enable;    /* Write timing enable */
  xmc_write_burst_type write_burst_syn;          /* Write burst synchronous */
} xmc_norsram_init_type;
```

### NAND Initialization

```c
/**
 * @brief NAND timing parameters
 */
typedef struct
{
  xmc_class_bank_type class_bank;  /* NAND bank */
  uint32_t mem_setup_time;         /* Memory setup time (0-254) */
  uint32_t mem_waite_time;         /* Memory wait time (0-254) */
  uint32_t mem_hold_time;          /* Memory hold time (1-254) */
  uint32_t mem_hiz_time;           /* Memory high-Z time (0-254) */
} xmc_nand_timinginit_type;

/**
 * @brief NAND initialization structure
 */
typedef struct
{
  xmc_class_bank_type nand_bank;     /* NAND bank selection */
  xmc_nand_wait_type wait_enable;    /* Wait feature enable */
  xmc_data_width_type bus_type;      /* Data bus width */
  xmc_ecc_enable_type ecc_enable;    /* ECC enable */
  xmc_ecc_pagesize_type ecc_pagesize;/* ECC page size */
  uint32_t delay_time_cycle;         /* CLE to RE delay (0-15) */
  uint32_t delay_time_ar;            /* ALE to RE delay (0-15) */
} xmc_nand_init_type;
```

---

## API Functions

### NOR/SRAM Functions

```c
/**
 * @brief  Reset NOR/SRAM registers to default values
 * @param  xmc_subbank: XMC_BANK1_NOR_SRAM1 or XMC_BANK1_NOR_SRAM4
 */
void xmc_nor_sram_reset(xmc_nor_sram_subbank_type xmc_subbank);

/**
 * @brief  Initialize NOR/SRAM bank
 * @param  xmc_norsram_init_struct: Pointer to initialization structure
 */
void xmc_nor_sram_init(xmc_norsram_init_type* xmc_norsram_init_struct);

/**
 * @brief  Configure NOR/SRAM timing
 * @param  xmc_rw_timing_struct: Read/write timing parameters
 * @param  xmc_w_timing_struct: Write timing parameters (if different)
 */
void xmc_nor_sram_timing_config(xmc_norsram_timing_init_type* xmc_rw_timing_struct,
                                xmc_norsram_timing_init_type* xmc_w_timing_struct);

/**
 * @brief  Fill initialization structure with default values
 */
void xmc_norsram_default_para_init(xmc_norsram_init_type* xmc_nor_sram_init_struct);
void xmc_norsram_timing_default_para_init(xmc_norsram_timing_init_type* xmc_rw_timing_struct,
                                          xmc_norsram_timing_init_type* xmc_w_timing_struct);

/**
 * @brief  Enable or disable NOR/SRAM bank
 */
void xmc_nor_sram_enable(xmc_nor_sram_subbank_type xmc_subbank, confirm_state new_state);

/**
 * @brief  Configure extended timing (bus turnaround)
 * @param  w2w_timing: Write-to-write turnaround
 * @param  r2r_timing: Read-to-read turnaround
 */
void xmc_ext_timing_config(xmc_nor_sram_subbank_type xmc_sub_bank, 
                           uint16_t w2w_timing, uint16_t r2r_timing);
```

### NAND Functions

```c
/**
 * @brief  Reset NAND registers to default values
 */
void xmc_nand_reset(xmc_class_bank_type xmc_bank);

/**
 * @brief  Initialize NAND bank
 */
void xmc_nand_init(xmc_nand_init_type* xmc_nand_init_struct);

/**
 * @brief  Configure NAND timing
 * @param  xmc_regular_spacetiming_struct: Common memory space timing
 * @param  xmc_special_spacetiming_struct: Attribute memory space timing
 */
void xmc_nand_timing_config(xmc_nand_timinginit_type* xmc_regular_spacetiming_struct,
                            xmc_nand_timinginit_type* xmc_special_spacetiming_struct);

/**
 * @brief  Fill initialization structure with default values
 */
void xmc_nand_default_para_init(xmc_nand_init_type* xmc_nand_init_struct);
void xmc_nand_timing_default_para_init(xmc_nand_timinginit_type* xmc_common_spacetiming_struct,
                                       xmc_nand_timinginit_type* xmc_special_spacetiming_struct);

/**
 * @brief  Enable or disable NAND bank
 */
void xmc_nand_enable(xmc_class_bank_type xmc_bank, confirm_state new_state);

/**
 * @brief  Enable or disable NAND ECC
 */
void xmc_nand_ecc_enable(xmc_class_bank_type xmc_bank, confirm_state new_state);

/**
 * @brief  Get ECC computation result
 */
uint32_t xmc_ecc_get(xmc_class_bank_type xmc_bank);

/**
 * @brief  Enable or disable NAND interrupts
 */
void xmc_interrupt_enable(xmc_class_bank_type xmc_bank, 
                          xmc_interrupt_sources_type xmc_int, 
                          confirm_state new_state);

/**
 * @brief  Get flag status
 */
flag_status xmc_flag_status_get(xmc_class_bank_type xmc_bank, 
                                xmc_interrupt_flag_type xmc_flag);

/**
 * @brief  Clear flag
 */
void xmc_flag_clear(xmc_class_bank_type xmc_bank, xmc_interrupt_flag_type xmc_flag);
```

---

## Usage Examples

### Example 1: PSRAM Interface (16-bit)

```c
#include "at32f403a_407.h"

#define PSRAM_BASE_ADDR  0x60000000

/**
 * @brief Initialize PSRAM on Bank1 Subbank1
 */
void psram_init(void)
{
  xmc_norsram_init_type xmc_norsram_init_struct;
  xmc_norsram_timing_init_type rw_timing_struct, w_timing_struct;
  gpio_init_type gpio_init_struct;

  /* Enable clocks */
  crm_periph_clock_enable(CRM_XMC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOD_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOE_PERIPH_CLOCK, TRUE);

  /* Configure GPIO pins for XMC */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;

  /* GPIOD: D0-D3, D13-D15 (data), A16-A18 (address), NOE, NWE */
  gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1 | GPIO_PINS_7 | GPIO_PINS_8 |
                               GPIO_PINS_9 | GPIO_PINS_10 | GPIO_PINS_14 | GPIO_PINS_15 |
                               GPIO_PINS_11 | GPIO_PINS_12 | GPIO_PINS_13 |
                               GPIO_PINS_4 | GPIO_PINS_5;
  gpio_init(GPIOD, &gpio_init_struct);

  /* GPIOE: D4-D15 (data), NBL0, NBL1 */
  gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1 | GPIO_PINS_3 |
                               GPIO_PINS_7 | GPIO_PINS_8 | GPIO_PINS_9 | GPIO_PINS_10 |
                               GPIO_PINS_11 | GPIO_PINS_12 | GPIO_PINS_13 |
                               GPIO_PINS_14 | GPIO_PINS_15;
  gpio_init(GPIOE, &gpio_init_struct);

  /* GPIOB: NADV (address valid for multiplexed bus) */
  gpio_init_struct.gpio_pins = GPIO_PINS_7;
  gpio_init(GPIOB, &gpio_init_struct);

  /* Configure XMC for PSRAM */
  xmc_norsram_init_struct.subbank = XMC_BANK1_NOR_SRAM1;
  xmc_norsram_init_struct.data_addr_multiplex = XMC_DATA_ADDR_MUX_ENABLE;
  xmc_norsram_init_struct.device = XMC_DEVICE_PSRAM;
  xmc_norsram_init_struct.bus_type = XMC_BUSTYPE_16_BITS;
  xmc_norsram_init_struct.burst_mode_enable = XMC_BURST_MODE_DISABLE;
  xmc_norsram_init_struct.asynwait_enable = XMC_ASYN_WAIT_DISABLE;
  xmc_norsram_init_struct.wait_signal_lv = XMC_WAIT_SIGNAL_LEVEL_LOW;
  xmc_norsram_init_struct.wrapped_mode_enable = XMC_WRAPPED_MODE_DISABLE;
  xmc_norsram_init_struct.wait_signal_config = XMC_WAIT_SIGNAL_SYN_BEFORE;
  xmc_norsram_init_struct.write_enable = XMC_WRITE_OPERATION_ENABLE;
  xmc_norsram_init_struct.wait_signal_enable = XMC_WAIT_SIGNAL_DISABLE;
  xmc_norsram_init_struct.write_timing_enable = XMC_WRITE_TIMING_DISABLE;
  xmc_norsram_init_struct.write_burst_syn = XMC_WRITE_BURST_SYN_DISABLE;
  xmc_nor_sram_init(&xmc_norsram_init_struct);

  /* Configure timing */
  rw_timing_struct.subbank = XMC_BANK1_NOR_SRAM1;
  rw_timing_struct.mode = XMC_ACCESS_MODE_A;
  rw_timing_struct.write_timing_enable = XMC_WRITE_TIMING_DISABLE;
  rw_timing_struct.addr_setup_time = 0x09;
  rw_timing_struct.addr_hold_time = 0x08;
  rw_timing_struct.data_setup_time = 0x0F;
  rw_timing_struct.data_latency_time = 0x00;
  rw_timing_struct.bus_latency_time = 0x00;
  rw_timing_struct.clk_psc = 0x00;

  w_timing_struct = rw_timing_struct;
  xmc_nor_sram_timing_config(&rw_timing_struct, &w_timing_struct);

  /* Configure bus turnaround */
  xmc_ext_timing_config(XMC_BANK1_NOR_SRAM1, 0x08, 0x08);

  /* Enable XMC bank */
  xmc_nor_sram_enable(XMC_BANK1_NOR_SRAM1, TRUE);
}

/**
 * @brief Write buffer to PSRAM
 */
void psram_write_buffer(uint16_t* buffer, uint32_t addr, uint32_t count)
{
  for(uint32_t i = 0; i < count; i++)
  {
    *(__IO uint16_t *)(PSRAM_BASE_ADDR + addr) = *buffer++;
    addr += 2;
  }
}

/**
 * @brief Read buffer from PSRAM
 */
void psram_read_buffer(uint16_t* buffer, uint32_t addr, uint32_t count)
{
  for(uint32_t i = 0; i < count; i++)
  {
    *buffer++ = *(__IO uint16_t *)(PSRAM_BASE_ADDR + addr);
    addr += 2;
  }
}
```

### Example 2: NAND Flash Interface

```c
#include "at32f403a_407.h"

/* NAND memory map */
#define NAND_BANK_ADDR  0x70000000
#define CMD_AREA        (1 << 16)  /* A16 = CLE */
#define ADDR_AREA       (1 << 17)  /* A17 = ALE */
#define DATA_AREA       0

/* NAND commands */
#define NAND_CMD_READ0       0x00
#define NAND_CMD_READ1       0x30
#define NAND_CMD_WRITE0      0x80
#define NAND_CMD_WRITE1      0x10
#define NAND_CMD_ERASE0      0x60
#define NAND_CMD_ERASE1      0xD0
#define NAND_CMD_READID      0x90
#define NAND_CMD_STATUS      0x70
#define NAND_CMD_RESET       0xFF

typedef struct {
  uint8_t maker_id;
  uint8_t device_id;
  uint8_t third_id;
  uint8_t fourth_id;
} nand_id_type;

/**
 * @brief Initialize NAND Flash on Bank2
 */
void nand_init(void)
{
  gpio_init_type gpio_init_struct;
  xmc_nand_init_type nand_init_struct;
  xmc_nand_timinginit_type regular_timing, special_timing;

  /* Enable clocks */
  crm_periph_clock_enable(CRM_XMC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOD_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOE_PERIPH_CLOCK, TRUE);

  /* Configure GPIO for NAND */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_MODERATE;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;

  /* GPIOD: D0-D3, CLE, ALE, NOE, NWE, NCE2 */
  gpio_init_struct.gpio_pins = GPIO_PINS_0 | GPIO_PINS_1 | GPIO_PINS_4 | GPIO_PINS_5 |
                               GPIO_PINS_7 | GPIO_PINS_11 | GPIO_PINS_12 |
                               GPIO_PINS_14 | GPIO_PINS_15;
  gpio_init(GPIOD, &gpio_init_struct);

  /* GPIOE: D4-D7 */
  gpio_init_struct.gpio_pins = GPIO_PINS_7 | GPIO_PINS_8 | GPIO_PINS_9 | GPIO_PINS_10;
  gpio_init(GPIOE, &gpio_init_struct);

  /* GPIOD: NWAIT (input) */
  gpio_init_struct.gpio_pins = GPIO_PINS_6;
  gpio_init_struct.gpio_mode = GPIO_MODE_INPUT;
  gpio_init(GPIOD, &gpio_init_struct);

  /* Configure XMC for NAND */
  xmc_nand_default_para_init(&nand_init_struct);
  nand_init_struct.nand_bank = XMC_BANK2_NAND;
  nand_init_struct.wait_enable = XMC_WAIT_OPERATION_DISABLE;
  nand_init_struct.bus_type = XMC_BUSTYPE_8_BITS;
  nand_init_struct.ecc_enable = XMC_ECC_OPERATION_DISABLE;
  nand_init_struct.ecc_pagesize = XMC_ECC_PAGESIZE_2048_BYTES;
  nand_init_struct.delay_time_cycle = 0x00;
  nand_init_struct.delay_time_ar = 0x00;
  xmc_nand_init(&nand_init_struct);

  /* Configure timing */
  xmc_nand_timing_default_para_init(&regular_timing, &special_timing);
  regular_timing.class_bank = XMC_BANK2_NAND;
  regular_timing.mem_setup_time = 254;
  regular_timing.mem_waite_time = 254;
  regular_timing.mem_hold_time = 254;
  regular_timing.mem_hiz_time = 254;
  special_timing = regular_timing;
  xmc_nand_timing_config(&regular_timing, &special_timing);

  /* Enable NAND bank */
  xmc_nand_enable(XMC_BANK2_NAND, TRUE);
}

/**
 * @brief Read NAND ID
 */
void nand_read_id(nand_id_type* id)
{
  /* Send Read ID command */
  *(__IO uint8_t *)(NAND_BANK_ADDR | CMD_AREA) = NAND_CMD_READID;
  *(__IO uint8_t *)(NAND_BANK_ADDR | ADDR_AREA) = 0x00;

  /* Read ID bytes */
  id->maker_id  = *(__IO uint8_t *)(NAND_BANK_ADDR | DATA_AREA);
  id->device_id = *(__IO uint8_t *)(NAND_BANK_ADDR | DATA_AREA);
  id->third_id  = *(__IO uint8_t *)(NAND_BANK_ADDR | DATA_AREA);
  id->fourth_id = *(__IO uint8_t *)(NAND_BANK_ADDR | DATA_AREA);
}

/**
 * @brief Reset NAND
 */
void nand_reset(void)
{
  *(__IO uint8_t *)(NAND_BANK_ADDR | CMD_AREA) = NAND_CMD_RESET;
}

/**
 * @brief Read NAND status
 */
uint8_t nand_read_status(void)
{
  *(__IO uint8_t *)(NAND_BANK_ADDR | CMD_AREA) = NAND_CMD_STATUS;
  return *(__IO uint8_t *)(NAND_BANK_ADDR | DATA_AREA);
}

/**
 * @brief Erase NAND block
 */
uint32_t nand_erase_block(uint32_t block_addr)
{
  *(__IO uint8_t *)(NAND_BANK_ADDR | CMD_AREA) = NAND_CMD_ERASE0;
  *(__IO uint8_t *)(NAND_BANK_ADDR | ADDR_AREA) = (block_addr & 0xFF);
  *(__IO uint8_t *)(NAND_BANK_ADDR | ADDR_AREA) = ((block_addr >> 8) & 0xFF);
  *(__IO uint8_t *)(NAND_BANK_ADDR | CMD_AREA) = NAND_CMD_ERASE1;

  /* Wait for operation complete */
  while((nand_read_status() & 0x40) == 0);

  return (nand_read_status() & 0x01) ? 1 : 0;  /* 0=success, 1=error */
}
```

### Example 3: LCD Interface (8-bit)

```c
#include "at32f403a_407.h"

/* LCD memory map using Bank1 Subbank4 */
#define LCD_BASE_ADDR   0x6C000000
#define LCD_CMD_ADDR    (LCD_BASE_ADDR)            /* RS = 0 (command) */
#define LCD_DATA_ADDR   (LCD_BASE_ADDR | 0x10000)  /* RS = 1 (data), A16 high */

/**
 * @brief Initialize XMC for 8-bit LCD
 */
void lcd_xmc_init(void)
{
  gpio_init_type gpio_init_struct;
  xmc_norsram_init_type xmc_norsram_init_struct;
  xmc_norsram_timing_init_type rw_timing_struct, w_timing_struct;

  /* Enable clocks */
  crm_periph_clock_enable(CRM_XMC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOC_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOD_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);

  /* Enable XMC GPIO remap */
  gpio_pin_remap_config(XMC_GMUX_001, TRUE);

  /* Configure GPIO pins */
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;

  /* Configure data bus and control pins */
  /* ... (GPIO configuration as per hardware) ... */

  /* Configure XMC for 8-bit SRAM mode (LCD acts as SRAM) */
  xmc_norsram_default_para_init(&xmc_norsram_init_struct);
  xmc_norsram_init_struct.subbank = XMC_BANK1_NOR_SRAM4;
  xmc_norsram_init_struct.data_addr_multiplex = XMC_DATA_ADDR_MUX_DISABLE;
  xmc_norsram_init_struct.device = XMC_DEVICE_SRAM;
  xmc_norsram_init_struct.bus_type = XMC_BUSTYPE_8_BITS;
  xmc_norsram_init_struct.burst_mode_enable = XMC_BURST_MODE_DISABLE;
  xmc_norsram_init_struct.asynwait_enable = XMC_ASYN_WAIT_DISABLE;
  xmc_norsram_init_struct.wait_signal_lv = XMC_WAIT_SIGNAL_LEVEL_LOW;
  xmc_norsram_init_struct.wrapped_mode_enable = XMC_WRAPPED_MODE_DISABLE;
  xmc_norsram_init_struct.wait_signal_config = XMC_WAIT_SIGNAL_SYN_BEFORE;
  xmc_norsram_init_struct.write_enable = XMC_WRITE_OPERATION_ENABLE;
  xmc_norsram_init_struct.wait_signal_enable = XMC_WAIT_SIGNAL_DISABLE;
  xmc_norsram_init_struct.write_timing_enable = XMC_WRITE_TIMING_ENABLE;
  xmc_norsram_init_struct.write_burst_syn = XMC_WRITE_BURST_SYN_DISABLE;
  xmc_nor_sram_init(&xmc_norsram_init_struct);

  /* Configure timing */
  xmc_norsram_timing_default_para_init(&rw_timing_struct, &w_timing_struct);
  rw_timing_struct.subbank = XMC_BANK1_NOR_SRAM4;
  rw_timing_struct.write_timing_enable = XMC_WRITE_TIMING_ENABLE;
  rw_timing_struct.addr_setup_time = 0x0F;
  rw_timing_struct.addr_hold_time = 0x00;
  rw_timing_struct.data_setup_time = 0x0F;
  rw_timing_struct.bus_latency_time = 0x00;
  rw_timing_struct.clk_psc = 0x00;
  rw_timing_struct.data_latency_time = 0x00;
  rw_timing_struct.mode = XMC_ACCESS_MODE_A;
  w_timing_struct = rw_timing_struct;
  xmc_nor_sram_timing_config(&rw_timing_struct, &w_timing_struct);

  /* Configure bus turnaround */
  xmc_ext_timing_config(XMC_BANK1_NOR_SRAM4, 0x08, 0x08);

  /* Enable XMC bank */
  xmc_nor_sram_enable(XMC_BANK1_NOR_SRAM4, TRUE);
}

/**
 * @brief Write command to LCD
 */
void lcd_write_command(uint8_t cmd)
{
  *(__IO uint8_t *)LCD_CMD_ADDR = cmd;
}

/**
 * @brief Write data to LCD
 */
void lcd_write_data(uint8_t data)
{
  *(__IO uint8_t *)LCD_DATA_ADDR = data;
}

/**
 * @brief Write 16-bit color to LCD (as two 8-bit writes)
 */
void lcd_write_color(uint16_t color)
{
  *(__IO uint8_t *)LCD_DATA_ADDR = (color >> 8);  /* High byte */
  *(__IO uint8_t *)LCD_DATA_ADDR = (color & 0xFF);/* Low byte */
}

/**
 * @brief Clear LCD with specified color
 */
void lcd_clear(uint16_t color)
{
  /* Set window to full screen */
  lcd_write_command(0x2A);  /* Column address set */
  lcd_write_data(0x00); lcd_write_data(0x00);  /* Start column */
  lcd_write_data(0x00); lcd_write_data(0xEF);  /* End column (239) */

  lcd_write_command(0x2B);  /* Row address set */
  lcd_write_data(0x00); lcd_write_data(0x00);  /* Start row */
  lcd_write_data(0x01); lcd_write_data(0x3F);  /* End row (319) */

  lcd_write_command(0x2C);  /* Memory write */

  /* Fill screen */
  for(uint32_t i = 0; i < 240 * 320; i++)
  {
    lcd_write_color(color);
  }
}
```

---

## Timing Considerations

### NOR/SRAM Timing Parameters

```
         ┌────────────────────────────────────────────────┐
         │                 XMC Clock Cycles               │
         ├────────┬────────┬──────────┬──────────┬───────┤
Address  │ADDRST  │        │          │          │       │
─────────┘        └────────┴──────────┴──────────┴───────┘
                  │ADDRHT  │
                  └────────┘
                           │  DTST    │
Data     ─────────────────────────────┴──────────┬───────
(Write)                                          │       │
                                                 └───────┘

ADDRST  = Address Setup Time (0-15 HCLK cycles)
ADDRHT  = Address Hold Time (1-15 HCLK cycles)  
DTST    = Data Setup Time (1-255 HCLK cycles)
BUSLAT  = Bus Turnaround Latency (0-15 HCLK cycles)
```

### NAND Timing Parameters

```
         ┌──────┬────────┬──────┬────────┐
         │SETUP │  WAIT  │ HOLD │ HIGH-Z │
         └──────┴────────┴──────┴────────┘

SETUP   = Memory Setup Time (0-254 HCLK cycles)
WAIT    = Memory Wait Time (0-254 HCLK cycles)
HOLD    = Memory Hold Time (1-254 HCLK cycles)
HIGH-Z  = Data Bus High-Z Time (0-254 HCLK cycles)
```

---

## GPIO Pin Mapping

### Bank1 NOR/SRAM (Default Pins)

| Signal | GPIO | Function |
|--------|------|----------|
| D0     | PD14 | Data bit 0 |
| D1     | PD15 | Data bit 1 |
| D2     | PD0  | Data bit 2 |
| D3     | PD1  | Data bit 3 |
| D4     | PE7  | Data bit 4 |
| D5     | PE8  | Data bit 5 |
| D6     | PE9  | Data bit 6 |
| D7     | PE10 | Data bit 7 |
| D8-D15 | PE11-PE15, PD8-PD10 | Data bits 8-15 |
| A16-A18| PD11-PD13 | Address |
| NOE    | PD4  | Output Enable |
| NWE    | PD5  | Write Enable |
| NE1    | PD7  | Chip Select 1 |
| NE4    | PG12 | Chip Select 4 |
| NBL0   | PE0  | Byte Lane 0 |
| NBL1   | PE1  | Byte Lane 1 |
| NADV   | PB7  | Address Valid (multiplexed) |

### Bank2 NAND (Default Pins)

| Signal | GPIO | Function |
|--------|------|----------|
| D0-D7  | PD14-15, PD0-1, PE7-10 | Data bus |
| CLE    | PD11 | Command Latch Enable (A16) |
| ALE    | PD12 | Address Latch Enable (A17) |
| NCE2   | PD7  | NAND Chip Enable |
| NOE    | PD4  | Output Enable |
| NWE    | PD5  | Write Enable |
| NWAIT  | PD6  | Wait/Ready (input) |

---

## Best Practices

### 1. Clock Configuration

```c
/* Enable XMC clock before any configuration */
crm_periph_clock_enable(CRM_XMC_PERIPH_CLOCK, TRUE);

/* XMC timing is based on HCLK - ensure proper system clock */
```

### 2. Timing Optimization

```c
/* Start with conservative timing, then optimize */
rw_timing_struct.addr_setup_time = 0x0F;  /* Maximum */
rw_timing_struct.data_setup_time = 0xFF;  /* Maximum */

/* After verification, reduce for better performance */
rw_timing_struct.addr_setup_time = 0x03;  /* Optimized */
rw_timing_struct.data_setup_time = 0x08;  /* Optimized */
```

### 3. Memory Verification

```c
/* Always verify memory after initialization */
uint16_t test_pattern = 0xA5A5;
*(__IO uint16_t *)PSRAM_BASE_ADDR = test_pattern;
if(*(__IO uint16_t *)PSRAM_BASE_ADDR != test_pattern)
{
  /* Memory initialization failed */
  while(1);
}
```

### 4. ECC Usage for NAND

```c
/* Enable ECC before write operation */
xmc_nand_ecc_enable(XMC_BANK2_NAND, TRUE);
/* Write data */
/* ... */
/* Read and save ECC value */
uint32_t ecc = xmc_ecc_get(XMC_BANK2_NAND);
xmc_nand_ecc_enable(XMC_BANK2_NAND, FALSE);
```

---

## Troubleshooting

### Common Issues

1. **No Response from Memory**
   - Check XMC clock enabled
   - Verify GPIO configuration (alternate function mode)
   - Check chip select signal routing
   - Verify timing parameters

2. **Data Corruption**
   - Increase data setup time
   - Add bus turnaround delay
   - Check signal integrity
   - Verify voltage levels

3. **NAND ECC Errors**
   - Verify page size setting
   - Check ECC algorithm compatibility
   - Ensure proper page boundaries

4. **LCD Display Issues**
   - Check RS (command/data) signal routing
   - Verify timing for LCD controller
   - Check reset sequence timing

### Debug Tips

```c
/* Verify XMC registers */
printf("BK1CTRL: 0x%08X\n", XMC_BANK1->ctrl_tmg_group[0].bk1ctrl);
printf("BK1TMG:  0x%08X\n", XMC_BANK1->ctrl_tmg_group[0].bk1tmg);

/* Test basic read/write */
volatile uint16_t *mem = (uint16_t *)0x60000000;
*mem = 0x1234;
printf("Read: 0x%04X\n", *mem);
```

---

## Application Notes

- **AN0044**: External Memory Interface Design Guide
- **AN0001**: Getting Started with AT32F403A/407

---

## See Also

- [GPIO (General Purpose I/O)](GPIO_General_Purpose_IO.md)
- [CRM (Clock and Reset Management)](CRM_Clock_Reset_Management.md)
- [DMA (Direct Memory Access)](DMA_Direct_Memory_Access.md)

