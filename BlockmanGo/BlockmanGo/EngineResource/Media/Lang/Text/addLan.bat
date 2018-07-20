@echo off
for %%i in (.\*.lang) do  echo. >>%%i && type in.txt >> %%i
echo "Successfully Added!"
pause