Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "Get-ChatPayload" -Tag ChatPayload {

    BeforeEach {
        Clear-ChatMessages
    }

    It 'Tests Get-ChatPayload function exists' {
        $actual = Get-Command Get-ChatPayload -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Tests Get-ChatPayload has initial correct data' {
        $actual = Get-ChatPayload
        $actual | Should -Not -BeNullOrEmpty

        $actual.keys.count | Should -Be 8

        $actual.model | Should -Be 'gpt-4'
        $actual.temperature | Should -Be 0.0
        $actual.max_tokens | Should -Be 256
        $actual.top_p | Should -Be 1.0
        $actual.frequency_penalty | Should -Be 0
        $actual.presence_penalty | Should -Be 0
        $actual.stop | Should -BeNullOrEmpty
        $actual.messages | Should -BeNullOrEmpty
    }

    It 'Tests Get-ChatPayload has correct data after New-ChatUserMessage' {
        New-ChatUserMessage -Content "Hello"
     
        $actual = Get-ChatPayload

        $actual.messages.count | Should -Be 1
        $actual.messages[0].role | Should -Be 'user'
        $actual.messages[0].content | Should -Be 'Hello'
    }

    It 'Tests Get-ChatPayload has correct data after New-ChatMessage' {
        New-ChatMessage -Role 'user' -Content "Hello"
     
        $actual = Get-ChatPayload

        $actual.messages.count | Should -Be 1
        $actual.messages[0].role | Should -Be 'user'
        $actual.messages[0].content | Should -Be 'Hello'
    }

    It 'Tests Get-ChatPayload has correct data after New-ChatMessage and New-ChatUserMessage' {
        New-ChatMessage -Role 'user' -Content "Hello"
        New-ChatUserMessage -Content "Hello message 2"
     
        $actual = Get-ChatPayload

        $actual.messages.count | Should -Be 2
        $actual.messages[0].role | Should -Be 'user'
        $actual.messages[0].content | Should -Be 'Hello'
        $actual.messages[1].role | Should -Be 'user'
        $actual.messages[1].content | Should -Be 'Hello message 2'
    }

    It 'Tests Get-ChatPayload has correct data after New-ChatMessage and New-ChatUserMessage and Clear-ChatMessages' {
        New-ChatMessage -Role 'user' -Content "Hello"
        New-ChatUserMessage -Content "Hello message 2"
        Clear-ChatMessages
     
        $actual = Get-ChatPayload

        $actual.messages.count | Should -Be 0
    }

    It 'Tests Get-ChatPayload has correct data after New-ChatMessage and New-ChatUserMessage and Clear-ChatMessages and New-ChatMessage' {
        New-ChatMessage -Role 'user' -Content "Hello"
        New-ChatUserMessage -Content "Hello message 2"
        Clear-ChatMessages
        New-ChatMessage -Role 'user' -Content "Hello"
     
        $actual = Get-ChatPayload

        $actual.messages.count | Should -Be 1
        $actual.messages[0].role | Should -Be 'user'
        $actual.messages[0].content | Should -Be 'Hello'
    }

    It 'Tests Get-ChatPayload after Get-GPT4Completion' {
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
        Get-GPT4Completion -Content "Hello World"

        $actual = Get-ChatPayload

        $actual.messages.count | Should -Be 2

        $actual.messages[0].role | Should -Be 'user'
        $actual.messages[0].content | Should -Be 'Hello World'

        $actual.messages[1].role | Should -Be 'assistant'
        $actual.messages[1].content | Should -Be 'Mocked Get-GPT4Completion call'
    }

    It 'Tests Get-ChatPayload as Json' {
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
        
        Get-GPT4Completion -Content "Hello World"

        $actual = Get-ChatPayload -AsJson
        $actual | Should -Not -BeNullOrEmpty

        $obj = ConvertFrom-Json $actual

        $obj.messages.count | Should -Be 2

        $obj.messages[0].role | Should -Be 'user'
        $obj.messages[0].content | Should -Be 'Hello World'

        $obj.messages[1].role | Should -Be 'assistant'
        $obj.messages[1].content | Should -Be 'Mocked Get-GPT4Completion call'
    }    
}