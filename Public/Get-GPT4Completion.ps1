$ChatSessionOptions = @{
    'model'             = 'gpt-4'
    'temperature'       = 0.0
    'max_tokens'        = 256
    'top_p'             = 1.0
    'frequency_penalty' = 0
    'presence_penalty'  = 0
    'stop'              = $null
}

$Script:ChatInProgress = $false

[System.Collections.ArrayList]$Script:ChatMessages = @()

function Get-ChatSessionOptions {
    [CmdletBinding()]
    param()

    $ChatSessionOptions
}

function Set-ChatSessionOption {
    [CmdletBinding()]
    param(
        $model
    )

    $options = @{} + $PSBoundParameters
    
    foreach ($entry in $options.GetEnumerator()) {
        $ChatSessionOptions["$($entry.Name)"] = $entry.Value
    }
}

function Clear-ChatMessages {
    [CmdletBinding()]
    param()

    $Script:ChatMessages.Clear()
}

function New-ChatMessage {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('user', 'system', 'assistant')]
        $Role,
        [Parameter(Mandatory)]
        $Content
    )

    $Script:ChatInProgress = $Script:true

    # keys need to be lower case
    $null = $Script:ChatMessages.Add(
        [PSCustomObject]@{
            role    = $Role
            content = $Content
        } 
    )    
}

function New-ChatSystemMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Content
    )

    New-ChatMessage -Role 'system' -Content $Content
}

function New-ChatUserMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Content
    )

    New-ChatMessage -Role 'user' -Content $Content
}

function New-ChatAssistantMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Content
    )

    New-ChatMessage -Role 'assistant' -Content $Content
}

function Get-ChatMessages {
    [CmdletBinding()]
    param()

    @($Script:ChatMessages)
}

function Get-ChatPayload {
    [CmdletBinding()]
    param(
        [Switch]$AsJson
    )

    $payload = (Get-ChatSessionOptions).Clone()
    
    $payload.messages = @(Get-ChatMessages)

    if ($AsJson) {
        return $payload | ConvertTo-Json -Depth 10
    }
    else {
        return $payload
    }
    
}

function New-Chat {
    [CmdletBinding()]
    param(
        $Content
    )

    $Script:ChatInProgress = $true

    Clear-ChatMessages

    if (![string]::IsNullOrEmpty($Content)) {
        New-ChatSystemMessage -Content $Content
    }
}

function Test-ChatInProgress {
    $Script:ChatInProgress
}

function Get-GPT4Completion {
    [CmdletBinding()]
    [alias("chat")]
    param(
        [Parameter(Mandatory)]
        $Content
    )

    New-ChatUserMessage -Content $Content

    $body = Get-ChatPayload -AsJson

    $result = Invoke-OpenAIAPI -Uri (Get-OpenAIChatCompletionUri) -Method 'Post' -Body $body
    if ($Raw) {
        $result
    } 
    elseif ($result.choices) {
        $response = $result.choices[0].message.content
        New-ChatAssistantMessage -Content $response
        $response
    }
}

# function Get-GPT4Completion {
#     <#
#         .SYNOPSIS
#         Get a completion from the OpenAI GPT

#         .DESCRIPTION
#         Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position

#         .PARAMETER prompt
#         The prompt to generate completions for

#         .PARAMETER model
#         ID of the model to use. Defaults to 'gpt4'

#         .PARAMETER temperature
#         The temperature used to control the model's likelihood to take risky actions. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer. Defaults to 0

#         .PARAMETER max_tokens
#         The maximum number of tokens to generate. By default, this will be 64 if the prompt is not provided, and 1 if a prompt is provided. The maximum is 2048

#         .PARAMETER top_p
#         An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. Defaults to 1

#         .PARAMETER frequency_penalty
#         A value between 0 and 1 that penalizes new tokens based on whether they appear in the text so far. Defaults to 0

#         .PARAMETER presence_penalty
#         A value between 0 and 1 that penalizes new tokens based on whether they appear in the text so far. Defaults to 0

#         .PARAMETER stop
#         A list of tokens that will cause the API to stop generating further tokens. By default, the API will stop generating when it hits one of the following tokens: ., !, or ?.
        
#         .EXAMPLE
#         Get-GPT3Completion -prompt "What is 2%2? - please explain"
#     #>
#     [CmdletBinding()]
#     [alias("gpt4")]
#     param(
#         [Parameter(Mandatory)]
#         $prompt,
#         $model = 'gpt-4',
#         [ValidateRange(0, 2)]
#         [decimal]$temperature = 0.0,
#         [ValidateRange(1, 2048)]
#         [int]$max_tokens = 256,
#         [ValidateRange(0, 1)]
#         [decimal]$top_p = 1.0,
#         [ValidateRange(-2, 2)]
#         [decimal]$frequency_penalty = 0,
#         [ValidateRange(-2, 2)]
#         [decimal]$presence_penalty = 0,
#         $stop,
#         [Switch]$Raw
#     )

#     $messages = @(
#         @{
#             'role'    = 'user'
#             'content' = $prompt
#         }
#     )
    
#     $body = [ordered]@{
#         model             = $model
#         messages          = $messages
#         temperature       = $temperature
#         max_tokens        = $max_tokens
#         top_p             = $top_p
#         frequency_penalty = $frequency_penalty
#         presence_penalty  = $presence_penalty
#         stop              = $stop
#     }

#     $body = $body | ConvertTo-Json -Depth 10
#     Write-Verbose $body    
    
#     $result = Invoke-OpenAIAPI -Uri (Get-OpenAIChatCompletionUri) -Method 'Post' -Body $body

#     if ($Raw) {
#         $result
#     } 
#     elseif ($result.choices) {
#         $result.choices[0].message.content
#     }
# }