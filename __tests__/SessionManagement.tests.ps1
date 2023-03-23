Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "Session Management" -Tag SessionManagement {
    BeforeAll {
        function Test-ChatSessionTimeStamp {
            param(
                [Parameter(Mandatory)]
                [string]$expected
            )

            ($expected.Length -eq 14) -and ($expected -match "^[0-9]+$")
        }
    }

    It 'Test Get-ChatSessionTimeStamp function exists' {
        $actual = Get-Command Get-ChatSessionTimeStamp -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test Reset-ChatSessionTimeStamp function exists' {
        $actual = Get-Command Reset-ChatSessionTimeStamp -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test Get-ChatSessionPath function exists' {
        $actual = Get-Command Get-ChatSessionPath -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test Get-ChatSessionFile function exists' {
        $actual = Get-Command Get-ChatSessionFile -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test Export-ChatSession function exists' {
        $actual = Get-Command Export-ChatSession -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test Get-ChatSessionTimeStamp returns a string in the correct format' {
        $actual = Get-ChatSessionTimeStamp

        Test-ChatSessionTimeStamp $actual | Should -BeTrue
    }

    It 'Test Reset-ChatSessionTimeStamp resets the session timestamp' {
        $expected = Get-ChatSessionTimeStamp
        Reset-ChatSessionTimeStamp
        
        # need to wait a second to ensure the timestamp is different
        Start-Sleep 1
        $actual = Get-ChatSessionTimeStamp

        $actual | Should -Not -Be $expected
    }

    It 'Test Get-ChatSessionPath returns correct path for Windows' {
        $actual = Get-ChatSessionPath

        if ($IsWindows -or $null -eq $IsWindows) {
            $actual | Should -BeExactly "$env:APPDATA\PowerShellAI\ChatGPT"
        }
    }

    # It 'Test Get-ChatSessionPath returns correct path for Linux' -Skip {
    #     $actual = Get-ChatSessionPath
    #     $actual | Should -Be ($env:HOME + "~/PowerShellAI/ChatGPT")
    # }

    It 'Test Get-ChatSessionFile returns correct file name for Windows' {

        if($IsLinux -or $IsMacOS) {
            # skip 
            return
        }
        
        Reset-ChatSessionTimeStamp
        $timeStamp = Get-ChatSessionTimeStamp

        $actual = Get-ChatSessionFile

        $expected = "$(Get-ChatSessionPath)\$($timeStamp)-ChatGPTSession.xml"

        $actual | Should -BeExactly $expected
    }

    It 'Test exporting chat messages' {
        Add-ChatMessage -Message ([PSCustomObject]@{
            role    = 'system'
            content = 'system test'
        })

        Add-ChatMessage -Message ([PSCustomObject]@{
            role    = 'user'
            content = 'user test'
        })

        Add-ChatMessage -Message ([PSCustomObject]@{
            role    = 'assistant'
            content = 'assistant test'
        })
        
        Export-ChatSession
        # Clear-ChatMessages
    }
}
