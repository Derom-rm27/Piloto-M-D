# Migración del Excel a Supabase

Estado: **preparada y validada localmente; NO aplicada al servidor**.
Proyecto solicitado: `mkecqennrzncqrrsmqwt`.

El MCP quedó configurado y el comando de autenticación terminó correctamente. Esta sesión no recibió las herramientas nuevas. Reiniciar Codex permite intentar cargarlas y continuar con la inspección del esquema remoto, aplicación y verificación. No se ha comprobado todavía que la cuenta autorizada tenga acceso al proyecto.

## Archivos

- `preparar.py`: extracción reproducible, no guarda ni modifica el Excel.
- `carga_preparada.sql`: esquema, datos y comprobaciones en una transacción; falla si ya existe alguna tabla destino en `public` para evitar reemplazar trabajo existente.
- `datos_normalizados.json`: datos destinados a las tablas.
- `auditoria.json`: huella del Excel, conteos, diferencias de presentaciones y nombres pendientes de conciliar.
- `validar.py`: comprueba claves, relaciones, conteos y reconciliación local. No certifica compatibilidad PostgreSQL.

## Modelo y decisiones

15 tablas: personal, líneas, productos, insumos, presentaciones de insumos, jornadas, bobinas, lotes, marcaciones, capturas masivas, participantes de capturas, consumos, recetas e ingredientes de recetas (con una tabla de atributos de insumos utilizados en recetas).

Se mantienen los identificadores originales. Los códigos de lote son texto para conservar `0306`. Los valores monetarios y cantidades usan `numeric`; los teléfonos y DNI se conservan como texto. Las fechas de registro se mantienen como hora local sin asignar un huso que no figura en el archivo.

Los espacios al final de categorías y líneas se eliminan. Los nombres de ingredientes se comparan ignorando mayúsculas y tildes; los nombres dudosos no se fusionan automáticamente: `SALVAJE`, `SALVAJE DE TRIGO` y `Salvado de trigo`, o `MANTECA` y `Manteca vegetal`. El ID 36 sin nombre se conserva como incompleto.

Las presentaciones del catálogo y las usadas en recetas se conservan por separado: son datos diferentes y hay siete diferencias de peso. No se asume que una receta equivalga automáticamente a un producto comercial; faltan enlaces explícitos y no existe un producto inequívoco para la receta CEREALES.

Las 12 columnas de pesos de bobinas se transforman en 19 filas. Se conserva `cant_bobinas` como cantidad declarada, porque puede expresar un valor distinto de los pesos registrados. El significado exacto de `bobina_1` se mantiene como `peso_reportado`, sin inventar que es peso neto o consumo.

Las 60 capturas masivas y sus 613 participantes son historial de captura, no otras 613 marcaciones. La asistencia operativa tiene exclusivamente las 546 filas de Registro. No había duplicados idénticos entre todos sus atributos distintos del ID. No se eliminan eventos por coincidir parcialmente en trabajador o fecha.

Los informes, Resumen Asistencia y Jornadas_Personal son salidas calculadas y se conservan en el Excel original. No se importan como tablas duplicadas. El SQL incorpora vistas de producción por jornada y totales de recetas. La reconstrucción completa de asistencia y nómina requiere definir el emparejamiento de entradas/salidas y descansos; no se copia la fórmula que toma la primera salida sin todas las claves de turno y línea. No se ha implementado esa reconstrucción ni la interfaz Flutter.

Las 6 recetas contienen 76 ingredientes no nulos y no cero. Las sumas coinciden exactamente con los seis totales del Excel. Merma y rendimiento se calculan desde los supuestos de porcentaje; el Excel guarda algunos resultados redondeados, conservados en la auditoría. Los 32 g de la receta y la presentación de 30 Gr en lotes no se igualan arbitrariamente. Los valores auxiliares de los informes y la anotación aislada M13 de Balance_Galletas permanecen en el Excel original.

La hoja material no contiene consumos: la tabla queda vacía. Las cantidades de los lotes suman 983 en la unidad declarada por los productos (Cajas). No se transforma ese total a kg sin información adicional.

## RLS y continuación

RLS queda desactivado según lo solicitado. Las tablas creadas en `public` no otorgan acceso a `anon` ni a `authenticated`; trabajar sin RLS no implica publicar los datos. La conexión desde una futura aplicación y la exposición de API aún no están configuradas.

Antes de ejecutar el SQL: comprobar proyecto y tablas existentes usando el MCP. Si hay datos previos, comparar y adaptar la carga, sin borrar ni reemplazar tablas. Aplicar la transacción y ejecutar los conteos, claves foráneas y vistas en PostgreSQL; revisar asesores documentando la excepción de RLS. Solo entonces cambiar el estado a migrado. No ejecutar otra vez el archivo sobre tablas ya creadas. No se modifican permisos de otras tablas del esquema public.

No se ha medido reducción de almacenamiento remoto: un XLSX comprimido no es comparable directamente con el tamaño de tablas e índices PostgreSQL.
