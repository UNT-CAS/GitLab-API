<#
.SYNOPSIS
Tests to see if `$env:GitLabPrivateToken` is in the expected format.
.DESCRIPTION
The `$env:GitLabPrivateToken` variable is expected to be a SecureString.
.EXAMPLE
if (-not (Test-GitLabPrivateToken)) { Set-GitLabPrivateToken }
#>
function Test-GitLabPrivateToken {
    Write-Log '>'
    try {
        Write-Log "Testing: env:GitLabPrivateToken: $($env:GitLabPrivateToken | Out-String)"
        $SecureToken = ConvertTo-SecureString $env:GitLabPrivateToken
        Write-Log "< $true"
        return $true
    } catch {
        Write-Log "< $false"
        return $false
    }
}