# Documentation Taxonomy for Context7
## AT32F403A/407 MCU Knowledge Base Structure

This directory contains **structured taxonomy files** designed to optimize Context7's understanding and semantic search capabilities for AT32F403A/407 MCU documentation.

---

## 📂 Taxonomy Files

### **peripherals.yaml**
Complete peripheral definitions with metadata:
- 16 peripherals fully documented
- Categories, descriptions, and common use cases
- Related peripherals and dependencies
- Issue counts and priority levels
- Errata section cross-references

**Context7 Use:** Understand peripheral relationships and capabilities

---

### **issue_categories.yaml**
Error type classifications for semantic search:
- 12 error categories (data corruption, system hang, exceptions, etc.)
- Severity mappings (critical, high, medium, low)
- Related peripherals for each error type
- Searchable keywords for symptom-based queries

**Context7 Use:** Match symptoms to known issues ("system freeze" → "system_hang")

---

### **priority_levels.yaml**
Issue prioritization and risk assessment:
- High priority: 7 critical issues with system impact
- Medium priority: 29 functional issues
- Low priority: 5 minor issues
- Revision A vs B status
- Decision matrix for design choices

**Context7 Use:** Determine which issues require immediate attention

---

### **keywords.yaml**
Comprehensive search term mappings:
- **Symptom-based keywords:** "crash", "freeze", "data loss"
- **Technical terms:** Peripheral-specific terminology
- **Action keywords:** "initialize", "configure", "debug"
- **Use cases:** Automotive, industrial, IoT
- **Peripheral aliases:** UART/USART, I²C/IIC, etc.
- **Question patterns:** "why does", "how to", "what causes"

**Context7 Use:** Natural language query understanding

---

### **peripheral_relationships.yaml**
Dependency mapping and cross-references:
- Dependencies between peripherals (CAN depends on CRM, GPIO, NVIC)
- Integration patterns (ADC with DMA, TMR with PWM)
- Issue relationships (Flash + Interrupts → Issue 12.2)
- Common issue patterns
- Typical application dependency chains

**Context7 Use:** Understand peripheral ecosystems and dependencies

---

### **examples.yaml** ⭐ NEW
Complete catalog of 1,985 working example files:
- Example count and categories per peripheral
- Common use cases for each example
- Query patterns for finding examples
- Errata workarounds demonstrated in examples
- Quick start recommendations
- F403A vs F407 differences

**Context7 Use:** Find working code examples for any peripheral or use case

---

## 🎯 How Context7 Uses This

### 1. **Semantic Search Optimization**
The taxonomy enables Context7 to understand:
- **"Why does my CAN bus lose messages?"**
  → Maps to `issue_categories.yaml` → communication_failure
  → Cross-references `peripherals.yaml` → CAN
  → Finds `priority_levels.yaml` → High priority issue 2.1
  → Shows `examples.yaml` → can_communication_mode example

### 2. **Natural Language Understanding**
- **"System won't wake from deepsleep"**
  → `keywords.yaml` → wakeup_failure
  → `issue_categories.yaml` → wakeup_failure
  → `peripherals.yaml` → PWC peripheral
  → `priority_levels.yaml` → Issue 6.1 (high priority)
  → `examples.yaml` → deepsleep_rtc example

### 3. **Cross-Reference Resolution**
- **"ADC with DMA example"**
  → `peripherals.yaml` → ADC works_with DMA
  → `examples.yaml` → adc_dma category
  → Shows relationship to Issue 1.1
  → Provides working example path

### 4. **Dependency Discovery**
- **"What do I need for CAN?"**
  → `peripheral_relationships.yaml` → CAN depends_on
  → Shows CRM (clock), GPIO (pins), NVIC (interrupts)
  → Lists related issues (2.1-2.4)
  → Suggests initialization sequence

---

## 📊 Statistics

| Taxonomy File | Entries | Purpose |
|--------------|---------|---------|
| **peripherals.yaml** | 16 peripherals | Peripheral definitions |
| **issue_categories.yaml** | 12 error types | Error classification |
| **priority_levels.yaml** | 3 priority levels | Risk assessment |
| **keywords.yaml** | 200+ keywords | Search optimization |
| **peripheral_relationships.yaml** | 16 peripherals | Dependency mapping |
| **examples.yaml** | 1,985 examples | Code discovery |

**Total:** 6 taxonomy files covering all aspects of AT32F403A/407 documentation

---

## 🔍 Example Queries

### Query: "Flash erase causes exception"
**Context7 Resolution:**
1. `keywords.yaml` → "exception" → system_exception
2. `issue_categories.yaml` → system_exception → Flash peripheral
3. `peripherals.yaml` → Flash → errata_section 1.1.12
4. `priority_levels.yaml` → Issue 12.2 → High priority
5. `examples.yaml` → flash_write_read → Workaround demonstrated
6. **Answer:** "Issue 12.2 - Disable interrupts during NZW erase. See examples/flash/flash_write_read/"

### Query: "PWM motor control"
**Context7 Resolution:**
1. `keywords.yaml` → "PWM" → TMR peripheral
2. `peripherals.yaml` → TMR → common_uses: "pwm-generation", "motor control"
3. `examples.yaml` → TMR → pwm category → Multiple examples
4. **Answer:** "Use Timer PWM. Examples: tmr_pwm_output, tmr_complementary_signals (with deadtime for motor control)"

### Query: "Low power battery application"
**Context7 Resolution:**
1. `keywords.yaml` → "low power", "battery" → PWC peripheral
2. `peripherals.yaml` → PWC → common_uses: "battery-powered", "low-power-design"
3. `examples.yaml` → PWC → sleep_modes category
4. `priority_levels.yaml` → High priority issue 6.1 warning
5. **Answer:** "Use Deepsleep mode. Warning: Issue 6.1 - Remove AHB division. Example: deepsleep_rtc"

---

## 🚀 For Developers

### Using Taxonomy in Your Application

The taxonomy files are **YAML format** and can be:
- Parsed by any YAML library
- Used to build custom search tools
- Integrated into IDEs or documentation browsers
- Used for automated testing (check if all peripherals are covered)

### Extending the Taxonomy

To add new entries:
1. **New peripheral:** Add to `peripherals.yaml` with full metadata
2. **New error pattern:** Add to `issue_categories.yaml`
3. **New keywords:** Add to `keywords.yaml` for better search
4. **New relationships:** Update `peripheral_relationships.yaml`
5. **New examples:** Update `examples.yaml` with example details

---

## 📝 Maintenance

**Last Updated:** November 2024  
**Firmware Version:** v2.2.1  
**Optimization Level:** Context7-ready  

**Update Triggers:**
- New errata sheet version → Update priority_levels.yaml
- New examples added → Update examples.yaml
- New peripheral support → Update peripherals.yaml
- User feedback on search → Update keywords.yaml

---

## 🤝 Contributing

Improvements to taxonomy welcome:
- Better keyword mappings for search
- Additional peripheral relationships
- More granular example categories
- Better symptom-to-issue mappings

**Goal:** Make Context7 the best AI assistant for AT32F403A/407 development!

---

## 🔗 Related Documentation

- [Main README](../README.md) - Repository overview
- [Errata Sheet](../ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md) - All 41 issues
- [FAQ](../FAQ.md) - Common questions
- [Firmware Library](../AT32F403A_407_Firmware_Library/) - Drivers and examples

---

**Status:** ✅ Complete and production-ready for Context7  
**Impact:** Enables intelligent semantic search across 1,985 examples and 41 errata issues  
**Benefit:** Context7 can answer natural language questions with precise technical answers

