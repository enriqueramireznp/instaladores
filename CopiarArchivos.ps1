# ===================================================================================
# Script para descargar y colocar los archivos de configuración de ISE Posture
# para Cisco Secure Client.
# Debe ejecutarse con privilegios de Administrador.
# ===================================================================================

# --- Configuración ---
# Directorio de destino final de los archivos.
$destinationDir = "C:\Program Files (x86)\Cisco\Cisco Secure Client\ISE Posture"

# Lista de archivos a descargar. Se pueden añadir más si es necesario.
$filesToDownload = @(
    @{
        Url = "https://github.com/enriqueramireznp/instaladores/releases/download/Postura_ISE/ISEPosture.json"
        FileName = "ISEPosture.json"
    },
    @{
        Url = "https://github.com/enriqueramireznp/instaladores/releases/download/Postura_ISE/ISEPostureCFG.xml"
        FileName = "ISEPostureCFG.xml"
    }
)

# --- Lógica del Script ---
# Se utiliza un bloque Try/Catch para manejar errores de forma centralizada.
try {
    # Paso 1: Verificar y crear el directorio de destino si no existe.
    if (-not (Test-Path -Path $destinationDir -PathType Container)) {
        Write-Host "El directorio de destino no existe. Creándolo en: $destinationDir"
        try {
            New-Item -Path $destinationDir -ItemType Directory -Force -ErrorAction Stop | Out-Null
            Write-Host "Directorio creado exitosamente."
        } catch {
            Write-Error "ERROR CRÍTICO: No se pudo crear el directorio de destino. Verifica los permisos. Error: $_"
            # Salir con un código de error si no se puede crear la carpeta.
            exit 1
        }
    } else {
        Write-Host "El directorio de destino ya existe: $destinationDir"
    }

    # Paso 2: Recorrer la lista de archivos y descargarlos uno por uno.
    foreach ($file in $filesToDownload) {
        $destinationPath = Join-Path -Path $destinationDir -ChildPath $file.FileName
        Write-Host "Descargando $($file.Url) a $destinationPath..."

        try {
            # Descargar el archivo. El comando sobreescribirá el archivo si ya existe.
            Invoke-WebRequest -Uri $file.Url -OutFile $destinationPath -ErrorAction Stop
            Write-Host "Descarga de $($file.FileName) completada."
        } catch {
            Write-Error "ERROR: Fallo al descargar $($file.FileName). Error: $_"
            # Si un archivo falla, se podría decidir si continuar o parar. Aquí paramos.
            exit 1
        }
    }

    Write-Host "ÉXITO: Todos los archivos han sido descargados y colocados correctamente."
    # Salir con un código de éxito.
    exit 0

} catch {
    Write-Error "ERROR INESPERADO: Ocurrió un error durante la ejecución del script. Error: $_"
    # Salir con un código de error para cualquier otra falla.
    exit 1
}