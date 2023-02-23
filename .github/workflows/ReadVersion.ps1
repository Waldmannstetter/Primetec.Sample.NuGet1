$pathTest = "C:\Dev\Primetec.Sample.NuGet1\Primetec.Sample.NuGet1.Core\AssemblyInfo.cs"

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

    $result = New-Object -TypeName System.Version -ArgumentList "0.0.0.0"

    (Get-Content $path) | ForEach-Object {
        if($_ -match $pattern) {
            $result = [version]$matches[1]
            
            if ($isRelease -eq $true) {
                $major = ([version]$result).Major
                $minor = ([version]$result).Minor
                $build = ([version]$result).Build

                $result = New-Object -TypeName System.Version -ArgumentList "$major.$minor.$build.0"
            }
        }
    }

    $Env:AssemblyVersion = $result
    
    Write-Host $result
}


