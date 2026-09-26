# Procesos M&D - Aplicación Flutter

## Alcance y fuentes

Implementación sobre el proyecto Flutter existente de `D:\PROCESOS MD`. Referencias: `app_completa.html`, hojas `Informe Galletas`, `Informe Barras` y `Balance_Galletas` de `Procesos M&D Piloto.xlsx`, y las dos fotografías de informes. El HTML y el Excel original se conservan.

El MCP confirmó el proyecto `mkecqennrzncqrrsmqwt` (piloto m&d), activo. La documentación anterior de migración quedó desactualizada: al iniciar este trabajo existían 46 trabajadores, 558 marcaciones, 5 jornadas, 6 lotes y 19 bobinas. La aplicación descarga el estado remoto actual; no carga los datos ficticios del HTML ni vuelve a importar el Excel.

## Módulos

- `lib/core/data`: SQLite, cola persistente y sincronización.
- `lib/core/domain`: asistencia, fechas de jornada y balance de materia.
- `lib/core/theme`: colores, espaciados y temas. `AppColors`, `AppSpacing` y `Appearance` concentran los valores editables. Los botones pueden tener un color distinto al principal.
- `lib/shared`: campos, tarjetas, indicadores y controles compartidos.
- `lib/features`: dashboard, asistencia, personal, producción, reportes y configuración.

La navegación lateral permanece visible desde 1050 px; en móvil se abre como menú. Formularios adaptables y tablas con desplazamiento horizontal. Modo claro/oscuro, tipografías y vista previa solo en Configuración. No hay panel derecho ni selector de tema en el encabezado. El indicador verde/rojo comprueba acceso al servicio de datos; una red Wi-Fi disponible sin acceso a Supabase no se considera conectada.

## Operación local y sincronización

SQLite guarda registros y una cola `outbox` en una misma transacción. Guardar un formulario no depende de internet. Los registros usan UUID generados una sola vez en el dispositivo. Jornadas, lotes, bobinas y sus anulaciones se envían como un conjunto transaccional mediante `md_apply_changes`.

La función verifica tablas permitidas, columnas y valores anteriores. Normaliza tipos PostgreSQL, incluidas fechas, antes de comparar. Un reintento con igual UUID y los mismos datos se reconoce como aplicado; no crea otro registro. Si los datos remotos cambiaron, se conserva la cola y se muestra un conflicto. Configuración permite comparar el envío pendiente con el servidor y decidir conservar los cambios locales. La nueva comprobación condicional evita sobrescribir un cambio posterior a esa revisión.

Sincronización al iniciar, al recuperar el foco, manualmente y cada 30 segundos mientras la aplicación está ejecutándose. No se promete ejecución en segundo plano con la aplicación cerrada. Cada descarga recorre páginas de 500 registros. Las ediciones locales pendientes no se reemplazan por una descarga. Si se recibe un error o se pierde una respuesta, el envío permanece pendiente.

En Android, iOS, macOS, Linux y Windows el archivo está en el directorio de soporte de la aplicación. En web se usa SQLite WASM persistido mediante IndexedDB por el paquete `sqflite_common_ffi_web`; limpiar los datos del navegador elimina esa copia. La primera descarga de datos exige conexión. Se incluye exportación de respaldo JSON con registros y cola; la restauración/importación no está implementada.

Las anulaciones usan `deleted_at`; no borran físicamente el histórico. Las consultas de Flutter excluyen anulados. Las antiguas vistas SQL y el HTML no conocen este campo: no deben utilizarse simultáneamente para elaborar reportes finales después de anular registros en Flutter. El borrado físico desde herramientas externas se refleja en la siguiente descarga si no hay cambios locales pendientes.

## Asistencia

Columnas PDF y XLSX: `#`, `Trabajador`, `Días Laborados`, `Turnos Día`, `Turnos Noche`, `Horas Totales`. El nombre incluye ambos apellidos. El mes se filtra por fecha de inicio de jornada, no por fecha calendario de la salida. La pantalla operativa excluye inactivos, pero el reporte incluye su histórico del mes.

Se agrupan trabajador, fecha de jornada, turno y línea. Las parejas entrada/salida se procesan cronológicamente; no se suman salidas solas, entradas sin salida, duplicaciones ambiguas ni intervalos superiores a 24 horas. Los días se cuentan una sola vez aunque existan varios intervalos. Una salida nocturna de madrugada pertenece al día de inicio; la captura de horas se interpreta en America/Lima (UTC-5). Las incidencias se muestran y no se convierten artificialmente en horas pagables. No se descuentan descansos que no estén registrados ni se calculan tarifas o pagos no solicitados.

## Jornadas y reportes

Una jornada admite varios lotes y varias bobinas. Presentaciones disponibles: 30 gr y 48 gr. Se conservan los códigos de lote como texto, incluidos ceros iniciales. Bobinas: peso bruto, peso neto, tuco/envoltorio y sobra. Mermas y bobinas pertenecen a la jornada, no se reparten arbitrariamente entre lotes.

PDF A4 con dos fichas por hoja, conforme a las fotografías. Se genera una ficha por lote: las mermas, batches y bobinas globales aparecen en la primera ficha; quedan vacías en las siguientes. Los lotes se ordenan por código para mantener estable cuál es la primera ficha. Una ficha contiene 11 bobinas; si hay más, se añade continuación sin repetir producción ni mermas. Observaciones largas deben comprobarse en la vista previa antes de imprimir.

Se pueden seleccionar varias jornadas del filtro visible y generar un PDF conjunto para imprimir en bloque. La vista previa permite guardar, compartir o imprimir. La exportación Excel es XLSX real, conserva tipos numéricos y las columnas de detalle por lote; no repite las mermas de una jornada en cada fila.

Todo el texto de los PDF se fija en negro sobre fondo blanco, independientemente del tema de la aplicación.

## Balance de materia confirmado por el usuario

Merma máxima del material ingresado: **26,56%**. Rendimiento mínimo: **73,44%**. Peso formulado por batch según fila 19 de `Balance_Galletas`: Quinua 122,01 kg; Kiwicha 117,91 kg; Integral 118,51 kg; Maca 117,51 kg; Cajamarquina y Cereales 120,51 kg.

Conversión confirmada: galletas 30 g × 250 unidades = 7,50 kg/caja; galletas 48 g × 160 unidades = 7,68 kg/caja. Rendimiento = peso terminado / peso formulado total × 100. Cajas mínimas esperadas = peso formulado × 0,7344 / peso de la caja. La fórmula se documenta aquí y no se muestra dentro del módulo Rendimiento.

El Excel calcula cajas aproximadas con paquetes de 32 g y 250 unidades. Sus cantidades aproximadas no se copian como si correspondieran a 30 g: se recalculan con las presentaciones confirmadas. El umbral uniforme de 26,56% prima sobre las pequeñas diferencias de redondeo en dos columnas del Excel.

Si todos los lotes son del mismo producto, los batches de la jornada determinan la masa de entrada. Si hay varios productos, el formulario requiere distribuir los batches por lote y comprobar la suma. Sin receta o batches suficientes no se inventa un porcentaje. Un resultado superior a 100% se marca para revisar datos. Las barras tienen 96 unidades por caja, pero su balance, ingredientes y rendimiento quedan pendientes por instrucción expresa del usuario.

Las barras del dashboard abren el detalle de la jornada. Verde: rendimiento entre 73,44% y 100%; naranja: fuera de ese intervalo. No se incluye la sección «Últimos registrados» en Rendimiento.

## Base remota y seguridad existente

Cambios aditivos: `deleted_at` en las cinco tablas editables, campos de tuco y sobra por bobina, pop quinua de dosimetría y batches por lote; función transaccional `md_apply_changes`. Definición final en `supabase/schemas/offline_sync.sql`, como referencia del estado aplicado, no como una sustitución completa del esquema. Las migraciones remotas del MCP conservan su historial.

Se usa exclusivamente la clave **publishable**, nunca `service_role`. El MCP y una consulta de privilegios confirmaron que las tablas existentes tienen RLS desactivado y permisos de lectura/escritura para `anon` y `authenticated`. Esto permite a cualquiera que obtenga la clave pública acceder a los datos; es una exposición real del backend existente, no una protección de usuario único. Se mantiene la preferencia anterior de no activar RLS en este trabajo. Antes de distribución pública corresponde decidir autenticación/políticas o un backend privado. La aplicación no debe presentarse como un sistema con control de acceso ya implementado.

## Ejecutar y compilar

```powershell
flutter pub get
dart run sqflite_common_ffi_web:setup
flutter run -d windows
flutter run -d chrome
flutter build apk --debug
flutter build web --release
flutter test
flutter analyze
```

El backend predeterminado es el proyecto verificado. Se puede sustituir mediante `--dart-define=SUPABASE_URL=...` y `--dart-define=SUPABASE_PUBLISHABLE_KEY=...`. Utilizar un directorio de datos distinto si se cambia de proyecto: no mezclar la cola pendiente de dos bases distintas.

iOS y macOS requieren compilación en macOS con Xcode. Linux requiere su toolchain nativo. Un build web no certifica compilación ni ejecución nativa en esas plataformas.

Referencias técnicas consultadas: [Flutter offline first](https://docs.flutter.dev/app-architecture/design-patterns/offline-first), [Supabase Flutter](https://supabase.com/docs/reference/dart/upsert), [changelog Supabase](https://supabase.com/changelog), [RLS](https://supabase.com/docs/guides/database/postgres/row-level-security).
