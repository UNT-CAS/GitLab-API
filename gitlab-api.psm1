<#
.SYNOPSIS
GitLab API handler
.DESCRIPTION
PowerShell functions to easily interact with the GitLab API. When importing the module, you should supply the GitLabPrivateToken. Include any non-default parameters as well.

Alternatively, all parameters can be sotred in $env:GitLabApi (See Examples); which will overwrite any supplied parameters.

Write-Log (https://github.com/UNT-CAS-ITS/Write-Log) is supported. If $env:Write-Log is not set, all log output will got to Write-Debug instead.
.PARAMETER GitLabProtocol
The API protocol. ie: http, https
.PARAMETER GitLabDomain
The domain name of the GitLab server. More info: https://gitlab.com/help/api/README.md#introduction
.PARAMETER GitLabApiVersion
The API version as defined 'lib/api.rb'. More info: https://gitlab.com/help/api/README.md#introduction
.PARAMETER GitLabPrivateToken
The Private Token provides the required authentication. More info: https://gitlab.com/help/api/README.md#introduction

If the GitLabPrivateToken parameter is not supplied, $env:GitLabPrivateToken is audited with the `Test-GitLabPrivateToken` function to see if a valid SecureString is stored. If one does not exist as an Environment Variable, the user will be prompted to supply one.

If module is used in scripts, you should pass the GitLabPrivateToken in as a SecureString or ensure $env:GitLabPrivateToken is set permanently on the system. 
.EXAMPLE
Import-Module .\gitlab-api.psm1
.EXAMPLE
$PrivateTokenAsPlainText = 'QVy1PB7sTxfy4pqfZM1U'
$PrivateTokenAsSecureString = ConvertTo-SecureString -String $PrivateTokenAsPlainText -AsPlainText -Force
Import-Module .\gitlab-api.psm1 -ArgumentList $PrivateTokenAsSecureString
.EXAMPLE
$PrivateTokenAsPlainText = 'QVy1PB7sTxfy4pqfZM1U'
$PrivateTokenAsSecureString = ConvertTo-SecureString -String $PrivateTokenAsPlainText -AsPlainText -Force
Import-Module .\gitlab-api.psm1 -ArgumentList $PrivateTokenAsSecureString,'example.com'
.EXAMPLE
$PrivateTokenAsPlainText = 'QVy1PB7sTxfy4pqfZM1U'
$PrivateTokenAsSecureString = ConvertTo-SecureString -String $PrivateTokenAsPlainText -AsPlainText -Force
Import-Module .\gitlab-api.psm1 -ArgumentList $PrivateTokenAsSecureString,'example.com','http'
.EXAMPLE
$PrivateTokenAsPlainText = 'QVy1PB7sTxfy4pqfZM1U'
$PrivateTokenAsSecureString = ConvertTo-SecureString -String $PrivateTokenAsPlainText -AsPlainText -Force
Import-Module .\gitlab-api.psm1 -ArgumentList $PrivateTokenAsSecureString,'example.com','http','v2'
.EXAMPLE
$ArgumentList = @(
    (ConvertTo-SecureString -String 'QVy1PB7sTxfy4pqfZM1U' -AsPlainText -Force),
    'example.com',
    'http',
    'v2'
)
Import-Module .\gitlab-api.psm1 -ArgumentList $ArgumentList
.EXAMPLE
$env:GitLabApi = ConvertTo-Json @{
    'GitLabProtocol' = 'http';
    'GitLabDomain' = 'example.com';
    'GitLabVersion' = 'v2';
} -Compress
Import-Module .\gitlab-api.psm1
.NOTES
Code is repo'd on GitHub.com and GitLab.com:
 - https://github.com/Vertigion/GitLab-API
 - https://gitlab.com/Vertigion/GitLab-API

Other tools used:
- [REQUIREMENTS.json](https://github.com/Vertigion/REQUIREMENTS.json)
- [Write-Log](https://github.com/UNT-CAS-ITS/Write-Log)
.LINK
https://github.com/Vertigion/GitLab-API
#>

param(
    [parameter(
        Position=0,
        Mandatory=$false
    )]
    [SecureString]$GitLabPrivateToken,
    [parameter(
        Position=1,
        Mandatory=$false
    )]
    [string]$GitLabDomain = 'gitlab.com',
    [parameter(
        Position=2,
        Mandatory=$false
    )]
    [string]$GitLabProtocol = 'https',
    [parameter(
        Position=3,
        Mandatory=$false
    )]
    [string]$GitLabApiVersion = 'v3'
)

if (${env:Write-Log}) {
    # Pull *REQUIREMENTS.json* from GitHub and Cache
    Remove-Variable -Scope 'global' 'REQUIREMENTS' -Force -ErrorAction Ignore
    $REQUIREMENTS_JSON = @{
        'version' = 'v1.5.2';
        'url' = 'https://raw.githubusercontent.com/Vertigion/REQUIREMENTS.json/{0}/requirements.ps1';
        'path' = "${env:Temp}\REQUIREMENTS.json\requirements_{0}.ps1"
    }
    if (-not (Test-Path ($REQUIREMENTS_JSON.path -f $REQUIREMENTS_JSON.version))) {
        New-Item -ItemType Directory -Path (Split-Path $REQUIREMENTS_JSON.path -Parent) -Force | Out-Null
        Invoke-WebRequest ($REQUIREMENTS_JSON.url -f $REQUIREMENTS_JSON.version) -OutFile ($REQUIREMENTS_JSON.path -f $REQUIREMENTS_JSON.version) -UseBasicParsing
        Unblock-File ($REQUIREMENTS_JSON.path -f $REQUIREMENTS_JSON.version)
    }
    Invoke-Expression (Get-Content ($REQUIREMENTS_JSON.path -f $REQUIREMENTS_JSON.version) | Out-String)
    # /REQUIREMENTS.json
} else {
    if (-not (Get-Command 'Write-Log' -ErrorAction Ignore)) {
        Set-Alias -Name 'Write-Log' -Value 'Write-Debug'
    } 
}

# Import all the functions
$functions = @()
Get-ChildItem '.\functions'  | ?{ $_.Name -notlike '*.Tests.ps1' } | %{
    Write-Log "Importing: $($_.Name)"
    $functions += $_.BaseName
    Invoke-Expression (Get-Content $_.FullName | Out-String)
}

if ($env:GitLabApi) {
    foreach ($GitLabVar in ((ConvertFrom-Json $env:GitLabApi).PSObject.Members | ?{ $_.MemberType -eq 'NoteProperty' })) {
        Remove-Variable $GitLabVar.Name -Force -ErrorAction Ignore
        Set-Variable -Name $GitLabVar.Name -Value $GitLabVar.Value -Force
    }
}

if ($GitLabPrivateToken) {
    Set-GitLabPrivateToken $GitLabPrivateToken -Permanent $false
} elseif (-not (Test-GitLabPrivateToken function)) {
    Set-GitLabPrivateToken
}

# Set the $GitLabPrivateToken for easy access.
$GitLabPrivateToken = Get-GitLabPrivateToken

Export-ModuleMember -Variable GitLabProtocol,GitLabDomain,GitLabApiVersion,GitLabPrivateToken -Function $functions