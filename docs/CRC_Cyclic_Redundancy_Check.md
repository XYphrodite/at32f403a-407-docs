# CRC - Cyclic Redundancy Check Calculator

## Overview

The **Cyclic Redundancy Check (CRC)** peripheral provides hardware-accelerated CRC calculation for data integrity verification. The AT32F403A/407 CRC unit supports configurable polynomial sizes, input/output bit reversal, and programmable polynomials for compatibility with various CRC standards.

| Feature | Specification |
|---------|---------------|
| **Data Width** | 32-bit input |
| **Polynomial Sizes** | 7, 8, 16, 32 bits |
| **Default Polynomial** | 0x04C11DB7 (CRC-32 Ethernet) |
| **Default Initial Value** | 0xFFFFFFFF |
| **Input Reversal** | No, By byte, By halfword, By word |
| **Output Reversal** | No, Full word reversal |
| **Common Data Register** | 8-bit auxiliary storage |

---

## Key Features

- **Hardware-accelerated** CRC calculation (no CPU intervention)
- **Configurable polynomial** up to 32 bits
- **Multiple polynomial sizes:** 7, 8, 16, 32 bits
- **Input bit reversal** options for protocol compatibility
- **Output bit reversal** for different CRC conventions
- **Programmable initial value** for various standards
- **Single-word** and **block** calculation modes
- **8-bit common data register** for temporary storage

---

## Register Map

| Offset | Register | Description |
|--------|----------|-------------|
| 0x00 | **DT** | Data Register (R/W) - Input/Output CRC data |
| 0x04 | **CDT** | Common Data Register (R/W) - 8-bit auxiliary storage |
| 0x08 | **CTRL** | Control Register (R/W) - Reset and configuration |
| 0x10 | **IDT** | Initial Data Register (R/W) - Initial CRC value |
| 0x14 | **POLY** | Polynomial Register (R/W) - CRC polynomial |

---

## Register Details

### DT - Data Register (0x00)

| Bits | Name | Access | Description |
|------|------|--------|-------------|
| 31:0 | DT | R/W | **Data Register** - Write input data, read calculated CRC |

**Usage:**
- Write 32-bit data to compute CRC
- Read to get current CRC value
- Each write updates the running CRC

---

### CDT - Common Data Register (0x04)

| Bits | Name | Access | Description |
|------|------|--------|-------------|
| 7:0 | CDT | R/W | **Common Data** - 8-bit general-purpose storage |
| 31:8 | Reserved | - | Reserved bits |

**Usage:**
- Independent 8-bit storage
- Not affected by CRC reset
- Useful for storing additional data or flags

---

### CTRL - Control Register (0x08)

| Bits | Name | Access | Description |
|------|------|--------|-------------|
| 0 | RST | W | **Reset** - Reset CRC to initial value (self-clearing) |
| 2:1 | Reserved | - | Reserved bits |
| 4:3 | POLY_SIZE | R/W | **Polynomial Size** - Select polynomial width |
| 6:5 | REVID | R/W | **Reverse Input Data** - Input bit reversal mode |
| 7 | REVOD | R/W | **Reverse Output Data** - Output bit reversal |
| 31:8 | Reserved | - | Reserved bits |

**POLY_SIZE Values:**

| Value | Size | Description |
|-------|------|-------------|
| 0x00 | 32-bit | Full 32-bit polynomial |
| 0x01 | 16-bit | 16-bit polynomial (bits [15:0]) |
| 0x02 | 8-bit | 8-bit polynomial (bits [7:0]) |
| 0x03 | 7-bit | 7-bit polynomial (bits [6:0]) |

**REVID (Reverse Input Data) Values:**

| Value | Mode | Description |
|-------|------|-------------|
| 0x00 | No Reversal | Input data not modified |
| 0x01 | By Byte | Bit reversal within each byte |
| 0x02 | By Halfword | Bit reversal within each 16-bit halfword |
| 0x03 | By Word | Bit reversal of entire 32-bit word |

**REVOD (Reverse Output Data) Values:**

| Value | Mode | Description |
|-------|------|-------------|
| 0x00 | No Reversal | Output data not modified |
| 0x01 | Reversed | Full word bit reversal |

---

### IDT - Initial Data Register (0x10)

| Bits | Name | Access | Description |
|------|------|--------|-------------|
| 31:0 | IDT | R/W | **Initial Data** - Value loaded into DT on reset |

**Default Value:** 0xFFFFFFFF

---

### POLY - Polynomial Register (0x14)

| Bits | Name | Access | Description |
|------|------|--------|-------------|
| 31:0 | POLY | R/W | **Polynomial** - CRC polynomial coefficients |

**Default Value:** 0x04C11DB7 (CRC-32 Ethernet/MPEG-2)

---

## Polynomial Configuration

### Default CRC-32 Polynomial

The default polynomial `0x04C11DB7` represents:

```
G(x) = x³² + x²⁶ + x²³ + x²² + x¹⁶ + x¹² + x¹¹ + x¹⁰ + x⁸ + x⁷ + x⁵ + x⁴ + x² + x + 1
```

### Standard CRC Polynomials

| Standard | Size | Polynomial | Init Value | RefIn | RefOut |
|----------|------|------------|------------|-------|--------|
| CRC-32/ISO-HDLC | 32-bit | 0x04C11DB7 | 0xFFFFFFFF | Yes | Yes |
| CRC-32/MPEG-2 | 32-bit | 0x04C11DB7 | 0xFFFFFFFF | No | No |
| CRC-16/CCITT | 16-bit | 0x1021 | 0xFFFF | No | No |
| CRC-16/MODBUS | 16-bit | 0x8005 | 0xFFFF | Yes | Yes |
| CRC-8/MAXIM | 8-bit | 0x31 | 0x00 | Yes | Yes |
| CRC-7/MMC | 7-bit | 0x09 | 0x00 | No | No |

### Polynomial Size Selection

```c
// Configure for CRC-16
crc_poly_size_set(CRC_POLY_SIZE_16B);
crc_poly_value_set(0x1021);  // CRC-16/CCITT polynomial

// Configure for CRC-8
crc_poly_size_set(CRC_POLY_SIZE_8B);
crc_poly_value_set(0x07);    // CRC-8 polynomial

// Configure for CRC-7 (SD card)
crc_poly_size_set(CRC_POLY_SIZE_7B);
crc_poly_value_set(0x09);    // CRC-7/MMC polynomial
```

---

## Input/Output Bit Reversal

### Why Bit Reversal?

Different CRC standards process data bits in different orders:
- **MSB-first:** Process most significant bit first
- **LSB-first:** Process least significant bit first

The hardware reversal options allow compatibility with various protocols.

### Reversal Modes Explained

**No Reversal (Input as-is):**
```
Input:  0x12345678
Stored: 0x12345678
```

**Reverse by Byte:**
```
Input:    0x12345678
Byte 0:   0x12 → 0x48
Byte 1:   0x34 → 0x2C
Byte 2:   0x56 → 0x6A
Byte 3:   0x78 → 0x1E
Stored:   0x482C6A1E
```

**Reverse by Halfword:**
```
Input:      0x12345678
Halfword 0: 0x1234 → 0x482C
Halfword 1: 0x5678 → 0x1E6A
Stored:     0x482C1E6A
```

**Reverse by Word:**
```
Input:  0x12345678
Stored: 0x1E6A2C48 (all 32 bits reversed)
```

---

## Data Types and Enumerations

### Input Reversal Types

```c
typedef enum
{
  CRC_REVERSE_INPUT_NO_AFFECTE    = 0x00,  // No input reversal
  CRC_REVERSE_INPUT_BY_BYTE       = 0x01,  // Reverse within each byte
  CRC_REVERSE_INPUT_BY_HALFWORD   = 0x02,  // Reverse within each halfword
  CRC_REVERSE_INPUT_BY_WORD       = 0x03   // Reverse entire word
} crc_reverse_input_type;
```

### Output Reversal Types

```c
typedef enum
{
  CRC_REVERSE_OUTPUT_NO_AFFECTE   = 0x00,  // No output reversal
  CRC_REVERSE_OUTPUT_DATA         = 0x01   // Reverse output word
} crc_reverse_output_type;
```

### Polynomial Size Types

```c
typedef enum
{
  CRC_POLY_SIZE_32B               = 0x00,  // 32-bit polynomial
  CRC_POLY_SIZE_16B               = 0x01,  // 16-bit polynomial
  CRC_POLY_SIZE_8B                = 0x02,  // 8-bit polynomial
  CRC_POLY_SIZE_7B                = 0x03   // 7-bit polynomial
} crc_poly_size_type;
```

---

## API Reference

### crc_data_reset

Reset the CRC calculator to its initial value.

```c
void crc_data_reset(void);
```

**Example:**
```c
// Reset CRC to initial value (0xFFFFFFFF by default)
crc_data_reset();
```

---

### crc_one_word_calculate

Calculate CRC for a single 32-bit word.

```c
uint32_t crc_one_word_calculate(uint32_t data);
```

| Parameter | Description |
|-----------|-------------|
| data | 32-bit data word to process |
| **Return** | Current CRC value after calculation |

**Example:**
```c
uint32_t crc;

crc_data_reset();
crc = crc_one_word_calculate(0x12345678);  // Process single word
```

---

### crc_block_calculate

Calculate CRC for a buffer of 32-bit words.

```c
uint32_t crc_block_calculate(uint32_t *pbuffer, uint32_t length);
```

| Parameter | Description |
|-----------|-------------|
| pbuffer | Pointer to 32-bit word buffer |
| length | Number of 32-bit words in buffer |
| **Return** | Final CRC value |

**Example:**
```c
uint32_t data[] = {0x11111111, 0x22222222, 0x33333333, 0x44444444};
uint32_t crc;

crc_data_reset();
crc = crc_block_calculate(data, 4);  // Process 4 words
```

---

### crc_data_get

Get the current CRC value without adding new data.

```c
uint32_t crc_data_get(void);
```

| Parameter | Description |
|-----------|-------------|
| **Return** | Current CRC value |

**Example:**
```c
uint32_t current_crc = crc_data_get();
```

---

### crc_common_data_set / crc_common_data_get

Store/retrieve 8-bit value in the common data register.

```c
void crc_common_data_set(uint8_t cdt_value);
uint8_t crc_common_data_get(void);
```

| Parameter | Description |
|-----------|-------------|
| cdt_value | 8-bit value to store |
| **Return** | 8-bit stored value |

**Example:**
```c
// Store temporary data
crc_common_data_set(0x55);

// Retrieve later
uint8_t temp = crc_common_data_get();  // Returns 0x55
```

---

### crc_init_data_set

Set the initial value loaded on reset.

```c
void crc_init_data_set(uint32_t value);
```

| Parameter | Description |
|-----------|-------------|
| value | 32-bit initial value |

**Example:**
```c
// Set custom initial value
crc_init_data_set(0x00000000);
crc_data_reset();  // Load new initial value
```

---

### crc_reverse_input_data_set

Configure input data bit reversal.

```c
void crc_reverse_input_data_set(crc_reverse_input_type value);
```

| Parameter | Description |
|-----------|-------------|
| value | Reversal mode from `crc_reverse_input_type` |

**Example:**
```c
// Enable byte-wise reversal for MODBUS compatibility
crc_reverse_input_data_set(CRC_REVERSE_INPUT_BY_BYTE);
```

---

### crc_reverse_output_data_set

Configure output data bit reversal.

```c
void crc_reverse_output_data_set(crc_reverse_output_type value);
```

| Parameter | Description |
|-----------|-------------|
| value | Reversal mode from `crc_reverse_output_type` |

**Example:**
```c
// Enable output reversal
crc_reverse_output_data_set(CRC_REVERSE_OUTPUT_DATA);
```

---

### crc_poly_value_set / crc_poly_value_get

Set/get the CRC polynomial.

```c
void crc_poly_value_set(uint32_t value);
uint32_t crc_poly_value_get(void);
```

| Parameter | Description |
|-----------|-------------|
| value | Polynomial value |
| **Return** | Current polynomial |

**Example:**
```c
// Set CRC-16/CCITT polynomial
crc_poly_value_set(0x1021);
```

---

### crc_poly_size_set / crc_poly_size_get

Set/get the polynomial size.

```c
void crc_poly_size_set(crc_poly_size_type size);
crc_poly_size_type crc_poly_size_get(void);
```

| Parameter | Description |
|-----------|-------------|
| size | Size from `crc_poly_size_type` |
| **Return** | Current polynomial size |

**Example:**
```c
// Configure for 16-bit CRC
crc_poly_size_set(CRC_POLY_SIZE_16B);
```

---

## Usage Examples

### Example 1: Basic CRC-32 Calculation

Standard CRC-32 calculation using default settings.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

#define BUFFER_SIZE  120

static const uint32_t data_buffer[BUFFER_SIZE] = {
    0xc33dd31c, 0xe37ff35e, 0x129022f3, 0x32d24235,
    0x52146277, 0x7256b5ea, 0x4a755a54, 0x6a377a16,
    // ... more data
};

int main(void)
{
    uint32_t crc_value;
    
    system_clock_config();
    at32_board_init();
    
    // Enable CRC peripheral clock
    crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);
    
    // Reset CRC to initial value
    crc_data_reset();
    
    // Calculate CRC-32 for data buffer
    crc_value = crc_block_calculate((uint32_t *)data_buffer, BUFFER_SIZE);
    
    // Verify expected value
    if(crc_value == 0xE5DFCF6D)
    {
        at32_led_on(LED3);  // Success
    }
    else
    {
        at32_led_on(LED4);  // Error
    }
    
    while(1)
    {
    }
}
```

---

### Example 2: CRC-16/CCITT Configuration

Configure CRC for CCITT-FALSE standard.

```c
void crc_init_ccitt_false(void)
{
    // Enable CRC clock
    crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);
    
    // Configure CRC-16/CCITT-FALSE
    crc_poly_size_set(CRC_POLY_SIZE_16B);
    crc_poly_value_set(0x1021);
    crc_init_data_set(0xFFFF);
    
    // No reversal for CCITT-FALSE
    crc_reverse_input_data_set(CRC_REVERSE_INPUT_NO_AFFECTE);
    crc_reverse_output_data_set(CRC_REVERSE_OUTPUT_NO_AFFECTE);
    
    crc_data_reset();
}

uint16_t calculate_crc16_ccitt(uint8_t *data, uint32_t length)
{
    uint32_t words = length / 4;
    uint32_t remainder = length % 4;
    uint16_t crc;
    
    crc_data_reset();
    
    // Process full words
    if(words > 0)
    {
        crc_block_calculate((uint32_t *)data, words);
    }
    
    // Process remaining bytes (if any)
    if(remainder > 0)
    {
        uint32_t last_word = 0;
        for(uint32_t i = 0; i < remainder; i++)
        {
            last_word |= ((uint32_t)data[words * 4 + i]) << (i * 8);
        }
        crc_one_word_calculate(last_word);
    }
    
    crc = (uint16_t)(crc_data_get() & 0xFFFF);
    return crc;
}
```

---

### Example 3: CRC-16/MODBUS Configuration

Configure CRC for MODBUS protocol.

```c
void crc_init_modbus(void)
{
    crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);
    
    // Configure CRC-16/MODBUS
    crc_poly_size_set(CRC_POLY_SIZE_16B);
    crc_poly_value_set(0x8005);
    crc_init_data_set(0xFFFF);
    
    // MODBUS uses reflected input and output
    crc_reverse_input_data_set(CRC_REVERSE_INPUT_BY_BYTE);
    crc_reverse_output_data_set(CRC_REVERSE_OUTPUT_DATA);
    
    crc_data_reset();
}

uint16_t calculate_modbus_crc(uint8_t *frame, uint16_t length)
{
    uint32_t crc;
    
    crc_init_modbus();
    crc_data_reset();
    
    // Process frame byte-by-byte using word writes
    for(uint16_t i = 0; i < length; i += 4)
    {
        uint32_t word = 0;
        for(uint16_t j = 0; j < 4 && (i + j) < length; j++)
        {
            word |= ((uint32_t)frame[i + j]) << (j * 8);
        }
        crc_one_word_calculate(word);
    }
    
    crc = crc_data_get();
    return (uint16_t)(crc & 0xFFFF);
}
```

---

### Example 4: CRC-32/ISO-HDLC (Standard Ethernet)

Configure CRC for standard Ethernet frame check sequence.

```c
void crc_init_ethernet(void)
{
    crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);
    
    // Configure CRC-32/ISO-HDLC (Ethernet FCS)
    crc_poly_size_set(CRC_POLY_SIZE_32B);
    crc_poly_value_set(0x04C11DB7);  // Default polynomial
    crc_init_data_set(0xFFFFFFFF);
    
    // Ethernet uses reflected input and output
    crc_reverse_input_data_set(CRC_REVERSE_INPUT_BY_BYTE);
    crc_reverse_output_data_set(CRC_REVERSE_OUTPUT_DATA);
    
    crc_data_reset();
}

uint32_t calculate_ethernet_fcs(uint8_t *frame, uint32_t length)
{
    uint32_t crc;
    
    crc_init_ethernet();
    crc_data_reset();
    
    // Process frame
    crc = crc_block_calculate((uint32_t *)frame, length / 4);
    
    // Complement result (Ethernet convention)
    crc ^= 0xFFFFFFFF;
    
    return crc;
}
```

---

### Example 5: CRC-7/MMC (SD Card)

Configure CRC for SD card command CRC.

```c
void crc_init_sd_card(void)
{
    crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);
    
    // Configure CRC-7/MMC
    crc_poly_size_set(CRC_POLY_SIZE_7B);
    crc_poly_value_set(0x09);
    crc_init_data_set(0x00);
    
    // No reversal for SD card CRC
    crc_reverse_input_data_set(CRC_REVERSE_INPUT_NO_AFFECTE);
    crc_reverse_output_data_set(CRC_REVERSE_OUTPUT_NO_AFFECTE);
    
    crc_data_reset();
}

uint8_t calculate_sd_command_crc(uint8_t *cmd, uint8_t length)
{
    uint8_t crc;
    
    crc_init_sd_card();
    crc_data_reset();
    
    // Process command bytes
    for(uint8_t i = 0; i < length; i++)
    {
        crc_one_word_calculate((uint32_t)cmd[i]);
    }
    
    // Get 7-bit CRC (bit positions [6:0])
    crc = (uint8_t)(crc_data_get() & 0x7F);
    
    // SD card CRC has stop bit (bit 0 = 1)
    return (crc << 1) | 0x01;
}
```

---

### Example 6: Incremental CRC Calculation

Calculate CRC incrementally for streaming data.

```c
typedef struct {
    uint32_t crc;
    uint32_t bytes_processed;
} crc_context_t;

void crc_context_init(crc_context_t *ctx)
{
    crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);
    
    crc_data_reset();
    
    ctx->crc = crc_data_get();
    ctx->bytes_processed = 0;
}

void crc_context_update(crc_context_t *ctx, uint32_t *data, uint32_t word_count)
{
    // Load previous CRC state
    crc_init_data_set(ctx->crc);
    crc_data_reset();
    
    // Process new data
    ctx->crc = crc_block_calculate(data, word_count);
    ctx->bytes_processed += word_count * 4;
}

uint32_t crc_context_finalize(crc_context_t *ctx)
{
    return ctx->crc;
}

// Usage
void streaming_crc_example(void)
{
    crc_context_t ctx;
    uint32_t chunk1[] = {0x11111111, 0x22222222};
    uint32_t chunk2[] = {0x33333333, 0x44444444};
    uint32_t final_crc;
    
    crc_context_init(&ctx);
    crc_context_update(&ctx, chunk1, 2);
    crc_context_update(&ctx, chunk2, 2);
    final_crc = crc_context_finalize(&ctx);
}
```

---

### Example 7: Data Integrity Verification

Use CRC to verify firmware or data integrity.

```c
#define FIRMWARE_START_ADDR    0x08008000
#define FIRMWARE_SIZE          0x10000  // 64KB
#define EXPECTED_CRC           0xABCD1234

typedef enum {
    INTEGRITY_OK,
    INTEGRITY_FAILED
} integrity_status_t;

integrity_status_t verify_firmware_integrity(void)
{
    uint32_t calculated_crc;
    uint32_t *firmware_ptr = (uint32_t *)FIRMWARE_START_ADDR;
    uint32_t word_count = FIRMWARE_SIZE / 4;
    
    // Enable CRC clock
    crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);
    
    // Reset CRC
    crc_data_reset();
    
    // Calculate CRC over firmware region
    calculated_crc = crc_block_calculate(firmware_ptr, word_count);
    
    // Verify
    if(calculated_crc == EXPECTED_CRC)
    {
        return INTEGRITY_OK;
    }
    
    return INTEGRITY_FAILED;
}

// Boot with integrity check
void secure_boot(void)
{
    if(verify_firmware_integrity() != INTEGRITY_OK)
    {
        // Firmware corrupted - enter safe mode
        while(1)
        {
            at32_led_toggle(LED4);
            delay_ms(100);
        }
    }
    
    // Firmware OK - continue boot
    at32_led_on(LED3);
}
```

---

## CRC Algorithm Comparison

### Supported Standards

| Standard | Poly | Init | RefIn | RefOut | XorOut | Check* |
|----------|------|------|-------|--------|--------|--------|
| CRC-32 | 0x04C11DB7 | 0xFFFFFFFF | Yes | Yes | 0xFFFFFFFF | 0xCBF43926 |
| CRC-32/MPEG-2 | 0x04C11DB7 | 0xFFFFFFFF | No | No | 0x00000000 | 0x0376E6E7 |
| CRC-32/BZIP2 | 0x04C11DB7 | 0xFFFFFFFF | No | No | 0xFFFFFFFF | 0xFC891918 |
| CRC-16/CCITT-FALSE | 0x1021 | 0xFFFF | No | No | 0x0000 | 0x29B1 |
| CRC-16/XMODEM | 0x1021 | 0x0000 | No | No | 0x0000 | 0x31C3 |
| CRC-16/MODBUS | 0x8005 | 0xFFFF | Yes | Yes | 0x0000 | 0x4B37 |
| CRC-8 | 0x07 | 0x00 | No | No | 0x00 | 0xF4 |
| CRC-7/MMC | 0x09 | 0x00 | No | No | 0x00 | 0x75 |

*Check value is CRC of ASCII string "123456789"

### Configuration Table

| Standard | poly_size | poly_value | init_data | rev_input | rev_output |
|----------|-----------|------------|-----------|-----------|------------|
| CRC-32 | 32B | 0x04C11DB7 | 0xFFFFFFFF | BY_BYTE | DATA |
| CRC-32/MPEG-2 | 32B | 0x04C11DB7 | 0xFFFFFFFF | NO | NO |
| CRC-16/CCITT | 16B | 0x1021 | 0xFFFF | NO | NO |
| CRC-16/MODBUS | 16B | 0x8005 | 0xFFFF | BY_BYTE | DATA |
| CRC-8 | 8B | 0x07 | 0x00 | NO | NO |
| CRC-7/MMC | 7B | 0x09 | 0x00 | NO | NO |

---

## Performance Considerations

### Calculation Speed

| Operation | Cycles | Notes |
|-----------|--------|-------|
| Single word write | 1 | Hardware processes immediately |
| Block calculation | N | N = number of words |
| Reset | 1 | Single register write |

### Optimization Tips

1. **Align data to 32-bit boundaries** for optimal throughput
2. **Use block calculation** instead of single words when possible
3. **Minimize reset calls** - only reset when starting new calculation
4. **Pre-configure reversal** settings once, not per-calculation

---

## Hardware Configuration

### Clock Requirements

```c
// Enable CRC peripheral clock
crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);
```

### Power Consumption

- CRC unit consumes power when clock is enabled
- Disable clock when not in use to save power:

```c
crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, FALSE);
```

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Wrong CRC value | Incorrect polynomial | Verify polynomial matches standard |
| CRC mismatch | Wrong reversal settings | Check RefIn/RefOut for your standard |
| Unexpected results | Missing reset | Call `crc_data_reset()` before new calculation |
| Zero result | Clock not enabled | Enable CRC peripheral clock |
| Wrong for partial data | Incorrect byte ordering | Ensure data is 32-bit aligned |

### Verification Test

Test CRC implementation with known test vector:

```c
// Test with ASCII "123456789" = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39}
uint32_t test_data[] = {
    0x34333231,  // "1234" in little-endian
    0x38373635,  // "5678" in little-endian
    0x00000039   // "9" with padding
};

void test_crc32_mpeg2(void)
{
    uint32_t crc;
    
    crm_periph_clock_enable(CRM_CRC_PERIPH_CLOCK, TRUE);
    
    // CRC-32/MPEG-2: No reversal, init 0xFFFFFFFF
    crc_poly_size_set(CRC_POLY_SIZE_32B);
    crc_poly_value_set(0x04C11DB7);
    crc_init_data_set(0xFFFFFFFF);
    crc_reverse_input_data_set(CRC_REVERSE_INPUT_NO_AFFECTE);
    crc_reverse_output_data_set(CRC_REVERSE_OUTPUT_NO_AFFECTE);
    
    crc_data_reset();
    crc = crc_block_calculate(test_data, 3);
    
    // Expected: 0x0376E6E7
    if(crc == 0x0376E6E7)
    {
        // Test passed
    }
}
```

---

## Related Peripherals

| Peripheral | Relationship |
|------------|--------------|
| **DMA** | Can be used to feed data to CRC automatically |
| **FLASH** | CRC often used to verify flash contents |
| **USART** | MODBUS protocol uses CRC-16 |
| **SDIO** | SD card commands use CRC-7 |
| **EMAC** | Ethernet uses CRC-32 for FCS |

---

## See Also

- [DMA - Direct Memory Access](DMA_Direct_Memory_Access.md)
- [FLASH - Flash Memory Controller](FLASH_Flash_Memory_Controller.md)
- [USART - Universal Synchronous/Asynchronous Receiver/Transmitter](USART_Universal_Serial.md)
- AN0109 - CRC Application Note

