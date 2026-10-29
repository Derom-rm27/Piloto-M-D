# Manual de Uso - Módulo de Personal
**Sistema Integrado de Control de Planta - Procesos M&D**

---

## 1. Introducción
El **Módulo de Personal** administra la nómina de trabajadores de planta (operarios, maquinistas, estibadores, personal de calidad y supervisores). 

Garantiza la integridad histórica de los registros laborales implementando el ciclo de vida **Activo / Inactivo**, protegiendo las bases de datos de eliminaciones accidentales que romperían la trazabilidad de la asistencia y la producción pasada. Cumple estrictamente con las directrices de interfaz de **listas ultra-limpias** y alta accesibilidad de planta.

---

## 2. Requisitos y Permisos
- **Dispositivos Compatibles**: Aplicación móvil Android y aplicación de escritorio Windows.
- **Acceso**: Supervisores de Producción, Jefatura de Planta y Recursos Humanos.
- **Operación**: Funcionalidad con persistencia local SQLite y sincronización bidireccional con Supabase.

---

## 3. Interfaz Principal del Módulo

![Pantalla Principal del Módulo de Personal](assets/docs/personal_01_principal.png)

### Componentes de la Pantalla:
1. **Pestañas de Filtrado por Estado**:
   - Pestaña **Activos**: Lista de trabajadores vigentes para la operación diaria.
   - Pestaña **Inactivos**: Histórico de extrabajadores, personal con licencia o cesados.
2. **Buscador Dinámico**:
   - Filtrado en tiempo real por nombres, apellidos o número de DNI.
3. **Lista Operativa Ultra-Limpia ("Solo Nombre")**:
   - Cada tarjeta muestra **estrictamente el nombre completo del trabajador**.
   - No contiene textos secundarios, DNI, cargo ni pastillas verdes en la primera vista para maximizar la velocidad de lectura y evitar saturación visual en planta.
4. **Botón Flotante "Nuevo Personal" (+)**:
   - Permite registrar rápidamente una nueva alta en la nómina.

---

## 4. Flujo de Uso Paso a Paso

### Paso 1: Registro de un Nuevo Trabajador
1. En la pantalla principal de Personal, presiona el botón **"+ Nuevo Trabajador"**.
   
   ![Botón Nuevo Trabajador](assets/docs/personal_02_btn_nuevo.png)

2. Se desplegará el modal **"Registro de Personal"**.
   
   ![Modal de Registro de Personal](assets/docs/personal_03_modal_nuevo.png)

3. Completa los campos requeridos:
   - **Nombres y Apellidos Completos**: Escribe ambos apellidos y nombres para evitar homónimos.
   - **DNI**: Documento Nacional de Identidad (8 dígitos numéricos).
   - **Cargo / Puesto**: Operario de Envasado, Amasador, Maquinista, Hornero, Supervisor, etc.
   - **Línea Asignada Habitual**: Línea Galletas, Línea Barras o Planta General.
4. Presiona el botón **"Guardar Trabajador"**. El nuevo colaborador aparecerá inmediatamente en la lista de activos y estará disponible para el control de asistencia.

---

### Paso 2: Consulta de la Ficha del Trabajador (Modal)
Para ver los detalles completos de un trabajador sin saturar la lista principal:
1. Haz un toque o clic sobre cualquier tarjeta de la lista de trabajadores.
   
   ![Selección de Tarjeta](assets/docs/personal_04_click_tarjeta.png)

2. Se abrirá la **Ficha del Trabajador (Modal)**:
   
   ![Ficha del Trabajador Modal](assets/docs/personal_05_modal_ficha.png)

   En esta ventana modal se visualizan:
   - Nombres y apellidos completos.
   - Número de DNI.
   - Cargo y puesto en planta.
   - Estado actual (**Activo** o **Inactivo**).
   - Botón **"Editar Datos"**.
   - Botón de cambio de estado (**"Desactivar"** / **"Reactivar"**).
   - Botón de eliminación (**"Eliminar"**).

---

### Paso 3: Edición de Datos del Trabajador
1. Dentro de la Ficha del Trabajador, haz clic en **"Editar Datos"**.
   
   ![Botón Editar Datos](assets/docs/personal_06_btn_editar.png)

2. Actualiza los campos necesarios (corrección ortográfica de nombres, actualización de cargo, etc.).
3. Presiona **"Guardar Cambios"**.

---

### Paso 4: Desactivar Personal (Pase a Inactivo)
Cuando un trabajador deja de laborar en planta temporal o definitivamente:
1. Abre su Ficha de Trabajador.
2. Presiona el botón **"Desactivar"** o cambia el selector de estado a **Inactivo**.
   
   ![Acción Desactivar](assets/docs/personal_07_desactivar.png)

3. Confirma la acción en el cuadro de diálogo.
4. **Efecto Inmediato**:
   - El trabajador pasará automáticamente a la pestaña **Inactivos**.
   - Quedará **excluido de forma estricta e instantánea** del módulo de Asistencia diaria.
   - Su histórico de marcaciones pasadas, horas acumuladas y turnos trabajados permanecerá **completamente intacto** para reportes mensuales.

---

### Paso 5: Reactivación en 1 Solo Clic
Si un trabajador reingresa a laborar a la planta:
1. En la pantalla principal de Personal, haz clic en la pestaña **Inactivos**.
   
   ![Pestaña Inactivos](assets/docs/personal_08_pestana_inactivos.png)

2. Localiza al colaborador en la lista y abre su Ficha.
3. Presiona el botón verde **"Reactivar Trabajador"**.
   
   ![Botón Reactivar](assets/docs/personal_09_btn_reactivar.png)

4. El trabajador retornará inmediatamente a la lista de **Activos** y reaparecerá disponible en el módulo de Asistencia diaria.

---

## 5. Reglas de Negocio y Seguridad de Datos

### 1. Columna `activo` y Borrado Lógico
- La tabla de base de datos `public.personal` incluye la columna `activo boolean NOT NULL DEFAULT true`.
- **Prohibición de Eliminación Física (`DELETE`)**:
  - Está estrictamente prohibido ejecutar un `DELETE` físico en la base de datos sobre trabajadores que cuenten con historial de asistencia o producción. Un borrado físico causaría errores de clave foránea y alteraría las liquidaciones pasadas.
  - El botón **"Eliminar"** solo debe utilizarse excepcionalmente para trabajadores registrados por error que nunca hayan registrado marcaciones.

### 2. Directriz de Interfaz: Listas Ultra-Limpias ("Solo Nombre")
- **Primera Vista**: Las tarjetas de trabajadores muestran únicamente el nombre completo.
- **Detalles encapsulados**: El DNI, cargo y controles de edición residen exclusivamente dentro de la Ficha Modal para mantener un diseño visual despejado y rápido.

### 3. Estándar de Contraste en Botones Destructivos
- Los botones de acción crítica (`Desactivar`, `Eliminar`) utilizan fondo rojo sólido (`#dc2626`) con tipografía blanca pura (`#ffffff !important`), asegurando legibilidad total en entornos de alta iluminación en planta.

---

## 6. Errores Comunes y Soluciones

| Problema Observado | Causa | Solución |
| :--- | :--- | :--- |
| **"No se puede eliminar el trabajador porque tiene marcaciones asociadas"** | Se intentó borrar a un trabajador que ya cuenta con asistencia registrada en meses previos. | En lugar de eliminar, utilice el botón **"Desactivar"**; esto lo retirará de las operaciones diarias sin dañar el histórico. |
| **"El DNI ingresado ya existe"** | Se intentó registrar a un colaborador ya existente en la base de datos. | Busque al trabajador por DNI en el buscador (verifique tanto en la pestaña *Activos* como en *Inactivos*) y edite su ficha en lugar de crear un duplicado. |
| **"Un trabajador activo no aparece en el selector de asistencia"** | Su estado figura como inactivo en la base de datos. | Abra la pestaña *Inactivos*, localice al trabajador y presione **"Reactivar"**. |

---

## 7. Consejos de Gestión de Nómina en Planta
1. **Actualización Semanal**: El área de Recursos Humanos o supervisión debe revisar la pestaña de inactivos al final de cada semana para mantener la nómina al día.
2. **Cargos Estandarizados**: Utilice los cargos definidos por la empresa (Operario, Hornero, Amasador, Envasador, Control de Calidad) para facilitar filtros y auditorías.
3. **Resguardo de Datos**: Toda modificación en personal se sincroniza automáticamente con la nube una vez que el equipo cuente con conexión.

---

## 8. Arquitectura y Código Fuente Relacionado

- **Modelo de Dominio**: `lib/core/domain/personnel.dart`
  - Clase: `PersonnelItem` (campos `id`, `nombres`, `dni`, `cargo`, `activo`, `linea`).
- **Gestión de Estado**: `lib/presentation/state/personnel_provider.dart`
  - Filtros: `activePersonnelProvider`, `inactivePersonnelProvider`.
- **Vistas**: `lib/presentation/modules/personnel/personnel_view.dart`
- **Tabla de Base de Datos**: `public.personal`
