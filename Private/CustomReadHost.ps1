function CustomReadHost {
    <#
        .SYNOPSIS
        Custom Read-Host function that allows for a default value and a prompt message.

        .EXAMPLE
        CustomReadHost 
    #>

    $Yes = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes', 'Yes, run the code'    
    $Explain = New-Object System.Management.Automation.Host.ChoiceDescription '&Explain', 'Yes, explain the code'    
    $No = New-Object System.Management.Automation.Host.ChoiceDescription '&No', 'No, do not run the code'

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $Explain, $No)

    $message = 'What would you like to do?'
    $host.ui.PromptForChoice($null, $message, $options, 2)
}