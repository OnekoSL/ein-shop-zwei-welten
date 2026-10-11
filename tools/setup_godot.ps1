#requires -Version 7.0
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$projectRoot = Split-Path -Parent $PSScriptRoot
$downloadDir = Join-Path $projectRoot '.tools\downloads'
$engineDir = Join-Path $projectRoot '.tools\godot-4.7.2'
$templateDir = Join-Path $env:APPDATA 'Godot\export_templates\4.7.2.stable'

function Get-VerifiedArchive {
    param([string]$Name, [string]$Url, [string]$Sha512)
    $archivePath = Join-Path $downloadDir $Name
    if (!(Test-Path -LiteralPath $archivePath -PathType Leaf)) {
        Write-Host "Lade $Name ..."
        Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $archivePath
    }
    if ((Get-FileHash -LiteralPath $archivePath -Algorithm SHA512).Hash -ne $Sha512) {
        throw "Pruefsumme stimmt nicht: $archivePath. Datei entfernen und Setup erneut starten."
    }
    return $archivePath
}

try {
    New-Item -ItemType Directory -Force -Path $downloadDir, $engineDir, $templateDir | Out-Null
    # SHA-512 values from the official 4.7.2-stable release's SHA512-SUMS.txt.
    $engineArchive = Get-VerifiedArchive -Name 'Godot_v4.7.2-stable_win64.exe.zip' `
        -Url 'https://downloads.godotengine.org/?version=4.7.2&flavor=stable&slug=win64.exe.zip&platform=windows.64' `
        -Sha512 '83decd58fdf67b9d657958a1ae6bf1929c20785315a81effe245874cdc57acb709bf868e00778a96984338c1b29dafdb453c6847747694621c6ecf5da2259993'
    $templateArchive = Get-VerifiedArchive -Name 'Godot_v4.7.2-stable_export_templates.tpz' `
        -Url 'https://downloads.godotengine.org/?version=4.7.2&flavor=stable&slug=export_templates.tpz&platform=templates' `
        -Sha512 'ca4d71c4d7b81dfc15d1a98baa07534aa95b03fdda78a0075b06672e1648d2e5f40980c9adc28d23e1b92e732ee7bf3461997aa804af74ec2fcd7a93ccb84079'

    Expand-Archive -LiteralPath $engineArchive -DestinationPath $engineDir -Force
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($templateArchive)
    try {
        foreach ($entry in $archive.Entries) {
            if ($entry.FullName -match '^templates/(version\.txt|windows_(debug|release)_x86_64(_console)?\.exe)$') {
                [IO.Compression.ZipFileExtensions]::ExtractToFile($entry, (Join-Path $templateDir $entry.Name), $true)
            }
        }
    } finally {
        $archive.Dispose()
    }
    if ((Get-Content -LiteralPath (Join-Path $templateDir 'version.txt') -Raw).Trim() -ne '4.7.2.stable') {
        throw 'Unerwartete Version in den Exportvorlagen.'
    }
    foreach ($template in @('windows_debug_x86_64.exe', 'windows_release_x86_64.exe')) {
        if (!(Test-Path -LiteralPath (Join-Path $templateDir $template))) {
            throw "Exportvorlage fehlt: $template"
        }
    }
    Write-Host "Godot 4.7.2 Standard bereit: $engineDir"
    Write-Host "Windows-x64-Exportvorlagen bereit: $templateDir"
} catch {
    Write-Error "Setup fehlgeschlagen: $($_.Exception.Message)" -ErrorAction Continue
    exit 1
}

exit 0
