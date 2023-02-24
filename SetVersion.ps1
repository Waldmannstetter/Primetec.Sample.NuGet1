Param
(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$path,

    [Parameter(Mandatory = $true, Position = 1)]
    [bool]$isRelease
)

function SetEnvVersion {
    Param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$path,

        [Parameter(Mandatory = $true, Position = 1)]
        [bool]$isRelease
    )

    $pattern = '\[assembly: AssemblyVersion\("(.*)"\)\]'

    $Env:Version = New-Object -TypeName System.Version -ArgumentList "0.0.0.0"

    (Get-Content $path) | ForEach-Object {
        if($_ -match $pattern) {
            if ($isRelease -eq $true) {
                $Env:Version = $matches[1]
            } else {
                $major = ([version]$matches[1]).Major
                $minor = ([version]$matches[1]).Minor
                $build = ([version]$matches[1]).Build

                $Env:Version = $major.ToString() + "." + $minor.ToString() + "." + $build.ToString() + "-preview." + $([System.DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))
            }
        }
    }

    Write-Host $Env:Version
}

SetEnvVersion $path $isRelease
