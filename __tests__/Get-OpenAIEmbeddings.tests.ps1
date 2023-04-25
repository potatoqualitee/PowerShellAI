Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "Get-OpenAIEmbeddings" -Tag 'Get-OpenAIEmbeddings' {
    It "Test Get-OpenAIEmbeddings function exists" {
        $actual = Get-Command Get-OpenAIEmbeddings -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test Get-OpenAIEmbeddings has these parameters' {
        $actual = Get-Command Get-OpenAIEmbeddings -ErrorAction SilentlyContinue

        $keys = $actual.Parameters.Keys

        $keys.Contains('Content') | Should -Be $true
        $keys.Contains('Raw') | Should -Be $true
    }
}
