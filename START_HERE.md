# 🚀 START HERE - Complete Setup in 3 Steps

This guide will help you push this documentation to GitHub and add it as a submodule to TafcoMcuCore.

---

## ⚡ Quick Setup (5 minutes)

### **Step 1: Create GitHub Repository** (Manual - 2 minutes)

1. **Open:** [1_CREATE_GITHUB_REPO.md](1_CREATE_GITHUB_REPO.md)
2. **Follow** the instructions (just copy-paste settings)
3. **Click** "Create repository" on GitHub

---

### **Step 2: Push to GitHub** (Automated - 1 minute)

**Open PowerShell in this folder** and run:

```powershell
# Navigate to this folder
cd D:\Repos\TafcoPigstore\TafcoMcuCore\Docs

# Run script (REPLACE with your GitHub username!)
.\2_PUSH_TO_GITHUB.ps1 -GithubUsername YOUR-USERNAME
```

**Example:**
```powershell
.\2_PUSH_TO_GITHUB.ps1 -GithubUsername XYphrodite
```

**What it does:**
- ✅ Configures git remote
- ✅ Pushes all commits to GitHub
- ✅ Verifies the push succeeded

---

### **Step 3: Add as Submodule** (Automated - 1 minute)

**Open PowerShell in TafcoMcuCore root** and run:

```powershell
# Navigate to TafcoMcuCore root
cd D:\Repos\TafcoPigstore\TafcoMcuCore

# Run script (REPLACE with your GitHub username!)
.\3_ADD_AS_SUBMODULE.ps1 -GithubUsername YOUR-USERNAME
```

**Example:**
```powershell
.\3_ADD_AS_SUBMODULE.ps1 -GithubUsername XYphrodite
```

**What it does:**
- ✅ Removes current Docs folder
- ✅ Adds GitHub repo as submodule
- ✅ Commits the submodule to TafcoMcuCore
- ✅ Ready to push

---

### **Step 4: Push TafcoMcuCore** (Final step)

```powershell
# Still in TafcoMcuCore root
git push origin main
```

---

## ✅ **Done!**

Your documentation is now:
- ✅ On GitHub as `at32f403a-407-docs`
- ✅ Linked to TafcoMcuCore as a submodule
- ✅ Context7-ready
- ✅ Community-accessible

---

## 🆘 **Troubleshooting**

### PowerShell Won't Run Scripts

If you see: `execution of scripts is disabled on this system`

Run this **once** in PowerShell (as Administrator):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Authentication Failed

GitHub may ask for credentials:
- **Username:** Your GitHub username
- **Password:** Use a **Personal Access Token** (not your password!)
  - Create at: https://github.com/settings/tokens
  - Select scope: `repo`

### Script Errors

Check:
1. You're in the correct directory
2. GitHub repository was created (Step 1)
3. Your username is spelled correctly
4. Repository is public (not private)

---

## 📊 **What's Happening Behind the Scenes**

### Step 1 (Manual):
Creates empty GitHub repository `at32f403a-407-docs`

### Step 2 (Script):
```bash
git remote add origin https://github.com/YOUR-USERNAME/at32f403a-407-docs.git
git push -u origin main
```

### Step 3 (Script):
```bash
cd TafcoMcuCore
Remove-Item -Recurse Docs
git submodule add https://github.com/YOUR-USERNAME/at32f403a-407-docs.git Docs
git commit -m "chore: convert Docs to submodule"
```

---

## 🎯 **Alternative: Manual Commands**

If you prefer not to use scripts, see:
- [PUSH_TO_GITHUB.md](PUSH_TO_GITHUB.md) - Manual git commands
- [../ADD_DOCS_AS_SUBMODULE.md](../ADD_DOCS_AS_SUBMODULE.md) - Full workflow

---

## 🔍 **Verification**

After completing all steps:

1. **Check GitHub:** Visit `https://github.com/YOUR-USERNAME/at32f403a-407-docs`
2. **Check Submodule:** 
   ```powershell
   cd D:\Repos\TafcoPigstore\TafcoMcuCore
   git submodule status
   ```
3. **Check Files:**
   ```powershell
   cd Docs
   ls
   # Should show all doc files
   ```

---

## 🎉 **Success Indicators**

You'll know it worked when:
- ✅ GitHub repository shows all files
- ✅ README displays with badges
- ✅ Mermaid diagrams render
- ✅ TafcoMcuCore has `.gitmodules` file
- ✅ `Docs/` folder is now a submodule

---

**Questions?** Open an issue on GitHub after setup!

**Ready?** Start with [1_CREATE_GITHUB_REPO.md](1_CREATE_GITHUB_REPO.md)!

