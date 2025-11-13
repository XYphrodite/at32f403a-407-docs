# AT32F403A/407 Firmware Library
## Context7-Optimized Version

**Source:** Artery AT32F403A/407 Firmware Library v2.2.1  
**Optimized For:** Context7 AI Knowledge Base  
**Date:** November 2024

---

## 📚 What's Included

This is a **Context7-optimized** version of the AT32F403A/407 firmware library, containing **only the files useful for AI-powered documentation and development assistance**.

### ✅ Included Files

#### 1. **Documentation** (`document/`)
- `AT32F403A_407固件库BSP&Pack应用指南.pdf` - BSP & Pack application guide
- `ReleaseNotes_AT32F403A_407_Firmware_Library.pdf` - Library release notes

#### 2. **Peripheral Drivers** (`libraries/drivers/`)
**Header Files** (`inc/`) - 26 peripheral API definitions:
- ADC, BPR, CAN, CRC, CRM, DAC, Debug, DMA, EMAC, EXINT
- Flash, GPIO, I2C, MISC, PWC, RTC, SDIO, SPI, TMR
- USART, USB, WDT, WWDT, XMC, ACC, DEF

**Source Files** (`src/`) - 25 driver implementations:
- Complete peripheral driver implementations in C
- Shows proper API usage and peripheral control

**Documentation:**
- `ReleaseNotes_AT32F403A_407_Firmware_Library_Drivers.pdf`

#### 3. **CMSIS Support** (`libraries/cmsis/`)
**Core Support** (`cm4/core_support/`):
- ARM Cortex-M4 core headers
- DSP function headers (definitions only)
- Compiler-specific headers (GCC, IAR, Keil)

**Device Support** (`cm4/device_support/`):
- `at32f403a_407.h` - Complete device header with register definitions
- `at32f403a_407_conf_template.h` - Configuration template
- `system_at32f403a_407.c/h` - System initialization code

#### 4. **Example Code** (`project/at_start_f403a/examples/`, `project/at_start_f407/examples/`)
**1,985 example files** showing peripheral usage:
- **937 files** for AT32F403A examples
- **1,048 files** for AT32F407 examples

**File Types:**
- `.c` files - Complete working examples with main() functions
- `.h` files - Configuration headers and definitions
- `.txt` files - README files explaining each example

**Example Categories:**
- ADC examples (single, dual, DMA modes)
- CAN examples (basic, filters, interrupts)
- Flash examples (read, write, erase, sLib)
- PWC examples (sleep, deepsleep, standby modes)
- Timer examples (PWM, input capture, encoder)
- Communication examples (USART, I2C, SPI, USB)
- And many more...

**List Files:**
- `at_start_f403a_Example_list.htm` - Complete example index for F403A
- `at_start_f407_Example_list.htm` - Complete example index for F407

#### 5. **Board Support** (`project/at32f403a_407_board/`)
- `at32f403a_407_board.c/h` - Board-specific support code

#### 6. **License**
- `LICENSE` - Artery Technology license terms

---

## ❌ What Was Removed (Not Useful for Context7)

To optimize for Context7 and reduce repository size, the following were removed from examples:

- **IDE project files** - Removed (.uvprojx, .ewp, .ewd, .uvoptx, etc.)
- **Linker scripts** - Removed (.ld, .icf)
- **Startup files** - Removed (.s assembly files)
- **Build configurations** - Removed (.ini, .bat, workspace files)
- **Compiled binaries** - Removed (.hex, .bin, .axf, .out files)

**Other removals:**
- **26MB CHM file** - Compiled help (not AI-searchable)
- **Middlewares** - 3rd party libraries (FatFS, lwIP, FreeRTOS)
- **DSP implementations** - Large library not AT32-specific
- **Utility demos** - Executable files and demo projects
- **.git folder** - Version control

**What Was KEPT from Examples:**
- ✅ All `.c` source files - Main application code and peripheral examples
- ✅ All `.h` header files - Configuration and definitions
- ✅ All `.txt` files - README and documentation for each example

---

## 🎯 How Context7 Uses This

Context7 leverages this firmware library for:

### 1. **API Reference**
All peripheral header files provide:
- Function prototypes
- Register definitions
- Bit field definitions
- Configuration structures

### 2. **Implementation Examples**
Driver source files show:
- Proper peripheral initialization
- API usage patterns
- Error handling
- Hardware interaction

### 3. **System Understanding**
CMSIS files provide:
- ARM Cortex-M4 architecture
- Memory map
- Interrupt vectors
- System configuration

### 4. **Cross-References**
Links to errata sheet issues:
- CAN driver → Errata Issue 2.1-2.4
- Flash driver → Errata Issue 12.1-12.4
- PWC driver → Errata Issue 6.1-6.4
- ADC driver → Errata Issue 1.1

---

## 📖 Key Files for Context7

### Most Important Headers:

1. **`at32f403a_407.h`** - Complete device register map
2. **`at32f403a_407_can.h`** - CAN peripheral API
3. **`at32f403a_407_flash.h`** - Flash memory API
4. **`at32f403a_407_pwc.h`** - Power control API
5. **`at32f403a_407_adc.h`** - ADC API
6. **`at32f403a_407_gpio.h`** - GPIO API
7. **`at32f403a_407_crm.h`** - Clock and reset management

### Implementation Examples:

- **`at32f403a_407_can.c`** - CAN peripheral implementation
- **`at32f403a_407_flash.c`** - Flash operations
- **`at32f403a_407_pwc.c`** - Power management
- **`system_at32f403a_407.c`** - System initialization

---

## 🔗 Related Documentation

**In This Repository:**
- [README.md](../README.md) - Main repository documentation
- [ES0002 Errata Sheet](../ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md) - Device limitations
- [FAQ.md](../FAQ.md) - Frequently asked questions
- [docs/taxonomy/](../docs/taxonomy/) - Context7 taxonomy system

**External:**
- [Artery Official Website](https://www.arterytek.com/) - Latest documentation
- AT32F403A/407 Datasheet - Electrical specifications
- AT32F403A/407 Reference Manual - Complete peripheral documentation

---

## 📊 File Statistics

**Total Files:** ~2,100 files  
**Size:** ~5-7 MB (reduced from 100MB+)  
**Header Files:** 500+ (.h files)  
**Source Files:** 450+ (.c files)  
**Example Files:** 1,985 (filtered from 2,500+)  
**Documentation:** 3 PDFs + 2 HTML example lists  

**Reduction:** ~93% size reduction while keeping 100% of API information + working examples

---

## 🚀 Usage Examples

### For Context7 Queries:

**Q: "How do I configure CAN peripheral?"**  
→ Context7 searches `at32f403a_407_can.h` for API definitions  
→ References `at32f403a_407_can.c` for implementation  
→ **NEW:** Shows working example from `examples/can/can_communication_mode/`  
→ Cross-references Errata Sheet Issue 2.1 for known issues

**Q: "Show me a working ADC DMA example"**  
→ **NEW:** Finds `examples/adc/adc_dma/` with complete code  
→ Shows `main.c` with ADC + DMA configuration  
→ References `adc_dma.txt` with explanation  
→ Warns about Errata Issue 1.1 (dual mode limitations)

**Q: "How to enter Deepsleep mode?"**  
→ Locates `at32f403a_407_pwc.h` with power API  
→ **NEW:** Shows `examples/pwc/deepsleep/` working example  
→ Demonstrates proper entry/exit sequence  
→ Warns about Errata Issue 6.1 (AHB division)

**Q: "PWM generation with Timer?"**  
→ **NEW:** Multiple examples in `examples/tmr/tmr_pwm_output/`  
→ Shows different PWM modes and configurations  
→ Complete working code ready to adapt

---

## 📝 Version Information

**Library Version:** v2.2.1  
**Device Family:** AT32F403A/407  
**ARM Core:** Cortex-M4F  
**CMSIS Version:** 5.x  
**Optimization Date:** November 2024

---

## ⚖️ License

This firmware library is provided by **Artery Technology Co., Ltd.**

See [LICENSE](LICENSE) for complete license terms.

**For Context7:** This optimized version maintains all license requirements while removing non-essential files for AI knowledge base efficiency.

---

## 🤝 Contributing

To improve Context7's understanding of AT32 peripherals:

1. **Report Missing Information:** If Context7 can't answer a question, identify missing files
2. **Add Cross-References:** Link driver code to errata issues
3. **Document Patterns:** Add usage examples to relevant sections

---

**Last Updated:** November 2024  
**Optimization:** Context7 Knowledge Base v1.0  
**Status:** ✅ Production Ready

**🎯 Context7-Optimized:** Maximum information, minimum bloat!

