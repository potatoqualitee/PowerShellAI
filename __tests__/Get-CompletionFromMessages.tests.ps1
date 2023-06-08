Import-Module $PSScriptRoot\..\PowerShellAI.psd1 -Force

Describe "Get-CompletionFromMessages" -Tag "Get-CompletionFromMessages" {
    BeforeAll {
        $script:savedKey = $env:OpenAIKey
        $env:OpenAIKey = 'sk-1234567890'
    }
    
    AfterAll {
        $env:OpenAIKey = $savedKey
    }

    It "tests the function Get-CompletionFromMessages exists" {
        $actual = Get-Command Get-CompletionFromMessages -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "tests Get-CompletionFromMessages has a parameter named Messages" {
        $actual = Get-Command Get-CompletionFromMessages -ErrorAction SilentlyContinue
        $actual.Parameters.Keys | Should -Contain Messages
    }

    It "tests Get-CompletionFromMessages returns a response" {
        Mock Invoke-RestMethodWithProgress -ModuleName PowerShellAI -ParameterFilter { 
            $Params.Method -eq 'Post' -and $Params.Uri -eq (Get-OpenAIChatCompletionUri) 
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
        
        $messages = $(
            New-ChatMessageTemplate -Role system "I am a bot"
            New-ChatMessageTemplate -Role user "Hello"
        )

        $actual = Get-CompletionFromMessages -Messages $messages

        $actual.content | Should -BeExactly "Mocked Get-GPT4Completion call"
    }
}