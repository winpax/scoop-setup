param(
    [Parameter()]
    [string]$apps_string = $(throw 'apps parameter is necessary.')
)

Import-Module "$($PSScriptRoot)\LogModule"

Write-Log "parameter: ${apps_string}"
[string[]] $apps = @()
if ($apps_string)
{
    $apps = $apps_string.Split(' ')
}
Write-Log "apps: ${apps}"
foreach ($app in $apps)
{
    if ($app -inotmatch '^\w[\w/.@-]+$')
    {
        Write-Error "Illegal app name `"$app`"." -ErrorAction Stop
    }
    Write-Log "Installing `"${app}`""
    scoop install $app
}
