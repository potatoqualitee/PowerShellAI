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

    It "Test Get-GPT4Completion function exists" {
        $actual = Get-Command Get-GPT4Completion -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Test complete alias exists" {
        $actual = Get-Alias gpt4 -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Tests Get-GPT4Completion has these parameters" {
        $actual = Get-Command Get-GPT4Completion -ErrorAction SilentlyContinue
        
        $keys = $actual.Parameters.keys

        $keys.Contains("Content") | Should -BeTrue
    }

    It 'Tests message is added to chat' {        
        $null = Get-GPT4Completion 'test'

        $actual = Get-ChatMessages
        $actual.Count | Should -Be 1
    }
}