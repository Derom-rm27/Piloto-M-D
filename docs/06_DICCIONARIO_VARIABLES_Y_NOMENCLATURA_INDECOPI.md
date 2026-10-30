# DICCIONARIO DE VARIABLES, NOMENCLATURA Y ESPECIFICACIÓN TÉCNICA
## REGISTRO DE SOPORTE LÓGICO (SOFTWARE) ANTE INDECOPI (D.L. 822)

---

### 1. DATOS GENERALES DE LA OBRA Y DEL AUTOR

| Campo | Especificación Oficial para INDECOPI |
| :--- | :--- |
| **Título de la Obra** | **Sistema Integrado de Control de Planta y Gestión de Manufactura - Procesos M&D** |
| **Autor y Desarrollador** | **Delfín Estanis Roque Mullisaca** |
| **Monograma / Iniciales de Autor** | **DERM** |
| **Afiliación Académica** | **Escuela Profesional de Ingeniería de Software y Sistemas** |
| **Institución Universitaria** | **Universidad Nacional de Juliaca (UNAJ)** |
| **Ubicación Geográfica** | Juliaca, San Román, Puno, Perú |
| **Año de Creación** | 2026 |
| **Naturaleza de la Obra** | Soporte Lógico (Software de Gestión de Manufactura y Control Industrial) |
| **Régimen de Creación** | Obra Originaria e Inédita (Creación Intelectual Individual) |
| **Lenguaje de Programación** | Dart 3.x / Framework Flutter 3.x |
| **Gestores de Base de Datos** | SQLite 3 (Persistencia Local Offline) / PostgreSQL en Supabase (Nube) |
| **Plataformas de Ejecución** | Android (Móvil) y Windows x64 (Escritorio) |
| **Identificador / Token de Obra** | `DERM-UNAJ-PROCESOSMD-PE-2026` |
| **Firma Criptográfica de Autoría** | `SHA256:d819e055d2dc4620b57d0266a00490cf:DERM:UNAJ` |

---

### 2. ANÁLISIS Y JUSTIFICACIÓN: ¿POR QUÉ NO INCLUIR NÚMERO DE VERSIÓN ANTE INDECOPI?

Siguiendo la recomendación del docente asesor y la doctrina registral de la **Dirección de Derecho de Autor del INDECOPI**, se sustenta la omisión expresa de números de versión (ej. *v1.0.0*, *v1.0.8*) en el título y en el petitorio registral por las siguientes razones técnico-legales fundamentales:

#### 2.1. Amplitud de la Cobertura Patrimonial y Moral (D.L. 822)
Cuando un autor inscribe un software con el nombre *"Software X versión 1.0"*, la resolución de registro ampara única y exclusivamente esa sub-versión literal depositada. Cualquier mejora funcional menor, parche o actualización futura podría ser interpretada por terceros como desprotegida o como una "obra derivada" que exigiría el pago de nuevas tasas administrativas y nuevos trámites de depósito. Al registrar la obra con su **título sustantivo e integral**:
> **"Sistema Integrado de Control de Planta y Gestión de Manufactura - Procesos M&D"**  
la protección autoral cubre la arquitectura, la lógica del negocio, las estructuras de datos y el conjunto de la solución sin encasillarla en un estado temporal.

#### 2.2. Evitar Requerimientos Administrativos de Tracto Sucesivo
Si en la solicitud de registro o en la carátula técnica se consigna un número como *v1.0.8*, los examinadores de INDECOPI suelen emitir requerimientos de aclaración tales como:
- *¿Dónde están depositadas las versiones 1.0.0 a 1.0.7?*
- *¿Constituye esta una obra derivada de una versión anterior? De ser así, acredite la titularidad originaria.*  
Omitir el número de versión permite registrar la obra como una **creación originaria, unitaria y completa**, agilizando el otorgamiento de la Partida Registral sin observaciones.

#### 2.3. Diferencia entre Nivel Legal (INDECOPI) vs. Nivel Técnico (Compilador)
- **Nivel Registral / INDECOPI**: El título legal de la obra **NO lleva versión**. Es el nombre de la creación intelectual.
- **Nivel Técnico de Compilación (Flutter / Android)**: En los archivos internos de compilación (`pubspec.yaml`, `AndroidManifest.xml`), el sistema operativo Android requiere técnicamente un número (`versionCode` / `versionName`) para permitir la instalación de paquetes APK en teléfonos celulares. Esto es un detalle técnico interno de empaquetado, no el nombre de la obra protegida.

---

### 3. POLÍTICA DE ORIGINALIDAD Y ESTÁNDAR DE NOMENCLATURA DERM-UNAJ

A fin de cumplir con el requisito de **Originalidad Sustancial y Autenticidad** que exige la Dirección de Derecho de Autor del INDECOPI conforme al Decreto Legislativo N° 822 (Ley sobre el Derecho de Autor del Perú), el código fuente incorpora un estándar formal de nomenclatura y particularidades estilísticas propias del autor **Delfín Estanis Roque Mullisaca (DERM - UNAJ)**.

#### 3.1. Reglas de Nomenclatura del Código Fuente
1. **Prefijo Monograma de Autor (`derm` / `DERM_`)**:
   - Variables de cálculo crítico, funciones utilitarias de balance, parámetros de control y modelos llevan incorporadas las iniciales del autor como prefijo identificador (`derm...`, `DERM_...`).
2. **Convención camelCase para Variables y Propiedades**:
   - Variables locales, parámetros y miembros de clase inician en minúscula con el prefijo o raíz semántica (ej. `dermStockActualKg`, `dermConsumoPorTurnoKg`, `dermMidnightDelta`).
3. **Convención SCREAMING_SNAKE_CASE para Constantes de Autor**:
   - Valores inmutables globales y firmas criptográficas utilizan mayúsculas separadas por guion bajo (ej. `DERM_AUTHOR_FULL_NAME`, `DERM_REGISTRATION_TOKEN`).
4. **Convención PascalCase para Clases y Tipos**:
   - Estructuras, modelos de dominio y controladores utilizan iniciales mayúsculas con firma del autor (ej. `DermAuthorIdentity`, `DermCoreUtils`, `InsumoItem`, `LoteItem`).
5. **Tipado Estricto (Strong Typing) y Null-Safety**:
   - Todas las variables se declaran explícitamente con su tipo o con inferencia inmutable (`final`, `const`), evitando variables dinámicas no tipadas (`dynamic`).

---

### 4. DICCIONARIO EXHAUSTIVO DE VARIABLES POR MÓDULO

#### Módulo 0: Identidad de Autor y Metadatos Legales (`derm_author_identity.dart`)

| Identificador de Variable | Tipo de Dato | Ámbito (Scope) | Particularidad / Prefijo | Propósito Técnico y Regla de Negocio |
| :--- | :--- | :--- | :--- | :--- |
| `dermAuthorFullName` | `String` | `static const` | `derm` (Autor) | Almacena el nombre legal completo: *"Delfín Estanis Roque Mullisaca"*. |
| `dermAuthorInitials` | `String` | `static const` | `derm` (Monograma) | Monograma oficial del autor: *"DERM"*. |
| `dermAuthorUniversity` | `String` | `static const` | `derm` (Universidad) | Entidad universitaria de formación: *"Universidad Nacional de Juliaca (UNAJ)"*. |
| `dermAuthorCareer` | `String` | `static const` | `derm` (Carrera) | Carrera profesional del autor: *"Ingeniería de Software y Sistemas"*. |
| `dermSoftwareTitle` | `String` | `static const` | `derm` (Obra) | Título oficial registrado para la obra de software ante INDECOPI (sin versión). |
| `dermRegistrationToken` | `String` | `static const` | `derm` (Token) | Código alfanumérico único para certificación de autenticidad en INDECOPI. |
| `dermAuthorSignatureHash` | `String` | `static const` | `derm` (Firma) | Hash criptográfico representativo del autor y de la institución UNAJ. |
| `dermEntrada` | `DateTime` | Parámetro formal | `derm` | Marca de tiempo (timestamp) de ingreso del trabajador al turno. |
| `dermSalida` | `DateTime` | Parámetro formal | `derm` | Marca de tiempo de retiro; se evalúa frente al cruce de medianoche. |
| `dermDiffMinutos` | `double` | Variable local | `derm` | Diferencia matemática en minutos entre entrada y salida con ajuste de +24h. |
| `dermMasaTerminadaKg` | `double` | Parámetro formal | `derm` | Masa neta en kilogramos de cajas y paquetes sellados en la jornada. |
| `dermMasaFormuladaKg` | `double` | Parámetro formal | `derm` | Masa teórica total preparada en la amasadora según número de batches. |
| `dermYield` | `double` | Variable local | `derm` | Porcentaje de rendimiento resultante ($(\text{Terminado} / \text{Formulado}) \times 100$). |

---

#### Módulo 1: Almacén y Control de Lotes PEPS (`warehouse_model.dart`, `warehouse_provider.dart`)

| Identificador de Variable | Tipo de Dato | Ámbito (Scope) | Prefijo / Firma | Propósito Técnico y Regla de Negocio |
| :--- | :--- | :--- | :--- | :--- |
| `dermTraceabilityTag` | `String` (Getter) | Miembro de clase | `derm` | Código de trazabilidad único por insumo: `DERM-INSUMO-{id}`. |
| `dermLoteTraceabilityTag` | `String` (Getter) | Miembro de clase | `derm` | Código de trazabilidad para cada lote: `DERM-LOTE-{id}-{lote}`. |
| `id` / `idNum` | `int` | Miembro (`InsumoItem`) | Estándar entero | Identificador numérico correlativo del insumo (1 al 19 en formulación). |
| `nombre` | `String` | Miembro (`InsumoItem`) | Texto descriptivo | Denominación comercial y técnica (ej. *"Harina de Trigo Especial"*). |
| `categoria` | `String` | Miembro (`InsumoItem`) | Enumeración lógica | Grupo de insumo: `'MATERIA_PRIMA'`, `'INSUMOS'`, `'EMPAQUES'`. |
| `unidad` | `String` | Miembro (`InsumoItem`) | Unidad de empaque | Presentación de compra (ej. *"Sacos x 50 kg"*, *"Cajas x 15 kg"*). |
| `kgPorUnidad` | `double` | Miembro (`InsumoItem`) | Factor de conversión | Equivalencia en masa de una unidad cerrada de compra hacia kilogramos. |
| `kgPorBatch` | `double` | Miembro (`InsumoItem`) | Receta estándar | Consumo teórico en kilogramos requerido para elaborar 1 batch de galleta. |
| `stockUnidades` | `double` | Miembro (`CoberturaTurno`)| Cantidad física | Saldo actual sumado de todos los lotes activos en sacos, cajas o bidones. |
| `stockKg` | `double` | Miembro (`CoberturaTurno`)| Masa disponible | Producto de `stockUnidades * kgPorUnidad`; representa el inventario en kg. |
| `kgNecesariosTurno` | `double` | Miembro (`CoberturaTurno`)| Consumo proyectado | Kilogramos requeridos para cumplir un turno completo (20 batches). |
| `batchesPosibles` | `int` | Miembro (`CoberturaTurno`)| Capacidad batch | Número entero de amasadas posibles con el stock actual disponible. |
| `turnosRinde` | `double` | Miembro (`CoberturaTurno`)| Cobertura temporal | Cantidad de guardias de producción continuas que soporta el inventario. |
| `esAlertaRoja` | `bool` | Miembro (`CoberturaTurno`)| Indicador booleano | `true` si `turnosRinde < 1.0` (nivel crítico de materia prima). |
| `faltaParaTurnoUnidades` | `int` | Miembro (`CoberturaTurno`)| Brecha de reposición | Unidades faltantes para garantizar al menos un turno completo de guardia. |
| `lote` / `nroLote` | `String` | Miembro (`LoteItem`) | Código de lote | Identificador de lote asignado por el fabricante o proveedor. |
| `fechaIngreso` | `String` | Miembro (`LoteItem`) | Fecha ISO-8601 | Fecha de arribo a la planta procesadora de M&D (`YYYY-MM-DD`). |
| `fechaVencimiento` | `String` | Miembro (`LoteItem`) | Criterio PEPS | Fecha de caducidad; define la cola de despacho prioritario (`ORDER BY ASC`). |
| `saldo` | `double` | Miembro (`LoteItem`) | Saldo restante | Unidades físicas vigentes en el lote disponibles para producción. |

---

#### Módulo 2: Producción, Jornadas y Balance de Materia (`production.dart`, `production_metrics.dart`)

| Identificador de Variable | Tipo de Dato | Ámbito (Scope) | Prefijo / Firma | Propósito Técnico y Regla de Negocio |
| :--- | :--- | :--- | :--- | :--- |
| `dermBatchWeightFactor` | `double` | Constante | `derm` | Peso estándar de formulación por receta según Fila 19 del Balance. |
| `idJornada` | `String` (UUID) | Miembro (`ProductionShift`)| Clave primaria | Código único de la jornada operativa generado en el dispositivo. |
| `fechaJornada` | `String` | Miembro (`ProductionShift`)| Fecha contable | Fecha de inicio de la guardia operativa (`YYYY-MM-DD`). |
| `turno` | `String` | Miembro (`ProductionShift`)| Clasificador | Turno de trabajo: `'Día'` (07:00 a 19:00) o `'Noche'` (19:00 a 05:00). |
| `linea` | `String` | Miembro (`ProductionShift`)| Línea fabril | Línea de procesamiento: `'Galletas'` o `'Barras'`. |
| `cantBatch` | `double` | Miembro (`ProductionShift`)| Volumen de mezcla | Número de batches de masa preparados en la amasadora en el turno. |
| `totalCajas` | `int` | Miembro (`ProductionShift`)| Producto terminado | Cantidad total de cajas terminadas de 30g o 48g listas para despacho. |
| `pesoTerminadoKg` | `double` | Variable de cálculo | Balance físico | Masa total calculada en base a cajas completas y paquetes sueltos. |
| `rendimiento` | `double` | Miembro (`ProductionShift`)| Métrica KPI | Rendimiento porcentual ($\ge 73.44\%$ óptimo, $< 73.44\%$ anómalo). |
| `mermaTotal` | `double` | Miembro (`ProductionShift`)| Desperdicio total | Sumatoria en kg de merma cruda, cocida, de empaque y bobinas. |
| `mermaPorcentaje` | `double` | Miembro (`ProductionShift`)| Porcentaje merma | Proporción de desperdicio respecto a la masa ingresada ($\le 26.56\%$). |
| `pesoBrutoBobina` | `double` | Miembro (`BobbinEntry`) | Pesaje inicial | Peso en báscula del rollo plástico antes de montar en la envasadora. |
| `pesoNetoBobina` | `double` | Miembro (`BobbinEntry`) | Consumo real | Película plástica efectivamente utilizada en el empaque de galletas. |
| `pesoTuco` | `double` | Miembro (`BobbinEntry`) | Desecho central | Peso del cilindro o cono de cartón interior de la bobina. |
| `pesoSobraBobina` | `double` | Miembro (`BobbinEntry`) | Merma de bobina | Retazo de plástico sobrante no consumido o defectuoso. |

---

#### Módulo 3: Asistencia y Cruce de Medianoche (`attendance.dart`, `attendance_calculator.dart`)

| Identificador de Variable | Tipo de Dato | Ámbito (Scope) | Prefijo / Firma | Propósito Técnico y Regla de Negocio |
| :--- | :--- | :--- | :--- | :--- |
| `dermConsolidatedRows` | `List<WorkerReportRow>` | Retorno de función | `derm` | Lista consolidada mensual con cálculo individual de días y horas. |
| `idRegistro` | `String` (UUID) | Miembro (`AttendanceEntry`)| Clave primaria | Identificador único de la marcación en SQLite y Supabase. |
| `idTrabajador` | `String` | Miembro (`AttendanceEntry`)| Clave foránea | Identificador del operario referenciado a la tabla `personal`. |
| `fechaJornada` | `String` | Miembro (`AttendanceEntry`)| Solución medianoche | Fecha en que comenzó la guardia; se mantiene para la salida en madrugada. |
| `tipo` | `String` | Miembro (`AttendanceEntry`)| Tipo de evento | `'ENTRADA'` o `'SALIDA'`. |
| `fechaHora` | `String` | Miembro (`AttendanceEntry`)| Timestamp ISO | Marca de tiempo exacta del reloj marcador en zona horaria UTC-5. |
| `diasLaborados` | `int` | Miembro (`WorkerReportRow`)| Acumulador | Conteo de días distintos efectivamente asistidos en el mes analizado. |
| `turnosDia` | `int` | Miembro (`WorkerReportRow`)| Conteo diurno | Guardias diurnas completadas por el trabajador en el periodo. |
| `turnosNoche` | `int` | Miembro (`WorkerReportRow`)| Conteo nocturno | Guardias nocturnas con cruce de medianoche completadas. |
| `horasTotales` | `double` | Miembro (`WorkerReportRow`)| Liquidación horas | Sumatoria de horas trabajadas para la planilla quincenal o mensual. |

---

#### Módulo 4: Personal y Nómina (`worker.dart`, `personnel_provider.dart`)

| Identificador de Variable | Tipo de Dato | Ámbito (Scope) | Prefijo / Firma | Propósito Técnico y Regla de Negocio |
| :--- | :--- | :--- | :--- | :--- |
| `id` / `idTrabajador` | `String` | Miembro (`Worker`) | Clave primaria | Código único del trabajador en la base de datos de planta. |
| `nombres` | `String` | Miembro (`Worker`) | Identidad personal | Nombres y apellidos completos del colaborador. |
| `dni` | `String` | Miembro (`Worker`) | Documento oficial | Documento Nacional de Identidad (8 dígitos numéricos). |
| `cargo` | `String` | Miembro (`Worker`) | Puesto laboral | Puesto en planta (Hornero, Envasador, Amasador, Calidad, etc.). |
| `activo` | `bool` | Miembro (`Worker`) | Borrado lógico | `true` = activo operativo; `false` = cesado (excluido de asistencia). |
| `linea` | `String` | Miembro (`Worker`) | Asignación fabril | Línea de trabajo habitual asignada en planta. |

---

#### Módulo 5: Persistencia, Base de Datos y Sincronización (`app_store.dart`)

| Identificador de Variable | Tipo de Dato | Ámbito (Scope) | Prefijo / Firma | Propósito Técnico y Regla de Negocio |
| :--- | :--- | :--- | :--- | :--- |
| `primaryKeys` | `Map<String, String>` | `const` global | Estructura core | Mapeo de claves primarias por entidad para SQLite y PostgreSQL. |
| `writableTables` | `Set<String>` | `const` global | Seguridad datos | Catálogo de tablas con permiso de escritura local en el dispositivo. |
| `remoteSyncTables` | `List<String>` | `const` global | Sincronización | Tablas autorizadas para sincronización bidireccional con Supabase. |
| `outbox` | `List<RowData>` | Tabla / Memoria | Cola transaccional | Registro de operaciones locales pendientes de envío a la nube. |
| `connected` | `bool` | Propiedad reactiva | Estado de red | `true` si el dispositivo tiene enlace activo y verificado con Supabase. |
| `syncing` | `bool` | Propiedad reactiva | Proceso en curso | `true` mientras se ejecuta el envío atómico de lotes en segundo plano. |
| `syncError` | `String?` | Propiedad reactiva | Diagnóstico | Mensaje detallado si ocurrió un conflicto `MD_CONFLICT` o fallo de red. |

---

### 5. GUÍA SINTÁCTICA DE DECLARACIÓN DE VARIABLES EN DART

A continuación se documenta el estándar sintáctico de codificación utilizado en el proyecto, diseñado para garantizar inmutabilidad, robustez en concurrencia y máxima eficiencia de memoria.

#### 5.1. Declaración de Variables Inmutables con Inferencia de Tipo (`final`)
Se utiliza para variables cuyo valor se calcula en tiempo de ejecución pero no volverá a ser reasignado, garantizando la inmutabilidad de los datos de planta:
```dart
// Declaración inmutable con prefijo de autor DERM
final dermMasaTerminadaKg = (cajasCompletas * 7.50) + (paquetesSueltos * 0.030);
final dermRendimientoCalculado = (dermMasaTerminadaKg / dermMasaFormuladaKg) * 100.0;
```

#### 5.2. Declaración de Constantes en Tiempo de Compilación (`const`)
Se utiliza para valores inalterables que se asignan en la etapa de compilación:
```dart
// Constantes oficiales con firma de autor DERM
const String DERM_AUTHOR_NAME = 'Delfín Estanis Roque Mullisaca';
const String DERM_INSTITUTION = 'Universidad Nacional de Juliaca (UNAJ)';
const double DERM_MIN_YIELD_THRESHOLD = 73.44; // Rendimiento mínimo
const double DERM_MAX_WASTE_THRESHOLD = 26.56; // Merma máxima
```

#### 5.3. Declaración de Variables con Null-Safety Estricto
Dart 3.x aplica seguridad contra valores nulos en tiempo de compilación. Las variables que admiten nulo se marcan explícitamente con `?`:
```dart
// Declaración de variable opcional segura
String? dermGuiaRemision; // Puede ser null si la entrada no requiere guía
String? dermObservacionesTurno;
```

#### 5.4. Declaración de Colecciones Fuertemente Tipadas
Las listas, mapas y conjuntos especifican siempre el tipo de dato de sus elementos:
```dart
// Listas y mapas fuertemente tipados
final List<InsumoItem> dermListaInsumos = <InsumoItem>[];
final Map<String, LoteItem> dermColaLotesPeps = <String, LoteItem>{};
```

#### 5.5. Declaración de Proveedores de Estado Reactivo (Riverpod)
La gestión de estado del sistema emplea `StateNotifierProvider` e inmutabilidad de estado:
```dart
// Proveedor reactivo de almacén con firma de autor
final warehouseProvider = StateNotifierProvider<WarehouseNotifier, WarehouseState>((ref) {
  final appStore = ref.watch(appStoreProvider);
  return WarehouseNotifier(appStore);
});
```

---

### 6. DECLARACIÓN JURADA DE AUTORÍA Y ORIGINALIDAD (PARA INDECOPI)

Yo, **Delfín Estanis Roque Mullisaca**, identificado con Documento Nacional de Identidad, estudiante de la **Escuela Profesional de Ingeniería de Software y Sistemas** de la **Universidad Nacional de Juliaca (UNAJ)**, declaro bajo juramento que el código fuente, la arquitectura lógica, los algoritmos de balance de masa y control PEPS, las interfaces gráficas y las estructuras de datos que componen la obra titulada:

> **"Sistema Integrado de Control de Planta y Gestión de Manufactura - Procesos M&D"**

constituyen una **creación intelectual original, inédita y de mi exclusiva autoría**, desarrollada aplicando las mejores prácticas de la ingeniería de software moderna, no constituyendo copia, reproducción no autorizada ni vulneración de derechos de propiedad intelectual de terceros, sometiéndome a las disposiciones y sanciones establecidas en el **Decreto Legislativo N° 822 (Ley sobre el Derecho de Autor)** y normativas complementarias de la República del Perú.

En fe de lo cual, se expide el presente documento para su incorporación formal en el expediente de Registro de Soporte Lógico (Software) ante la **Dirección de Derecho de Autor del INDECOPI**.

**Juliaca, Octubre de 2026.**

________________________________________
**Delfín Estanis Roque Mullisaca**  
Autor - Desarrollador de Software  
Escuela Profesional de Ingeniería de Software y Sistemas  
**Universidad Nacional de Juliaca (UNAJ)**  
Monograma / Firma: **DERM**
