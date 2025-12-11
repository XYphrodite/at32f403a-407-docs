# AT32F403A/407 Driver Library
## Context7-Optimized Version

**Source:** Artery AT32F403A/407 Firmware Library v2.2.1  
**Optimized For:** Context7 AI Knowledge Base  
**Date:** December 2024

---

## 📚 What's Included

This is a **Context7-optimized** version of the AT32F403A/407 driver library, containing **peripheral drivers and CMSIS support for API reference**.

### ✅ Included Files

#### 1. **Peripheral Drivers** (`libraries/drivers/`)
**Header Files** (`inc/`) - 26 peripheral API definitions:
- ADC, BPR, CAN, CRC, CRM, DAC, Debug, DMA, EMAC, EXINT
- Flash, GPIO, I2C, MISC, PWC, RTC, SDIO, SPI, TMR
- USART, USB, WDT, WWDT, XMC, ACC, DEF

**Source Files** (`src/`) - 26 driver implementations:
- Complete peripheral driver implementations in C
- Shows proper API usage and peripheral control

#### 2. **CMSIS Support** (`libraries/cmsis/`)
**Core Support** (`cm4/core_support/`):
- ARM Cortex-M4 core headers
- DSP function headers (definitions only)
- Compiler-specific headers (GCC, IAR, Keil)

**Device Support** (`cm4/device_support/`):
- `at32f403a_407.h` - Complete device header with register definitions
- `at32f403a_407_conf_template.h` - Configuration template
- `system_at32f403a_407.c/h` - System initialization code

#### 3. **License**
- `LICENSE` - Artery Technology license terms

---

## ❌ What Was Removed (Not Useful for Context7)

To optimize for Context7 and reduce repository size:

- **Example project folders** - Removed (knowledge captured in [peripheral documentation](../docs/))
- **Board support files** - Removed (knowledge captured in documentation)
- **IDE project files** - Not needed for AI reference
- **Middlewares** - 3rd party libraries (FatFS, lwIP, FreeRTOS)
- **DSP implementations** - Large library not AT32-specific

**What's Available Instead:**
- ✅ **26 comprehensive peripheral guides** in `docs/` folder with embedded code examples
- ✅ **Complete driver API** in `libraries/drivers/` for reference
- ✅ **CMSIS support** in `libraries/cmsis/` for core functionality

---

## 🎯 How Context7 Uses This

Context7 leverages this driver library for:

### 1. **API Reference**
All peripheral header files provide:
- Function prototypes
- Register definitions
- Bit field definitions
- Configuration structures

### 2. **Implementation Reference**
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
Links to peripheral documentation and errata:
- `docs/CAN_Controller_Area_Network.md` → Errata Issue 2.1-2.4
- `docs/FLASH_Flash_Memory_Controller.md` → Errata Issue 12.1-12.4
- `docs/PWC_Power_Control.md` → Errata Issue 6.1-6.4
- `docs/ADC_Analog_to_Digital_Converter.md` → Errata Issue 1.1

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

### Implementation Sources:

- **`at32f403a_407_can.c`** - CAN peripheral implementation
- **`at32f403a_407_flash.c`** - Flash operations
- **`at32f403a_407_pwc.c`** - Power management
- **`system_at32f403a_407.c`** - System initialization

---

## 🔗 Related Documentation

**In This Repository:**
- [README.md](../README.md) - Main repository documentation
- [Peripheral Documentation](../docs/) - 26 comprehensive peripheral guides
- [ES0002 Errata Sheet](../ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md) - Device limitations
- [FAQ.md](../FAQ.md) - Frequently asked questions
- [docs/taxonomy/](../docs/taxonomy/) - Context7 taxonomy system

**External:**
- [Artery Official Website](https://www.arterytek.com/) - Latest documentation
- AT32F403A/407 Datasheet - Electrical specifications
- AT32F403A/407 Reference Manual - Complete peripheral documentation

---

## 📊 File Statistics

**Total Files:** ~120 files  
**Size:** ~2 MB  
**Header Files:** 60+ (.h files)  
**Source Files:** 30+ (.c files)  

**Focus:** Core driver API and CMSIS support for reference  
**Peripheral Documentation:** Available in [docs/](../docs/) folder

---

## 🚀 Usage Examples

### For Context7 Queries:

**Q: "How do I configure CAN peripheral?"**  
→ Context7 searches `at32f403a_407_can.h` for API definitions  
→ References `at32f403a_407_can.c` for implementation  
→ Shows code examples from `docs/CAN_Controller_Area_Network.md`  
→ Cross-references Errata Sheet Issue 2.1 for known issues

**Q: "ADC with DMA?"**  
→ Finds API in `at32f403a_407_adc.h` and `at32f403a_407_dma.h`  
→ Shows code examples from `docs/ADC_Analog_to_Digital_Converter.md`  
→ Warns about Errata Issue 1.1 (dual mode limitations)

**Q: "How to enter Deepsleep mode?"**  
→ Locates `at32f403a_407_pwc.h` with power API  
→ Shows code examples from `docs/PWC_Power_Control.md`  
→ Demonstrates proper entry/exit sequence  
→ Warns about Errata Issue 6.1 (AHB division)

**Q: "PWM generation with Timer?"**  
→ Shows API from `at32f403a_407_tmr.h`  
→ Shows code examples from `docs/TMR_Timer.md`  
→ Different PWM modes and configurations explained

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

**Last Updated:** December 2024  
**Optimization:** Context7 Knowledge Base v2.0  
**Status:** ✅ Production Ready

**🎯 Context7-Optimized:** Driver API reference + comprehensive documentation!

