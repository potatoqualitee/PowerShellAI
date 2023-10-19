<#
.SYNOPSIS
Converts a collection of PowerShell objects to a single line JSON string.

.DESCRIPTION
The ConvertTo-JsonL function takes a collection of PowerShell objects and converts them to a single line JSON string. This is useful for scenarios where you need to pass JSON data as a command line argument or when you need to write JSON data to a file.

.PARAMETER InputObject
The collection of PowerShell objects to convert to JSON.

.EXAMPLE
PS C:\> Get-Process | ? Company| select Company, name,Handles -First 5 | ConvertTo-JsonL
{"Company":"Microsoft Corporation","Name":"ai","Handles":191}
{"Company":"Microsoft Corporation","Name":"ApplicationFrameHost","Handles":425}
{"Company":"Dell Technologies","Name":"AWCC","Handles":866}
{"Company":"Dell Technologies","Name":"AWCC.Background.Server","Handles":1086}
{"Company":"A-Volute","Name":"awscns","Handles":948}

Converts the output of Get-Process to a single line JSON string.
#>


# Define the function ConvertTo-JsonL
function ConvertTo-JsonL {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject # The collection of PowerShell objects to convert to JSON.
    )

    begin {
        $sb = [System.Text.StringBuilder]::new() # Create a new StringBuilder object to store the JSON string.
    }

    process {
        foreach ($obj in $InputObject) { # Loop through each object in the collection.
            $null = $sb.AppendLine(($obj | ConvertTo-Json -Compress)) # Convert the object to JSON and append it to the StringBuilder object.
        }
    }

    end {
        $sb.ToString() # Convert the StringBuilder object to a string and return it.
    }
}