function Get-CompletionFromMessages {
    param(
        [Parameter(Mandatory)]
        $Messages
    )

    $payload = (Get-ChatSessionOptions).Clone()

    $payload.messages = $messages
    $payload = $payload | ConvertTo-Json -Depth 10
    
    $body = [System.Text.Encoding]::UTF8.GetBytes($payload)

    if ((Get-ChatAPIProvider) -eq 'OpenAI') {
        $uri = Get-OpenAIChatCompletionUri
    }
    elseif ((Get-ChatAPIProvider) -eq 'AzureOpenAI') {
        $uri = Get-ChatAzureOpenAIURI
    }

    $result = Invoke-OpenAIAPI -Uri $uri -Method 'Post' -Body $body 
    $result.choices.message
}