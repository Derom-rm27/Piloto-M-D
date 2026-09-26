# Procesos M&D - Control de Planta & Trazabilidad Operativa

Sistema integral multiplataforma (**Android Móvil**, **Windows Desktop** y **Prototipos Web/HTML**) diseñado a medida para **Procesos M&D**, enfocado en la supervisión de planta, control diario de asistencia con turnos rotativos, registro de jornadas de producción (líneas de Galletas y Barras), trazabilidad de lotes y bobinas, y cálculo inductivo de rendimiento operativo mediante balance de materiales.

---

## 📋 Tabla de Contenidos
1. [Descripción General](#-descripción-general)
2. [Módulos del Sistema](#-módulos-del-sistema)
3. [Arquitectura y Tecnologías](#-arquitectura-y-tecnologías)
4. [Requisitos Previos del Sistema](#-requisitos-previos-del-sistema)
5. [Instalación y Configuración](#-instalación-y-configuración)
6. [Compilación y Despliegue](#-compilación-y-despliegue)
   - [Compilación para Android (APK Release)](#compilación-para-android-apk-release)
   - [Compilación para Windows (.exe Release)](#compilación-para-windows-exe-release)
   - [Prototipos Móviles HTML](#prototipos-móviles-html)
7. [Consideraciones Críticas para el Usuario y Reglas de Negocio](#-consideraciones-críticas-para-el-usuario-y-reglas-de-negocio)
8. [Estructura del Proyecto](#-estructura-del-proyecto)

---

## 🏭 Descripción General

El sistema optimiza el flujo de información operativo de planta, eliminando el extravío de datos físicos y facilitando la sincronización en tiempo real y offline entre supervisores, operarios y gerencia:

- **Modo Offline-First**: Operatividad garantizada en planta sin conexión a internet mediante base de datos SQLite local (`sqflite` en Android, `sqflite_common_ffi` en Windows), sincronizando automáticamente con la nube (Supabase) al detectar conectividad.
- **Multiplataforma**: Código unificado en Flutter para celulares Android y computadoras Windows x64.
- **Diseño Adaptativo & Ergonómico**: Tema Claro (blanco limpio con verde corporativo `#27741B`) y Tema Oscuro (negro profundo `#050508` con azul corporativo `#2B0E9C`), cumpliendo altos estándares de contraste y accesibilidad.

---

## 📦 Módulos del Sistema

### 1. Control de Asistencia y Tareo
- **Listas Operativas Ultra-Limpias**: Vista inicial de tarjetas con solo el nombre del trabajador para agilizar la interacción táctil en planta.
- **Soporte de Turno Noche con Cruce de Medianoche**: Las salidas registradas en la madrugada (00:00 a 11:59 AM) se asocian estrictamente a la `fecha_jornada` del turno iniciado la noche anterior.
- **Selectores Ergonómicos**: Modales táctiles con calendario y reloj para registro intuitivo de fecha y hora.
- **Barra de Acciones Unificada**: Botón flotante adaptativo *"Editar"* (edición individual o en lote) con anulación controlada de marcaciones.
- **Reportes & Fichas Individuales en PDF**: Generación en 1 clic de calendarios mensuales de asistencia y fichas formales con cuadro de conformidad y firmas (para imprimir o compartir vía WhatsApp).

### 2. Gestión de Personal
- **Control Activo/Inactivo**: Estado operativo para excluir automáticamente al personal inactivo de la lista diaria de asistencia sin eliminar su histórico de marcaciones.
- **Ficha del Trabajador**: Consulta y edición de DNI, cargo, teléfono y dirección referencial.
- **Reactivación Rápida**: Pestaña dedicada a personal inactivo con reactivación en un solo toque.

### 3. Jornadas y Lotes de Producción
- **Formularios Dinámicos por Línea**: Campos adaptados según la línea seleccionada (Galletas vs Barras), coincidiendo con las fichas físicas de planta.
- **Trazabilidad Completa**: Registro de batches preparados, cantidad de cajas obtenidas, control de bobinas de empaque (pesos brutos, netos y tuco) y cálculo de mermas por etapa.

### 4. Rendimiento y Balance de Materia (Línea Galletas)
- **Modelo Inductivo de Ingeniería**: Fórmulas estandarizadas a partir de `balance materia galletas.xlsx` para las 6 variedades oficiales:
  - *Quinua* (121.5 kg masa $\rightarrow$ 89.2 kg prod. final $\rightarrow$ 11.2 cajas/batch).
  - *Kiwicha* (122.8 kg masa $\rightarrow$ 90.2 kg prod. final $\rightarrow$ 15.0 cajas/batch).
  - *Maca* (121.7 kg masa $\rightarrow$ 89.4 kg prod. final $\rightarrow$ 14.9 cajas/batch).
  - *Cajamarquinas* (119.3 kg masa $\rightarrow$ 87.6 kg prod. final $\rightarrow$ 14.6 cajas/batch).
  - *Cereales* (124.8 kg masa $\rightarrow$ 91.7 kg prod. final $\rightarrow$ 15.3 cajas/batch).
  - *Integral* (122.8 kg masa $\rightarrow$ 90.2 kg prod. final $\rightarrow$ 15.0 cajas/batch).
- **Eficiencia Operativa Real vs Teórica**: Relación porcentual entre cajas reales logradas vs potencial estándar de balance ($\ge 95\%$ meta de planta).
- **Diagrama de Cascada de Balance de Masa (Waterfall)**: Visualización paso a paso de Masa Cruda $\rightarrow$ Troquelado ($1.0\%$) $\rightarrow$ Evaporación de Agua ($25.0\%$) $\rightarrow$ Selección ($0.6\%$) $\rightarrow$ Envasado ($0.5\%$) $\rightarrow$ Cajas Finales.
- **Semáforo de Desviación de Mermas**: Contraste barra a barra entre pesos reales pesados y las tolerancias máximas de ingeniería.

---

## 🛠️ Arquitectura y Tecnologías

- **Framework**: [Flutter](https://flutter.dev/) (v3.41.x, canal Stable) / [Dart](https://dart.dev/) (v3.11.x).
- **Gestión de Estado**: `flutter_riverpod` (v2.6.1).
- **Backend & Autenticación**: [Supabase](https://supabase.com/) con PostgreSQL relacional y sincronización en tiempo real.
- **Persistencia Local**: `sqflite` (Android/iOS) y `sqflite_common_ffi` con `sqlite3.dll` (Windows/Linux).
- **Reportes y Documentos**: `pdf` y `printing` para generación vectorial y compartición de fichas PDF.
- **Hojas de Cálculo**: `excel` para importación/exportación de registros de planta.

---

## 💻 Requisitos Previos del Sistema

Para compilar y ejecutar el proyecto desde el código fuente, el entorno de desarrollo debe contar con:

1. **Flutter SDK**: Versión 3.41 o superior instalada y agregada al `PATH`.
2. **Git**: Versión 2.40 o superior.
3. **Para Compilación Android**:
   - **Java Development Kit (JDK)**: **JDK 21** (`C:\Program Files\Java\jdk-21.0.12.1`). Configurar `$env:JAVA_HOME` y ejecutar `flutter config --jdk-dir="C:\Program Files\Java\jdk-21.0.12.1"`.
   - **Android SDK**: Build-tools versión 34.0.0 o superior.
4. **Para Compilación Windows Desktop**:
   - **Visual Studio 2022** (Community, Professional o Enterprise) con la carga de trabajo:
     - *"Desarrollo para el escritorio con C++"* (incluye MSVC v143, CMake para Windows y Windows 10/11 SDK).
   - Habilitar Windows desktop en Flutter: `flutter config --enable-windows-desktop`.

---

## 🚀 Instalación y Configuración

### 1. Clonar el Repositorio
```bash
git clone https://github.com/ameliaticonapari/procesos_m-d.git
cd procesos_m-d
```

### 2. Descargar Dependencias
```bash
flutter pub get
```

### 3. Verificar Entorno
```bash
flutter doctor -v
```

### 4. Variables de Entorno y Conexión Supabase
La aplicación cuenta con credenciales predeterminadas para sincronización en `lib/main.dart`. Para personalizar la URL o llave de publicación de Supabase en tiempo de compilación:
```bash
flutter run --dart-define=SUPABASE_URL="https://tu-proyecto.supabase.co" --dart-define=SUPABASE_PUBLISHABLE_KEY="tu-clave-publica"
```

---

## 🏗️ Compilación y Despliegue

### Compilación para Android (APK Release)
Genera el paquete instalable optimizado para teléfonos celulares:
```powershell
# Configurar JDK 21 requerido
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21.0.12.1"
flutter config --jdk-dir="C:\Program Files\Java\jdk-21.0.12.1"

# Compilar APK Release
flutter build apk --release
```
- **Ruta de salida**: `build/app/outputs/flutter-apk/app-release.apk`
- **Ruta oficial en Google Drive**: `G:\Mi unidad\Procesos M&D\APLICACIONES\Procesos_MD_v<version>.apk` *(Preservar histórico de versiones previas).*

---

### Compilación para Windows (.exe Release)
Genera el ejecutable nativo de 64 bits para computadoras de planta y administración:
```powershell
flutter build windows --release
```
- **Ruta de salida**: `build/windows/x64/runner/Release/`
- **Ejecutable principal**: `Procesos_MD.exe`
- **Archivos requeridos para distribución**:
  El ejecutable requiere estar acompañado de su carpeta `data/` y las librerías dinámicas generadas en la misma carpeta:
  - `Procesos_MD.exe`
  - `flutter_windows.dll`
  - `sqlite3.dll`
  - `pdfium.dll`
  - `data/` (activos, fuentes, binarios compilados de Flutter)
- **Ruta oficial en Google Drive**: `G:\Mi unidad\Procesos M&D\APLICACIONES\VERSION_PC\` (disponible en carpeta extraída y en archivo ZIP portable `Procesos_MD_v<version>_PC.zip`).

---

### Prototipos Móviles HTML
En el directorio raíz se incluyen prototipos web independientes de alta fidelidad, interactivos y sin dependencias de compilación:
- **`prototipo_rendimiento_galletas.html`**: Simulador táctil móvil de rendimiento operativo para la línea de Galletas, con diagramas de cascada de balance de masa, semáforos de tolerancia y recetas completas.
- **`app_completa.html`**: Prototipo web integral del sistema de control de planta.

---

## ⚠️ Consideraciones Críticas para el Usuario y Reglas de Negocio

1. **Gestión de Personal Inactivo**:
   - **Nunca eliminar con `DELETE`** a un trabajador si tiene historial de marcaciones, ya que rompería la integridad referencial de los reportes pasados.
   - En su lugar, marcar como **Inactivo** desde su Ficha de Trabajador. Automáticamente dejará de figurar en el selector de asistencia diaria, pero se mantendrá accesible en la pestaña de inactivos para consultar o reactivar.
2. **Turno Noche y Registro de Salidas de Madrugada**:
   - Todo turno noche inicia en la noche del Día N (aprox. 19:00 hrs) y concluye en la madrugada del Día N+1 (aprox. 05:00 hrs).
   - El sistema almacena la `fecha_jornada` vinculada al Día N. Al registrar una marcación entre 00:00 y 11:59 AM, el sistema mantiene la pertenencia a la jornada correspondiente, garantizando sumatorias de horas positivas y emparejamientos exactos.
3. **Distribución del Ejecutable de Windows**:
   - No copiar únicamente el archivo `.exe` a otra computadora. Para que la aplicación funcione en cualquier PC, debe copiarse la carpeta completa `Procesos_MD_v1.0.7_PC` o descomprimir el `.zip` que incluye todas las dependencias (`pdfium.dll`, `sqlite3.dll`, carpeta `data/`).
4. **Accesibilidad y Contraste en Modo Claro**:
   - En Modo Claro, los botones destructivos (*Eliminar*, *Anular Marcación*) utilizan fondos rojo vivo (`#dc2626`) con texto blanco puro para garantizar legibilidad bajo la iluminación de planta.

---

## 📁 Estructura del Proyecto

```text
PROCESOS MDV2/
├── android/                   # Configuración y runner nativo de Android
├── assets/                    # Imágenes, logos corporativos e iconos
│   └── images/
│       └── logo_app.png       # Logo oficial de la aplicación
├── docs/                      # Documentación técnica adicional
├── lib/
│   ├── app.dart               # Rutas y configuración de MaterialApp
│   ├── main.dart              # Punto de entrada, inicialización de BD y Supabase
│   ├── core/                  # Base de datos local (SQLite), sync y temas
│   ├── domain/                # Modelos de dominio y casos de uso
│   ├── features/              # Reportes PDF y servicios auxiliares
│   ├── presentation/          # Módulos UI (Asistencia, Personal, Jornadas, Dashboard)
│   └── shared/                # Widgets compartidos y componentes visuales
├── windows/                   # Configuración de compilación CMake y runner Windows C++
├── balance materia galletas.xlsx # Estudio oficial de balance de masa y mermas
├── prototipo_rendimiento_galletas.html # Prototipo móvil interactivo de rendimiento
├── app_completa.html          # Prototipo web general del sistema
├── pubspec.yaml               # Declaración de dependencias y versiones
└── README.md                  # Manual del sistema y guía de instalación
```

---

**Procesos M&D** • *Control de Calidad, Planta y Trazabilidad Operativa*
