function Invoke-AIExplain {
    <#
        .SYNOPSIS
            Explain the last command or a command by id
        .DESCRIPTION
            Invoke-AIExplain is a function that uses the OpenAI GPT-3 API to provide explain the last command or a command by id.
        .EXAMPLE
            explain
        .EXAMPLE
            explain 10 # where 10 is the id of the command in the history
    #>
    [CmdletBinding()]
    [alias("explain")]
    param(
        $Id
    )

    if ($Id) {
        $cli = Get-History -Id $Id
    }
    else {
        $cli = (Get-History | Select-Object -last 1).CommandLine 
    }

    $result = $cli | ai 'explain'

    Write-Host $cli -ForegroundColor Green
    $result
}