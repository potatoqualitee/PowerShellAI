function CustomReadHost {
    <#
        .SYNOPSIS
        Custom Read-Host function that allows for a default value and a prompt message.

        .EXAMPLE
        CustomReadHost 
    #>

    $Run = New-Object System.Management.Automation.Host.ChoiceDescription '&Run', 'Run the code'    
    $Explain = New-Object System.Management.Automation.Host.ChoiceDescription '&Explain', 'Explain the code'
    $Copy = New-Object System.Management.Automation.Host.ChoiceDescription '&Copy', 'Copy to clipboard'    
    $Nothing = New-Object System.Management.Automation.Host.ChoiceDescription '&Nothing', 'Do not run the code'

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($Run, $Explain, $Copy, $Nothing)

    $message = 'What would you like to do?'
    $host.ui.PromptForChoice($null, $message, $options, 3)
}