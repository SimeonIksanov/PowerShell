function Get-HBAAdapterAttributes {  
    param(  
        [String[]]$ComputerName = $ENV:ComputerName
    )  
  
    ForEach ($Computer in $ComputerName) {  
        try { 
            $Params = @{ 
                Namespace    = 'root\WMI' 
                class        = 'MSFC_FCAdapterHBAAttributes' 
                ComputerName = $Computer  
                ErrorAction  = 'Stop' 
                } 
             
            Get-WmiObject @Params  | ForEach-Object {  
                    $hash=@{  
                        ComputerName     = $_.__SERVER  
                        NodeWWN          = (($_.NodeWWN) | ForEach-Object {"{0:X}" -f $_}) -join ":"  
                        Active           = $_.Active  
                        DriverName       = $_.DriverName  
                        DriverVersion    = $_.DriverVersion  
                        FirmwareVersion  = $_.FirmwareVersion  
                        Model            = $_.Model  
                        ModelDescription = $_.ModelDescription  
                        }  
                    New-Object psobject -Property $hash  
                }#Foreach-Object(Adapter)  
        }#try 
        catch { 
            Write-Warning -Message $_ 
        } 
    }#Foreach(Computer)  
}#Get-HBAWin
