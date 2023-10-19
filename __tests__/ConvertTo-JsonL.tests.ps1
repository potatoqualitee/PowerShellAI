Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force


Describe "ConvertTo-JsonL" -Tag 'ConvertTo-JsonL' {

    It 'Tests ConvertTo-JsonL function exists' {
        $actual = Get-Command ConvertTo-JsonL -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Tests ConvertTo-JsonL has these parameters' {
        $actual = Get-Command ConvertTo-JsonL -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
        $keys = $actual.Parameters.Keys
        $keys.Contains('InputObject') | Should -BeTrue
    }

    It 'Tests ConvertTo-JsonL InputObject parameter has these attributes' {
        $actual = Get-Command ConvertTo-JsonL -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters['InputObject'].Attributes.Mandatory | Should -BeTrue
        $actual.Parameters['InputObject'].Attributes.ValueFromPipeline | Should -BeTrue
        $actual.Parameters['InputObject'].Attributes.ValueFromPipelineByPropertyName | Should -BeFalse
    }

    It 'Tests ConvertTo-JsonL returns a string of JsonL' {
        $actual = ConvertTo-JsonL -InputObject @(
            [Ordered]@{Name = 'Test'; Value = 'Test' }
        )
        $actual | Should -Not -BeNullOrEmpty
        $actual | Should -BeOfType [string]

        $result=$actual.Split([System.Environment]::NewLine)

        $result.Count | Should -Be 2
        $result[0] | Should -Be '{"Name":"Test","Value":"Test"}'
    }

    #     It 'Tests ConvertTo-JsonL handles more than one object' {
    #         $actual = ConvertTo-JsonL -InputObject @(
    #             @{Name = 'Test'; Value = 'Test' }
    #             @{Name = 'Test2'; Value = 'Test2' }
    #         )

    #         $expected = @"
    # {"Name":"Test","Value":"Test"}
    # {"Name":"Test2","Value":"Test2"}

    # "@
    #         $actual | Should -Not -BeNullOrEmpty
    #         $actual | Should -BeOfType [string]
    #         $actual | Should -Be $expected
    #     }

    #     It 'Tests ConvertTo-JsonL handles converted csv' {

    #         $data = ConvertFrom-Csv @"
    # Name,Value
    # Test,Test
    # Test2,Test2
    # "@
    #         $actual = ConvertTo-JsonL -InputObject $data

    #         $expected = @"
    # {"Name":"Test","Value":"Test"}
    # {"Name":"Test2","Value":"Test2"}

    # "@
        
    #         $actual | Should -Not -BeNullOrEmpty
    #         $actual | Should -BeOfType [string]
    #         $actual | Should -Be $expected
    #     }        
}