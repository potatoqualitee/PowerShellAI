# Start with a guess at how long this API call will take
$script:DefaultResponseTimeSeconds = 10
$script:EndpointResponseTimeSeconds = @{}

function Reset-APIEstimatedResponseTimes {
    $script:DefaultResponseTimeSeconds = 10
    $script:EndpointResponseTimeSeconds = @{}    
}

function Get-APIEstimatedResponseTime {
    param (
        [string] $Method,
        [string] $Uri
    )

    $endpointResponseTimeKey = $Method + $Uri
    $estimatedResponseTime = $script:EndpointResponseTimeSeconds[$endpointResponseTimeKey]

    if($null -eq $estimatedResponseTime -or $estimatedResponseTime -lt $script:DefaultResponseTimeSeconds) {
        $estimatedResponseTime = $script:DefaultResponseTimeSeconds
    }

    return $estimatedResponseTime
}

function Set-APIResponseTime {
    param (
        [string] $Method,
        [string] $Uri,
        [int] $ResponseTimeSeconds
    )

    $endpointResponseTimeKey = $Method + $Uri
    $script:EndpointResponseTimeSeconds[$endpointResponseTimeKey] = $ResponseTimeSeconds
}

function Invoke-RestMethodWithProgress {
    param (
        [hashtable] $Params
    )

    $estimatedResponseTime = Get-APIEstimatedResponseTime -Method $Params["Method"] -Uri $Params["Uri"]

    try {
        [Console]::CursorVisible = $false
        $job = Start-Job {
            $restParameters = $using:Params
            $response = Invoke-RestMethod @restParameters
            return @{
                Response = $response
            }
        }

        $start = Get-Date
        
        while($job.State -eq "Running") {
            $percent = ((Get-Date) - $start).TotalSeconds / $estimatedResponseTime * 100
            
            # Slow the progress towards the end of the progress bar because the api is a bit all over the show for response times, this makes sure the bar doesn't fill up linearly
            $logPercent = [int][math]::Min([math]::Max(1, $percent * [math]::Log(1.5)), 100)
            $status = "$logPercent% Completed {$($job.State)}"
            if($logPercent -eq 100) {
                $status = "API is taking longer than expected"
            }
            Write-Progress -Id 1 -Activity "Invoking AI" -Status $status -PercentComplete $logPercent
            Start-Sleep -Milliseconds 50
        }
        Write-Progress -Id 1 -Activity "Invoking AI" -Completed

        if($job.State -eq "Failed") {
            throw $job.ChildJobs[0].JobStateInfo.Reason
        }

        Set-APIResponseTime -Method $Params["Method"] -Uri $Params["Uri"] -ResponseTimeSeconds ((Get-Date) - $start).TotalSeconds

        $response = (Receive-Job $job).Response

        return $response
    } catch {
        throw $_
    } finally {
        [Console]::CursorVisible = $false
        Stop-Job $job -ErrorAction "SilentlyContinue"
        Remove-Job $job -Force -ErrorAction "SilentlyContinue"
    }
}