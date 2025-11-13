# Frequently Asked Questions (FAQ)
## AT32F403A/407 MCU Documentation

**For Context7:** Optimized for semantic search and quick retrieval

---

## 🔥 Top 10 Most Common Questions

### 1. What are the critical issues I must address?

**Tags:** #critical #high-priority #must-fix  
**Quick Answer:** 7 high-priority issues, mainly in CAN (2), Flash (3), PWC (2)

**Critical Issues:**
1. **Flash sLib Placement** (12.1) - Program crashes
2. **Flash NZW Erase** (12.2) - System exception
3. **Flash SPIM Erase** (12.3) - Read errors
4. **CAN Reception Failure** (2.1) - Lost messages
5. **CAN Data Disorder** (2.1) - Corrupted data
6. **PWC Deepsleep Wakeup** (6.1) - Cannot wake
7. **ADC Dual Mode Stuck** (1.1) - System hang

**Reference:** [Critical Issues Section](README.md#critical-issues-must-address)

---

### 2. Why does my CAN bus lose messages?

**Tags:** #CAN #message-loss #reception-error  
**Quick Answer:** Issue 2.1 - Bit stuffing error during retransmission

**Problem:** Receive mailbox data disorder during CAN retransmission with bit stuffing error

**Impact:** 🔴 HIGH - Production system failure

**Workarounds:**
- **Method 1:** Mailbox Priority (simple)
- **Method 2:** Lock/Unlock (recommended) ✅
- **Method 3:** Software Filter (flexible)

**Code:** [CAN Issue 2.1](ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md#21-can-reception-failure)

---

### 3. Can I use AT32F403A/407 in production?

**Tags:** #production #reliability #quality  
**Quick Answer:** YES, with workarounds implemented for known issues

**Details:**
- 41 known issues, 39 have workarounds (95%)
- Revision B fixes 16 issues (39%)
- All critical issues have working solutions
- Widely used in automotive, industrial applications

**Recommendation:**
- Use Revision B for new designs
- Implement all high-priority workarounds
- Test thoroughly with your specific use case

---

### 4. What's the difference between Revision A and B?

**Tags:** #revision #hardware-revision #updates  
**Quick Answer:** Revision B fixes 16 of 41 issues (39%)

**Fixed in Revision B:**
- ADC: 3/3 issues ✅
- I2C: 2/4 issues
- I2S: 2/5 issues
- PWC: 2/4 issues
- USB: 2/2 issues ✅
- Others: Various peripheral fixes

**NOT Fixed in Revision B:**
- All Flash issues (4) ⚠️
- CAN reception failure ⚠️
- Some TMR, I2S, PWC issues

**Reference:** [Revision Status](README.md#revision-status)

---

### 5. Is AT32F403A/407 compatible with STM32F4?

**Tags:** #compatibility #STM32 #migration #pin-compatible  
**Quick Answer:** Mostly compatible, with some register naming differences

**Compatible:**
- ✅ Pin layout (drop-in replacement)
- ✅ ARM Cortex-M4F core
- ✅ Peripheral functionality
- ✅ Development tools (OpenOCD, GDB)

**Differences:**
- ❌ Register names (RCC → CRM)
- ❌ SDK/HAL libraries (not STM32 HAL)
- ⚠️ Some peripheral timing differences
- ⚠️ AT32-specific errata issues

**Migration:** See STM32 migration guide (coming soon)

---

### 6. Why can't I wake up from Deepsleep mode?

**Tags:** #power-management #deepsleep #wakeup-failure  
**Quick Answer:** Issue 6.1 - AHB frequency division prevents wakeup

**Problem:** Cannot wake from Deepsleep if AHB frequency division is set

**Solution:**
```c
// Before entering Deepsleep
crm_ahb_div_set(CRM_AHB_DIV_1);  // Remove AHB division

// Enter Deepsleep
pwc_deep_sleep_mode_enter(PWC_DEEP_SLEEP_ENTER_WFI);
```

**Also Check:**
- Disable Systick before Deepsleep (Issue 6.2)
- Set CLKOUT to NOCLK (Issue 7.1)
- Configure GPIO properly (Issue 6.4)

**Reference:** [PWC Issues](ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md#116-pwc)

---

### 7. How do I safely erase Flash NZW area?

**Tags:** #flash #erase #NZW #exception  
**Quick Answer:** Issue 12.2 - Disable interrupts, run erase from ZW/RAM

**Problem:** System exception during Flash NZW area erase

**Solution:**
```c
// Disable interrupts
__disable_irq();

// Perform erase
flash_sector_erase(address);  // Must execute from ZW or RAM

// Wait for completion
while(flash_flag_get(FLASH_OBF_FLAG) != RESET);

// Re-enable interrupts
__enable_irq();
```

**Important:**
- Place erase code in Zero-Wait (ZW) area
- OR execute from RAM
- Disable ALL interrupts during erase
- Don't read from NZW during erase

**Reference:** [Flash Issue 12.2](ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md#1122-flash-nzw-erase)

---

### 8. Where can I find code examples?

**Tags:** #code-examples #samples #getting-started  
**Quick Answer:** 15+ examples in errata sheet, more in firmware library

**In This Repository:**
- Errata sheet: 15+ workaround examples
- CAN: 3 different reception workaround methods
- Flash: Safe erase procedures
- PWC: Deepsleep entry/exit
- ADC: Dual mode protection

**Firmware Library:**
- Location: `AT32F403A_407_Firmware_Library/`
- Examples: `project/at_start_f403a/examples/`
- Drivers: `libraries/drivers/`

**Coming Soon:**
- `CODE_EXAMPLES/` directory with 30+ examples
- Peripheral-specific example collections

---

### 9. What tools do I need for development?

**Tags:** #development #tools #IDE #compiler  
**Quick Answer:** ARM GCC + any IDE (Keil, IAR, VS Code, Eclipse)

**Compilers:**
- ARM GCC (free, recommended)
- Keil MDK-ARM
- IAR EWARM

**IDEs:**
- VS Code + PlatformIO
- Eclipse + GNU ARM Plugin
- Keil μVision
- IAR Embedded Workbench

**Debug Tools:**
- JTAG/SWD debugger (ST-Link, J-Link)
- OpenOCD (free, open source)
- GDB server

**SDK:**
- AT32 Firmware Library (in this repo)
- CMSIS support included

---

### 10. How do I report issues or contribute?

**Tags:** #contribute #issues #community  
**Quick Answer:** GitHub Issues for bugs, PRs for improvements

**Report Issues:**
1. Open GitHub Issue
2. Include: MCU variant, revision, issue description
3. Add code example if applicable
4. Reference errata section if related

**Contribute:**
1. Fork repository
2. Add improvements (examples, docs, fixes)
3. Follow CONTRIBUTING_CONTEXT7.md guidelines
4. Submit Pull Request

**For Context7 Developers:**
- See CONTRIBUTING_CONTEXT7.md
- Follow metadata requirements
- Use semantic chunking guidelines

---

## 📑 By Topic

### CAN Bus
- [Why does my CAN bus lose messages?](#2-why-does-my-can-bus-lose-messages)
- [CAN filter not working?](#) (coming soon)
- [CAN bus-off recovery?](#) (coming soon)

### Flash Memory
- [How do I safely erase Flash NZW area?](#7-how-do-i-safely-erase-flash-nzw-area)
- [sLib placement restrictions?](#) (coming soon)
- [SPIM Flash erase issues?](#) (coming soon)

### Power Management
- [Why can't I wake up from Deepsleep?](#6-why-cant-i-wake-up-from-deepsleep-mode)
- [Low power mode best practices?](#) (coming soon)

### General
- [What are the critical issues?](#1-what-are-the-critical-issues-i-must-address)
- [Revision A vs B differences?](#4-whats-the-difference-between-revision-a-and-b)
- [STM32 compatibility?](#5-is-at32f403a407-compatible-with-stm32f4)
- [Production readiness?](#3-can-i-use-at32f403a407-in-production)
- [Where are code examples?](#8-where-can-i-find-code-examples)
- [Development tools?](#9-what-tools-do-i-need-for-development)
- [How to contribute?](#10-how-do-i-report-issues-or-contribute)

---

**Status:** Initial 10 questions complete  
**Target:** 75+ questions  
**Next Update:** Add 10 peripheral-specific questions per major peripheral

