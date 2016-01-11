$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
# . "$here\$sut"
Import-Module "${here}\gitlab-api.psm1"
 
Describe 'Variables' {
    Context 'GitLabRoot' {
        It 'should get a 200 response from the GitLab server.' {
            (Invoke-WebRequest "${GitLabProtocol}://${GitLabDomain}" -UseBasicParsing).StatusCode | Should Be 200
        }
    }

    Context 'GitLabApi' {
        It 'should get a 200 response from the GitLab server.' {
            (Invoke-WebRequest "${GitLabProtocol}://${GitLabDomain}/api/${GitLabApiVersion}" -UseBasicParsing).StatusCode | Should Be 200
        }

        It 'should get ''401 Unauthorized'' from api/user without private token' {
            { Invoke-WebRequest "${GitLabProtocol}://${GitLabDomain}/api/${GitLabApiVersion}/user" -UseBasicParsing } | Should Throw '(401) Unauthorized'
        }
    }
}