function GetVersion {
    Param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$path,

        [Parameter(Mandatory = $true, Position = 1)]
        [bool]$isRelease
    )

    $pattern = '\[assembly: AssemblyVersion\("(.*)"\)\]'

    $env:AssemblyVersion = New-Object -TypeName System.Version -ArgumentList "0.0.0.0"

    (Get-Content $path) | ForEach-Object {
        if($_ -match $pattern) {
            if ($isRelease -eq $true) {
                $major = ([version]$result).Major
                $minor = ([version]$result).Minor
                $build = ([version]$result).Build

                $env:AssemblyVersion = New-Object -TypeName System.Version -ArgumentList "$major.$minor.$build.0"
            } else {
                $major = ([version]$result).Major
                $minor = ([version]$result).Minor
                $build = ([version]$result).Build
                $revision = ([version]$result).Revision

                $env:AssemblyVersion = New-Object -TypeName System.Version -ArgumentList "$major.$minor.$build-preview.$revision"
            }
        }
    }
}
