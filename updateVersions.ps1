param (
    [string]$releasesUrl,
    [string]$templateFile = 'createUiDefinition.json'
)

Write-Host "Updating $templateFile file"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$json = Invoke-WebRequest $releasesUrl | ConvertFrom-Json

# Select last two major releases
$groups = $json.TC | Group-Object -Property majorVersion | Select-Object -First 2
$versions = New-Object System.Collections.ArrayList

foreach($group in $groups) {
    foreach($release in $group.Group) {
        $versions.add($release.version) > $null
    }
}

Write-Host "Will set the following versions: $versions"

$template = Get-Content $templateFile -Raw | ConvertFrom-Json
$template.parameters.basics[0].defaultValue = $versions[0]
$template.parameters.basics[0].constraints.allowedValues = $versions | % { @{ label = $_; value = $_; } }
$template | ConvertTo-Json -Depth 20 | Set-Content $templateFile

Write-Host "$templateFile file was updated"