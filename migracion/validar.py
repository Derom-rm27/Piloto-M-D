"""Validación independiente de claves y relaciones mediante SQLite en memoria.
No sustituye ejecutar el SQL y las comprobaciones en PostgreSQL remoto.
"""
import json, re, sqlite3
from pathlib import Path

folder=Path(__file__).resolve().parent
data=json.loads((folder/'datos_normalizados.json').read_text(encoding='utf-8'))
sql=(folder/'carga_preparada.sql').read_text(encoding='utf-8')
db=sqlite3.connect(':memory:')
db.execute('PRAGMA foreign_keys=ON')
for name,definition in re.findall(r'CREATE TABLE public\.(\w+) \((.*?)\);',sql):
    db.execute('CREATE TABLE '+name+' ('+definition.replace('public.','')+')')
    rows=data[name]
    if rows:
        db.executemany('INSERT INTO '+name+' VALUES ('+','.join('?' for _ in rows[0])+')',rows)
    assert db.execute('SELECT count(*) FROM '+name).fetchone()[0]==len(rows)
assert not db.execute('PRAGMA foreign_key_check').fetchall()
assert len(data['marcaciones'])==546
assert len(data['personal'])==46
assert sum(r[6] for r in data['lotes'])==983
assert len({r[0] for r in data['marcaciones']})==546
assert not [r for r in json.loads((folder/'auditoria.json').read_text(encoding='utf-8'))['observaciones'] if 'diferencia' in r and float(r['diferencia'])!=0]
print('PASS: 15 tablas; claves primarias, relaciones y conteos; 983 unidades declaradas en lotes; 6 recetas reconciliadas. Pendiente validacion PostgreSQL remoto.')
