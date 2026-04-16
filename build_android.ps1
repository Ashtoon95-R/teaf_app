# Script para construir la app Android para Google Play Store
#
# TIPO DE BUILD - Recomendaciones por canal de distribucion:
#   1) AAB (Play Store): Siempre usar para publicar en Google Play. Play genera APKs por dispositivo.
#   2) APK universal: Para distribucion directa (pruebas, sideload). Incluye todas las arquitecturas.
#   3) APK split: Solo para casos especificos (CI, builds por ABI). CUIDADO: cada APK solo funciona
#      en su arquitectura. Nunca distribuyas un solo archivo a todos los usuarios.
#
# Uso:
#   .\build_android.ps1                                    # Lee version de pubspec.yaml, pregunta tipo de build
#   .\build_android.ps1 -BuildName "2.0.9" -BuildNumber 22 # Version personalizada
#   .\build_android.ps1 -BuildType 1                      # AAB directo (sin preguntar), para CI
#   .\build_android.ps1 -BuildType 2                      # APK directo
#   .\build_android.ps1 -BuildType 3                      # APK split por ABI
# BuildType: 1 = AAB (Play Store), 2 = APK, 3 = APK split por ABI

param(
    [string]$BuildName = "",
    [string]$BuildNumber = "",
    [int]$BuildType = 0
)

# Salir si hay algun error
$ErrorActionPreference = "Stop"

# Verifica que un APK contiene libflutter.so (evita MissingLibraryException)
function Test-ApkContainsLibFlutter {
    param([string]$ApkPath)
    $verifyDir = Join-Path $env:TEMP "apk_verify_$(Get-Random)"
    $verifyZip = "$verifyDir.zip"
    try {
        Copy-Item -Path $ApkPath -Destination $verifyZip -Force
        Expand-Archive -Path $verifyZip -DestinationPath $verifyDir -Force
        $libFlutter = Get-ChildItem -Path $verifyDir -Recurse -Filter "libflutter.so" -ErrorAction SilentlyContinue | Select-Object -First 1
        return ($null -ne $libFlutter)
    } catch {
        return $false
    } finally {
        Remove-Item -Recurse -Force $verifyDir -ErrorAction SilentlyContinue
        Remove-Item -Force $verifyZip -ErrorAction SilentlyContinue
    }
}

# Asegurar que estamos en el directorio del script (epco_flutter)
$projectRoot = $PSScriptRoot
if (-not [string]::IsNullOrEmpty($projectRoot)) {
    Set-Location -LiteralPath $projectRoot
}

Write-Host ""
Write-Host "Iniciando build de Android para EPCO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Directorio actual: $(Get-Location)" -ForegroundColor DarkGray
Write-Host ""

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "Error: No se encontro pubspec.yaml. Asegurate de estar en el directorio del proyecto Flutter." -ForegroundColor Red
    exit 1
}

# Verificar Flutter
Write-Host "Verificando Flutter..." -ForegroundColor Yellow
$flutterCmd = $null

# Intentar encontrar Flutter
$flutterPaths = @(
    "$env:LOCALAPPDATA\fvm\default\bin\flutter.bat",
    "C:\src\flutter\bin\flutter.bat",
    "C:\flutter\bin\flutter.bat",
    "$env:USERPROFILE\flutter\bin\flutter.bat"
)

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
        Write-Host "Error: Flutter no esta instalado o no esta en el PATH" -ForegroundColor Red
        exit 1
    }
}

# Verificar version de Flutter
$flutterVersion = & $flutterCmd --version 2>&1 | Select-Object -First 1
Write-Host "Flutter: $flutterVersion" -ForegroundColor Green
Write-Host ""

# Determinar version a usar
$appVersion = $BuildName
$buildNum = $BuildNumber

if ([string]::IsNullOrEmpty($BuildName) -or [string]::IsNullOrEmpty($BuildNumber)) {
    # Leer version de la app desde pubspec.yaml
    Write-Host "Leyendo version de pubspec.yaml..." -ForegroundColor Yellow
    $pubspecContent = Get-Content "pubspec.yaml" -Raw
    if ($pubspecContent -match 'version:\s*(\d+\.\d+\.\d+)\+(\d+)') {
        $appVersion = $matches[1]
        $buildNum = $matches[2]
        Write-Host "Version de la App: $appVersion (Build $buildNum)" -ForegroundColor Green
    } else {
        Write-Host "Error: No se pudo leer la version del pubspec.yaml" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Usando version personalizada: $appVersion (Build $buildNum)" -ForegroundColor Cyan
}
Write-Host ""

# Limpiar proyecto
Write-Host "Limpiando proyecto..." -ForegroundColor Yellow
& $flutterCmd clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error durante la limpieza del proyecto" -ForegroundColor Red
    exit 1
}
Write-Host "Limpieza completada" -ForegroundColor Green
Write-Host ""

# Obtener dependencias
Write-Host "Obteniendo dependencias de Flutter..." -ForegroundColor Yellow
& $flutterCmd pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al obtener dependencias" -ForegroundColor Red
    exit 1
}
Write-Host "Dependencias obtenidas" -ForegroundColor Green
Write-Host ""

# Verificar configuracion de Android
Write-Host "Verificando configuracion de Android..." -ForegroundColor Yellow
$doctorOutput = & $flutterCmd doctor -v 2>&1
$doctorOutput | Select-String -Pattern "Android" -Context 0,3

# Verificar licencias
if ($doctorOutput -match "Android license status unknown" -or $doctorOutput -match "Some Android licenses not accepted") {
    Write-Host "Advertencia: Las licencias de Android no han sido aceptadas." -ForegroundColor Yellow
    Write-Host "   Ejecuta: flutter doctor --android-licenses" -ForegroundColor White
    Write-Host ""
    if ($BuildType -eq 0) {
        $confirm = Read-Host "¿Deseas intentar continuar de todos modos? (s/n)"
        if ($confirm -ne "s") { exit 1 }
    }
}
Write-Host ""

# Verificar que existe key.properties y el keystore
if (Test-Path "android\key.properties") {
    Write-Host "Verificando configuracion de firma (key.properties)..." -ForegroundColor Yellow
    try {
        $keyProps = ConvertFrom-StringData (Get-Content "android\key.properties" -Raw)
        $storeFile = $keyProps.storeFile
        if ($storeFile) {
            # La ruta en key.properties es relativa a la carpeta 'android'
            $absStorePath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine((Join-Path (Get-Location) "android"), $storeFile))
            if (Test-Path $absStorePath) {
                Write-Host "Keystore encontrado: $absStorePath" -ForegroundColor Green
            } else {
                Write-Host "ERROR: No se encontro el archivo keystore en: $absStorePath" -ForegroundColor Red
                Write-Host "Verifica la ruta 'storeFile' en android\key.properties" -ForegroundColor Red
                Write-Host ""
                exit 1
            }
        }
    } catch {
        Write-Host "Nota: No se pudo validar el archivo keystore automaticamente, continuando..." -ForegroundColor Gray
    }
} else {
    Write-Host "Advertencia: No se encontro android\key.properties" -ForegroundColor Yellow
    Write-Host "El build no estara firmado para produccion" -ForegroundColor Yellow
    Write-Host ""
}

# Tipo de build: por parametro o preguntar
if ($BuildType -lt 1 -or $BuildType -gt 3) {
    Write-Host "Que tipo de build deseas crear?" -ForegroundColor Yellow
    Write-Host "1) App Bundle (AAB) para Google Play Store (recomendado)"
    Write-Host "2) APK para pruebas"
    Write-Host "3) APK Split (multiples APKs por arquitectura)"
    $buildTypeStr = Read-Host "Selecciona una opcion (1-3)"
    $buildType = [int]$buildTypeStr
} else {
    $buildType = $BuildType
    Write-Host "Build tipo $buildType (AAB=1, APK=2, APK split=3)" -ForegroundColor Cyan
}

Write-Host ""
switch ($buildType) {
    "1" {
        Write-Host "Construyendo App Bundle (AAB) para Google Play Store (Version: $appVersion+$buildNum)..." -ForegroundColor Yellow
        Write-Host ""
        & $flutterCmd build appbundle --release --build-name=$appVersion --build-number=$buildNum
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host ""
            Write-Host "Error al construir el App Bundle" -ForegroundColor Red
            exit 1
        }
        
        $aabPath = "build\app\outputs\bundle\release\app-release.aab"
        if (Test-Path $aabPath) {
            $aabSize = (Get-Item $aabPath).Length / 1MB
            Write-Host ""
            Write-Host "Build completado exitosamente!" -ForegroundColor Green
            Write-Host "Archivo AAB: $aabPath" -ForegroundColor Green
            Write-Host "Tamano: $([math]::Round($aabSize, 2)) MB" -ForegroundColor Green
            # Verificar que el AAB contiene librerias nativas (evita MissingLibraryException libflutter.so)
            $verifyDir = "build\app\outputs\bundle\release\aab_verify"
            $verifyZip = "build\app\outputs\bundle\release\app-release.zip"
            if (Test-Path $verifyDir) { Remove-Item -Recurse -Force $verifyDir }
            try {
                Copy-Item -Path $aabPath -Destination $verifyZip -Force
                Expand-Archive -Path $verifyZip -DestinationPath $verifyDir -Force
                $libFlutter = Get-ChildItem -Path $verifyDir -Recurse -Filter "libflutter.so" -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($libFlutter) {
                    Write-Host "Verificacion AAB: libflutter.so encontrado (librerias nativas OK)" -ForegroundColor Green
                } else {
                    Write-Host "Advertencia: No se encontro libflutter.so en el AAB. Revisa el build." -ForegroundColor Yellow
                }
                Remove-Item -Recurse -Force $verifyDir -ErrorAction SilentlyContinue
                Remove-Item -Force $verifyZip -ErrorAction SilentlyContinue
            } catch {
                Write-Host "No se pudo verificar contenido del AAB: $($_.Message)" -ForegroundColor Gray
            }
            Write-Host ""
            Write-Host "Puedes subir este archivo a Google Play Console:" -ForegroundColor Yellow
            Write-Host "  1. Ve a https://play.google.com/console" -ForegroundColor White
            Write-Host "  2. Selecciona tu app" -ForegroundColor White
            Write-Host "  3. Ve a 'Release' > 'Production' (o 'Testing')" -ForegroundColor White
            Write-Host "  4. Crea una nueva version y sube el archivo AAB" -ForegroundColor White
        } else {
            Write-Host "Error: No se encontro el archivo AAB en $aabPath" -ForegroundColor Red
            exit 1
        }
    }
    "2" {
        Write-Host "Construyendo APK para pruebas (Version: $appVersion+$buildNum)..." -ForegroundColor Yellow
        Write-Host ""
        & $flutterCmd build apk --release --build-name=$appVersion --build-number=$buildNum
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host ""
            Write-Host "Error al construir el APK" -ForegroundColor Red
            exit 1
        }
        
        $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
        if (Test-Path $apkPath) {
            $apkSize = (Get-Item $apkPath).Length / 1MB
            Write-Host ""
            Write-Host "Build completado exitosamente!" -ForegroundColor Green
            Write-Host "Archivo APK: $apkPath" -ForegroundColor Green
            Write-Host "Tamano: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Green
            # Verificar que el APK contiene librerias nativas (evita MissingLibraryException libflutter.so)
            try {
                if (Test-ApkContainsLibFlutter -ApkPath $apkPath) {
                    Write-Host "Verificacion APK: libflutter.so encontrado (librerias nativas OK)" -ForegroundColor Green
                } else {
                    Write-Host "Advertencia: No se encontro libflutter.so en el APK. Revisa el build." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "No se pudo verificar contenido del APK: $($_.Message)" -ForegroundColor Gray
            }
            Write-Host ""
            Write-Host "APK listo para pruebas e instalacion directa" -ForegroundColor Yellow
        } else {
            Write-Host "Error: No se encontro el archivo APK en $apkPath" -ForegroundColor Red
            exit 1
        }
    }
    "3" {
        Write-Host "Construyendo APK Split (Version: $appVersion+$buildNum)..." -ForegroundColor Yellow
        Write-Host ""
        & $flutterCmd build apk --release --split-per-abi --build-name=$appVersion --build-number=$buildNum
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host ""
            Write-Host "Error al construir los APKs" -ForegroundColor Red
            exit 1
        }
        
        $apkDir = "build\app\outputs\flutter-apk"
        $apks = Get-ChildItem -Path $apkDir -Filter "app-*-release.apk" -ErrorAction SilentlyContinue
        
        if ($apks.Count -gt 0) {
            Write-Host ""
            Write-Host "Build completado exitosamente!" -ForegroundColor Green
            Write-Host "Archivos APK generados:" -ForegroundColor Green
            $allVerified = $true
            foreach ($apk in $apks) {
                $apkSize = $apk.Length / 1MB
                Write-Host "  - $($apk.Name): $([math]::Round($apkSize, 2)) MB" -ForegroundColor Cyan
                # Verificar libflutter.so en cada APK split
                try {
                    if (Test-ApkContainsLibFlutter -ApkPath $apk.FullName) {
                        Write-Host "    Verificacion: libflutter.so OK" -ForegroundColor Green
                    } else {
                        Write-Host "    Advertencia: libflutter.so NO encontrado" -ForegroundColor Yellow
                        $allVerified = $false
                    }
                } catch {
                    Write-Host "    No se pudo verificar: $($_.Message)" -ForegroundColor Gray
                    $allVerified = $false
                }
            }
            Write-Host ""
            Write-Host "ADVERTENCIA: Cada APK solo funciona en su arquitectura. No distribuyas un solo archivo a todos los usuarios." -ForegroundColor Yellow
            Write-Host "  - arm64-v8a: moviles modernos (mayoria)" -ForegroundColor Gray
            Write-Host "  - armeabi-v7a: moviles ARM 32-bit" -ForegroundColor Gray
            Write-Host "  - x86_64: emuladores y algunos tablets" -ForegroundColor Gray
            if (-not $allVerified) {
                Write-Host "Revisa el build: algun APK no contiene libflutter.so" -ForegroundColor Yellow
            }
        } else {
            Write-Host "Error: No se encontraron archivos APK en $apkDir" -ForegroundColor Red
            exit 1
        }
    }
    default {
        Write-Host "Opcion invalida" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Proceso completado!" -ForegroundColor Green
Write-Host ""
Write-Host "Informacion de la version:" -ForegroundColor Yellow
Write-Host "  Version: $appVersion" -ForegroundColor White
Write-Host "  Build: $buildNum" -ForegroundColor White
Write-Host ""
