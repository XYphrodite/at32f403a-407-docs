# AT32F403A Series Datasheet

**Version:** 2.04  
**Date:** 2023.10.17  

ARM®-based 32-bit Cortex®-M4 MCU+FPU with 256 to 1024 KB Flash, sLib, 17 timers, 3 ADCs, 20 communication interfaces (USBFS)

## Features

- **Core:** ARM® 32-bit Cortex®-M4 CPU with FPU
  - 240 MHz maximum frequency, with a memory protection unit (MPU), single-cycle multiplication and hardware division
  - Floating point unit (FPU) and DSP instructions

- **Memories**
  - 256 to 1024 KBytes of internal Flash memory
  - sLib: configurable part of main Flash set as a library area with code executable but secured, non-readable
  - SPIM interface: Extra interfacing up to 16 MBytes of the external SPI Flash (as instruction/data memory)
  - Up to 96+128 KBytes of SRAM
  - External memory controller (XMC) with 16-bit data bus. Supports multiplexed PSRAM/NOR and NAND memories

- **XMC** as LCD parallel interface, compatible with 8080/6800 modes

- **Power control (PWC)**
  - 2.6 to 3.6 V application supply
  - Power on reset (POR), low voltage reset (LVR), and power voltage monitoring (PVM)
  - Low power modes: Sleep, Deepsleep, and Standby modes
  - VBAT supply for LEXT, RTC, and forty-two 16-bit battery powered registers (BPR)

- **Clock and reset management (CRM)**
  - 4 to 25 MHz crystal (HEXT)
  - 48 MHz internal factory-trimmed high speed internal clock (HICK), offering 1 % accuracy at TA = 25 °C and 2.5 % accuracy at TA = -40 to +105 °C, with automatic clock calibration (ACC)
  - 32 kHz crystal (LEXT)
  - Low speed internal clock (LICK)

- **Analog**
  - 3 x 12-bit 2 MSPS A/D converters, up to 16 input channels
  - Temperature sensor (VTS) and internal reference voltage (VINTRV)
  - 2 x 12-bit D/A converters

- **DMA:** 14-channel DMA controller

- **Up to 80 fast GPIOs**
  - all mappable on 16 external interrupts (EXINT)
  - almost all 5 V-tolerant

- **Up to 17 timers (TMR)**
  - Up to 2 x 16-bit motor control PWM advanced timers with dead-time generator and emergency brake
  - Up to 8 x 16-bit + 2 x 32-bit timers, each with 4 IC/OC/PWM or pulse counter and quadrature encoder input
  - 2 x 16-bit basic timers to drive the DAC
  - 2 x watchdog timers (general WDT and windowed WWDT)
  - SysTick timer: a 24-bit downcounter

- **Up to 20 communication interfaces**
  - Up to 3 x I2C interfaces (SMBus/PMBus)
  - Up to 8 x USARTs (ISO7816 interface, LIN, IrDA capability, modem control)
  - Up to 4 x SPIs (50 Mbit/s), all with I2S interface multiplexed, I2S2/I2S3 support full-duplex
  - Up to 2 x CAN interface (2.0B Active)
  - USB 2.0 full speed interface supporting crystal-less
  - Up to 2 x SDIO interfaces

- **CRC** calculation unit, 96-bit unique ID (UID)

- **Debug mode**
  - Serial wire debug (SWD) and JTAG interfaces
  - Cortex®-M4 Embedded Trace Macrocell (ETMTM)

- **Operating temperatures:** -40 to +105 °C

- **Packages**
  - LQFP100 14 x 14 mm
  - LQFP64 10 x 10 mm
  - LQFP48 7 x 7 mm
  - QFN48 6 x 6 mm

### Table 1. Device summary

| Internal Flash | Part number |
| -------------- | ----------- |
| 1024 KBytes | AT32F403ACGT7, AT32F403ACGU7, AT32F403ARGT7, AT32F403AVGT7 |
| 512 KBytes | AT32F403ACET7, AT32F403ACEU7, AT32F403ARET7, AT32F403AVET7 |
| 256 KBytes | AT32F403ACCT7, AT32F403ACCU7, AT32F403ARCT7, AT32F403AVCT7 |

## Contents

1. Descriptions ....................................................................................................................................... 9

2. Functional overview ......................................................................................................................... 11

  2.1 ARM® Cortex®-M4 with FPU .................................................................................................. 11

  2.2 Memory ................................................................................................................................... 12

    2.2.1 Internal Flash memory ................................................................................................ 12

    2.2.2 Memory protection unit (MPU) ................................................................................... 12

    2.2.3 Embedded SRAM ..................................................................................................... 12

    2.2.4 External memory controller (XMC) ............................................................................ 12

  2.3 Interrupts ................................................................................................................................. 13

    2.3.1 Nested vectored interrupt controller (NVIC) ............................................................. 13

    2.3.2 External interrupts (EXINT) ....................................................................................... 13

  2.4 Power control (PWC) ............................................................................................................. 13

    2.4.1 Power supply schemes .............................................................................................. 13

    2.4.2 Reset and power voltage monitoring (POR / LVR / PVM) ....................................... 13

    2.4.3 Voltage regulator (LDO) ............................................................................................. 13

    2.4.4 Low-power modes ...................................................................................................... 14

  2.5 Boot modes ............................................................................................................................ 14

  2.6 Clocks ............................................................................................................................. 15

  2.7 General-purpose inputs / outputs (GPIOs) ..................................................................... 15

  2.8 Remap capability .................................................................................................... 15

  2.9 Direct Memory Access Controller (DMA) ................................................................ 16

  2.10 Timers (TMR) ......................................................................................................... 16

    2.10.1 Advanced timers (TMR1 and TMR8) ......................................................................... 17

    2.10.2 General-purpose timers (TMRx) ................................................................................ 17

    2.10.3 Basic timers (TMR6 and TMR7)................................................................................. 18

    2.10.4 SysTick timer .............................................................................................................. 18

  2.11 Watchdog (WDT) .................................................................................................... 18

  2.12 Window watchdog (WWDT) ................................................................................... 18

  2.13 Real-time clock (RTC) and battery powered registers (BPR) .................................. 18

  2.14 Communication interfaces ...................................................................................... 19

    2.14.1 Serial peripheral interface (SPI) ................................................................................. 19

    2.14.2 Inter-integrated sound interface (I2S) ......................................................................... 19

    2.14.3 Universal synchronous / asynchronous receiver transmitters (USART) ................... 19

    2.14.4 Inter-integrated-circuit interface (I2C) ......................................................................... 20

    2.14.5 Secure digital input / output interface (SDIO) ............................................................ 20

    2.14.6 Controller area network (CAN) ................................................................................... 20

    2.14.7 Universal serial bus full-speed (USBFS).................................................................... 20

  2.15 Cyclic redundancy check (CRC) calculation unit .................................................... 20

  2.16 Analog-to-digital converter (ADC) ........................................................................... 21

    2.16.1 Temperature sensor (VTS) .......................................................................................... 21

    2.16.2 Internal reference voltage (VINTRV) ............................................................................. 21

  2.17 Digital-to-analog converter (DAC) ........................................................................... 22

  2.18 Debug ..................................................................................................................... 22

    2.18.1 Serial wire (SWD) / JTAG port ................................................................................... 22

    2.18.2 Embedded Trace Macrocell (ETMTM) ......................................................................... 22

3. Pin functional definitions .................................................................................... 23

4. Memory mapping ................................................................................................. 33

5. Electrical characteristics .................................................................................... 34

  5.1 Parameter conditions.............................................................................................. 34

    5.1.1 Minimum and maximum values ................................................................................. 34

    5.1.2 Typical values ............................................................................................................. 34

    5.1.3 Typical curves ............................................................................................................. 34

    5.1.4 Power supply scheme ................................................................................................ 34

  5.2 Absolute maximum values ...................................................................................... 35

    5.2.1 Ratings ....................................................................................................................... 35

    5.2.2 Electrical sensitivity .................................................................................................... 36

  5.3 Specification ........................................................................................................... 37

    5.3.1 General operating conditions ..................................................................................... 37

    5.3.2 Operating conditions at power-up / power-down ....................................................... 37

    5.3.3 Embedded reset and power control block characteristics ......................................... 38

    5.3.4 Memory characteristics .............................................................................................. 39

    5.3.5 Supply current characteristics .................................................................................... 40

    5.3.6 External clock source characteristics ......................................................................... 49

    5.3.7 Internal clock source characteristics .......................................................................... 53

    5.3.8 PLL characteristics ..................................................................................................... 54

    5.3.9 Wakeup time from low-power mode........................................................................... 54

    5.3.10 EMC characteristics ................................................................................................... 55

    5.3.11 GPIO port characteristics ........................................................................................... 56

    5.3.12 NRST pin characteristics ............................................................................................ 58

    5.3.13 XMC characteristics ................................................................................................... 58

    5.3.14 TMR timer characteristics .......................................................................................... 66

    5.3.15 SPI characteristics...................................................................................................... 67

    5.3.16 I2S characteristics ....................................................................................................... 69

    5.3.17 I2C interface characteristics ....................................................................................... 70

    5.3.18 SDIO characteristics................................................................................................... 71

    5.3.19 USBFS characteristics ............................................................................................... 72

    5.3.20 12-bit ADC characteristics .......................................................................................... 73

    5.3.21 Internal reference voltage (VINTRV) characteristics ..................................................... 78

    5.3.22 Temperature sensor (VTS) characteristics .................................................................. 78

    5.3.23 12-bit DAC specifications ........................................................................................... 79

6. Package information ........................................................................................... 80

  6.1 LQFP100 package information ............................................................................... 80

  6.2 LQFP64 package information ................................................................................. 82

  6.3 LQFP48 package information ................................................................................. 84

  6.4 QFN48 package information ................................................................................... 86

  6.5 Device marking ....................................................................................................... 87

  6.6 Thermal characteristics .......................................................................................... 88

7. Part numbering .................................................................................................... 89

8. Document revision history ................................................................................. 90

## List of Tables

- Table 1. Device summary .................................................................................................................... 1

- Table 2. AT32F403A features and peripheral counts......................................................................... 10

- Table 3. The Bootloader supporting part numbers and pin configurations ....................................... 15

- Table 4. Timer feature comparison .................................................................................................... 16

- Table 5. USART / UART feature comparison .................................................................................... 19

- Table 6. AT32F403A series pin definitions ......................................................................................... 26

- Table 7. XMC pin definition ................................................................................................................ 31

- Table 8. Voltage characteristics ......................................................................................................... 35

- Table 9. Current characteristics ......................................................................................................... 35

- Table 10. Thermal characteristics ...................................................................................................... 35

- Table 11. ESD values ......................................................................................................................... 36

- Table 12. Latch-up values .................................................................................................................. 36

- Table 13. General operating conditions ............................................................................................. 37

- Table 14. Operating conditions at power-up / power-down ............................................................... 37

- Table 15. Embedded reset and power management block characteristics ....................................... 38

- Table 16. Internal Flash memory characteristics ............................................................................... 39

- Table 17. Internal Flash memory endurance and data retention ....................................................... 39

- Table 18. Typical current consumption in Run mode......................................................................... 41

- Table 19. Typical current consumption in Sleep mode ...................................................................... 42

- Table 20. Maximum current consumption in Run mode .................................................................... 43

- Table 21. Maximum current consumption in Sleep mode ................................................................. 44

- Table 22. Typical and maximum current consumptions in Deepsleep and Standby modes ............. 44

- Table 23. Typical and maximum current consumptions on VBAT ....................................................... 46

- Table 24. Peripheral current consumption ......................................................................................... 47

- Table 25. HEXT 4-25 MHz crystal characteristics(1)(2) ....................................................................... 49

- Table 26. HEXT external source characteristics ................................................................................ 50

- Table 27. LEXT 32.768 kHz crystal characteristics(1)(2) ..................................................................... 51

- Table 28. LEXT external source characteristics ................................................................................ 52

- Table 29. HICK clock characteristics ................................................................................................. 53

- Table 30. LICK clock characteristics .................................................................................................. 53

- Table 31. PLL characteristics ............................................................................................................. 54

- Table 32. Low-power mode wakeup time .......................................................................................... 54

- Table 33. EMS characteristics ........................................................................................................... 55

- Table 34. GPIO static characteristics ................................................................................................. 56

- Table 35. Output voltage characteristics............................................................................................ 57

- Table 36. Input AC characteristics ..................................................................................................... 57

- Table 37. NRST pin characteristics.................................................................................................... 58

- Table 38. Asynchronous multiplexed PSRAM / NOR read timings ................................................... 59

- Table 39. Asynchronous multiplexed PSRAM / NOR write timings ................................................... 60

- Table 40. Synchronous multiplexed PSRAM / NOR read timings ..................................................... 62

- Table 41. Synchronous multiplexed PSRAM write timings ................................................................ 63

- Table 42. NAND Flash read and write timings ................................................................................... 64

- Table 43. TMR characteristics ........................................................................................................... 66

- Table 44. SPI characteristics ............................................................................................................. 67

- Table 45. I2S characteristics .............................................................................................................. 69

- Table 46. SD / MMC characteristics .................................................................................................. 71

- Table 47. USBFS startup time ........................................................................................................... 72

- Table 48. USBFS DC electrical characteristics ................................................................................. 72

- Table 49. USBFS electrical characteristics ........................................................................................ 72

- Table 50. ADC characteristics ............................................................................................................ 73

- Table 51. RAIN max for fADC = 14 MHz ................................................................................................ 74

- Table 52. RAIN max for fADC = 28 MHz ................................................................................................ 74

- Table 53. ADC accuracy(1) ................................................................................................................. 75

- Table 54. Internal reference voltage characteristics .......................................................................... 78

- Table 55. Temperature sensor characteristics ................................................................................... 78

- Table 56. DAC characteristics ............................................................................................................ 79

- Table 57. LQFP100 – 14 x 14 mm 100 pin low-profile quad flat package mechanical data ............. 81

- Table 58. LQFP64 – 10 x 10 mm 64 pin low-profile quad flat package mechanical data ................. 83

- Table 59. LQFP48 – 7 x 7 mm 48 pin low-profile quad flat package mechanical data ..................... 85

- Table 60. QFN48 – 6 x 6 mm 48 pin quad flat no-leads package mechanical data ......................... 87

- Table 61. Package thermal characteristics ........................................................................................ 88

- Table 62. AT32F403A series part numbering .................................................................................... 89

- Table 63. Document revision history .................................................................................................. 90

## List of Figures

- Figure 1. AT32F403A block diagram ................................................................................................. 11

- Figure 2. AT32F403A LQFP100 pinout ............................................................................................. 23

- Figure 3. AT32F403A LQFP64 pinout ............................................................................................... 24

- Figure 4. AT32F403A LQFP48 pinout ............................................................................................... 25

- Figure 5. AT32F403A QFN48 pinout ................................................................................................. 25

- Figure 6. Memory map ....................................................................................................................... 33

- Figure 7. Power supply scheme ........................................................................................................ 34

- Figure 8. Power on reset and low voltage reset waveform ............................................................... 39

- Figure 9. Typical current consumption in Deepsleep mode vs. temperature at different VDD .......... 45

- Figure 10. Typical current consumption in Standby mode vs. temperature at different VDD ............ 45

- Figure 11. Typical current consumption on VBAT with LEXT and RTC ON vs. temperature at different VBAT ................................................................................................................................................ 46

- Figure 12. HEXT typical application with an 8 MHz crystal ............................................................... 49

- Figure 13. HEXT external source AC timing diagram........................................................................ 50

- Figure 14. LEXT typical application with a 32.768 kHz crystal ......................................................... 51

- Figure 15. LEXT external source AC timing diagram ........................................................................ 52

- Figure 16. HICK clock frequency accuracy vs. temperature ............................................................. 53

- Figure 17. Recommended NRST pin protection ............................................................................... 58

- Figure 18. Asynchronous multiplexed PSRAM / NOR read waveforms ........................................... 59

- Figure 19. Asynchronous multiplexed PSRAM / NOR write waveforms ........................................... 60

- Figure 20. Synchronous multiplexed PSRAM / NOR read timings ................................................... 62

- Figure 21. Synchronous multiplexed PSRAM write timings .............................................................. 63

- Figure 22. NAND controller read waveforms ..................................................................................... 65

- Figure 23. NAND controller write waveforms .................................................................................... 65

- Figure 24. NAND controller common memory read waveforms ....................................................... 65

- Figure 25. NAND controller for common memory write waveforms .................................................. 66

- Figure 26. SPI timing diagram - slave mode and CPHA = 0 ............................................................. 68

- Figure 27. SPI timing diagram - slave mode and CPHA = 1 ............................................................. 68

- Figure 28. SPI timing diagram - master mode ................................................................................... 68

- Figure 29. I2S slave timing diagram (Philips protocol) ...................................................................... 69

- Figure 30. I2S master timing diagram (Philips protocol) .................................................................... 70

- Figure 31. SDIO high-speed mode .................................................................................................... 71

- Figure 32. SD default mode ............................................................................................................... 71

- Figure 33. USBFS timings: definition of data signal rise and fall time .............................................. 72

- Figure 34. ADC accuracy characteristics .......................................................................................... 75

- Figure 35. Typical connection diagram using the ADC ..................................................................... 76

- Figure 36. Power supply and reference decoupling (with external VREF pin) .................................... 76

- Figure 37. Power supply and reference decoupling (without external VREF pin) ............................... 77

- Figure 38. VTS vs. temperature .......................................................................................................... 78

- Figure 39. LQFP100 – 14 x 14 mm 100 pin low-profile quad flat package outline ........................... 80

- Figure 40. LQFP64 – 10 x 10 mm 64 pin low-profile quad flat package outline ............................... 82

- Figure 41. LQFP48 – 7 x 7 mm 48 pin low-profile quad flat package outline ................................... 84

- Figure 42. QFN48 – 6 x 6 mm 48 pin quad flat no-leads package outline ........................................ 86

- Figure 43. Marking example .............................................................................................................. 87

## 1 Descriptions

The AT32F403A series is based on the high-performance ARM®Cortex®-M4 32-bit RISC core operating at a frequency of up to 240 MHz. The Cortex®-M4 core features a Floating point unit (FPU) single precision which supports all ARM® single-precision data processing instructions and data types. It also implements a full set of DSP instructions and a memory protection unit (MPU) which enhances application security.

The AT32F403A series incorporates high-speed embedded memories (up to 1024 KBytes of internal Flash memory, 96+128 KBytes of SRAM), external SPI Flash (up to 16 MBytes addressing capability), and a wide range of enhanced GPIOs and peripherals connected to two APB buses. Any block of the embedded Flash memory can be protected by the “sLib” (security library), functioning as a security area with code-excutable only.

The AT32F403A series offers three 12-bit ADC, two 12-bit DAC, eight general-purpose 16-bit timers plus two general-purpose 32-bit timers, and up to two PWM timers for motor control. It supports standard and advanced communication interfaces: up to three I2Cs, four SPIs (all multiplexed as I2Ss), two SDIOs, eight USARTs/UARTs, one USBFS, and two CANs.

The AT32F403A series operates in the -40 to +105 °C temperature range, from a 2.6 to 3.6 V power supply. A comprehensive set of power-saving mode allows the design of low-power application.

The AT32F403A series offers devices in different package types. They are fully pin-to-pin, software and functionaly compatible with the entire AT32F403A series devices, except that the configurations of peripherals are not completely identical, depending on the package types.

### Table 2. AT32F403A features and peripheral counts

| Part Number | AT32F403AxxU7 | AT32F403AxxT7 |
|-------------|---------------|---------------|
| | CC | CE | CG | CC | CE | CG | RC | RE | RG | VC | VE | VG |
| CPU frequency (MHz) | 240 | | | | | | | | | | | |
| Int. Flash(1)(2) ZW (KBytes) | 256 | 256 | 256 | 256 | 256 | 256 | 256 | 256 | 256 | 256 | 256 | 256 |
| NZW (KBytes) | 0 | 256 | 768 | 0 | 256 | 768 | 0 | 256 | 768 | 0 | 256 | 768 |
| Total (KBytes) | 256 | 512 | 1024 | 256 | 512 | 1024 | 256 | 512 | 1024 | 256 | 512 | 1024 |
| SRAM(2) (KBytes) | 96 + 128 | | | | | | | | | | | |
| SPIM(3) | 1 ch / up to 16 MB | | | | | | | | | | | |
| XMC | - | - | 1(4) | 1 | | | | | | | | |
| Timers Advanced | 2 | 2 | 2 | 2 | | | | | | | | |
| 32-bit general-purpose | 2 | 2 | 2 | 2 | | | | | | | | |
| 16-bit general-purpose | 8 | 8 | 8 | 8 | | | | | | | | |
| Basic | 2 | 2 | 2 | 2 | | | | | | | | |
| SysTick | 1 | 1 | 1 | 1 | | | | | | | | |
| WDT | 1 | 1 | 1 | 1 | | | | | | | | |
| WWDT | 1 | 1 | 1 | 1 | | | | | | | | |
| RTC | 1 | 1 | 1 | 1 | | | | | | | | |
| Communication I2C | 3 | 3 | 3 | 3 | | | | | | | | |
| SPI(5) | 4 | 4 | 4 | 4 | | | | | | | | |
| I2S(5) | 4 (2 full-duplex) | 4 (2 full-duplex) | 4 (2 full-duplex) | 4 (2 full-duplex) | | | | | | | | |
| USART + UART | 3 + 4(6) | 3 + 4(6) | 4 + 4 | 4 + 4 | | | | | | | | |
| SDIO | 1(7) | 1(7) | 2 | 2 | | | | | | | | |
| USBFS device | 1 | 1 | 1 | 1 | | | | | | | | |
| CAN | 2 | 2 | 2 | 2 | | | | | | | | |
| Analog 12-bit ADC numbers/channels | 3 / 10 | 10 | 16 | 16 | | | | | | | | |
| 12-bit DAC numbers | 2 | | | | | | | | | | | |
| GPIO | 37 | 37 | 51 | 80 | | | | | | | | |
| Operating temperatures | -40 to +105 °C | | | | | | | | | | | |
| Packages | QFN48 6 x 6 mm | LQFP48 7 x 7 mm | LQFP64 10 x 10 mm | LQFP100 14 x 14 mm | | | | | | | | |

(1) ZW = zero wait-state, up to SYSCLK 240 MHz NZW = non-zero wait-state  
(2) The internal Flash and SRAM sizes are configurable with User System Data. Take the AT32F403AVGT7 as an example, on which the Flash/SRAM can be configured into two options below: - ZW: 256 KBytes, NZW: 768 KBytes, SRAM: 96 KBytes; - ZW: 128 KBytes, NZW: 896 KBytes, SRAM: 224 KBytes.  
(3) SPIM = External four-wire SPI Flash memory extension (for program execution/ data storage with encryption capability).  
(4) For LQFP64 package, XMC only supports the LCD panel with 8-bit mode.  
(5) I2S shares the same pin with SPI.  
(6) For LQFP48 and QFN48 packages, UART8 is not available and USART6 is used as UART for no CK pin.  
(7) For LQFP48 and QFN48 packages, only SDIO2 exists and supports maximum 4-bit (D0~D3) mode.

## 2 Functional overview

### 2.1 ARM® Cortex®-M4 with FPU

The ARM®Cortex®-M4 processor is the latest generation of ARM® processors for embedded systems. It is a 32-bit RISC processor featuring exceptional code efficiency, outstanding computing power and advanced response to interrupts. The processor supports a set of DSP instructions which enable efficient signal processing and complex algorithm execution. Its single precision FPU (floating point unit) speeds up floating point calculation while avoiding saturation. Figure 1 shows the general block diagram of the AT32F403A.

[Figure 1: AT32F403A block diagram]

### 2.2 Memory

#### 2.2.1 Internal Flash memory

Up to 1024 KBytes of embedded Flash is available for storing programs and data. Any part of the embedded Flash memory can be protected by the sLib (security library), a security area that is code-excutable only but non-readable. “sLib” is a mechanism designed to protect the intelligence of solution venders and facilitate the second-level development by customers.

Additionally, there is an external four-wire SPI Flash memory interface available for accessing up to 16MB. The external SPI Flash memory is used as an extended Flash memory bank 3. Ciphertext protection feature is also supported. Therefore it is possible to select wheter to encrypt data by setting the user system data. The range to be encrypted is configured through the corresponding register.  

There is another 18-KByte boot code area in which the boodloader is stored.

A User System Data block is included, which is used to configure the hardware behaviors such as read/erase/write protection and watchdog self-enable. User System Data allows to set erase/write and read protection individually.

#### 2.2.2 Memory protection unit (MPU)

The memory protection unit (MPU) is used to manage the CPU accesses to memory to prevent one task to accidentally corrupt the memory or resources used by any other active task. This memory area consists of up to 8 protected areas that can in turn be divided up into 8 subareas. The protection area sizes are between 32 bytes and the entire 4 gigabytes of addressable memory.

The MPU is especially suited to the applications where some critical or certified code has to be protected against the misbehavior of other tasks. It is usually managed by an RTOS (real-time operating system).

#### 2.2.3 Embedded SRAM

The device offers up to 224 KBytes of embedded SRAM that is accessible (read/write) at CPU clock speed with 0 wait states.

#### 2.2.4 External memory controller (XMC)

The XMC is embedded in the AT32F403A. It has two Chip Select outputs supporting the following modes: multiplexed PSRAM/NOR and 16-bit/8-bit NAND memory.

**Main features:**
- Write buffer area
- Code execution from external memory of the multiplexed PSRAM/NOR

The XMC can be configured to interface with most graphic LCD controllers. It supports the Intel 8080 and Motorola 6800 modes.

### 2.3 Interrupts

#### 2.3.1 Nested vectored interrupt controller (NVIC)

The AT32F403A embed a nested vectored interrupt controller able to manage 16 priority levels and handle maskable interrupt channels plus the 16 interrupt lines of the Cortex®-M4 core. This hardware block provides flexible interrupt management features with minimal interrupt latency.

#### 2.3.2 External interrupts (EXINT)

The external interrupt (EXINT), which is connected directly with NVIC, consists of 19 edge detector lines used to generate interrupt requests. Each line can be independently configured to select the trigger event (rising edge, falling edge, both) and can be masked independently. A pending register maintains the status of the interrupt requests. The external interrupt lines connects up to 16 GPIOs.

### 2.4 Power control (PWC)

#### 2.4.1 Power supply schemes

- VDD = 2.6～3.6 V: external power supply for GPIOs and the internal block such as regulator (LDO), provided externally through VDD pins.
- VDDA = 2.6～3.6 V: external analog power supplies for ADC and DAC. VDDA and VSSA must be the same voltage potential as VDD and VSS, respectively.
- VBAT = 1.8～3.6 V: power supply for VBAT domain through the external battery or super capacitor, or from VDD when the external battery or super capacitor is not present. The VBAT (through power switch) supplies for RTC, external crystal 32 kHz (LEXT), and battery powered registers (BPR) when VDD is not present.

#### 2.4.2 Reset and power voltage monitoring (POR / LVR / PVM)

The device has an integrated power-on reset (POR)/low voltage reset (PDR) circuitry. It is always active, and allows proper operation starting from/down to 2.6 V. The device remains in reset mode when VDD is below a specified threshold (VLVR) without the need for an external reset circuit.

The device features an embedded power voltage monitor (PVM) that monitors the VDD power supply and compares it to the VPVM threshold. An interrupt can be generated when VDD drops below the VPVM threshold and/or when VDD rises above the VPVM threshold. The PVM is enabled by software.

#### 2.4.3 Voltage regulator (LDO)

The LDO has three operation modes: normal mode, low-power mode, and power down mode.

- Normal mode: It is used in Run/Sleep mode and in the Deepsleep mode;
- Low-power mode: It can be used in the Deepsleep mode;
- Power down mode: It is used in Standby mode: The LDO output is in high impedance and the kernel circuitry is powered down but the contents of the registers and SRAM are lost.

This LDO operates always in its normal mode after reset.

#### 2.4.4 Low-power modes

The AT32F403A supports three low-power modes:

- Sleep mode

  In Sleep mode, only the CPU is stopped. All peripherals continue to operate and can wake up the CPU when an interrupt/event occurs.

- Deepsleep mode

  Deepsleep mode achieves the lowest power consumption while retaining the content of SRAM and registers. All clocks in the LDO domain are stopped, disabling the PLL, the HICK clock, and the HEXT crystal oscillator. The voltage regulator can also be put in normal or low-power mode.

  The device can be woken up from Deepsleep mode by any of the EXINT line. The EXINT line source can be one of the 16 external lines, the PVM output, the RTC alarm, or the USBFS wakeup.

- Standby mode

  The Standby mode is used to achieve the lowest power consumption. The internal voltage regulator is switched off so that the entire LDO domain is powered off. The PLL, the HICK clock and the HEXT crystal oscillator are also switched off. After entering Standby mode, SRAM and register contents are lost except for registers in the BPR domain, RTC domain and Standby circuitry.

  The device leaves Standby mode when an external reset (NRST pin), a WDT reset, a rising edge on the WKUP pin, or an RTC alarm occurs.

Note: The RTC and the corresponding clock sources are not stopped by entering Deepsleep or Standby mode. WDT depends on User System Data setting.

### 2.5 Boot modes

At startup, boot pins are used to select one of three boot options:

- Boot from the internal Flash memory. For the AT32F403AxG, user has an option to boot from any of two memory banks. By default, boot from Flash memory Bank 1 is selected. User can also choose to boot from Flash memory Bank 2 using the User System Data;
- Boot from boot code area;
- Boot from embedded SRAM.

The bootloader is stored in boot code area. It is used to reprogram the Flash memory through USART1, USART2, or USBFS1. Of them, the USBFS1 supports crystal-less mode. If SPIM_IO0/1 pin is configured to be shared with USBFS1 pin, the SPIM Flash memory Bank 3 cannot be programmed through USBFS1. Table 3 presents AT32F403A pin configurations relative to Bootloader.

### Table 3. The Bootloader supporting part numbers and pin configurations

| Interface | Part number | Pin |
|-----------|-------------|-----|
| USART1 | All part numbers | PA9: USART1_TX <br> PA10: USART1_RX |
| USART2 | AT32F403AVGT7 | PD5: USART2_TX (remapped) <br> PD6: USART2_RX (remapped) |
| | Part numbers except AT32F403AVGT7 | PA2: USART2_TX <br> PA3: USART2_RX |
| USBFS1 | All part numbers | PA11: USBFS1_D- <br> PA12: USBFS1_D+ |

### 2.6 Clocks

On reset, the internal 48 MHz clock (HICK) divided by 6 (that is 8 MHz) is selected as default CPU clock after any reset. The application can select an external 4 to 25 MHz clock (HEXT) as a system clock. This clock can be monitored for failure. If failure is detected, HEXT will be switched off and the system automatically switches back to the internal HICK. A software interrupt is generated.

Similarly, the system take the same action once HEXT fails when it is used as the source of PLL.

Several prescalers are available to allow the configuration of the AHB and the APB (APB1 and APB2) frequency. The maximum frequency of the AHB domain is 240 MHz. The maximum allowed frequency of the APB domain is 120 MHz.

The AT32F403A embeded an automatic clock calibration (ACC) block, which calibrates the internal 48 MHz HICK clock, assuring the most precise accuracy of the HICK in the full ragne of the operating temperatures.

### 2.7 General-purpose inputs / outputs (GPIOs)

Each of the GPIO pins can be configured by software as output (push-pull or open-drain), as input (with or without pull-up or pull-down), or as multiple function. Most of the GPIO pins are shared with digital or analog multiple functions. All GPIOs are high current-capable.

The GPIO’s configuration can be locked, if needed, in order to avoid spurious writing to the GPIO’s registers by following a specific sequence.

### 2.8 Remap capability

This feature allows the use of a maximum number of peripherals in a given application. Indeed, multiple functions are available not only on the default pins but also on other specific pins onto which they are remappable. This has the advantage of making board design and port usage much more flexible.

For details refer to Table 6; it shows the list of remappable multiple functions and the pins onto which they can be remapped. See the AT32F403A reference manual for software considerations.

### 2.9 Direct Memory Access Controller (DMA)

The device features two general-purpose dual-port DMAs (7 channels for DMA1 and 7 channels for DMA2). They are able to manage memory-to-memory, peripheral-to-memory, and memory-to-peripheral transfers. These two DMA controllers support circular buffer management, removing the need for user code intervention when the controller reaches the end of the buffer.

Each channel is connected to dedicated hardware DMA requests, with support for software trigger on each channel. Configuration is made by software and transfer sizes between source and destination are independent.

The DMA can be used with the main peripherals: SPI, I2C, USART, advanced, general-purpose, and basic timers TMRx, DAC, I2S, SDIO, and ADC.

### 2.10 Timers (TMR)

The AT32F403A device includes two advanced timers, ten general-purpose timers, two basic timers and a SysTick timer.

The table below compares the features of the advanced, general-purpose, and basic timers.

### Table 4. Timer feature comparison

| Timer | Counter resolution | Counter type | Prescaler factor | DMA request generation | Capture/compare channels | Complementary outputs |
|-------|---------------------|--------------|-----------------|-------------------------|---------------------------|-----------------------|
| TMR1, TMR8 | 16-bit | Up, down, up/down | Any integer between 1 and 65536 | Yes | 4 | Yes |
| TMR2, TMR5 | 16-bit or 32-bit | Up, down, up/down | Any integer between 1 and 65536 | Yes | 4 | No |
| TMR3, TMR4 | 16-bit | Up, down, up/down | Any integer between 1 and 65536 | Yes | 4 | No |
| TMR9, TMR12 | 16-bit | Up | Any integer between 1 and 65536 | No | 2 | No |
| TMR10, TMR11 TMR13, TMR14 | 16-bit | Up | Any integer between 1 and 65536 | No | 1 | No |
| TMR6, TMR7 | 16-bit | Up | Any integer between 1 and 65536 | Yes | 0 | No |

#### 2.10.1 Advanced timers (TMR1 and TMR8)

The two advanced timers (TMR1 and TMR8) can each be seen three-phase PWM generators multiplexed on 6 channels. They have complementary PWM outputs with programmable dead-time insertion. They can also be seen as a complete general-purpose timer. Their four independent channels can be used for:

- Input capture
- Output compare
- PWM generation (edge or center-aligned modes)
- One-cycle mode output

If configured as a standard 16-bit timer, it has the same features as the TMRx timer. If configured as the 16-bit PWM generator, it has full modulation capability (0-100%).

In debug mode, the advanced timer counter can be frozen and the PWM outputs disabled to turn off any power switch driven by these outputs.

Many features are shared with those of the general-purpose TMR which have the same architecture. The advanced timer can therefore work together with the general-purpose timers via the timer link feature for synchronization or event chaining.

#### 2.10.2 General-purpose timers (TMRx)

There are 10 synchronizable general-purpose timers embedded in the AT32F403A series.

- TMR2, TMR3, TMR4, and TMR5

  The AT32F403A has 4 full- featured general-purpose timers: TMR2, TMR3, TMR4, and TMR5.The TMR2 and TMR5 timers are based on a 32-bit auto-reload up/down counter and a 16-bit prescaler. The TMR3 and TMR4 timers are based on a 16- bit auto-reload up/down counter and a 16-bit prescaler. They can offer four independent channels on the largest package. Each channel can be used for input capture/output compare, PWM or one-cycle mode output.

  These general-purpose timers can work together with advanced timers via the timer link feature for synchronization or event chaining. In debug mode, their countesr can be frozen.

  Any of these general-purpose timers can be used to generate PWM outputs. Each timer has individual DMA request.

  These timers are capable of handling incremental quadrature encoder signals and the digital outputs coming from 1 to 3 hall-effect sensors.

- TMR9 and TMR12

  TMR9 and TMR12 are based on a 16-bit auto-reload upcounter, a 16-bit prescaler, and two independent channels for input capture/output compare, PWM, or one-cycle mode output.

  They can be synchronized with the TMR2, TMR3, TMR4, and TMR5 full-featured general-purpose timers. They can also be used as simple time bases.

- TMR10, TMR11, TMR13, and TMR14

  These timers are based on a 16-bit auto-reload upcounter, a 16-bit prescaler, and one independent channels for input capture/output compare, PWM, or one-cycle mode output.

  They can be synchronized with the TMR2, TMR3, TMR4, and TMR5 full-featured general-purpose timers. They can also be used as simple time bases.

#### 2.10.3 Basic timers (TMR6 and TMR7)

These two timers are mainly used for DAC trigger generation. Each of them can also be used as a generic 16-bit time base.

#### 2.10.4 SysTick timer

This timer is dedicated to real-time operating systems, but could also be used as a standard down counter. It features include:

- A 24-bit down counter
- Autoreload capability
- Maskable system interrupt generation when the counter reaches 0
- Programmable clock source (HICK or HICK/8)

### 2.11 Watchdog (WDT)

The watchdog consists of a 12-bit downcounter and 8-bit prescaler. It is clocked by an independent internal LICK clock. As it operates independently from the main clock, it can operate in Deepsleep and Standby modes. It can be used either as a watchdog to reset the device when an error occurs, or as a free running timer for application timeout management. It is self-enabled through the User System Data configuration. The counter can be frozen in debug mode.

### 2.12 Window watchdog (WWDT)

The window watchdog embeds a 7-bit downcounter that can be set as free running. It can be used as a watchdog to reset the device when a problem occurs. It is clocked from the main clock. It has an early warning interrupt capability and the counter can be frozen in debug mode.

### 2.13 Real-time clock (RTC) and battery powered registers (BPR)

The RTC and the battery powered registers (BPR) are supplied with a power switch that is powered either from VDD when present or from the VBAT pin. The battery powered registers are forty-two 16-bit registers used to store 84 bytes of user application data. RTC and BPR are not reset by a system or power reset, and they are not reset when the device wakes up from the Standby mode.

The real-time clock provides a continuous-running counter. The RTC provides clock calendar, and alarm interrupt and periodic interrupt functions. It is clocked by a 32.768 kHz external crystal (LEXT), the internal low-power clock (LICK), or the high-speed external clock (HEXT) divided by 128. The RTC can be calibrated using a divied-by-64 output of TAMPER pin to compensate for any natural quartz deviation. The RTC features a 32-bit programmable counter that allows long time measurement with the help of the Compare register. A prescaler is used for the time base clock and is by default configured to generate a time base of 1 second from a clock at 32.768 kHz.

### 2.14 Communication interfaces

#### 2.14.1 Serial peripheral interface (SPI)

There are up to four SPI interfaces able to communicate up to 50 Mbits/s in slave and master modes in full-duplex and half-duplex modes. A prescaler is able to generate multiple master mode frequencies and the frame is configurable to 8 bits or 16 bits. The hardware CRC generation/verification supports basic SD Card/MMC/SDHC modes. All SPIs can be served by the DMA controller.

#### 2.14.2 Inter-integrated sound interface (I2S)

Four standard I2S interfaces (multiplexed with SPI) can be operated in master or slave mode in half-duplex mode. The I2S2 and I2S3 can be operated in full duplex mode. These four interfaces can be configured to operate with 16/24/32 bit resolution, as input or output channels. Audio sampling frequencies from 8 kHz up to 192 kHz are supported. When I2S configured in master mode, the master clock can be output at 256 times the sampling frequency. All I2Ss can be served by the DMA controller.

#### 2.14.3 Universal synchronous / asynchronous receiver transmitters (USART)

The AT32F403A embeds four universal synchronous/asynchronous receiver transmitters (USART1, USART2, USART3, and USART6) and 4 universal asynchronous receiver transmitters (UART4, UART5, UART7, and UART8).

These eight interfaces provide asynchronous communication, IrDA SIR ENDEC support, multiprocessor communication mode, single-wire half-duplex communication mode, and have LIN Master/Slave capability.  

These eight interfaces are able to communicate at speeds of up to 7.5 Mbit/s.

USART1, USART2, and USART3 provide hardware management of the CTS and RTS signals.

USART1, USART2, USART3, and USART6 provide Smart Card mode (ISO 7816 compliant) and SPI-like communication capability. All interfaces can be served by the DMA controller.

### Table 5. USART / UART feature comparison

| USART/UART name | USART1 | USART2 | USART3 | UART4 | UART5 | USART6 | UART7 | UART8 |
|------------------|--------|--------|--------|-------|-------|---------|-------|-------|
| Hardware flow control for modem | Yes | Yes | Yes | - | - | - | - | - |
| Continuous communication using DMA | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| Multiprocessor communication | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| Synchronous mode | Yes | Yes | Yes | - | - | Yes | - | - |
| Smartcard mode | Yes | Yes | Yes | - | - | Yes | - | - |
| Single-wire half-duplex communication | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| IrDA SIR ENDEC block | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| LIN mode | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |

#### 2.14.4 Inter-integrated-circuit interface (I2C)

Up to three I2C bus interfaces can operate in multi-master and slave modes. They support standard mode (max. 100 kHz) and fast mode (max. 400 kHz). The I2C bus frequency can be increased up to 1 MHz. For more details, please contact your local Artery sales office for technical support.

They support 7/10-bit addressing mode and 7-bit dual addressing mode (as slave). A hardware CRC generation/verification is included.

They can be served by DMA and they support SMBus 2.0/PMBus.

#### 2.14.5 Secure digital input / output interface (SDIO)

Two SD/SDIO/MMC host interfaces are available to support MultiMediaCard System Specification Version 4.2 in three different data bus modes: 1-bit (default), 4-bit and 8-bit. The interface allows data transfer at up to 48 MHz in 8-bit mode, and is compliant with SD Memory Card Specifications Version 2.0.

Two different data bus modes supported in the SDIO Card Specification Version 2.0 are: 1-bit (default) and 4-bit.

For the current version, a SDIO interface supports only one SD/SDIO/MMC4.2 card at any one time and a stack of MMC4.1 or previous.

In addition to SD/SDIO/MMC/eMMC, this interface is also fully compliant with the CE-ATA digital protocol Rev1.1.

#### 2.14.6 Controller area network (CAN)

Two CANs are compliant with specifications 2.0A and B (active) with a bit rate up to 1 Mbit/s. It can receive and transmit standard frames with 11-bit identifiers as well as extended frames with 29-bit identifiers. Each CAN has three transmit mailboxes, two receive buffers with 3 stages, and 14 scalable filter banks.

To guarantee CAN transmission quality, the CAN 2.0 protocol states that its clock souce must come from the HEXT-based PLL clock.

#### 2.14.7 Universal serial bus full-speed (USBFS)

AT32F403A embeds a USB full-speed device (12 Mbit/s) with integrated transceivers (PHY). It has software-configurable endpoint settings and supports suspend/resume operations. The USBFS controller requires a dedicated 48 MHz clock that is generated from the HEXT-based PLL or directly from a 48 MHz HICK.

### 2.15 Cyclic redundancy check (CRC) calculation unit

The CRC (cyclic redundancy check) calculation unit is used to get a CRC code from a 32-bit data word and a fixed generator polynomial. Among other applications, CRC-based techniques are used to verify data transmission or storage integrity.

### 2.16 Analog-to-digital converter (ADC)

Three 12-bit analog-to-digital converters are embedded into AT32F403A device and they share up to 16 external channels, performing conversions in single-shot or sequential modes. In sequence mode, automatic conversion is performed on a selected group of analog channels.

Additional logic functions embedded in the ADC interface allow:

- Simultaneous sample and hold
- Interleaved sample and hole
- Single sample

The ADC can be served by the DMA controller.

The voltage monitoring feature allows very precise monitoring of the converted voltage of one, some or all selected channels. An interrupt is generated when the converted voltage is outside the programmed thresholds.

The events generated by the general-purpose timers (TMRx) and the advanced timers (TMR1 and TMR8) can be internally connected to the ADC regular trigger and injection trigger, respectively, to allow the application to synchronize A/D conversion and timers.

#### 2.16.1 Temperature sensor (VTS)

The temperature sensor has to generate a voltage VTS that varies linearly with temperature. The temperature sensor is internally connected to the ADC1_IN16 input channel which is used to convert the sensor output voltage into a digital value.

The offset of this line varies from chip to chip due to process variation. The internal temperature sensor is more suited to applications that detect temperature variations instead of absolute temperatures. If accurate temperature readings are needed, an external temperature sensor part should be used.

#### 2.16.2 Internal reference voltage (VINTRV)

The internal reference voltage (VINTRV) provides a stable voltage source for ADC. The VINTRV is internally connected to the ADC1_IN17 input channel.

### 2.17 Digital-to-analog converter (DAC)

The two 12-bit buffered DACs can be used to convert two-channel digital signals into two-channel analog voltage signal outputs.

The DAC has the following features:

- Two DAC converters with an output channel each
- 8-bit or 12-bit monotonic output
- Left- or right-alignment data in 12-bit mode
- Synchronized update capability
- Noise-wave generation
- Triangular-wave generation
- Dual DAC channel independent or simultaneous conversions
- DMA capability for each DAC
- External triggers for conversion
- Input voltage reference VREF+

Several DAC trigger inputs are available in the AT32F403A. DAC outputs can be triggered through the timer update outputs. The update output can also be connected to different DMA channels.

### 2.18 Debug

#### 2.18.1 Serial wire (SWD) / JTAG port

The ARM® SWJ-DP Interface is embedded, consisting of aserial wire debug port and JTAG. It enables either a serial wire debug or a JTAG probe to be connected to the target for programming and debug operation. The JTAG TMS and TCK pins are shared respectively with SWDIO and SWCLK.

#### 2.18.2 Embedded Trace Macrocell (ETMTM)

The ARM® Embedded Trace Macrocell (ETMTM) provides a greater visibility of the instruction and data flow inside the CPU core by streaming compressed data at a very high rate from the AT32F403A through a small number of ETM pins to an external hardware trace port analyzer (TPA) device. The TPA is connected to a host computer using USB or any other high-speed channel.

Real-time instruction and data flow activity can be recorded and then formatted for display on the host computer that runs the debugger software. TPA hardware is commercially available from common development tool vendors. It operates with third party debugger software tools.

## 3 Pin functional definitions

[Figure 2: AT32F403A LQFP100 pinout]

[Figure 3: AT32F403A LQFP64 pinout]

[Figure 4: AT32F403A LQFP48 pinout]

[Figure 5: AT32F403A QFN48 pinout]

The table below is the pin definition of the AT32F403A. ”-” presents there is no such pinout on the related package. The multi-functions list follows priority from high to low. In principle, the analog signals have priority over the digital signals, and the digital output signals have priority over the digital input signals.

### Table 6. AT32F403A series pin definitions

| Pin number | | | | Pin name | Type(1) | IO level(2) | Main function(3) | Multi-functions(4) | |
|------------| - | - | - |---------|---------|------------|------------------|--------------------|-|
| LQFP48 | QFN48 | LQFP64 | LQFP100 | | | | | Default | Remap |
| - | - | - | 1 | PE2 | I/O | FT | PE2 | SPI4_SCK(7) / I2S4_CK(7) / XMC_A23 / TRACECK | - |
| - | - | - | 2 | PE3 | I/O | FT | PE3 | XMC_A19 / TRACED0 | - |
| - | - | - | 3 | PE4 | I/O | FT | PE4 | SPI4_CS(7) / I2S4_WS(7) / XMC_A20 / TRACED1 | - |
| - | - | - | 4 | PE5 | I/O | FT | PE5 | SPI4_MISO(7) / XMC_A21 / TRACED2 | TMR9_CH1 |
| - | - | - | 5 | PE6 | I/O | FT | PE6 | SPI4_MOSI(7) / I2S4_SD(7) / XMC_A22 / TRACED3 | TMR9_CH2 |
| 1 | 1 | 1 | 6 | VBAT | S | - | VBAT | - | - |
| 2 | 2 | 2 | 7 | TAMPER-RTC / PC13(5) | I/O | TC | PC13(6) | TAMPER-RTC | - |
| 3 | 3 | 3 | 8 | LEXT_IN / PC14(5) | I/O | TC | PC14(6) | LEXT_IN | - |
| 4 | 4 | 4 | 9 | LEXT_OUT / PC15(5) | I/O | TC | PC15(6) | LEXT_OUT | - |
| - | - | - | 10 | VSS_5 | S | - | VSS_5 | - | - |
| - | - | - | 11 | VDD_5 | S | - | VDD_5 | - | - |
| - | - | - | 12 | HEXT_IN | I | - | HEXT_IN | - | - |
| - | - | - | 13 | HEXT_OUT | O | - | HEXT_OUT | - | - |
| 5 | 5 | 5 | - | HEXT_IN / PD0(8) | I/O | TC | HEXT_IN | - | PD0(8) |
| 6 | 6 | 6 | - | HEXT_OUT / PD1(8) | I/O | TC | HEXT_OUT | - | PD1(8) |
| 7 | 7 | 7 | 14 | NRST | I/O | - | NRST | - | - |
| - | 8 | 8 | 15 | PC0 | I/O | FTa | PC0 | ADC123_IN10 / SDIO2_D0(7) | - |
| - | 9 | 9 | 16 | PC1 | I/O | FTa | PC1 | ADC123_IN11 / SDIO2_D1(7) | - |
| - | 10 | 10 | 17 | PC2 | I/O | FTa | PC2 | ADC123_IN12 / SDIO2_D2(7) | UART8_TX / XMC_NWE |
| - | 11 | 11 | 18 | PC3 | I/O | FTa | PC3 | ADC123_IN13 / SDIO2_D3(7) / XMC_A0 | UART8_RX |
| - | - | - | 19 | VSSA | S | - | VSSA | - | - |
| - | - | - | 20 | VREF- | S | - | VREF- | - | - |
| 8 | 12 | - | - | VSSA / VREF- | S | - | VSSA / VREF- | - | - |
| - | - | - | 21 | VREF+ | S | - | VREF+ | - | - |
| - | - | - | 22 | VDDA | S | - | VDDA | - | - |
| 9 | 13 | - | - | VDDA / VREF+ | S | - | VDDA / VREF+ | - | - |
| 10 | 14 | 12 | 23 | PA0 / WKUP | I/O | TC | PA0 | ADC123_IN0 / WKUP / USART2_CTS(7) / TMR2_CH1(7) / TMR2_EXT(7) / TMR5_CH1 / TMR8_EXT | UART4_TX |
| 11 | 15 | 13 | 24 | PA1 | I/O | FTa | PA1 | ADC123_IN1 / USART2_RTS(7) / TMR2_CH2(7) / TMR5_CH2 | UART4_RX |
| 12 | 16 | 14 | 25 | PA2 | I/O | FTa | PA2 | ADC123_IN2 / USART2_TX(7) / TMR2_CH3(7) / TMR5_CH3 / TMR9_CH1(7) | SDIO2_CK / XMC_D4 |
| 13 | 17 | 15 | 26 | PA3 | I/O | FTa | PA3 | ADC123_IN3 / USART2_RX(7) / TMR2_CH4(7) / TMR5_CH4 / TMR9_CH2(7) | I2S2_MCK / SDIO2_CMD / XMC_D5 |
| - | 18 | 16 | 27 | VSS_4 | S | - | VSS_4 | - | - |
| - | 19 | 17 | 28 | VDD_4 | S | - | VDD_4 | - | - |
| 14 | 20 | 18 | 29 | PA4 | I/O | FTa | PA4 | DAC1_OUT / ADC12_IN4 / USART2_CK(7) / SPI1_CS(7) / I2S1_WS(7) / SDIO2_D4 | USART6_TX / SPI3_CS / I2S3_WS / SDIO2_D0 / XMC_D6 |
| 15 | 21 | 19 | 30 | PA5 | I/O | FTa | PA5 | DAC2_OUT / ADC12_IN5 / SPI1_SCK(7) / I2S1_CK(7) / SDIO2_D5 | USART6_RX / SDIO2_D1 / XMC_D7 |
| 16 | 22 | 20 | 31 | PA6 | I/O | FTa | PA6 | ADC12_IN6 / SPI1_MISO(7) / SDIO2_D6 / TMR3_CH1(7) / TMR8_BRK / TMR13_CH1 | I2S2_MCK / SDIO2_D2 / TMR1_BRK |
| 17 | 23 | 21 | 32 | PA7 | I/O | FTa | PA7 | ADC12_IN7 / SPI1_MOSI(7) / I2S1_SD(7) / SDIO2_D7 / TMR3_CH2(7) / TMR8_CH1C / TMR14_CH1 | SDIO2_D3 / TMR1_CH1C |
| - | 24 | 22 | 33 | PC4 | I/O | FTa | PC4 | ADC12_IN14 / SDIO2_CK(7) / XMC_NE4 | - |
| - | 25 | 23 | 34 | PC5 | I/O | FTa | PC5 | ADC12_IN15 / SDIO2_CMD(7) | XMC_NOE |
| 18 | 26 | 24 | 35 | PB0 | I/O | FTa | PB0 | ADC12_IN8 / I2S1_MCK(7) / TMR3_CH3(7) / TMR8_CH2C | TMR1_CH2C |
| 19 | 27 | 25 | 36 | PB1 | I/O | FTa | PB1 | ADC12_IN9 / SPIM_SCK / TMR3_CH4(7) / TMR8_CH3C | TMR1_CH3C |
| 20 | 28 | 26 | 37 | PB2 | I/O | FT | PB2 / BOOT1(9) | - | - |
| - | - | - | 38 | PE7 | I/O | FT | PE7 | UART7_RX(7) / XMC_D4(7) | TMR1_EXT |
| - | - | - | 39 | PE8 | I/O | FT | PE8 | UART7_TX(7) / XMC_D5(7) | TMR1_CH1C |
| - | - | - | 40 | PE9 | I/O | FT | PE9 | XMC_D6(7) | TMR1_CH1 |
| - | - | - | 41 | PE10 | I/O | FT | PE10 | XMC_D7(7) | TMR1_CH2C |
| - | - | - | 42 | PE11 | I/O | FT | PE11 | XMC_D8 | SPI4_SCK / I2S4_CK / TMR1_CH2 |
| - | - | - | 43 | PE12 | I/O | FT | PE12 | XMC_D9 | SPI4_CS / I2S4_WS / TMR1_CH3C |
| - | - | - | 44 | PE13 | I/O | FT | PE13 | XMC_D10 | SPI4_MISO / TMR1_CH3 |
| - | - | - | 45 | PE14 | I/O | FT | PE14 | XMC_D11 | SPI4_MOSI / I2S4_SD / TMR1_CH4 |
| - | - | - | 46 | PE15 | I/O | FT | PE15 | XMC_D12 | TMR1_BRK |
| 21 | 29 | 27 | 47 | PB10 | I/O | FT | PB10 | USART3_TX(7) / I2C2_SCL | I2S3_MCK / SPIM_IO0 / TMR2_CH3 |
| 22 | 30 | 28 | 48 | PB11 | I/O | FT | PB11 | USART3_RX(7) / I2C2_SDA | SPIM_IO1 / TMR2_CH4 |
| 23 | 31 | 29 | 49 | VSS_1 | S | - | VSS_1 | - | - |
| 24 | 32 | 30 | 50 | VDD_1 | S | - | VDD_1 | - | - |
| 25 | 33 | 31 | 51 | PB12 | I/O | FT | PB12 | USART3_CK(7) / CAN2_RX(7) / I2C2_SMBA / SPI2_CS / I2S2_WS / TMR1_BRK(7) | XMC_D13 |
| 26 | 34 | 32 | 52 | PB13 | I/O | FT | PB13 | USART3_CTS(7) / CAN2_TX(7) / SPI2_SCK / I2S2_CK / TMR1_CH1C(7) | - |
| 27 | 35 | 33 | 53 | PB14 | I/O | FT | PB14 | USART3_RTS(7) / SPI2_MISO / I2S2_SDEXT / TMR1_CH2C(7) / TMR12_CH1 | XMC_D0 |
| 28 | 36 | 34 | 54 | PB15 | I/O | FT | PB15 | SPI2_MOSI / I2S2_SD / TMR1_CH3C(7) / TMR12_CH2 | - |
| - | - | - | 55 | PD8 | I/O | FT | PD8 | XMC_D13(7) | USART3_TX |
| - | - | - | 56 | PD9 | I/O | FT | PD9 | XMC_D14 | USART3_RX |
| - | - | - | 57 | PD10 | I/O | FT | PD10 | XMC_D15 | USART3_CK |
| - | - | - | 58 | PD11 | I/O | FT | PD11 | XMC_A16 | USART3_CTS |
| - | - | - | 59 | PD12 | I/O | FT | PD12 | XMC_A17 | USART3_RTS / TMR4_CH1 |
| - | - | - | 60 | PD13 | I/O | FT | PD13 | XMC_A18 | TMR4_CH2 |
| - | - | - | 61 | PD14 | I/O | FT | PD14 | XMC_D0(7) | TMR4_CH3 |
| - | - | - | 62 | PD15 | I/O | FT | PD15 | XMC_D1(7) | TMR4_CH4 |
| - | 37 | 35 | 63 | PC6 | I/O | FT | PC6 | USART6_TX(7) / I2S2_MCK(7) / SDIO1_D6 / TMR8_CH1 | XMC_D1 / TMR3_CH1 |
| - | 38 | 36 | 64 | PC7 | I/O | FT | PC7 | USART6_RX(7) / I2S3_MCK(7) / SDIO1_D7 / TMR8_CH2 | TMR3_CH2 |
| - | 39 | 37 | 65 | PC8 | I/O | FT | PC8 | USART6_CK / I2S4_MCK(7) / SDIO1_D0 / TMR8_CH3 | TMR3_CH3 |
| - | 40 | 38 | 66 | PC9 | I/O | FT | PC9 | I2C3_SDA(7) / SDIO1_D1 / TMR8_CH4 | TMR3_CH4 |
| 29 | 41 | 39 | 67 | PA8 | I/O | FT | PA8 | CLKOUT / USART1_CK / I2C3_SCL / USBFS_SOF / SPIM_CS / TMR1_CH1(7) | - |
| 30 | 42 | 40 | 68 | PA9 | I/O | FT | PA9 | USART1_TX(7) / I2C3_SMBA / TMR1_CH2(7) | - |
| 31 | 43 | 41 | 69 | PA10 | I/O | FT | PA10 | USART1_RX(7) / TMR1_CH3(7) | I2S4_MCK |
| 32 | 44 | 42 | 70 | PA11 | I/O | TC | PA11 | USBFS1_D- / USART1_CTS / CAN1_RX(7) / SPIM_IO0(7) / TMR1_CH4(7) | - |
| 33 | 45 | 43 | 71 | PA12 | I/O | TC | PA12 | USBFS1_D+ / USART1_RTS / CAN1_TX(7) / SPIM_IO1(7) / TMR1_EXT(7) | - |
| 34 | 46 | 44 | 72 | PA13 | I/O | FT | JTMS-SWDIO | - | PA13 |
| - | - | - | 73 | Disconnected | | | | | |
| 35 | 47 | 45 | 74 | VSS_2 | S | - | VSS_2 | - | - |
| 36 | 48 | 46 | 75 | VDD_2 | S | - | VDD_2 | - | - |
| 37 | 49 | 47 | 76 | PA14 | I/O | FT | JTCK-SWCLK | - | PA14 |
| 38 | 50 | 48 | 77 | PA15 | I/O | FT | JTDI | SPI3_CS(7) / I2S3_WS(7) | PA15 / SPI1_CS / I2S1_WS / TMR2_CH1 / TMR2_EXT |
| - | 51 | 49 | 78 | PC10 | I/O | FT | PC10 | UART4_TX(7) / SDIO1_D2 | USART3_TX / SPI3_SCK / I2S3_CK |
| - | 52 | 50 | 79 | PC11 | I/O | FT | PC11 | UART4_RX(7) / SDIO1_D3 | USART3_RX / SPI3_MISO / I2S3_SDEXT / XMC_D2 |
| - | 53 | 51 | 80 | PC12 | I/O | FT | PC12 | UART5_TX(7) / SDIO1_CK | USART3_CK / SPI3_MOSI / I2S3_SD / XMC_D3 |
| - | - | 52 | 81 | PD0 | I/O | FT | PD0 | XMC_D2(7) | CAN1_RX |
| - | - | 53 | 82 | PD1 | I/O | FT | PD1 | XMC_D3(7) | CAN1_TX |
| - | 54 | 54 | 83 | PD2 | I/O | FT | PD2 | UART5_RX(7) / SDIO1_CMD / TMR3_EXT | XMC_NWE |
| - | - | 55 | 84 | PD3 | I/O | FT | PD3 | XMC_CLK | USART2_CTS |
| - | - | 56 | 85 | PD4 | I/O | FT | PD4 | XMC_NOE(7) | USART2_RTS |
| - | - | 57 | 86 | PD5 | I/O | FT | PD5 | XMC_NWE(7) | USART2_TX |
| - | - | 58 | 87 | PD6 | I/O | FT | PD6 | XMC_NWAIT | USART2_RX |
| - | - | 59 | 88 | PD7 | I/O | FT | PD7 | XMC_NE1 / XMC_NCE2 | USART2_CK |
| 39 | 55 | 60 | 89 | PB3 | I/O | FT | JTDO | SPI3_SCK(7) / I2S3_CK(7) | PB3 / UART7_RX / SPI1_SCK / I2S1_CK / SWO / TMR2_CH2 |
| 40 | 56 | 61 | 90 | PB4 | I/O | FT | NJTRST | SPI3_MISO(7) / I2S3_SDEXT(7) | PB4 / SPI1_MISO / I2C3_SDA / UART7_TX / TMR3_CH1 |
| 41 | 57 | 62 | 91 | PB5 | I/O | FT | PB5 | SPI3_MOSI(7) / I2S3_SD(7) / I2C1_SMBA(7) | SPI1_MOSI / I2S1_SD / CAN2_RX / TMR3_CH2 |
| 42 | 58 | 63 | 92 | PB6 | I/O | FT | PB6 | I2C1_SCL(7) / SPIM_IO3 / TMR4_CH1(7) | USART1_TX / I2S1_MCK / SPI4_CS / I2S4_WS / CAN2_TX |
| 43 | 59 | 64 | 93 | PB7 | I/O | FT | PB7 | I2C1_SDA(7) / XMC_NADV / SPIM_IO2 / TMR4_CH2(7) | USART1_RX / SPI4_SCK / I2S4_CK |
| 44 | 60 | - | 94 | BOOT0 | I | - | BOOT0 | - | - |
| 45 | 61 | - | 95 | PB8 | I/O | FT | PB8 | SDIO1_D4 / TMR4_CH3(7) / TMR10_CH1 | UART5_RX / SPI4_MISO / I2C1_SCL / CAN1_RX |
| 46 | 62 | - | 96 | PB9 | I/O | FT | PB9 | SDIO1_D5 / TMR4_CH4(7) / TMR11_CH1 | UART5_TX / SPI4_MOSI / I2S4_SD / I2C1_SDA / CAN1_TX |
| - | - | - | 97 | PE0 | I/O | FT | PE0 | UART8_RX(7) / XMC_LB / TMR4_EXT | - |
| - | - | - | 98 | PE1 | I/O | FT | PE1 | UART8_TX(7) / XMC_UB | - |
| 47 | 63 | - | 99 | VSS_3 | S | - | VSS_3 | - | - |
| 48 | 64 | - | 100 | VDD_3 | S | - | VDD_3 | - | - |
| -/49 | - | - | - | EPAD | S | - | VSS | - | - |

(1) I = input, O = output, S = supply.  
(2) TC = standard 3.3 V GPIO, FT = general 5 V-tolerant GPIO, FTa = 5 V-tolerant GPIO with analog functionalities. FTa pin is 5 V-tolerant when configured as input floating, input pull-up, or input pull-down mode. However, it cannot be 5 V-tolerant when configured as analog mode. Meanwhile, its input level should not higher than VDD + 0.3 V.  
(3) Function availability depends on the chosen device.  
(4) If several peripherals share the same GPIO pin, to avoid conflict between these multiple functions only one peripheral should be enabled at a time through the peripheral clock enable bit (in the corresponding CRM peripheral clock enable register).  
(5) PC13, PC14, and PC15 are supplied through the power switch. Since the switch only drives a limited amount of current (3 mA), the use of GPIOs PC13 to PC15 in output mode is limited not to be used as a current source (e.g. to drive an LED).  
(6) Main function after the first battery powered domain power-up. Later on, it depends on the contents of the battery powered registers even after reset (because these registers are not reset by the main reset). For details on how to manage these GPIOs, refer to the battery powered domain and register description sections in the AT32F403A reference manual.  
(7) This multiple function can be remapped by software to some other port pins (if available on the used package). For more details, refer to the multi-function GPIO and debug configuration section in the AT32F403A reference manual.  
(8) For the LQFP64, LQFP48, and QFN48 package, the pins number 5 and 6 are configured as HEXT_IN and HEXT_OUT after reset, the functionality of PD0 and PD1 can be remapped by software on these pins. However, for the LQFP100 package, PD0 and PD1 are available by default, so there is no need for remapping. For more details, refer to multi-function GPIO and debug configuration section in the AT32F403A reference manual.  
(9) If the device boots from Flash and leaves PB2 not used, suggest to pull PB2/BOOT1 pin down to VSS.

### Table 7. XMC pin definition

| Pins | XMC | LQFP64 | | |
|------|-----|--------| - | - |
| | Multiplexed PSRAM/NOR | LCD | NAND | |
| PE2 | A23 | A23 | - | - |
| PE3 | A19 | A19 | - | - |
| PE4 | A20 | A20 | - | - |
| PE5 | A21 | A21 | - | - |
| PE6 | A22 | A22 | - | - |
| PC2 | NWE | NWE | NWE | Yes |
| PC3 | - | A0 | - | Yes |
| PA2 | DA4 | D4 | D4 | Yes |
| PA3 | DA5 | D5 | D5 | Yes |
| PA4 | DA6 | D6 | D6 | Yes |
| PA5 | DA7 | D7 | D7 | Yes |
| PC4 | NE4 | NE4 | - | Yes |
| PC5 | NOE | NOE | NOE | Yes |
| PE7 | DA4 | D4 | D4 | - |
| PE8 | DA5 | D5 | D5 | - |
| PE9 | DA6 | D6 | D6 | - |
| PE10 | DA7 | D7 | D7 | - |
| PE11 | DA8 | D8 | D8 | - |
| PE12 | DA9 | D9 | D9 | - |
| PE13 | DA10 | D10 | D10 | - |
| PE14 | DA11 | D11 | D11 | - |
| PE15 | DA12 | D12 | D12 | - |
| PB12 | DA13 | D13 | D13 | Yes |
| PB14 | DA0 | D0 | D0 | Yes |
| PD8 | DA13 | D13 | D13 | - |
| PD9 | DA14 | D14 | D14 | - |
| PD10 | DA15 | D15 | D15 | - |
| PD11 | A16 | A16 | CLE | - |
| PD12 | A17 | A17 | ALE | - |
| PD13 | A18 | A18 | - | - |
| PD14 | DA0 | D0 | D0 | - |
| PD15 | DA1 | D1 | D1 | - |
| PC6 | DA1 | D1 | D1 | Yes |
| PC11 | DA2 | D2 | D2 | Yes |
| PC12 | DA3 | D3 | D3 | Yes |
| PD0 | DA2 | D2 | D2 | - |
| PD1 | DA3 | D3 | D3 | - |
| PD2 | NWE | NWE | NWE | Yes |
| PD3 | CLK | - | - | - |
| PD4 | NOE | NOE | NOE | - |
| PD5 | NWE | NWE | NWE | - |
| PD6 | NWAIT | - | NWAIT | - |
| PD7 | NE1 | NE1 | NCE2 | - |
| PB7 | NADV | - | - | Yes |
| PE0 | LB | - | - | - |
| PE1 | UB | - | - | - |

## 4 Memory mapping

[Figure 6: Memory map]

## 5 Electrical characteristics

### 5.1 Parameter conditions

#### 5.1.1 Minimum and maximum values

The minimum and maximum values are obtained in the worst conditions. Data based on characterization results, design simulation and/or technology characteristics are indicated in the table footnotes and are not tested in production. The minimum and maximum values represent the mean value plus or minus three times the standard deviation (mean ± 3σ).

#### 5.1.2 Typical values

Typical data are based on TA = 25 °C, VDD = 3.3 V.

#### 5.1.3 Typical curves

All typical curves are given only as design guidelines and are not tested.

#### 5.1.4 Power supply scheme

[Figure 7: Power supply scheme]

Caution: In this figure, the 4.7μF capacitor must be connected to VDD3.

### 5.2 Absolute maximum values

#### 5.2.1 Ratings

If stresses were out of the absolute maximum ratings listed in Table 8, Table 9, and Table 10, it may cause permanent damage to the device. These are maximum stress ratings only that the device could bear, but the functional operation of the device under these conditions is not implied.

Exposure to maximum rating conditions for an extended period of times may affect device reliability.

### Table 8. Voltage characteristics

| Symbol | Ratings | Min | Max | Unit |
|--------|---------|-----|-----|------|
| VDD-VSS | External main supply voltage (including VDDA and VDD) | -0.3 | 4.0 | V |
| VIN | Input voltage on FT GPIO | VSS-0.3 | 6.0 | V |
| | Input voltage on FTa GPIO (set as input floating, input pull-up, or input pull-down mode) | VSS-0.3 | 6.0 | V |
| | Input voltage on TC GPIO | VSS-0.3 | 4.0 | V |
| | Input voltage on FTa GPIO (set as analog mode) | VSS-0.3 | VDD + 0.3 | V |
| |ΔVDDx| | Variations between different VDD power pins | - | 50 | mV |
| |VSSx-VSS| | Variations between all the different ground pins | - | 50 | mV |

### Table 9. Current characteristics

| Symbol | Ratings | Max | Unit |
|--------|---------|-----|------|
| IVDD | Total current into VDD/VDDA power lines (source) | 150 | mA |
| IVSS | Total current out of VSS ground lines (sink) | 150 | mA |
| IIO | Output current sunk by any GPIO and control pin | 25 | mA |
| | Output current source by any GPIOs and control pin | -25 | mA |

### Table 10. Thermal characteristics

| Symbol | Ratings | Min | Value | Unit |
|--------|---------|-----|-------|------|
| TSTG | Storage temperature range | -60 ~ +150 | | °C |
| TJ | Maximum junction temperature | | 125 | |

#### 5.2.2 Electrical sensitivity

Based on three different tests (HBM, CDM, and LU) using specific measurement methods, the device is stressed in order to determine its performance in terms of electrical sensitivity.

Electrostatic discharge (ESD)

Electrostatic discharges are applied to the pins of each sample according to each pin combination. This test conforms to the JS-001-2017/JS-002-2018 standard.

### Table 11. ESD values

| Symbol | Parameter | Conditions | Class | Max | Unit |
|--------|---------|-----------|-------|-----|------|
| VESD(HBM) | Electrostatic discharge voltage (human body model) | TA = +25 °C, conforming to JS-001-2017 | 3A | 5000 | V |
| VESD(CDM) | Electrostatic discharge voltage (charge device model) | TA = +25 °C, conforming to JS-002-2018 | III | 1000 | V |

Static latch-up

Tests compliant with EIA/JESD78E IC latch-up standard are required to assess the latch-up performance:

- A supply overvoltage is applied to each power supply pin;
- A current injection is applied to each input, output and configurable GPIO pin.

### Table 12. Latch-up values

| Symbol | Parameter | Conditions | Level/Class |
|--------|---------|-----------|-------------|
| LU | Static latch-up class | TA = +105 °C, conforming to EIA/JESD78E | II level A (200 mA) |

### 5.3 Specification

#### 5.3.1 General operating conditions

### Table 13. General operating conditions

| Symbol | Parameter | Conditions | Min | Max | Unit |
|--------|---------|-----------|-----|-----|------|
| fHCLK | Internal AHB clock frequency | Flash memory bank 3 (SPIM) not used | 0 | 240 | MHz |
| | | 3.1 V ≤ VDD ≤ 3.6 V | 0 | 240 | MHz |
| | | 2.6 V ≤ VDD < 3.1 V | 0 | 180 | MHz |
| | | Flash memory bank 3 used (SPIM) | 0 | 180 | MHz |
| | | 3.1 V ≤ VDD ≤ 3.6 V | 0 | 180 | MHz |
| | | 2.6 V ≤ VDD < 3.1 V | 0 | 160 | MHz |
| fPCLK1 | Internal APB1 clock frequency | - | 0 | 120 | MHz |
| fPCLK2 | Internal APB2 clock frequency | - | 0 | 120 | MHz |
| VDD | Standard operating voltage | - | 2.6 | 3.6 | V |
| VDDA | Analog operating voltage | Must be the same potential as VDD(1) | 2.6 | 3.6 | V |
| VBAT | Backup operating voltage | - | 1.8 | 3.6 | V |
| PD | Power dissipation: TA = 105 °C | LQFP100 | - | 326 | mW |
| | | LQFP64 | - | 309 | mW |
| | | LQFP48 | - | 290 | mW |
| | | QFN48 | - | 662 | mW |
| TA | Ambient temperature | - | -40 | 105 | °C |

#### 5.3.2 Operating conditions at power-up / power-down

### Table 14. Operating conditions at power-up / power-down

| Symbol | Parameter | Conditions | Min | Max | Unit |
|--------|---------|-----------|-----|-----|------|
| tVDD | VDD rise time rate | - | 0 | ∞(1) | ms/V |
| | VDD fall time rate | | 20 | ∞ | μs/V |

(1) If VDD rising time rate is slower than 120 ms/V, the code should access the backup registers after VDD higher than VPOR + 0.1V.

#### 5.3.3 Embedded reset and power control block characteristics

### Table 15. Embedded reset and power control block characteristics

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| VPVM | Power voltage monitoring level selection | PVMSEL[2:0] = 001 (rising edge)(1) | 2.19 | 2.28 | 2.37 | V |
| | | PVMSEL [2:0] = 001 (falling edge)(1) | 2.09 | 2.18 | 2.27 | V |
| | | PVMSEL [2:0] = 010 (rising edge)(2) | 2.28 | 2.38 | 2.48 | V |
| | | PVMSEL [2:0] = 010 (falling edge)(2) | 2.18 | 2.28 | 2.38 | V |
| | | PVMSEL [2:0] = 011 (rising edge)(2) | 2.38 | 2.48 | 2.58 | V |
| | | PVMSEL [2:0] = 011 (falling edge)(2) | 2.28 | 2.38 | 2.48 | V |
| | | PVMSEL [2:0] = 100 (rising edge)(2) | 2.47 | 2.58 | 2.69 | V |
| | | PVMSEL [2:0] = 100 (falling edge)(2) | 2.37 | 2.48 | 2.59 | V |
| | | PVMSEL [2:0] = 101 (rising edge)(2) | 2.57 | 2.68 | 2.79 | V |
| | | PVMSEL [2:0] = 101 (falling edge)(2) | 2.47 | 2.58 | 2.69 | V |
| | | PVMSEL [2:0] = 110 (rising edge)(2) | 2.66 | 2.78 | 2.9 | V |
| | | PVMSEL [2:0] = 110 (falling edge)(2) | 2.56 | 2.68 | 2.8 | V |
| | | PVMSEL [2:0] = 111 (rising edge) | 2.76 | 2.88 | 3 | V |
| | | PVMSEL [2:0] = 111 (falling edge) | 2.66 | 2.78 | 2.9 | V |
| VHYS_P(2) | PVM hysteresis | - | - | 100 | - | mV |
| VPOR(2) | Power on reset threshold | - | 2.03 | 2.18 | 2.35 | V |
| VLVR(2) | Low voltage reset threshold | - | 1.85(3) | 2.02 | 2.2 | V |
| VLVRhyst(2) | LVR hysteresis | - | - | 160 | - | mV |
| TRESTTEMPO(2) | Reset temporization: CPU starts execution after VDD keeps higher than VPOR for TRSTTEMPO | - | - | 13 | - | ms |

(1) PVMSEL[2:0] = 001 may be not available for its voltage detector level may be lower than VPOR/PDR.  
(2) Guaranteed by design, not tested in production.  
(3) The product behavior is guaranteed by design down to the minimum VLVR value.

[Figure 8: Power on reset and low voltage reset waveform]

#### 5.3.4 Memory characteristics

### Table 16. Internal Flash memory characteristics(1)

| Symbol | Parameter | Conditions | Typ. | Max. | Unit |
|--------|---------|-----------|------|------|------|
| TPROG | Programming time | - | 50 | 200 | μs |
| tSE | Sector erase time (2 KB) | - | 50 | 500 | ms |
| tBKE | Block erase time | AT32F403AxC | 0.8 | 10 | s |
| | | AT32F403AxE AT32F403AxG | 1.6 | | |

(1) Guaranteed by design, not tested in production.

### Table 17. Internal Flash memory endurance and data retention(1)

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| NEND | Endurance | TA = -40 ~ 105 °C | 100 | - | - | kcycles |
| tRET | Data retention | TA = 105 °C | 10 | - | - | years |

(1) Guaranteed by design, not tested in production.

#### 5.3.5 Supply current characteristics

The current consumption is subjected to several parameters and factors such as the operating voltage, ambient temperature, GPIO pin loading, device software configuration, operating frequencies, GPIO pin switching rate, and executed binary code. The current consumption is obtained by characterization results, not tested in production.

**Typical and maximum current consumption**  
The MCU is placed under the following conditions:  
- All GPIO pins are in analog mode.  
- Prefetch ON. (Reminder: this bit must be set before clock setting and bus prescaling.)  
- When the peripherals are enabled:  
  - fHCLK > 120 MHz: fPCLK1 = fHCLK/2, fPCLK2 = fHCLK/2, fADCCLK = fPCLK2/4  
  - If fHCLK ≤ 120 MHz: fPCLK1 = fHCLK, fPCLK2 = fHCLK, fADCCLK = fPCLK2/4.  
- Code executes in ZW area.  
- Unless otherwise specified, the typical values are measured with VDD = 3.3 V and TA = 25 °C condition and the maximum values are measured with VDD = 3.6 V.

### Table 18. Typical current consumption in Run mode

| Symbol | Parameter | Conditions | fHCLK | Typ All peripherals enabled | All peripherals disabled | Unit |
|--------|---------|-----------|--------|--------------------------------|--------------------------|------|
| IDD | Supply current in Run mode | High speed external crystal (HEXT)(1)(2) | 240 MHz | 93.8 | 41.0 | mA |
| | | | 200 MHz | 78.9 | 34.6 | |
| | | | 144 MHz | 57.8 | 25.7 | |
| | | | 120 MHz | 59.1 | 23.3 | |
| | | | 108 MHz | 53.5 | 21.3 | |
| | | | 72 MHz | 37.1 | 15.4 | |
| | | | 48 MHz | 25.7 | 11.1 | |
| | | | 36 MHz | 19.9 | 8.99 | |
| | | | 24 MHz | 14.2 | 6.86 | |
| | | | 16 MHz | 10.3 | 5.44 | |
| | | | 8 MHz | 6.01 | 3.58 | |
| | | | 4 MHz | 4.16 | 2.95 | |
| | | | 2 MHz | 3.23 | 2.63 | |
| | | | 1 MHz | 2.77 | 2.47 | |
| | | | 500 kHz | 2.55 | 2.39 | |
| | | | 125 kHz | 2.37 | 2.34 | |
| | | High speed internal clock (HICK)(2) | 240 MHz | 93.8 | 41.0 | mA |
| | | | 200 MHz | 78.9 | 34.6 | |
| | | | 144 MHz | 57.8 | 25.6 | |
| | | | 120 MHz | 59.0 | 23.2 | |
| | | | 108 MHz | 53.4 | 21.2 | |
| | | | 72 MHz | 37.1 | 15.4 | |
| | | | 48 MHz | 25.6 | 11.1 | |
| | | | 36 MHz | 19.8 | 8.91 | |
| | | | 24 MHz | 14.1 | 6.78 | |
| | | | 16 MHz | 10.2 | 5.36 | |
| | | | 8 MHz | 5.92 | 3.49 | |
| | | | 4 MHz | 4.07 | 2.86 | |
| | | | 2 MHz | 3.14 | 2.54 | |
| | | | 1 MHz | 2.69 | 2.39 | |
| | | | 500 kHz | 2.46 | 2.31 | |
| | | | 125 kHz | 2.29 | 2.25 | |

(1) External clock is 8 MHz.  
(2) PLL is on when fHCLK > 8 MHz.

### Table 19. Typical current consumption in Sleep mode

| Symbol | Parameter | Conditions | fHCLK | Typ All peripherals enabled | All peripherals disabled | Unit |
|--------|---------|-----------|--------|--------------------------------|--------------------------|------|
| IDD | Supply current in Sleep mode | High speed external crystal (HEXT)(1)(2) | 240 MHz | 78.3 | 12.5 | mA |
| | | | 200 MHz | 65.9 | 10.8 | |
| | | | 144 MHz | 48.3 | 8.52 | |
| | | | 120 MHz | 50.2 | 8.07 | |
| | | | 108 MHz | 45.5 | 7.54 | |
| | | | 72 MHz | 31.8 | 6.29 | |
| | | | 48 MHz | 22.1 | 5.07 | |
| | | | 36 MHz | 17.2 | 4.45 | |
| | | | 24 MHz | 12.4 | 3.83 | |
| | | | 16 MHz | 9.12 | 3.42 | |
| | | | 8 MHz | 5.42 | 2.57 | |
| | | | 4 MHz | 3.87 | 2.45 | |
| | | | 2 MHz | 3.09 | 2.39 | |
| | | | 1 MHz | 2.71 | 2.36 | |
| | | | 500 kHz | 2.52 | 2.34 | |
| | | | 125 kHz | 2.37 | 2.33 | |
| | | High speed internal clock (HICK)(2) | 240 MHz | 78.3 | 12.4 | mA |
| | | | 200 MHz | 65.9 | 10.8 | |
| | | | 144 MHz | 48.3 | 8.44 | |
| | | | 120 MHz | 50.2 | 7.99 | |
| | | | 108 MHz | 45.5 | 7.45 | |
| | | | 72 MHz | 31.7 | 6.20 | |
| | | | 48 MHz | 22.0 | 4.97 | |
| | | | 36 MHz | 17.2 | 4.35 | |
| | | | 24 MHz | 12.3 | 3.74 | |
| | | | 16 MHz | 9.04 | 3.33 | |
| | | | 8 MHz | 5.33 | 2.48 | |
| | | | 4 MHz | 3.78 | 2.36 | |
| | | | 2 MHz | 3.01 | 2.30 | |
| | | | 1 MHz | 2.62 | 2.27 | |
| | | | 500 kHz | 2.43 | 2.25 | |
| | | | 125 kHz | 2.28 | 2.24 | |

(1) External clock is 8 MHz.  
(2) PLL is on when fHCLK > 8 MHz.

### Table 20. Maximum current consumption in Run mode

| Symbol | Parameter | Conditions | fHCLK | Max TA = 85 °C | TA = 105 °C | Unit |
|--------|---------|-----------|--------|--------------------|-------------|------|
| IDD | Supply current in Run mode | High speed external crystal (HEXT)(1), all peripherals enabled | 240 MHz | 108.5 | 119.6 | mA |
| | | | 200 MHz | 93.3 | 104.2 | |
| | | | 144 MHz | 71.6 | 82.2 | |
| | | | 120 MHz | 73.2 | 83.7 | |
| | | | 108 MHz | 67.5 | 77.9 | |
| | | | 72 MHz | 50.4 | 60.6 | |
| | | | 48 MHz | 38.4 | 48.5 | |
| | | | 36 MHz | 32.4 | 42.3 | |
| | | | 24 MHz | 26.3 | 36.2 | |
| | | | 16 MHz | 22.3 | 32.0 | |
| | | | 8 MHz | 17.8 | 27.5 | |
| | | High speed external crystal (HEXT)(1), all peripherals disabled | 240 MHz | 53.4 | 63.5 | mA |
| | | | 200 MHz | 46.9 | 57.0 | |
| | | | 144 MHz | 37.8 | 47.7 | |
| | | | 120 MHz | 35.4 | 45.3 | |
| | | | 108 MHz | 33.3 | 43.2 | |
| | | | 72 MHz | 27.3 | 37.1 | |
| | | | 48 MHz | 22.9 | 32.6 | |
| | | | 36 MHz | 20.7 | 30.4 | |
| | | | 24 MHz | 18.5 | 28.2 | |
| | | | 16 MHz | 17.0 | 26.7 | |
| | | | 8 MHz | 15.2 | 24.8 | |

(1) External clock is 8 MHz and PLL is on when fHCLK > 8 MHz.

### Table 21. Maximum current consumption in Sleep mode

| Symbol | Parameter | Conditions | fHCLK | Max TA = 85 °C | TA = 105 °C | Unit |
|--------|---------|-----------|--------|--------------------|-------------|------|
| IDD | Supply current in Sleep mode | High speed external crystal (HEXT)(1), all peripherals enabled | 240 MHz | 92.8 | 103.2 | mA |
| | | | 200 MHz | 80.0 | 90.4 | |
| | | | 144 MHz | 61.9 | 72.1 | |
| | | | 120 MHz | 64.1 | 74.3 | |
| | | | 108 MHz | 59.2 | 69.3 | |
| | | | 72 MHz | 44.8 | 54.7 | |
| | | | 48 MHz | 34.6 | 44.4 | |
| | | | 36 MHz | 29.5 | 39.2 | |
| | | | 24 MHz | 24.4 | 34.0 | |
| | | | 16 MHz | 20.9 | 30.5 | |
| | | | 8 MHz | 17.0 | 26.5 | |
| | | High speed external crystal (HEXT)(1), all peripherals disabled | 240 MHz | 23.9 | 33.5 | mA |
| | | | 200 MHz | 22.3 | 31.8 | |
| | | | 144 MHz | 20.0 | 29.4 | |
| | | | 120 MHz | 19.6 | 29.0 | |
| | | | 108 MHz | 19.0 | 28.4 | |
| | | | 72 MHz | 17.7 | 27.1 | |
| | | | 48 MHz | 16.4 | 25.8 | |
| | | | 36 MHz | 15.8 | 25.2 | |
| | | | 24 MHz | 15.2 | 24.6 | |
| | | | 16 MHz | 14.8 | 24.2 | |
| | | | 8 MHz | 13.9 | 23.3 | |

(1) External clock is 8 MHz and PLL is on when fHCLK > 8 MHz.

### Table 22. Typical and maximum current consumptions in Deepsleep and Standby modes

| Symbol | Parameter | Conditions | Typ(1) VDD/VBAT = 2.6 V | VDD/VBAT = 3.3 V | Max(2) TA = 25 °C | TA = 85 °C | TA = 105 °C | Unit |
|--------|---------|-----------|--------------------------------|--------------------------------|------------------------|--------------------|---------------------|------|
| IDD | Supply current in Deepsleep mode | LDO in Run mode, HICK and HEXT OFF (no WDT) | 1.35 | 1.36 | Refer to note (3) | 13.6 | 23.7 | mA |
| | | LDO in low-power mode, HICK and HEXT OFF (no WDT) | 1.33 | 1.34 | | 13.1 | 22.8 | mA |
| | Supply current in Standby mode | LEXT and RTC OFF | 3.93 | 5.72 | 7.49 | 10.4 | 14.9 | μA |
| | | LEXT and RTC ON | 4.55 | 6.48 | 8.34 | 11.5 | 16.5 | μA |

(1) Typical values are measured at TA = 25 °C.  
(2) Guaranteed by characterization results, not tested in production.  
(3) The value may be several times the typical values due to process variation.

[Figure 9: Typical current consumption in Deepsleep mode vs. temperature at different VDD]

[Figure 10: Typical current consumption in Standby mode vs. temperature at different VDD]

### Table 23. Typical and maximum current consumptions on VBAT

| Symbol | Parameter | Conditions | Typ(1) VBAT = 2.0 V | VBAT = 2.6 V | VBAT = 3.3 V | Max(2) TA = 25 °C | TA = 85 °C | TA = 105 °C | Unit |
|--------|---------|-----------|--------------------|--------------------|--------------------|------------------------|--------------------|---------------------|------|
| IDD_VBAT | VBAT Supply current | LEXT and RTC ON, VDD < VLVR | 0.47 | 0.59 | 0.77 | 0.92 | 1.34 | 2.04 | μA |

(1) Typical values are measured at TA = 25 °C.  
(2) Guaranteed by characterization results, not tested in production.

[Figure 11: Typical current consumption on VBAT with LEXT and RTC ON vs. temperature at different VBAT]

**On-chip peripheral current consumption**  
The MCU is placed under the following conditions:  
- All GPIO pins are in analog mode.  
- The given value is calculated by measuring the current consumption difference between “all peripherals clocked OFF” and “only one peripheral clocked ON”.

### Table 24. Peripheral current consumption

| Peripheral | Typ | Unit |
|------------|-----|------|
| **AHB** | | |
| DMA1 | 9.34 | μA/MHz |
| DMA2 | 9.39 | |
| GPIOA | 1.41 | |
| GPIOB | 1.41 | |
| GPIOC | 1.47 | |
| GPIOD | 1.43 | |
| GPIOE | 1.44 | |
| XMC | 26.89 | |
| CRC | 1.53 | |
| SDIO1 | 19.62 | |
| SDIO2 | 20.40 | |
| **APB1** | | |
| TMR2 | 9.11 | |
| TMR3 | 6.52 | |
| TMR4 | 6.54 | |
| TMR5 | 8.82 | |
| TMR6 | 0.77 | |
| TMR7 | 0.75 | |
| TMR12 | 3.89 | |
| TMR13 | 2.45 | |
| TMR14 | 2.48 | |
| SPI2/I2S2 | 5.19 | |
| SPI3/I2S3 | 4.95 | |
| SPI4/I2S4 | 2.62 | |
| USART2 | 2.60 | |
| USART3 | 2.57 | |
| UART4 | 2.60 | |
| UART5 | 2.63 | |
| I2C1 | 2.47 | |
| I2C2 | 2.54 | |
| USBFS1 | 6.40 | |
| CAN1 | 3.77 | |
| CAN2 | 3.77 | |
| DAC1/2 | 2.30 | |
| WWDT | 0.34 | |
| PWC | 0.34 | |
| BPR | 68.36 | |
| **APB2** | | |
| IOMUX | 2.32 | |
| SPI1/I2S1 | 2.82 | |
| USART1 | 2.53 | |
| USART6 | 2.64 | |
| UART7 | 2.80 | |
| UART8 | 2.85 | |
| I2C3 | 2.48 | |
| TMR1 | 8.99 | |
| TMR8 | 8.72 | |
| TMR9 | 3.78 | |
| TMR10 | 2.62 | |
| TMR11 | 2.56 | |
| ADC1 | 5.17 | |
| ADC2 | 5.24 | |
| ADC3 | 5.18 | |
| ACC | 0.95 | |

#### 5.3.6 External clock source characteristics

**High-speed external clock generated from a crystal / ceramic resonator**  
The high-speed external (HEXT) clock can be supplied with a 4 to 25 MHz crystal/ceramic resonator oscillator. All the information given in this paragraph are based on characterization results obtained with typical external components specified in the table below. In the application, the resonator and the load capacitors have to be placed as close as possible to the oscillator pins in order to minimize output distortion and startup stabilization time. Refer to the crystal resonator manufacturer for more details on the resonator characteristics (frequency, package, accuracy).

### Table 25. HEXT 4-25 MHz crystal characteristics(1)(2)

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| fHEXT_IN | Oscillator frequency | - | 4 | 8 | 25 | MHz |
| tSU(HEXT)(3) | Startup time | VDD is stabilized | - | 2 | - | ms |

(1) Oscillator characteristics given by the crystal/ceramic resonator manufacturer.  
(2) Guaranteed by characterization results, not tested in production.  
(3) tSU(HEXT) is the startup time measured from the moment HEXT is enabled (by software) to a stabilized 8 MHz oscillation is reached. This value is measured for a standard crystal resonator and it can vary significantly with the crystal manufacturer

For CL1 and CL2, it is recommended to use high-quality external ceramic capacitors in the 5 pF to 25 pF range (typ.), designed for high-frequency applications, and selected to match the requirements of the crystal or resonator. CL1 and CL2 are usually the same size. The crystal manufacturer typically specifies a load capacitance which is the series combination of CL1 and CL2. PCB and MCU pin capacitance must be included (10 pF can be used as a rough estimate of the combined pin and board capacitance) when sizing CL1 and CL2.

[Figure 12: HEXT typical application with an 8 MHz crystal]

**High-speed external clock generated from an external source**  
The characteristics given in the table below result from tests performed using a high-speed external clock source.

### Table 26. HEXT external source characteristics

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| fHEXT_ext | User external clock source frequency(1) | - | 1 | 8 | 25 | MHz |
| VHEXTH | HEXT_IN input pin high level voltage | | 0.7VDD | - | VDD | V |
| VHEXTL | HEXT_IN input pin low level voltage | | VSS | - | 0.3VDD | V |
| tw(HEXT) tw(HEXT) | HEXT_IN high or low time(1) | | 5 | - | - | ns |
| tr(HEXT) tf(HEXT) | HEXT_IN rise or fall time(1) | | - | - | 20 | ns |
| Cin(HEXT) | HEXT_IN input capacitance(1) | - | - | 5 | - | pF |
| DuCy(HEXT) | Duty cycle | - | 45 | - | 55 | % |
| IL | HEXT_IN Input leakage current | VSS ≤ VIN ≤ VDD | - | - | ±1 | μA |

(1) Guaranteed by design, not tested in production.

[Figure 13: HEXT external source AC timing diagram]

**Low-speed external clock generated from a crystal / ceramic resonator**  
The low-speed external (LEXT) clock can be supplied with a 32.768 kHz crystal/ceramic resonator oscillator. All the information given in this paragraph are based on characterization results obtained with typical external components specified in the table below. In the application, the resonator and the load capacitors have to be placed as close as possible to the oscillator pins in order to minimize output distortion and startup stabilization time. Refer to the crystal resonator manufacturer for more details on the resonator characteristics (frequency, package, accuracy).

### Table 27. LEXT 32.768 kHz crystal characteristics(1)(2)

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| tSU(LEXT) | Startup time | VDD is stabilized | - | 150 | - | ms |

(1) Oscillator characteristics given by the crystal/ceramic resonator manufacturer.  
(2) Guaranteed by characterization results, not tested in production.

For CL1 and CL2, it is recommended to use high-quality ceramic capacitors in the 5 pF to 20 pF range selected to match the requirements of the crystal or resonator. CL1 and CL2, are usually the same size. The crystal manufacturer typically specifies a load capacitance which is the series combination of CL1 and CL2.

Load capacitance CL has the following formula: CL = CL1 x CL2 / (CL1 + CL2) + Cstray where Cstray is the pin capacitance and board or trace PCB-related capacitance. Typically, it is between 2 pF and 7 pF.

[Figure 14: LEXT typical application with a 32.768 kHz crystal]

Note: No external resistor is required between LEXT_IN and LEXT_OUT and it is prohibited to add it.

**Low-speed external clock generated from an external source**  
The characteristics given in the table below result from tests performed using a low-speed external clock source.

### Table 28. LEXT external source characteristics

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| fLEXT_ext | User External clock source frequency(1) | - | - | 32.768 | 1000 | kHz |
| VLEXTH | LEXT_IN input pin high level voltage | | 0.7VDD | - | VDD | V |
| VLEXTL | LEXT_IN input pin low level voltage | | VSS | - | 0.3VDD | V |
| tw(LEXT) tw(LEXT) | LEXT_IN high or low time(1) | | 450 | - | - | ns |
| tr(LEXT) tf(LEXT) | LEXT_IN rise or fall time(1) | | - | - | 50 | ns |
| Cin(LEXT) | LEXT_IN input capacitance(1) | - | - | 5 | - | pF |
| DuCy(LEXT) | Duty cycle | - | 30 | - | 70 | % |
| IL | LEXT_IN input leakage current | VSS ≤ VIN ≤ VDD | - | - | ±1 | μA |

(1) Guaranteed by design, not tested in production.

[Figure 15: LEXT external source AC timing diagram]

#### 5.3.7 Internal clock source characteristics

**High-speed internal clock (HICK)**

### Table 29. HICK clock characteristics

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| fHICK | Frequency | - | - | 48 | - | MHz |
| DuCy(HICK) | Duty cycle | - | 45 | - | 55 | % |
| ACCHICK | Accuracy of the HICK oscillator | User-trimmed with the CRM_CTRL register | - | - | 1(1) | % |
| | | ACC-trimmed | - | - | 0.25(1) | % |
| | | Factory-calibrated(2) TA = -40 ~ 105 °C | -2.5 |  | 2 | % |
| | | TA = -40 ~ 85 °C | -2 | - | 2 | % |
| | | TA = 0 ~ 70 °C | -1.5 | - | 1.5 | % |
| | | TA = 25 °C | -1 | - | 1 | % |
| tSU(HICK)(2) | HICK oscillator startup time | - | - | - | 10 | μs |
| IDD(HICK)(2) | HICK oscillator power consumption | - | - | 240 | 290 | μA |

(1) Guaranteed by design, not tested in production.  
(2) Guaranteed by characterization results, not tested in production.

[Figure 16: HICK clock frequency accuracy vs. temperature]

**Low-speed internal clock (LICK)**

### Table 30. LICK clock characteristics

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| fLICK(1) | Frequency | - | 30 | 40 | 60 | kHz |

(1) Guaranteed by characterization results, not tested in production.

#### 5.3.8 PLL characteristics

### Table 31. PLL characteristics

| Symbol | Parameter | Min(1) | Typ | Max(1) | Unit |
|--------|---------|--------|-----|--------|------|
| fPLL_IN | PLL input clock(2) | 2 | 8 | 16 | MHz |
| | PLL input clock duty cycle | 40 | - | 60 | % |
| fPLL_OUT | PLL multiplier output clock | 16 | - | 240 | MHz |
| tLOCK | PLL lock time | - | - | 200 | μs |
| Jitter | Cycle-to-cycle jitter | - | - | 300 | ps |

(1) Guaranteed by design, not tested in production.  
(2) Take care of using the appropriate multiplier factors so as to have PLL input clock values compatible with the range defined by fPLL_OUT.

#### 5.3.9 Wakeup time from low-power mode

The wakeup times given in the table below is measured on a wakeup phase with the HICK. The clock source used to wake up the device depends from the current operating mode:

- Sleep mode: the clock source is the clock that was set before entering Sleep mode.
- Deepsleep or Standby mode: the clock source is the HICK.

### Table 32. Low-power mode wakeup time

| Symbol | Parameter | Conditions | Typ | Unit |
|--------|---------|-----------|-----|------|
| tWUSLEEP | Wakeup from Sleep mode | | 3.3 | μs |
| tWUDEEPSLEEP | Wakeup from Deepsleep mode (regulator in normal mode) | | 280 | μs |
| | Wakeup from Deepsleep mode (regulator in low-power mode) | | 320 | μs |
| tWUSTDBY | Wakeup from Standby mode | | 8 | ms |

#### 5.3.10 EMC characteristics

Susceptibility tests are performed on a sample basis during device characterization.

**Functional EMS (electromagnetic susceptibility)**  
- EFT: A Burst of Fast Transient voltage (positive and negative) is applied to VDD and VSS through a coupling/decoupling network, until a functional disturbance occurs. This test is compliant with the IEC 61000-4-4 standard.

### Table 33. EMS characteristics

| Symbol | Parameter | Conditions | Level/Class |
|--------|---------|-----------|-------------|
| VEFT | Fast transient voltage burst limits to be applied through coupling/decoupling network conforms to IEC 61000-4-4 on VDD and VSS pins to induce a functional disturbance, VDD and VSS input has one 47 μF capacitor and each VDD and VSS pair 0.1 μF | VDD = 3.3 V, LQFP100, TA = +25 °C, fHCLK = 240 MHz, conforms to IEC 61000-4-4 | 4A (4kV) |
| | | VDD = 3.3 V, LQFP100, TA = +25 °C, fHCLK = 72 MHz, conforms to IEC 61000-4-4 | |

EMC characterization and optimization are performed at component level with a typical application environment. It should be noted that good EMC performance is highly dependent on the user application and the software in particular. Therefore it is recommended that the user applies EMC software optimization and prequalification tests in relation with the EMC level requested for his application.

#### 5.3.11 GPIO port characteristics

**General input / output characteristics**  
All GPIOs are CMOS and TTL compliant.

### Table 34. GPIO static characteristics

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| VIL | GPIO input low level voltage | - | –0.3 | - | 0.28 x VDD + 0.1 | V |
| VIH | TC GPIO input high level voltage | - | 0.31 x VDD + 0.8 | - | VDD + 0.3 | V |
| | FTa GPIO input high level voltage Analog mode | | - | - | VDD + 0.3 | V |
| | FT GPIO input high level voltage | | - | - | 5.5 | V |
| | FTa GPIO input high level voltage Input floating, input pull-up, or input pull-down mode | | - | - | 5.5 | V |
| Vhys | TC GPIO Schmitt trigger voltage hysteresis(1) | - | 200 | - | - | mV |
| | FT and FTa GPIO Schmitt trigger voltage hysteresis(1) | | 5% VDD | - | - | - |
| Ilkg | Input leakage current(2) | VSS ≤ VIN ≤ VDD TC GPIOs | - | - | ±1 | μA |
| | | VSS ≤ VIN ≤ 5.5V FT and FTa GPIO | - | - | ±1 | μA |
| RPU | Weak pull-up equivalent resistor(3) | VIN = VSS | 60 | 70 | 100 | kΩ |
| RPD | Weak pull-down equivalent resistor(3) (4) | VIN = VDD | 60 | 70 | 100 | kΩ |
| CIO | GPIO pin capacitance | - | - | 9 | - | pF |

(1) Hysteresis voltage between Schmitt trigger switching levels. Guaranteed by characterization results.  
(2) Leakage could be higher than max if negative current is injected on adjacent pins.  
(3) When the input is higher than VDD + 0.3 V, the internal pull-up and pull-down resistors must be disabled for FT, and FTa pins.  
(4) The pull-down resistor of BOOT0 exists permanently.

All GPIOs are CMOS and TTL compliant (no software configuration required). Their characteristics cover more than the strict CMOS-technology or TTL parameters.

**Output driving current**  
In the user application, the number of GPIO pins which can drive current must be controlled to respect the absolute maximum rating defined in Section 5.2.1:  

- The sum of the currents sourced by all GPIOs on VDD, plus the maximum Run consumption of the MCU sourced on VDD, cannot exceed the absolute maximum rating IVDD (see Table 9).  
- The sum of the currents sunk by all GPIOs on VSS, plus the maximum Run consumption of the MCU sunk on VSS, cannot exceed the absolute maximum rating IVSS (see Table 9).

**Output voltage levels**  
All GPIOs are CMOS and TTL compliant.

### Table 35. Output voltage characteristics

| Symbol | Parameter | Conditions | Min | Max | Unit |
|--------|---------|-----------|-----|-----|------|
| **Maximum sourcing/sinking strength** | | | | | |
| VOL | Output low level voltage | CMOS standard, IIO = 15 mA | - | 0.4 | V |
| VOH | Output high level voltage | | VDD-0.4 | - | V |
| VOL | Output low level voltage | TTL standard, IIO = 6 mA | - | 0.4 | V |
| VOH | Output high level voltage | | 2.4 | - | V |
| **Large sourcing/sinking strength** | | | | | |
| VOL | Output low level voltage | CMOS standard, IIO = 6 mA | - | 0.4 | V |
| VOH | Output high level voltage | | VDD-0.4 | - | V |
| VOL | Output low level voltage | TTL standard, IIO = 3 mA | - | 0.4 | V |
| VOH | Output high level voltage | | 2.4 | - | V |
| VOL(1) | Output low level voltage | IIO = 20 mA | - | 1.3 | V |
| VOH(1) | Output high level voltage | | VDD-1.3 | - | V |
| **Normal sourcing/sinking strength** | | | | | |
| VOL | Output low level voltage | CMOS standard, IIO = 4 mA | - | 0.4 | V |
| VOH | Output high level voltage | | VDD-0.4 | - | V |
| VOL | Output low level voltage | TTL standard, IIO = 2 mA | - | 0.4 | V |
| VOH | Output high level voltage | | 2.4 | - | V |
| VOL(1) | Output low level voltage | IIO = 10 mA | - | 1.3 | V |
| VOH(1) | Output high level voltage | | VDD-1.3 | - | V |

(1) Guaranteed by characterization results, not tested in production.

**Input AC characteristics**  
The definition and values of input AC characteristics are given as follows.

### Table 36. Input AC characteristics

| Symbol | Parameter | Min | Max | Unit |
|--------|---------|-----|-----|------|
| tEXINTpw | Pulse width of external signals detected by EXINT controller | 10 | - | ns |

#### 5.3.12 NRST pin characteristics

The NRST pin input driver uses CMOS technology. It is connected to a permanent pull-up resistor, RPU (see the table below).

### Table 37. NRST pin characteristics

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| VIL(NRST)(1) | NRST input low level voltage | - | -0.5 | - | 0.8 | V |
| VIH(NRST)(1) | NRST input high level voltage | - | 2 | - | VDD + 0.3 | V |
| Vhys(NRST) | NRST Schmitt trigger voltage hysteresis | - | - | 500 | - | mV |
| RPU | Weak pull-up equivalent resistor VIN = VSS | 30 | 40 | 50 | kΩ |
| tILV(NRST)(1) | NRST input low level inactive | - | - | - | 33.3 | μs |
| VNF(NRST)(1) | NRST input low level active | - | 66.7 | - | - | μs |

(1) Guaranteed by design, not tested in production.

[Figure 17: Recommended NRST pin protection]

(1) The reset network protects the device against parasitic resets.  
(2) The user must ensure that the level on the NRST pin can go below the VIL (NRST) max level specified in Table 37. Otherwise the reset will not be taken into account by the device.

#### 5.3.13 XMC characteristics

The parameters given in the table below are guaranteed by design and not tested in production.

**Asynchronous waveforms and timings of PSRAM / NOR**  
The results shown in these tables are obtained with the following XMC configuration:  
- AddressSetupTime = 0  
- AddressHoldTime = 1  
- DataSetupTime = 1

### Table 38. Asynchronous multiplexed PSRAM / NOR read timings

| Symbol | Parameter | Min | Max | Unit |
|--------|---------|-----|-----|------|
| tw(NE) | XMC_NE low time | 7tHCLK - 2 | 7tHCLK + 2 | ns |
| tv(NOE_NE) | XMC_NE low to XMC_NOE low | 3tHCLK - 0.5 | 3tHCLK + 1.5 | ns |
| tw(NOE) | XMC_NOE low time | 4tHCLK - 1 | 4tHCLK + 2 | ns |
| th(NE_NOE) | XMC_NOE high to XMC_NE high hold time | -1 | - | ns |
| tv(A_NE) | XMC_NE low to XMC_A valid | - | 0 | ns |
| tv(NADV_NE) | XMC_NE low to XMC_NADV low | 3 | 5 | ns |
| tw(NADV) | XMC_NADV low time | tHCLK - 1.5 | tHCLK + 1.5 | ns |
| th(AD_NADV) | XMC_AD (address) valid hold time after XMC_NADV high | tHCLK + 3 | - | ns |
| th(A_NOE) | Address hold time after XMC_NOE high | tHCLK + 3 | - | ns |
| th(UBLB_NOE) | XMC_UB/LB hold time after XMC_NOE high | 0 | - | ns |
| tv(UBLB_NE) | XMC_NE low to XMC_UB/LB valid | - | 0 | ns |
| tsu(Data_NE) | Data to XMC_NE high setup time | 2tHCLK + 24 | - | ns |
| tsu(Data_NOE) | Data to XMC_NOE high setup time | 2tHCLK + 25 | - | ns |
| th(Data_NE) | Data hold time after XMC_NE high | 0 | - | ns |
| th(Data_NOE) | Data hold time after XMC_NOE high | 0 | - | ns |

[Figure 18: Asynchronous multiplexed PSRAM / NOR read waveforms]

### Table 39. Asynchronous multiplexed PSRAM / NOR write timings

| Symbol | Parameter | Min | Max | Unit |
|--------|---------|-----|-----|------|
| tw(NE) | XMC_NE low time | 5tHCLK - 1 | 5tHCLK + 2 | ns |
| tv(NWE_NE) | XMC_NE low to XMC_NWE low | 2tHCLK | 2tHCLK + 1 | ns |
| tw(NWE) | XMC_NWE low time | 2tHCLK - 1 | 2tHCLK + 2 | ns |
| th(NE_NWE) | XMC_NWE high to XMC_NE high hold time | tHCLK - 1 | - | ns |
| tv(A_NE) | XMC_NE low to XMC_A valid | - | 7 | ns |
| tv(NADV_NE) | XMC_NE low to XMC_NADV low | 3 | 5 | ns |
| tw(NADV) | XMC_NADV low time | tHCLK - 1 | tHCLK + 1 | ns |
| th(AD_NADV) | XMC_AD (address) valid hold time after XMC_NADV high | tHCLK - 3 | - | ns |
| th(A_NWE) | Address hold time after XMC_NWE high | 4tHCLK + 2.5 | - | ns |
| th(UBLB_NWE) | XMC_UB/LB hold time after XMC_NWE high | tHCLK - 1.5 | - | ns |
| tv(UBLB_NE) | XMC_NE low to XMC_UB/LB valid | - | 1.6 | ns |
| tv(Data_NADV) | XMC_NADV high to Data valid | - | tHCLK + 1.5 | ns |
| th(Data_NWE) | Data hold time after XMC_NWE high | tHCLK - 5 | - | ns |

[Figure 19: Asynchronous multiplexed PSRAM / NOR write waveforms]

**Synchronous waveforms and timings of PSRAM / NOR**  
The results shown in these tables are obtained with the following XMC configuration:  
- BurstAccessMode = XMC_BurstAccessMode_Enable (enable burst transfer mode)  
- MemoryType = XMC_MemoryType_CRAM (memory type is CRAM)  
- WriteBurst = XMC_WriteBurst_Enable (enable burst write operation)  
- CLKPrescale = 1; (memory cycle = 2 HICK cycles) (note: CLKPrescale refers to the CLKPSC bit in XMC_BK1TMGx register. Refer to the AT32F403A reference manual.)  
- DataLatency = 1 stands for NOR Flash; DataLatency = 0 for PSRAM (Note: DataLatency refers to the DATLAT bit in XMC_BK1TMGx register. Refer to the AT32F403A reference manual.)

### Table 40. Synchronous multiplexed PSRAM / NOR read timings

| Symbol | Parameter | Min | Max | Unit |
|--------|---------|-----|-----|------|
| tw(CLK) | XMC_CLK period | 20 | - | ns |
| td(CLKL-NEL) | XMC_CLK low to XMC_NE low | - | 1.5 | ns |
| td(CLKH-NEH) | XMC_CLK low to XMC_NE high | 1 | - | ns |
| td(CLKL-NADVL) | XMC_CLK low to XMC_NADV low | - | 4 | ns |
| td(CLKL-NADVH) | XMC_CLK low to XMC_NADV high | 5 | - | ns |
| td(CLKL-AV) | XMC_CLK low to XMC_A valid | - | 0 | ns |
| td(CLKH-AIV) | XMC_CLK low to XMC_A invalid | 2 | - | ns |
| td(CLKL-NOEL) | XMC_CLK high to XMC_NOE low |  | 1 | ns |
| td(CLKH-NOEH) | XMC_CLK low to XMC_NOE high | 0.5 | - | ns |
| td(CLKL-ADV) | XMC_CLK low to XMC_AD valid | - | 12 | ns |
| td(CLKL-ADIV) | XMC_CLK low to XMC_AD invalid | 0 | - | ns |
| tsu(ADV-CLKH) | XMC_AD valid data before XMC_CLK high | 6 | - | ns |
| th(CLKH-ADV) | XMC_AD valid data after XMC_CLK high | 6 | - | ns |
| tsu(NWAITV-CLKH) | XMC_NWAIT valid before XMC_CLK high | 8 | - | ns |
| th(CLKH-NWAITV) | XMC_NWAIT valid after XMC_CLK high | 6 | - | ns |

[Figure 20: Synchronous multiplexed PSRAM / NOR read timings]

### Table 41. Synchronous multiplexed PSRAM write timings

| Symbol | Parameter | Min | Max | Unit |
|--------|---------|-----|-----|------|
| tw(CLK) | XMC_CLK period | 20 | - | ns |
| td(CLKL-NEL) | XMC_CLK low to XMC_NE low | - | 2 | ns |
| td(CLKH-NEH) | XMC_CLK low to XMC_NE high | 2 | - | ns |
| td(CLKL-NADVL) | XMC_CLK low to XMC_NADV low | - | 4 | ns |
| td(CLKL-NADVH) | XMC_CLK low to XMC_NADV high | 5 | - | ns |
| td(CLKL-AV) | XMC_CLK low to XMC_A valid | - | 0 | ns |
| td(CLKH-AIV) | XMC_CLK low to XMC_A invalid | 2 | - | ns |
| td(CLKL-NWEL) | XMC_CLK low to XMC_NWE low | - | 1 | ns |
| td(CLKH-NWEH) | XMC_CLK low to XMC_NWE high | 0.5 | - | ns |
| td(CLKL-ADV) | XMC_CLK low to XMC_AD valid | - | 12 | ns |
| td(CLKL-ADIV) | XMC_CLK low to XMC_AD invalid | 3 | - | ns |
| td(CLKL-Data) | XMC_AD valid after XMC_CLK low | - | 6 | ns |
| td(CLKL-UBLBH) | XMC_CLK low to XMC_UB/LB high | 1 | - | ns |
| tsu(NWAITV-CLKH) | XMC_NWAIT valid before XMC_CLK high | 7 | - | ns |
| th(CLKH-NWAITV) | XMC_NWAIT valid after XMC_CLK high | 2 | - | ns |

[Figure 21: Synchronous multiplexed PSRAM write timings]

**NAND controller waveforms and timings**  
The results shown in this table are obtained with the following XMC configuration:  
- COM.XMC_SetupTime = 0x01; (Note: STP in XMC_BKxTMGMEM)  
- COM.XMC_WaitSetupTime = 0x03; (Note: OP in XMC_BKxTMGMEM)  
- COM.XMC_HoldSetupTime = 0x02; (Note: HLD in XMC_BKxTMGMEM)  
- COM.XMC_HiZSetupTime = 0x01; (Note: WRSTP in XMC_BKxTMGMEM)  
- ATT.XMC_SetupTime = 0x01; (Note: STP in XMC_BKxTMGATT)  
- ATT.XMC_WaitSetupTime = 0x03; (Note: OP in XMC_BKxTMGATT)  
- ATT.XMC_HoldSetupTime = 0x02; (Note: HLD in XMC_BKxTMGATT)  
- ATT.XMC_HiZSetupTime = 0x01; (Note: WRSTP in XMC_BKxTMGATT)  
- Bank = XMC_Bank_NAND;  
- MemoryDataWidth = XMC_MemoryDataWidth_16b; (Note: Memory data width = 16 bits)  
- ECC = XMC_ECC_Enable; (Note: enable ECC calculation)  
- ECCPageSize = XMC_ECCPageSize_512Bytes; (Note: ECC page size = 512 Bytes)  
- DLYCRSetupTime = 0; (Note: DLYCR in XMC_BKxCTRL)  
- DLYARSetupTime = 0; (Note: DLYAR in XMC_BKxCTRL)

### Table 42. NAND Flash read and write timings

| Symbol | Parameter | Min | Max | Unit |
|--------|---------|-----|-----|------|
| tw(NOE) | XMC_NWE low width | 4tHCLK - 1.5 | 4tHCLK + 1.5 | ns |
| tsu(D-NOE) | XMC_D valid data before XMC_NOE high | 25 | - | ns |
| th(NOE-D) | XMC_D valid data after XMC_NOE high | 14 | - | ns |
| td(ALE-NOE) | XMC_ALE valid before XMC_NOE low | - | 3tHCLK + 2 | ns |
| th(NOE-ALE) | XMC_NOE high to XMC_ALE invalid | 3tHCLK + 4.5 | - | ns |
| tw(NWE) | XMC_NWE low width | 4tHCLK - 1 | 4tHCLK + 2.5 | ns |
| tv(NWE-D) | XMC_NWE low to XMC_D valid | - | 0 | ns |
| th(NWE-D) | XMC_NWE high to XMC_D invalid | 10tHCLK + 4 | - | ns |
| td(D-NWE) | XMC_D valid before XMC_NWE high | 6tHCLK + 12 | - | ns |
| td(ALE-NWE) | XMC_ALE valid before XMC_NWE low | - | 3tHCLK + 1.5 | ns |
| th(NWE-ALE) | XMC_NWE high to XMC_ALE invalid | 3tHCLK + 4.5 | - | ns |

[Figure 22: NAND controller read waveforms]

[Figure 23: NAND controller write waveforms]

[Figure 24: NAND controller common memory read waveforms]

[Figure 25: NAND controller for common memory write waveforms]

#### 5.3.14 TMR timer characteristics

The parameters given in the table below are guaranteed by design.

### Table 43. TMR characteristics

| Symbol | Parameter | Conditions | Min | Max | Unit |
|--------|---------|-----------|-----|-----|------|
| tres(TMR) | Timer resolution time | - | 1 | - | tTMRxCLK |
| | | fTMRxCLK = 240 MHz | 4.17 | - | ns |
| fEXT | Timer external clock frequency on CH1 to CH4 | - | 0 | fTMRxCLK/2 | MHz |
| | | | | 50 | MHz |

#### 5.3.15 SPI characteristics

### Table 44. SPI characteristics

| Symbol | Parameter | Conditions | Min | Max | Unit |
|--------|---------|-----------|-----|-----|------|
| fSCK (1/tc(SCK))(1) | SPI clock frequency(2)(3) | VDD = 3.3 V, TA = 25 °C | - | 50 | MHz |
| | | VDD = 3.3 V, TA = 105 °C | - | 36 | MHz |
| | | VDD = 2.6 V, TA = 105 °C | - | 30 | MHz |
| tr(SCK) tf(SCK) | SPI clock rise and fall time | Capacitive load: C = 30 pF | - | 8 | ns |
| tsu(CS)(1) | CS setup time | Slave mode | 4tPCLK | - | ns |
| th(CS)(1) | CS hold time | Slave mode | 2tPCLK | - | ns |
| tw(SCKH)(1) tw(SCKL)(1) | SCK high and low time | Master mode, prescaler = 4 | 2tPCLK - 3 | 2tPCLK + 3 | ns |
| tsu(MI)(1) | Data input setup time | Master mode | 6 | - | ns |
| tsu(SI)(1) | | Slave mode | 5 | - | ns |
| th(MI)(1) | Data input setup time | Master mode | 4 | - | ns |
| th(SI)(1) | | Slave mode | 5 | - | ns |
| ta(SO)(1)(4) | Data output access time | Slave mode | tPCLK - 2 | 2tPCLK + 2 | ns |
| tdis(SO)(1)(5) | Data output disable time | Slave mode | tPCLK - 2 | 2tPCLK + 2 | ns |
| tv(SO)(1) | Data output valid time | Slave mode (after enable edge) | - | 25 | ns |
| tv(MO)(1) | Data output valid time | Master mode (after enable edge) | - | 10 | ns |
| th(SO)(1) | Data output hold time | Slave mode (after enable edge) | 9 | - | ns |
| th(MO)(1) | | Master mode (after enable edge) | 2 | - | ns |

(1) Guaranteed by design, not tested in production.  
(2) The maximum SPI clock frequency should not exceed fPCLK/2.  
(3) The maximum SPI clock frequency is highly related with devices and the PCB layout. For more details about the complete solution, please contact your local Artery sales representative.  
(4) Min time is for the minimum time to drive the output and the max time is for the maximum time to validate the data.  
(5) Min time is for the minimum time to invalidate the output and the max time is for the maximum time to put the data in Hi-Z.

[Figure 26: SPI timing diagram - slave mode and CPHA = 0]

[Figure 27: SPI timing diagram - slave mode and CPHA = 1]

[Figure 28: SPI timing diagram - master mode]

#### 5.3.16 I2S characteristics

### Table 45. I2S characteristics

| Symbol | Parameter | Conditions | Min | Max | Unit |
|--------|---------|-----------|-----|-----|------|
| tr(CK) tf(CK) | I2S clock rise and fall time | Capacitive load: C = 15 pF | - | 12 | ns |
| tv(WS)(1) | WS valid time | Master mode | 0 | 4 | ns |
| th(WS)(1) | WS hold time | Master mode | 0 | 4 | ns |
| tsu(WS)(1) | WS setup time | Slave mode | 9 | - | ns |
| th(WS)(1) | WS hold time | Slave mode | 0 | - | ns |
| tsu(SD_MR)(1) | Data input setup time | Master receiver | 6 | - | ns |
| tsu(SD_SR)(1) | | Slave receiver | 2 | - | ns |
| th(SD_MR)(1)(2) | Data input hold time | Master receiver | 0.5 | - | ns |
| th(SD_SR)(1)(2) | | Slave receiver | 0.5 | - | ns |
| tv(SD_ST)(1)(2) | Data output valid time | Slave transmitter (after enable edge) | - | 20 | ns |
| th(SD_ST)(1) | Data output hold time | Slave transmitter (after enable edge) | 9 | - | ns |
| tv(SD_MT)(1)(2) | Data output valid time | Master transmitter (after enable edge) | - | 15 | ns |
| th(SD_MT)(1) | Data output hold time | Master transmitter (after enable edge) | 0 | - | ns |

(1) Guaranteed by design, not tested in production.  
(2) Depends on fPCLK. For example, if fPCLK=8 MHz, then TPCLK = 1/fPCLK =125 ns.

[Figure 29: I2S slave timing diagram (Philips protocol)]

(1) LSB transmit/receive of the previously transmitted byte. No LSB transmit/receive is sent before the first byte.

[Figure 30: I2S master timing diagram (Philips protocol)]

(1) LSB transmit/receive of the previously transmitted byte. No LSB transmit/receive is sent before the first byte.

#### 5.3.17 I2C interface characteristics

GPIO pins SDA and SCL have limitation as follows: they are not ”true” open-drain. When configured as open-drain, the PMOS connected between the GPIO pin and VDD is disabled, but is still present.

I2C bus interface can support standard mode (max. 100 kHz) and fast mode (max. 400 kHz). The I2C bus frequency can be increased up to 1 MHz. For more complete information, please contact your local Artery sales office for technical support.

#### 5.3.18 SDIO characteristics

[Figure 31: SDIO high-speed mode]

[Figure 32: SD default mode]

### Table 46. SD / MMC characteristics

| Symbol | Parameter | Conditions | Min | Max | Unit |
|--------|---------|-----------|-----|-----|------|
| fPP | Clock frequency in data transfer mode | - | 0 | 48 | MHz |
| tW(CKL) | Clock low time | - | 32 | - | ns |
| tW(CKH) | Clock high time | - | 30 | - | ns |
| tr | Clock rise time | - | - | 4 | ns |
| tf | Clock fall time | - | - | 5 | ns |
| CMD, D inputs (referenced to CK) | | | | | |
| tISU | Input setup time | - | 2 | - | ns |
| tIH | Input hold time | - | 0 | - | ns |
| CMD, D outputs (referenced to CK) in MMC and SD HS mode | | | | | |
| tOV | Output valid time | - | - | 6 | ns |
| tOH | Output hold time | - | 0 | - | ns |
| CMD, D outputs (referenced to CK) in SD default mode(1) | | | | | |
| tOVD | Output valid default time | - | - | 7 | ns |
| tOHD | Output hold default time | - | 0.5 | - | ns |

(1) Refer to SDIO_CLKCTRL, the SDIO clock control register to control the CK output.

#### 5.3.19 USBFS characteristics

### Table 47. USBFS startup time

| Symbol | Parameter | Max | Unit |
|--------|---------|-----|------|
| tSTARTUP(1) | USBFS transceiver startup time | 1 | μs |

(1) Guaranteed by design, not tested in production.

### Table 48. USBFS DC electrical characteristics

| Symbol | Parameter | Conditions | Min(1) | Typ | Max(1) | Unit |
|--------|---------|-----------|--------|-----|--------|------|
| **Input levels** | | | | | | |
| VDD | USBFS operating voltage | - | 3.0(2) |  | 3.6 | V |
| VDI(3) | Differential input sensitivity | I (USBFS_D+, USBFS_D-) | 0.2 |  | - | V |
| VCM(3) | Differential common mode range | Includes VDI range | 0.8 |  | 2.5 | V |
| VSE(3) | Single ended receiver threshold | - | 1.3 |  | 2.0 | V |
| **Output levels** | | | | | | |
| VOL | Static output level low | RL of 1.24 kΩ to 3.6 V(4) | - |  | 0.3 | V |
| VOH | Static output level high | RL of 15 kΩ to VSS(4) | 2.8 |  | 3.6 | V |
| RPU | USBFS_D+ internal pull-up | VIN = VSS | 0.97 | 1.24 | 1.58 | kΩ |

(1) All the voltages are measured from the local ground potential.  
(2) The AT32F403A USB functionality is ensured down to 2.7 V but not the full USB electrical characteristics which are degraded in the 2.7 to 3.0 V VDD voltage range.  
(3) Guaranteed by design, not tested in production.  
(4) RL is the load connected on the USB drivers.

[Figure 33: USBFS timings: definition of data signal rise and fall time]

### Table 49. USBFS electrical characteristics

| Symbol | Parameter | Conditions | Min(1) | Max(1) | Unit |
|--------|---------|-----------|--------|--------|------|
| tr | Rise time (2) | CL ≤ 50 pF | 4 | 20 | ns |
| tf | Fall Time (2) | CL ≤ 50 pF | 4 | 20 | ns |
| trfm | Rise/fall time matching | tr/tf | 90 | 110 | % |
| VCRS | Output signal crossover voltage | - | 1.3 | 2.0 | V |

(1) Guaranteed by design, not tested in production.  
(2) Measured from 10% to 90% of the data signal. For more detailed information, please refer to USB Specification - Chapter 7 (version 2.0).

#### 5.3.20 12-bit ADC characteristics

Unless otherwise specified, the parameters given in the table below are preliminary values derived from tests performed under ambient temperature, fPCLK2 frequency and VDDA supply voltage conditions summarized in Table 13.

Note: It is recommended to perform a calibration after each power-up.

### Table 50. ADC characteristics

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| VDDA | Power supply | - | 2.6 | - | 3.6 | V |
| VREF+ | Positive reference voltage(3) | - | 2.0 | - | VDDA | V |
| IDDA | Current on the VDDA input pin | - | - | 380(1) | 445 | μA |
| IVREF | Current on the VREF input pin(3) | - | - | 200(1) | 220 | μA |
| fADC | ADC clock frequency | - | 0.6 | - | 28 | MHz |
| fS(2) | Sampling rate | - | 0.05 | - | 2 | MHz |
| fTRIG(2) | External trigger frequency | fADC = 28 MHz | - | - | 1.65 | MHz |
| | | - | - | - | 17 | 1/fADC |
| VAIN | Conversion voltage range(3) | - | 0 (VSSA or VREF- internally tied to ground)) | - | VREF+ | V |
| RAIN(2) | External input impedance | - | See Table 51 and Table 52 for details | | Ω |
| CADC(2) | Internal sample and hold capacitor | - | - | 10 | - | pF |
| tCAL(2) | Calibration time | fADC = 28 MHz | | 6.61 | | μs |
| | | - | | 185 | | 1/fADC |
| tlat(2) | Injection trigger conversion latency | fADC = 28 MHz | - | - | 107 | ns |
| | | - | - | - | 3(4) | 1/fADC |
| tlatr(2) | Regular trigger conversion latency | fADC = 28 MHz | - | - | 71.4 | ns |
| | | - | - | - | 2(4) | 1/fADC |
| tS(2) | Sampling time | fADC = 28 MHz | 0.053 | - | 8.55 | μs |
| | | - | 1.5 | - | 239.5 | 1/fADC |
| tSTAB(2) | Power-up time | - | | 42 | | 1/fADC |
| tCONV(2) | Total conversion time (including sampling time) | fADC = 28 MHz | 0.5 | - | 9 | μs |
| | | - | 14 to 252 (tS for sampling + 12.5 for successive approximation) | | | 1/fADC |

(1) Guaranteed by design, not tested in production.  
(2) Guaranteed by design, not tested in production.  
(3) VREF+ can be internally connected to VDDA and VREF- can be internally connected to VSSA, depending on the package.  
(4) For external triggers, a delay of 1/fPCLK2 must be added to the latency specified in Table 50.

Table 51 and Table 52 are used to determine the maximum external impedance allowed for an error below 1/4 of LSB.

### Table 51. RAIN max for fADC = 14 MHz

| TS (Cycle) | tS (μs) | RAIN max (kΩ)(1) |
|------------|---------|-------------------|
| 1.5 | 0.11 | 0.25 |
| 7.5 | 0.54 | 1.3 |
| 13.5 | 0.96 | 2.5 |
| 28.5 | 2.04 | 5.0 |
| 41.5 | 2.96 | 8.0 |
| 55.5 | 3.96 | 10.5 |
| 71.5 | 5.11 | 13.5 |
| 239.5 | 17.11 | 40 |

(1) Guaranteed by design.

### Table 52. RAIN max for fADC = 28 MHz

| TS (Cycle) | tS (μs) | RAIN max (kΩ)(1) |
|------------|---------|-------------------|
| 1.5 | 0.05 | 0.1 |
| 7.5 | 0.27 | 0.6 |
| 13.5 | 0.48 | 1.2 |
| 28.5 | 1.02 | 2.5 |
| 41.5 | 1.48 | 4.0 |
| 55.5 | 1.98 | 5.2 |
| 71.5 | 2.55 | 7.0 |
| 239.5 | 8.55 | 20 |

(1) Guaranteed by design.

### Table 53. ADC accuracy(1)(2)

| Symbol | Parameter | Test Conditions | Typ | Max | Unit |
|--------|---------|-----------------|-----|-----|------|
| ET | Total unadjusted error | fPCLK2 = 56 MHz, fADC = 28 MHz, RAIN < 10 kΩ, VDDA = 3.0 to 3.6 V, TA = 25 °C VREF+ = VDDA | ±1.5 | ±2.5 | LSB |
| EO | Offset error | | +0.5 | ±1.5 | LSB |
| EG | Gain error | | +1 | +2/-0.5 | LSB |
| ED | Differential linearity error | | ±0.6 | ±0.9 | LSB |
| EL | Integral linearity error | | ±0.8 | ±1.5 | LSB |
| ET | Total unadjusted error | fPCLK2 = 56 MHz, fADC = 28 MHz, RAIN < 10 kΩ, VDDA = 2.6 to 3.6 V, TA = -40 ~ 105 °C | ±2 | ±4 | LSB |
| EO | Offset error | | +0.5 | ±2 | LSB |
| EG | Gain error | | +1 | +2.5/-1.5 | LSB |
| ED | Differential linearity error | | ±0.6 | ±1.2 | LSB |
| EL | Integral linearity error | | ±1 | ±2 | LSB |

(1) ADC DC accuracy values are measured after internal calibration.  
(2) Guaranteed by design, not tested in production.

[Figure 34: ADC accuracy characteristics]

(1) Example of an actual transfer curve.  
(2) Ideal transfer curve.  
(3) End point correlation line.  
(4) ET = Maximum deviation between the actual and the ideal transfer curves. EO = Deviation between the first actual transition and the first ideal one. EG = Deviation between the last ideal transition and the last actual one. ED = Maximum deviation between actual steps and the ideal one. EL = Maximum deviation between any actual transition and the end point correlation line.

[Figure 35: Typical connection diagram using the ADC]

(1) Refer to Table 50 for the values of RAIN and CADC.  
(2) Cparasitic represents the capacitance of the PCB (dependent on soldering and PCB layout quality) plus the pad capacitance (roughly 7 pF). A high Cparasitic value will downgrade conversion accuracy. To remedy this, fADC should be reduced.

**General PCB design guidelines**  
Power supply decoupling should be performed as shown in Figure 36 or Figure 37.depending on whether VREF+ is connected to VDDA or not. The 100 nF capacitors should be ceramic (good quality). They should be placed them as close as possible to the chip.

If HEXT is enabled while using any input channel of ADC123_IN10~13, follow PCB layout guide line below to isolate the high frequency interference from HEXT emitting to ADC input signals nearby.

- Use different PCB layers to route ADC_IN signal apart from HEXT path
- Do not route ADC_IN signals and HEXT path in parallel

[Figure 36: Power supply and reference decoupling (with external VREF pin)]

(1) VREF input is available only on 100-pin package and above.

[Figure 37: Power supply and reference decoupling (without external VREF pin)]

(1) VREF input is available only on 100-pin package and above.

#### 5.3.21 Internal reference voltage (VINTRV) characteristics

### Table 54. Internal reference voltage characteristics

| Symbol | Parameter | Conditions | Min | Typ | Max | Unit |
|--------|---------|-----------|-----|-----|-----|------|
| VINTRV(1) | Internal reference voltage | - | 1.16 | 1.20 | 1.24 | V |
| TCoeff(1) | Temperature coefficient | - | - | - | 120 | ppm/°C |
| TS_VINTRV(2) | ADC sampling time when reading the internal reference voltage | - | 5.1 | - | - | μs |

(1) Guaranteed by characterization results, not tested in production.  
(2) Guaranteed by design, not tested in production.

#### 5.3.22 Temperature sensor (VTS) characteristics

### Table 55. Temperature sensor characteristics

| Symbol | Parameter | Min | Typ | Max | Unit |
|--------|---------|-----|-----|-----|------|
| TL(1) | VTS linearity with temperature | - | ±2 | ±4 | ºC |
| Avg_Slope(1(2)) | Average slope | -4.11 | -4.26 | -4.41 | mV/ºC |
| V25(1)(2) | Voltage at 25 ºC | 1.19 | 1.28 | 1.37 | V |
| tSTART(3) | Startup time | - | - | 100 | μs |
| TS_temp(3) | ADC sampling time when reading the temperature | 5.1 |  |  | μs |

(1) Guaranteed by design, not tested in production.  
(2) The temperature sensor output voltage changes linearly with temperature. The offset of this line varies from chip to chip due to process variation (up to 50 °C from one chip to another). The internal temperature sensor is more suited to applications that detect temperature variations instead of absolute temperatures. If accurate temperature readings are needed, an external temperature sensor part should be used.  
(3) Guaranteed by design, not tested in production.

Obtain the temperature using the following formula:  
Temperature (in °C) = {(V25 - VTS) / Avg_Slope} + 25.

Where,  
V25 = VTS value for 25° C and  
Avg_Slope = Average Slope for curve between Temperature vs. VSENSE (given in mV/° C).

[Figure 38: VTS vs. temperature]

#### 5.3.23 12-bit DAC specifications

### Table 56. DAC characteristics

| Symbol | Parameter | Comments | Min | Typ | Max | Unit |
|--------|---------|----------|-----|-----|-----|------|
| VDDA | Analog supply voltage | - | 2.6 | - | 3.6 | V |
| VREF+(3) | Reference supply voltage | - | 2.0 | - | 3.6 | V |
| VSSA | Ground | - | 0 | - | 0 | V |
| RLOAD(1) | Resistive load with buffer ON | - | 5 | - | - | kΩ |
| RO(2) | Impedance output with buffer OFF | - | - | 13.2 | 16 | kΩ |
| CLOAD(1) | Capacitive load | - | - | - | 50 | pF |
| DAC_OUT(1) | Lower DAC_OUT voltage with buffer ON | - | 0.15 | - | - | V |
| | Higher DAC_OUT voltage with buffer ON | - | - | - | VREF+ - 0.2 | V |
| | Lower DAC_OUT voltage with buffer OFF | - | - | 0.5 | 3.5 | mV |
| | Higher DAC_OUT voltage with buffer OFF | - | - | - | VREF+ - 1.5 mV | V |
| IDDA | DC current consumption in quiescent mode | With no load, VREF+ = 3.6 V | - | 480 | 625 | μA |
| IVREF(3) | DC current consumption in quiescent mode | With no load, VREF+ = 3.6 V | - | 330 | 340 | μA |
| DNL(2) | Differential non linearity | - | - | ±0.4 | ±0.8 | LSB |
| INL(2) | Integral non linearity (difference between measured value and a line drawn between DAC_OUT min and DAC_OUT max) | - | - | ±0.8 | ±1.5 | LSB |
| Offset(2) | Offset error (difference between measured value at Code (0x800) and the ideal value = VREF+/2) | - | - | 15 | 30 | mV |
| | | - | 20 | 35 | LSB |
| Gain error(2) | Gain error | - | - | 0.1 | 0.25 | % |
| tSETTLING | Settling time | CLOAD ≤ 50 pF, RLOAD ≥ 5 kΩ | - | 1 | 4 | μs |
| Update rate | Max frequency for a correct DAC_OUT change when small variation in the input code (from code i to i+1 LSB) | CLOAD ≤ 50 pF, RLOAD ≥ 5 kΩ | - | - | 1 | MSPS |
| tWAKEUP | Wakeup time from off state (setting the EN bit in the DAC Control register) | CLOAD ≤ 50 pF, RLOAD ≥ 5 kΩ | - | 1.2 | 4 | μs |

(1) Guaranteed by design, not tested in production.  
(2) Guaranteed by design, not tested in production.  
(3) VREF+ can be internally connected to VDDA and VREF- can be internally connected to VSSA, depending on the package.

## 6 Package information

### 6.1 LQFP100 package information

[Figure 39: LQFP100 – 14 x 14 mm 100 pin low-profile quad flat package outline]

### Table 57. LQFP100 – 14 x 14 mm 100 pin low-profile quad flat package mechanical data

| Symbol | Min | Typ | Max |
|--------|-----|-----|-----|
| A | - | - | 1.60 |
| A1 | 0.05 | - | 0.15 |
| A2 | 1.35 | 1.40 | 1.45 |
| b | 0.17 | 0.20 | 0.26 |
| c | 0.10 | 0.127 | 0.20 |
| D | 15.75 | 16.00 | 16.25 |
| D1 | 13.90 | 14.00 | 14.10 |
| E | 15.75 | 16.00 | 16.25 |
| E1 | 13.90 | 14.00 | 14.10 |
| e | | 0.50 BSC. | |
| L | 0.45 | 0.60 | 0.75 |
| L1 | | 1.00 REF. | |

### 6.2 LQFP64 package information

[Figure 40: LQFP64 – 10 x 10 mm 64 pin low-profile quad flat package outline]

### Table 58. LQFP64 – 10 x 10 mm 64 pin low-profile quad flat package mechanical data

| Symbol | Min | Typ | Max |
|--------|-----|-----|-----|
| A | - | - | 1.60 |
| A1 | 0.05 | - | 0.15 |
| A2 | 1.35 | 1.40 | 1.45 |
| b | 0.17 | 0.20 | 0.27 |
| c | 0.09 | - | 0.20 |
| D | 11.75 | 12.00 | 12.25 |
| D1 | 9.90 | 10.00 | 10.10 |
| E | 11.75 | 12.00 | 12.25 |
| E1 | 9.90 | 10.00 | 10.10 |
| e | | 0.50 BSC. | |
| Θ | | 3.5° REF. | |
| L | 0.45 | 0.60 | 0.75 |
| L1 | | 1.00 REF. | |
| ccc | | 0.08 | |

### 6.3 LQFP48 package information

[Figure 41: LQFP48 – 7 x 7 mm 48 pin low-profile quad flat package outline]

### Table 59. LQFP48 – 7 x 7 mm 48 pin low-profile quad flat package mechanical data

| Symbol | Min | Typ | Max |
|--------|-----|-----|-----|
| A | - | - | 1.60 |
| A1 | 0.05 | - | 0.15 |
| A2 | 1.35 | 1.40 | 1.45 |
| b | 0.17 | 0.22 | 0.27 |
| c | 0.09 | - | 0.20 |
| D | 8.80 | 9.00 | 9.20 |
| D1 | 6.90 | 7.00 | 7.10 |
| E | 8.80 | 9.00 | 9.20 |
| E1 | 6.90 | 7.00 | 7.10 |
| e | | 0.50 BSC. | |
| Θ | 0° | 3.5° | 7° |
| L | 0.45 | 0.60 | 0.75 |
| L1 | | 1.00 REF. | |

### 6.4 QFN48 package information

[Figure 42: QFN48 – 6 x 6 mm 48 pin quad flat no-leads package outline]

### Table 60. QFN48 – 6 x 6 mm 48 pin quad flat no-leads package mechanical data

| Symbol | Min | Typ | Max |
|--------|-----|-----|-----|
| A | 0.80 | 0.85 | 0.90 |
| A1 | 0.00 | 0.02 | 0.05 |
| A3 | | 0.203 REF. | |
| b | 0.15 | 0.20 | 0.25 |
| D | 5.90 | 6.00 | 6.10 |
| D2 | 3.07 | 3.17 | 3.27 |
| E | 5.90 | 6.00 | 6.10 |
| E2 | 3.07 | 3.17 | 3.27 |
| e | | 0.40 BSC. | |
| K | 0.20 | - | - |
| L | 0.35 | 0.40 | 0.45 |

### 6.5 Device marking

[Figure 43: Marking example]

(1) Not In Scale.

### 6.6 Thermal characteristics

Thermal characteristics are calculated based on two-layer board that uses FR-4 material of 1.6mm thickness. They are guaranteed by design, not tested in production.

### Table 61. Package thermal characteristics

| Symbol | Parameter | Value | Unit |
|--------|---------|-------|------|
| ΘJA | Thermal resistance junction-ambient LQFP100 – 14 × 14 mm/0.5 mm pitch | 61.2 | °C/W |
| | Thermal resistance junction-ambient LQFP64 – 10 × 10 mm/0.5 mm pitch | 64.6 | °C/W |
| | Thermal resistance junction-ambient LQFP48 – 7 × 7 mm/0.5 mm pitch | 68.8 | °C/W |
| | Thermal resistance junction-ambient QFN48 – 6 × 6 mm/0.4 mm pitch | 37.8 | °C/W |

## 7 Part numbering

### Table 62. AT32F403A series part numbering

Example: AT32 F 4 0 3A V G T 7  

- Product family: AT32 = ARM®-based 32-bit microcontroller  
- Product type: F = General-purpose  
- Core: 4 = Cortex®-M4  
- Product series: 0 = Main Stream  
- Product application: 3A = CAN + USB series advanced version  
- Pin count: C = 48 pins, R = 64 pins, V = 100 pins  
- Internal Flash memory size: C = 256 KBytes of the internal Flash memory, E = 512 KBytes of the internal Flash memory, G = 1 MBytes of the internal Flash memory  
- Package: T = LQFP, U = QFN  
- Temperature range: 7 = -40 °C to +105 °C  

For a list of available options (speed, package, etc.) or for more information concerning this device, please contact your local Artery sales office.

## 8 Document revision history

### Table 63. Document revision history

| Date | Version | Change |
|------|---------|--------|
| 2020.1.8 | 1.00 | Initial release |
| 2020.2.10 | 1.01 | Modified the max. frequency of the system and the internal AHB clock as 240 MHz; and the internal APB clock as 120 MHz |
| 2020.4.22 | 1.02 | 1. Modified the minimum value of VREF+ of ADC and DAC as 2.0 V <br> 2. Modified conditions and max. frequencies of the internal AHB clock in Table 13 <br> 3. Updated current values in sector 5.3.4 <br> 4. Removed the original note (9) of Table 6 <br> 5. Modified the parameter descriptions, conditions, and the maximum values of the SPI clock frequency in Table 44 |
| 2020.8.7 | 1.03 | Corrected values in Table 55 |
| 2021.7.20 | 2.00 | 1. Modified paragraph orders and descriptions of the whole document <br> 2. Added Table 6 note (9) <br> 3. Added LQFP48 package mechanical D, D1, E, E1 Min. and Max. in Table 59 <br> 4. Modified QFN48 package mechanical D2, E2 and added D, E Min. and Max. in Table 60 |
| 2022.1.27 | 2.01 | 1. Updated Figure 42 <br> 2. Added Section 6.5 device marking example |
| 2022.6.10 | 2.02 | 1. Added max value and notes (TA = 25 °C) in Table 22 and Table 23. <br> 2. Added min and max values in D, D1, E and E1 lines of all package mechanic data tables. |
| 2022.11.24 | 2.03 | 1. Updated Figure 36 and Figure 37 <br> 2. Modified the value of ΘJA in Table 61 |
| 2023.10.17 | 2.04 | 1. Modified Table 16, Table 40, Table 41, Table 44 and Table 45 <br> 2. Added note (3) in Table 34 <br> 3. Updated CAN descriptions in 2.14.6 Controller area network (CAN) <br> 4. Updated the paragraph 4 in the “IMPORTANT NOTICE” at the end of the file. |

## IMPORTANT NOTICE – PLEASE READ CAREFULLY

Purchasers are solely responsible for the selection and use of ARTERY’s products and services, and ARTERY assumes no liability whatsoever relating to the choice, selection or use of the ARTERY products and services described herein

No license, express or implied, to any intellectual property rights is granted under this document. If any part of this document deals with any third party products or services, it shall not be deemed a license granted by ARTERY for the use of such third party products or services, or any intellectual property contained therein, or considered as a warranty regarding the use in any manner of such third party products or services or any intellectual property contained therein.

Unless otherwise specified in ARTERY’s terms and conditions of sale, ARTERY provides no warranties, express or implied, regarding the use and/or sale of ARTERY products, including but not limited to any implied warranties of merchantability, fitness for a particular purpose (and their equivalents under the laws of any jurisdiction), or infringement on any patent, copyright or other intellectual property right.

Purchasers hereby agree that ARTERY’s products are not designed or authorized for use in: (A) any application with special requirements of safety such as life support and active implantable device, or system with functional safety requirements; (B) any aircraft application; (C) any aerospace application or environment; (D) any weapon application, and/or (E) or other uses where the failure of the device or product could result in personal injury, death, property damage. Purchasers’ unauthorized use of them in the aforementioned applications, even if with a written notice, is solely at purchasers’ risk, and Purchasers are solely responsible for meeting all legal and regulatory requirements in such use.

Resale of ARTERY products with provisions different from the statements and/or technical characteristics stated in this document shall immediately void any warranty grant by ARTERY for ARTERY’s products or services described herein and shall not create or expand any liability of ARTERY in any manner whatsoever.

© 2023 ARTERY Technology – All rights reserved