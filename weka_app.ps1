# VICOBA SYSTEM - inaweka alama ya app kwenye Desktop na Start Menu (Windows)
$ErrorActionPreference = 'Stop'
try {
    $dir  = Split-Path -Parent $MyInvocation.MyCommand.Path
    $html = Join-Path $dir 'index.html'
    if (-not (Test-Path $html)) { throw "index.html haipo kwenye folda hii: $dir" }
    $url  = ([System.Uri]$html).AbsoluteUri

    $candidates = @(
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
    )
    $browser = $null
    foreach ($c in $candidates) { if ($c -and (Test-Path $c)) { $browser = $c; break } }
    if (-not $browser) { throw 'Microsoft Edge au Google Chrome haikupatikana kwenye kompyuta hii.' }

    $icon  = Join-Path $dir 'icons\vicoba.ico'
    $shell = New-Object -ComObject WScript.Shell
    $places = @(
        (Join-Path ([Environment]::GetFolderPath('Desktop')) 'VICOBA SYSTEM.lnk'),
        (Join-Path ([Environment]::GetFolderPath('Programs')) 'VICOBA SYSTEM.lnk')
    )
    foreach ($p in $places) {
        $s = $shell.CreateShortcut($p)
        $s.TargetPath       = $browser
        $s.Arguments        = '--app="' + $url + '"'
        $s.WorkingDirectory = $dir
        $s.IconLocation     = $icon
        $s.Description      = 'VICOBA SYSTEM'
        $s.Save()
    }
    Write-Host ''
    Write-Host 'IMEKAMILIKA!' -ForegroundColor Green
    Write-Host 'Alama ya VICOBA SYSTEM imewekwa kwenye Desktop na kwenye Start Menu.'
    Write-Host 'Ifungue kama app nyingine yoyote.'
    Write-Host ''
    Write-Host 'Muhimu: usihamishe wala kufuta folda hii:'
    Write-Host "  $dir"
    Write-Host 'Ukiihamisha, endesha faili hili tena.'
}
catch {
    Write-Host ''
    Write-Host ('TATIZO: ' + $_.Exception.Message) -ForegroundColor Red
}
Write-Host ''
Read-Host 'Bonyeza Enter kufunga'
