---
title: "AT32F403A/407 MCU Documentation Repository"
type: "mcu-documentation"
purpose: "context7-knowledge-source"
mcu_family: "AT32F403A/407"
architecture: "ARM Cortex-M4"
vendor: "Artery"
documentation_version: "2.0.11"
last_updated: "2024-11-13"
tags:
  - mcu
  - microcontroller
  - embedded-systems
  - arm-cortex-m4
  - errata
  - device-limitations
  - context7
  - artery-at32
peripherals:
  - CAN
  - Flash
  - PWC
  - ADC
  - I2C
  - I2S
  - TMR
  - USART
  - USB
  - GPIO
status: "production-ready"
---

# AT32F403A/407 MCU Documentation Repository
## Reference Source for Context7

![Status](https://img.shields.io/badge/Documentation-Complete-brightgreen)
![Type](https://img.shields.io/badge/Type-MCU%20Documentation-blue)
![Issues Documented](https://img.shields.io/badge/Issues-41%2F41-blue)
![Mermaid Diagrams](https://img.shields.io/badge/Diagrams-4-orange)
![Code Examples](https://img.shields.io/badge/Examples-1985-purple)
![Firmware Library](https://img.shields.io/badge/Firmware-v2.2.1-green)

**Comprehensive MCU documentation repository** for the **Artery AT32F403A/407** ARM Cortex-M4 microcontroller series. This repository serves as a primary documentation source for Context7, providing structured technical references and implementation guidelines.

**Includes:** 
- **1,985 working example files** (Context7-optimized firmware library v2.2.1)
- Complete peripheral driver references with CMSIS support
- Comprehensive taxonomy system for semantic search (6 YAML files)
- FAQ and development guides

**Note:** For device errata and limitations, please download the official ES0002 errata sheet (v2.0.11 or later) from [Artery Technology's official website](https://www.arterytek.com/).

---

## 📖 Context7 Integration

This repository is designed as a **documentation source for Context7**, providing:

- **Structured Technical References:** Complete MCU specifications and limitations in searchable Markdown format
- **Working Code Examples:** 1,985 peripheral examples (drivers, applications, use cases)
- **Intelligent Taxonomy:** 6 YAML files enabling semantic search and natural language queries
- **Device Limitations Catalog:** All 41 known issues with priority levels and workarounds
- **Quick Access:** Search-friendly format for rapid information retrieval during development

**Use this repository as a reference when:**
- Developing firmware for AT32F403A/407 microcontrollers
- Implementing Context7 MCU support and peripherals
- Documenting device-specific behaviors and workarounds
- Training new developers on AT32 capabilities and limitations

---

## 🚀 Quick Start

**Jump directly to:**
- [📦 Firmware Library (1,985 Examples)](AT32F403A_407_Firmware_Library/)
- [❓ FAQ - Common Questions](FAQ.md)
- [🗂️ Taxonomy System for Context7](docs/)
- [📝 CHANGELOG - Version History](CHANGELOG.md)
- [🔗 Official Artery Website](https://www.arterytek.com/) - Download latest errata sheet (ES0002)

---

## 📚 Main Documentation

### **[Firmware Library v2.2.1](AT32F403A_407_Firmware_Library/)** 🔥

**Context7-optimized firmware library** with working examples:
- ✅ **1,985 example files** (937 F403A + 1,048 F407)
- ✅ **Peripheral drivers** - Complete API headers and implementations
- ✅ **CMSIS support** - ARM Cortex-M4 core definitions
- ✅ **Examples for all peripherals** - ADC, CAN, Flash, I2C, SPI, TMR, USART, USB, etc.
- ✅ **Filtered for Context7** - Only .c/.h/.txt files (no IDE bloat)
- ✅ **93% size reduction** - From 100MB to ~5-7MB
- ✅ **[Complete documentation](AT32F403A_407_Firmware_Library/README_CONTEXT7.md)**

### **[Context7 Resources](docs/)**

**Intelligent taxonomy system for semantic search:**
- ✅ **[FAQ.md](FAQ.md)** - Common questions with answers
- ✅ **[CHANGELOG.md](CHANGELOG.md)** - Complete version history
- ✅ **[Taxonomy System](docs/)** - 6 YAML files for Context7 AI
  - `peripherals.yaml` - 16 peripheral definitions
  - `issue_categories.yaml` - Error classifications
  - `priority_levels.yaml` - Risk assessment
  - `keywords.yaml` - 200+ search terms
  - `peripheral_relationships.yaml` - Dependency mapping
  - `examples.yaml` - Complete example catalog

### **Device Errata & Limitations**

For complete device errata documentation (ES0002), please visit:
- **[Artery Official Website](https://www.arterytek.com/)** - Download ES0002 v2.0.11 or later
- **Document:** AT32F403A/407 Errata Sheet (41 documented issues with workarounds)
- **Includes:** Critical Flash, CAN, PWC issues; Revision A vs B comparison; Code examples

---

## ⚠️ Known Device Limitations

The AT32F403A/407 series has **41 documented silicon errata** that developers should be aware of:

### Critical Areas Requiring Attention

**🔴 High Priority Issues (7 total):**
- **Flash Memory:** sLib placement restrictions, NZW erase exceptions, SPIM read errors
- **CAN Bus:** Reception failures during retransmission with bit stuffing errors
- **Power Management:** Deepsleep wake-up failures with AHB frequency division
- **ADC:** Dual mode program hang conditions

**Hardware Revisions:**
- **Revision A:** All 41 issues present
- **Revision B:** Fixes 16 issues (39%), including all ADC, USB, and most I2C issues

**Workaround Availability:**
- 39 of 41 issues (95%) have documented workarounds
- 2 issues require using Revision B hardware

**📥 Download Official Errata Sheet:**  
Visit [Artery Technology](https://www.arterytek.com/) to download document **ES0002** (AT32F403A/407 Errata Sheet v2.0.11 or later) for complete details, code examples, and workarounds.

---

## 🎨 Key Features

### Code Examples

**1,985 working peripheral examples:**
- **ADC:** 8 examples (single, dual, DMA, temperature sensor)
- **CAN:** 5 examples (communication modes, filters, time-triggered)
- **Flash:** 4 examples (read/write, SPIM Flash operations)
- **I2C:** 5 examples (polling, interrupt, DMA, EEPROM)
- **SPI:** 6 examples (full/half duplex, SPI Flash + FatFS)
- **TMR:** 15 examples (PWM, input capture, encoder, complementary)
- **USART:** 14 examples (RS485, IrDA, LIN, smart card)
- **USB:** 13 examples (HID, MSC, CDC, composite devices)
- **PWC:** 3 examples (sleep, deepsleep with RTC)
- **And many more...** (GPIO, I2S, EMAC, XMC, etc.)

**All examples include:**
- Complete working main.c with initialization
- Peripheral configuration code
- Clock setup and optimization
- README.txt explaining purpose and usage

### Development Checklists

Ready-to-use checklists for:
- ✅ Flash operations (4 items)
- ✅ Power management (5 items)
- ✅ CAN communication (4 items)

---

## 📖 Usage Guide

### For New Developers

1. **Read the Quick Reference Table** to see all 41 issues at a glance
2. **Identify which peripherals** you're using in your project
3. **Check high-priority issues** for those peripherals
4. **Implement workarounds** from the code examples
5. **Consider Revision B** for new designs (39% of issues fixed)

### For Experienced Developers

- **Jump to specific peripheral sections** using the table of contents
- **Copy code examples** directly into your project
- **Use development checklists** before going to production
- **Reference diagrams** to understand complex error scenarios

### Example Workflow: CAN Implementation

1. Download the official ES0002 errata sheet from Artery Technology
2. Review all 4 documented CAN issues in the errata sheet
3. Focus on reception failure issue (high priority)
4. Choose appropriate workaround method from the errata documentation
5. Refer to CAN examples in `AT32F403A_407_Firmware_Library/project/*/examples/can/`
6. Implement workaround and test thoroughly

---

## 🔍 Search Tips

### By Peripheral
Search by name: `CAN`, `Flash`, `PWC`, `ADC`, `TMR`, `USART`, etc.

### By Example Type
Search for specific implementations:
- "DMA transfer"
- "interrupt handler"
- "PWM generation"
- "USB device"
- "I2C EEPROM"

### GitHub Search
Use GitHub's file search (`/`) for instant navigation across examples and drivers

---

## 🛠️ Technical Details

### Repository Information

- **Firmware Library Version:** v2.2.1
- **Last Updated:** November 2024
- **Total Examples:** 1,985 files
- **Supported Devices:** AT32F403A/407 series
- **Taxonomy Files:** 6 YAML classification files

### Supported Devices

**AT32F403A Series:**
- AT32F403ACGU7, AT32F403ACGT7, AT32F403ARGT7, AT32F403AVGT7
- AT32F403ACEU7, AT32F403ACET7, AT32F403ARET7, AT32F403AVET7
- AT32F403ACCU7, AT32F403ACCT7, AT32F403ARCT7, AT32F403AVCT7

**AT32F407 Series:**
- AT32F407RGT7, AT32F407VGT7, AT32F407AVGT7
- AT32F407RET7, AT32F407VET7
- AT32F407RCT7, AT32F407VCT7, AT32F407AVCT7

**Flash Sizes:** 256KB, 512KB, 1024KB  
**Core:** ARM Cortex-M4  
**Revisions Covered:** Revision A and Revision B

---

## 🔗 Related Resources

### Official Artery Resources
- **[Artery Official Website](https://www.arterytek.com/)** - Download latest documents
- **[AT32 MCU Series](https://www.arterytek.com/en/product/index.jsp)** - Product lineup
- **AT32F403A/407 Datasheet** - Electrical specifications
- **AT32F403A/407 Reference Manual** - Complete peripheral documentation

### Community Resources
- **GitHub:** Search "AT32F403" for code examples
- **Forums:** EEVBlog, STM32duino (AT32 compatible)
- **STM32 Code:** Often compatible due to ARM Cortex-M4 core

### Alternative Options
- **Revision B:** Fixes 16 of 41 issues - recommended for new designs
- **STM32F4 Series:** Alternative if issues are blocking

---

## 📋 Development Checklist

### Before Using AT32F403A/407

- [ ] Download official ES0002 errata sheet from Artery Technology
- [ ] Review all documented device limitations (41 issues)
- [ ] Identify peripherals used in your design
- [ ] Check for critical issues in Flash, CAN, and PWC peripherals
- [ ] Implement required workarounds from errata documentation
- [ ] Consider using Revision B for new designs (39% issues fixed)
- [ ] Test thoroughly with your specific use case

### For Each Peripheral

**Flash Memory:**
- [ ] Consult ES0002 for Flash limitations (4 documented issues)
- [ ] Never place sLib in Non-Zero-Wait (NZW) area
- [ ] Disable interrupts during Flash erase operations
- [ ] Place erase functions in Zero-Wait (ZW) area or RAM

**CAN Communication:**
- [ ] Consult ES0002 for CAN limitations (4 documented issues)
- [ ] Implement reception failure workaround
- [ ] Configure error handling for bit stuffing errors
- [ ] Test with CAN bus disturbances

**Power Management:**
- [ ] Consult ES0002 for PWC limitations (4 documented issues)
- [ ] Remove AHB frequency division before Deepsleep
- [ ] Disable Systick before entering Deepsleep mode
- [ ] Configure GPIO and CLKOUT properly for low power modes

---

## 🤝 Contributing

This documentation is converted from **official Artery Technology documents**.

### How to Contribute

**Found an error?**
- Open an issue with the specific section reference

**Have a better workaround?**
- Submit a pull request with code examples

**Want to add content?**
- Add practical examples or diagrams
- Improve existing explanations
- Translate to other languages

### Guidelines

- Maintain technical accuracy
- Reference official documentation
- Include working code examples
- Test workarounds on real hardware
- Follow existing formatting style

---

## 📜 License & Attribution

### Firmware Library

- **Copyright © Artery Technology Co., Ltd.**
- **Version:** v2.2.1
- **Content:** Peripheral drivers, examples, CMSIS support

### This Repository

- **Purpose:** MCU firmware library and documentation for Context7 and embedded development
- **Content:** 1,985 working code examples, peripheral drivers, taxonomy system
- **Status:** Production-ready for Context7 integration
- **Target Audience:** Embedded systems engineers, MCU firmware developers, Context7 AI developers

**Important:** For device errata and silicon limitations, always download the latest ES0002 errata sheet from [Artery Technology's official website](https://www.arterytek.com/). This repository contains firmware examples and drivers, not the official errata documentation.

---

## 📈 Repository Statistics

![Code Examples](https://img.shields.io/badge/Examples-1%2C985-purple)
![Firmware](https://img.shields.io/badge/Firmware-v2.2.1-green)
![Taxonomy](https://img.shields.io/badge/Taxonomy-6%20files-yellow)
![Peripherals](https://img.shields.io/badge/Peripherals-16+-blue)
![Drivers](https://img.shields.io/badge/Drivers-Complete-brightgreen)

---

## 🎯 Repository Goals

### Achieved ✅

- ✅ **1,985 working code examples** (Context7-optimized)
- ✅ **Complete firmware library v2.2.1** with peripheral drivers
- ✅ **Intelligent taxonomy system** (6 YAML files)
- ✅ **FAQ with common development questions**
- ✅ **CHANGELOG for version tracking**
- ✅ Development checklists and best practices
- ✅ Complete CMSIS support for ARM Cortex-M4
- ✅ Examples for all 16+ peripherals

### Future Enhancements

- 📌 Context7 integration guide for AI developers
- 📌 API reference documentation with detailed parameter descriptions
- 📌 Advanced peripheral driver implementation examples
- 📌 Comprehensive troubleshooting guide
- 📌 Migration guide from STM32F4 series
- 📌 Performance optimization tips and techniques
- 📌 Low-power mode implementation guide
- 📌 Community-contributed examples
- 📌 Video tutorials (community-driven)

---

## 💬 Support

- **Issues:** Use GitHub Issues for questions or problems
- **Discussions:** Use GitHub Discussions for general topics
- **Official Support:** Contact Artery Technology directly

---

## 🔗 Context7 Resources

**In This Repository:**
- **[Firmware Library](AT32F403A_407_Firmware_Library/):** 1,985 examples + drivers (v2.2.1)
- **[Taxonomy System](docs/):** 6 YAML files for semantic search
- **[FAQ](FAQ.md):** Common questions and answers
- **[CHANGELOG](CHANGELOG.md):** Version history

**External Resources:**
- **[Official Errata Sheet](https://www.arterytek.com/):** Download ES0002 for all 41 documented device limitations

**Related Projects:**
- **Context7 Repository:** Primary project repository
- **TafcoMcuCore:** MCU core implementation and drivers

---

**Last Updated:** November 2024  
**Firmware Version:** v2.2.1  
**Repository Status:** ✅ Production Ready for Context7

**🎯 MCU Firmware Library:** Complete reference for AT32F403A/407 development  
**📚 Context7 Source:** Primary documentation with 1,985 working examples  
**🤖 AI-Optimized:** 6-file taxonomy system for intelligent semantic search  
**🚀 Ready to Use:** Complete firmware library with drivers and examples  

**⭐ Help Others:** Star this repo if Context7 MCU support helped you!  
**🔄 Share:** Help other developers working on AT32 projects!  
**🤝 Contribute:** Improve documentation for the embedded community!

