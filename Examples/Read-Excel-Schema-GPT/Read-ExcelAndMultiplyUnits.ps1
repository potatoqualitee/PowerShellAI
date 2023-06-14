#Requires -Modules @{ ModuleName="ImportExcel"; ModuleVersion="7.8.5" }, PowerShellAI

<#
This PowerShell script uses the ImportExcel module to read an Excel file and multiply the units by 20%. It first gets the schema of the Excel file using the Get-ExcelFileSchema function, then creates chat messages for the user and system. The user is prompted to "read the excel file" and "multiply the units by 20%". The script then uses the Get-CompletionFromMessages function to get completion from the chat messages and outputs the second to second-to-last lines of the content. Finally, it outputs the PowerShell code that reads the Excel file, multiplies the units by 20%, and formats the output as a table.
#>

# Set the path to the Excel file
$path = "$PSScriptRoot\salesData.xlsx"

# Get the schema of the Excel file using the ImportExcel module
$schema = Get-ExcelFileSchema $path

# Create chat messages for the user and system
$messages = @()
$messages += New-ChatMessageTemplate -Role system -Content (@'
You are a great PowerShell assistant. Based on the attached
excel schema, sheet names and property names, please create PowerShell code
based on follow up questions, no explanation needed. 

- Use the PowerShell ImportExcel module
- Use the this excel file {0}.
- Output results to the console
- Schema:
{1}
'@ -f $path, $schema)    

$messages += New-ChatMessageTemplate -Role user -Content "
read the excel file
multiply the units by 20%
"

# Set the max tokens for the chat session
Set-ChatSessionOption -max_tokens 1024 

# Get completion from the chat messages
$r = Get-CompletionFromMessages $messages

# Split the content by new lines and output the second to second-to-last lines
$content = $r.content -split '\r?\n'    
$content[1..($content.Count - 2)]

# Output: Your mileage may vary
<#

$excelFile = "D:\mygit\PowerShellAI\Examples\yyz\salesData.xlsx"
$data = Import-Excel -Path $excelFile -WorksheetName "Sheet1"
$data | ForEach-Object { $_.Units = $_.Units * 1.2; $_ } | Format-Table

#>