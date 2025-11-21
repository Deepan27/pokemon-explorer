# Pokemon Explorer - Push to GitHub Script
# Run this script after creating your GitHub repository

Write-Host "=== Pokemon Explorer - GitHub Upload ===" -ForegroundColor Cyan
Write-Host ""

# Get GitHub username
$username = Read-Host "Enter your GitHub username"

# Get repository name (default: pokemon-explorer)
$repoName = Read-Host "Enter repository name (press Enter for 'pokemon-explorer')"
if ([string]::IsNullOrWhiteSpace($repoName)) {
    $repoName = "pokemon-explorer"
}

Write-Host ""
Write-Host "Repository URL will be: https://github.com/$username/$repoName" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Have you created this repository on GitHub? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host ""
    Write-Host "Please create the repository first:" -ForegroundColor Red
    Write-Host "1. Go to https://github.com/new" -ForegroundColor Yellow
    Write-Host "2. Repository name: $repoName" -ForegroundColor Yellow
    Write-Host "3. Description: A production-quality Flutter app with offline support" -ForegroundColor Yellow
    Write-Host "4. Choose Private or Public" -ForegroundColor Yellow
    Write-Host "5. DO NOT initialize with README, .gitignore, or license" -ForegroundColor Yellow
    Write-Host "6. Click 'Create repository'" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Then run this script again!" -ForegroundColor Green
    exit
}

Write-Host ""
Write-Host "Configuring git..." -ForegroundColor Green

# Configure git (if not already configured)
$gitUser = git config --global user.name
if ([string]::IsNullOrWhiteSpace($gitUser)) {
    $name = Read-Host "Enter your name for git commits"
    git config --global user.name "$name"
}

$gitEmail = git config --global user.email
if ([string]::IsNullOrWhiteSpace($gitEmail)) {
    $email = Read-Host "Enter your email for git commits"
    git config --global user.email "$email"
}

Write-Host ""
Write-Host "Adding remote repository..." -ForegroundColor Green
git remote remove origin 2>$null  # Remove if exists
git remote add origin "https://github.com/$username/$repoName.git"

Write-Host "Setting branch to main..." -ForegroundColor Green
git branch -M main

Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Green
Write-Host "You may be prompted for authentication." -ForegroundColor Yellow
Write-Host ""

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== SUCCESS! ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your repository is now live at:" -ForegroundColor Cyan
    Write-Host "https://github.com/$username/$repoName" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Share this link with your supervisor!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "=== PUSH FAILED ===" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "1. Authentication failed - You may need a Personal Access Token" -ForegroundColor White
    Write-Host "   Create one at: https://github.com/settings/tokens" -ForegroundColor White
    Write-Host "   Use the token as your password when prompted" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Repository doesn't exist - Make sure you created it on GitHub first" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Try GitHub Desktop instead:" -ForegroundColor White
    Write-Host "   Download from: https://desktop.github.com/" -ForegroundColor White
    Write-Host ""
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
