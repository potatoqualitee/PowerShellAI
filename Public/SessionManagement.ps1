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

function Get-ChatSession {
    [CmdletBinding()]
    param (
        $Name
    )

    $path = Get-ChatSessionPath

    if(Test-Path $path) {
        Get-ChildItem -Path $path -Filter "*.xml" | Where-Object { $_.Name -match $Name }         
    }
}


function Export-ChatSession {
    [CmdletBinding()]
    param ()

    $sessionPath = Get-ChatSessionPath
    if (-not (Test-Path $sessionPath)) {
        New-Item -ItemType Directory -Path $sessionPath -Force | Out-Null
    }
    
    Get-ChatMessages | Export-Clixml -Path (Get-ChatSessionFile) -Force
}