Write-Output $env:MSA_VER
$exitCode = 0;
try {
  . ./script/calcVersion.ps1
  $exitCode = $LastExitCode
}
catch {
  Write-Output $Error[0].Exception.Message
  exit $exitCode
}

Write-Output $env:MSA_BUILD
try {
  . ./script/build.ps1
  $exitCode = $LastExitCode
}
catch {
  Write-Output $Error[0].Exception.Message
  exit $exitCode
}
# try {
#   . ./script/publish.ps1
#   $exitCode = $LastExitCode
# }
# catch {
#   Write-Output $Error[0].Exception.Message
#   exit $exitCode
# }
