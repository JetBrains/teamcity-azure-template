param (
    [string]$cloudConfigFile = 'cloud-config.yaml',
    [string]$templateFile = 'azuredeploy.json'
)

if (!(Test-Path $cloudConfigFile)) {
    Write-Host "Cloud config file '$cloudConfigFile' is not accessible"
    exit 1
}

Write-Host "Updating $templateFile file"

$replacementTokens = @{
    "%RDSHost%" = "',variables('dbServerName'),'";
    "%RDSPassword%" = "',replace(parameters('databasePassword'), '\\', '\\\\'),'";
    "%RDSDataBase%" = "',variables('dbName'),'";
    "%CORE_USER%" = "',parameters('VMAdminUsername'),'";
    '$' = '$$';
}

$content = Get-Content -Path $cloudConfigFile -Raw
$json = ConvertTo-Json $content.replace("'", "''")
$json = $json.substring(1, $json.length - 2)

Foreach ($key in $replacementTokens.keys) {
    $json = $json.replace($key, $replacementTokens.Item($key))
}

$customData = "[base64(concat('$json'))]"

$template = (Get-Content $templateFile -Raw).Trim()
($template -replace '("customData": )("\[base64.+?\]")', ('$1"' + $customData + '"')) | Set-Content $templateFile

Write-Host "$templateFile file was updated"