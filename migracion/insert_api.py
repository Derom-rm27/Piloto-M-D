import pandas as pd
import uuid
import datetime
import requests
import json
import math

URL = "https://mkecqennrzncqrrsmqwt.supabase.co"
KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rZWNxZW5ucnpuY3FycnNtcXd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkwNTI3NjksImV4cCI6MjEwNDYyODc2OX0.e8fswjHz-hsKFXQYQSPIjBUbtQkc84AOmDDpvSbawt4"

HEADERS = {
    "apikey": KEY,
    "Authorization": f"Bearer {KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=minimal"
}

def generate_uuid(name):
    if pd.isna(name) or str(name).strip().lower() in ('nan', 'nat', 'none', ''):
        return None
    return str(uuid.uuid5(uuid.NAMESPACE_OID, str(name).strip()))

def clean_val(val):
    if pd.isna(val) or str(val).strip().lower() in ('nan', 'nat', 'none', ''):
        return None
    if isinstance(val, (datetime.datetime, datetime.date, pd.Timestamp)):
        return val.strftime('%Y-%m-%d %H:%M:%S')
    return val

def clean_dict(d):
    return {k: clean_val(v) for k, v in d.items()}

def insert_batch(table, data):
    if not data: return
    # upsert
    headers = HEADERS.copy()
    headers["Prefer"] = "resolution=merge-duplicates,return=minimal"
    resp = requests.post(f"{URL}/rest/v1/{table}", headers=headers, json=data)
    if resp.status_code not in (200, 201, 204):
        print(f"Error inserting into {table}: {resp.text}")
    else:
        print(f"Inserted {len(data)} into {table}")

excel_path = r"d:\PROCESOS MD\Procesos M&D Piloto.xlsx"
xls = pd.ExcelFile(excel_path)

# 1. PERSONAL
df_personal = pd.read_excel(xls, sheet_name="Personal")
batch = []
for _, row in df_personal.iterrows():
    id_trab = generate_uuid(row['id_trabajador'])
    if not id_trab: continue
    
    dni = clean_val(row['DNI'])
    if dni and str(dni).endswith(".0"): dni = str(dni)[:-2]
    
    batch.append(clean_dict({
        "id_trabajador": id_trab,
        "nombre": row['nombre'],
        "apellido_paterno": row['apellido_paterno'],
        "apellido_materno": row['apellido_materno'],
        "dni": dni,
        "telefono": str(row['Telefono']) if pd.notna(row['Telefono']) else None,
        "cargo": row['Cargo'],
        "precio_h": float(row['precio_h']) if pd.notna(row['precio_h']) else None,
        "created_at": row['Fecha_registro']
    }))
insert_batch("personal", batch)

# 2. PRODUCTOS_MP
df_mp = pd.read_excel(xls, sheet_name="Productos_MP")
batch = []
mp_id_col = [c for c in df_mp.columns if 'Id_producto' in c][0]
for _, row in df_mp.iterrows():
    id_prod = generate_uuid(row[mp_id_col])
    if not id_prod: continue
    
    um = clean_val(row['Unidad_medida'])
    cat = clean_val(row['Categoria'])
    
    batch.append(clean_dict({
        "id_producto": id_prod,
        "nombre_producto": clean_val(row['Nombre_producto']) or "Desconocido",
        "unidad_medida": um if um else "No definido",
        "categoria": cat if cat else "No definido"
    }))
insert_batch("productos_mp", batch)

# 3. PRODUCTOS_ENVASADOS
df_env = pd.read_excel(xls, sheet_name="Productos_envasados")
batch = []
env_id_col = [c for c in df_env.columns if 'Id_producto' in c][0]
for _, row in df_env.iterrows():
    id_prod = generate_uuid(row[env_id_col])
    if not id_prod: continue
    batch.append(clean_dict({
        "id_producto": id_prod,
        "nombre_producto": row['Nombre_producto'],
        "tipo": row['Tipo'],
        "unidad_medida": row['Unidad_medida']
    }))
insert_batch("productos_envasados", batch)

# 4. REGISTRO ASISTENCIA
df_reg = pd.read_excel(xls, sheet_name="Registro")
batch = []
for _, row in df_reg.iterrows():
    id_reg = generate_uuid(row['id_registro'])
    if not id_reg: continue
    id_trab = generate_uuid(row['trabajador'])
    fh = row['FechaHora']
    if pd.isna(fh): continue
    batch.append(clean_dict({
        "id_registro": id_reg,
        "id_trabajador": id_trab,
        "fecha_hora": fh,
        "tipo": row['tipo'],
        "turno": row['Turno'],
        "linea": row['Linea']
    }))
# Send in chunks of 200
for i in range(0, len(batch), 200):
    insert_batch("registro_asistencia", batch[i:i+200])

# 5. JORNADAS PRODUCCION & BOBINAS
df_jor = pd.read_excel(xls, sheet_name="Jornadas")
jor_batch = []
bob_batch = []
for _, row in df_jor.iterrows():
    id_jor = generate_uuid(row['id_jornada'])
    if not id_jor: continue
    id_sup = generate_uuid(row['cargo'])
    
    def get_num(col):
        v = row.get(col, None)
        if pd.isna(v): return 0
        return float(v)

    jor_batch.append(clean_dict({
        "id_jornada": id_jor,
        "fecha": row['fecha'],
        "turno": row['turno'],
        "tipo": row['tipo'],
        "id_supervisor": id_sup,
        "merma_piso_crudo": get_num('merma_piso_crudo'),
        "merma_maquina": get_num('merma_maquina'),
        "quemados": get_num('quemados'),
        "caja": get_num('caja'),
        "merma_piso_cocido": get_num('merma_piso_cocido'),
        "cinta_embalaje": get_num('cinta_embalaje'),
        "tampon": get_num('tampon'),
        "merma_bobinas": get_num('merma_bobinas'),
        "sobra_bobina": get_num('Sobra_bobina'),
        "cant_batch": get_num('cant_batch'),
        "cant_extruido_tolva": get_num('cant_extruido_tolva'),
        "pop_kiwicha": get_num('pop_kiwicha'),
        "pop_quinua": get_num('pop_quinua'),
        "merma_piso": get_num('merma_piso'),
        "observaciones": str(row.get('observaciones', '')) if pd.notna(row.get('observaciones')) else None,
        "created_at": row.get('datetime')
    }))
    
    for i in range(1, 7):
        pb_col = f'pb_bobina_{i}'
        b_col = f'bobina_{i}'
        if pb_col in row and b_col in row:
            if pd.notna(row[pb_col]) and pd.notna(row[b_col]):
                bob_batch.append({
                    "id_bobina": generate_uuid(f"{row['id_jornada']}_bobina_{i}"),
                    "id_jornada": id_jor,
                    "numero_bobina": i,
                    "peso_bruto": float(row[pb_col]),
                    "peso_neto": float(row[b_col])
                })
insert_batch("jornadas_produccion", jor_batch)
insert_batch("bobinas_produccion", bob_batch)

# 6. LOTES
df_lotes = pd.read_excel(xls, sheet_name="Lotes")
batch = []
for _, row in df_lotes.iterrows():
    id_lote = generate_uuid(row['id_lote'])
    if not id_lote: continue
    batch.append(clean_dict({
        "id_lote": id_lote,
        "id_jornada": generate_uuid(row['jornada']),
        "id_producto": generate_uuid(row['producto']),
        "numero_lote": str(row['lote']),
        "f_vencimiento": row['f_vencimiento'],
        "cantidad": int(row['cantidad']) if pd.notna(row['cantidad']) else 0,
        "created_at": row['datetime']
    }))
insert_batch("lotes_produccion", batch)

# 7. BALANCE GALLETAS (RECETAS)
df_bal = pd.read_excel(xls, sheet_name="Balance_Galletas")
# Fetch MPs to get their UUIDs
mp_resp = requests.get(f"{URL}/rest/v1/productos_mp", headers={"apikey": KEY, "Authorization": f"Bearer {KEY}"})
mp_map = {m['nombre_producto']: m['id_producto'] for m in mp_resp.json()}

batch = []
for _, row in df_bal.iterrows():
    insumo = row['INSUMO / MATERIA PRIMA']
    if insumo in mp_map:
        for receta in ['QUINUA (kg)', 'KIWICHA (kg)', 'INTEGRAL (kg)', 'MACA (kg)', 'CAJAMARQUINA (kg)', 'CEREALES (kg)']:
            cant = row.get(receta)
            if pd.notna(cant) and float(cant) > 0:
                receta_nombre = receta.replace(" (kg)", "")
                batch.append({
                    "nombre_receta": receta_nombre,
                    "id_materia_prima": mp_map[insumo],
                    "cantidad": float(cant)
                })
insert_batch("recetas", batch)

print("Data upload complete via REST API.")
