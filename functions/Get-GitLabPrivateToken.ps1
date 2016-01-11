<#
.SYNOPSIS
Tests to see if `$env:GitLabPrivateToken` is in the expected format.
.DESCRIPTION
The `$env:GitLabPrivateToken` variable is expected to be a SecureString.
.EXAMPLE
if (-not (Test-GitLabPrivateToken)) { Set-GitLabPrivateToken }
#>
function Get-GitLabPrivateToken {
    Write-Log '>'

    try {
        $SecureToken = ConvertTo-SecureString $env:GitLabPrivateToken
    } catch {
        Throw('Error getting $env:GitLabPrivateToken; run `Set-GitLabPrivateToken` to set it.')
    }
    
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureToken)
    return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}