-- Additive support for offline clients; preserves all existing records and access rules.
alter table public.personal add column if not exists deleted_at timestamptz;
alter table public.registro_asistencia add column if not exists deleted_at timestamptz;
alter table public.jornadas_produccion add column if not exists deleted_at timestamptz;
alter table public.lotes_produccion add column if not exists deleted_at timestamptz;
alter table public.bobinas_produccion add column if not exists deleted_at timestamptz;
alter table public.bobinas_produccion add column if not exists tuco_envoltorio numeric(10,2);
alter table public.bobinas_produccion add column if not exists sobra_bobina numeric(10,2);
alter table public.jornadas_produccion add column if not exists pop_quinua_dosimetria numeric(10,2);
create or replace function public.md_apply_changes(p_changes jsonb)
returns void language plpgsql security invoker set search_path = '' as $$
declare
  c jsonb; tbl text; pk text; prev jsonb; nxt jsonb; cur jsonb;
  cols text; vals text; assigns text; rid uuid; normalized jsonb;
begin
  if jsonb_typeof(p_changes) <> 'array' or jsonb_array_length(p_changes) > 1000 then
    raise exception 'Invalid change batch';
  end if;
  perform pg_advisory_xact_lock(20260911, 1);
  for c in select value from jsonb_array_elements(p_changes) loop
    tbl := c->>'table';
    pk := case tbl when 'personal' then 'id_trabajador'
      when 'registro_asistencia' then 'id_registro'
      when 'jornadas_produccion' then 'id_jornada'
      when 'lotes_produccion' then 'id_lote'
      when 'bobinas_produccion' then 'id_bobina' else null end;
    if pk is null then raise exception 'Table is not writable'; end if;
    prev := nullif(c->'before','null'::jsonb) - 'created_at';
    nxt := (c->'after') - 'created_at';
    rid := (nxt->>pk)::uuid;
    if rid is null or jsonb_typeof(nxt) <> 'object' then raise exception 'Invalid record'; end if;
    if exists(select 1 from jsonb_object_keys(nxt) k where not exists(
      select 1 from information_schema.columns a where a.table_schema='public' and a.table_name=tbl and a.column_name=k)) then
      raise exception 'Unknown column';
    end if;
    execute format('select to_jsonb(jsonb_populate_record(null::public.%I,$1))',tbl) into normalized using nxt;
    select jsonb_object_agg(k,normalized->k) into nxt from jsonb_object_keys(nxt) k;
    if prev is not null then
      execute format('select to_jsonb(jsonb_populate_record(null::public.%I,$1))',tbl) into normalized using prev;
      select jsonb_object_agg(k,normalized->k) into prev from jsonb_object_keys(prev) k;
    end if;
    execute format('select to_jsonb(t) - ''created_at'' from public.%I t where %I=$1 for update',tbl,pk)
      into cur using rid;
    -- Same UUID and same submitted values: safe retry after a lost response.
    if cur is not null and cur @> nxt then continue; end if;
    if prev is null and cur is not null then raise exception 'MD_CONFLICT:%:%',tbl,rid; end if;
    if prev is not null and (cur is null or not(cur @> prev)) then
      raise exception 'MD_CONFLICT:%:%',tbl,rid;
    end if;
    select string_agg(format('%I',k),','),string_agg(format('r.%I',k),','),
      string_agg(format('%I=r.%I',k,k),',')
      into cols,vals,assigns from jsonb_object_keys(nxt) k;
    if cur is null then
      execute format('insert into public.%I (%s) select %s from jsonb_populate_record(null::public.%I,$1) r',tbl,cols,vals,tbl) using nxt;
    else
      execute format('update public.%I t set %s from jsonb_populate_record(null::public.%I,$1) r where t.%I=$2',tbl,assigns,tbl,pk) using nxt,rid;
    end if;
  end loop;
end $$;
revoke all on function public.md_apply_changes(jsonb) from public;
grant execute on function public.md_apply_changes(jsonb) to anon, authenticated;

alter table public.lotes_produccion add column if not exists cant_batch numeric(10,2) check (cant_batch >= 0);
