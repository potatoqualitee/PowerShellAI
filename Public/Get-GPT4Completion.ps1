$Script:ChatSessionOptions = @{
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

    $Script:ChatSessionOptions
}

function Set-ChatSessionOption {
    [CmdletBinding()]
    param(
        [ValidateSet('gpt-4', 'gpt-3.5-turbo')]
        $model,
        $max_tokens = 256,
        $temperature = 0,
        $top_p = 1,
        $frequency_penalty = 0,
        $presence_penalty = 0,
        $stop
    )

    $options = @{} + $PSBoundParameters
    
    foreach ($entry in $options.GetEnumerator()) {
        $Script:ChatSessionOptions["$($entry.Name)"] = $entry.Value
    }
}

function Reset-ChatSessionOptions {
    [CmdletBinding()]
    param()

    $Script:ChatSessionOptions = @{
        'model'             = 'gpt-4'
        'temperature'       = 0.0
        'max_tokens'        = 256
        'top_p'             = 1.0
        'frequency_penalty' = 0
        'presence_penalty'  = 0
        'stop'              = $null
    }
}

function Clear-ChatMessages {
    [CmdletBinding()]
    param()

    $Script:ChatMessages.Clear()
}

function Add-ChatMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Message
    )

    $null = $Script:ChatMessages.Add($Message)
}

function New-ChatMessageTemplate {
    [CmdletBinding()]
    param( 
        [ValidateSet('user', 'system', 'assistant')]
        $Role,
        $Content
    )

    [PSCustomObject]@{
        role    = $Role
        content = $Content
    }
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

    $message = New-ChatMessageTemplate -Role $Role -Content $Content

    Add-ChatMessage -Message $message

    #Export-ChatSession
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

    Stop-Chat
    $Script:ChatInProgress = $true

    if (![string]::IsNullOrEmpty($Content)) {
        New-ChatSystemMessage -Content $Content
    }
    
    Export-ChatSession
}

function Test-ChatInProgress {
    $Script:ChatInProgress
}

function Stop-Chat {
    [CmdletBinding()]
    param()

    $Script:ChatInProgress = $false
    
    Clear-ChatMessages
    Reset-ChatSessionTimeStamp 
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

    if ($result.choices) {
        $response = $result.choices[0].message.content
        New-ChatAssistantMessage -Content $response
        
        Export-ChatSession
        $response
    }
}