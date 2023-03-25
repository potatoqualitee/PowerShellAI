$Script:timeStamp
$Script:chatSessionPath

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

function Reset-ChatSessionPath {
    [CmdletBinding()]
    param ()

    if ($PSVersionTable.Platform -eq 'Unix') {
        $Script:chatSessionPath = Join-Path $env:HOME '~/PowerShellAI/ChatGPT'
    }
    elseif ($env:APPDATA) {
        $Script:chatSessionPath = Join-Path $env:APPDATA 'PowerShellAI/ChatGPT'
    }

}

function Get-ChatSessionPath {
    [CmdletBinding()]
    param ()

    if ($null -eq $Script:chatSessionPath) {
        Reset-ChatSessionPath
    }

    $Script:chatSessionPath
}

function Set-ChatSessionPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Script:chatSessionPath = $Path
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

    if (Test-Path $path) {
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