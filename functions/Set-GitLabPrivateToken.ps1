<#
.SYNOPSIS
Set `$env:GitLabPrivateToken` for use in API connections.
.DESCRIPTION
Set the `$env:GitLabPrivateToken` variable as a SecureString; which is required by the set of functions.
.EXAMPLE
if (-not (Test-GitLabPrivateToken)) { Set-GitLabPrivateToken }
#>
function Set-GitLabPrivateToken {
    param (
        $Token = (Read-Host -AsSecureString "Enter your GitLab Private Token (${GitLabProtocol}://${GitLabDomain}/profile/account)"),
        $Permanent = (Read-Host 'Set permanently? [Y|n]')
    )
    Write-Log '>'

    if ($Token -is 'String') {
        $Token = ConvertTo-SecureString -String $Token -AsPlainText -Force
    }

    if ($Permanent -isNot 'Boolean') {
        $Permanent = if ($Permanent.Trim().ToLower().StartsWith('n')) { $false } else { $true }
    }

    $env:GitLabPrivateToken = ConvertFrom-SecureString $Token
    
    if ($Permanent) {
        [Environment]::SetEnvironmentVariable('GitLabPrivateToken', (ConvertFrom-SecureString $Token), 'User')
    }
}