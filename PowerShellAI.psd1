@{
    RootModule        = 'PowerShellAI.psm1'
    ModuleVersion     = '0.5.3'
    GUID              = '081ce7b4-6e63-41ca-92a7-2bf72dbad018'
    Author            = 'Douglas Finke'
    CompanyName       = 'Doug Finke'
    Copyright         = 'c 2023 All rights reserved.'

    Description       = @'
The PowerShell AI module integrates with the OpenAI API and let's you easily access the GPT models for text completion, image generation and more.
'@

    FunctionsToExport = @(
		'Get-OpenAIEdit'
		'Get-OpenAIEditsUri'
        'ai'
        'ConvertFrom-GPTMarkdownTable'
        'copilot'
        'Disable-AIShortCutKey'
        'Enable-AIShortCutKey'
        'Get-DalleImage'
        'Get-ChatCompletion'
        'Get-GPT3Completion'
        'Get-OpenAIBaseRestUri'
        'Get-OpenAIChatCompletionUri'
        'Get-OpenAICompletionsUri'
        'Get-OpenAIImagesGenerationsUri'
        'Get-OpenAIKey'
        'Get-OpenAIModel'
        'Get-OpenAIModelsUri'
        'Get-OpenAIModeration'
        'Get-OpenAIModerationsUri'

        'Get-OpenAIEditsUri'
        'Get-OpenAIEdit'
        'New-SpreadSheet'

        'Get-ChatHistory'
        'Get-ChatInProgress'
        'Get-ChatSession'
        'Get-ChatSessionContent'
        'Get-ChatSessionPath'
        'Get-ChatTheme'
        'Import-ChatMessages'
        'Import-ChatAssistantMessages'
        'Import-ChatUserMessages'
        'Import-ChatSession'
        'Invoke-ChatCompletion'
        'New-Chat'
        'Stop-Chat'
        'Test-ChatInProgress'

        'Get-OpenAIUsage'
        'Get-OpenAIUser'
        'Invoke-AIErrorHelper'
        'Invoke-AIExplain'
        'Invoke-OpenAIAPI'
        'New-SpreadSheet'
        'Set-DalleImageAsWallpaper'
        'Set-OpenAIKey'
    )

    AliasesToExport   = @(
        'gpt'
        #'chatgpt'
        'chat'
        'ieh'
        'explain'
    )

    PrivateData       = @{
        PSData = @{
            Category   = "PowerShell GPT Module"
            Tags       = @("PowerShell", "GPT", "OpenAI")
            ProjectUri = "https://github.com/dfinke/PowerShellAI"
            LicenseUri = "https://github.com/dfinke/PowerShellAI/blob/master/LICENSE.txt"
        }
    }
}