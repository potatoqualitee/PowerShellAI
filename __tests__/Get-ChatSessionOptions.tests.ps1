Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "ChatSessionOptions" -Tag ChatSessionOptions {

    AfterEach {
        Reset-ChatSessionOptions
    }
    
    It "Test Get-ChatSessionOptions function exists" {
        $actual = Get-Command Get-ChatSessionOptions -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Tests default Get-ChatSessionOptions' {
        $actual = Get-ChatSessionOptions
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.model | Should -BeExactly 'gpt-4'
        $actual.temperature | Should -Be 0.0
        $actual.max_tokens | Should -Be 256
        $actual.top_p | Should -Be 1.0
        $actual.frequency_penalty | Should -Be 0
        $actual.presence_penalty | Should -Be 0
        $actual.stop | Should -BeNullOrEmpty
    }

    It 'Test Set-ChatSessionOption' {
        $actual = Get-Command Set-ChatSessionOption -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test Set-ChatSessionOption model' {
        Set-ChatSessionOption -model 'gpt-4'
        $actual = Get-ChatSessionOptions
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.model | Should -BeExactly 'gpt-4'
        $actual.temperature | Should -Be 0.0
        $actual.max_tokens | Should -Be 256
        $actual.top_p | Should -Be 1.0
        $actual.frequency_penalty | Should -Be 0
        $actual.presence_penalty | Should -Be 0
        $actual.stop | Should -BeNullOrEmpty
    }

    It 'Test Set-ChatsessionOption max_tokens' {
        Set-ChatSessionOption -max_tokens 512
        $actual = Get-ChatSessionOptions
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.model | Should -BeExactly 'gpt-4'
        $actual.temperature | Should -Be 0.0
        $actual.max_tokens | Should -Be 512
        $actual.top_p | Should -Be 1.0
        $actual.frequency_penalty | Should -Be 0
        $actual.presence_penalty | Should -Be 0
        $actual.stop | Should -BeNullOrEmpty
    }

    It 'Test Set-ChatSessionOption temperature' {
        Set-ChatSessionOption -temperature 0.5
        $actual = Get-ChatSessionOptions
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.model | Should -BeExactly 'gpt-4'
        $actual.temperature | Should -Be 0.5
        $actual.max_tokens | Should -Be 256
        $actual.top_p | Should -Be 1.0
        $actual.frequency_penalty | Should -Be 0
        $actual.presence_penalty | Should -Be 0
        $actual.stop | Should -BeNullOrEmpty
    }

    It 'Test set-ChatSessionOption top_p' {
        Set-ChatSessionOption -top_p 0.5
        $actual = Get-ChatSessionOptions
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.model | Should -BeExactly 'gpt-4'
        $actual.temperature | Should -Be 0.0
        $actual.max_tokens | Should -Be 256
        $actual.top_p | Should -Be 0.5
        $actual.frequency_penalty | Should -Be 0
        $actual.presence_penalty | Should -Be 0
        $actual.stop | Should -BeNullOrEmpty
    }

    It 'Test Set-ChatSessionOption frequency_penalty' {
        Set-ChatSessionOption -frequency_penalty 0.5
        $actual = Get-ChatSessionOptions
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.model | Should -BeExactly 'gpt-4'
        $actual.temperature | Should -Be 0.0
        $actual.max_tokens | Should -Be 256
        $actual.top_p | Should -Be 1.0
        $actual.frequency_penalty | Should -Be 0.5
        $actual.presence_penalty | Should -Be 0
        $actual.stop | Should -BeNullOrEmpty
    }

    It 'Test Set-ChatSessionOption presence_penalty' {
        Set-ChatSessionOption -presence_penalty 0.5
        $actual = Get-ChatSessionOptions
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.model | Should -BeExactly 'gpt-4'
        $actual.temperature | Should -Be 0.0
        $actual.max_tokens | Should -Be 256
        $actual.top_p | Should -Be 1.0
        $actual.frequency_penalty | Should -Be 0
        $actual.presence_penalty | Should -Be 0.5
        $actual.stop | Should -BeNullOrEmpty
    }

    It 'Test Set-ChatSessionOption stop' {
        Set-ChatSessionOption -stop '!'
        $actual = Get-ChatSessionOptions
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.model | Should -BeExactly 'gpt-4'
        $actual.temperature | Should -Be 0.0
        $actual.max_tokens | Should -Be 256
        $actual.top_p | Should -Be 1.0
        $actual.frequency_penalty | Should -Be 0
        $actual.presence_penalty | Should -Be 0
        $actual.stop | Should -BeExactly '!'
    }

    It 'Test Reset-ChatSessionOptions function exists' {
        $actual = Get-Command Reset-ChatSessionOptions -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test Reset-ChatSessionOptions' {
        Reset-ChatSessionOptions
        $actual = Get-ChatSessionOptions
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.model | Should -BeExactly 'gpt-4'
        $actual.temperature | Should -Be 0.0
        $actual.max_tokens | Should -Be 256
        $actual.top_p | Should -Be 1.0
        $actual.frequency_penalty | Should -Be 0
        $actual.presence_penalty | Should -Be 0
        $actual.stop | Should -BeNullOrEmpty
    }
}