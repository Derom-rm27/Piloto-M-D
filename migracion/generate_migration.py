import pandas as pd
import uuid
import datetime
import numpy as np

def generate_uuid(name):
    if pd.isna(name) or str(name).strip().lower() in ('nan', 'nat', 'none', ''):
        return None
    return str(uuid.uuid5(uuid.NAMESPACE_OID, str(name).strip()))

def escape_sql(val):
    if pd.isna(val) or str(val).strip().lower() in ('nan', 'nat', 'none', ''):
        return "NULL"
    if isinstance(val, (int, float, np.integer, np.floating)):
        return str(val)
    if isinstance(val, (datetime.datetime, datetime.date, pd.Timestamp)):
        return f"'{val.strftime('%Y-%m-%d %H:%M:%S')}'"
    val_str = str(val).replace("'", "''")
    return f"'{val_str}'"

excel_path = r"d:\PROCESOS MD\Procesos M&D Piloto.xlsx"
xls = pd.ExcelFile(excel_path)

out_sql = open(r"d:\PROCESOS MD\supabase\migrations\20260910200000_seed_and_fixes.sql", "w", encoding="utf-8")

# 1. ALTER TABLE para columnas omitidas
out_sql.write("-- Agregando columnas omitidas\n")
out_sql.write("ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS cant_batch DECIMAL(10, 2);\n")
out_sql.write("ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS cant_extruido_tolva DECIMAL(10, 2);\n")
out_sql.write("ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS pop_kiwicha DECIMAL(10, 2);\n")
out_sql.write("ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS pop_quinua DECIMAL(10, 2);\n")
out_sql.write("ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS merma_piso DECIMAL(10, 2);\n\n")

# 2. CREATE TABLE para recetas
out_sql.write("-- Creando tabla de recetas (Balance Galletas)\n")
out_sql.write("""CREATE TABLE IF NOT EXISTS public.recetas (
    id_receta UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_receta VARCHAR(255) NOT NULL, -- ej: QUINUA (kg)
    id_materia_prima UUID NOT NULL REFERENCES public.productos_mp(id_producto) ON DELETE CASCADE,
    cantidad DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
\n""")

# 3. PERSONAL
df_personal = pd.read_excel(xls, sheet_name="Personal")
out_sql.write("-- Insertando Personal\n")
for _, row in df_personal.iterrows():
    id_trab = generate_uuid(row['id_trabajador'])
    if not id_trab: continue
    nombre = escape_sql(row['nombre'])
    ap = escape_sql(row['apellido_paterno'])
    am = escape_sql(row['apellido_materno'])
    dni = escape_sql(row['DNI'])
    if dni != "NULL" and dni.endswith(".0"): dni = f"'{dni[1:-3]}'" # strip ' and .0'
    elif dni != "NULL": dni = escape_sql(str(int(float(row['DNI'])))) if isinstance(row['DNI'], float) else escape_sql(row['DNI'])
    
    tel = escape_sql(row['Telefono'])
    cargo = escape_sql(row['Cargo'])
    ph = escape_sql(row['precio_h'])
    fr = escape_sql(row['Fecha_registro'])
    
    out_sql.write(f"INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) "
                  f"VALUES ('{id_trab}', {nombre}, {ap}, {am}, {dni}, {tel}, {cargo}, {ph}, {fr}) ON CONFLICT DO NOTHING;\n")

# 4. PRODUCTOS_MP
df_mp = pd.read_excel(xls, sheet_name="Productos_MP")
out_sql.write("\n-- Insertando Productos MP\n")
# clean up 'Id_producto ' column name
mp_id_col = [c for c in df_mp.columns if 'Id_producto' in c][0]
for _, row in df_mp.iterrows():
    id_prod = generate_uuid(row[mp_id_col])
    if not id_prod: continue
    nombre = escape_sql(row['Nombre_producto'])
    um = escape_sql(row['Unidad_medida'])
    cat = escape_sql(row['Categoria'])
    out_sql.write(f"INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) "
                  f"VALUES ('{id_prod}', {nombre}, {um}, {cat}) ON CONFLICT DO NOTHING;\n")

# 5. PRODUCTOS_ENVASADOS
df_env = pd.read_excel(xls, sheet_name="Productos_envasados")
out_sql.write("\n-- Insertando Productos Envasados\n")
env_id_col = [c for c in df_env.columns if 'Id_producto' in c][0]
for _, row in df_env.iterrows():
    id_prod = generate_uuid(row[env_id_col])
    if not id_prod: continue
    nombre = escape_sql(row['Nombre_producto'])
    tipo = escape_sql(row['Tipo'])
    um = escape_sql(row['Unidad_medida'])
    out_sql.write(f"INSERT INTO public.productos_envasados (id_producto, nombre_producto, tipo, unidad_medida) "
                  f"VALUES ('{id_prod}', {nombre}, {tipo}, {um}) ON CONFLICT DO NOTHING;\n")

# 6. REGISTRO ASISTENCIA
df_reg = pd.read_excel(xls, sheet_name="Registro")
out_sql.write("\n-- Insertando Registro Asistencia\n")
for _, row in df_reg.iterrows():
    id_reg = generate_uuid(row['id_registro'])
    if not id_reg: continue
    id_trab = generate_uuid(row['trabajador'])
    # Combine Fecha and Hora or use FechaHora
    fh = escape_sql(row['FechaHora'])
    if fh == "NULL":
        # Fallback to Fecha + Hora if needed, but FechaHora seems mostly populated
        pass
    tipo = escape_sql(row['tipo'])
    turno = escape_sql(row['Turno'])
    linea = escape_sql(row['Linea'])
    
    out_sql.write(f"INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) "
                  f"VALUES ('{id_reg}', '{id_trab}', {fh}, {tipo}, {turno}, {linea}) ON CONFLICT DO NOTHING;\n")

# 7. JORNADAS PRODUCCION
df_jor = pd.read_excel(xls, sheet_name="Jornadas")
out_sql.write("\n-- Insertando Jornadas Producción y Bobinas\n")
for _, row in df_jor.iterrows():
    id_jor = generate_uuid(row['id_jornada'])
    if not id_jor: continue
    fecha = escape_sql(row['fecha'])
    turno = escape_sql(row['turno'])
    tipo = escape_sql(row['tipo'])
    id_sup = generate_uuid(row['cargo'])
    if id_sup: id_sup = f"'{id_sup}'"
    else: id_sup = "NULL"
    
    # Mermas
    mpc = escape_sql(row.get('merma_piso_crudo', None))
    mm = escape_sql(row.get('merma_maquina', None))
    quem = escape_sql(row.get('quemados', None))
    caja = escape_sql(row.get('caja', None))
    mpcoc = escape_sql(row.get('merma_piso_cocido', None))
    ce = escape_sql(row.get('cinta_embalaje', None))
    tamp = escape_sql(row.get('tampon', None))
    mbob = escape_sql(row.get('merma_bobinas', None))
    sbob = escape_sql(row.get('Sobra_bobina', None))
    cbatch = escape_sql(row.get('cant_batch', None))
    cet = escape_sql(row.get('cant_extruido_tolva', None))
    pkiw = escape_sql(row.get('pop_kiwicha', None))
    pqui = escape_sql(row.get('pop_quinua', None))
    mpiso = escape_sql(row.get('merma_piso', None))
    obs = escape_sql(row.get('observaciones', None))
    created = escape_sql(row.get('datetime', None))
    
    out_sql.write(f"INSERT INTO public.jornadas_produccion (id_jornada, fecha, turno, tipo, id_supervisor, "
                  f"merma_piso_crudo, merma_maquina, quemados, caja, merma_piso_cocido, cinta_embalaje, tampon, "
                  f"merma_bobinas, sobra_bobina, cant_batch, cant_extruido_tolva, pop_kiwicha, pop_quinua, merma_piso, observaciones, created_at) "
                  f"VALUES ('{id_jor}', {fecha}, {turno}, {tipo}, {id_sup}, "
                  f"COALESCE({mpc}, 0), COALESCE({mm}, 0), COALESCE({quem}, 0), COALESCE({caja}, 0), COALESCE({mpcoc}, 0), COALESCE({ce}, 0), COALESCE({tamp}, 0), "
                  f"COALESCE({mbob}, 0), COALESCE({sbob}, 0), COALESCE({cbatch}, 0), COALESCE({cet}, 0), COALESCE({pkiw}, 0), COALESCE({pqui}, 0), COALESCE({mpiso}, 0), {obs}, COALESCE({created}, NOW())) ON CONFLICT DO NOTHING;\n")

    # Bobinas
    for i in range(1, 7):
        pb_col = f'pb_bobina_{i}'
        b_col = f'bobina_{i}'
        if pb_col in row and b_col in row:
            pb = escape_sql(row[pb_col])
            bn = escape_sql(row[b_col])
            if pb != "NULL" and bn != "NULL":
                id_bob = generate_uuid(f"{row['id_jornada']}_bobina_{i}")
                out_sql.write(f"INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) "
                              f"VALUES ('{id_bob}', '{id_jor}', {i}, {pb}, {bn}) ON CONFLICT DO NOTHING;\n")

# 8. LOTES
df_lotes = pd.read_excel(xls, sheet_name="Lotes")
out_sql.write("\n-- Insertando Lotes\n")
for _, row in df_lotes.iterrows():
    id_lote = generate_uuid(row['id_lote'])
    if not id_lote: continue
    id_jor = generate_uuid(row['jornada'])
    id_prod = generate_uuid(row['producto'])
    nlote = escape_sql(row['lote'])
    fven = escape_sql(row['f_vencimiento'])
    cant = escape_sql(row['cantidad'])
    created = escape_sql(row['datetime'])
    
    out_sql.write(f"INSERT INTO public.lotes_produccion (id_lote, id_jornada, id_producto, numero_lote, f_vencimiento, cantidad, created_at) "
                  f"VALUES ('{id_lote}', '{id_jor}', '{id_prod}', {nlote}, {fven}, COALESCE({cant}, 0), COALESCE({created}, NOW())) ON CONFLICT DO NOTHING;\n")

# 9. BALANCE GALLETAS (RECETAS)
df_bal = pd.read_excel(xls, sheet_name="Balance_Galletas")
out_sql.write("\n-- Insertando Recetas (Balance Galletas)\n")
# Mapeo tentativo: buscamos el id_materia_prima por nombre
out_sql.write("""
DO $$
DECLARE
    mp_id UUID;
BEGIN
""")
for _, row in df_bal.iterrows():
    insumo = escape_sql(row['INSUMO / MATERIA PRIMA'])
    # Iterar por los productos finales: QUINUA, KIWICHA, INTEGRAL, MACA, CAJAMARQUINA, CEREALES
    for receta in ['QUINUA (kg)', 'KIWICHA (kg)', 'INTEGRAL (kg)', 'MACA (kg)', 'CAJAMARQUINA (kg)', 'CEREALES (kg)']:
        cant = escape_sql(row[receta])
        if cant != "NULL" and float(cant.replace("'", "")) > 0:
            receta_nombre = escape_sql(receta.replace(" (kg)", ""))
            out_sql.write(f"    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = {insumo} LIMIT 1;\n")
            out_sql.write(f"    IF FOUND THEN\n")
            out_sql.write(f"        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ({receta_nombre}, mp_id, {cant});\n")
            out_sql.write(f"    END IF;\n")
out_sql.write("END $$;\n")

out_sql.close()
print("Migration script generated successfully at supabase/migrations/20260910200000_seed_and_fixes.sql")
