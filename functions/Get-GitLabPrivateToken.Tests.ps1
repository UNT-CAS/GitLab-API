$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

if (-not (Get-Module 'gitlab-api')) {
    $Parent = Split-Path -Parent $here
    Import-Module "${Parent}\gitlab-api.psm1"
}

Describe $sut {
    $GitLabPrivateToken = $env:GitLabPrivateToken

    AfterEach {
        $env:GitLabPrivateToken = $GitLabPrivateToken
    }

    Context 'Valid: $env:GitLabPrivateToken' {
        It 'Is a SecureString' {
            $Token = ConvertTo-SecureString -String 'asdf1234' -AsPlainText -Force
            $env:GitLabPrivateToken = ConvertFrom-SecureString $Token
            Get-GitLabPrivateToken | Should Be 'asdf1234'
        }
    }

    Context 'Invalid: $env:GitLabPrivateToken' {
        It 'String should Throw' {
            {
                $env:GitLabPrivateToken = 'asdf1234'
                Get-GitLabPrivateToken
            } | Should Throw
        }
    }
}