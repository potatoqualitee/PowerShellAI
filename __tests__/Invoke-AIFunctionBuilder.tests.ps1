Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "Invoke-AIFunctionBuilder" -Tag 'Invoke-AIFunctionBuilder' {
    It "Test Invoke-AIFunctionBuilder function exists" {
        $actual = Get-Command Invoke-AIFunctionBuilder -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Test ifb alias exists" {
        $actual = Get-Alias ifb -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Invoke-AIFunctionBuilder function dependencies support expected parameters" {
        $dependencies = @(
            @{
                Function = "Get-GPT3Completion"
                Parameters = @("prompt", "max_tokens")
                Description = "This function is used for quick completions that don't require chat context"
            }
        )

        foreach($dependency in $dependencies) {
            $function = Get-Command $dependency.Function -ErrorAction SilentlyContinue
            $function | Should -Not -BeNullOrEmpty
            foreach($parameter in $dependency.Parameters) {
                $function.Parameters.Keys | Should -Contain $parameter
            }
        }
    }

    It "FunctionBuilderCore function dependencies support expected parameters" {
        $dependencies = @(
            @{
                Function = "Set-ChatSessionOption"
                Parameters = @("model", "max_tokens", "temperature")
                Description = "This function is used to setup the model parameters for Get-GPT4Completion, each system can use different settings e.g a code editing system uses lower temp than one that is responsible for creating the initial code solution"
            },
            @{
                Function = "New-Chat"
                Parameters = @("Content")
                Description = "This function is used to setup the system prompt for Get-GPT4Completion"
            },
            @{
                Function = "Get-GPT4Completion"
                Parameters = @("Content", "ErrorAction")
                Description = "This function is used for enhanced code completions that require chat context or a system prompt"
            },
            @{
                Function = "Get-ChatMessages"
                Parameters = @()
                Description = "This is used when the function builder doesn't output something sensible, the chat is dumped to help debug issues"
            }
        )
        foreach($dependency in $dependencies) {
            $function = Get-Command $dependency.Function -ErrorAction SilentlyContinue
            $function | Should -Not -BeNullOrEmpty
            foreach($parameter in $dependency.Parameters) {
                $function.Parameters.Keys | Should -Contain $parameter
            }
        }
    }
}
