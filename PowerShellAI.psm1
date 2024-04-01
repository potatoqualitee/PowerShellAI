# Set the OpenAI key to null
$Script:OpenAIKey = $null

# Set the chat API provider to OpenAI
$Script:ChatAPIProvider = 'OpenAI'

# Set the chat in progress flag to false
$Script:ChatInProgress = $false

# Create an array list to store chat messages
[System.Collections.ArrayList]$Script:ChatMessages = @()

# Enable chat persistence
$Script:ChatPersistence = $true

# Set the options for the chat session
$Script:ChatSessionOptions = @{
    'model'             = 'gpt-4'
    'temperature'       = 0.0
    'max_tokens'        = 256
    'top_p'             = 1.0
    'frequency_penalty' = 0
    'presence_penalty'  = 0
    'stop'              = $null
}

# Set the options for the Azure OpenAI API
$Script:AzureOpenAIOptions = @{
    Endpoint       = 'not set'
    DeploymentName = 'not set'
    ApiVersion     = 'not set'
}

# Load all PowerShell scripts in the Public and Private directories
foreach ($directory in @('Public', 'Private')) {
    Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1" | ForEach-Object { . $_.FullName }
}

$scriptBlock = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $models = Get-OpenAIModel -ErrorAction SilentlyContinue
    if (-not $models) {
        $models = 'gpt-4','gpt-3.5-turbo-1106', 'gpt-4-1106-preview', 'gpt-4-0613', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-3.5-turbo-0613'
    }

    $models | Where-Object {
        $_ -like "$wordToComplete*"
    } | ForEach-Object {
        "'$_'"
    }
}

Register-ArgumentCompleter -CommandName Set-ChatSessionOption, Invoke-AIFunctionBuilder -ParameterName model -ScriptBlock $scriptBlock