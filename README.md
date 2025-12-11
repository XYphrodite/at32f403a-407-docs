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
![Peripherals](https://img.shields.io/badge/Peripherals-26-purple)
![Issues Documented](https://img.shields.io/badge/Issues-41%2F41-blue)
![Mermaid Diagrams](https://img.shields.io/badge/Diagrams-4-orange)
![Drivers](https://img.shields.io/badge/Drivers-v2.2.1-green)

**Comprehensive MCU documentation repository** for the **Artery AT32F403A/407** ARM Cortex-M4 microcontroller series. This repository serves as a primary documentation source for Context7, providing structured technical references and implementation guidelines.

**Includes:** 
- **26 detailed peripheral documentation files** with code examples and best practices
- Complete peripheral driver API references with CMSIS support (v2.2.1)
- Comprehensive taxonomy system for semantic search (5 YAML files)
- FAQ and development guides

**Note:** For device errata and limitations, please download the official ES0002 errata sheet (v2.0.11 or later) from [Artery Technology's official website](https://www.arterytek.com/).

---

## 📖 Context7 Integration

This repository is designed as a **documentation source for Context7**, providing:

- **Structured Technical References:** Complete MCU specifications and limitations in searchable Markdown format
- **Comprehensive Peripheral Documentation:** 26 detailed guides with code examples, API references, and best practices
- **Intelligent Taxonomy:** 5 YAML files enabling semantic search and natural language queries
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
- [📚 Peripheral Documentation (26 Guides)](docs/)
- [📦 Driver API Reference](AT32F403A_407_Firmware_Library/)
- [❓ FAQ - Common Questions](FAQ.md)
- [📝 CHANGELOG - Version History](CHANGELOG.md)
- [🔗 Official Artery Website](https://www.arterytek.com/) - Download latest errata sheet (ES0002)

---

## 📚 Main Documentation

### **[Peripheral Documentation](docs/)** 🔥

**26 comprehensive peripheral guides** covering all AT32F403A/407 peripherals:
- ✅ **Complete API documentation** - Function references, configuration structures, usage patterns
- ✅ **Code examples** - Initialization, configuration, and operation code embedded in docs
- ✅ **Best practices** - Common pitfalls, optimization tips, and errata workarounds
- ✅ **GPIO pin mappings** - Pin assignments for each peripheral
- ✅ **Troubleshooting guides** - Problem diagnosis and solutions

### **[Driver API Reference](AT32F403A_407_Firmware_Library/)**

**Official peripheral drivers v2.2.1:**
- ✅ **26 peripheral drivers** - Complete API headers and implementations
- ✅ **CMSIS support** - ARM Cortex-M4 core definitions
- ✅ **[Documentation](AT32F403A_407_Firmware_Library/README_CONTEXT7.md)**

### **[Context7 Resources](docs/)**

**Intelligent taxonomy system for semantic search:**
- ✅ **[FAQ.md](FAQ.md)** - Common questions with answers
- ✅ **[CHANGELOG.md](CHANGELOG.md)** - Complete version history
- ✅ **[Taxonomy System](docs/taxonomy/)** - 5 YAML files for Context7 AI
  - `peripherals.yaml` - 26 peripheral definitions
  - `issue_categories.yaml` - Error classifications
  - `priority_levels.yaml` - Risk assessment
  - `keywords.yaml` - 200+ search terms
  - `peripheral_relationships.yaml` - Dependency mapping

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

### Peripheral Documentation

**26 comprehensive peripheral guides covering:**

| Category | Peripherals |
|----------|-------------|
| **Communication** | CAN, I2C, I2S, SPI, USART, USB, EMAC |
| **Analog** | ADC, DAC |
| **Timers** | TMR, RTC, WDT, WWDT |
| **System** | CRM, FLASH, GPIO, DMA, EXINT, NVIC, DEBUG |
| **Power** | PWC, BPR |
| **Memory** | XMC, SDIO |
| **Data** | CRC, ACC |

**Each documentation file includes:**
- Complete API reference with function descriptions
- Code examples for initialization and operation
- GPIO pin mappings and alternate functions
- Best practices and common pitfalls
- Errata workarounds where applicable

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

1. Read [CAN_Controller_Area_Network.md](docs/CAN_Controller_Area_Network.md) for complete guide
2. Download the official ES0002 errata sheet from Artery Technology
3. Review all 4 documented CAN issues in the errata sheet
4. Focus on reception failure issue (high priority)
5. Use code examples from the CAN documentation
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

- **Driver Library Version:** v2.2.1
- **Last Updated:** December 2024
- **Peripheral Documentation:** 26 comprehensive guides
- **Supported Devices:** AT32F403A/407 series
- **Taxonomy Files:** 5 YAML classification files

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

- **Purpose:** MCU documentation and driver reference for Context7 and embedded development
- **Content:** 26 peripheral guides, driver API references, taxonomy system
- **Status:** Production-ready for Context7 integration
- **Target Audience:** Embedded systems engineers, MCU firmware developers, Context7 AI developers

**Important:** For device errata and silicon limitations, always download the latest ES0002 errata sheet from [Artery Technology's official website](https://www.arterytek.com/). This repository contains firmware examples and drivers, not the official errata documentation.

---

## 📈 Repository Statistics

![Peripheral Docs](https://img.shields.io/badge/Peripheral%20Docs-26-purple)
![Drivers](https://img.shields.io/badge/Drivers-v2.2.1-green)
![Taxonomy](https://img.shields.io/badge/Taxonomy-5%20files-yellow)
![Peripherals](https://img.shields.io/badge/Peripherals-26-blue)
![API Reference](https://img.shields.io/badge/API-Complete-brightgreen)

---

## 🎯 Repository Goals

### Achieved ✅

- ✅ **26 comprehensive peripheral documentation files**
- ✅ **Complete driver library v2.2.1** with API references
- ✅ **Intelligent taxonomy system** (5 YAML files)
- ✅ **FAQ with common development questions**
- ✅ **CHANGELOG for version tracking**
- ✅ Development checklists and best practices
- ✅ Complete CMSIS support for ARM Cortex-M4
- ✅ Documentation for all 26 peripherals

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
- **[Peripheral Documentation](docs/):** 26 comprehensive guides with code examples
- **[Driver Library](AT32F403A_407_Firmware_Library/):** v2.2.1 API reference
- **[Taxonomy System](docs/taxonomy/):** 5 YAML files for semantic search
- **[FAQ](FAQ.md):** Common questions and answers
- **[CHANGELOG](CHANGELOG.md):** Version history

**External Resources:**
- **[Official Errata Sheet](https://www.arterytek.com/):** Download ES0002 for all 41 documented device limitations

**Related Projects:**
- **Context7 Repository:** Primary project repository
- **TafcoMcuCore:** MCU core implementation and drivers

---

**Last Updated:** December 2024  
**Driver Version:** v2.2.1  
**Repository Status:** ✅ Production Ready for Context7

**🎯 MCU Documentation:** Complete reference for AT32F403A/407 development  
**📚 Context7 Source:** 26 comprehensive peripheral guides with embedded code examples  
**🤖 AI-Optimized:** 5-file taxonomy system for intelligent semantic search  
**🚀 Ready to Use:** Complete documentation and driver API reference  

**⭐ Help Others:** Star this repo if Context7 MCU support helped you!  
**🔄 Share:** Help other developers working on AT32 projects!  
**🤝 Contribute:** Improve documentation for the embedded community!

