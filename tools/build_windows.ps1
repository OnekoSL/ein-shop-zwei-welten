#requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$GodotExe
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$gameDir = Join-Path $projectRoot 'game'
$buildRoot = Join-Path $projectRoot 'build\windows'
$buildStage = $null

function Invoke-GodotChecked {
    param([string[]]$Arguments, [string]$Step)
    $oldPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = @(& $script:enginePath @Arguments 2>&1)
        $commandExit = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
    }
    $lines = @($output | ForEach-Object { $_.ToString() })
    $lines | Set-Content -LiteralPath (Join-Path $script:logDir "$Step.log") -Encoding UTF8
    if ($commandExit -ne 0 -or ($lines -match '(SCRIPT ERROR:|(^|\s)ERROR:)')) {
        $lines | ForEach-Object { Write-Host $_ }
        throw "$Step fehlgeschlagen (Exit $commandExit). Siehe build/windows/logs/$Step.log."
    }
    Write-Host "$Step erfolgreich."
}

function Remove-GeneratedDirectory {
    param([string]$Path)
    $resolved = [IO.Path]::GetFullPath($Path)
    $allowed = [IO.Path]::GetFullPath($buildRoot).TrimEnd('\') + '\'
    if (!$resolved.StartsWith($allowed, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Loeschen ausserhalb des Buildordners verweigert: $resolved"
    }
    if (Test-Path -LiteralPath $resolved) {
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}

try {
    if (!(Test-Path -LiteralPath $GodotExe -PathType Leaf)) {
        throw "Godot wurde nicht gefunden: $GodotExe. Zuerst tools/setup_godot.ps1 ausfuehren."
    }
    $script:enginePath = (Resolve-Path -LiteralPath $GodotExe).Path
    $versionOutput = @(& $script:enginePath --version 2>&1)
    $versionExit = $LASTEXITCODE
    $engineVersion = ($versionOutput -join "`n").Trim()
    if ($versionExit -ne 0 -or $engineVersion -notmatch '^4\.7\.2\.stable\.official\.[a-f0-9]+$') {
        throw "Benoetigt wird Godot 4.7.2 Standard. Gefunden: $engineVersion"
    }
    $templatePath = Join-Path $env:APPDATA 'Godot\export_templates\4.7.2.stable\windows_release_x86_64.exe'
    if (!(Test-Path -LiteralPath $templatePath -PathType Leaf)) {
        throw "Exportvorlage fehlt: $templatePath. tools/setup_godot.ps1 ausfuehren."
    }
    $projectText = Get-Content -LiteralPath (Join-Path $gameDir 'project.godot') -Raw -Encoding UTF8
    $versionMatch = [regex]::Match($projectText, '(?m)^config/version="(\d+\.\d+\.\d+)"\r?$')
    if (!$versionMatch.Success) { throw 'Keine gueltige Prototypversion in project.godot gefunden.' }
    $appVersion = $versionMatch.Groups[1].Value
    $packageName = "EinShopZweiWelten-$appVersion"
    $releaseDir = Join-Path $buildRoot $packageName
    $archivePath = Join-Path $buildRoot "$packageName-windows-x64.zip"
    $buildStage = Join-Path $buildRoot ('.staging-' + [guid]::NewGuid().ToString('N'))
    $script:logDir = Join-Path $buildRoot 'logs'
    New-Item -ItemType Directory -Force -Path $buildStage, $script:logDir | Out-Null

    Invoke-GodotChecked -Step 'import' -Arguments @('--headless', '--path', $gameDir, '--editor', '--import')
    $stageExe = Join-Path $buildStage 'EinShopZweiWelten.exe'
    Invoke-GodotChecked -Step 'export' -Arguments @('--headless', '--path', $gameDir, '--export-release', 'Windows Desktop', $stageExe)
    foreach ($file in @($stageExe, (Join-Path $buildStage 'EinShopZweiWelten.pck'))) {
        if (!(Test-Path -LiteralPath $file -PathType Leaf) -or (Get-Item -LiteralPath $file).Length -eq 0) {
            throw "Exportdatei fehlt oder ist leer: $file"
        }
    }
    Copy-Item -LiteralPath (Join-Path $projectRoot 'legal\GODOT_LICENSE.txt'), (Join-Path $projectRoot 'legal\GODOT_COPYRIGHT.txt') -Destination $buildStage
    Copy-Item -LiteralPath (Join-Path $projectRoot 'tools\build-readme.txt') -Destination (Join-Path $buildStage 'LIESMICH.txt')
    @("Ein Shop, zwei Welten $appVersion", "Engine: $engineVersion", 'Plattform: Windows x86_64', 'Renderer: Compatibility') |
        Set-Content -LiteralPath (Join-Path $buildStage 'BUILDINFO.txt') -Encoding UTF8
    # Publish only after import/export have both succeeded. Never include stale files.
    Remove-GeneratedDirectory -Path $releaseDir
    Move-Item -LiteralPath $buildStage -Destination $releaseDir
    $buildStage = $null
    Compress-Archive -LiteralPath $releaseDir -DestinationPath $archivePath -Force
    $checksum = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
    "$checksum  $([IO.Path]::GetFileName($archivePath))" | Set-Content -LiteralPath "$archivePath.sha256" -Encoding ASCII
    Write-Host "Testbuild: $releaseDir"
    Write-Host "ZIP: $archivePath"
} catch {
    Write-Error "Build fehlgeschlagen: $($_.Exception.Message)" -ErrorAction Continue
    exit 1
} finally {
    if ($null -ne $buildStage -and (Test-Path -LiteralPath $buildStage)) {
        Remove-GeneratedDirectory -Path $buildStage
    }
}

exit 0
