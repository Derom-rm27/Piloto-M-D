# Centro de Documentación y Manuales de Usuario
**Sistema Integrado de Control de Planta - Procesos M&D**

Bienvenido a la documentación técnica y manuales de usuario del sistema **Procesos M&D Planta**. Esta carpeta reúne las guías operativas, especificaciones funcionales, diagramas de flujo y resolución de problemas para cada uno de los componentes de la aplicación.

---

## 📚 Índice de Manuales por Módulo

| N° | Documento | Módulo / Componente | Alcance y Contenido Principal |
| :---: | :--- | :--- | :--- |
| **00** | [Manual General e Instalación](00_MANUAL_GENERAL_E_INSTALACION.md) | **Instalación y Arquitectura** | Requisitos de hardware, instalación del APK en Android, ejecución de la versión Windows (.exe), sincronización Offline-First con SQLite y Supabase, y temas visuales. |
| **01** | [Manual de Almacén y Control PEPS](01_MANUAL_ALMACEN_PEPS.md) | **Almacén y Lotes PEPS** | Kardex de 19 insumos de formulación, recepción de materias primas con checklist BPM, salidas con asignación automática PEPS (FIFO), cálculo de cobertura en turnos y 3 reportes PDF oficiales (1 página A4). |
| **02** | [Manual de Producción y Jornadas](02_MANUAL_PRODUCCION_JORNADAS.md) | **Producción y Balance** | Registro de guardias para Línea Galletas y Línea Barras, gestión de lotes (30g y 48g), control de bobinas de empaque, registro de mermas, balance de masa y emisión de ficha física A4 de planta. |
| **03** | [Manual de Asistencia y Turnos](03_MANUAL_ASISTENCIA.md) | **Asistencia y Turno Noche** | Control de guardias día/noche, solución matemática para el **Cruce de Medianoche** (`fecha_jornada`), listas limpias ("Solo Nombre"), botón flotante unificado "Editar" y reportes mensuales de liquidación. |
| **04** | [Manual de Personal](04_MANUAL_PERSONAL.md) | **Gestión de Personal** | Ciclo de vida **Activo / Inactivo**, Ficha del Trabajador (modal), exclusión operativa en asistencia, reactivación en 1 clic y políticas de accesibilidad en botones de peligro. |
| **05** | [Manual de Rendimiento y Dashboard](05_MANUAL_DASHBOARD_RENDIMIENTO.md) | **Dashboard Gerencial** | Auditoría del balance de materia en tiempo real, KPIs ejecutivos (cajas, masa formulada, mermas), semáforo de rendimiento ($73.44\%$ a $100\%$) y gráficos interactivos por lote. |

---

## 🖼️ Estructura para Imágenes y Capturas de Pantalla

Todos los manuales cuentan con marcadores estandarizados en formato Markdown listos para enlazar las capturas de pantalla de la aplicación:

```markdown
![Descripción de la Acción o Pantalla](assets/docs/nombre_imagen.png)
```

Las imágenes deben ubicarse dentro de la carpeta:
`assets/docs/`

### Nomenclatura Recomendada para las Capturas:
- **Almacén**: `almacen_01_principal.png`, `almacen_02_btn_entrada.png`, etc.
- **Producción**: `produccion_01_principal.png`, `produccion_02_btn_nueva.png`, etc.
- **Asistencia**: `asistencia_01_principal.png`, `asistencia_02_selector_fecha.png`, etc.
- **Personal**: `personal_01_principal.png`, `personal_02_btn_nuevo.png`, etc.
- **Dashboard**: `dashboard_01_principal.png`, `dashboard_02_selector_mes.png`, etc.
- **Instalación**: `instalacion_01_carpeta_drive.png`, `instalacion_02_descarga_apk.png`, etc.

---

## 🌐 Enlaces y Repositorios Oficiales
- **Repositorio de Código Fuente**: [https://github.com/Derom-rm27/Piloto-M-D](https://github.com/Derom-rm27/Piloto-M-D)
- **Distribución de Versiones Móviles (Android APK)**: `G:\Mi unidad\Procesos M&D\APLICACIONES\`
- **Distribución de Versiones para PC (Windows .EXE)**: `G:\Mi unidad\Procesos M&D\APLICACIONES\VERSION_PC\`
