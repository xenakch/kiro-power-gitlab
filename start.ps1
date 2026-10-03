#!/usr/bin/env pwsh
# Launch Kiro with the GitLab token loaded from this repo's .env (Option 3).
#
# Windows (PowerShell) equivalent of start.sh.
#
# This script contains NO secret. It loads the git-ignored .env so the
# GITLAB_PERSONAL_ACCESS_TOKEN is set in the environment only for the
# Kiro process it launches. The token never leaves .env.
#
# Usage:
#   .\start.ps1                 # starts `kiro-cli chat`
#   .\start.ps1 <args...>       # passes extra args through to kiro-cli

$ErrorActionPreference = 'Stop'

# Resolve this script's directory so it works from any working directory.
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Env file location. Set GITLAB_ENV_FILE to keep the token outside the repo;
# otherwise fall back to the repo-local .env (default behavior).
$EnvFile = if ($env:GITLAB_ENV_FILE) { $env:GITLAB_ENV_FILE } else { Join-Path $ScriptDir '.env' }

if (-not (Test-Path -LiteralPath $EnvFile)) {
    if ($env:GITLAB_ENV_FILE) {
        Write-Error "ERROR: $EnvFile not found. GITLAB_ENV_FILE points to a file that does not exist."
    } else {
        Write-Error "ERROR: $EnvFile not found. Copy .env.example to .env and set GITLAB_PERSONAL_ACCESS_TOKEN, or set GITLAB_ENV_FILE to an .env outside the repo."
    }
    exit 1
}

# Load variables from .env into this process's environment.
# Skips blank lines and comments; splits on the first '=' only.
Get-Content -LiteralPath $EnvFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -eq '' -or $line.StartsWith('#')) { return }
    if ($line -notmatch '=') { return }
    $parts = $line -split '=', 2
    $key = $parts[0].Trim()
    $value = $parts[1].Trim()
    # Strip surrounding single or double quotes if present.
    if ($value.Length -ge 2) {
        if (($value.StartsWith('"') -and $value.EndsWith('"')) -or
            ($value.StartsWith("'") -and $value.EndsWith("'"))) {
            $value = $value.Substring(1, $value.Length - 2)
        }
    }
    Set-Item -Path "Env:$key" -Value $value
}

if ([string]::IsNullOrEmpty($env:GITLAB_PERSONAL_ACCESS_TOKEN)) {
    Write-Error "ERROR: GITLAB_PERSONAL_ACCESS_TOKEN is empty in $EnvFile."
    exit 1
}

# Launch Kiro. Default to `chat` when no args are given.
if ($args.Count -eq 0) {
    & kiro-cli chat
} else {
    & kiro-cli @args
}
exit $LASTEXITCODE
