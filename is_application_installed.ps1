#Set CSV-filename and path
$CSVFile = ".\test.csv"
 
#Select computers from .txt source-file
$machines = get-content ".\computers.txt"
 
#Create CSV-tables and descriptions
"Computer name,WMI-Model,AppInstalled" | out-file -FilePath $CSVFile -append
 
#For each computer in .txt do the following check(s)
foreach ($machine in $machines) 
 
{
 
#Example: Check if computer alive and reachable. 
$result = $true
try { Test-Connection -count 1 $machine -ErrorAction Stop }
catch { $result = $false }
 
if ($result -eq "true")
 
#Do the following checks if the computer is reachable: 
 
{


#Example #4: Get information from remote WMI
$WMI = (Get-WmiObject Win32_ComputerSystem -computername $machine | Select-Object -property "Model").Model
 

 
#Example #7: Get Installed application (MSI/ARP)
$Application = "LogMein Backup"
$AppInstalled = (Get-WmiObject Win32_Product -ComputerName "$machine" | Where-Object {$_.Name -eq "$Application"}).name
if ($AppInstalled -eq "$Application")
{$AppInstalled = "Installed"}
else
{$AppInstalled = "Not installed"}
 
### When all information is collected - write results to CSV file:
"{0},{1},{2}" -f $Machine,$WMI,$AppInstalled | out-file -FilePath $CSVFile -append
 
}
 
#Skips getting information if computer is unreachable:
 
else
 
    {
        #Computer is not alive - create message in CSV-file (optional)
        #"{0},{1}" -f $Machine,"Computer is turned off or without network connection" | out-file -FilePath .\test.csv -append
    }
}
