# Show a list of disabled users and then delete their home directories

Get-ADUser -filter 'enabled -eq $false' -properties Name, homedirectory -SearchBase "OU=Avanta_UK,OU=_Avanta_Group,DC=avanta,DC=co,DC=uk" | % { Write-Host ("Removing homdir for:" + $_.Name + ",path:" + $_.homedirectory) rm -Force -Recurse $_.homedirectory }
