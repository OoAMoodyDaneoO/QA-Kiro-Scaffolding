# ─────────────────────────────────────────────────────────────
# install.ps1 — Copy the Kiro QA Testing Toolkit into a project
#
# Usage:
#   .\install.ps1 -Target C:\path\to\your\project
#
# What it does:
#   1. Copies .kiro/ (agents, hooks, skills, steering)
#   2. Creates docs/test-reports/ with the audit log template
#   3. Optionally copies the SonarQube power
#
# It will NOT overwrite existing files — safe to re-run.
# ─────────────────────────────────────────────────────────────

param(
    [Parameter(Mandatory=$true)]
    [string]$Target
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Test-Path $Target -PathType Container)) {
    Write-Error "'$Target' is not a directory."
    exit 1
}

function Copy-IfMissing {
    param([string]$Src, [string]$Dest)
    if (Test-Path $Dest) {
        Write-Host "  SKIP  $Dest (already exists)"
    } else {
        $dir = Split-Path -Parent $Dest
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        Copy-Item $Src $Dest
        Write-Host "  COPY  $Dest"
    }
}

function Copy-DirIfMissing {
    param([string]$Src, [string]$Dest)
    if (Test-Path $Dest -PathType Container) {
        Write-Host "  SKIP  $Dest/ (already exists)"
    } else {
        $dir = Split-Path -Parent $Dest
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        Copy-Item -Recurse $Src $Dest
        Write-Host "  COPY  $Dest/"
    }
}

Write-Host ""
Write-Host "Installing Kiro QA Testing Toolkit into: $Target"
Write-Host "================================================="
Write-Host ""

# --- .kiro directory ---
Write-Host "[1/4] Agents"
Copy-IfMissing "$ScriptDir\.kiro\agents\qa-test-engineer.json"      "$Target\.kiro\agents\qa-test-engineer.json"
Copy-IfMissing "$ScriptDir\.kiro\agents\qa-test-engineer-prompt.md"  "$Target\.kiro\agents\qa-test-engineer-prompt.md"

Write-Host ""
Write-Host "[2/4] Hooks"
Copy-IfMissing "$ScriptDir\.kiro\hooks\auto-test-on-create.kiro.hook"    "$Target\.kiro\hooks\auto-test-on-create.kiro.hook"
Copy-IfMissing "$ScriptDir\.kiro\hooks\auto-test-on-edit.kiro.hook"      "$Target\.kiro\hooks\auto-test-on-edit.kiro.hook"
Copy-IfMissing "$ScriptDir\.kiro\hooks\test-coverage-report.kiro.hook"   "$Target\.kiro\hooks\test-coverage-report.kiro.hook"

Write-Host ""
Write-Host "[3/4] Skills & Steering"
Copy-DirIfMissing "$ScriptDir\.kiro\skills\write-unit-tests"       "$Target\.kiro\skills\write-unit-tests"
Copy-DirIfMissing "$ScriptDir\.kiro\skills\review-test-quality"    "$Target\.kiro\skills\review-test-quality"
Copy-DirIfMissing "$ScriptDir\.kiro\skills\fix-failing-tests"      "$Target\.kiro\skills\fix-failing-tests"
Copy-IfMissing "$ScriptDir\.kiro\steering\unit-testing-standards.md"   "$Target\.kiro\steering\unit-testing-standards.md"
Copy-IfMissing "$ScriptDir\.kiro\steering\test-bug-fixing-policy.md"   "$Target\.kiro\steering\test-bug-fixing-policy.md"
Copy-IfMissing "$ScriptDir\.kiro\steering\test-evidence-policy.md"     "$Target\.kiro\steering\test-evidence-policy.md"

Write-Host ""
Write-Host "[4/4] Test reports directory"
@("$Target\docs\test-reports\coverage", "$Target\docs\test-reports\gap-analysis") | ForEach-Object {
    if (-not (Test-Path $_)) { New-Item -ItemType Directory -Path $_ -Force | Out-Null }
}
Copy-IfMissing "$ScriptDir\docs\test-reports\audit-log.md" "$Target\docs\test-reports\audit-log.md"

Write-Host ""

# --- Optional: SonarQube power ---
$installSonar = Read-Host "Install SonarQube power? (y/N)"
if ($installSonar -match '^[Yy]$') {
    Write-Host ""
    Write-Host "[Optional] SonarQube Power"
    Copy-DirIfMissing "$ScriptDir\powers\sonarqube-testing" "$Target\powers\sonarqube-testing"
    Write-Host ""
    Write-Host "  Remember to edit powers/sonarqube-testing/mcp.json with your token and URL."
}

Write-Host ""
Write-Host "Done. Open the project in Kiro and the toolkit is active."
Write-Host ""
