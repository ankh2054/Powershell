######################################################################
#
# This script will find the 25 (default) largest files and then list the
# folders sizes of the c:\ drive (default). The results will be written to a
# formatted text file. At the end of the script is an option to scan and list
# the size of all sub folders within a particular folder, output will be 
# appended to the txt file generated during the initial scan.
#
# Author: Rob Willis 7/8/2014
#
######################################################################

# Output location for for file and folder scan...
$findFilesFoldersOutput = "C:\findLargeFilesFolders.txt";

# Drive Scan Settings
#
# Drive to Scan
$diskDrive = "C:"

# File Scan Settings
#
# Path to Search
$filesLocation = "C:\";
# Minimum file size
$fileSize = 10MB;
# Limit number of rows on output
$filesLimit = 25;
# Search for specific file extensions - Default *.*
$extension = "*.*";
# Set output width
$outputWidth = 150;

# Folder Scan Settings
#
# Root location to scan for folder size
$rootLocation = "C:\";

# Do not edit below!

###################################
# Elevate Privileges
###################################

#Remove stale output file
Remove-Item $findFilesFoldersOutput 2> $null
Write-Host "Attempting to run as Admin..."
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   # Exit from the current, unelevated, process
   exit
   }


###################################
# Top Largest Files Scan
###################################

Function fileScan {
Write-Host " "
Write-Host "Scanning $filesLocation for the $filesLimit largest files, this process will take a few minutes..."
"Below are the $filesLimit largest files on $filesLocation from largest to smallest:" | out-file -width $outputWidth $findFilesFoldersOutput -append
$largeSizefiles = get-ChildItem -path $filesLocation -include $Extension -recurse -ErrorAction "SilentlyContinue" | ? { $_.GetType().Name -eq "FileInfo" } | where-Object {$_.Length -gt $fileSize} | sort-Object -property length -Descending | Select-Object Name, @{Name="Size In MB";Expression={ "{0:N0}" -f ($_.Length / 1MB)}},@{Name="LastWriteTime";Expression={$_.LastWriteTime}},@{Name="Path";Expression={$_.directory}} -first $filesLimit
$largeSizefiles | format-list -property Name,"Size In MB",Path,LastWriteTime | out-file -width $outputWidth $findFilesFoldersOutput -append
Write-Host " "
Write-Host "File Scan Complete..."
Write-Host " "
}

###################################
# Top Largest Folders Scan
###################################

Function folderScan {
$subDirectories = Get-ChildItem $rootLocation | Where-Object{($_.PSIsContainer)} | foreach-object{$_.Name}
Write-Host "Calculating folder sizes for $rootLocation,"
Write-Host "this process will take a few minutes..."
"Estimated subfolder sizes for $rootLocation :" | out-file -width $outputWidth $findFilesFoldersOutput -append
Write-Host " "
" "  | out-file -width $outputWidth $findFilesFoldersOutput -append
$folderOutputFixed = @{}
foreach ($i in $subDirectories)
	{
	$targetDir = $rootLocation + $i
	$folderSize = (Get-ChildItem $targetDir -Recurse -Force | Measure-Object -Property Length -Sum).Sum 2> $null
    $folderSizeComplete = "{0:N0}" -f ($folderSize / 1MB) + "MB"
	$folderOutputFixed.Add("$targetDir" , "$folderSizeComplete")
	write-host " Calculating $targetDir..."
}
$folderOutputFixed.GetEnumerator() | sort-Object Name | format-table -autosize | out-file -width $outputWidth $findFilesFoldersOutput -append
Write-Host " "
Write-Host "Attempting to open scan results with notepad..."
c:\windows\system32\notepad.exe "$findFilesFoldersOutput"
Write-Host " "
Write-Host "Scan saved to: $findFilesFoldersOutput..."
Write-Host " "
}



# Pause
Function Pause {
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Execute the functions
# Comment out any of the below functions to prevent them from running
#driveScan
fileScan
folderScan





