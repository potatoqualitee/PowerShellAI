Describe 'Enable-ChatPersistence' -Tag ChatPersistence {

    AfterEach {
        Reset-ChatSessionOptions
    }

    It 'tests the function Enable-ChatPersistence exists' {
        $actual = Get-Command Enable-ChatPersistence -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'tests that it enables chat persistence' {
        Enable-ChatPersistence
        $actual = Get-ChatPersistence

        $actual | Should -Be $true
    }
}