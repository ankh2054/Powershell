# Script will import details from list.csv and input into html email and send. See email.html and list.csv.
$html = (Get-Content .\email.html)
Import-Csv .\list.csv |
ForEach-Object {
    Send-MailMessage -SmtpServer 10.1.1.26 -Subject "Logon details" -From charles@avanta.co.uk  -To $_.email -Priority: High -BodyAsHtml ($html -f $_.name, $_.username, $_.password);
}
