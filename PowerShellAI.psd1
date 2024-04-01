@{
    RootModule        = 'PowerShellAI.psm1'
    ModuleVersion     = '0.9.7'
    GUID              = '081ce7b4-6e63-41ca-92a7-2bf72dbad018'
    Author            = 'Douglas Finke'
    CompanyName       = 'Doug Finke'
    Copyright         = 'c 2024 All rights reserved.'

    Description       = @'
The PowerShell AI module integrates with the OpenAI API and let's you easily access the GPT models for text completion, image generation and more.
'@

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(
        @{ModuleName = 'PowerShellAI.Functions'; ModuleVersion = "0.1.0" ; GUID = "bd4306a8-d043-430b-b02c-813ab8330924" }
    )

    # This module uses Invoke-RestMethod, which was introduced in PSv3
    PowerShellVersion = '3.0'

    FunctionsToExport = @(
        'Get-OpenAIEdit'
        'Get-OpenAIEditsUri'
        'Get-OpenAIEmbeddings'
        'Get-OpenAIEmbeddingsUri'
        'ai'
        'ConvertTo-JsonL'
        'ConvertFrom-GPTMarkdownTable'
        'copilot'
        'Disable-AIShortCutKey'
        'Disable-ChatPersistence'
        'Enable-AIShortCutKey'
        'Enable-ChatPersistence'
        'Get-ChatPersistence'
        'Get-CompletionFromMessages'
        'Get-DalleImage'
        'Get-GPT3Completion'
        'Get-GPT4Completion'
        'Get-GPT4Response'
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

        # new chat functions
        'Add-ChatMessage'
        'Clear-ChatMessages'
        'Export-ChatSession'
        'Get-ChatMessages'
        'Get-ChatPayload'
        'Get-ChatSession'
        'Get-ChatSessionContent'
        'Get-ChatSessionFile'
        'Get-ChatSessionOptions'
        'Get-ChatSessionPath'
        'Get-ChatSessionTimeStamp'
        'New-Chat'
        'New-ChatAssistantMessage'
        'New-ChatMessage'
        'New-ChatMessageTemplate'
        'New-ChatSystemMessage'
        'New-ChatUserMessage'        
        'Reset-ChatSessionOptions'
        'Reset-ChatSessionPath'
        'Reset-ChatSessionTimeStamp'
        'Set-ChatSessionOption'
        'Set-ChatSessionPath'
        'Stop-Chat'
        'Test-ChatInProgress'
        #

        # Azure OpenAI
        'Get-ChatAPIProvider'
        'Get-ChatAzureOpenAIURI'
        'Get-AOAIDalleImage'
        'Get-AzureOpenAIOptions'
        'Reset-AzureOpenAIOptions'
        'Set-AzureOpenAI'
        'Set-ChatAPIProvider'
        'Set-AzureOpenAIOptions'
        #

        'Get-OpenAIUsage'
        'Get-OpenAIUser'
        'Invoke-AIErrorHelper'
        'Invoke-AIExplain'
        'Invoke-AIFunctionBuilder'
        'Invoke-OpenAIAPI'
        'New-SpreadSheet'
        'Set-DalleImageAsWallpaper'
        'Set-OpenAIKey'
        'Test-AzureOpenAIKey'

        # Notebook Copilot
        'NBCopilot'
        'New-NBCell'

        # Copilot wrappers
        'git?' # Translate natural language to Git commands
        'gh?' # Translate natural language to to GitHub CLI commands
    )

    AliasesToExport   = @(
        'gpt'
        'gpt4'
        'chat'
        'ieh'
        'explain'
        'ifb'
        '??'
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