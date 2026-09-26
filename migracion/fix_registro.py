import pandas as pd
import uuid
import datetime
import requests

URL = "https://mkecqennrzncqrrsmqwt.supabase.co"
KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rZWNxZW5ucnpuY3FycnNtcXd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkwNTI3NjksImV4cCI6MjEwNDYyODc2OX0.e8fswjHz-hsKFXQYQSPIjBUbtQkc84AOmDDpvSbawt4"

HEADERS = {
    "apikey": KEY,
    "Authorization": f"Bearer {KEY}",
    "Content-Type": "application/json",
    "Prefer": "resolution=merge-duplicates,return=minimal"
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
    resp = requests.post(f"{URL}/rest/v1/{table}", headers=HEADERS, json=data)
    if resp.status_code not in (200, 201, 204):
        print(f"Error inserting into {table}: {resp.text}")
    else:
        print(f"Updated {len(data)} into {table}")

excel_path = r"d:\PROCESOS MD\Procesos M&D Piloto.xlsx"
xls = pd.ExcelFile(excel_path)

df_reg = pd.read_excel(xls, sheet_name="Registro")
batch = []
for _, row in df_reg.iterrows():
    id_reg = generate_uuid(row['id_registro'])
    if not id_reg: continue
    id_trab = generate_uuid(row['trabajador'])
    
    fh_audit = row['FechaHora']
    fecha = row['Fecha']
    hora = row['Hora']
    
    fh_real = fh_audit
    if pd.notna(fecha) and pd.notna(hora):
        try:
            date_str = fecha.strftime('%Y-%m-%d') if hasattr(fecha, 'strftime') else str(fecha).split(' ')[0]
            time_str = hora.strftime('%H:%M:%S') if hasattr(hora, 'strftime') else str(hora)
            fh_real = pd.to_datetime(f"{date_str} {time_str}")
        except:
            pass

    batch.append(clean_dict({
        "id_registro": id_reg,
        "id_trabajador": id_trab,
        "fecha_hora": fh_real,
        "tipo": row['tipo'],
        "turno": row['Turno'],
        "linea": row['Linea'],
        "created_at": fh_audit
    }))

for i in range(0, len(batch), 200):
    insert_batch("registro_asistencia", batch[i:i+200])

print("Registro asistencia updated!")
