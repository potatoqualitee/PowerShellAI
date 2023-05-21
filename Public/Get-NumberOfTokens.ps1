function Get-NumberOfTokens {
    param(
        [Parameter(Mandatory)]
        $Messages
    )

    $encoding = [SharpToken.GptEncoding]::GetEncoding("cl100k_base")    
    $encoding = [SharpToken.GptEncoding]::GetEncodingForModel("gpt-4")
    $encoding.Encode($Messages).Count
}