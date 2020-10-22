FROM mcr.microsoft.com/powershell
COPY . ./home/
ENTRYPOINT [ "pwsh", "./home/script/build.ps1" ]