Param
(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$path,

    [Parameter(Mandatory = $true, Position = 1)]
    [bool]$isRelease
)

function Get-Version {
    Param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$path,

        [Parameter(Mandatory = $true, Position = 1)]
        [bool]$isRelease
    )

    $pattern = '\[assembly: AssemblyVersion\("(.*)"\)\]'

    $version = New-Object -TypeName System.Version -ArgumentList "0.0.0.0"

    (Get-Content $path) | ForEach-Object {
        if($_ -match $pattern) {
            if ($isRelease -eq $true) {
                $version = $matches[1]
            } else {
                $major = ([version]$matches[1]).Major
                $minor = ([version]$matches[1]).Minor
                $build = ([version]$matches[1]).Build

                $version = $major.ToString() + "." + $minor.ToString() + "." + $build.ToString() + "-preview." + $([System.DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))
            }
        }
    }

    return $version
}

return Get-Version $path $isRelease
