# Script para generar build web y crear ZIP
# Ejecutar: .\generar_build.ps1
# Opciones:
#   .\generar_build.ps1 -FastLoad           # Usa renderer HTML (~1.5 MB menos, carga rapida)
#   .\generar_build.ps1 -InstagramCompat    # Usa CanvasKit (mejor en WebView Instagram/Facebook)
#   .\generar_build.ps1                     # Default (auto)

param(
    [switch]$FastLoad,       
    [switch]$InstagramCompat 
)

Write-Host "Generando build web de Flutter..." -ForegroundColor Cyan

# Intentar encontrar Flutter
$flutterPaths = @(
    "$env:LOCALAPPDATA\fvm\default\bin\flutter.bat",
    "C:\src\flutter\bin\flutter.bat",
    "C:\flutter\bin\flutter.bat",
    "$env:USERPROFILE\flutter\bin\flutter.bat"
)

$flutterCmd = $null
foreach ($path in $flutterPaths) {
    if (Test-Path $path) {
        $flutterCmd = $path
        Write-Host "Flutter encontrado en: $path" -ForegroundColor Green
        break
    }
}

# Si no se encuentra, intentar con PATH
if (-not $flutterCmd) {
    try {
        $flutterCheck = Get-Command flutter -ErrorAction Stop
        $flutterCmd = "flutter"
        Write-Host "Flutter encontrado en PATH" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Flutter no encontrado. Asegúrate de tenerlo instalado y en las variables de entorno." -ForegroundColor Red
        exit 1
    }
}

# Limpiar build anterior
Write-Host "Limpiando build anterior (flutter clean)..." -ForegroundColor Cyan
& $flutterCmd clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "Advertencia: flutter clean falló, continuando..." -ForegroundColor Yellow
}

# Configuración de argumentos de renderizado
$rendererArgs = @()
if ($FastLoad) {
    $rendererArgs = @("--web-renderer", "html")
    Write-Host "Modo: Carga rápida (renderer HTML)" -ForegroundColor Cyan
} elseif ($InstagramCompat) {
    $rendererArgs = @("--web-renderer", "canvaskit")
    Write-Host "Modo: Compatibilidad Instagram/Facebook (CanvasKit)" -ForegroundColor Cyan
} else {
    Write-Host "Modo: Automático (Default)" -ForegroundColor Cyan
}

# Ejecutar el build
Write-Host "Ejecutando build web..." -ForegroundColor Cyan
& $flutterCmd build web --release --no-tree-shake-icons @rendererArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Ocurrió un fallo al generar el build web." -ForegroundColor Red
    exit 1
}

Write-Host "¡Build web generado exitosamente!" -ForegroundColor Green

# Verificar que build/web existe
if (-not (Test-Path "build\web")) {
    Write-Host "ERROR: La carpeta build\web no pudo ser encontrada." -ForegroundColor Red
    exit 1
}

# Generar nombre del ZIP dinámicamente basado en la carpeta actual
$projectName = (Get-Item .).Name
$zipName = "${projectName}_web_build.zip"

Write-Host "Creando archivo ZIP..." -ForegroundColor Cyan
if (Test-Path $zipName) {
    Remove-Item $zipName -Force
    Write-Host "Archivo ZIP anterior eliminado" -ForegroundColor Yellow
}

# Comprimir usando tar.exe de Windows (soluciona el problema de las barras invertidas en servidores Linux)
Push-Location "build\web"
tar.exe -a -c -f "..\..\$zipName" *
Pop-Location

if (Test-Path $zipName) {
    $zipSize = (Get-Item $zipName).Length / 1MB
    Write-Host "¡Archivo ZIP creado exitosamente!" -ForegroundColor Green
    Write-Host "  > Archivo: $zipName" -ForegroundColor Cyan
    Write-Host "  > Tamaño: $([math]::Round($zipSize, 2)) MB" -ForegroundColor Cyan
    Write-Host "  > Ubicación: $(Get-Location)\$zipName" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "¡Listo para subir a producción!" -ForegroundColor Green
} else {
    Write-Host "ERROR: Ha fallado la creación del archivo ZIP." -ForegroundColor Red
    exit 1
}
