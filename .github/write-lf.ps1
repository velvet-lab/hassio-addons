# write-lf.ps1 - Normalize files to LF line endings (CRLF -> LF).
#
# The editor/workspace writes CRLF on Windows, but rootfs/ scripts and
# .devcontainer/ files must be LF (CRLF breaks s6 / bash). This tool rewrites
# the given path(s) with LF line endings so we don't have to normalize by hand.
#
# Usage (from the repo root):
#   powershell -NoProfile -ExecutionPolicy Bypass -File .github/write-lf.ps1 <path> [<path> ...]
#
# <path> may be a single file or a directory (normalized recursively).
# Prints each processed file. Files that already are LF are left untouched.

# Collect the target paths from all arguments (the env var may split them).
$targets = New-Object System.Collections.ArrayList
foreach ($arg in @() + [System.Collections.ArrayList][array]$args) {
    $targets.Add([string]$arg)
}

if ($targets.Count -eq 0) {
    Write-Host "Usage: write-lf.ps1 <file-or-dir> [<file-or-dir> ...]"
    exit 1
}

$files = New-Object System.Collections.ArrayList

foreach ($t in $targets) {
    if ([System.IO.File]::Exists($t)) {
        $files.Add($t)
    } elseif ([System.IO.Directory]::Exists($t)) {
        # Recurse over the directory tree.
        $stack = New-Object System.Collections.ArrayList
        $stack.Add($t)
        while ($stack.Count -gt 0) {
            $dir = $stack[$stack.Count - 1]
            $stack.RemoveAt($stack.Count - 1)
            foreach ($entry in [System.IO.Directory]::List($dir)) {
                $full = [System.IO.Path]::Combine($dir, $entry)
                if ([System.IO.Directory]::Exists($full)) {
                    $stack.Add($full)
                } else {
                    $files.Add($full)
                }
            }
        }
    } else {
        Write-Host "WARN: not found: $t"
    }
}

foreach ($f in $files) {
    $b = [System.IO.File]::ReadAllBytes($f)
    $crlf = 0
    $out = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt $b.Count; $i++) {
        if ($b[$i] -eq 13 -and ($i + 1) -lt $b.Count -and $b[$i + 1] -eq 10) {
            $crlf++
            $out.Add(10)
            $i++
        } else {
            $out.Add($b[$i])
        }
    }
    if ($crlf -gt 0) {
        $outBytes = New-Object byte[] $out.Count
        for ($j = 0; $j -lt $out.Count; $j++) { $outBytes[$j] = $out[$j] }
        [System.IO.File]::WriteAllBytes($f, $outBytes)
        Write-Host "LF: $f ($crlf CRLF removed)"
    } else {
        Write-Host "ok (already LF): $f"
    }
}

Write-Host "Done. ($($files.Count) files checked)"