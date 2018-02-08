param (
    [string]$cloudConfigFile = 'cloud-config.yaml'
)

if (!(Test-Path $cloudConfigFile)) {
    Write-Host "Cloud config file '$cloudConfigFile' is not accessible"
    exit 1
}

$replacementTokens = @{
    "%RDSHost%" = "',variables('dbServerName'),'";
    "%RDSPassword%" = "',replace(parameters('databasePassword'), '\\', '\\\\'),'";
    "%RDSDataBase%" = "',variables('dbName'),'";
}

$content = Get-Content -Path $cloudConfigFile -Raw
$json = ConvertTo-Json $content.replace("'", "''")
$json = $json.substring(1, $json.length - 2)

Foreach ($key in $replacementTokens.keys) {
    $json = $json.replace($key, $replacementTokens.Item($key))
}

Write-Host "[base64(concat('$json'))]"