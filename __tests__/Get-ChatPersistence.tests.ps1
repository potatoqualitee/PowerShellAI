
Describe 'Get-ChatPersistence' -Tag ChatPersistence {
    It 'tests the function Get-ChatPersistence exists' {
        $actual = Get-Command Get-ChatPersistence -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'tests the function Get-ChatPersistence returns a boolean' {
        $actual = Get-ChatPersistence
        $actual.GetType().Name | Should -Be 'Boolean'
    }
}
