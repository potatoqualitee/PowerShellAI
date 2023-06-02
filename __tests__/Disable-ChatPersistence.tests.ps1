Describe 'Disable-ChatPersistence' -Tag ChatPersistence {

    BeforeEach {
        Reset-ChatSessionOptions
    }
    

    It 'tests the function Disable-ChatPersistence exists' {
        $actual = Get-Command Disable-ChatPersistence -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'tests that it disables chat persistence' {
        Disable-ChatPersistence
        $actual = Get-ChatPersistence

        $actual | Should -Be $false
    }
}