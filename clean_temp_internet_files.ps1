$localServerName = Get-WmiObject -Class Win32_ComputerSystem | Select Name
foreach($disk in gwmi win32_logicaldisk -ComputerName $localServerName.Name | where {$_.drivetype -eq 3} | select caption,size,freespace)
{
If($hour -gt 7 -or $hour -lt 19){ $Output = "Not set to execute during office hours " }
    Else{

            if(($disk.freespace/$disk.size)*100 -lt 2 -and $disk.caption -eq 'C:')
            {
                  foreach($USER in (gci "c:\Users" | where {$_.mode -eq 'd----' -and $_.name} | select name))
                  {
                        $FOLDER = 'c:\Users\' + $USER.name + '\AppData\Local\Microsoft\Windows\Temporary Internet Files'
                        gci -recurse $FOLDER | Remove-Item -recurse 
                        $FOLDER = 'c:\Users\' + $USER.name + '\AppData\Local\Microsoft\Windows\WER\ReportQueue '
                        gci -recurse $FOLDER | Remove-Item -recurse 
                  }
            }
      }
}
Write-Host $Output
