function Get-NumberOfTokens {
    param(
        [Parameter(Mandatory)]
        $Messages,
        $Model = "gpt-3.5-turbo"
    )

    [TiktokenSharp.TikToken]::set_PBEFileDirectory("$PSScriptRoot\PBEFileDirectory")
    
    try {
        $encoding = [TiktokenSharp.TikToken]::EncodingForModel($Model)
    }
    catch {
        if ($null -eq $encoding) {
            Write-Warning "Model [$($Model)] not found. Using cl100k_base encoding."
            $encoding = [TiktokenSharp.TikToken]::EncodingForModel("cl100k_base")
        }
    }    
 
    <#
    Python:

    num_tokens_from_messages(messages, model="gpt-3.5-turbo-0301"):
    num_tokens = 0
    for message in messages:
        num_tokens += tokens_per_message
        for key, value in message.items():
            num_tokens += len(encoding.encode(value))
            if key == "name":
                num_tokens += tokens_per_name
    num_tokens += 3  # every reply is primed with <|start|>assistant<|message|>
#>

    # need to update to take and arry of hashtables returned from Get-ChatMessages
    # may need to keep for text-in text-out approach    
    $tokenCount = 0
    foreach ($message in $Messages) {
        $tokenCount += @($encoding.Encode($message)).Count
    }
    $tokenCount += 3 # every reply is primed with <|start|>assistant<|message|>
    $tokenCount
}