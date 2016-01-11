$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

if (-not (Get-Module 'gitlab-api')) {
    $Parent = Split-Path -Parent $here
    Import-Module "${Parent}\gitlab-api.psm1"
}

Describe $sut {
    Context 'Simple Call' {
        $res = Invoke-GitLabApi

        It 'Returns PSCustomObject' {
            $res.GetType().Name | Should Be 'PSCustomObject'
        }

        It 'PSCustomObject has private_token' {
            $res.private_token | Should Not BeNullOrEmpty
        }

        It 'PSCustomObject private_token matches Get-GitLabPrivateToken' {
            $res.private_token -eq $GitLabPrivateToken | Should Be $true
        }
    }

    Context 'Simple Call; ReturnResponse' {
        $res = Invoke-GitLabApi -ReturnResponse

        It 'Returns BasicHtmlWebResponseObject' {
            $res.GetType().Name | Should Be 'BasicHtmlWebResponseObject' 
        }

        It 'BasicHtmlWebResponseObject not have private_token' {
            $res.private_token | Should BeNullOrEmpty
        }

        It 'BasicHtmlWebResponseObject has StatusCode' {
            $res.StatusCode | Should Not BeNullOrEmpty
        }

        It 'BasicHtmlWebResponseObject StatusCode is 200' {
            $res.StatusCode | Should Be 200
        }
    }
}