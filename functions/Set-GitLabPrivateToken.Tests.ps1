$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

if (-not (Get-Module 'gitlab-api')) {
    $Parent = Split-Path -Parent $here
    Import-Module "${Parent}\gitlab-api.psm1"
}

# store current values so we can fix after the tests
$GitLabPrivateToken = $env:GitLabPrivateToken
$GitLabPrivateTokenPerm = [Environment]::GetEnvironmentVariable('GitLabPrivateToken', 'User')

Describe $sut {
    $tokens = @(
        'asdf1234',
        (ConvertTo-SecureString -String 'asdf1234' -AsPlainText -Force)
    )

    AfterEach {
        $env:GitLabPrivateToken = $null
        [Environment]::SetEnvironmentVariable('GitLabPrivateToken', $null, 'User')
    }

    foreach ($token in $tokens) {
        Context "Token is [$($token.GetType())]${token}" {
            BeforeEach {
                if ($token -is 'SecureString') {
                    $token = ConvertFrom-SecureString $token
                }
            }

            It 'Set permanent ([bool] $true); check session' {
                Set-GitLabPrivateToken -Token $token -Permanent $true
                { ConvertTo-SecureString $env:GitLabPrivateToken } | Should Not Throw
            }

            It 'Set permanent ([bool] $true); check permanent' {
                Set-GitLabPrivateToken -Token $token -Permanent $true
                { ConvertTo-SecureString ([Environment]::GetEnvironmentVariable('GitLabPrivateToken', 'User')) } | Should Not Throw
            }

            It 'Set permanent ([bool] $false); check session' {
                Set-GitLabPrivateToken -Token $token -Permanent $false
                { ConvertTo-SecureString $env:GitLabPrivateToken } | Should Not Throw
            }

            It 'Set permanent ([bool] $false); check permanent' {
                Set-GitLabPrivateToken -Token $token -Permanent $false
                { ConvertTo-SecureString ([Environment]::GetEnvironmentVariable('GitLabPrivateToken', 'User')) } | Should Throw
            }

            It 'Set permanent ([string] ''yes''); check session' {
                Set-GitLabPrivateToken -Token $token -Permanent 'yes'
                { ConvertTo-SecureString $env:GitLabPrivateToken } | Should Not Throw
            }

            It 'Set permanent ([string] ''yes''); check permanent' {
                Set-GitLabPrivateToken -Token $token -Permanent 'yes'
                { ConvertTo-SecureString ([Environment]::GetEnvironmentVariable('GitLabPrivateToken', 'User')) } | Should Not Throw
            }

            It 'Set permanent ([string] ''no''); check session' {
                Set-GitLabPrivateToken -Token $token -Permanent 'no'
                { ConvertTo-SecureString $env:GitLabPrivateToken } | Should Not Throw
            }

            It 'Set permanent ([string] ''no''); check permanent' {
                Set-GitLabPrivateToken -Token $token -Permanent 'no'
                { ConvertTo-SecureString ([Environment]::GetEnvironmentVariable('GitLabPrivateToken', 'User')) } | Should Throw
            }
        }
    }
}

# reset to before we did the tests.
$env:GitLabPrivateToken = $GitLabPrivateToken
[Environment]::SetEnvironmentVariable('GitLabPrivateToken', $GitLabPrivateTokenPerm, 'User')