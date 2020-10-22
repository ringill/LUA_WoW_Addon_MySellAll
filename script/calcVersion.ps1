# calculate build version
$buildNumber = (Get-Date).Year + ((Get-Date).Month * 31) + (Get-Date).Day
$buildNumberString = $env:MSA_VER + "." + $buildNumber.ToString()
# pass it into env. var.
$env:MSA_BUILD=$buildNumberString
