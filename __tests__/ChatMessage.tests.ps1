Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "Chat Messages" -Tag ChatMessages {
    BeforeEach {
        Clear-ChatMessages
    }

    It 'Tests New-ChatUserMessage exists' {
        $actual = Get-Command New-ChatUserMessage -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Tests Get-ChatMessages exists' {
        $actual = Get-Command Get-ChatMessages -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Tests Clear-ChatMessages exists' {
        $actual = Get-Command Clear-ChatMessages -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Tests Get-ChatMessages is null as default' {
        $actual = Get-ChatMessages
        $actual | Should -BeNullOrEmpty
    }

    It 'Tests New-ChatMessage exists' {
        $actual = Get-Command New-ChatMessage -ErrorAction SilentlyContinue
        
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test Clear-ChatMessages clears messages' {
        New-ChatMessage -Role 'user' -Content "Hello"       
        New-ChatUserMessage -Content "Hello message 2"  

        $actual = Get-ChatMessages
        $actual.Count | Should -Be 2

        Clear-ChatMessages
        $actual = Get-ChatMessages
        $actual.Count | Should -Be 0
    }

    It 'Tests Get-ChatMessages retuns messages with proper cased keys' {
        New-ChatMessage -Role 'user' -Content "Hello"       

        $actual = Get-ChatMessages

        $names = $actual[0].PSObject.Properties.Name

        $names[0] | Should -BeExactly "role"
        $names[1] | Should -BeExactly "content"        
    }

    It 'Tests New-ChatMessage has these parameters' {
        $actual = Get-Command New-ChatMessage -ErrorAction SilentlyContinue
        
        $keys = $actual.Parameters.keys

        $keys.Contains("role") | Should -BeTrue
        $keys.Contains("content") | Should -BeTrue
    }
        
    It 'Tests New-ChatUserMessage has these parameters' {
        $actual = Get-Command New-ChatUserMessage -ErrorAction SilentlyContinue
        
        $keys = $actual.Parameters.keys

        $keys.Contains("content") | Should -BeTrue
    }

    It 'Tests adding a user message with New-ChatMessage' {
        
        New-ChatMessage -Role 'user' -Content "Hello"       

        $actual = Get-ChatMessages

        $actual.Count | Should -Be 1
        $actual[0].Role | Should -Be "user"
        $actual[0].Content | Should -Be "Hello"
    }

    It 'Tests adding a user message witn New-ChatUserMessage' {
        Clear-ChatMessages
        New-ChatUserMessage -content "Hello"       

        $actual = Get-ChatMessages

        $actual.Count | Should -Be 1
        $actual[0].Role | Should -Be "user"
        $actual[0].Content | Should -Be "Hello"
    }
}