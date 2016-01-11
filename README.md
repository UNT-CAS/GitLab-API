GitLab API handler

# Description

PowerShell functions to easily interact with the GitLab API. When importing the module, you should supply the GitLabPrivateToken. Include any non-default parameters as well.

Alternatively, all parameters can be stored in `$env:GitLabApi` (See Examples); which will overwrite any supplied parameters.

[Write-Log](https://github.com/UNT-CAS-ITS/Write-Log) is supported. If $env:Write-Log is not set, all log output will got to Write-Debug instead.

# Parameters 

## GitLabProtocol

The API protocol. ie: http, https

## GitLabDomain

The domain name of the GitLab server. [More info](https://gitlab.com/help/api/README.md#introduction)

## GitLabApiVersion

The API version as defined 'lib/api.rb'. [More info](https://gitlab.com/help/api/README.md#introduction)

## GitLabPrivateToken

The Private Token provides the required authentication. [More info](https://gitlab.com/help/api/README.md#introduction)

If the GitLabPrivateToken parameter is not supplied, `$env:GitLabPrivateToken` is audited with the `Test-GitLabPrivateToken` function to see if a valid SecureString is stored. If one does not exist as an Environment Variable, the user will be prompted to supply one.

If module is used in scripts, you should pass the GitLabPrivateToken in as a SecureString or ensure $env:GitLabPrivateToken is set permanently on the system. 

# Examples

## Basic Import

```powershell
Import-Module .\gitlab-api.psm1
```

Will prompt user to set their private token:

```text
Enter your GitLab Private Token (https://git.cas.unt.edu/profile/account): ********************
Set permanently? [Y|n]: y
```

## Import-Module with 1 Argument

```powershell
$PrivateTokenAsPlainText = 'QVy1PB7sTxfy4pqfZM1U'
$PrivateTokenAsSecureString = ConvertTo-SecureString -String $PrivateTokenAsPlainText -AsPlainText -Force
Import-Module .\gitlab-api.psm1 -ArgumentList $PrivateTokenAsSecureString
```

## Import-Module with 2 Arguments

```powershell
$PrivateTokenAsPlainText = 'QVy1PB7sTxfy4pqfZM1U'
$PrivateTokenAsSecureString = ConvertTo-SecureString -String $PrivateTokenAsPlainText -AsPlainText -Force
Import-Module .\gitlab-api.psm1 -ArgumentList $PrivateTokenAsSecureString,'example.com'
```

## Import-Module with 3 Arguments

```powershell
$PrivateTokenAsPlainText = 'QVy1PB7sTxfy4pqfZM1U'
$PrivateTokenAsSecureString = ConvertTo-SecureString -String $PrivateTokenAsPlainText -AsPlainText -Force
Import-Module .\gitlab-api.psm1 -ArgumentList $PrivateTokenAsSecureString,'example.com','http'
```

## Import-Module with 4 Arguments

```powershell
$PrivateTokenAsPlainText = 'QVy1PB7sTxfy4pqfZM1U'
$PrivateTokenAsSecureString = ConvertTo-SecureString -String $PrivateTokenAsPlainText -AsPlainText -Force
Import-Module .\gitlab-api.psm1 -ArgumentList $PrivateTokenAsSecureString,'example.com','http','v2'
```

## Import-Module with 4 Argument Array

```powershell
$ArgumentList = @(
    (ConvertTo-SecureString -String 'QVy1PB7sTxfy4pqfZM1U' -AsPlainText -Force),
    'example.com',
    'http',
    'v2'
)
Import-Module .\gitlab-api.psm1 -ArgumentList $ArgumentList
```

## Import-Module with Environment Variable

```powershell
$env:GitLabApi = ConvertTo-Json @{
    'GitLabProtocol' = 'http';
    'GitLabDomain' = 'example.com';
    'GitLabVersion' = 'v2';
} -Compress
Import-Module .\gitlab-api.psm1
```

***Note:*** *You can also set `$env:GitLabPrivateToken`. For details on how, you should review the code for [Set-GitLabPrivateToken](functions/Set-GitLabPrivateToken.ps1)*
