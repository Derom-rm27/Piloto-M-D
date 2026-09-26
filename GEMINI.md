# Reglas de Proyecto - Procesos M&D Planta

Este archivo documenta las reglas de negocio, cálculo de turnos y directrices de interfaz aprendidas para el proyecto de control de planta.

## 1. Gestión de Personal y Estado Activo/Inactivo
- **Columna `activo`**: La tabla `public.personal` cuenta con la columna `activo boolean NOT NULL DEFAULT true`.
- **Exclusión Operativa en Asistencia**:
  - Todo personal con `activo = false` (**Inactivo**) debe excluirse estrictamente del selector y listas operativas del módulo de **Asistencia** diaria.
  - El personal inactivo **no debe eliminarse** con `DELETE` de la base de datos si cuenta con histórico de marcaciones.
  - En el módulo de **Personal**, debe permanecer consultable filtrando por la pestaña *Inactivos*, permitiendo su edición y reactivación en 1 solo clic.

## 2. Cálculo de Horas y Turno Noche (Cruce de Medianoche)
- **Horario Habitual Turno Noche**: Entrada ~19:00 (Día N) y Salida ~05:00 (Día N+1).
- **Concepto de `fecha_jornada`**:
  - Para evitar agrupar por fecha de calendario (`date(fecha_hora)`), lo cual generaba emparejamientos erróneos (ej. Salida 05:00 del turno previo vs Entrada 19:00 del nuevo turno resultando en `-14.00` horas), todas las marcaciones registran o derivan `fecha_jornada`.
  - La marcación de salida de la madrugada (entre 00:00 y 11:59 AM) de un Turno Noche conserva como `fecha_jornada` la fecha de inicio del turno (Día N).
- **Cálculo de Duración en SQL**:
  - En vistas como `vw_jornadas_personal` o cálculos directos, la diferencia entre salida y entrada debe protegerse ante el cruce de medianoche:
    ```sql
    CASE 
      WHEN salida < entrada THEN (salida + interval '1 day') - entrada 
      ELSE salida - entrada 
    END
    ```

## 3. Directrices de Diseño e Interfaz (UI)
- **Modo Claro**: Fondo blanco limpio con verde corporativo `#27741B`.
- **Modo Oscuro**: Fondo negro profundo con azul corporativo `#2B0E9C`.
- **Iconos**: Utilizar iconos SVG limpios y consistentes en lugar de emojis en controles interactivos, botones flotantes y tablas.
- **Formularios Dinámicos**: Los campos de producción en *Jornadas* deben adaptarse según la línea seleccionada (Galletas vs Barras), coincidiendo con las fichas físicas de planta.

## 4. Directrices de Listas Operativas (Personal y Asistencia)
- **Listas Ultra-Limpias ("Solo Nombre")**:
  - En la primera vista de **Personal** y de **Asistencia**, las tarjetas deben mostrar **estrictamente el nombre completo** del trabajador.
  - **Prohibido en la primera vista**: DNI, cargo, pastillas verdes de activo, sub-renglones de horario/turno o botones directos por fila.
  - **Acceso a Detalles**: Al hacer clic sobre cualquier trabajador en Personal se abre la **Ficha del Trabajador (Modal)** con su DNI, cargo, estado activo/inactivo y los botones de edición, desactivación y eliminación.

## 5. Control de Asistencia y Barra Flotante
- **Botón Unificado "Editar"**:
  - El botón flotante inferior de asistencia debe titularse simplemente **"Editar"** (no "Editar en bloque").
  - **Comportamiento adaptativo**:
    - Si se selecciona **1 trabajador**: abre la edición individual de su marcación.
    - Si se seleccionan **varios trabajadores**: abre la edición en lote.
  - **Eliminación de Marcaciones**: No incluir botón duplicado de eliminar en la barra flotante; la acción de anular marcación reside exclusivamente dentro del formulario de *Editar*.

## 6. Accesibilidad y Contraste en Modo Claro
- **Botones de Peligro y Eliminación**:
  - En **Modo Claro**, todos los botones de acción destructiva (`Eliminar`, `Anular Marcación`) deben utilizar un fondo rojo sólido y vivo (`#dc2626` / `#b91c1c`) con texto blanco puro (`#ffffff !important`).
  - Queda prohibido el uso de tonos rosados tenues o textos pálidos sobre fondos claros que provoquen pérdida de contraste o ilegibilidad.

## 7. Compilación y Despliegue de Aplicación Móvil (APK)
- **Exclusividad Móvil**: Solo compilar y distribuir la aplicación para celular (Android APK release). No generar ni subir ejecutables web ni de escritorio a esta carpeta a menos que se solicite explícitamente.
- **Ruta de Distribución en Google Drive**:
  - Carpeta destino: `G:\Mi unidad\Procesos M&D\APLICACIONES`.
- **Versionamiento y Preservación de Historial**:
  - Nombrar el archivo de acuerdo a la versión configurada en `pubspec.yaml` (ej. `Procesos_MD_v<version>.apk`).
  - **No eliminar ni sobreescribir versiones anteriores** al subir una nueva compilación; cada versión debe coexistir como histórico de versiones.
- **Entorno de Compilación (Gradle / JDK)**:
  - Asegurar la ejecución con JDK 21 (`C:\Program Files\Java\jdk-21.0.12.1`) configurado en `$env:JAVA_HOME` y `flutter config --jdk-dir` para compatibilidad con Gradle.


