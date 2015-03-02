REM Be carefull running this command
REM Delets the temporary internet files from the User directories on Terminal Server

for /f "tokens=1" %a in ('dir c:\users\* /ad /b ') do cd C:\Users\%a\AppData\Local\Microsoft\Windows\Temporary Internet Files & del /s /q *.*
