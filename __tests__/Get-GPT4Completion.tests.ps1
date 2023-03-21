Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "Get-GPT4Completion" -Tag 'Get-GPT4Completion' {

    BeforeAll {
        Mock Invoke-RestMethod -ModuleName PowerShellAI -ParameterFilter { 
            $Method -eq 'Post' -and $Uri -eq (Get-OpenAIChatCompletionUri) 

        } -MockWith {
            [PSCustomObject]@{
                choices = @(
                    [PSCustomObject]@{
                        message = [PSCustomObject]@{
                            content = 'Mocked'
                        }
                    }
                )
            }
        } 
    }

    It "Test Get-GPT4Completion function exists" {
        $actual = Get-Command Get-GPT4Completion -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Test complete alias exists" {
        $actual = Get-Alias gpt4 -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Should have these parameters" {
        $actual = Get-Command Get-GPT4Completion -ErrorAction SilentlyContinue
        
        $keys = $actual.Parameters.keys

        $keys.Contains("prompt") | Should -BeTrue
        $keys.Contains("model") | Should -BeTrue
        $keys.Contains("temperature") | Should -BeTrue
        $keys.Contains("max_tokens") | Should -BeTrue
        $keys.Contains("top_p") | Should -BeTrue
        $keys.Contains("frequency_penalty") | Should -BeTrue
        $keys.Contains("presence_penalty") | Should -BeTrue
        $keys.Contains("stop") | Should -BeTrue
        $keys.Contains("Raw") | Should -BeTrue
    }

    It 'Should Mock' {
        $actual = Get-GPT4Completion 'test'
        $actual | Should -Be 'Mocked'
    }
}