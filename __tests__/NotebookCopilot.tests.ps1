Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe 'Notebook Copilot' -Tag NotebookCopilot {
    It 'Test Notebook Copilot function exists' {
        $actual = Get-Command NBCopilot -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test NBCopilot throws when not in a notebook' {
        {NBCopilot 'test'} | Should -Throw 'This can only be used in a Polyglot Interactive Notebook'
    }
}