
function Get-OpenAIChatCompletionUri {
    <#
    .Synopsis
    Base url for OpenAI Completions API
    #>
    
    #https://api.openai.com/v1/chat/completions
    (Get-OpenAIBaseRestURI) + '/chat/completions'
}