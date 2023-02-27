#Requires -Modules PowerShellAI

function Get-ErrorInsights {
    $lastError = $Error[0]

    if($lastError) {
        $message = $lastError.Exception.Message
        $errorType = $lastError.FullyQualifiedErrorId

        $promptPrefix = "Provide a detailed summary of the following powershell error and offer a potential powershell solution (using code if it's a confident solution):"

        $errorDetails = "${errorType}`n$message"
        
        $response = (Get-GPT3Completion -prompt "$promptPrefix`n`n$errorDetails" -max_tokens 2048).Trim()
        Write-Host -ForegroundColor Cyan "$errorDetails`n"
        Write-Host -ForegroundColor DarkGray $response
    } else {
        Write-Host "No error has occurred"
    }
}

Set-Alias -Name Get-WtfHappened -Value Get-ErrorInsights # ;)