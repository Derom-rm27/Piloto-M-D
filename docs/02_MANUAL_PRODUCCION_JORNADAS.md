# Manual de Uso - Módulo de Producción y Jornadas
**Sistema Integrado de Control de Planta - Procesos M&D**

---

## 1. Introducción
El **Módulo de Producción y Jornadas** es el núcleo operativo para el registro, seguimiento y control de la manufactura diaria en la planta de Procesos M&D. Administra las dos líneas principales de procesamiento: **Línea Galletas** y **Línea Barras Nutritivas**.

Permite digitalizar íntegramente las fichas de producción físicas de planta, calculando de manera automatizada el balance de masa, el control de bobinas de polipropileno, el porcentaje de mermas, el rendimiento por batch formulado y la emisión del formato físico oficial en PDF (2 fichas por hoja A4) con integración directa al consumo de materias primas de Almacén.

---

## 2. Requisitos del Sistema
- **Plataformas Compatibles**:
  - Android 8.0+ (`Procesos_MD_v1.0.8.apk`).
  - Windows 10/11 64-bit (`Procesos_MD.exe`).
- **Almacenamiento Local**: SQLite en el dispositivo (permite registrar jornadas en zonas de planta sin cobertura de red).
- **Sincronización**: Envío transaccional atómico hacia Supabase al restablecer la conectividad.

---

## 3. Interfaz Principal del Módulo

![Pantalla Principal de Jornadas de Producción](assets/docs/produccion_01_principal.png)

### Componentes de la Pantalla:
1. **Selector de Línea**:
   - Pestaña **Galletas**: Formularios dinámicos adaptados a presentación en cajas, paquetes, mermas de masa y horneado.
   - Pestaña **Barras**: Formularios con métricas de mezclado, moldeado, cortado y empaque de barras.
2. **Filtro de Fecha y Mes de Producción**:
   - Selector de mes calendario y fecha de inicio de jornada para auditoría y reportes.
3. **Resumen de Métricas del Periodo**:
   - Total de Cajas Producidas.
   - Total de Batches Procesados.
   - Promedio de Rendimiento Global (%) con código de colores.
4. **Lista de Jornadas Registradas**:
   - Tarjetas con: Fecha de jornada, Turno (Día/Noche), Código de lotes fabricados, Total de cajas terminadas y porcentaje de rendimiento.
5. **Botón Flotante "Nueva Jornada"**:
   - Acceso inmediato al formulario completo de registro de producción.

---

## 4. Flujo de Uso Paso a Paso

### Paso 1: Apertura de una Nueva Jornada
1. En la pantalla principal de Jornadas, pulsa el botón **"+ Nueva Jornada"**.
   
   ![Botón Nueva Jornada](assets/docs/produccion_02_btn_nueva.png)

2. Se abrirá el formulario interactivo **"Registro de Jornada de Producción"**.
   
   ![Formulario de Jornada](assets/docs/produccion_03_formulario_cabecera.png)

3. Completa los datos iniciales de cabecera:
   - **Línea de Producción**: Galletas o Barras.
   - **Fecha de Inicio de Jornada**: Fecha en que comenzó la guardia.
   - **Turno**: *Día* (07:00 a 19:00 aprox.) o *Noche* (19:00 a 05:00 del día siguiente).
   - **Supervisor / Responsable de Turno**: Selección del personal a cargo de la guardia.
   - **Número de Batches Formulados**: Cantidad de mezclas de masa preparadas en el turno.

---

### Paso 2: Registro de Lotes de Producción y Presentaciones
1. En la sección **"Lotes Producidos"**, haz clic en **"Agregar Lote"**.
   
   ![Sección de Lotes Producidos](assets/docs/produccion_04_agregar_lote.png)

2. Ingresa los parámetros de fabricación:
   - **Código de Lote**: Código alfanumérico impreso en el producto terminado (el sistema conserva ceros iniciales como texto, ej. `00142`).
   - **Tipo de Producto / Receta**: Quinua, Kiwicha, Integral, Maca, Cajamarquina o Cereales.
   - **Presentación**:
     - *30 gramos* (250 unidades por caja = 7.50 kg netos por caja).
     - *48 gramos* (160 unidades por caja = 7.68 kg netos por caja).
   - **Cajas Terminadas**: Número de cajas completas selladas y paletizadas.
   - **Paquetes Sueltos**: Unidades residuales que no completaron una caja máster.
   - **Batches Asignados al Lote**: Si la jornada produjo varios tipos de galleta, distribuye cuántos batches correspondieron a cada lote.

---

### Paso 3: Control y Consumo de Bobinas de Empaque
1. Desplázate a la sección **"Bobinas de Envoltura"**.
   
   ![Sección de Bobinas](assets/docs/produccion_05_bobinas.png)

2. Haz clic en **"Agregar Bobina"** para cada rollo montado en la envasadora:
   - **N° de Bobina**: Identificador del rollo.
   - **Peso Bruto (kg)**: Peso registrado en balanza antes de montar en máquina.
   - **Peso Neto / Usado (kg)**: Masa efectiva de polipropileno empleada en el sellado.
   - **Tuco / Cono Cartón (kg)**: Peso del cilindro central desechado.
   - **Sobra / Merma de Bobina (kg)**: Retazo de película plástica sobrante o defectuosa.
3. El sistema valida automáticamente que el peso bruto sea igual a la suma de peso usado + tuco + sobra.

---

### Paso 4: Registro de Mermas de Planta
1. En la sección **"Control de Mermas"**, anota los pesajes de desperdicio:
   - **Merma de Masa Cruda (kg)**: Restos de masa de troquelado o mezclado no reutilizables.
   - **Merma de Horneado / Galleta Rota (kg)**: Galletas quemadas, quebradas o deformes antes del envasado.
   - **Merma de Empaque (kg)**: Producto atrapado en mordazas de sellado.
   - **Total de Mermas**: Calculado automáticamente por el sistema.

---

### Paso 5: Descuento Automático en Almacén (PEPS)
1. Al completar los lotes y batches de la jornada, presiona **"Descontar Insumos en Almacén"**.
   
   ![Botón Descuento Almacén](assets/docs/produccion_06_descontar_insumos.png)

2. El sistema cruzará la formulación de los productos con el kardex de almacén, consumirá los lotes PEPS con vencimiento más próximo de harinas, azúcares, grasas y leudantes, y generará el registro de movimiento.

---

### Paso 6: Generación e Impresión del Formato Oficial PDF
1. Presiona el botón **"Generar Ficha PDF"**.
   
   ![Botón Generar PDF](assets/docs/produccion_07_vista_pdf.png)

2. El sistema abrirá la vista previa del documento oficial en formato A4:
   - **Estructura idéntica al formato físico de planta**: Dos fichas idénticas por hoja A4.
   - **Primera Ficha**: Contiene el consolidado de mermas, bobinas (hasta 11 bobinas por ficha) y datos del primer lote.
   - **Hojas de Continuación**: Si la jornada excede 11 bobinas o incluye más de dos lotes, se generan hojas anexas manteniendo el encabezado y firmas.
   - **Opciones**: Imprimir directamente, guardar como archivo PDF o compartir por correo/WhatsApp.

---

## 5. Reglas de Negocio y Balance de Masa

### 1. Pesos Formulados por Batch (Fila 19 - Balance de Materia)
La masa teórica preparada por cada batch formulado está estandarizada por receta:
- **Galleta de Quinua**: $122.01\text{ kg / batch}$
- **Galleta de Kiwicha**: $117.91\text{ kg / batch}$
- **Galleta Integral**: $118.51\text{ kg / batch}$
- **Galleta de Maca**: $117.51\text{ kg / batch}$
- **Galleta Cajamarquina y Cereales**: $120.51\text{ kg / batch}$

### 2. Conversión Oficial de Cajas Terminadas
- **Presentación 30 g**: $250\text{ paquetes} \times 0.030\text{ kg} = 7.50\text{ kg / caja}$
- **Presentación 48 g**: $160\text{ paquetes} \times 0.048\text{ kg} = 7.68\text{ kg / caja}$
- **Barras Nutritivas**: $96\text{ unidades por caja}$

### 3. Fórmulas de Rendimiento y Merma
$$\text{Peso Formulado Total (kg)} = \sum (\text{Batches del Lote} \times \text{Peso Teórico del Producto})$$

$$\text{Peso Terminado (kg)} = (\text{Cajas Producidas} \times \text{Peso Caja}) + \left(\frac{\text{Paquetes Sueltos} \times \text{Peso Paquete}}{1000}\right)$$

$$\text{Rendimiento (\%)} = \frac{\text{Peso Terminado (kg)}}{\text{Peso Formulado Total (kg)}} \times 100$$

$$\text{Cajas Mínimas Esperadas} = \frac{\text{Peso Formulado Total} \times 0.7344}{\text{Peso por Caja}}$$

### 4. Umbrales de Calidad Aceptables
| Métrica | Rango Estándar | Estado |
| :--- | :--- | :--- |
| **Rendimiento** | $73.44\% \le \text{Rendimiento} \le 100\%$ | 🟢 **Aceptable / Eficiente** |
| **Rendimiento Anómalo** | $< 73.44\%$ o $> 100\%$ | 🔴 **Alerta / Revisar Pesajes o Batches** |
| **Merma Máxima Permitida** | $\le 26.56\%$ de la masa ingresada | 🟢 **Conforme a BPM** |

---

## 6. Errores Comunes y Soluciones

| Problema / Alerta | Causa Probable | Solución |
| :--- | :--- | :--- |
| **"Rendimiento mayor al 100%"** | Se ingresó un número menor de batches formulados o un número inflado de cajas producidas. | Verifique la pizarra de formulación y cuente las cajas físicas reales en la parihuela. Corrija los valores antes de guardar. |
| **"La suma de batches por lote no coincide con el total"** | Se produjeron dos productos distintos pero no se repartieron correctamente los batches. | Compruebe que la suma de batches asignados a cada lote sume exactamente los batches totales de la amasadora. |
| **"El código de lote ya existe en el mes"** | Se intentó registrar dos veces el mismo lote. | Corrija el número correlativo de lote según la orden de producción. |
| **"Peso de bobina no cuadra"** | El peso neto + tuco + sobra no coincide con el peso bruto. | Verifique el peso registrado en la balanza de bobinas y ajuste el decimal correspondiente. |

---

## 7. Consejos de Operación en Planta
1. **Verificación de Básculas**: Calibre la balanza de mermas y de bobinas al inicio de cada guardia antes de anotar los datos.
2. **Corte Diario de Turno**: No mezcle datos del Turno Día con el Turno Noche; cada jornada debe tener su propio registro independiente.
3. **Impresión Inmediata**: Imprima la ficha física A4 al terminar el turno para recabar la firma del operador de máquina y del supervisor antes del cambio de guardia.

---

## 8. Arquitectura y Código Fuente Relacionado

- **Modelos de Dominio**:
  - `lib/core/domain/production.dart`: Modelos de `ProductionShift`, `ProductionBatch`, `BobbinEntry`, `WasteEntry`.
- **Gestión de Estado**:
  - `lib/presentation/state/production_provider.dart`: Cálculo dinámico de rendimientos y persistencia.
- **Formularios y Vistas**:
  - `lib/presentation/modules/production/production_view.dart`
  - `lib/presentation/modules/production/production_modals.dart`
  - `lib/features/production/production_editor.dart`
- **Servicio de Reportes**:
  - `lib/features/reports/report_service.dart` (Ficha física A4 doble cara).
