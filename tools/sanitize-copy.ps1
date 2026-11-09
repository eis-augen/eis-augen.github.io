# Copia proyectos del Escritorio a showcases/ sin tocar originales.
$ErrorActionPreference = 'Stop'
$Desktop = [Environment]::GetFolderPath('Desktop')
$Root = Split-Path $PSScriptRoot -Parent
$Show = Join-Path $Root 'showcases'

$excludeDirs = @('node_modules', '.git', 'dist', 'build', 'target', '.venv', '__pycache__', 'release', '.gradle', 'secrets')

function Copy-Project($Name, $SrcRel, $DstName) {
    $src = Join-Path $Desktop $SrcRel
    if (-not (Test-Path $src)) { Write-Warning "No existe: $src"; return }
    $dst = Join-Path $Show $DstName
    if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
  $xd = ($excludeDirs | ForEach-Object { "/XD", $_ }) -join ' '
    robocopy $src $dst /E /COPY:DAT /R:1 /W:1 /NFL /NDL /NJH /NJS `
        /XD node_modules .git dist build target .venv __pycache__ release .gradle secrets 2>$null | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy falló para $Name" }
    Write-Host "OK $DstName"
}

New-Item -ItemType Directory -Path $Show -Force | Out-Null

Copy-Project 'Qyron' 'Qyron_Werke' 'qyron-werke'
Copy-Project 'Valknut' 'valknut_web' 'valknut-web'
Copy-Project 'DataCenter' 'data_center' 'data-center'
Copy-Project 'Zona7' 'zona7radio' 'zona7radio'
Copy-Project 'Latina' 'latina_live' 'latina-live'
Copy-Project 'MeineKleine' 'meine_kleine_world' 'meine-kleine-world'

$siss = Join-Path $Desktop 'SISS\traccar-web'
$sissDst = Join-Path $Show 'siss-fleet-platform'
if (Test-Path $siss) {
    New-Item -ItemType Directory -Path $sissDst -Force | Out-Null
    robocopy $siss $sissDst /E /COPY:DAT /XD node_modules .git build dist secrets .cursor `
        /XF '*.env' '*.pem' '*.key' '/XD rehearsal' 2>$null | Out-Null
    # Copiar solo docs públicos de rehearsal sin infra real
    $pub = Join-Path $sissDst 'docs-portfolio'
    New-Item -ItemType Directory -Path $pub -Force | Out-Null
    @('README.md', 'package.json', 'index.html') | ForEach-Object {
        $f = Join-Path $siss $_
        if (Test-Path $f) { Copy-Item $f (Join-Path $sissDst $_) -Force }
    }
    if (Test-Path (Join-Path $siss 'src')) {
        robocopy (Join-Path $siss 'src') (Join-Path $sissDst 'src') /E /XD node_modules 2>$null | Out-Null
    }
    Write-Host 'OK siss-fleet-platform (subset)'
}

$sdk = Join-Path $Desktop 'SISS\traccar-client-sdk'
if (Test-Path $sdk) {
    Copy-Project 'SDK' 'SISS\traccar-client-sdk' 'siss-mdm-sdk'
}

# Sanitizar texto en copias
$patterns = @(
    @{ Old = '89\.126\.249\.\d+'; New = '203.0.113.10' },
    @{ Old = '192\.168\.10\.\d+'; New = '10.20.30.40' },
    @{ Old = '201\.124\.21\.\d+'; New = '198.51.100.1' },
    @{ Old = 'valknutprotocol\.com\.mx'; New = 'ejemplo-protocolo.demo' },
    @{ Old = 'zona7radio\.com\.mx'; New = 'radio-ejemplo.demo' },
    @{ Old = 'ecuatorialradio'; New = 'host-ejemplo' }
)
Get-ChildItem $Show -Recurse -Include *.md,*.json,*.ts,*.tsx,*.js,*.jsx,*.py,*.toml,*.yaml,*.yml,*.env.example -ErrorAction SilentlyContinue |
    ForEach-Object {
        $c = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $c) { return }
        $n = $c
        foreach ($p in $patterns) { $n = $n -replace $p.Old, $p.New }
        if ($n -ne $c) { Set-Content -Path $_.FullName -Value $n -NoNewline }
    }

Write-Host 'Copias listas en showcases/'
