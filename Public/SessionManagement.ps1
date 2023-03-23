$Script:timeStamp

function Get-ChatSessionTimeStamp {
    [CmdletBinding()]
    param ()
    
    if ($null -eq $Script:timeStamp) {
        $Script:timeStamp = (Get-Date).ToString("yyyyMMddHHmmss")
    }

    $Script:timeStamp    
}

function Reset-ChatSessionTimeStamp {
    [CmdletBinding()]
    param ()

    $Script:timeStamp = $null
}

function Get-ChatSessionPath {
    [CmdletBinding()]
    param ()
    
    if ($PSVersionTable.Platform -eq 'Unix') {
        return Join-Path $env:HOME '~/PowerShellAI/ChatGPT'
    }
    elseif ($env:APPDATA) {
        return Join-Path $env:APPDATA 'PowerShellAI/ChatGPT'
    }
}

function Get-ChatSessionFile {
    [CmdletBinding()]
    param (
        $timeStamp
    )

    if (-not $timeStamp) {
        $timeStamp = Get-ChatSessionTimeStamp
    }

    Join-Path (Get-ChatSessionPath) ("{0}-ChatGPTSession.xml" -f $timeStamp)
}