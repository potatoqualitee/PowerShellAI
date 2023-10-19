function ConvertTo-JsonL {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject
    )

    begin {
        $sb = [System.Text.StringBuilder]::new()
    }

    process {
        foreach ($obj in $InputObject) {
            $null = $sb.AppendLine(($obj | ConvertTo-Json -Compress))
        }
    }

    end {
        $sb.ToString()
    }
}