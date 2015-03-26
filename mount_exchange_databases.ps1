Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
$localServerName = Get-WmiObject -Class Win32_ComputerSystem | Select Name
[int]$hour = get-date -format HH
$DBS = Get-MailboxDatabase -Status -Server $localServerName.Name | Select Server,Name,Mounted | where {$_.Server -eq $localServerName.Name}

foreach($db in $dbs){


If($hour -gt 22 -or $hour -lt 4){ $Output = "Exchange Defrag taking place" }
    Else{
        If($db.Name -eq $null){
            $Output = "OK: No Databases are active on this host"
        }else{
            if($db.Mounted -ne $true){
                $Output += "CRITICAL: Database Name: " + $db.Name + " " + " is not mounted" + " "
            }else{
                $Output += "OK: Database Name: " + $db.Name + " "
            }
        
        }
   }
}
Write-Host $Output
