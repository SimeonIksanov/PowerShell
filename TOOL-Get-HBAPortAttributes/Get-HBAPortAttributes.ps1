function Get-HBAPortAttributes
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipelineByPropertyName=$true, Position=0)]
        [string[]]$Computername = $env:COMPUTERNAME
    )

    Begin
    {
        $HBA_PORTSTATE = @{
            1 = "Unknown";
            2 = "Operational";
            3 = "User Offline"; 
            4 = "Bypassed";
            5 = "In diagnostics mode";
            6 = "Link Down";
            7 = "Port Error";
            8 = "Loopback";
        }
        $HBA_PORTTYPE = @{
            1 = "Unknown";
            2 = "Other";
            3 = "Not present";
            5 = "Fabric";
            6 = "Public Loop";
            7 = "HBA_PORTTYPE_FLPORT";
            8 = "Fabric Port";
            9 = "Fabric expansion port";
            10 = "Generic Fabric Port";
            20 = "Private Loop";
            21 = "Point to Point";
        }
    }
    Process
    {
        foreach ($Computer in $Computername) {
            $PortWNNParams = @{ 
                    Namespace    = 'root\WMI' 
                    class        = 'MSFC_FibrePortHBAAttributes' 
                    ComputerName = $Computer  
                    ErrorAction  = 'Stop' 
                    }
            try {
                Get-WmiObject @PortWNNParams | ForEach-Object {
                    $hash = [ordered]@{
                        PortWWN = ($_.Attributes.PortWWN | foreach {"{0:X}" -f $_}) -join ":";
                        NodeWWN = ($_.Attributes.NodeWWN | foreach {"{0:X}" -f $_}) -join ":";
                        PortSpeed = "$($_.Attributes.portspeed)";
                        PortSupportedSpeed = $_.Attributes.PortSupportedSpeed;
                        NumberofDiscoveredPorts = $_.Attributes.NumberofDiscoveredPorts;
                        PortState = $HBA_PORTSTATE[[int]$_.Attributes.PortState];
                        PortType = $HBA_PORTTYPE[[int]$_.Attributes.PortType];
                        ComputerName     = $_.__SERVER;
                    }
                    New-Object -TypeName PSCustomObject -Property $hash
                }
            } catch {
                Write-Warning "$computer : $_"
            }
        }
    }
    End
    {
    }
}
