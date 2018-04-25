param (
    [string]$releasesUrl
)

$templateFile = 'createUiDefinition.json'

Write-Host "Updating $templateFile file"

. ./newtonjson.ps1

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

$template = [Newtonsoft.Json.JsonConvert]::DeserializeObject((Get-Content $templateFile -Raw), [Newtonsoft.Json.Linq.JObject])
$template.parameters.basics[1].defaultValue = $versions[0]
$template.parameters.basics[1].constraints.allowedValues.clear()
foreach($version in $versions) {
    $jo = New-Object -TypeName Newtonsoft.Json.Linq.JObject
    $jo.label = $version
    $jo.value = $version
    $template.parameters.basics[1].constraints.allowedValues.add($jo)
}

[Newtonsoft.Json.JsonConvert]::SerializeObject($template, [Newtonsoft.Json.Formatting]::Indented) | Set-Content $templateFile

Write-Host "$templateFile file was updated"