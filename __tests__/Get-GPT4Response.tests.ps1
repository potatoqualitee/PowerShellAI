Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe 'Get-GPT4Response' -Tag GPT4Response {
    It 'tests the function exists' {
        $actual = Get-Command Get-GPT4Response -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'test the function has these parameters' {
        $actual = Get-Command Get-GPT4Response -ErrorAction SilentlyContinue
        
        $keys = $actual.Parameters.keys

        $keys.Contains("temperature") | Should -BeTrue
    }

    <#
        TODO: not all Azure OpenAI models support conversational mode.
        Invoke-OpenAIAPI currently for this method name and allows it to be called, otherwise it would throw an error.
        Needs to be separated out so it can be unit tested.
    #> 
}