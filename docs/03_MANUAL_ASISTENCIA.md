# Manual de Uso - Módulo de Asistencia y Control de Turnos
**Sistema Integrado de Control de Planta - Procesos M&D**

---

## 1. Introducción
El **Módulo de Asistencia** permite el registro rápido, la fiscalización diaria y la liquidación mensual de horas trabajadas para todo el personal operativo de planta. 

Está diseñado bajo una política de **listas ultra-limpias** optimizadas para pantallas táctiles de celular y computadoras de supervisión, e incorpora una solución matemática robusta para el **Cruce de Medianoche (Turno Noche)**, evitando desfases de fechas y garantizando el cálculo exacto de horas hombre sin generar valores negativos.

---

## 2. Requisitos y Permisos
- **Dispositivos**: Android APK o Windows EXE.
- **Modo de Operación**: 100% funcional sin conexión a internet (almacenamiento local SQLite con sincronización automática en cola).
- **Rol de Usuario**: Supervisores de Turno, Controladores de Asistencia y Jefatura de Recursos Humanos.

---

## 3. Interfaz Principal del Módulo

![Pantalla Principal de Asistencia](assets/docs/asistencia_01_principal.png)

### Componentes de la Pantalla:
1. **Selector de Fecha Operativa (`fecha_jornada`)**:
   - Selector de calendario para consultar o registrar la asistencia de cualquier día o turno.
2. **Selector de Turno Operativo**:
   - Pestaña **Turno Día**: Horario habitual de 07:00 AM a 19:00 PM.
   - Pestaña **Turno Noche**: Horario habitual de 19:00 PM a 05:00 AM del día siguiente.
3. **Buscador Rápido de Personal**:
   - Filtro instantáneo por nombres y apellidos.
4. **Lista Operativa Ultra-Limpia ("Solo Nombre")**:
   - Conforme a la regla de diseño de planta, las tarjetas de la primera vista muestran **estrictamente el nombre completo del trabajador**, sin elementos distractores (sin DNI, sin cargo ni pastillas de colores innecesarias).
   - Casilla de selección múltiple (checkbox) para acciones individuales o masivas.
   - Estado de marcación visual: Marcado (Entrada registrada / Salida registrada) o Pendiente.
5. **Barra Flotante Inferior Unificada ("Editar")**:
   - Botón adaptativo titulado simplemente **"Editar"**.
   - Si se selecciona **1 trabajador**: abre la edición individual de su entrada y salida.
   - Si se seleccionan **varios trabajadores**: abre la edición en lote para aplicar el mismo horario a toda la cuadrilla en un solo clic.

---

## 4. Flujo de Uso Paso a Paso

### Paso 1: Selección de Fecha y Turno
1. En la parte superior, verifica la fecha correspondiente a la guardia.
   
   ![Selector de Fecha](assets/docs/asistencia_02_selector_fecha.png)

2. Selecciona si vas a controlar el **Turno Día** o el **Turno Noche**.

---

### Paso 2: Marcación Rápida de Entrada
1. Para marcar la entrada de la cuadrilla completa:
   - Haz clic en la casilla **"Seleccionar Todos"** o marca los trabajadores presentes en el turno.
   
   ![Selección de Cuadrilla](assets/docs/asistencia_03_seleccion_personal.png)

2. Haz clic en el botón flotante inferior **"Editar"**.
   
   ![Botón Flotante Editar](assets/docs/asistencia_04_btn_editar.png)

3. En el formulario desplegado:
   - Ingresa la hora de entrada (por defecto precarga la hora del turno, ej. `19:00`).
   - Deja el campo de salida en blanco si la jornada recién está comenzando.
4. Presiona **"Guardar Marcación"**. Las tarjetas mostrarán la confirmación de asistencia.

---

### Paso 3: Marcación de Salida y Cruce de Medianoche (Turno Noche)
1. Al culminar la guardia nocturna en la madrugada (ejemplo: 05:00 AM del día siguiente):
2. Ingresa al módulo de Asistencia manteniendo como **fecha seleccionada la fecha de inicio del turno (Día N)**.
3. Selecciona a los trabajadores que culminaron su turno y presiona **"Editar"**.
   
   ![Modal Edición de Salida](assets/docs/asistencia_05_salida_noche.png)

4. Ingresa la hora de salida (`05:00`).
5. El sistema detectará automáticamente que la salida corresponde a la madrugada del día siguiente y conservará la `fecha_jornada` original, computando exactamente **10.00 horas** sin desfasar el registro.

---

### Paso 4: Edición Individual o Anulación de Marcación
1. Si un trabajador llegó con retraso o se retiró antes:
2. Selecciona únicamente a ese trabajador en la lista y presiona **"Editar"**.
   
   ![Edición Individual](assets/docs/asistencia_06_edicion_individual.png)

3. Modifica la hora de ingreso o salida respectiva.
4. **Anulación de Marcación**: Si se marcó a un trabajador por error, dentro de este mismo formulario presiona el botón rojo **"Anular Marcación"** (diseñado con fondo rojo vivo `#dc2626` y texto blanco puro para máxima legibilidad y seguridad).

---

### Paso 5: Generación del Reporte Mensual de Asistencia
1. Presiona el botón de **"Reporte Mensual"** en la esquina superior.
   
   ![Botón Reporte Mensual](assets/docs/asistencia_07_btn_reporte.png)

2. Selecciona el mes a liquidar (ejemplo: Octubre 2026).
3. El sistema emitirá el reporte oficial consolidado (disponible en PDF para firma física y en XLSX para Recursos Humanos) con las columnas:
   - `#`: Número correlativo.
   - `Trabajador`: Apellidos y nombres completos.
   - `Días Laborados`: Número total de jornadas efectivas trabajadas.
   - `Turnos Día`: Conteo de turnos diurnos completados.
   - `Turnos Noche`: Conteo de turnos nocturnos completados.
   - `Horas Totales`: Sumatoria exacta de horas con dos decimales.

---

## 5. Reglas de Negocio Críticas

### 1. Regla de Cruce de Medianoche y `fecha_jornada`
- **Problema Histórico de Fechas de Calendario**:
  Si la entrada fue a las `19:00` del día 15 y la salida a las `05:00` del día 16, agrupar por fecha de calendario emparejaba erróneamente la salida `05:00` con la entrada `19:00` del mismo día 16, arrojando **`-14.00 horas`**.
- **Solución con `fecha_jornada`**:
  Todas las marcaciones de un turno pertenecen a la `fecha_jornada` en que inició el turno:
  - Una salida entre `00:00` y `11:59 AM` de un turno nocturno mantiene como `fecha_jornada` la fecha del día anterior (Día N).
- **Fórmula de Duración de Turno**:
  ```sql
  CASE 
    WHEN salida < entrada THEN (salida + interval '1 day') - entrada 
    ELSE salida - entrada 
  END
  ```

### 2. Exclusión Estricta de Personal Inactivo
- Todo trabajador con `activo = false` en la base de datos queda **completamente oculto y excluido** de las listas de selección operativa diaria de asistencia.
- El personal inactivo **no se borra** de la base de datos; su histórico permanece intacto y se refleja en los reportes mensuales de meses en que estuvo activo.

### 3. Directriz de Accesibilidad en Botones Destructivos
- En Modo Claro y Modo Oscuro, los botones de acción crítica (`Eliminar`, `Anular Marcación`) utilizan fondo rojo sólido (`#dc2626`) con texto blanco puro (`#ffffff !important`), quedando prohibido el uso de tonos rosados tenues o textos de bajo contraste.

---

## 6. Errores Comunes y Soluciones

| Problema Observado | Causa Frecuente | Solución Inmediata |
| :--- | :--- | :--- |
| **"Un trabajador no aparece en la lista de asistencia"** | El trabajador fue dado de baja o marcado como **Inactivo** en el módulo de Personal. | Ingrese al módulo de **Personal**, cambie a la pestaña *Inactivos*, abra su ficha y presione **"Reactivar"**. |
| **"Las horas del turno noche salen negativas o cero"** | Se registró la salida cambiando la fecha del calendario a la fecha del día siguiente. | Seleccione la fecha de inicio del turno (Día N) y registre la salida a las 05:00; el sistema compensará el cruce de medianoche automáticamente. |
| **"Marcación duplicada para el mismo trabajador"** | Se ingresó dos veces la entrada para el mismo turno. | Seleccione al trabajador, presione **"Editar"** y borre o ajuste el intervalo duplicado. |
| **"No se visualizan cambios guardados en otro celular"** | El dispositivo se encuentra fuera de cobertura Wi-Fi. | Verifique que el indicador de conexión esté en verde o presione el botón de sincronización manual en el encabezado. |

---

## 7. Consejos de Buen Uso en Planta
1. **Pase de Lista al Inicio de Guardia**: Tome asistencia durante los primeros 15 minutos del turno seleccionando la cuadrilla en bloque.
2. **Cierre de Guardia en Madrugada**: El supervisor saliente del Turno Noche debe verificar que todo el personal tenga su hora de salida registrada a las 05:00 antes de entregar la guardia al supervisor entrante.
3. **Revisión de Incidencias**: No invente horas ni compense descansos no autorizados; registre exactamente las horas de entrada y salida marcadas en portería.

---

## 8. Arquitectura y Código Fuente Relacionado

- **Modelo de Dominio**: `lib/core/domain/attendance.dart`
  - Clases: `AttendanceEntry`, `ShiftSummary`, `MonthlyAttendanceReport`.
- **Gestión de Estado**: `lib/presentation/state/attendance_provider.dart`
- **Vistas y Modales**:
  - `lib/presentation/modules/attendance/attendance_view.dart`
  - `lib/presentation/modules/attendance/attendance_modals.dart`
- **Vistas SQL de Soporte en Supabase**:
  - `vw_jornadas_personal`: Vista con cálculo de cruce de medianoche protegido.
