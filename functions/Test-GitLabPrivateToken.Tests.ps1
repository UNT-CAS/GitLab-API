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
        It 'is a SecureString' {
            $Token = ConvertTo-SecureString -String 'asdf1234' -AsPlainText -Force
            $env:GitLabPrivateToken = ConvertFrom-SecureString $Token
            Test-GitLabPrivateToken | Should Be $true 
        }
    }

    Context 'Invalid: $env:GitLabPrivateToken' {
        It 'is a String' {
            $env:GitLabPrivateToken = 'asdf1234'
            Test-GitLabPrivateToken | Should Be $false
        }
    }
}