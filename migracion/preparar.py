"""Extrae el Excel sin modificarlo y prepara SQL transaccional para Supabase."""
from pathlib import Path
from datetime import datetime, date, time
from decimal import Decimal
import json, hashlib, unicodedata, warnings
import openpyxl

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'migracion'
SOURCE = ROOT / 'Procesos M&D Piloto.xlsx'
warnings.filterwarnings('ignore', category=UserWarning, module='openpyxl')
w = openpyxl.load_workbook(SOURCE, data_only=True)
tables, definitions = {}, {}
issues = []

def clean(v):
    if isinstance(v, str): return v.strip() or None
    return v

def rows(sheet):
    return [(i, [clean(v) for v in r]) for i,r in enumerate(w[sheet].values,1)
            if i > 1 and any(v is not None for v in r)]

def ident(v):
    return str(int(v)) if isinstance(v,(int,float)) else clean(v)

def norm(v):
    return ''.join(c for c in unicodedata.normalize('NFD',v.casefold()) if not unicodedata.combining(c))

def add(name, definition, data):
    definitions[name] = definition
    tables[name] = data

def serial(v):
    if isinstance(v,(datetime,date,time)): return v.isoformat()
    if isinstance(v,Decimal): return str(v)
    raise TypeError(type(v).__name__)

add('personal', 'id text primary key, nombre text, apellido_paterno text, apellido_materno text, dni text, telefono text, precio_h numeric, fecha_registro timestamp, responsable text, correo text, cargo text',
    [[ident(r[0]),*r[1:5],ident(r[5]),*r[6:11]] for _,r in rows('Personal')])
add('lineas', 'nombre text primary key', [['Galletas'],['Barras']])
add('productos', 'id text primary key, categoria text, nombre text not null, unidad_medida text, linea text references public.lineas(nombre)',
    [[ident(r[0]),*r[1:5]] for _,r in rows('Productos_envasados')])

ingredients=[]
for n,r in rows('Productos_MP'):
    if not r[2]:
        issues.append({'hoja':'Productos_MP','fila':n,'motivo':'ID sin nombre ni atributos; conservado como registro incompleto','id':ident(r[0])})
    ingredients.append([ident(r[0]),r[1],r[2]])
add('insumos','id text primary key, categoria text, nombre text',ingredients)
presentations = [[ident(r[0]),r[3],r[4],r[5]] for _,r in rows('Productos_MP') if any(v is not None for v in r[3:6])]
add('presentaciones_insumo','insumo_id text primary key references public.insumos(id), unidad text, kg numeric, unidades numeric',presentations)

jcols = [(0,'id text primary key'),(1,'fecha date'),(2,'encargado_id text references public.personal(id)'),(3,'turno text'),(4,'linea text references public.lineas(nombre)')]
for i in range(5,19): jcols.append((i, str(w['Jornadas'].cell(1,i+1).value).lower()+' numeric'))
jcols += [(31,'sobra_bobina numeric'),(32,'hora_inicio time'),(33,'observaciones text'),(34,'registrado_por text'),(35,'registrado_en timestamp')]
add('jornadas',', '.join(d for _,d in jcols),[[r[i] for i,_ in jcols] for _,r in rows('Jornadas')])
add('bobinas','jornada_id text references public.jornadas(id), posicion smallint check(posicion > 0), peso_bruto numeric, peso_reportado numeric, primary key(jornada_id,posicion)',
    [[r[0],p+1,r[19+p*2],r[20+p*2]] for _,r in rows('Jornadas') for p in range(6) if r[19+p*2] is not None or r[20+p*2] is not None])
add('lotes','id text primary key, jornada_id text references public.jornadas(id), producto_id text references public.productos(id), codigo text, vencimiento date, presentacion text, cantidad numeric, registrado_en timestamp, registrado_por text, observaciones text',
    [[r[0],r[1],ident(r[2]),ident(r[3]),r[4],*r[6:11]] for _,r in rows('Lotes')])
for n,r in rows('Lotes'):
    prod = next(x for x in tables['productos'] if x[0]==ident(r[2]))
    assert prod[4] == r[5], ('Linea lote diferente de producto',n)

add('marcaciones','id text primary key, persona_id text not null references public.personal(id), fecha date not null, turno text, tipo text check(tipo in (\'ENTRADA\',\'SALIDA\')), hora time, registrado_por text, registrado_en timestamp, linea text references public.lineas(nombre)',
    [[r[0],r[1],r[2],r[3],r[4],r[5],r[6],r[7],r[9]] for _,r in rows('Registro')])
assert all(r[8] is None for _,r in rows('Registro')), 'FechaTurno contiene valores que deben preservarse'
add('capturas_masivas','id text primary key, fecha date, turno text, linea text references public.lineas(nombre), tipo text, hora time',
    [r[:6] for _,r in rows('asistencia_masiva')])
add('capturas_masivas_personal','captura_id text references public.capturas_masivas(id), posicion integer, persona_id text references public.personal(id), primary key(captura_id,posicion)',
    [[r[0],p,person.strip()] for _,r in rows('asistencia_masiva') for p,person in enumerate(r[6].split(','),1)])
add('consumos','id text primary key, jornada_id text references public.jornadas(id), insumo_id text references public.insumos(id), cantidad numeric, unidad_medida text',
    [[ident(r[0]),r[1],ident(r[2]),r[3],r[4]] for _,r in rows('material')])

balance=list(w['Balance_Galletas'].values)
recetas=[]; detalle=[]; mapa=[]
lookup={norm(r[2]):r[0] for r in ingredients if r[2]}
for n,r in enumerate(balance[1:18],2):
    key=norm(r[0]); iid=lookup.get(key)
    if iid is None:
        iid='receta-'+str(n)
        ingredients.append([iid,'Ingrediente de receta',r[0]])
        issues.append({'hoja':'Balance_Galletas','fila':n,'motivo':'Sin coincidencia exacta normalizada en catalogo; no se fusiona por parecido','nombre':r[0]})
    mapa.append([iid,r[0],r[1],r[8]])
    if iid in {x[0] for x in presentations}:
        p=next(x for x in presentations if x[0]==iid)
        if p[2] is not None and p[2]!=r[8]: issues.append({'insumo':r[0],'motivo':'Presentaciones distintas en catalogo y receta','kg_catalogo':p[2],'kg_receta':r[8]})
    for c in range(2,8):
        if r[c] is not None and r[c]!=0: detalle.append([str(c-1),iid,r[c]])
for c in range(2,8):
    rid=str(c-1)
    # Se preservan los supuestos; los totales de referencia se reconcilian en el informe.
    recetas.append([rid,balance[0][c].replace(' (kg)',''),balance[20][c],balance[22][c],250])
    total=sum(Decimal(str(r[c])) for r in balance[1:18])
    issues.append({'receta':recetas[-1][1],'total_ingredientes':str(total),'total_excel':balance[18][c],
                   'diferencia':str(total-Decimal(str(balance[18][c]))),'merma_kg_excel':balance[19][c],
                   'rendimiento_kg_excel':balance[21][c],'cajas_excel':balance[23][c]})
add('recetas','id text primary key, nombre text not null unique, merma_fraccion numeric, peso_paquete_g numeric, paquetes_caja integer',recetas)
add('insumos_receta','insumo_id text primary key references public.insumos(id), nombre_en_receta text, unidad_base text, empaque_comercial numeric',mapa)
add('receta_ingredientes','receta_id text references public.recetas(id), insumo_id text references public.insumos(id), cantidad numeric not null check(cantidad > 0), primary key(receta_id,insumo_id)',detalle)

def lit(v):
    if v is None: return 'NULL'
    if isinstance(v,(int,float,Decimal)): return str(v)
    if isinstance(v,(datetime,date,time)): v=v.isoformat()
    return "'"+str(v).replace("'","''")+"'"

sql=['-- Proyecto destino: mkecqennrzncqrrsmqwt', '-- Revisar esquema remoto antes de ejecutar. Falla si una tabla destino ya existe; no reemplaza datos.',
     'BEGIN;']
for name, definition in definitions.items():
    sql.append('CREATE TABLE public.'+name+' ('+definition+');')
    data=tables[name]
    for start in range(0,len(data),150):
        sql.append('INSERT INTO public.'+name+' VALUES\n'+',\n'.join('('+','.join(lit(v) for v in r)+')' for r in data[start:start+150])+';')
sql += [
    'CREATE INDEX ON public.jornadas(encargado_id);', 'CREATE INDEX ON public.jornadas(linea,fecha);',
    'CREATE INDEX ON public.productos(linea);', 'CREATE INDEX ON public.lotes(jornada_id);', 'CREATE INDEX ON public.lotes(producto_id);',
    'CREATE INDEX ON public.marcaciones(persona_id,fecha,hora);', 'CREATE INDEX ON public.marcaciones(linea,fecha);',
    'CREATE INDEX ON public.capturas_masivas(linea);', 'CREATE INDEX ON public.capturas_masivas_personal(persona_id);',
    'CREATE INDEX ON public.consumos(jornada_id);', 'CREATE INDEX ON public.consumos(insumo_id);', 'CREATE INDEX ON public.receta_ingredientes(insumo_id);',
    '''CREATE VIEW public.resumen_recetas WITH (security_invoker=true) AS
SELECT r.id,r.nombre,sum(d.cantidad) AS kg_batch,
sum(d.cantidad)*r.merma_fraccion AS merma_kg,
sum(d.cantidad)*(1-r.merma_fraccion) AS rendimiento_kg,
sum(d.cantidad)*(1-r.merma_fraccion)*1000/nullif(r.peso_paquete_g*r.paquetes_caja,0) AS cajas_batch
FROM public.recetas r JOIN public.receta_ingredientes d ON d.receta_id=r.id GROUP BY r.id;''',
    '''CREATE VIEW public.produccion_por_jornada WITH (security_invoker=true) AS
SELECT j.id,j.fecha,j.turno,j.linea,count(l.id) AS lotes,sum(l.cantidad) AS cantidad_envasada
FROM public.jornadas j LEFT JOIN public.lotes l ON l.jornada_id=j.id GROUP BY j.id;''',

    '-- RLS desactivado por solicitud. Permisos limitados solo en los objetos creados.',
]
for name in [*tables, 'resumen_recetas', 'produccion_por_jornada']:
    sql.append('REVOKE ALL ON public.'+name+' FROM PUBLIC, anon, authenticated;')
for name in tables:
    sql.append('ALTER TABLE public.'+name+' DISABLE ROW LEVEL SECURITY;')
for name,data in tables.items():
    sql.append("DO $$ BEGIN IF (SELECT count(*) FROM public."+name+") <> "+str(len(data))+" THEN RAISE EXCEPTION 'Conteo incorrecto: "+name+"'; END IF; END $$;")
sql.append('COMMIT;')
(OUT/'carga_preparada.sql').write_text('\n\n'.join(sql)+'\n',encoding='utf-8')
(OUT/'datos_normalizados.json').write_text(json.dumps(tables,ensure_ascii=False,default=serial,indent=2),encoding='utf-8')
audit={'archivo':SOURCE.name,'sha256':hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
       'estado':'PREPARADO_LOCALMENTE_NO_APLICADO','conteos':{n:len(r) for n,r in tables.items()},'observaciones':issues}
(OUT/'auditoria.json').write_text(json.dumps(audit,ensure_ascii=False,default=serial,indent=2),encoding='utf-8')
print(json.dumps(audit,ensure_ascii=True,default=serial,indent=2))
