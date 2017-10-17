Import-CSV "c:\temp\Customattribute1.csv" | % {Set-Mailbox -identity $_.LANID -CustomAttribute10 $_.CA1}
