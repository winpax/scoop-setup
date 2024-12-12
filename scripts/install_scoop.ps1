param([switch]$RunAsAdmin)
if ($RunAsAdmin)
{
    Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
}
else
{
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

if (Test-Path install.ps1)
{
    Remove-Item install.ps1
}