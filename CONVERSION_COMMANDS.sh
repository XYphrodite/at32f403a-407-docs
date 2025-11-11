#!/bin/bash
# PDF-TO-MARKDOWN CONVERSION - COMMAND REFERENCE
# Copy-paste ready commands for each phase
# Tested on: Windows (Git Bash), Linux, macOS

# =============================================================================
# SETUP
# =============================================================================

# Install required Python packages
pip install PyMuPDF Pillow

# Create project structure
mkdir -p conversion/{images,archive,scripts}
cd conversion

# =============================================================================
# PHASE 1: EXTRACT & ASSESS
# =============================================================================

# Extract all text from PDF (PyMuPDF method)
python3 << 'EOF'
import fitz
doc = fitz.open('source.pdf')
with open('PDF_extracted_text.txt', 'w', encoding='utf-8') as f:
    for page_num in range(len(doc)):
        f.write(f'\n--- PAGE {page_num + 1} ---\n')
        f.write(doc[page_num].get_text())
print(f'✓ Extracted text from {len(doc)} pages')
doc.close()
EOF

# Extract all images from PDF
python3 << 'EOF'
import fitz
from PIL import Image
import io
import os

doc = fitz.open('source.pdf')
os.makedirs('images', exist_ok=True)
img_count = 0

for page_num in range(len(doc)):
    page = doc[page_num]
    images = page.get_images()
    
    for img_index, img in enumerate(images):
        xref = img[0]
        base_image = doc.extract_image(xref)
        image_bytes = base_image["image"]
        image_ext = base_image["ext"]
        
        image_path = f'images/page{page_num+1:03d}_img{img_index+1:02d}.{image_ext}'
        with open(image_path, 'wb') as f:
            f.write(image_bytes)
        img_count += 1

print(f'✓ Extracted {img_count} images')
doc.close()
EOF

# Count sections in PDF
grep -o "^[0-9]\+\.[0-9]\+" PDF_extracted_text.txt | sort -u | wc -l

# Create validation script
cat > scripts/compare_pdf_md.py << 'EOF'
#!/usr/bin/env python3
import sys

pdf_text_file = sys.argv[1] if len(sys.argv) > 1 else 'PDF_extracted_text.txt'
md_file = sys.argv[2] if len(sys.argv) > 2 else 'output.md'

with open(pdf_text_file, 'r', encoding='utf-8') as f:
    pdf_text = f.read().upper()

with open(md_file, 'r', encoding='utf-8') as f:
    md_text = f.read().upper()

# Define sections to check
sections = []  # Add your section names here

print("\nCONVERSION VALIDATION REPORT")
print("=" * 50)

found = sum(1 for s in sections if s.upper() in md_text)
total = len(sections)
percentage = (found / total * 100) if total > 0 else 0

print(f"Completion: {found}/{total} sections ({percentage:.1f}%)")
print("\nSection Status:")

for section in sections:
    in_pdf = section.upper() in pdf_text
    in_md = section.upper() in md_text
    status = "[OK]" if (in_pdf and in_md) else "[!!]"
    print(f"{status} {section}: PDF={'Yes' if in_pdf else 'No'}, MD={'Yes' if in_md else 'No'}")

print("=" * 50)
EOF

chmod +x scripts/compare_pdf_md.py

# Run validation
python3 scripts/compare_pdf_md.py

# =============================================================================
# PHASE 2: SYSTEMATIC CONVERSION
# =============================================================================

# Create initial Markdown structure
cat > output.md << 'EOF'
# [DOCUMENT TITLE]

## CONVERSION STATUS & TODO

**Current Completion:** 0% (0 out of X sections)

### ☐ Pending Sections
- ☐ Section 1: [Name]
- ☐ Section 2: [Name]

### ✅ Completed Sections
(none yet)

---

# [BEGIN MAIN CONTENT]

EOF

# Git initialization and first commit
git init
git add output.md PDF_extracted_text.txt
git commit -m "docs: initial structure and extracted text"

# After converting 2-3 sections
git add output.md
git commit -m "docs: add sections X, Y, Z - 25% completion"

# =============================================================================
# PHASE 3: IMAGE OPTIMIZATION
# =============================================================================

# Analyze all extracted images
cat > scripts/analyze_images.py << 'EOF'
#!/usr/bin/env python3
import os
import json
from PIL import Image

results = []
images_dir = 'images'

for filename in os.listdir(images_dir):
    if not filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
        continue
    
    filepath = os.path.join(images_dir, filename)
    img = Image.open(filepath)
    width, height = img.size
    size_kb = os.path.getsize(filepath) / 1024
    aspect = width / height if height > 0 else 0
    
    # Categorize
    if size_kb < 50 and 0.8 < aspect < 1.2:
        category = "LOGO_ICON"
    elif height < 50 or (width > 800 and height < 100):
        category = "HEADER_FOOTER"
    elif width > 200 and height > 150 and 0.5 < aspect < 2.0:
        category = "DIAGRAM"
    else:
        category = "UNKNOWN"
    
    results.append({
        "file": filename,
        "width": width,
        "height": height,
        "size_kb": round(size_kb, 2),
        "aspect": round(aspect, 2),
        "category": category
    })

# Save results
with open('image_analysis_results.json', 'w') as f:
    json.dump(results, f, indent=2)

# Print summary
categories = {}
for r in results:
    cat = r['category']
    categories[cat] = categories.get(cat, 0) + 1

print("\nIMAGE ANALYSIS SUMMARY")
print("=" * 50)
for cat, count in sorted(categories.items()):
    print(f"{cat}: {count}")
print(f"TOTAL: {len(results)}")
print("\nRecommendation: Keep DIAGRAM and 1-2 LOGO_ICON, archive rest")
print("=" * 50)
EOF

chmod +x scripts/analyze_images.py
python3 scripts/analyze_images.py

# View diagrams only
cat image_analysis_results.json | grep -A 6 '"category": "DIAGRAM"'

# Cleanup unused images
cat > scripts/cleanup_unused_images.py << 'EOF'
#!/usr/bin/env python3
import os
import shutil
import re

md_file = 'output.md'
images_dir = 'images'
archive_dir = 'archive/unused_images'

# Get all images referenced in Markdown
with open(md_file, 'r') as f:
    md_content = f.read()

referenced = re.findall(r'!\[.*?\]\((images/[^\)]+)\)', md_content)
referenced = [os.path.basename(r) for r in referenced]

# Move unused images
os.makedirs(archive_dir, exist_ok=True)
moved = 0

for filename in os.listdir(images_dir):
    if filename not in referenced and filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
        src = os.path.join(images_dir, filename)
        dst = os.path.join(archive_dir, filename)
        shutil.move(src, dst)
        moved += 1

print(f"\n✓ Moved {moved} unused images to {archive_dir}")
print(f"✓ Kept {len(referenced)} referenced images")
EOF

chmod +x scripts/cleanup_unused_images.py
python3 scripts/cleanup_unused_images.py

# =============================================================================
# PHASE 4: VISUAL ENHANCEMENT
# =============================================================================

# Mermaid diagram templates

# Flowchart
cat >> output.md << 'EOF'
```mermaid
graph TD
    A[Start] --> B{Decision Point}
    B -->|Option 1| C[Action A]
    B -->|Option 2| D[Action B]
    C --> E[End]
    D --> E
```
EOF

# State diagram
cat >> output.md << 'EOF'
```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Active : Start
    Active --> Processing : Process
    Processing --> Complete : Finish
    Complete --> [*]
```
EOF

# Pie chart
cat >> output.md << 'EOF'
```mermaid
pie title Distribution
    "Category A" : 45
    "Category B" : 30
    "Category C" : 25
```
EOF

# =============================================================================
# PHASE 5: REPOSITORY OPTIMIZATION
# =============================================================================

# Create README
cat > README.md << 'EOF'
# [Project Name]

> [Brief description of what this documentation covers]

## 📚 Overview

[Detailed description]

## ✨ Features

- ✅ Complete coverage of [X] topics
- ✅ [Y] code examples
- ✅ Visual diagrams and flowcharts
- ✅ Quick reference tables

## 🚀 Quick Start

[How to use this documentation]

## 📖 Contents

- [Section 1](#section-1)
- [Section 2](#section-2)

## 📝 License

[Your License] - Original content © [Source]
EOF

# Create LICENSE (MIT example)
cat > LICENSE << 'EOF'
MIT License

Copyright (c) [YEAR] [AUTHOR]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# Create CONTRIBUTING.md
cat > CONTRIBUTING.md << 'EOF'
# Contributing Guidelines

Thank you for considering contributing to this documentation!

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b improve-section-x`)
3. Make your changes
4. Test that Markdown renders correctly
5. Commit with descriptive message (`git commit -m "docs: improve section X"`)
6. Push to your fork (`git push origin improve-section-x`)
7. Open a Pull Request

## Guidelines

- Follow existing Markdown style
- Test Mermaid diagrams render on GitHub
- Keep code examples concise and correct
- Update table of contents if adding sections
- Check spelling and grammar

## Questions?

Open an issue and we'll help!
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# OS Files
.DS_Store
Thumbs.db
desktop.ini

# Editor Files
.vscode/
.idea/
*.swp
*.swo
*~

# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
*.egg-info/

# Logs
*.log

# Temporary Files
*.tmp
.cache/
EOF

# Organize development artifacts
mkdir -p archive/{scripts,reports,extracted_images}
mv scripts/* archive/scripts/
mv image_analysis_results.json archive/reports/
mv PDF_extracted_text.txt archive/

# Create archive README
cat > archive/README.md << 'EOF'
# Development Archive

This folder contains tools and artifacts from the PDF-to-Markdown conversion process.

## Contents

- **scripts/**: Python scripts used for conversion
- **reports/**: Analysis and validation reports
- **extracted_images/**: All images extracted from source PDF

## Tools

- `compare_pdf_md.py`: Validates conversion completeness
- `analyze_images.py`: Categorizes extracted images
- `cleanup_unused_images.py`: Identifies unused images

These tools can be reused for future conversions or updates.
EOF

# Final commit
git add -A
git commit -m "docs: complete repository structure and optimization"

# =============================================================================
# PHASE 6: DEPLOYMENT
# =============================================================================

# Create push script (PowerShell for Windows)
cat > push_to_github.ps1 << 'EOF'
param(
    [Parameter(Mandatory=$true)]
    [string]$GithubUsername,
    
    [Parameter(Mandatory=$true)]
    [string]$RepoName
)

$remoteUrl = "https://github.com/$GithubUsername/$RepoName.git"

Write-Host "Pushing to $remoteUrl..."

git remote add origin $remoteUrl 2>$null
if ($LASTEXITCODE -ne 0) {
    git remote set-url origin $remoteUrl
}

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "URL: https://github.com/$GithubUsername/$RepoName"
} else {
    Write-Host "✗ Push failed" -ForegroundColor Red
}
EOF

# Create push script (Bash for Linux/macOS)
cat > push_to_github.sh << 'EOF'
#!/bin/bash
GITHUB_USERNAME=$1
REPO_NAME=$2

if [ -z "$GITHUB_USERNAME" ] || [ -z "$REPO_NAME" ]; then
    echo "Usage: ./push_to_github.sh <username> <repo-name>"
    exit 1
fi

REMOTE_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

echo "Pushing to $REMOTE_URL..."

git remote add origin $REMOTE_URL 2>/dev/null || git remote set-url origin $REMOTE_URL
git push -u origin main

if [ $? -eq 0 ]; then
    echo "✓ Successfully pushed to GitHub!"
    echo "URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
else
    echo "✗ Push failed"
    exit 1
fi
EOF

chmod +x push_to_github.sh

# Run validation one final time
python3 archive/scripts/compare_pdf_md.py archive/PDF_extracted_text.txt output.md

# Check repository size
du -sh .
du -sh images/

# List all commits
git log --oneline --all --graph

# =============================================================================
# VERIFICATION COMMANDS
# =============================================================================

# Verify all internal links work
grep -o '\[.*\](#.*)'output.md | sed 's/.*(\(#.*\))/\1/' | while read anchor; do
    if ! grep -q "$anchor" output.md; then
        echo "Broken link: $anchor"
    fi
done

# Count code blocks
grep -c '```' output.md

# Count Mermaid diagrams
grep -c '```mermaid' output.md

# Count images
grep -c '!\[' output.md

# Check Markdown syntax (requires markdownlint)
# npm install -g markdownlint-cli
markdownlint output.md README.md CONTRIBUTING.md

# Preview on GitHub (open in browser)
# Requires 'gh' CLI: brew install gh
gh repo view --web

# =============================================================================
# QUICK STATS
# =============================================================================

echo "
CONVERSION STATISTICS
=====================
Lines in main document:  $(wc -l < output.md)
Sections completed:      $(grep -c '^##' output.md)
Code blocks:             $(grep -c '^\`\`\`' output.md)
Mermaid diagrams:        $(grep -c '^\`\`\`mermaid' output.md)
Images embedded:         $(grep -c '!\[' output.md)
Total commits:           $(git rev-list --count HEAD)
Repository size:         $(du -sh . | cut -f1)
"

# =============================================================================
# END
# =============================================================================

echo "
✓ All commands executed successfully!

Next steps:
1. Review output.md
2. Test Mermaid diagrams on GitHub
3. Push to GitHub: ./push_to_github.sh YOUR_USERNAME REPO_NAME
4. Share with the world!
"

