[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$jsonDir = "newtonsoft"
$jsonPath = "$jsonDir/lib/net40/Newtonsoft.Json.dll"
if (-not (Test-Path $jsonPath)) {
    $nupkg = "newtonsoft.json.zip"
    Invoke-WebRequest -Uri https://www.nuget.org/api/v2/package/Newtonsoft.Json/11.0.2 -OutFile $nupkg
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($nupkg, $jsonDir)
    Remove-Item -Force $nupkg
}

Add-Type -Path $jsonPath