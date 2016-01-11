<#
.SYNOPSIS
Call the GitLab API
.DESCRIPTION
Call the GitLab API with the supplied path and post parameters. Return an object[].
.PARAMETER Method
API Request Type. Ref: https://gitlab.com/help/api/README.md#status-codes
.PARAMETER Path
Path of the API call.
.PARAMETER Parameters
Parameters required for the call.
.PARAMETER ReturnResponse
Return the `Invoke-WebRequest` response instead of the Content.
.EXAMPLE
Invoke-GitLabApi '/user'
#>
function Invoke-GitLabApi {
    param(
        [ValidatePattern('^/\S+')]
        [string]
        $Path = '/user'
        ,
        [ValidateSet('DELETE','GET','POST','PUT')] 
        [string]
        $Method = 'GET'
        ,
        [hashtable]
        $Parameters = @{}
        ,
        [switch]
        $ReturnResponse
    )
    Write-Log '>'

    $Parameters.Add('PRIVATE-TOKEN', $GitLabPrivateToken)

    $url = "${GitLabProtocol}://${GitLabDomain}/api/${GitLabApiVersion}${Path}"
    Write-Log "GitLabAPI URL: $url"
    $response = Invoke-WebRequest -Uri $url -Method $Method -Headers $Parameters -UseBasicParsing

    if ($ReturnResponse) {
        return $response
    } else {
        return ConvertFrom-Json $response.Content
    }
}