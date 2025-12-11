# FLASH - Flash Memory Controller

## Overview

The **Flash Memory Controller (FLASH)** peripheral manages the internal flash memory and external SPI-based memory (SPIM) of the AT32F403A/407 microcontrollers. It provides functions for programming, erasing, reading, and protecting flash memory regions. The flash controller supports dual-bank architecture, user system data (USD) configuration, security library (SLIB) protection, and external SPIM flash memory integration.

| Feature | Specification |
|---------|---------------|
| **Internal Flash Size** | Up to 1024 KB (AT32F403A/407) |
| **Flash Banks** | Bank1 (0x08000000 - 0x0807FFFF), Bank2 (0x08080000 - 0x080FFFFF) |
| **Sector Size** | 2 KB |
| **Programming Width** | Byte, Halfword (16-bit), Word (32-bit) |
| **SPIM Flash** | External SPI flash memory mapped to 0x08400000 |
| **Protection** | FAP (Flash Access Protection), EPP (Erase/Program Protection), SLIB (Security Library) |
| **CRC Calculation** | Hardware CRC for flash sectors |
| **User System Data** | 8 bytes of user-configurable data |

---

## Key Features

- **Dual-Bank Architecture**: Two independent flash banks allowing concurrent read/write operations.
- **Flexible Programming**:
  - Byte, halfword (16-bit), and word (32-bit) programming.
  - Sector erase and mass erase operations.
- **External SPIM Flash**:
  - Memory-mapped access to external SPI flash.
  - Supports two SPIM models for different flash chips.
  - Optional data encryption/scrambling.
- **Flash Protection**:
  - **FAP (Flash Access Protection)**: Prevents unauthorized read-out of flash content.
  - **EPP (Erase/Program Protection)**: Per-sector protection against erase/program operations.
  - **SLIB (Security Library)**: Protects intellectual property by defining protected regions.
- **User System Data (USD)**: Configurable system options (WDT auto-start, reset behavior, boot selection).
- **Hardware CRC**: Built-in CRC calculation for flash sectors.
- **Interrupt Support**: Error and operation-done interrupts for each bank and SPIM.

---

## Memory Map

| Region | Start Address | End Address | Description |
|--------|---------------|-------------|-------------|
| **Bank1** | `0x08000000` | `0x0807FFFF` | 512 KB internal flash |
| **Bank2** | `0x08080000` | `0x080FFFFF` | 512 KB internal flash |
| **SPIM** | `0x08400000` | - | External SPI flash memory |
| **USD** | `0x1FFFF800` | `0x1FFFF81F` | User System Data |

---

## Flash Status Types

```c
typedef enum
{
  FLASH_OPERATE_BUSY    = 0x00, // Flash operation is in progress
  FLASH_PROGRAM_ERROR   = 0x01, // Programming error occurred
  FLASH_EPP_ERROR       = 0x02, // Erase/program protection error
  FLASH_OPERATE_DONE    = 0x03, // Operation completed successfully
  FLASH_OPERATE_TIMEOUT = 0x04  // Operation timed out
} flash_status_type;
```

---

## Register Overview

### Status Registers (STS, STS2, STS3)

| Bit | Name | Description |
|-----|------|-------------|
| 0 | `OBF` | Operate Busy Flag - Flash operation in progress |
| 2 | `PRGMERR` | Program Error Flag |
| 4 | `EPPERR` | Erase/Program Protection Error Flag |
| 5 | `ODF` | Operate Done Flag |

### Control Registers (CTRL, CTRL2, CTRL3)

| Bit | Name | Description |
|-----|------|-------------|
| 0 | `FPRGM` | Flash Program Enable |
| 1 | `SECERS` | Sector Erase Enable |
| 2 | `BANKERS` / `CHPERS` | Bank Erase / Chip Erase (SPIM) Enable |
| 4 | `USDPRGM` | User System Data Program Enable |
| 5 | `USDERS` | User System Data Erase Enable |
| 6 | `ERSTR` | Erase Start |
| 7 | `OPLK` | Operation Lock |
| 10 | `ERRIE` | Error Interrupt Enable |
| 12 | `ODFIE` | Operate Done Interrupt Enable |

---

## API Reference

### Flash Unlock/Lock Functions

#### `void flash_unlock(void)`
Unlocks both Bank1 and Bank2 flash controllers for programming/erasing operations.

```c
flash_unlock();
// Perform flash operations...
flash_lock();
```

#### `void flash_bank1_unlock(void)` / `void flash_bank2_unlock(void)`
Unlocks individual flash banks.

#### `void flash_spim_unlock(void)`
Unlocks the SPIM flash controller for external flash operations.

#### `void flash_lock(void)` / `void flash_bank1_lock(void)` / `void flash_bank2_lock(void)` / `void flash_spim_lock(void)`
Locks the flash controllers to prevent accidental modifications.

---

### Flash Erase Functions

#### `flash_status_type flash_sector_erase(uint32_t sector_address)`
Erases a single flash sector. Automatically selects the correct bank or SPIM based on address.

- `sector_address`: Start address of the sector to erase.
- Returns: Flash operation status.

```c
flash_unlock();
flash_status_type status = flash_sector_erase(0x08010000);
flash_lock();
```

#### `flash_status_type flash_internal_all_erase(void)`
Erases all internal flash sectors (Bank1 and Bank2).

#### `flash_status_type flash_bank1_erase(void)` / `flash_status_type flash_bank2_erase(void)`
Erases all sectors in a specific bank.

#### `flash_status_type flash_spim_all_erase(void)`
Erases the entire external SPIM flash.

#### `flash_status_type flash_user_system_data_erase(void)`
Erases User System Data (USD), preserving the FAP byte.

---

### Flash Program Functions

#### `flash_status_type flash_word_program(uint32_t address, uint32_t data)`
Programs a 32-bit word at the specified address.

- `address`: Target address (word alignment recommended).
- `data`: 32-bit data to program.
- Returns: Flash operation status.

```c
flash_unlock();
flash_word_program(0x08010000, 0x12345678);
flash_lock();
```

#### `flash_status_type flash_halfword_program(uint32_t address, uint16_t data)`
Programs a 16-bit halfword at the specified address.

#### `flash_status_type flash_byte_program(uint32_t address, uint8_t data)`
Programs an 8-bit byte at the specified address.
> **Note**: Byte programming is not supported for SPIM flash.

#### `flash_status_type flash_user_system_data_program(uint32_t address, uint8_t data)`
Programs a byte in the User System Data area.

---

### Flash Status Functions

#### `flag_status flash_flag_get(uint32_t flash_flag)`
Checks if a specific flash flag is set.

Available flags:
- `FLASH_OBF_FLAG` / `FLASH_BANK1_OBF_FLAG` / `FLASH_BANK2_OBF_FLAG` / `FLASH_SPIM_OBF_FLAG`: Operate Busy
- `FLASH_ODF_FLAG` / `FLASH_BANK1_ODF_FLAG` / `FLASH_BANK2_ODF_FLAG` / `FLASH_SPIM_ODF_FLAG`: Operate Done
- `FLASH_PRGMERR_FLAG` / `FLASH_BANK1_PRGMERR_FLAG` / `FLASH_BANK2_PRGMERR_FLAG` / `FLASH_SPIM_PRGMERR_FLAG`: Program Error
- `FLASH_EPPERR_FLAG` / `FLASH_BANK1_EPPERR_FLAG` / `FLASH_BANK2_EPPERR_FLAG` / `FLASH_SPIM_EPPERR_FLAG`: EPP Error
- `FLASH_USDERR_FLAG`: User System Data Error

#### `void flash_flag_clear(uint32_t flash_flag)`
Clears the specified flash flags.

#### `flash_status_type flash_operation_wait_for(uint32_t time_out)`
Waits for flash operation to complete or timeout.

```c
flash_status_type status = flash_operation_wait_for(ERASE_TIMEOUT);
if (status != FLASH_OPERATE_DONE) {
  // Handle error
}
```

---

### Flash Protection Functions

#### `flash_status_type flash_fap_enable(confirm_state new_state)`
Enables or disables Flash Access Protection (FAP).

- `new_state`: `TRUE` to enable FAP, `FALSE` to disable.
- Returns: Flash operation status.

> **Warning**: Enabling FAP prevents external read-out of flash. Disabling FAP erases all flash content.

#### `flag_status flash_fap_status_get(void)`
Returns the current FAP status.

#### `flash_status_type flash_epp_set(uint32_t *sector_bits)`
Configures Erase/Program Protection for sectors.

- `sector_bits`: Pointer to 32-bit value where each bit represents a 4KB sector (1 = protected, 0 = unprotected).

#### `void flash_epp_status_get(uint32_t *sector_bits)`
Returns the current EPP status.

#### `flash_status_type flash_ssb_set(uint8_t usd_ssb)`
Programs the System Setting Byte (SSB) in USD.

Options:
- `USD_WDT_ATO_DISABLE` / `USD_WDT_ATO_ENABLE`: WDT auto-start control
- `USD_DEPSLP_NO_RST` / `USD_DEPSLP_RST`: Deep sleep reset behavior
- `USD_STDBY_NO_RST` / `USD_STDBY_RST`: Standby reset behavior
- `FLASH_BOOT_FROM_BANK1` / `FLASH_BOOT_FROM_BANK2`: Boot bank selection

```c
// Disable WDT auto-start, no reset on deep sleep/standby, boot from Bank1
flash_ssb_set(USD_WDT_ATO_DISABLE | USD_DEPSLP_NO_RST | USD_STDBY_NO_RST | FLASH_BOOT_FROM_BANK1);
```

#### `uint8_t flash_ssb_status_get(void)`
Returns the current System Setting Byte value.

---

### Security Library (SLIB) Functions

#### `flash_status_type flash_slib_enable(uint32_t pwd, uint16_t start_sector, uint16_t data_start_sector, uint16_t end_sector)`
Enables SLIB protection for a specified sector range.

- `pwd`: Password for SLIB protection.
- `start_sector`: First protected sector.
- `data_start_sector`: First sector for D-bus (data) access (`0x7FF` to disable D-bus access).
- `end_sector`: Last protected sector.
- Returns: Flash operation status.

```c
// Protect sectors 10-20, with D-bus access starting at sector 15
flash_slib_enable(0x12345678, 10, 15, 20);
```

#### `error_status flash_slib_disable(uint32_t pwd)`
Disables SLIB protection using the password.

#### `flag_status flash_slib_state_get(void)`
Returns SLIB enable status (`SET` = enabled, `RESET` = disabled).

#### `uint32_t flash_slib_remaining_count_get(void)`
Returns the remaining SLIB password retry count (256 to 0).

#### `uint16_t flash_slib_start_sector_get(void)` / `uint16_t flash_slib_datastart_sector_get(void)` / `uint16_t flash_slib_end_sector_get(void)`
Returns the SLIB sector range configuration.

---

### SPIM Functions

#### `void flash_spim_model_select(flash_spim_model_type mode)`
Selects the SPIM flash model.

- `FLASH_SPIM_MODEL1`: For certain SPI flash types (requires delay after selection).
- `FLASH_SPIM_MODEL2`: For EN25QH128A and similar flash types.

#### `void flash_spim_encryption_range_set(uint32_t decode_address)`
Sets the encryption range for SPIM flash. Data written below this address is encrypted.

- `decode_address`: End address of encryption range (`0` to disable encryption).

#### `void flash_spim_dummy_read(void)`
Performs dummy reads on SPIM flash (required after certain operations).

#### `flash_status_type flash_spim_mass_program(uint32_t address, uint8_t *buf, uint32_t cnt)`
Programs multiple bytes to SPIM flash efficiently.

- `address`: Target SPIM address.
- `buf`: Data buffer.
- `cnt`: Number of bytes to program (must be multiple of 2 or 4).

---

### CRC Functions

#### `uint32_t flash_crc_calibrate(uint32_t start_sector, uint32_t sector_cnt)`
Calculates CRC for a range of flash sectors.

- `start_sector`: First sector number.
- `sector_cnt`: Number of sectors.
- Returns: 32-bit CRC result.

```c
uint32_t crc = flash_crc_calibrate(0, 10); // CRC of sectors 0-9
```

---

### Interrupt Functions

#### `void flash_interrupt_enable(uint32_t flash_int, confirm_state new_state)`
Enables or disables flash interrupts.

Available interrupts:
- `FLASH_ERR_INT` / `FLASH_BANK1_ERR_INT` / `FLASH_BANK2_ERR_INT` / `FLASH_SPIM_ERR_INT`: Error interrupts
- `FLASH_ODF_INT` / `FLASH_BANK1_ODF_INT` / `FLASH_BANK2_ODF_INT` / `FLASH_SPIM_ODF_INT`: Operation Done interrupts

---

## Usage Examples

### 1. Basic Flash Write and Read

This example demonstrates writing data to internal flash and reading it back.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

#define SECTOR_SIZE              2048
#define TEST_FLASH_ADDRESS       (0x08000000 + 1024 * 10) // 10KB offset
#define TEST_BUFFER_SIZE         100

uint16_t write_buffer[TEST_BUFFER_SIZE];
uint16_t read_buffer[TEST_BUFFER_SIZE];
uint16_t sector_buffer[SECTOR_SIZE / 2];

// Read data from flash (halfword mode)
void flash_read(uint32_t address, uint16_t *buffer, uint16_t count)
{
  for (uint16_t i = 0; i < count; i++)
  {
    buffer[i] = *(uint16_t *)address;
    address += 2;
  }
}

// Write data to flash with erase if needed
error_status flash_write_with_erase(uint32_t address, uint16_t *buffer, uint16_t count)
{
  uint32_t sector_address = (address / SECTOR_SIZE) * SECTOR_SIZE;
  uint32_t offset = (address - sector_address) / 2;
  flash_status_type status;

  flash_unlock();

  // Read existing sector data
  flash_read(sector_address, sector_buffer, SECTOR_SIZE / 2);

  // Check if erase is needed (any location not 0xFFFF)
  confirm_state need_erase = FALSE;
  for (uint16_t i = 0; i < count; i++)
  {
    if (sector_buffer[offset + i] != 0xFFFF)
    {
      need_erase = TRUE;
      break;
    }
  }

  if (need_erase)
  {
    // Erase sector
    status = flash_sector_erase(sector_address);
    if (status != FLASH_OPERATE_DONE)
    {
      flash_lock();
      return ERROR;
    }

    // Merge new data with existing sector data
    for (uint16_t i = 0; i < count; i++)
    {
      sector_buffer[offset + i] = buffer[i];
    }

    // Write entire sector
    for (uint16_t i = 0; i < SECTOR_SIZE / 2; i++)
    {
      status = flash_halfword_program(sector_address + i * 2, sector_buffer[i]);
      if (status != FLASH_OPERATE_DONE)
      {
        flash_lock();
        return ERROR;
      }
    }
  }
  else
  {
    // Direct write (no erase needed)
    for (uint16_t i = 0; i < count; i++)
    {
      status = flash_halfword_program(address + i * 2, buffer[i]);
      if (status != FLASH_OPERATE_DONE)
      {
        flash_lock();
        return ERROR;
      }
    }
  }

  flash_lock();
  return SUCCESS;
}

int main(void)
{
  system_clock_config();
  at32_board_init();

  // Prepare test data
  for (uint32_t i = 0; i < TEST_BUFFER_SIZE; i++)
  {
    write_buffer[i] = i;
  }

  // Write to flash
  if (flash_write_with_erase(TEST_FLASH_ADDRESS, write_buffer, TEST_BUFFER_SIZE) == SUCCESS)
  {
    // Read back
    flash_read(TEST_FLASH_ADDRESS, read_buffer, TEST_BUFFER_SIZE);

    // Verify
    confirm_state match = TRUE;
    for (uint32_t i = 0; i < TEST_BUFFER_SIZE; i++)
    {
      if (write_buffer[i] != read_buffer[i])
      {
        match = FALSE;
        break;
      }
    }

    if (match)
    {
      at32_led_on(LED2); // Success
    }
    else
    {
      at32_led_on(LED4); // Verify failed
    }
  }
  else
  {
    at32_led_on(LED4); // Write failed
  }

  while (1);
}
```

### 2. SPIM Flash Operations

This example demonstrates initializing and using external SPIM flash.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"
#include <string.h>

#define SPIM_TEST_ADDR       0x08400000  // SPIM flash start address
#define SPIM_SECTOR_SIZE     4096        // 4KB sector

uint8_t write_buffer[SPIM_SECTOR_SIZE];
uint8_t read_buffer[SPIM_SECTOR_SIZE];

void spim_init(void)
{
  gpio_init_type gpio_init_struct;

  // Enable clocks
  crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  // Configure SPIM GPIO pins
  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;

  // PA8 - SPIM CLK
  gpio_init_struct.gpio_pins = GPIO_PINS_8;
  gpio_init(GPIOA, &gpio_init_struct);

  // PB1, PB6, PB7, PB10, PB11 - SPIM data pins
  gpio_init_struct.gpio_pins = GPIO_PINS_1 | GPIO_PINS_6 | GPIO_PINS_7 | GPIO_PINS_10 | GPIO_PINS_11;
  gpio_init(GPIOB, &gpio_init_struct);

  // Enable SPIM with PB10/PB11 configuration
  gpio_pin_remap_config(EXT_SPIM_GMUX_1001, TRUE);

  // Select SPIM model (Model 2 for EN25QH128A)
  flash_spim_model_select(FLASH_SPIM_MODEL2);

  // Delay for Model 1 flash types
  delay_ms(20);

  // Wait for SPIM to be ready and unlock
  while (flash_flag_get(FLASH_SPIM_OBF_FLAG));
  flash_spim_unlock();
  while (FLASH->ctrl3_bit.oplk);

  // Disable encryption (0 = no encryption)
  flash_spim_encryption_range_set(0);
}

void spim_read_sector(uint32_t address, uint8_t *buffer, uint32_t size)
{
  while (size >= 4)
  {
    *(uint32_t *)buffer = *(uint32_t *)address;
    address += 4;
    buffer += 4;
    size -= 4;
  }
}

int main(void)
{
  flash_status_type status;

  system_clock_config();
  at32_board_init();

  // Initialize SPIM
  spim_init();

  // Prepare test data
  for (uint32_t i = 0; i < SPIM_SECTOR_SIZE; i++)
  {
    write_buffer[i] = i % 256;
  }

  // Wait for any pending operation
  status = flash_operation_wait_for(ERASE_TIMEOUT);
  if (status == FLASH_PROGRAM_ERROR || status == FLASH_EPP_ERROR)
  {
    flash_flag_clear(FLASH_PRGMERR_FLAG | FLASH_EPPERR_FLAG);
  }

  // Erase SPIM sector
  status = flash_sector_erase(SPIM_TEST_ADDR);
  if (status != FLASH_OPERATE_DONE)
  {
    at32_led_on(LED4); // Erase failed
    while (1);
  }

  // Verify sector is erased (all 0xFF)
  spim_read_sector(SPIM_TEST_ADDR, read_buffer, SPIM_SECTOR_SIZE);
  for (uint32_t i = 0; i < SPIM_SECTOR_SIZE; i++)
  {
    if (read_buffer[i] != 0xFF)
    {
      at32_led_on(LED4); // Erase verify failed
      while (1);
    }
  }

  // Program SPIM sector word by word
  for (uint32_t i = 0; i < SPIM_SECTOR_SIZE; i += 4)
  {
    status = flash_word_program(SPIM_TEST_ADDR + i, *(uint32_t *)(write_buffer + i));
    if (status != FLASH_OPERATE_DONE)
    {
      at32_led_on(LED4); // Program failed
      while (1);
    }
  }

  // Read back and verify
  memset(read_buffer, 0, SPIM_SECTOR_SIZE);
  spim_read_sector(SPIM_TEST_ADDR, read_buffer, SPIM_SECTOR_SIZE);

  for (uint32_t i = 0; i < SPIM_SECTOR_SIZE; i++)
  {
    if (read_buffer[i] != write_buffer[i])
    {
      at32_led_on(LED4); // Verify failed
      while (1);
    }
  }

  // Success - toggle LEDs
  while (1)
  {
    at32_led_toggle(LED2);
    delay_ms(100);
    at32_led_toggle(LED3);
    delay_ms(100);
    at32_led_toggle(LED4);
    delay_ms(100);
  }
}
```

### 3. Execute Code from SPIM Flash

This example shows how to run code directly from external SPIM flash.

```c
// main.c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

// Function prototype (implemented in SPIM flash)
extern void spim_run(void);

void spim_init(void)
{
  gpio_init_type gpio_init_struct;

  crm_periph_clock_enable(CRM_IOMUX_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOA_PERIPH_CLOCK, TRUE);
  crm_periph_clock_enable(CRM_GPIOB_PERIPH_CLOCK, TRUE);

  gpio_default_para_init(&gpio_init_struct);
  gpio_init_struct.gpio_drive_strength = GPIO_DRIVE_STRENGTH_STRONGER;
  gpio_init_struct.gpio_out_type = GPIO_OUTPUT_PUSH_PULL;
  gpio_init_struct.gpio_mode = GPIO_MODE_MUX;
  gpio_init_struct.gpio_pull = GPIO_PULL_NONE;
  gpio_init_struct.gpio_pins = GPIO_PINS_8;
  gpio_init(GPIOA, &gpio_init_struct);
  gpio_init_struct.gpio_pins = GPIO_PINS_1 | GPIO_PINS_6 | GPIO_PINS_7 | GPIO_PINS_10 | GPIO_PINS_11;
  gpio_init(GPIOB, &gpio_init_struct);

  gpio_pin_remap_config(EXT_SPIM_GMUX_1001, TRUE);
  flash_spim_model_select(FLASH_SPIM_MODEL2);
  delay_ms(20);

  while (flash_flag_get(FLASH_SPIM_OBF_FLAG));
  flash_spim_unlock();
  while (FLASH->ctrl3_bit.oplk);

  flash_spim_encryption_range_set(0);
}

int main(void)
{
  system_clock_config();
  at32_board_init();

  // Initialize SPIM
  spim_init();

  // Jump to code in SPIM flash
  spim_run();

  while (1);
}

// run_in_spim.c - This file is placed in SPIM flash via linker script
// Located at SPIM address range (0x08400000+)
void spim_run(void)
{
  while (1)
  {
    at32_led_toggle(LED2);
    delay_ms(100);
    at32_led_toggle(LED3);
    delay_ms(100);
    at32_led_toggle(LED4);
    delay_ms(100);
  }
}
```

### 4. Flash Protection Configuration

This example demonstrates configuring flash protection options.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

int main(void)
{
  flash_status_type status;

  system_clock_config();
  at32_board_init();

  flash_unlock();

  // Example 1: Configure System Setting Byte
  // Disable WDT auto-start, no reset on deep sleep, boot from Bank1
  uint8_t ssb_config = USD_WDT_ATO_DISABLE | USD_DEPSLP_NO_RST | 
                       USD_STDBY_NO_RST | FLASH_BOOT_FROM_BANK1;
  status = flash_ssb_set(ssb_config);
  if (status != FLASH_OPERATE_DONE)
  {
    at32_led_on(LED4); // SSB config failed
    while (1);
  }

  // Example 2: Enable Erase/Program Protection for sectors 0-7
  uint32_t epp_sectors = 0x000000FF; // Protect first 8 sectors (32KB)
  status = flash_epp_set(&epp_sectors);
  if (status != FLASH_OPERATE_DONE)
  {
    at32_led_on(LED4); // EPP config failed
    while (1);
  }

  // Read back EPP status
  uint32_t epp_status;
  flash_epp_status_get(&epp_status);

  // Example 3: Enable SLIB (Security Library)
  // Protect sectors 100-150, D-bus access starts at sector 120
  status = flash_slib_enable(0xA5A5A5A5, 100, 120, 150);
  if (status != FLASH_OPERATE_DONE)
  {
    at32_led_on(LED4); // SLIB enable failed
    while (1);
  }

  // Check SLIB state
  if (flash_slib_state_get() == SET)
  {
    at32_led_on(LED2); // SLIB is enabled
  }

  flash_lock();

  // Note: A system reset is required for protection settings to take effect

  while (1);
}
```

### 5. Flash CRC Verification

This example demonstrates using the hardware CRC for flash integrity verification.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

#define APP_START_SECTOR    5
#define APP_SECTOR_COUNT    50
#define EXPECTED_CRC        0x12345678  // Pre-calculated expected CRC

int main(void)
{
  system_clock_config();
  at32_board_init();

  flash_unlock();

  // Calculate CRC of application sectors
  uint32_t calculated_crc = flash_crc_calibrate(APP_START_SECTOR, APP_SECTOR_COUNT);

  flash_lock();

  // Verify CRC
  if (calculated_crc == EXPECTED_CRC)
  {
    at32_led_on(LED2); // CRC match - flash integrity OK
    at32_led_on(LED3);
  }
  else
  {
    at32_led_on(LED4); // CRC mismatch - flash corrupted
  }

  while (1);
}
```

### 6. User System Data Programming

This example shows how to program user data bytes in USD.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

// USD data addresses
#define USD_DATA0_ADDR   (USD_BASE + 0x04)
#define USD_DATA1_ADDR   (USD_BASE + 0x06)

int main(void)
{
  flash_status_type status;

  system_clock_config();
  at32_board_init();

  flash_unlock();

  // Erase USD first (preserves FAP)
  status = flash_user_system_data_erase();
  if (status != FLASH_OPERATE_DONE)
  {
    at32_led_on(LED4);
    while (1);
  }

  // Program user data bytes
  status = flash_user_system_data_program(USD_DATA0_ADDR, 0x55);
  if (status != FLASH_OPERATE_DONE)
  {
    at32_led_on(LED4);
    while (1);
  }

  status = flash_user_system_data_program(USD_DATA1_ADDR, 0xAA);
  if (status != FLASH_OPERATE_DONE)
  {
    at32_led_on(LED4);
    while (1);
  }

  flash_lock();

  // Read back and verify
  uint8_t data0 = (uint8_t)(FLASH->usd_bit.user_d0);
  uint8_t data1 = (uint8_t)(FLASH->usd_bit.user_d1);

  if (data0 == 0x55 && data1 == 0xAA)
  {
    at32_led_on(LED2); // Success
    at32_led_on(LED3);
  }
  else
  {
    at32_led_on(LED4); // Verification failed
  }

  while (1);
}
```

---

## SPIM GPIO Pin Configuration

| Pin | Function | Description |
|-----|----------|-------------|
| PA8 | SPIM_CLK | SPI Clock |
| PB1 | SPIM_IO3 | Data Line 3 (Quad mode) |
| PB6 | SPIM_CSN | Chip Select (active low) |
| PB7 | SPIM_IO2 | Data Line 2 (Quad mode) |
| PB10 | SPIM_IO0 | Data Line 0 / MOSI |
| PB11 | SPIM_IO1 | Data Line 1 / MISO |

---

## Timeout Values

| Constant | Value | Description |
|----------|-------|-------------|
| `ERASE_TIMEOUT` | `0x40000000` | Internal flash erase timeout |
| `PROGRAMMING_TIMEOUT` | `0x00100000` | Internal flash program timeout |
| `SPIM_ERASE_TIMEOUT` | `0xFFFFFFFF` | SPIM erase timeout |
| `SPIM_PROGRAMMING_TIMEOUT` | `0x00100000` | SPIM program timeout |
| `OPERATION_TIMEOUT` | `0x10000000` | General operation timeout |

---

## Troubleshooting

### Flash Programming Fails

- **Ensure flash is unlocked**: Call `flash_unlock()` before any program/erase operation.
- **Check protection status**: Verify FAP and EPP are not blocking the operation.
- **Clear error flags**: Call `flash_flag_clear(FLASH_PRGMERR_FLAG | FLASH_EPPERR_FLAG)` before retrying.
- **Erase before programming**: Flash can only be programmed from 1 to 0. Erase the sector first if writing to non-erased locations.

### SPIM Operations Fail

- **Check GPIO configuration**: Ensure all SPIM pins are configured correctly.
- **Select correct model**: Use `flash_spim_model_select()` with the correct model for your flash chip.
- **Wait for ready**: Always wait for `FLASH_SPIM_OBF_FLAG` to clear before operations.
- **Perform dummy read**: Call `flash_spim_dummy_read()` after erase/program operations.

### SLIB Cannot Be Disabled

- **Check password**: Ensure you're using the exact password used when enabling SLIB.
- **Check retry count**: SLIB has a limited number of password retries. Use `flash_slib_remaining_count_get()` to check.

### System Doesn't Boot After USD Change

- **Reset required**: USD changes take effect after system reset.
- **Boot bank selection**: Verify `FLASH_BOOT_FROM_BANK1` or `FLASH_BOOT_FROM_BANK2` is set correctly.

---

## Related Peripherals

- **CRM**: Clock and Reset Management - provides flash clock enable.
- **GPIO**: For SPIM pin configuration.
- **WDT**: Watchdog timer auto-start is controlled via USD.

---

## Important Notes

1. **Always unlock before operations**: Flash must be unlocked before any program/erase operation.
2. **Lock after operations**: Always lock flash after completing operations to prevent accidental writes.
3. **Sector erase is required**: Flash bits can only be changed from 1 to 0. To write new data over existing data, erase the sector first.
4. **Protection changes require reset**: FAP, EPP, and SLIB changes take effect after system reset.
5. **FAP warning**: Enabling FAP without proper preparation can permanently lock the device.
6. **SPIM requires initialization**: Always initialize SPIM GPIO and controller before accessing external flash.
7. **Bank selection for dual-bank**: Operations automatically select the correct bank based on address.

