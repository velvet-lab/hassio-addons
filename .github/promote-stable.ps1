# promote-stable.ps1 - Promote add-ons from experimental to stable.
#
# Walks every add-on config.yaml in the repository and:
#   1. removes the "(experimental)" marker from the `name:` field
#   2. sets `stage:` to `stable`
#
# Only the top-level `name:` and `stage:` keys are touched; everything else
# (indentation, comments, ordering) is preserved. Files that are already
# stable are left untouched.
#
# Usage (from the repo root):
#   powershell -NoProfile -ExecutionPolicy Bypass -File .github/promote-stable.ps1
#
# Optional: pass one or more add-on folders to limit the scope, e.g.
#   powershell -NoProfile -ExecutionPolicy Bypass -File .github/promote-stable.ps1 .\gitea .\valkey

$ErrorActionPreference = 'Stop'

# Repo root = parent of the .github folder this script lives in.
$repoRoot = Split-Path -Parent $PSScriptRoot

# Collect target config.yaml files: either the given folders or the whole repo.
$targets = @() + [array]$args
$configs = New-Object System.Collections.ArrayList

if ($targets.Count -gt 0) {
    foreach ($t in $targets) {
        $path = $t
        if (-not [System.IO.Path]::IsPathRooted($path)) {
            $path = Join-Path $repoRoot $path
        }
        if ([System.IO.Directory]::Exists($path)) {
            $candidate = Join-Path $path 'config.yaml'
            if ([System.IO.File]::Exists($candidate)) {
                $configs.Add($candidate) | Out-Null
            } else {
                Write-Host "WARN: no config.yaml in: $path"
            }
        } elseif ([System.IO.File]::Exists($path)) {
            $configs.Add($path) | Out-Null
        } else {
            Write-Host "WARN: not found: $t"
        }
    }
} else {
    # Recurse the repo, skipping hidden folders (e.g. .git, .github, !obsolete).
    $stack = New-Object System.Collections.ArrayList
    $stack.Add($repoRoot) | Out-Null
    while ($stack.Count -gt 0) {
        $dir = $stack[$stack.Count - 1]
        $stack.RemoveAt($stack.Count - 1)
        foreach ($entry in [System.IO.Directory]::EnumerateFileSystemEntries($dir)) {
            $name = [System.IO.Path]::GetFileName($entry)
            if ([System.IO.Directory]::Exists($entry)) {
                if ($name.StartsWith('.')) { continue }
                $stack.Add($entry) | Out-Null
            } elseif ($name -eq 'config.yaml') {
                $configs.Add($entry) | Out-Null
            }
        }
    }
}

$changed = 0
$checked = 0

foreach ($file in $configs) {
    $checked++
    $lines = [System.IO.File]::ReadAllLines($file)
    $modified = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]

        # Top-level `name:` (no leading whitespace).
        if ($line -match '^name:\s*(.*)$') {
            $value = $Matches[1]
            $newValue = $value -replace '\s*\(experimental\)\s*', ' '
            $newValue = $newValue.TrimEnd()
            if ($newValue -ne $value) {
                $lines[$i] = "name: $newValue"
                $modified = $true
            }
            continue
        }

        # Top-level `stage:` (no leading whitespace).
        if ($line -match '^stage:\s*(.*)$') {
            $value = $Matches[1].Trim()
            if ($value -ne 'stable') {
                $lines[$i] = 'stage: stable'
                $modified = $true
            }
            continue
        }
    }

    if ($modified) {
        # Write back with LF line endings (repo convention for config files).
        $text = ($lines -join "`n") + "`n"
        [System.IO.File]::WriteAllText($file, $text, (New-Object System.Text.UTF8Encoding($false)))
        Write-Host "UPDATED: $file"
        $changed++
    } else {
        Write-Host "ok (already stable): $file"
    }
}

Write-Host "Done. ($checked files checked, $changed updated)"
