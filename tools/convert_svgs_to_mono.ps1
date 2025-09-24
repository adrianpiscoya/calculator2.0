<#
Batch-convert SVGs to monochrome/sanitized variants.
Creates files with suffix `.sanitized.svg` next to the original files.
What it does:
 - removes XML prolog and DOCTYPE
 - strips <style> and <defs> blocks
 - removes inline style attributes
 - removes width/height attributes on root elements
 - replaces explicit fills/strokes (#rrggbb or names) with `currentColor`
 - wraps root content with <g fill="currentColor" stroke="currentColor"> if needed

Usage (PowerShell):
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
  .\tools\convert_svgs_to_mono.ps1

Note: This is a best-effort sanitizer using regex. Complex Corel/Illustrator files
may still need manual tweaking or a dedicated tool (svgo/scour). Always keep backups.
#>

$root = Join-Path $PSScriptRoot '..\assets\icons\buttons' | Resolve-Path
Write-Host "Processing SVGs in: $root"
$files = Get-ChildItem -Path $root -Filter "*.svg" -File -Recurse
if ($files.Count -eq 0) {
    Write-Host "No SVG files found under $root"
    exit 0
}

foreach ($f in $files) {
    try {
        $s = Get-Content -Raw -Encoding UTF8 $f.FullName

        # Remove xml prolog and DOCTYPE
        $s = [regex]::Replace($s, '<\?xml[\s\S]*?\?>', '', 'IgnoreCase')
        $s = [regex]::Replace($s, '<!DOCTYPE[\s\S]*?>', '', 'IgnoreCase')

        # Remove style and defs blocks (multi-line)
        $s = [regex]::Replace($s, '<style[\s\S]*?<\/style>', '', 'IgnoreCase')
        $s = [regex]::Replace($s, '<defs[\s\S]*?<\/defs>', '', 'IgnoreCase')

        # Remove inline style attributes entirely (best-effort)
        $s = [regex]::Replace($s, 'style\s*=\s*"[^"]*"', '', 'IgnoreCase')
        $s = [regex]::Replace($s, "style\s*=\s*'[^']*'", '', 'IgnoreCase')

        # Remove width/height attributes (so viewBox governs sizing)
        $s = [regex]::Replace($s, '\s+(width|height)\s*=\s*"[^"]+"', '', 'IgnoreCase')
        $s = [regex]::Replace($s, "\s+(width|height)\s*=\s*'[^']+'", '', 'IgnoreCase')

        # Replace common fill/stroke hex values and names with currentColor
        $s = [regex]::Replace($s, 'fill\s*=\s*"#?[0-9a-fA-F]{3,8}"', 'fill="currentColor"', 'IgnoreCase')
        $s = [regex]::Replace($s, "fill\s*=\s*'#[0-9a-fA-F]{3,8}'", "fill='currentColor'", 'IgnoreCase')
        $s = [regex]::Replace($s, 'stroke\s*=\s*"#?[0-9a-fA-F]{3,8}"', 'stroke="currentColor"', 'IgnoreCase')
        $s = [regex]::Replace($s, "stroke\s*=\s*'#[0-9a-fA-F]{3,8}'", "stroke='currentColor'", 'IgnoreCase')

        # Replace common color names (black/white) used as fills
        $s = [regex]::Replace($s, 'fill\s*=\s*"(black|white|none)"', 'fill="currentColor"', 'IgnoreCase')
        $s = [regex]::Replace($s, "fill\s*=\s*'(black|white|none)'", "fill='currentColor'", 'IgnoreCase')
        $s = [regex]::Replace($s, 'stroke\s*=\s*"(black|white|none)"', 'stroke="currentColor"', 'IgnoreCase')
        $s = [regex]::Replace($s, "stroke\s*=\s*'(black|white|none)'", "stroke='currentColor'", 'IgnoreCase')

        # If the file does not already use currentColor, inject a wrapper group after <svg ...>
        if ($s -notmatch 'currentColor') {
            $s = [regex]::Replace($s, '(<svg[^>]*>)', '$1<g fill="currentColor" stroke="currentColor">', 'IgnoreCase')
            # close group before </svg>
            if ($s -match '</svg>') {
                $idx = $s.LastIndexOf('</svg>')
                if ($idx -ne -1) {
                    $s = $s.Substring(0, $idx) + '</g></svg>' + $s.Substring($idx + 6)
                }
            } else {
                $s = $s + '</g>'
            }
        }

        # Trim excessive whitespace
        $s = $s.Trim()

        # Write sanitized file next to original
        $out = Join-Path $f.DirectoryName ($f.BaseName + '.sanitized.svg')
        Set-Content -Path $out -Value $s -Encoding UTF8
        Write-Host "Processed: $($f.Name) -> $([IO.Path]::GetFileName($out))"
    } catch {
        Write-Warning "Failed processing $($f.FullName): $_"
    }
}

Write-Host "Done. Review the generated .sanitized.svg files in assets/icons/buttons/"
