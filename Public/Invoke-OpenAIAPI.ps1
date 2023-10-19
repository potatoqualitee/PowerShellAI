function Invoke-OpenAIAPI {
    <#
    .SYNOPSIS
    Invoke the OpenAI API

    .DESCRIPTION
    Invoke the OpenAI API

    .PARAMETER Uri
    The URI to invoke

    .PARAMETER Method
    The HTTP method to use. Defaults to 'Get'

    .PARAMETER Body
    The body to send with the request

    .PARAMETER NoProgress
    The option to hide write-progress if you want, you could also set $ProgressPreference to SilentlyContinue

    .EXAMPLE
    Invoke-OpenAIAPI -Uri "https://api.openai.com/v1/images/generations" -Method Post -Body $body
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Uri,
        [ValidateSet('Default', 'Delete', 'Get', 'Head', 'Merge', 'Options', 'Patch', 'Post', 'Put', 'Trace')]
        $Method = 'Get',
        $Body,
        [switch] $NoProgress
    )

    $params = @{
        Uri         = $Uri
        Method      = $Method
        ContentType = 'application/json'
        body        = $Body
    }

    if ((Get-ChatAPIProvider) -eq 'OpenAI') {
        if (!(Test-OpenAIKey)) {
            throw 'Please set your OpenAI API key using Set-OpenAIKey or by configuring the $env:OpenAIKey environment variable (https://platform.openai.com/account/api-keys)'
        }

        if (($apiKey = Get-LocalOpenAIKey) -is [SecureString]) {
            #On PowerShell 6 and higher use Invoke-RestMethod with Authentication parameter and secure Token
            $params['Authentication'] = 'Bearer'
            $params['Token'] = $apiKey
        }
        else {
            #On PowerShell 5 and lower, or when using the $env:OpenAIKey environment variable, use Invoke-RestMethod with plain text header
            $params['Headers'] = @{Authorization = "Bearer $apiKey" }
        }
    } 
    elseif ((Get-ChatAPIProvider) -eq 'AzureOpenAI') {
        $callingFunction = (Get-PSCallStack)[1].FunctionName
        # if($callingFunction -ne 'Get-GPT4Completion'){
        if ($callingFunction -notin 'Get-GPT4Response', "Get-ChatCompletion") {
            $msg = "$callingFunction is not supported by Azure OpenAI. Use 'Set-ChatAPIProvider OpenAI' and then try again."
            #Write-Warning $msg
            throw $msg
        }`

        if (!(Test-AzureOpenAIKey)) {
            throw 'Please set your Azure OpenAI API key by configuring the $env:AzureOpenAIKey environment variable'
        }
        else {
            $params['Headers'] = @{'api-key' = $env:AzureOpenAIKey }
        }
    }
    
    Write-Verbose ($params | ConvertTo-Json)
    
    Write-Information "Thinking ..."
    
    Invoke-RestMethodWithProgress -Params $params -NoProgress:$NoProgress
}
