function Get-Uptime
{
<#
.Synopsis
   Get Computer Uptime
.DESCRIPTION
   Get computer uptime using WMI
.EXAMPLE
    get-uptime -computername localhost
    
    ComputerName StartTime           Uptime (Days) Status
    ------------ ---------           ------------- ------
    localhost    17.06.2016 08:05:22 0,1           OK    
.EXAMPLE
   "localhost" | get-uptime -credential $creds

.NOTES
   Author: Simeon Iksanov
#>
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipelineByPropertyName=$True,
                   valuefromPipeline=$True,
                   Position=0)]
        [string[]]$Computername = $env:COMPUTERNAME,
        [System.Management.Automation.PSCredential]$Credential = [System.Management.Automation.PSCredential]::Empty
    )

    Begin
    {
    }
    Process
    {
        foreach ($ComputerItem in $Computername)
        {
            $wmi = $null
            $LastBootUpTime = $null
            $params = [ordered]@{
                        'ComputerName'  = $ComputerItem;
                        'StartTime'     = $null;
                        'Uptime (Days)' = $null;
                        'Status'        = $null;
                    }
            if (Test-Connection -ComputerName $ComputerItem -Count 1 -Quiet)
            {
                try
                {
                    $wmi = Get-WmiObject -ClassName Win32_OperatingSystem -ComputerName $ComputerItem -ErrorAction Stop -Credential $Credential
                    $LastBootUpTime = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
                    $params.'StartTime'     = $LastBootUpTime.ToString("dd.MM.yyyy HH:mm:ss");
                    $params.'Uptime (Days)' = [math]::Round((New-TimeSpan -Start $LastBootUpTime -End (Get-date)).TotalDays,2);
                    $params.'Status'        = 'OK';
                    
                }
                catch
                {
                    $params.'Status' = 'ERROR';
                }
                finally
                {
                    $Object = New-Object -TypeName PSCustomObject -Property $params
                    Write-Output $Object
                }
            }
            else
            {
                $params.'Status' = 'OFFLINE';
                $Object = New-Object -TypeName PSCustomObject -Property $params
                Write-Output $Object
            }
        }
    }
    End
    {
    }
}
