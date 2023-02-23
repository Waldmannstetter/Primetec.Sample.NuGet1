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
            $env:AssemblyVersion = [version]$matches[1]

            if ($isRelease -eq $true) {
                $major = ([version]$result).Major
                $minor = ([version]$result).Minor
                $build = ([version]$result).Build

                $env:AssemblyVersion = New-Object -TypeName System.Version -ArgumentList "$major.$minor.$build.0"
            }
        }
    }
}
