#OFFICE365
Import-CSV "c:\temp\Customattribute1.csv" | % {Set-Mailbox -identity $_.LANID -CustomAttribute10 $_.CA1}


#Local Active Directory
Import-CSV c:\temp\users.csv | Foreach { Set-ADUSer -Identity $_.samaccountname -Department $_.Department }
