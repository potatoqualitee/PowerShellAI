function Get-NumberOfTokens {
    param(
        [Parameter(Mandatory)]
        $Messages
    )

    # https://github.com/dmitry-brazhenko/SharpToken

    $encoding = [SharpToken.GptEncoding]::GetEncoding("cl100k_base")    
    $encoding = [SharpToken.GptEncoding]::GetEncodingForModel("gpt-4")
    $encoding.Encode($Messages).Count
}