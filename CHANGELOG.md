# Changelog

All notable changes to the AT32F403A/407 documentation.

## [Unreleased]

## [2.0.11] - 2024-11-13
### Added - Phase 1: Errata Conversion
- Complete errata sheet ES0002 v2.0.11 conversion (41/41 issues)
- Context7 integration documentation
- README for MCU documentation repository
- 4 Mermaid diagrams (CAN flowchart, Flash layout, PWC state machine, Revision pie chart)
- 15+ code examples with workarounds
- Quick reference table for all issues
- Development checklists (Flash, CAN, PWC)

### Added - Phase 2: Context7 Optimization
- **Firmware Library v2.2.1** - 1,985 working example files (937 F403A + 1,048 F407)
- **Taxonomy System** - 6 YAML files for AI semantic search:
  - peripherals.yaml (16 peripherals with metadata)
  - issue_categories.yaml (12 error classifications)
  - priority_levels.yaml (risk assessment matrix)
  - keywords.yaml (200+ search terms)
  - peripheral_relationships.yaml (dependency mapping)
  - examples.yaml (complete example catalog)
- **FAQ.md** - 10 AI-optimized questions with tags and quick answers
- **docs/README.md** - Taxonomy system documentation
- **YAML Frontmatter** - Added to README.md and Errata Sheet for AI parsing
- **AT32F403A_407_Firmware_Library/** - Context7-optimized library (93% size reduction)
  - Peripheral drivers (26 headers + 25 implementations)
  - CMSIS support (ARM Cortex-M4 core)
  - Board support package
  - Documentation PDFs (BSP guide, release notes)
  - Example HTML indexes (F403A and F407)

### Documentation
- Errata Sheet: ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.11.md (1,401 lines)
- README: Complete with Context7 integration guide (496 lines)
- FAQ: 10 common questions (269 lines)
- Taxonomy: 6 YAML files in docs/taxonomy/
- Firmware Library: README_CONTEXT7.md (247 lines)
- Images: 3 technical diagrams

### Optimization
- **Size Reduction:** Firmware library filtered from 100MB to ~12MB (88% reduction)
- **File Optimization:** 1,985 example files (.c, .h, .txt only - no IDE bloat)
- **AI Optimization:** YAML metadata, semantic tags, keyword mappings

### Devices Covered
- AT32F403A Series (all variants)
- AT32F407 Series (all variants)
- Revision A and Revision B

## [1.0.0] - 2024-11-10
### Added
- Initial repository setup
- License and attribution

