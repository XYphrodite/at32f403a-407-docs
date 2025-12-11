# Cortex-M4 Core Features

## Overview

The AT32F403A/407 is based on the **ARM Cortex-M4** processor core with hardware floating-point unit (FPU). This document covers the core features provided by the Cortex-M4 architecture and their implementation in the AT32F403A/407.

| Feature | Specification |
|---------|---------------|
| **Core** | ARM Cortex-M4F |
| **Architecture** | ARMv7E-M |
| **Max Frequency** | 240 MHz |
| **FPU** | Single-precision IEEE 754 |
| **DSP Extensions** | SIMD instructions |
| **NVIC Priorities** | 4 bits (16 levels) |
| **SysTick Timer** | 24-bit countdown timer |
| **Bit-banding** | SRAM and Peripheral regions |

---

## Key Features

- **Hardware FPU** for single-precision floating-point operations
- **DSP instructions** for digital signal processing
- **Nested Vectored Interrupt Controller (NVIC)** with 16 priority levels
- **24-bit SysTick timer** with interrupt capability
- **Bit-band regions** for atomic bit manipulation
- **Memory Protection Unit (MPU)** - optional
- **Sleep modes** for power management

---

## SysTick Timer

### Overview

The SysTick timer is a 24-bit countdown timer that generates periodic interrupts. It's commonly used for:
- RTOS tick generation
- Delay functions
- Time measurement

### SysTick Registers

| Register | Description |
|----------|-------------|
| **CTRL** | Control and status register |
| **LOAD** | Reload value register (24-bit) |
| **VAL** | Current value register (24-bit) |
| **CALIB** | Calibration value register |

### CTRL Register Bits

| Bit | Name | Description |
|-----|------|-------------|
| 0 | ENABLE | Enable counter (1 = enabled) |
| 1 | TICKINT | Enable SysTick exception (1 = enabled) |
| 2 | CLKSOURCE | Clock source (0 = AHB/8, 1 = AHB) |
| 16 | COUNTFLAG | Returns 1 if timer counted to 0 since last read |

### Clock Source Configuration

```c
typedef enum
{
  SYSTICK_CLOCK_SOURCE_AHBCLK_DIV8  = 0x00,  // AHB clock / 8
  SYSTICK_CLOCK_SOURCE_AHBCLK_NODIV = 0x04   // AHB clock (full speed)
} systick_clock_source_type;
```

### SysTick API

#### systick_clock_source_config

Configure the SysTick clock source.

```c
void systick_clock_source_config(systick_clock_source_type source);
```

| Parameter | Description |
|-----------|-------------|
| source | `SYSTICK_CLOCK_SOURCE_AHBCLK_DIV8` or `SYSTICK_CLOCK_SOURCE_AHBCLK_NODIV` |

**Example:**
```c
// Use full AHB clock for maximum resolution
systick_clock_source_config(SYSTICK_CLOCK_SOURCE_AHBCLK_NODIV);
```

### SysTick Calculation

**Reload Value Formula:**
```
RELOAD = (Desired_Period × Clock_Frequency) - 1
```

**For 1ms interrupt @ 240 MHz:**
```
RELOAD = (0.001 × 240,000,000) - 1 = 239,999
```

### SysTick Interrupt Example

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

#define MS_TICK     (system_core_clock / 1000U)  // Ticks per millisecond
#define DELAY_MS    200                           // 200 ms delay

// SysTick interrupt handler
void systick_handler(void)
{
    static uint32_t ticks = 0;
    
    ticks++;
    
    // Toggle LED every DELAY_MS milliseconds
    if(ticks > DELAY_MS)
    {
        at32_led_toggle(LED2);
        ticks = 0;
    }
}

// Configure SysTick with interrupt
static uint32_t systick_interrupt_config(uint32_t ticks)
{
    // Validate reload value (24-bit max)
    if((ticks - 1UL) > SysTick_LOAD_RELOAD_Msk)
    {
        return 1UL;  // Error: value too large
    }
    
    SysTick->LOAD  = (uint32_t)(ticks - 1UL);
    NVIC_SetPriority(SysTick_IRQn, (1UL << __NVIC_PRIO_BITS) - 1UL);
    SysTick->VAL   = 0UL;
    SysTick->CTRL |= SysTick_CTRL_TICKINT_Msk |
                     SysTick_CTRL_ENABLE_Msk;
    return 0UL;
}

int main(void)
{
    system_clock_config();
    
    // Configure SysTick clock source (full AHB clock)
    systick_clock_source_config(SYSTICK_CLOCK_SOURCE_AHBCLK_NODIV);
    
    // Configure SysTick for 1ms interrupts
    systick_interrupt_config(MS_TICK);
    
    // Initialize LED
    at32_led_init(LED2);
    
    while(1)
    {
        // Main loop - LED toggled by interrupt
    }
}
```

### Delay Function Implementation

```c
volatile uint32_t systick_count = 0;

void SysTick_Handler(void)
{
    if(systick_count > 0)
    {
        systick_count--;
    }
}

void delay_ms(uint32_t ms)
{
    systick_count = ms;
    while(systick_count != 0);
}

void delay_init(void)
{
    // Configure for 1ms tick
    systick_clock_source_config(SYSTICK_CLOCK_SOURCE_AHBCLK_NODIV);
    SysTick->LOAD = (system_core_clock / 1000) - 1;
    SysTick->VAL  = 0;
    SysTick->CTRL = SysTick_CTRL_CLKSOURCE_Msk |
                    SysTick_CTRL_TICKINT_Msk |
                    SysTick_CTRL_ENABLE_Msk;
}
```

---

## NVIC (Nested Vectored Interrupt Controller)

### Overview

The NVIC provides:
- Low-latency exception and interrupt handling
- Automatic state saving and restoration
- Dynamic priority changing
- Nested interrupt support

### Priority Groups

The AT32F403A/407 has 4 bits for interrupt priority, which can be split between preemption priority and sub-priority.

```c
typedef enum
{
  NVIC_PRIORITY_GROUP_0 = 0x7,  // 0 bits preempt, 4 bits sub
  NVIC_PRIORITY_GROUP_1 = 0x6,  // 1 bit preempt,  3 bits sub
  NVIC_PRIORITY_GROUP_2 = 0x5,  // 2 bits preempt, 2 bits sub
  NVIC_PRIORITY_GROUP_3 = 0x4,  // 3 bits preempt, 1 bit sub
  NVIC_PRIORITY_GROUP_4 = 0x3   // 4 bits preempt, 0 bits sub
} nvic_priority_group_type;
```

### Priority Group Explained

| Group | Preemption Bits | Sub-priority Bits | Preemption Levels | Sub Levels |
|-------|-----------------|-------------------|-------------------|------------|
| 0 | 0 | 4 | 1 | 16 |
| 1 | 1 | 3 | 2 | 8 |
| 2 | 2 | 2 | 4 | 4 |
| 3 | 3 | 1 | 8 | 2 |
| 4 | 4 | 0 | 16 | 1 |

**Note:** Lower priority numbers = higher priority

### Vector Table Base Addresses

```c
#define NVIC_VECTTAB_RAM    ((uint32_t)0x20000000)  // Vector table in SRAM
#define NVIC_VECTTAB_FLASH  ((uint32_t)0x08000000)  // Vector table in Flash
```

### Low Power Modes

```c
typedef enum
{
  NVIC_LP_SLEEPONEXIT = 0x02,  // Enter sleep on ISR exit
  NVIC_LP_SLEEPDEEP   = 0x04,  // Enable deep sleep
  NVIC_LP_SEVONPEND   = 0x10   // Wake on pending interrupt
} nvic_lowpower_mode_type;
```

### NVIC API Reference

#### nvic_priority_group_config

Configure the priority grouping.

```c
void nvic_priority_group_config(nvic_priority_group_type priority_group);
```

**Example:**
```c
// Use 4 bits for preemption, 0 for sub-priority
nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
```

---

#### nvic_irq_enable

Enable an interrupt with specified priorities.

```c
void nvic_irq_enable(IRQn_Type irqn, uint32_t preempt_priority, uint32_t sub_priority);
```

| Parameter | Description |
|-----------|-------------|
| irqn | Interrupt number from IRQn_Type enum |
| preempt_priority | Preemption priority (0 = highest) |
| sub_priority | Sub-priority (0 = highest) |

**Example:**
```c
// Enable USART1 interrupt with priority 2, sub-priority 0
nvic_irq_enable(USART1_IRQn, 2, 0);

// Enable TIM2 interrupt with priority 1, sub-priority 0
nvic_irq_enable(TMR2_GLOBAL_IRQn, 1, 0);
```

---

#### nvic_irq_disable

Disable an interrupt.

```c
void nvic_irq_disable(IRQn_Type irqn);
```

**Example:**
```c
nvic_irq_disable(USART1_IRQn);
```

---

#### nvic_vector_table_set

Relocate the vector table.

```c
void nvic_vector_table_set(uint32_t base, uint32_t offset);
```

| Parameter | Description |
|-----------|-------------|
| base | `NVIC_VECTTAB_RAM` or `NVIC_VECTTAB_FLASH` |
| offset | Offset from base (must be multiple of 0x200) |

**Example:**
```c
// For bootloader: relocate to application at 0x08008000
nvic_vector_table_set(NVIC_VECTTAB_FLASH, 0x8000);

// For RAM execution
nvic_vector_table_set(NVIC_VECTTAB_RAM, 0x0);
```

---

#### nvic_lowpower_mode_config

Configure low power behavior.

```c
void nvic_lowpower_mode_config(nvic_lowpower_mode_type lp_mode, confirm_state new_state);
```

**Example:**
```c
// Enable sleep-on-exit (return to sleep after ISR)
nvic_lowpower_mode_config(NVIC_LP_SLEEPONEXIT, TRUE);

// Enable deep sleep mode
nvic_lowpower_mode_config(NVIC_LP_SLEEPDEEP, TRUE);
```

---

#### nvic_system_reset

Perform a system reset.

```c
void nvic_system_reset(void);
```

**Example:**
```c
// Reset the system
nvic_system_reset();
// Code after this line will not execute
```

### NVIC Usage Example

```c
void nvic_configuration(void)
{
    // Set priority grouping: 4 bits preemption, 0 sub-priority
    nvic_priority_group_config(NVIC_PRIORITY_GROUP_4);
    
    // Configure interrupts with different priorities
    nvic_irq_enable(TMR2_GLOBAL_IRQn, 0, 0);   // Highest priority
    nvic_irq_enable(USART1_IRQn, 1, 0);        // Second priority
    nvic_irq_enable(DMA1_Channel1_IRQn, 2, 0); // Third priority
    nvic_irq_enable(ADC1_2_IRQn, 3, 0);        // Lower priority
}
```

---

## Floating Point Unit (FPU)

### Overview

The Cortex-M4F includes a single-precision FPU that provides:
- IEEE 754 compliant single-precision operations
- Hardware support for add, subtract, multiply, divide, square root
- Fused multiply-accumulate (FMA) instructions
- Comparison and conversion operations

### FPU Performance Comparison

| Operation | Without FPU (cycles) | With FPU (cycles) | Speedup |
|-----------|---------------------|-------------------|---------|
| Addition | ~50-100 | 1-3 | 15-30x |
| Multiplication | ~100-200 | 1-3 | 30-70x |
| Division | ~200-400 | 14 | 15-30x |
| Square Root | ~300-500 | 14 | 20-35x |

### Enabling the FPU

The FPU must be enabled before use. This is typically done in startup code.

```c
// Enable FPU (set CP10 and CP11 to Full Access)
SCB->CPACR |= ((3UL << 10*2) | (3UL << 11*2));

// Ensure FPU is enabled before floating-point operations
__DSB();
__ISB();
```

### FPU Registers

| Register | Description |
|----------|-------------|
| S0-S31 | 32 single-precision registers |
| D0-D15 | 16 double-word registers (pairs of S registers) |
| FPSCR | Floating-Point Status and Control Register |

### FPSCR Bits

| Bit | Name | Description |
|-----|------|-------------|
| 31 | N | Negative flag |
| 30 | Z | Zero flag |
| 29 | C | Carry flag |
| 28 | V | Overflow flag |
| 26 | AHP | Alternative half-precision |
| 25 | DN | Default NaN mode |
| 24 | FZ | Flush-to-zero mode |
| 23:22 | RMode | Rounding mode |
| 4 | IDC | Input denormal exception |
| 3 | IXC | Inexact exception |
| 2 | UFC | Underflow exception |
| 1 | OFC | Overflow exception |
| 0 | DZC | Division by zero exception |

### Julia Set FPU Benchmark Example

This example generates a Julia set fractal to benchmark FPU performance.

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

#define SCREEN_X_SIZE    320
#define SCREEN_Y_SIZE    240
#define ZOOM             100
#define ITERATION        200
#define REAL_CONSTANT    (0.285f)
#define IMG_CONSTANT     (0.01f)

uint8_t buffer[SCREEN_X_SIZE * SCREEN_Y_SIZE];

/**
 * @brief  Generate Julia set fractal using FPU
 */
void generate_julia_fpu(uint16_t size_x, uint16_t size_y,
                        uint16_t offset_x, uint16_t offset_y,
                        uint16_t zoom, uint8_t *buffer)
{
    float tmp1, tmp2;
    float num_real, num_img;
    float rayon;
    uint16_t i;
    uint16_t x, y;
    
    for(y = 0; y < size_y; y++)
    {
        for(x = 0; x < size_x; x++)
        {
            num_real = y - offset_y;
            num_real = num_real / zoom;
            num_img = x - offset_x;
            num_img = num_img / zoom;
            i = 0;
            rayon = 0;
            
            while((i < ITERATION - 1) && (rayon < 4))
            {
                tmp1 = num_real * num_real;
                tmp2 = num_img * num_img;
                num_img = 2 * num_real * num_img + IMG_CONSTANT;
                num_real = tmp1 - tmp2 + REAL_CONSTANT;
                rayon = tmp1 + tmp2;
                i++;
            }
            
            buffer[x + y * size_x] = i;
        }
    }
}

int main(void)
{
    system_clock_config();
    at32_board_init();
    
    while(1)
    {
        at32_led_toggle(LED4);
        
        // Generate Julia set - LED toggle rate shows FPU performance
        generate_julia_fpu(SCREEN_X_SIZE, SCREEN_Y_SIZE,
                          SCREEN_X_SIZE / 2, SCREEN_Y_SIZE / 2,
                          ZOOM, buffer);
    }
}
```

### FPU Compiler Settings

**Keil MDK:**
```
Target Options → Floating Point Hardware: Use FPU
```

**GCC:**
```bash
-mfloat-abi=hard -mfpu=fpv4-sp-d16
```

**IAR:**
```
General Options → Library Configuration → Enable VFP
```

---

## Bit-Banding

### Overview

Bit-banding provides atomic bit-level access to memory. Each bit in the bit-band region maps to a full word in the alias region, enabling atomic set/clear operations.

### Memory Regions

| Region | Base Address | Alias Base | Size |
|--------|--------------|------------|------|
| SRAM | 0x20000000 | 0x22000000 | 1 MB |
| Peripheral | 0x40000000 | 0x42000000 | 1 MB |

### Bit-Band Address Formula

```
Alias_Address = Alias_Base + (Byte_Offset × 32) + (Bit_Number × 4)
```

Where:
- `Byte_Offset` = Address - Base_Address
- `Bit_Number` = 0-31

### Bit-Band Macros

```c
// SRAM Bit-Band
#define RAM_BASE            0x20000000
#define RAM_BITBAND_BASE    0x22000000

#define VARIABLES_RESET_BIT(addr, bit) \
    (*(uint32_t *)(RAM_BITBAND_BASE + ((addr - RAM_BASE) * 32) + ((bit) * 4)) = 0)

#define VARIABLES_SET_BIT(addr, bit) \
    (*(uint32_t *)(RAM_BITBAND_BASE + ((addr - RAM_BASE) * 32) + ((bit) * 4)) = 1)

#define VARIABLES_GET_BIT(addr, bit) \
    (*(uint32_t *)(RAM_BITBAND_BASE + ((addr - RAM_BASE) * 32) + ((bit) * 4)))

// Peripheral Bit-Band
#define PERIPHERAL_BASE         0x40000000
#define PERIPHERAL_BITBAND_BASE 0x42000000

#define PERIPHERAL_RESET_BIT(addr, bit) \
    (*(uint32_t *)(PERIPHERAL_BITBAND_BASE + ((addr - PERIPHERAL_BASE) * 32) + ((bit) * 4)) = 0)

#define PERIPHERAL_SET_BIT(addr, bit) \
    (*(uint32_t *)(PERIPHERAL_BITBAND_BASE + ((addr - PERIPHERAL_BASE) * 32) + ((bit) * 4)) = 1)
```

### Bit-Band Usage Example

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"

__IO uint32_t variables, variables_addr = 0, variables_bit_val = 0;

void result_error(void)
{
    while(1)
    {
        at32_led_toggle(LED4);
        delay_sec(1);
    }
}

int main(void)
{
    system_clock_config();
    at32_board_init();
    
    variables = 0xA5A5A5A5;
    variables_addr = (uint32_t)&variables;
    
    // Test bit 0 manipulation
    VARIABLES_RESET_BIT(variables_addr, 0);
    if((variables != 0xA5A5A5A4) || (VARIABLES_GET_BIT(variables_addr, 0) != 0))
    {
        result_error();
    }
    
    VARIABLES_SET_BIT(variables_addr, 0);
    if((variables != 0xA5A5A5A5) || (VARIABLES_GET_BIT(variables_addr, 0) != 1))
    {
        result_error();
    }
    
    // Test bit 16 manipulation
    VARIABLES_RESET_BIT(variables_addr, 16);
    if((variables != 0xA5A4A5A5) || (VARIABLES_GET_BIT(variables_addr, 16) != 0))
    {
        result_error();
    }
    
    VARIABLES_SET_BIT(variables_addr, 16);
    if((variables != 0xA5A5A5A5) || (VARIABLES_GET_BIT(variables_addr, 16) != 1))
    {
        result_error();
    }
    
    // Test bit 31 manipulation
    VARIABLES_RESET_BIT(variables_addr, 31);
    if((variables != 0x25A5A5A5) || (VARIABLES_GET_BIT(variables_addr, 31) != 0))
    {
        result_error();
    }
    
    VARIABLES_SET_BIT(variables_addr, 31);
    if((variables != 0xA5A5A5A5) || (VARIABLES_GET_BIT(variables_addr, 31) != 1))
    {
        result_error();
    }
    
    // Use bit-banding to toggle GPIO
    while(1)
    {
        // LED2 on GPIO pin 13
        PERIPHERAL_RESET_BIT((uint32_t)&LED2_GPIO->odt, 13);
        delay_ms(500);
        PERIPHERAL_SET_BIT((uint32_t)&LED2_GPIO->odt, 13);
        delay_ms(500);
    }
}
```

### Bit-Band Advantages

| Feature | Traditional Method | Bit-Band Method |
|---------|-------------------|-----------------|
| **Atomicity** | Requires disable IRQ | Always atomic |
| **Instructions** | Read-Modify-Write (3+) | Single store (1) |
| **Thread Safety** | Needs protection | Inherently safe |
| **Code Size** | Larger | Smaller |

### Generic Bit-Band Helper

```c
// Generic bit-band access structure
typedef struct {
    volatile uint32_t bit[32];
} bitband_t;

// Convert address to bit-band pointer
#define BITBAND_SRAM(addr) \
    ((bitband_t *)(RAM_BITBAND_BASE + ((((uint32_t)(addr)) - RAM_BASE) * 32)))

#define BITBAND_PERIPH(addr) \
    ((bitband_t *)(PERIPHERAL_BITBAND_BASE + ((((uint32_t)(addr)) - PERIPHERAL_BASE) * 32)))

// Usage example
uint32_t my_var = 0;

void example(void)
{
    bitband_t *bb = BITBAND_SRAM(&my_var);
    
    bb->bit[0] = 1;   // Set bit 0
    bb->bit[7] = 1;   // Set bit 7
    bb->bit[0] = 0;   // Clear bit 0
    
    if(bb->bit[7])    // Test bit 7
    {
        // Bit is set
    }
}
```

---

## CMSIS-DSP Library

### Overview

The CMSIS-DSP library provides optimized signal processing functions that take advantage of the Cortex-M4's DSP instructions and FPU.

### Function Categories

| Category | Description | Examples |
|----------|-------------|----------|
| **Basic Math** | Vector operations | arm_add_f32, arm_sub_f32, arm_mult_f32 |
| **Fast Math** | Trigonometric | arm_sin_f32, arm_cos_f32, arm_sqrt_f32 |
| **Complex Math** | Complex numbers | arm_cmplx_mag_f32, arm_cmplx_mult_f32 |
| **Filtering** | FIR/IIR filters | arm_fir_f32, arm_biquad_cascade_f32 |
| **Matrix** | Matrix operations | arm_mat_mult_f32, arm_mat_trans_f32 |
| **Transform** | FFT/DCT | arm_cfft_f32, arm_rfft_f32 |
| **Statistics** | Statistical functions | arm_mean_f32, arm_std_f32, arm_var_f32 |
| **Support** | Utility functions | arm_copy_f32, arm_fill_f32 |

### Matrix Operations Example

```c
#include "at32f403a_407_board.h"
#include "at32f403a_407_clock.h"
#include "arm_math.h"

#define NUMSTUDENTS  20
#define NUMSUBJECTS  4
#define TEST_LENGTH_SAMPLES  (NUMSTUDENTS * NUMSUBJECTS)

// Test marks for 20 students, 4 subjects each
const float32_t testMarks_f32[TEST_LENGTH_SAMPLES] = {
    42.0f, 37.0f, 81.0f, 28.0f,
    83.0f, 72.0f, 36.0f, 38.0f,
    32.0f, 51.0f, 63.0f, 64.0f,
    97.0f, 82.0f, 95.0f, 90.0f,
    66.0f, 51.0f, 54.0f, 42.0f,
    67.0f, 56.0f, 45.0f, 57.0f,
    67.0f, 69.0f, 35.0f, 52.0f,
    29.0f, 81.0f, 58.0f, 47.0f,
    38.0f, 76.0f, 100.0f, 29.0f,
    33.0f, 47.0f, 29.0f, 50.0f,
    34.0f, 41.0f, 61.0f, 46.0f,
    52.0f, 50.0f, 48.0f, 36.0f,
    47.0f, 55.0f, 44.0f, 40.0f,
    100.0f, 94.0f, 84.0f, 37.0f,
    32.0f, 71.0f, 47.0f, 77.0f,
    31.0f, 50.0f, 49.0f, 35.0f,
    63.0f, 67.0f, 40.0f, 31.0f,
    29.0f, 68.0f, 61.0f, 38.0f,
    31.0f, 28.0f, 28.0f, 76.0f,
    55.0f, 33.0f, 29.0f, 39.0f
};

// Unity vector for summing subjects
const float32_t testUnity_f32[NUMSUBJECTS] = {
    1.0f, 1.0f, 1.0f, 1.0f
};

// Output buffer
static float32_t testOutput[NUMSTUDENTS];

// Statistics variables
float32_t max_marks, min_marks, mean, std, var;
uint32_t student_num;

int main(void)
{
    // Initialize matrix structures
    arm_matrix_instance_f32 srcA = {
        NUMSTUDENTS, NUMSUBJECTS, (float32_t *)testMarks_f32
    };
    arm_matrix_instance_f32 srcB = {
        NUMSUBJECTS, 1, (float32_t *)testUnity_f32
    };
    arm_matrix_instance_f32 dstC = {
        NUMSTUDENTS, 1, testOutput
    };
    
    system_clock_config();
    uart_print_init(115200);
    
    // Matrix multiplication: total marks per student
    arm_mat_mult_f32(&srcA, &srcB, &dstC);
    
    // Calculate statistics
    arm_max_f32(testOutput, NUMSTUDENTS, &max_marks, &student_num);
    arm_min_f32(testOutput, NUMSTUDENTS, &min_marks, &student_num);
    arm_mean_f32(testOutput, NUMSTUDENTS, &mean);
    arm_std_f32(testOutput, NUMSTUDENTS, &std);
    arm_var_f32(testOutput, NUMSTUDENTS, &var);
    
    printf("max_marks = %f, min_marks = %f\n", max_marks, min_marks);
    printf("mean = %f, std = %f, var = %f\n", mean, std, var);
    
    while(1);
}
```

### Common CMSIS-DSP Functions

#### Statistical Functions

```c
// Find maximum value
void arm_max_f32(const float32_t *pSrc, uint32_t blockSize,
                 float32_t *pResult, uint32_t *pIndex);

// Find minimum value
void arm_min_f32(const float32_t *pSrc, uint32_t blockSize,
                 float32_t *pResult, uint32_t *pIndex);

// Calculate mean
void arm_mean_f32(const float32_t *pSrc, uint32_t blockSize,
                  float32_t *pResult);

// Calculate standard deviation
void arm_std_f32(const float32_t *pSrc, uint32_t blockSize,
                 float32_t *pResult);

// Calculate variance
void arm_var_f32(const float32_t *pSrc, uint32_t blockSize,
                 float32_t *pResult);
```

#### Matrix Functions

```c
// Initialize matrix
void arm_mat_init_f32(arm_matrix_instance_f32 *S,
                      uint16_t nRows, uint16_t nCols,
                      float32_t *pData);

// Matrix multiplication
arm_status arm_mat_mult_f32(const arm_matrix_instance_f32 *pSrcA,
                            const arm_matrix_instance_f32 *pSrcB,
                            arm_matrix_instance_f32 *pDst);

// Matrix transpose
arm_status arm_mat_trans_f32(const arm_matrix_instance_f32 *pSrc,
                             arm_matrix_instance_f32 *pDst);

// Matrix inverse
arm_status arm_mat_inverse_f32(const arm_matrix_instance_f32 *pSrc,
                               arm_matrix_instance_f32 *pDst);
```

#### Basic Math Functions

```c
// Vector addition
void arm_add_f32(const float32_t *pSrcA, const float32_t *pSrcB,
                 float32_t *pDst, uint32_t blockSize);

// Vector subtraction
void arm_sub_f32(const float32_t *pSrcA, const float32_t *pSrcB,
                 float32_t *pDst, uint32_t blockSize);

// Vector multiplication
void arm_mult_f32(const float32_t *pSrcA, const float32_t *pSrcB,
                  float32_t *pDst, uint32_t blockSize);

// Vector dot product
void arm_dot_prod_f32(const float32_t *pSrcA, const float32_t *pSrcB,
                      uint32_t blockSize, float32_t *result);
```

### Including CMSIS-DSP

1. Add include path to CMSIS-DSP headers
2. Link CMSIS-DSP library (arm_cortexM4lf_math.lib)
3. Define `ARM_MATH_CM4` in preprocessor

```c
#define ARM_MATH_CM4
#include "arm_math.h"
```

---

## Exception Handling

### Exception Types

| Exception | IRQ Number | Priority | Description |
|-----------|------------|----------|-------------|
| Reset | -3 | Fixed | Reset vector |
| NMI | -14 | -2 (Fixed) | Non-maskable interrupt |
| HardFault | -13 | -1 (Fixed) | All faults not handled |
| MemManage | -12 | Configurable | Memory protection |
| BusFault | -11 | Configurable | Bus error |
| UsageFault | -10 | Configurable | Undefined instruction |
| SVCall | -5 | Configurable | System service call |
| PendSV | -2 | Configurable | Pendable system service |
| SysTick | -1 | Configurable | System tick timer |

### Fault Handler Example

```c
void HardFault_Handler(void)
{
    // Get fault status registers
    volatile uint32_t cfsr = SCB->CFSR;
    volatile uint32_t hfsr = SCB->HFSR;
    volatile uint32_t mmfar = SCB->MMFAR;
    volatile uint32_t bfar = SCB->BFAR;
    
    // Analyze fault
    if(cfsr & SCB_CFSR_USGFAULTSR_Msk)
    {
        // Usage fault
    }
    if(cfsr & SCB_CFSR_BUSFAULTSR_Msk)
    {
        // Bus fault
    }
    if(cfsr & SCB_CFSR_MEMFAULTSR_Msk)
    {
        // Memory management fault
    }
    
    while(1)
    {
        // Halt in fault handler
    }
}
```

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| FPU not working | FPU not enabled | Enable CPACR before use |
| Hard fault on float | FPU disabled in compiler | Enable FPU in project settings |
| SysTick not firing | Clock not configured | Check SysTick clock source |
| Interrupt not firing | NVIC not enabled | Call nvic_irq_enable() |
| Wrong priority behavior | Incorrect priority group | Check nvic_priority_group_config() |
| Bit-band address fault | Address out of range | Verify address is in bit-band region |

### Debug Tips

1. **Check FPU status:**
```c
if((SCB->CPACR & (0xF << 20)) == (0xF << 20))
{
    // FPU is enabled
}
```

2. **Verify interrupt priorities:**
```c
uint32_t priority = NVIC_GetPriority(irqn);
```

3. **Check vector table location:**
```c
uint32_t vtor = SCB->VTOR;
```

---

## Related Documents

- [CRM - Clock and Reset Management](CRM_Clock_Reset_Management.md)
- [PWC - Power Control](PWC_Power_Control.md)
- [DEBUG - MCU Debug Support](DEBUG_MCU_Debug.md)
- AN0037 - FPU Application Note
- AN0036 - CMSIS-DSP Application Note
- AN0083 - Cortex-M4 Core Features Application Note

