# Script para obtener SHA-1 del keystore de debug
# Uso: .\get_sha1.ps1

Write-Host "Obteniendo SHA-1 del keystore de debug..." -ForegroundColor Cyan
Write-Host ""

$debugKeystore = "$env:USERPROFILE\.android\debug.keystore"

if (Test-Path $debugKeystore) {
    Write-Host "Keystore encontrado: $debugKeystore" -ForegroundColor Green
    Write-Host ""
    Write-Host "SHA-1 Fingerprint:" -ForegroundColor Yellow
    keytool -list -v -keystore $debugKeystore -alias androiddebugkey -storepass android -keypass android | Select-String "SHA1:"
    Write-Host ""
    Write-Host "Nota: Esta es la huella del keystore de DEBUG." -ForegroundColor Yellow
    Write-Host "Para producción, necesitarás obtener la huella de tu keystore de release." -ForegroundColor Yellow
} else {
    Write-Host "Error: No se encontró el keystore de debug en $debugKeystore" -ForegroundColor Red
    Write-Host "Ejecuta primero 'flutter run' para generar el keystore." -ForegroundColor Yellow
}

