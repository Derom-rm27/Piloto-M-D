# Manual de Uso - Módulo de Rendimiento y Dashboard de Planta
**Sistema Integrado de Control de Planta - Procesos M&D**

---

## 1. Introducción
El **Módulo de Rendimiento y Dashboard** proporciona a la gerencia de planta y supervisores una vista analítica ejecutiva del desempeño productivo en tiempo real. 

Sintetiza la información de las jornadas operativas, comparando la masa formulada teórica contra el producto terminado empacado para auditar el cumplimiento del **Balance de Materia** (Rendimiento mínimo del 73.44% y control de mermas con techo de 26.56%), alertando anomalías y desvíos de masa.

---

## 2. Requisitos del Sistema
- **Dispositivos**: Android APK o Windows Desktop EXE.
- **Acceso**: Dirección General, Gerencia de Operaciones, Jefatura de Calidad y Supervisores.
- **Datos Requeridos**: Jornadas de producción registradas con lotes, batches y pesajes de bobinas.

---

## 3. Interfaz Principal del Dashboard

![Pantalla Principal del Dashboard de Rendimiento](assets/docs/dashboard_01_principal.png)

### Componentes de la Pantalla:
1. **Selector de Periodo de Análisis**:
   - Selector de mes calendario o rango de fechas de guardia.
2. **Selector de Línea**:
   - Pestaña **Línea Galletas** / **Línea Barras**.
3. **Tarjetas de Indicadores Clave de Desempeño (KPIs)**:
   - **Total Cajas Producidas**: Volumen físico terminado listo para despacho comercial.
   - **Masa Total Formulada**: Sumatoria de kilogramos teóricos ingresados a la amasadora según número de batches y recetas.
   - **Masa Terminada Empacada**: Kilogramos netos en cajas selladas.
   - **Rendimiento Promedio (%)**: Porcentaje de eficiencia de conversión de masa.
   - **Merma Total (kg y %)**: Desperdicio generado en masa cruda, horneado y empaque.
4. **Gráfico de Rendimiento por Jornada / Lote**:
   - Barras comparativas por cada jornada de trabajo con código de colores según umbrales de calidad.
5. **Panel de Alertas de Rendimiento**:
   - Lista rápida de jornadas que cayeron por debajo del 73.44% de rendimiento o que registraron valores atípicos superiores al 100%.

---

## 4. Flujo de Uso Paso a Paso

### Paso 1: Selección del Periodo y Línea a Evaluar
1. Al ingresar al módulo **Rendimiento**, selecciona el mes a auditar (ejemplo: Octubre 2026).
   
   ![Selector de Mes en Dashboard](assets/docs/dashboard_02_selector_mes.png)

2. Selecciona la pestaña de la línea deseada (**Galletas** o **Barras**).
3. Las tarjetas superiores y los gráficos se recalcularán automáticamente en milisegundos.

---

### Paso 2: Análisis de Indicadores Globales (KPIs)
1. Examina las tarjetas de métricas en la parte superior:
   
   ![Tarjetas de KPIs](assets/docs/dashboard_03_kpi_cards.png)

   - **Cajas Producidas**: Indica el volumen comercial terminado.
   - **Rendimiento Global**: Si figura en **verde**, la planta operó dentro de los estándares de balance de materia; si figura en **ámbar** o **rojo**, las mermas superaron el límite permitido.

---

### Paso 3: Inspección Visual del Gráfico de Rendimiento
1. Observa el gráfico de barras por guardia:
   
   ![Gráfico de Rendimiento](assets/docs/dashboard_04_grafico_barras.png)

   - **Barra Verde**: Jornada eficiente ($73.44\% \le \text{Rendimiento} \le 100\%$).
   - **Barra Naranja / Roja**: Jornada deficiente ($< 73.44\%$) o atípica ($> 100\%$).
2. **Interacción Directa**: Haz clic o toca directamente sobre cualquier barra para abrir el desglose completo de esa jornada (lotes, bobinas y mermas).

---

### Paso 4: Exportación de Indicadores a Reportes
1. Presiona el botón de **"Exportar Métricas (XLSX / PDF)"** en la barra superior.
   
   ![Botón Exportar Métricas](assets/docs/dashboard_05_btn_exportar.png)

2. El sistema compilará la hoja de cálculo con las fórmulas de balance y la tabla resumen para la reunión mensual de operaciones.

---

## 5. Reglas de Negocio y Balance de Materia

### 1. Umbrales Confirmados de Calidad y Eficiencia
- **Rendimiento Mínimo Esperado**: **$73.44\%$**
- **Merma Máxima Aceptable**: **$26.56\%$**

### 2. Formulación Estándar por Batch (Fila 19 - Balance de Materia)
| Producto | Peso Formulado por Batch | Cajas Esperadas (30g) | Cajas Esperadas (48g) |
| :--- | :--- | :--- | :--- |
| **Galleta de Quinua** | $122.01\text{ kg}$ | $11.94\text{ cajas / batch}$ | $11.66\text{ cajas / batch}$ |
| **Galleta de Kiwicha** | $117.91\text{ kg}$ | $11.54\text{ cajas / batch}$ | $11.27\text{ cajas / batch}$ |
| **Galleta Integral** | $118.51\text{ kg}$ | $11.60\text{ cajas / batch}$ | $11.33\text{ cajas / batch}$ |
| **Galleta de Maca** | $117.51\text{ kg}$ | $11.50\text{ cajas / batch}$ | $11.23\text{ cajas / batch}$ |
| **Galleta Cajamarquina y Cereales** | $120.51\text{ kg}$ | $11.80\text{ cajas / batch}$ | $11.52\text{ cajas / batch}$ |

### 3. Fórmulas de Cálculo
$$\text{Rendimiento (\%)} = \frac{\text{Peso Terminado en Cajas y Paquetes (kg)}}{\text{Peso Formulado Total según Batches (kg)}} \times 100$$

$$\text{Cajas Mínimas Esperadas} = \frac{\text{Peso Formulado} \times 0.7344}{\text{Peso de Caja}}$$

---

## 6. Diagnóstico de Anomalías y Soluciones

| Situación Detectada | Diagnóstico Posible | Acción Correctiva |
| :--- | :--- | :--- |
| **Rendimiento $< 73.44\%$ (Barra Roja)** | Elevada merma en horneado (galleta quemada o rota), sobrante excesivo de bobina plástica o error en el pesaje de paquetes sueltos. | Abra la ficha de la jornada, verifique si hubo parada de máquina o problemas de temperatura en el horno y anote las observaciones en el reporte. |
| **Rendimiento $> 100\%$ (Barra Naranja)** | Error de digitación: se ingresó un número menor de batches en la amasadora o se registraron cajas de otra guardia. | Cuadre la pizarra física de la sala de mezclas con el número de batches ingresados en la jornada. |
| **Mermas de empaque elevadas** | Desalineación de fotocélula o problemas de sellado en mordazas de envasadora. | Solicite calibración de la máquina de empaque al área de mantenimiento. |

---

## 7. Consejos de Control de Operaciones
1. **Auditoría Diaria**: La jefatura de calidad debe revisar el dashboard cada mañana a primera hora para detectar guardias con bajo rendimiento y tomar acciones inmediatas.
2. **Trazabilidad con Almacén**: Cruce el consumo de sacos de harina del Módulo de Almacén contra los batches reportados en el Dashboard para validar la consistencia física de planta.

---

## 8. Arquitectura y Código Fuente Relacionado

- **Gestión de Estado**: `lib/presentation/state/dashboard_provider.dart`
- **Vistas**: `lib/presentation/modules/dashboard/dashboard_view.dart`
- **Componentes Gráficos**: Tarjetas de métricas, barras de progreso y cálculo de rendimientos porcentuales.
