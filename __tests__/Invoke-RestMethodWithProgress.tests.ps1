Import-Module "$PSScriptRoot\..\PowerShellAI.psd1" -Force

Describe "Invoke-RestMethodWithProgress" -Tag InvokeRestMethodWithProgress {

    InModuleScope 'PowerShellAI' {

        $script:StartJobCommand = Get-Command "Start-Job"

        BeforeEach {
            Reset-APIEstimatedResponseTimes
        }

        It "should return the known response if the API call is successful" {
            
            Mock Start-Job {
                return & $script:StartJobCommand { }
            }
            
            Mock Receive-Job {
                return @{
                    Response = "a happy web response from a web server"
                }
            }

            $params = @{
                "Method" = "GET";
                "Uri" = "http://localhost";
            }
            
            $response = Invoke-RestMethodWithProgress -Params $params
            $response | Should -BeExactly "a happy web response from a web server"
        }

        It "should throw if the API call fails" {
            
            $params = @{
                "Method" = "GET"
                "Uri" = "yeet://the.yeet.scheme.is.not.supported"
            }

            Mock Start-Job {
                return & $script:StartJobCommand {
                    Invoke-RestMethod $using:params.Uri
                }
            }

            $errorRecord = { Invoke-RestMethodWithProgress -Params $params } | Should -Throw -PassThru
            $errorRecord.Exception.Message | Should -BeLike "*'yeet' scheme is not supported*"
        }

        Describe "Get-APIEstimatedResponseTime Tests" {
            It "should return default response time when there's no record for a specific endpoint" {
                $responseTime = Get-APIEstimatedResponseTime -Method "POST" -Uri "http://localhost/new-endpoint"
                $responseTime | Should -Be 10
            }
        }
        
        Describe "Set-APIResponseTime Tests" {
            It "should record response time for a specific endpoint" {
                Set-APIResponseTime -Method "PUT" -Uri "http://localhost/new-endpoint" -ResponseTimeSeconds 30
                $responseTime = Get-APIEstimatedResponseTime -Method "PUT" -Uri "http://localhost/new-endpoint"
                $responseTime | Should -Be 30
            }
        }
    }
}