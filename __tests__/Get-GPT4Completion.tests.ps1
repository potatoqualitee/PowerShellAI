Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "Get-GPT4Completion" -Tag 'GPT4Completion' {

    BeforeAll {
        $script:savedKey = $env:OpenAIKey
        $env:OpenAIKey = 'sk-1234567890'

        Mock Invoke-RestMethod -ModuleName PowerShellAI -ParameterFilter { 
            $Method -eq 'Post' -and $Uri -eq (Get-OpenAIChatCompletionUri) 
        } -MockWith {
            [PSCustomObject]@{
                choices = @(
                    [PSCustomObject]@{
                        message = [PSCustomObject]@{
                            content = 'Mocked Get-GPT4Completion call'
                        }
                    }
                )
            }
        } 
    }

    BeforeEach {
        Clear-ChatMessages
    }

    AfterAll {
        $env:OpenAIKey = $savedKey
    }

    It 'Test if chat is in progress initially' -Skip {
        $actual = Test-ChatInProgress
        $actual | Should -BeFalse
    }

    It "Test Get-GPT4Completion function exists" {
        $actual = Get-Command Get-GPT4Completion -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Tests Test-ChatInProgress exists' {
        $actual = Get-Command Test-ChatInProgress -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Tests if Stop-Chat exists' {
        $actual = Get-Command Stop-Chat -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    } 
    
    It "Test chat alias exists" {
        $actual = Get-Alias chat -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
        $actual.Definition | Should -Be Get-GPT4Completion
    }

    It 'Test if chat is in progress after message' {
        $null = Get-GPT4Completion 'test'

        $actual = Test-ChatInProgress
        $actual | Should -BeTrue
    }

    It 'Test if chat is in progress after New-Chat' {
        $null = New-Chat

        $actual = Test-ChatInProgress
        $actual | Should -BeTrue
    }

    It 'Test if chat is in progress after New-ChatMessage and then New-Chat' {
        $null = New-ChatMessage -Role user -Content 'test'

        $actual = Test-ChatInProgress
        $actual | Should -BeTrue

        New-Chat

        $actual = Test-ChatInProgress
        $actual | Should -BeTrue
    }

    It "Tests Get-GPT4Completion has these parameters" {
        $actual = Get-Command Get-GPT4Completion -ErrorAction SilentlyContinue
        
        $keys = $actual.Parameters.keys

        $keys.Contains("Content") | Should -BeTrue
    }

    It 'Test if Stop-Chats stops chat and resets messages' {
        $null = New-Chat 'test'

        $actual = Test-ChatInProgress
        $actual | Should -BeTrue

        Stop-Chat

        $actual = Test-ChatInProgress
        $actual | Should -BeFalse

        (Get-ChatMessages).Count | Should -Be 0
    }

    # It 'Tests message is added to chat' {        
    #     $null = Get-GPT4Completion 'test'

    #     $actual = Get-ChatMessages
    #     $actual.Count | Should -Be 1
    # }
}