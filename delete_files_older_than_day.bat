REM Delete files older than 1 day in the folder specified.
REM /D -1 = (older than 1 day -  adjust accordingly) 

for /f "tokens=1" %a in ('dir f:\"Dimensions Daily Backups"\* /ad /b ') do ( forfiles -p "f:\Dimensions Daily Backups\%a" -s -m *.bak /D -1 /C "cmd /c del @path")
