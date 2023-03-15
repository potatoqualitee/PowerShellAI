Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "Invoke-AIExplain" -Tag 'Invoke-AIExplain' {
    It "Test Invoke-AIExplain function exists" {
        $actual = Get-Command Invoke-AIExplain -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Test explain alias exists" {
        $actual = Get-Alias explain -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Should have these parameters" {
        $actual = Get-Command Invoke-AIExplain -ErrorAction SilentlyContinue
        
        $actual.Parameters.keys.Contains("Id") | Should -BeTrue
        $actual.Parameters.keys.Contains("Value") | Should -BeTrue
    }
}
