# Manual General e Instalación del Sistema
**Sistema Integrado de Control de Planta - Procesos M&D**

---

## 1. Introducción
El sistema **Procesos M&D** es una solución informática integral desarrollada en **Flutter** para la gestión operativa y control de manufactura de planta industrial. Centraliza en una única plataforma digital:
- Control de Asistencia y Turnos (con solución matemática para Cruce de Medianoche).
- Gestión de Nómina y Personal (ciclo Activo/Inactivo con protección histórica).
- Control de Producción y Jornadas (Líneas Galletas y Barras con balance de masa y mermas).
- Almacén y Control de Lotes PEPS (FIFO con fechas de vencimiento y 3 reportes PDF oficiales).
- Dashboard Gerencial de Rendimiento en tiempo real.

El sistema opera bajo una arquitectura **Offline-First**: los datos se registran y procesan de forma inmediata en una base de datos local SQLite y se sincronizan automáticamente con la nube (Supabase) una vez detectada una conexión estable a internet.

---

## 2. Requisitos del Sistema

### 📱 Dispositivos Móviles (Celulares / Tablets Android)
- **Sistema Operativo**: Android 8.0 (Oreo) o versión superior.
- **Memoria RAM**: 2 GB de memoria RAM como mínimo (recomendado 3 GB o superior).
- **Almacenamiento Libre**: 150 MB de espacio disponible.
- **Permisos Requeridos**: Acceso a almacenamiento local para guardar o compartir reportes PDF.

### 🖥️ Computadoras de Escritorio / Laptops (Windows)
- **Sistema Operativo**: Windows 10 o Windows 11 de 64 bits.
- **Procesador**: Intel Core i3 / AMD Ryzen 3 o superior.
- **Memoria RAM**: 4 GB de memoria RAM (recomendado 8 GB).
- **Almacenamiento Libre**: 250 MB de espacio disponible.
- **Conectividad**: Tarjeta de red Ethernet o Wi-Fi para sincronización con la nube.

### 🛠️ Para Compilación desde Código Fuente (Entorno de Desarrollo)
- **Flutter SDK**: Versión 3.24 o superior.
- **Dart SDK**: 3.5+.
- **Java Development Kit**: JDK 21 (`C:\Program Files\Java\jdk-21.0.12.1`) configurado en `JAVA_HOME`.
- **Git**: 2.40+.
- **Repositorio Oficial**: [https://github.com/Derom-rm27/Piloto-M-D](https://github.com/Derom-rm27/Piloto-M-D)

---

## 3. Instalación de la Aplicación Móvil (Android APK)

Las aplicaciones para Android se distribuyen de forma oficial mediante Google Drive, conservando el histórico de versiones sin sobreescribir versiones previas:

Ruta de descarga oficial:
`G:\Mi unidad\Procesos M&D\APLICACIONES\`

![Carpeta de Distribución APK](assets/docs/instalacion_01_carpeta_drive.png)

### Flujo de Instalación Paso a Paso en el Celular:

#### Paso 1: Descargar el Archivo APK
1. Desde el celular o mediante cable USB, descarga la versión más reciente del archivo APK (por ejemplo: `Procesos_MD_v1.0.8.apk`).
   
   ![Descarga del APK](assets/docs/instalacion_02_descarga_apk.png)

#### Paso 2: Habilitar Orígenes Desconocidos (Solo la primera vez)
1. Al tocar el archivo APK descargado, el sistema Android puede mostrar el mensaje: *"Por seguridad, el teléfono no tiene permitido instalar apps desconocidas de esta fuente"*.
2. Haz clic en **"Configuración"** o **"Ajustes"**.
3. Activa la casilla **"Permitir desde esta fuente"** (o "Confiar en este origen").
   
   ![Habilitar Fuentes Desconocidas](assets/docs/instalacion_03_permisos_android.png)

#### Paso 3: Confirmar la Instalación
1. Regresa al instalador y presiona el botón **"Instalar"**.
   
   ![Instalar APK](assets/docs/instalacion_04_confirmar_instalacion.png)

2. Espera unos segundos a que finalice el proceso y presiona **"Abrir"**.
3. La aplicación iniciará mostrando la pantalla de carga corporativa y conectará con la base de datos local.

---

## 4. Instalación y Ejecución de la Versión para PC (Windows .EXE)

Para estaciones de trabajo fijas de supervisión y oficinas administrativas se distribuye la versión de escritorio de 64 bits:

Ruta de descarga oficial en Google Drive:
`G:\Mi unidad\Procesos M&D\APLICACIONES\VERSION_PC\`

![Carpeta VERSION_PC](assets/docs/instalacion_05_carpeta_pc.png)

### Flujo de Puesta en Marcha en Windows:

#### Paso 1: Descargar el Archivo ZIP
1. Descarga el paquete comprimido más reciente: `Procesos_MD_v1.0.8_PC.zip` (aproximadamente 23 MB).
   
   ![Descarga de Archivo ZIP](assets/docs/instalacion_06_descarga_zip.png)

#### Paso 2: Descomprimir en una Carpeta de Trabajo
1. Haz clic derecho sobre el archivo `Procesos_MD_v1.0.8_PC.zip` y selecciona **"Extraer todo..."**.
2. Elige una ruta permanente sin caracteres especiales, por ejemplo:
   `C:\Procesos_MD_v1.0.8\` o `D:\Sistemas\Procesos_MD\`.
   
   ![Extracción de Archivos](assets/docs/instalacion_07_extraer_zip.png)

3. Verifica que la carpeta contenga el archivo ejecutable `Procesos_MD.exe` junto con las librerías dinámicas (`flutter_windows.dll`, `sqlite3.dll`, `pdfium.dll`, etc.) y la carpeta `data`.

#### Paso 3: Crear Acceso Directo en el Escritorio
1. Haz clic derecho sobre el archivo `Procesos_MD.exe`.
2. Selecciona **"Enviar a"** $\rightarrow$ **"Escritorio (crear acceso directo)"**.
   
   ![Crear Acceso Directo](assets/docs/instalacion_08_acceso_directo.png)

#### Paso 4: Ejecución y Advertencia de Seguridad (SmartScreen)
1. Haz doble clic sobre el acceso directo recién creado.
2. Si aparece la ventana azul de **Windows Defender SmartScreen**:
   
   ![Advertencia SmartScreen](assets/docs/instalacion_09_smartscreen.png)

   - Haz clic en el enlace subrayado **"Más información"**.
   - Aparecerá el botón **"Ejecutar de todas formas"**; haz clic en él.
   *(Esta advertencia aparece únicamente la primera vez debido a que la aplicación es un desarrollo empresarial interno que no requiere firma comercial de Microsoft).*

---

## 5. Conectividad, Sincronización y Modo Offline-First

El sistema cuenta con un motor de sincronización de doble vía para garantizar que la operación nunca se detenga ante cortes de internet:

```
[ Formulario de Planta ]
         │
         ▼
[ Base de Datos SQLite Local ] ◄── Inmediato (0 ms de espera)
         │
    (Cola Outbox)
         │  (Al detectar conexión a internet)
         ▼
[ Servidor Nube Supabase ] ◄── Sincronización Transaccional Atómica
```

### Indicador de Conexión en el Encabezado:
- 🟢 **Punto Verde / "Sincronizado"**: El dispositivo tiene conexión activa con el servidor central Supabase y todos los registros locales están respaldados en la nube.
- 🔴 **Punto Rojo / "Modo Local"**: El dispositivo se encuentra sin red; todos los datos se siguen guardando con total normalidad en SQLite local sin pérdida de información.
- 🔄 **Botón Sincronizar**: Al tocar el botón de sincronización en el encabezado, el sistema procesa inmediatamente los cambios acumulados en cola.

---

## 6. Personalización Visual: Modo Claro y Modo Oscuro

El sistema dispone de dos temas cromáticos estrictamente calibrados para el confort visual en los distintos ambientes de planta:

- **Modo Claro (Ideal para oficinas y luz natural)**:
  - Fondo: Blanco puro `#FFFFFF` y superficies elevadas `#F8FAFC`.
  - Color de Acento: Verde corporativo `#27741B`.
  - Textos: Alto contraste `#0F172A`.
- **Modo Oscuro (Ideal para turnos de noche y cabinas de control)**:
  - Fondo: Negro profundo `#0B0E14` y superficies `#151A23`.
  - Color de Acento: Azul corporativo `#2B0E9C` / Azul eléctrico `#3B82F6`.
- **Alternar Tema**: Se puede cambiar en cualquier momento tocando el icono de sol/luna ubicado en la esquina superior derecha del encabezado.

---

## 7. Advertencias y Errores Frecuentes

| Problema / Mensaje | Causa | Solución Paso a Paso |
| :--- | :--- | :--- |
| **"Error al analizar el paquete" (Android)** | El archivo APK se descargó incompleto o la versión de Android es anterior a 8.0. | Vuelva a descargar el archivo APK asegurando una conexión Wi-Fi estable y verifique que el tamaño del archivo sea de aproximadamente 72 MB. |
| **"No se encuentra sqlite3.dll" (Windows)** | Se intentó mover únicamente el archivo `Procesos_MD.exe` al escritorio en lugar de crear un acceso directo. | Regrese el archivo a su carpeta original con todas las DLLs y cree un **Acceso Directo** hacia el escritorio. |
| **"Bloqueo por antivirus o Windows Defender"** | Falsa alarma de seguridad por ejecutable sin firma pública. | Agregue la carpeta de la aplicación a las exclusiones de Windows Defender o presione "Más información" $\rightarrow$ "Ejecutar de todas formas". |
| **"La aplicación no sincroniza los datos nuevos"** | El router Wi-Fi de la planta no tiene salida a internet exterior. | Verifique que el dispositivo tenga acceso web abriendo una página en el navegador; la sincronización se reanudará automáticamente en cuanto retorne el servicio. |

---

## 8. Repositorio Oficial y Gestión de Versiones

- **Repositorio de Código Fuente**:
  [https://github.com/Derom-rm27/Piloto-M-D.git](https://github.com/Derom-rm27/Piloto-M-D.git)
- **Historial de Versiones Publicadas**:
  - `v1.0.0` a `v1.0.6`: Versiones iniciales de pruebas y validación en planta.
  - `v1.0.7`: Release estable con arquitectura Riverpod para Android y Windows.
  - `v1.0.8`: Incorporación del Módulo de Almacén y Control PEPS con reportes PDF oficiales y barra de navegación móvil adaptativa.
