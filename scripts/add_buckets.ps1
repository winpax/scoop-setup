param([string]$buckets_string)

Import-Module "$($PSScriptRoot)\LogModule"

Write-Log "parameter: ${buckets_string}"
[string[]] $buckets = @()
if ($buckets_string)
{
    $buckets = $buckets_string.Split(' ')
}
Write-Log "buckets: ${buckets}"
if ($buckets.count -ge 1)
{
    $known_buckets = scoop bucket known
    foreach ($bucket in $buckets)
    {
        if ($null -eq ($known_buckets | Where-Object { $_ -eq $bucket }))
        {
            Write-Error "Bucket `"$bucket`" is unknown." -ErrorAction Stop
        }
        Write-Log "Adding `"${bucket}`" bucket"
        scoop bucket add $bucket
    }
}
