#!/usr/bin/env pwsh
# Verify a GitLab personal access token is present and valid (read-only).
#
# Windows (PowerShell) equivalent of verify-token.sh.
#
# Usage:
#   $env:GITLAB_PERSONAL_ACCESS_TOKEN = 'glpat-xxxxx'
#   .\verify-token.ps1

$ErrorActionPreference = 'Stop'

$Api = if ($env:GITLAB_API_URL) { $env:GITLAB_API_URL } else { 'https://gitlab.com/api/v4' }
$Token = $env:GITLAB_PERSONAL_ACCESS_TOKEN

if ([string]::IsNullOrEmpty($Token)) {
    Write-Host 'FAIL: GITLAB_PERSONAL_ACCESS_TOKEN is not set in the environment.'
    Write-Host 'Create one (scope: read_api) at:'
    Write-Host '  https://gitlab.com/-/user_settings/personal_access_tokens'
    exit 1
}

$Headers = @{ 'PRIVATE-TOKEN' = $Token }

Write-Host "Checking token against $Api/user ..."
try {
    $user = Invoke-RestMethod -Method Get -Uri "$Api/user" -Headers $Headers -TimeoutSec 15
} catch {
    $status = $null
    if ($_.Exception.Response) { $status = [int]$_.Exception.Response.StatusCode }
    if ($status -eq 401) {
        Write-Host 'FAIL: HTTP 401 Unauthorized - token is invalid, expired, or revoked.'
    } elseif ($status) {
        Write-Host "FAIL: unexpected HTTP $status."
    } else {
        Write-Host "FAIL: request error: $($_.Exception.Message)"
    }
    exit 1
}

Write-Host "OK: token is valid. Authenticated as: $($user.username)"

# Report token scopes if available.
Write-Host 'Checking token scopes ...'
try {
    $self = Invoke-RestMethod -Method Get -Uri "$Api/personal_access_tokens/self" -Headers $Headers -TimeoutSec 15
    $scopes = $self.scopes
    Write-Host "Token scopes: $($scopes -join ', ')"
    if ($scopes -contains 'api') {
        Write-Host "WARNING: token has full 'api' scope. 'read_api' is sufficient for this read-only Power."
    }
} catch {
    # Scope lookup is best-effort; ignore failures.
}

exit 0
