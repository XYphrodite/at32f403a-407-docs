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

**Comprehensive MCU documentation repository** for the **Artery AT32F403A/407** ARM Cortex-M4 microcontroller series. This repository serves as a primary documentation source for Context7, providing structured technical references, device limitations, and implementation guidelines.

**Includes:** 
- Complete errata sheet (ES0002 v2.0.11) with visual diagrams and workarounds
- **1,985 working example files** (Context7-optimized firmware library)
- Comprehensive taxonomy system for semantic search
- FAQ, CHANGELOG, and development guides

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
- [📊 Quick Reference Table - All 41 Issues](ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md#-quick-reference---all-issues-at-a-glance)
- [🔴 Critical Issues (High Priority)](ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md#critical-issues-to-address)
- [📦 Firmware Library (1,985 Examples)](AT32F403A_407_Firmware_Library/)
- [❓ FAQ - Common Questions](FAQ.md)
- [🗂️ Taxonomy System for Context7](docs/)
- [📝 CHANGELOG - Version History](CHANGELOG.md)

---

## 📚 Main Documentation

### **[ES0002 Errata Sheet](ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md)** ⭐

**Complete device limitations documentation** with:
- ✅ **41/41 subsections documented** (100% complete)
- ✅ **1,380 lines** of detailed technical information
- ✅ **4 embedded Mermaid diagrams** for complex topics
- ✅ **15+ C code examples** with workarounds
- ✅ **Quick reference table** with priority indicators
- ✅ **Development checklists** for critical peripherals
- ✅ **Revision A vs B comparison** for all issues

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
- ✅ **[FAQ.md](FAQ.md)** - 10 most common questions with answers
- ✅ **[CHANGELOG.md](CHANGELOG.md)** - Complete version history
- ✅ **[Taxonomy System](docs/)** - 6 YAML files for Context7 AI
  - `peripherals.yaml` - 16 peripheral definitions
  - `issue_categories.yaml` - Error classifications
  - `priority_levels.yaml` - Risk assessment
  - `keywords.yaml` - 200+ search terms
  - `peripheral_relationships.yaml` - Dependency mapping
  - `examples.yaml` - Complete example catalog

---

## 📊 Issues Summary

### By Peripheral

| Peripheral | Issues | Rev B Fixed | High Priority | Workarounds |
|------------|--------|-------------|---------------|-------------|
| **Flash** | 4 | 0/4 ❌ | 🔴🔴🔴 | ✅ Yes |
| **CAN** | 4 | 3/4 | 🔴🔴 | ✅ Yes (3 methods) |
| **PWC** | 4 | 2/4 | 🔴 | ✅ Yes |
| **I2S** | 5 | 5/5 ✅ | - | ✅ Yes |
| **TMR** | 5 | 1/5 | - | ✅ Yes |
| **I2C** | 4 | 4/4 ✅ | - | ✅ Yes |
| **ADC** | 3 | 3/3 ✅ | - | ✅ Yes |
| **USB** | 2 | 2/2 ✅ | - | ✅ Yes |
| **USART** | 2 | 2/2 ✅ | - | ✅ Yes (1 has none) |
| **Others** | 8 | 2/8 | - | ✅ Yes |
| **Total** | **41** | **16 (39%)** | **7** | **39/41 (95%)** |

### By Priority

| Priority | Count | Description |
|----------|-------|-------------|
| 🔴 **High** | 7 | Can cause system failure or data corruption |
| 🟡 **Medium** | 29 | May cause functional issues under specific conditions |
| 🟢 **Low** | 5 | Minor issues or edge cases |

### Revision Status

- **Fixed in Rev B:** 16 issues (39%)
- **Not Fixed (with workaround):** 23 issues (56%)
- **Not Fixed (no workaround):** 2 issues (5%) - **Use Rev B**

---

## 🔴 Critical Issues (Must Address)

### Top 5 High-Priority Issues

1. **Flash: sLib Placement (1.1.12.1)** 🔴
   - **Impact:** Program crashes when sLib placed in NZW area
   - **Fix:** Place sLib only in Zero-Wait (ZW) area
   - **Status:** Not fixed in Rev B

2. **Flash: NZW Erase During Execution (1.1.12.2)** 🔴
   - **Impact:** System exception during erase
   - **Fix:** Disable interrupts, place erase code in ZW/RAM
   - **Status:** Not fixed in Rev B

3. **Flash: SPIM Erase CPU Read (1.1.12.3)** 🔴
   - **Impact:** Read errors during external Flash erase
   - **Fix:** Disable interrupts during SPIM erase
   - **Status:** Not fixed in Rev B

4. **CAN: Reception Failure (1.1.2.1)** 🔴
   - **Impact:** Lost CAN messages during retransmission
   - **Fix:** 3 methods available (mailbox priority, lock/unlock, software filter)
   - **Status:** Not fixed in Rev B

5. **PWC: Deepsleep + AHB Division (1.1.6.1)** 🔴
   - **Impact:** Cannot wake up from Deepsleep mode
   - **Fix:** Remove AHB frequency division before entering Deepsleep
   - **Status:** Not fixed in Rev B

**→ [See all issues with details](ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md#-quick-reference---all-issues-at-a-glance)**

---

## 🎨 Key Features

### Visual Enhancements

This documentation includes **4 embedded Mermaid diagrams** that render automatically on GitHub:

1. **📊 Revision Status Pie Chart** - Fix distribution across revisions
2. **🚗 CAN Error Handling Flowchart** - Complete recovery procedure with 3 methods
3. **⚡ PWC Deepsleep State Machine** - Power control flow with error states
4. **💾 Flash Memory Layout Diagram** - ZW/NZW organization with issue mapping

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

```markdown
1. Navigate to CAN section (1.1.2)
2. Review all 4 CAN issues
3. Focus on 1.1.2.1 (Reception Failure) - High Priority
4. View CAN Error Handling Flowchart
5. Choose one of 3 workaround methods:
   - Method 1: Mailbox Priority (simple)
   - Method 2: Lock/Unlock (reliable) ← Recommended
   - Method 3: Software Filter (flexible)
6. Copy code example and integrate
7. Test with CAN error simulation
```

---

## 🔍 Search Tips

### By Issue Number
Search for specific issue: `1.1.2.1`, `1.1.12.2`, etc.

### By Peripheral
Search by name: `CAN`, `Flash`, `PWC`, `ADC`, etc.

### By Symptom
Search by behavior:
- "cannot wake up"
- "data loss"
- "exception"
- "stuck"
- "error"

### GitHub Search
Use GitHub's file search (`/`) for instant navigation

---

## 🛠️ Technical Details

### Document Information

- **Source:** ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.pdf
- **Official Version:** v2.0.11
- **Release Date:** 2024.06.24
- **Conversion Date:** November 2024
- **Format:** Markdown with Mermaid diagrams
- **Lines:** 1,380
- **Completeness:** 100% (41/41 subsections)

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

- [ ] Read complete errata sheet
- [ ] Identify peripherals used in your design
- [ ] Check high-priority issues (7 critical issues)
- [ ] Review issues for each peripheral you're using
- [ ] Implement required workarounds
- [ ] Test with error scenarios
- [ ] Consider Revision B for new designs

### For Each Peripheral

**Flash Memory:**
- [ ] Verify sLib is placed in ZW area only (1.1.12.1)
- [ ] Disable interrupts during NZW erase (1.1.12.2)
- [ ] Place erase functions in ZW/RAM (1.1.12.3)
- [ ] Initialize UID/F_SIZE buffers before erase (1.1.12.4)

**CAN Communication:**
- [ ] Implement one of 3 reception error methods (1.1.2.1)
- [ ] Add manual bus-off recovery routine (1.1.2.2)
- [ ] Configure auto-retransmit policy (1.1.2.3)
- [ ] Verify time quantum calculation (1.1.2.4)

**Power Management:**
- [ ] Remove AHB division before Deepsleep (1.1.6.1)
- [ ] Disable Systick before Deepsleep (1.1.6.2)
- [ ] Ensure WFI completes atomically (1.1.6.3)
- [ ] Configure GPIO states for Deepsleep (1.1.6.4)
- [ ] Set CLKOUT to NOCLK before Deepsleep (1.1.7.1)

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

### Original Documents

- **Copyright © Artery Technology Co., Ltd.**
- **Document:** ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11
- **Version:** v2.0.11
- **Date:** 2024.06.24

### This Repository

- **Purpose:** MCU documentation source for Context7 and embedded development
- **Format:** Markdown conversion for accessibility and search-friendliness
- **Enhancements:** Visual diagrams, cross-references, code examples, development checklists
- **Status:** Production-ready documentation for Context7 integration
- **Target Audience:** Context7 developers, embedded systems engineers, MCU firmware developers

**Disclaimer:** This is an unofficial community conversion of official Artery documentation. Always refer to the latest official PDFs for production use. This repository serves as a reference tool and should be used alongside official Artery documentation.

---

## 📈 Repository Statistics

![Lines of Code](https://img.shields.io/badge/Documentation%20Lines-1%2C380-blue)
![Issues Documented](https://img.shields.io/badge/Issues-41%2F41-brightgreen)
![Code Examples](https://img.shields.io/badge/Examples-1%2C985-purple)
![Diagrams](https://img.shields.io/badge/Mermaid-4-orange)
![Workarounds](https://img.shields.io/badge/Workarounds-39%2F41-green)
![Priority](https://img.shields.io/badge/High%20Priority-7-red)
![Firmware](https://img.shields.io/badge/Firmware-v2.2.1-green)
![Taxonomy](https://img.shields.io/badge/Taxonomy-6%20files-yellow)

---

## 🎯 Repository Goals

### Achieved ✅

- ✅ 100% content conversion from PDF to Markdown
- ✅ All 41 device limitations documented
- ✅ 4 Mermaid diagrams for visualization
- ✅ **1,985 working code examples** (Context7-optimized)
- ✅ **Complete firmware library v2.2.1** with peripheral drivers
- ✅ **Intelligent taxonomy system** (6 YAML files)
- ✅ **FAQ with 10 common questions**
- ✅ **CHANGELOG for version tracking**
- ✅ Quick reference table
- ✅ Development checklists
- ✅ Revision A vs B comparison

### Future Enhancements

- 📌 Context7 integration guide for developers
- 📌 API reference documentation for Context7 MCU bindings
- 📌 Peripheral driver implementation examples
- 📌 Add more practical examples
- 📌 Create troubleshooting guide
- 📌 Add migration guide from STM32
- 📌 Community-contributed workarounds
- 📌 Video tutorials (community)
- 📌 Translations (Chinese, etc.)

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
- **[Errata Sheet](ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md):** All 41 issues

**Related Projects:**
- **Context7 Repository:** Primary project repository
- **TafcoMcuCore:** MCU core implementation and drivers

---

**Last Updated:** November 2024  
**Documentation Version:** v2.0.11  
**Firmware Version:** v2.2.1  
**Repository Status:** ✅ Production Ready for Context7

**🎯 MCU Documentation:** Complete reference for AT32F403A/407 development  
**📚 Context7 Source:** Primary documentation with 1,985 working examples  
**🤖 AI-Optimized:** 6-file taxonomy system for intelligent search  
**🚀 Ready to Use:** All 41 issues + complete firmware library  

**⭐ Help Others:** Star this repo if Context7 MCU support helped you!  
**🔄 Share:** Help other developers working on AT32 projects!  
**🤝 Contribute:** Improve documentation for the embedded community!

