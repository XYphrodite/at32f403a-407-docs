# Push at32f403a-407-docs to GitHub
# Run this after creating the GitHub repository

param(
    [Parameter(Mandatory=$true)]
    [string]$GithubUsername
)

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Push Docs to GitHub" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Construct the remote URL
$remoteUrl = "https://github.com/$GithubUsername/at32f403a-407-docs.git"

Write-Host "[1/3] Setting remote origin..." -ForegroundColor Yellow
Write-Host "      URL: $remoteUrl" -ForegroundColor Gray

try {
    # Try to add remote
    git remote add origin $remoteUrl 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "      Remote 'origin' already exists, updating..." -ForegroundColor Gray
        git remote set-url origin $remoteUrl
    }
} catch {
    Write-Host "      Error setting remote: $_" -ForegroundColor Red
    exit 1
}

Write-Host "      [OK] Remote configured" -ForegroundColor Green
Write-Host ""

Write-Host "[2/3] Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "      This may prompt for GitHub credentials" -ForegroundColor Gray

try {
    git push -u origin main
    if ($LASTEXITCODE -ne 0) {
        Write-Host "      [ERROR] Push failed" -ForegroundColor Red
        Write-Host ""
        Write-Host "Common issues:" -ForegroundColor Yellow
        Write-Host "  - Repository not created on GitHub yet" -ForegroundColor Gray
        Write-Host "  - Authentication failed (check credentials)" -ForegroundColor Gray
        Write-Host "  - Username is incorrect" -ForegroundColor Gray
        exit 1
    }
} catch {
    Write-Host "      [ERROR] Push failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "      [OK] Pushed successfully" -ForegroundColor Green
Write-Host ""

Write-Host "[3/3] Verifying..." -ForegroundColor Yellow
git remote -v

Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "SUCCESS!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "Repository URL:" -ForegroundColor Cyan
Write-Host "  https://github.com/$GithubUsername/at32f403a-407-docs" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Visit the URL above to verify" -ForegroundColor Gray
Write-Host "  2. Configure repository settings (topics, description)" -ForegroundColor Gray
Write-Host "  3. Run: ..\3_ADD_AS_SUBMODULE.ps1 -GithubUsername $GithubUsername" -ForegroundColor Gray
Write-Host ""

