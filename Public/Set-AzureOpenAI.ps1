function Set-AzureOpenAI {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Endpoint,
        [Parameter(Mandatory)]
        $DeploymentName,
        [Parameter(Mandatory)]
        $ApiVersion,
        [Parameter(Mandatory)]
        $ApiKey
    )

    $p = @{} + $PSBoundParameters    
    $p.Remove("ApiKey")    

    Set-ChatAzureOpenAIURIOptions @p
    $env:AzureOpenAIKey = $ApiKey
    Set-ChatAPIProvider -Provider AzureOpenAI    
}