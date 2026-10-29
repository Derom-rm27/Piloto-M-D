# Manual de Uso - Módulo de Almacén y Control PEPS (FIFO)
**Sistema Integrado de Control de Planta - Procesos M&D**

---

## 1. Introducción
El **Módulo de Almacén y Control PEPS** de Procesos M&D está diseñado para garantizar la trazabilidad total, el control riguroso de fechas de vencimiento y la gestión de inventario en tiempo real para las líneas de producción de Galletas y Barras.

Implementa de forma estricta el método **PEPS (Primeras Entradas, Primeras Salidas / FIFO)**, asegurando que los lotes de materias primas e insumos con fecha de vencimiento más próxima sean despachados prioritariamente para producción. Asimismo, genera reportes oficiales en PDF de formato estricto de una página A4 listos para auditorías sanitarias y de calidad (BPM / HACCP).

---

## 2. Requisitos del Sistema
- **Plataformas Compatibles**:
  - Android 8.0 o superior (mediante archivo instalador `Procesos_MD_v1.0.8.apk`).
  - Windows 10 / Windows 11 de 64 bits (mediante ejecutable de escritorio `Procesos_MD.exe`).
- **Almacenamiento Local**: SQLite integrado en el dispositivo (funcionalidad 100% Offline-First sin requerir internet constante).
- **Conectividad**: Conexión a red (Wi-Fi o datos) para la sincronización periódica con la base de datos central Supabase.
- **Visualizador de PDF**: Aplicación para previsualización e impresión de documentos PDF (incluido nativamente mediante el motor integrado).

---

## 3. Interfaz Principal del Módulo

La interfaz se adapta fluidamente a pantallas de escritorio (PC) y dispositivos móviles (celulares y tablets).

![Pantalla Principal del Módulo de Almacén](assets/docs/almacen_01_principal.png)

### Componentes de la Pantalla:
1. **Encabezado y Barra de Herramientas**:
   - Buscador rápido por nombre de insumo o código.
   - Botón de descarga/impresión del **Reporte de Existencias (PDF)**.
   - Contador de insumos activos y porcentaje de cobertura global.
2. **Selector de Categorías (Pills)**:
   - *Todos*: Vista completa de insumos.
   - *Harinas*: Harina especial, trigo, etc.
   - *Azúcares y Grasas*: Azúcar rubia, manteca vegetal, grasa para relleno.
   - *Cacao y Cobertura*: Cacao en polvo, cobertura de chocolate.
   - *Químicos y Leudantes*: Bicarbonato de sodio, bicarbonato de amonio, lecitina, esencias, sal.
   - *Empaque y Embalaje*: Cajas máster, bobinas de polipropileno, cintas de embalaje.
3. **Banner de Alertas de Stock Crítico**:
   - Se muestra automáticamente en la parte superior cuando uno o más insumos cuentan con un stock menor a **1 turno de producción**.
   - Identifica el insumo en peligro y sugiere reposición inmediata.
4. **Tabla de Inventario (Vista de Escritorio)** / **Tarjetas Interactivas (Vista Móvil)**:
   - Muestra Nombre, Categoría, Stock Actual (en unidades y kg equivalentes), Cobertura en Turnos, Próximo Lote a Vencer y Estado del Insumo.
5. **Barra Flotante de Acciones Inferior**:
   - Botón **Entrada (+)**: Registro de recepción de materias primas.
   - Botón **Salida PEPS (-)**: Despacho manual con asignación automática por vencimiento.
   - Botón **Historial**: Consulta de kardex de movimientos físicos.

---

## 4. Flujo de Uso Paso a Paso

### Paso 1: Ingreso de Materia Prima / Recepción de Mercadería
1. En la pantalla principal de Almacén, presiona el botón **"Entrada de Insumo"**.
   
   ![Botón de Entrada de Insumo](assets/docs/almacen_02_btn_entrada.png)

2. Se desplegará el modal **"Recepción de Materia Prima"**.
   
   ![Modal de Entrada de Materia Prima](assets/docs/almacen_03_modal_entrada.png)

3. Completa los datos requeridos:
   - **Insumo**: Selecciona el producto recibido de la lista desplegable.
   - **Cantidad Recibida**: Ingresa el número de sacos, cajas o kilogramos.
   - **N° de Lote del Proveedor**: Código de lote impreso en el saco o empaque.
   - **N° de Guía de Remisión**: Número del documento de traslado del transportista.
   - **Proveedor**: Nombre comercial o razón social del remitente.
   - **Fecha de Vencimiento**: Selecciona la fecha o utiliza los atajos rápidos:
     - `+6 Meses`: Calcula automáticamente la caducidad a 6 meses.
     - `+1 Año`: Calcula la caducidad a 1 año calendario.
   - **Checklist de Conformidad BPM**: Verifica el estado físico (Empaque íntegro, libre de plagas, olor característico, rotulado legible).
4. Presiona el botón **"Registrar Entrada y Generar PDF"**.
   
   ![Confirmación de Entrada](assets/docs/almacen_04_comprobante_entrada.png)

5. El sistema registrará el nuevo lote disponible para producción y abrirá instantáneamente la **Nota de Recepción / Comprobante de Entrada (1 Página A4)** con doble firma para almacén y control de calidad.

---

### Paso 2: Salida de Almacén con Algoritmo PEPS (FIFO)
1. Presiona el botón **"Salida PEPS"** en la barra inferior o directamente desde la fila del insumo deseado.
   
   ![Botón de Salida PEPS](assets/docs/almacen_05_btn_salida.png)

2. Selecciona el insumo y especifica la **Cantidad a Retirar**.
   
   ![Modal de Salida PEPS](assets/docs/almacen_06_modal_salida.png)

3. **Asignación Automática Inteligente**:
   - El sistema analiza los lotes activos ordenados cronológicamente por fecha de vencimiento (`fecha_vencimiento ASC`).
   - Muestra en pantalla el desglose visual de cómo se descontará la cantidad:
     > *Ejemplo:* Si requieres 30 sacos y el Lote A tiene 20 sacos disponibles y el Lote B tiene 50 sacos:
     > - Lote A (Vence: 15/Nov/2026): Consume 20 sacos (Lote agotado).
     > - Lote B (Vence: 20/Dic/2026): Consume 10 sacos (Quedan 40 disponibles).
4. Selecciona el **Destino / Línea** (Línea Galletas, Línea Barras o Merma/Baja) y el personal que autoriza el retiro.
5. Presiona **"Confirmar Salida PEPS"**. El stock y los lotes se actualizarán de forma inmediata.

---

### Paso 3: Consulta y Trazabilidad de Lotes Activos
1. Haz clic en la opción **"Ver Lotes"** o sobre el badge del próximo lote del insumo.
   
   ![Ventana de Consulta de Lotes](assets/docs/almacen_07_ver_lotes.png)

2. La pantalla listará todos los lotes asociados al insumo:
   - Número de Lote.
   - Fecha de Vencimiento y días restantes de vida útil.
   - Cantidad inicial recibida vs. Saldo disponible actual.
   - Pastilla indicadora de prioridad PEPS (*Próximo a salir*, *En reserva*, *Agotado*).

---

### Paso 4: Descuento Automático desde el Informe de Producción (Turno)
Para evitar doble digitación, el consumo de insumos puede descontarse automáticamente al cerrar una jornada:
1. Ingresa al módulo de **Jornadas / Producción**.
2. Al registrar los batches procesados en el turno (ejemplo: 20 batches de Galleta de Quinua), haz clic en **"Descontar Insumos en Almacén"**.
   
   ![Descuento Automático por Turno](assets/docs/almacen_08_descuento_turno.png)

3. El sistema calculará la masa teórica formulada multiplicando los batches por las cantidades estándar de receta, ejecutará la salida PEPS de cada ingrediente y emitirá el **Parte de Producción y Consumo de Turno (PDF)**.

---

### Paso 5: Generación del Reporte Oficial de Existencias (Stock Actual)
1. En la parte superior derecha de Almacén, haz clic en **"Reporte de Existencias (PDF)"**.
   
   ![Generar Reporte de Existencias](assets/docs/almacen_09_reporte_existencias.png)

2. Se generará un documento oficial en formato A4 de 1 página que incluye:
   - Encabezado corporativo de Procesos M&D con fecha y hora de emisión.
   - Tabla consolidada de los 19 insumos con stock físico, unidad de medida y peso en kg.
   - Estimación de cobertura en turnos (días de producción restantes).
   - Resaltado en color rojo para insumos en nivel crítico (< 1 turno).
   - Espacio para triple firma: Jefe de Almacén, Supervisor de Turno y Gerencia de Operaciones.

---

## 5. Reglas de Negocio y Lógica de Cálculo

### 1. Fórmulas de Cobertura en Turnos
La cobertura en turnos proyecta cuántos turnos continuos de planta pueden operar con el stock disponible:
$$\text{Cobertura (Turnos)} = \frac{\text{Stock Actual (kg)}}{\text{Consumo Teórico por Turno (kg)}}$$

Donde el consumo por turno depende de la capacidad estándar establecida para cada línea:
- **Línea Galletas**: 20 batches por turno.
- **Línea Rellenas**: 18 batches por turno.
- **Línea Barras**: 15 batches por turno.

### 2. Estados de Stock y Semáforo de Control
| Nivel de Cobertura | Estado Visual | Acción Requerida |
| :--- | :--- | :--- |
| **$< 1.0$ Turno** | 🔴 **Crítico** (Fondo rojo tenue / texto rojo vivo) | Compra y reposición de emergencia inmediata. |
| **$1.0$ a $3.0$ Turnos** | 🟡 **Alerta** (Texto ámbar / naranja) | Emitir orden de compra ordinaria al proveedor. |
| **$> 3.0$ Turnos** | 🟢 **Óptimo** (Texto verde corporativo) | Nivel adecuado de materia prima para operación. |

### 3. Regla PEPS Estricta
Ningún lote posterior puede ser consumido si existe un lote precedente activo con saldo disponible mayor a cero, garantizando cero mermas por vencimiento de materias primas en planta.

---

## 6. Errores Comunes y Soluciones

| Problema / Mensaje | Causa Probable | Solución Paso a Paso |
| :--- | :--- | :--- |
| **"Stock insuficiente para completar la salida PEPS"** | La cantidad solicitada supera la sumatoria de todos los saldos de lotes activos. | Verifique que se hayan registrado todas las guías de entrada pendientes antes de autorizar el despacho. |
| **"Debe ingresar un N° de Lote válido"** | El campo de lote del proveedor se dejó en blanco. | Revise la etiqueta física del saco o bidón e ingrese el código de lote respectivo. |
| **"Fecha de vencimiento anterior a la fecha actual"** | Se ingresó por error una fecha pasada. | Corrija la fecha de vencimiento según la ficha técnica del insumo; materias primas vencidas no son admitidas por el sistema. |
| **"Lote agotado durante la asignación"** | El saldo del lote más antiguo era menor a la cantidad requerida. | No es un error; el sistema tomó automáticamente el saldo restante y continuó descontando del lote subsiguiente por regla PEPS. |
| **El insumo figura con stock cero pero hay sacos físicos** | No se registró la Nota de Recepción de la guía de remisión. | Ingrese a **"Entrada de Insumo"** y registre la mercadería para actualizar el kardex digital. |

---

## 7. Consejos de Buen Uso en Planta
1. **Registro Inmediato en Recepción**: Registre cada lote en el sistema en el momento exacto en que ingresa al almacén de planta y aplique la etiqueta con el número de lote interno.
2. **Impresión de Comprobante de Entrada**: Adjunte siempre la Nota de Recepción en PDF impresa a la guía de remisión física del transportista.
3. **Verificación de Alertas Diarias**: Al iniciar cada guardia, el supervisor debe revisar el banner de insumos críticos para planificar los requerimientos de la jornada.
4. **Respaldo y Cierre de Turno**: Al finalizar cada turno de producción, valide que el consumo de materias primas cuadre exactamente con los batches producidos.

---

## 8. Arquitectura y Código Fuente Relacionado

- **Modelo de Dominio**: `lib/domain/models/warehouse_model.dart`
  - Clases: `InsumoItem`, `LoteItem`, `MovimientoItem`, `CoberturaTurno`.
- **Gestión de Estado (Riverpod)**: `lib/presentation/state/warehouse_provider.dart`
  - Proveedor principal: `warehouseProvider`, `WarehouseNotifier`.
- **Vistas y Modales**:
  - `lib/presentation/modules/warehouse/warehouse_view.dart`
  - `lib/presentation/modules/warehouse/warehouse_modals.dart`
- **Servicio de Reportes PDF**:
  - `lib/features/reports/warehouse_report_service.dart` (Diseño A4 exacto de 1 página).
- **Tablas de Base de Datos**:
  - `almacen_insumos`
  - `almacen_lotes`
  - `almacen_movimientos`
