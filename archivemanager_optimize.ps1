Get-Service | where {$_.name -eq 'Archive Full Text Index Service'} | Stop-Service -Force
while((Get-Service | where {$_.name -eq 'Archive Full Text Index Service'}).status -ne 'stopped')
{
      sleep -Seconds 1
      Write-Host "Busy stopping Service...."
}
Write-Host 'Archive Full Text Index Service stopped'
Get-Service | where {$_.name -eq 'Archive Full Text Search Service'} | Stop-Service -Force
while((Get-Service | where {$_.name -eq 'Archive Full Text Search Service'}).status -ne 'stopped')
{
      sleep -Seconds 1
      Write-Host "Busy stopping Service...."
}
Write-Host 'Archive Full Text Search Service Stopped'

& "C:\Program Files (x86)\Quest Software\ArchiveManager\Archive Full Text Index Service.exe" -console -optimize | Out-Null 
Write-Host 'Archive Optimization completed'

Get-Service | where {$_.name -eq 'Archive Full Text Search Service'} | Start-Service
while((Get-Service | where {$_.name -eq 'Archive Full Text Search Service'}).status -ne 'Running')
{
      sleep -Seconds 1
      Write-Host "Busy starting Service...."
}
Write-Host 'Archive Full Text Search Service Started'

Get-Service | where {$_.name -eq 'Archive Full Text Index Service'} | Start-Service
while((Get-Service | where {$_.name -eq 'Archive Full Text Index Service'}).status -ne 'Running')
{
      sleep -Seconds 1
      Write-Host "Busy starting Service...."
}
Write-Host 'Archive Full Text Index Service started'
