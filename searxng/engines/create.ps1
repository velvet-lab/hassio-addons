$root = $PSScriptRoot
$module = "powershell-yaml"

$settingsUrl = "https://raw.githubusercontent.com/searxng/searxng/refs/heads/master/searx/settings.yml"
$configFile = Join-Path -Path $root -ChildPath "config.csv"
$extensionFile = Join-Path -Path $root -ChildPath "engines.extension.yaml"
$enginesFile = Join-Path -Path $root -ChildPath "engines.yaml"

if (-not (Get-Module -Name $module -ListAvailable)) {
    Install-Module $module
}

$settings = Invoke-WebRequest -Uri $settingsUrl | ConvertFrom-Yaml
$extension = Get-Content -Path $extensionFile | ConvertFrom-Yaml
$engines = $settings.engines

$config = Import-Csv -Path $configFile -Delimiter ";"

$result = @()
$config | Foreach-Object {
    $item = $_

    if ($null -ne $item.Enabled -and $item.Enabled -eq $true) {
        $extensionEngine = $extension.engines | Where-Object { $_.name -eq $item.Name }
        if ($extensionEngine) {
            $extensionEngine.Disabled = $false
            $extensionEngine.Inactive = $false
            $result += $extensionEngine
        }
        else {
            $engine = $engines | Where-Object { $_.Name -eq $item.Name }
            if ($engine) {
                $engine.Disabled = $false
                $engine.Inactive = $false
                $result += $engine
            }
            else {
                Write-Warning "Engine '$($item.Name)' not found in settings."
            }
        }
    }
    else {
        $result += @{
            "Name"     = $item.Name
            "Disabled" = $true
            "Inactive" = $true
        }
    }
}

# Write alle Keys toLower
$result = $result | ForEach-Object {
    $obj = $_
    $newObj = @{}
    foreach ($key in $obj.Keys) {
        $newObj[$key.ToLower()] = $obj[$key]
    }
    $newObj
}

ConvertTo-Yaml @{"engines" = $result } -OutFile $enginesFile -UseFlowStyle -Force
Write-Host "Engines YAML has been written to $enginesFile"