# Script para liberar espacio en el emulador Android
# Soluciona el error INSTALL_FAILED_INSUFFICIENT_STORAGE

Write-Host "🔧 Limpiando espacio en el emulador..." -ForegroundColor Cyan

# Intentar encontrar ADB en las rutas comunes
$adbPath = $null
$possiblePaths = @(
    "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe",
    "$env:ANDROID_HOME\platform-tools\adb.exe",
    "$env:ANDROID_SDK_ROOT\platform-tools\adb.exe",
    "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk\platform-tools\adb.exe"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $adbPath = $path
        Write-Host "✅ ADB encontrado en: $adbPath" -ForegroundColor Green
        break
    }
}

if (-not $adbPath) {
    Write-Host "❌ ADB no encontrado. Intentando desde Flutter..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opciones manuales:" -ForegroundColor Yellow
    Write-Host "1. Desde el emulador:" -ForegroundColor White
    Write-Host "   - Abre Configuración > Almacenamiento" -ForegroundColor White
    Write-Host "   - Limpia caché y datos innecesarios" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Desde Android Studio:" -ForegroundColor White
    Write-Host "   - Ve a Device Manager" -ForegroundColor White
    Write-Host "   - Click derecho en tu emulador > Wipe Data" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Aumentar espacio del emulador:" -ForegroundColor White
    Write-Host "   - Device Manager > Edit > Show Advanced Settings" -ForegroundColor White
    Write-Host "   - Aumenta 'Internal Storage' a 4GB o más" -ForegroundColor White
    exit 1
}

# 1. Desinstalar la app anterior si existe
Write-Host ""
Write-Host "1️⃣ Desinstalando app anterior..." -ForegroundColor Cyan
& $adbPath shell pm uninstall com.example.cupazo_app 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ App desinstalada" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  App no encontrada (puede que no exista)" -ForegroundColor Yellow
}

# 2. Limpiar caché del sistema
Write-Host ""
Write-Host "2️⃣ Limpiando caché del sistema..." -ForegroundColor Cyan
& $adbPath shell pm trim-caches 500M 2>&1 | Out-Null
Write-Host "   ✅ Caché limpiado" -ForegroundColor Green

# 3. Verificar espacio disponible
Write-Host ""
Write-Host "3️⃣ Verificando espacio disponible..." -ForegroundColor Cyan
$dfOutput = & $adbPath shell df /data 2>&1
Write-Host $dfOutput

# 4. Limpiar build local
Write-Host ""
Write-Host "4️⃣ Limpiando build local de Flutter..." -ForegroundColor Cyan
flutter clean | Out-Null
Write-Host "   ✅ Build limpiado" -ForegroundColor Green

Write-Host ""
Write-Host "✅ Proceso completado. Intenta instalar la app nuevamente con:" -ForegroundColor Green
Write-Host "   flutter run" -ForegroundColor White
Write-Host ""
