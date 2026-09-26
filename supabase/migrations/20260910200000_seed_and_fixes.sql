-- Agregando columnas omitidas
ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS cant_batch DECIMAL(10, 2);
ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS cant_extruido_tolva DECIMAL(10, 2);
ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS pop_kiwicha DECIMAL(10, 2);
ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS pop_quinua DECIMAL(10, 2);
ALTER TABLE public.jornadas_produccion ADD COLUMN IF NOT EXISTS merma_piso DECIMAL(10, 2);

-- Creando tabla de recetas (Balance Galletas)
CREATE TABLE IF NOT EXISTS public.recetas (
    id_receta UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_receta VARCHAR(255) NOT NULL, -- ej: QUINUA (kg)
    id_materia_prima UUID NOT NULL REFERENCES public.productos_mp(id_producto) ON DELETE CASCADE,
    cantidad DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insertando Personal
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('1656d9a3-eaa7-5e09-9f3f-9f27795843f9', 'Delfin Estanis', 'Roque', 'Mullisaca', '150547', 963165439.0, NULL, 6.0, '2026-08-05 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('9f4bde98-48ae-5bf1-a770-619aab95a7af', 'Amelia Evelyn', 'Ticona', 'Pari', '017724', 904850808.0, NULL, NULL, '2026-08-06 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('e5bace15-c502-50bb-8915-1165753414ea', 'Miriam', 'Tito', 'Sanca', NULL, NULL, 'Supervisor', NULL, '2026-08-07 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('09aa90b1-ff4a-5074-be9f-cbca85a70da1', 'Vianet', 'Charca', 'Mamani', NULL, NULL, NULL, NULL, '2026-08-08 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('c773ba76-9251-534c-b44a-98573d73a29b', 'Mary Luz', 'Laura', 'Chirinos', NULL, NULL, NULL, NULL, '2026-08-09 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('afb95ade-b1c8-5abf-a9e1-2bbe3d81b431', 'Mariela', 'Mendoza', 'Puma', NULL, NULL, NULL, NULL, '2026-08-10 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('b63408f0-ae4f-5662-b329-cfa56bb6e013', 'Miguel', 'Zapana', 'Puma', NULL, NULL, NULL, NULL, '2026-08-12 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('ddd37ed1-c590-5977-9a57-5187bbcef2cc', 'Marisol', 'Huacasi', 'Mamani', NULL, NULL, NULL, NULL, '2026-08-13 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('78442442-8aef-53a6-9692-a9d07e4ac910', 'Marco', 'Mamani', 'Miranda', NULL, NULL, NULL, NULL, '2026-08-14 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('aae84532-608d-5e10-9812-34f54b4ac01b', 'Evelyn kelly', 'Marcedo', 'Equise', NULL, NULL, NULL, NULL, '2026-08-15 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('8f190d3f-9893-5e21-823e-a11c62d81ada', 'Yolanda CASAZOLA', 'Cazasola', 'Mamani', NULL, NULL, NULL, NULL, '2026-08-16 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('836cf82d-6731-5019-9d32-f698dae51602', 'Edu J', 'Quispe', 'Puma', '550213', NULL, NULL, NULL, '2026-08-17 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('3b786555-ca49-51e3-8afa-877c3802cf01', 'Miriam', 'Quispe', 'Coaquira', NULL, NULL, NULL, NULL, '2026-08-18 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('0c7829a8-c706-57e8-85ea-bea33957180d', 'Jhon Alex', 'Quispe', 'Puma', '550213', NULL, 'Ingeniero', NULL, '2026-08-19 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('c19b5690-3158-5eb9-b0ab-97ceda90e8b4', 'Diana', 'Panca', 'Belizario', NULL, NULL, NULL, NULL, '2026-08-20 15:28:20') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('78cbfe55-03ff-5381-9678-701641e48a31', 'Wilmer Henry', 'Ccallohuanca', 'Condori', NULL, NULL, NULL, NULL, '2026-08-05 18:36:02') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('e0a333ee-eda3-5852-b68a-14aa6930e264', 'Belen', 'Sucasaca', 'Quispe', NULL, NULL, NULL, NULL, '2026-08-22 01:29:57') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('46bf853f-f2d3-5139-b666-e14c3451dc9e', 'Alejandra', 'Chambi', 'Sucasaca', NULL, NULL, NULL, NULL, '2026-08-22 01:31:02') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('22d2e2a5-6983-5b55-b009-ef8fa45b1a75', 'Yolanda CONDORI', 'Condori', 'Ramos', NULL, NULL, NULL, NULL, '2026-08-22 01:31:32') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('b434f5cb-8f9f-572e-80ec-1f441a419607', 'Juan Jose', 'Nuñoa', 'Suyo', NULL, NULL, NULL, NULL, '2026-08-22 01:32:00') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('2ed79abc-1650-571a-853e-cac1db1c116a', 'Silvia E', 'Mamani', 'Zea', NULL, NULL, NULL, NULL, '2026-08-22 01:32:44') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('5c075c99-f126-5fab-a2a6-a93bb26dbf9c', 'Luz Noelia', 'Flores', 'Arias', NULL, NULL, NULL, NULL, '2026-08-22 01:33:21') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('170733e1-bb01-58a9-97c2-1be7b40f8b19', 'yudith calisaya', 'Calisaya', 'Machaca', NULL, NULL, NULL, NULL, '2026-08-22 01:34:05') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('fe4a8ed9-6423-5a53-baea-fe31ae0e87e3', 'Ismael', 'Mamani', 'Mamani', NULL, NULL, NULL, NULL, '2026-08-22 01:35:02') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('1ebc5a0f-e170-52b6-99b6-a3db03a33148', 'Leydi Estefany', 'Caceres', 'Quispe', NULL, NULL, NULL, NULL, '2026-08-22 01:35:31') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('a5e37607-e61c-5381-bea1-702303a4242c', 'Wilson', 'Muchico', 'Jove', NULL, NULL, NULL, NULL, '2026-08-22 01:36:40') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('2596ae9d-bc77-522c-9191-b2e967dc0647', 'Brenda', 'Coaquira', 'Ramos', NULL, NULL, NULL, NULL, '2026-08-22 01:37:30') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('14a27dfc-7310-57c6-bd62-0eb31bed4820', 'Sugely', 'Humpire', 'Humpire', NULL, NULL, NULL, NULL, '2026-08-22 01:38:16') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('37d72b43-c289-5f43-966c-6c5f5a2539fe', 'Genoveva', 'Turpo', 'TY', NULL, NULL, NULL, NULL, '2026-08-22 01:42:25') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('7b0f11a2-13b0-59e4-91a1-d9293c421de2', 'Marily Liz', 'Quispe', 'Mamani', NULL, NULL, NULL, NULL, '2026-08-22 01:43:49') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('8ad2fa15-38bb-5b2e-9b9a-c3f66bd522d5', 'Ubaldo', 'Huaccachi', 'Borda', NULL, NULL, NULL, NULL, '2026-08-22 01:45:10') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('ca3fb2b3-6fb3-5e50-afae-06238a1f44be', 'Aldemar Leonel', 'cha', 'M', NULL, NULL, NULL, NULL, '2026-08-22 01:47:15') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('ea7af948-0e5b-5424-8bec-32886f6a60b5', 'Yoselin Diana', 'Panca', 'Belizario', NULL, NULL, NULL, NULL, '2026-08-22 01:51:42') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('4ef9cb20-d657-5772-8fc7-656cfebd52f7', 'Yudith Mrgoth', NULL, 'M', NULL, NULL, NULL, NULL, '2026-08-22 01:52:07') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('11e27f20-c871-55b2-a3e1-4069b6e188ac', 'Mayomy Roxana', 'Ccalla', 'C', NULL, NULL, NULL, NULL, '2026-08-22 01:55:14') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('e5f494c1-6d4a-553c-9674-1f340a7b36a3', 'Diego', 'Rivera', 'B', NULL, NULL, NULL, NULL, '2026-08-25 16:51:53') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('83c114de-eef7-5d30-b195-74db6709c09d', 'Lily', 'yerba', 'Quispe', NULL, NULL, NULL, NULL, '2026-08-25 16:57:11') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('74eb5e4d-263f-5c1a-8061-6b1f0321b133', 'Milagros', 'calderon', 'Ojera', NULL, NULL, NULL, NULL, '2026-08-29 06:42:27') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('744d5d34-0876-5571-bce2-1521a434e448', 'Diane Esther', 'Mamani', 'Maraza', NULL, NULL, NULL, NULL, '2026-08-29 07:11:09') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('e50ed02b-15e7-5b79-b419-d4b9ff179935', 'shaleira gomez', 'Gomez', 'Sile', NULL, NULL, NULL, NULL, '2026-08-29 07:11:59') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('7d5d2a65-2a27-50a6-89f0-c845d219d935', 'Elizabeth', 'Chambi', 'Flores', NULL, NULL, NULL, NULL, '2026-08-29 07:17:51') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('11c503cd-ea12-5d00-b27b-a0cff822b212', 'Juan Carlos', 'a', 's', NULL, NULL, NULL, NULL, '2026-08-29 09:48:16') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('27a184be-bc1e-575c-b8f3-cfa4d37f038f', 'Niflin  Alan', 'ccari', 'Quispe', NULL, NULL, NULL, NULL, '2026-08-29 10:26:37') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('2c18aee3-5b6c-5458-9b4a-78a40af6102d', 'Saul', 'Sucari', 'Huanca', NULL, NULL, NULL, NULL, '2026-08-29 12:20:55') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('c26bfdf3-dac7-5450-9e5b-a71952e3ed8b', 'Edwin carita', 'Carita', 'Smari', NULL, NULL, NULL, NULL, '2026-08-29 12:23:13') ON CONFLICT DO NOTHING;
INSERT INTO public.personal (id_trabajador, nombre, apellido_paterno, apellido_materno, dni, telefono, cargo, precio_h, created_at) VALUES ('1416bbf1-76c9-5f4b-86e9-71bae01b8f18', 'Emmanel E', 'Quispe', 'Sucari', NULL, NULL, NULL, NULL, '2026-09-05 07:56:20') ON CONFLICT DO NOTHING;

-- Insertando Productos MP
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('00cd6396-62fa-529a-9e7b-bec1b5edd991', 'HARINA DE TRIGO', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('b531c915-baab-53f7-aee2-2891b8f3dceb', 'HARINA DE MACA', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('91e82bbc-f60f-5f6a-a613-1ecb63f1c391', 'HARINA DE QUINUA', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('9f82b843-eca4-58e0-ab34-3f282923cda9', 'HARINA DE KIWICHA', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('2f8662ed-1790-5ef6-8b0e-91ba58b4f054', 'SALVAJE DE TRIGO', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('871db77f-65dc-5f2a-878e-ae4ee537b8d5', 'MANI', NULL, 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('95412a46-8d15-5a22-8f7a-1e07264ff98e', 'MANTECA', 'CAJAS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('a7a1e0ce-b3e6-52e0-8655-611aa5a2107d', 'AZUCAR', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('d0c42af2-43d5-5322-9392-464d47f6d03c', 'SALVAJE', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('3437cc8b-8efe-509a-b690-178b7186e0c5', 'HOJUELA DE QUINUA', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('9d4e2a1d-6112-504d-96c2-5ebc6593059f', 'BICARBONATO DE SODIO', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('1894c773-ad54-51bb-bbf0-db0192fec5db', 'BICARBONATO DE CALCIO', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('5447b2e0-795a-5eae-9f7d-5fdea75fec3c', 'BICARBONATO DE AMONIO', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('b9d49217-00d1-5432-87fa-de3623c4954c', 'LECHE EN POLVO', 'SACOS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('4ca3f1ed-5728-50dd-8ab3-4254065f435f', 'LECITINA DE SOYA', 'BARRIL', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('5f024ee9-ecea-523a-823c-b68c50b01691', 'CINTA', 'CAJAS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('219bb153-0671-571c-ac70-a4dc0057fd9d', 'CAJAS VERDES', 'CAJAS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('9712f6d8-147c-5c6c-a315-f066ea4dbc7b', 'CAJAS AZULES', 'CAJAS', 'Materia Prima') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_mp (id_producto, nombre_producto, unidad_medida, categoria) VALUES ('60068dd0-cbef-5492-b3ec-d7f2e43cb1ae', NULL, NULL, NULL) ON CONFLICT DO NOTHING;

-- Insertando Productos Envasados
INSERT INTO public.productos_envasados (id_producto, nombre_producto, tipo, unidad_medida) VALUES ('996ad860-2a9a-504f-8861-aeafd0b2ae29', 'Galleta con Quinua', 'Galletas', 'Cajas') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_envasados (id_producto, nombre_producto, tipo, unidad_medida) VALUES ('59e06cf8-f390-5093-af2e-3685be593a25', 'Galleta con Kiwicha', 'Galletas', 'Cajas') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_envasados (id_producto, nombre_producto, tipo, unidad_medida) VALUES ('391ada15-580c-5baa-b16f-eeb35d9b1122', 'Galleta con Maca', 'Galletas', 'Cajas') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_envasados (id_producto, nombre_producto, tipo, unidad_medida) VALUES ('22fe83ae-a20f-54fc-b436-cec85c94c5e8', 'Gallleta Integral', 'Galletas', 'Cajas') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_envasados (id_producto, nombre_producto, tipo, unidad_medida) VALUES ('b7d55bf4-7057-5113-85c8-141871bf7635', 'Rosquitas tipo Cajamarquinas', 'Galletas', 'Cajas') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_envasados (id_producto, nombre_producto, tipo, unidad_medida) VALUES ('1883fdfb-249b-58f5-b445-87dff6eabc06', 'Barra a base de extruidos con Quinua expandida', 'Barras', 'Cajas') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_envasados (id_producto, nombre_producto, tipo, unidad_medida) VALUES ('d6ed313e-533a-55a6-aa06-4c00bc132812', 'Barra a base de extruidos con kiwicha expandida', 'Barras', 'Cajas') ON CONFLICT DO NOTHING;
INSERT INTO public.productos_envasados (id_producto, nombre_producto, tipo, unidad_medida) VALUES ('9090025d-5d06-58f1-b79a-3690407024fc', 'Barra a base de extruidos (Leguminosa cereales y Grano andino)', 'Barras', 'Cajas') ON CONFLICT DO NOTHING;

-- Insertando Registro Asistencia
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a0e7dc64-72de-5e0d-8fcc-eeb6a3fc8c1a', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4737d980-2b6e-5c21-a2ed-1fd14d4f22c1', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5e2aee77-f4d2-59ab-9a13-93cc919e02ba', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('35a107ee-407d-54b0-b03f-06e150d58a79', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('31eca64d-84a6-5a7e-813f-13b398a92cef', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ecdff6ef-1e20-5f4f-8ca6-f04b7ce73aec', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c866e9d6-0de2-5221-a122-3d9d595f017d', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c1cd6364-d539-598f-a83c-a02c4e6202e5', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a8606bd6-7d2c-59e2-aa91-825deba9fb0d', '74eb5e4d-263f-5c1a-8061-6b1f0321b133', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e84e6771-0ad1-5a7d-8414-4c93873ffa1b', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8d5e9f63-00f8-5793-ad6c-1c8477b187cf', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 06:45:51', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('08c8f7b4-b493-57c4-845e-5c5f45e10ba4', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('aa63282c-6e12-5006-8379-3c757264d9b2', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c8175f49-2ee3-5639-81d6-ba1f1c881309', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('82a7a05a-5be2-5197-b3fe-271b4cacc27a', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4c89a9fb-5083-53e6-bbd5-e602af9e0324', '74eb5e4d-263f-5c1a-8061-6b1f0321b133', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c4ab0ab6-d8d2-5137-837b-c525d62efb81', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('00b9ad77-dcfd-591b-adde-bb45cd22f96c', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('689e0f7c-e010-5c64-af50-2feba349e6b4', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8c6be3c4-56ba-5a30-b867-eaa4630d1315', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1eefb381-beeb-54b1-8c83-e8b8798b9a4a', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('83842720-bc70-583e-9527-d921808cb7bf', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-08-29 06:47:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('41bda5dc-af3e-56b3-ae3d-ab865912f593', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('378f373f-a8c2-551e-b681-dbc8bc0267f1', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b0b493b2-cf9a-5eb7-b721-48f2a75f7792', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('85b6ca34-c616-50f7-af80-f08c99df89ae', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9a59b1a0-f845-5f1b-b5dd-0a00e7744e1c', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('50b79258-5f66-533d-a71f-49628d91c7e4', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('23fb9696-b52c-5e28-861a-9c64285f8e2e', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fcde1986-8350-50e3-a77e-913487e66469', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9a23c827-11ac-5e16-a979-55d0c6f1a253', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('afefa10d-6f08-5b56-b425-b189c63d672e', 'ea7af948-0e5b-5424-8bec-32886f6a60b5', '2026-08-29 07:04:15', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4e357770-5236-5651-817c-a8a0b0caabfe', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5e25248b-023d-597f-8bd5-1a172602d6dd', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('130d93da-b007-5593-8f46-b0f05f6713fd', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1768abdb-ca20-5ebd-93d9-131684256876', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('06245486-6324-57fb-9774-4a7e4cb20042', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('678185a8-0806-53a1-9484-784c8266e8e2', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5e508e95-7936-59fa-b17a-de98244e98f5', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7496cf2a-3f7f-5c68-b2d3-0889c6042316', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a5216ae7-ea80-5ed3-860b-dc44c7dadea1', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d9297cfb-9e5f-57cb-8af3-c96575068cb5', 'ea7af948-0e5b-5424-8bec-32886f6a60b5', '2026-08-29 07:05:33', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('53309b64-71fa-5f5e-a604-b36839eff6e3', '2ed79abc-1650-571a-853e-cac1db1c116a', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2d93426c-5c01-555b-8f1a-340af55a98f6', 'afb95ade-b1c8-5abf-a9e1-2bbe3d81b431', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e661f863-2428-54d3-ab35-99bd610d4e64', '5c075c99-f126-5fab-a2a6-a93bb26dbf9c', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('efc7443b-1fff-5339-8e15-6268cf5b2b23', '744d5d34-0876-5571-bce2-1521a434e448', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7a221bfe-e01c-54cd-9db7-4e6d74af1b13', 'e50ed02b-15e7-5b79-b419-d4b9ff179935', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('149192ac-b0d4-586b-93d9-920f1e57bd14', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6a9a9d0a-b99b-5f5c-8b84-d71de93222dd', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('11678870-b153-53f9-996d-c866f817e525', '170733e1-bb01-58a9-97c2-1be7b40f8b19', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ab9d034e-c5d5-5ac3-9e79-c68345bca572', 'a5e37607-e61c-5381-bea1-702303a4242c', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ad0f647e-7dbb-5c0d-94a5-0669d445c7f0', 'b63408f0-ae4f-5662-b329-cfa56bb6e013', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e8b033f5-a456-5309-9fdc-e8a0fb982777', 'fe4a8ed9-6423-5a53-baea-fe31ae0e87e3', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3e0fd475-826a-5e6c-b54a-318b23a9f4c2', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-08-29 07:17:35', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d38b136e-9e38-5bd6-9dbf-9b7dec56c566', '7d5d2a65-2a27-50a6-89f0-c845d219d935', '2026-08-29 07:18:47', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5eef11b9-c983-57ce-b91b-340dc84ca8a7', '2ed79abc-1650-571a-853e-cac1db1c116a', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('91145df6-3a24-50d9-bbcc-f0b629b8c580', 'afb95ade-b1c8-5abf-a9e1-2bbe3d81b431', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a05cab5a-e14e-5e6d-8636-01460bda2396', '5c075c99-f126-5fab-a2a6-a93bb26dbf9c', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('adc8ca55-8ca1-5e5b-9a4f-7c4dc5d9c63a', '744d5d34-0876-5571-bce2-1521a434e448', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8c8ac4e1-8b32-54a6-b01c-92093afcc85f', 'e50ed02b-15e7-5b79-b419-d4b9ff179935', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('921208f3-8c34-57e1-aa06-c2fb8b9bf01b', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7aa86e5d-2935-5303-a479-dffddc0bd11f', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b62c6c8b-c250-52a7-bb96-620b63f225cb', '7d5d2a65-2a27-50a6-89f0-c845d219d935', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9bec7e1d-c01d-58e9-b213-5ab34d749e5b', '170733e1-bb01-58a9-97c2-1be7b40f8b19', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c74f1510-db6e-5603-a3f4-8fa9b51b8092', 'a5e37607-e61c-5381-bea1-702303a4242c', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('47537a28-576f-52e7-9277-3114e365dbf8', 'b63408f0-ae4f-5662-b329-cfa56bb6e013', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('37fc4b94-ba00-5289-a39c-d16ae06969f0', 'fe4a8ed9-6423-5a53-baea-fe31ae0e87e3', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0e951a08-035d-565c-ad5b-abf2d63c24b7', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-08-29 07:21:40', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a6510073-78bd-5dbf-b40f-4817652d1088', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 07:31:46', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7d86ec9d-660c-5418-b8ff-e4283d021922', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 07:31:46', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('10b592d7-4379-5c9e-b71e-168de1fb85f5', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 07:31:46', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6e8c0d22-8ae7-5404-8bda-21bd7935821e', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 07:31:46', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6bd335bb-a85b-54c9-8397-9e0cffc1c4b2', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 07:31:46', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d43fb260-bb1c-5d09-8dc2-8c7fb108b173', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 07:31:46', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e4f2dc37-f926-5db2-a81a-7ba4aa093ae7', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 07:31:46', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5a2a9f26-089c-54d4-9356-102aec7d2529', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 07:31:46', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1dc7ffda-6330-5489-b527-78fd806dd9f4', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 07:31:46', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e834e727-e419-5707-b7eb-269ad59666ea', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 07:32:25', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9490fa7f-8466-55fb-a908-de3ef459d612', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8f947fc0-edce-5458-b8f9-af5561aa5e4f', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ca940d2a-26fc-5d7d-85fc-5edb5769f6b1', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('280aebd6-d002-51c6-9b2e-69f80a485a91', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('54974425-ab6c-5eb1-b097-0d9b50813665', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7e77ca74-3a9d-551f-8f56-e5cbff4ac226', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('361a34d1-343e-545f-a587-44b49ea7ff81', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ceceb72d-6b16-5396-b5ad-f055e006129f', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('48ce89ed-06b8-5162-9ea8-1b3773d76308', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('abeeab7e-99a2-5273-8067-8fce457fa03c', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 07:34:16', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('58bfdf78-4e99-51bf-a531-c301203390c6', '8ad2fa15-38bb-5b2e-9b9a-c3f66bd522d5', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('154d7169-4dcf-5bcb-b12c-e20303226b99', '14a27dfc-7310-57c6-bd62-0eb31bed4820', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('eab1d6a3-5214-5b4f-ba66-c2daaa850acf', 'b63408f0-ae4f-5662-b329-cfa56bb6e013', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('95096c2e-15f4-5c44-95b6-5537ae73198b', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('298d8dc8-bbf4-54d1-b670-3cc5233326bf', 'afb95ade-b1c8-5abf-a9e1-2bbe3d81b431', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('332a092e-4914-5cd8-9c0a-89ee1be497f5', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1764f73d-294c-5d74-9db7-491afeb473df', '7d5d2a65-2a27-50a6-89f0-c845d219d935', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ea25c394-d39b-59a1-931b-e82b762be49b', 'c773ba76-9251-534c-b44a-98573d73a29b', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('06ec4378-0167-5287-bee7-12d67e4aaa34', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e68f35c5-1945-5521-907d-b9fab0c6c776', '2ed79abc-1650-571a-853e-cac1db1c116a', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('af90ee13-bb7f-5682-99ac-beceaa15b228', 'aae84532-608d-5e10-9812-34f54b4ac01b', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('472e7ce5-042f-5e43-8a0d-ba3f2cb34c55', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5e4d6f84-fbba-5643-9d88-5e756bc5a5a1', '836cf82d-6731-5019-9d32-f698dae51602', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b0f1cd20-6802-55b5-b155-c9f09e9727d9', 'a5e37607-e61c-5381-bea1-702303a4242c', '2026-08-29 09:30:49', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0cc21646-1432-542a-8b28-b672267b7815', '14a27dfc-7310-57c6-bd62-0eb31bed4820', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e4796d2f-a98d-529f-8a0a-54a07b8f939e', '8ad2fa15-38bb-5b2e-9b9a-c3f66bd522d5', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('50c460d2-1225-5166-b10d-2776dda57d30', 'b63408f0-ae4f-5662-b329-cfa56bb6e013', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b689640f-b0d4-5fc2-83e7-c431d51ae213', 'a5e37607-e61c-5381-bea1-702303a4242c', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f29cbc9b-777d-55dd-b0d1-1443cb0047a9', 'afb95ade-b1c8-5abf-a9e1-2bbe3d81b431', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('aa242e23-8216-5d7d-8ecd-3d809babf476', 'aae84532-608d-5e10-9812-34f54b4ac01b', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ba13c965-4a94-5085-b779-e28e00dd0bb7', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('bb4b24a7-e72b-5bea-b4a7-2a62d39142f9', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0bfe0ecf-5748-56a5-9fa6-d64749a85738', 'c773ba76-9251-534c-b44a-98573d73a29b', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d5cd1586-7669-5849-b02b-fd31b3979d19', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('09b51fbe-dc71-59dd-8056-d7827ddde941', '836cf82d-6731-5019-9d32-f698dae51602', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f3da317c-424f-5b76-8df6-030685462dd3', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('dde1c845-3c04-57c6-94dd-aa3e66b17d93', '2ed79abc-1650-571a-853e-cac1db1c116a', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d5eaec5d-27c9-5eba-88c0-48a9f72b9a99', '7d5d2a65-2a27-50a6-89f0-c845d219d935', '2026-08-29 09:34:00', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('10d8561d-6075-54b1-8f0c-b5e8d4ab726a', 'afb95ade-b1c8-5abf-a9e1-2bbe3d81b431', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('eb71cc92-72e8-5992-bc06-c59a281d7860', 'b63408f0-ae4f-5662-b329-cfa56bb6e013', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5ea7b3e4-de3a-50b6-9662-5459f205b122', '2ed79abc-1650-571a-853e-cac1db1c116a', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b547d7a6-d8b6-574a-9d33-989bc258ba06', 'a5e37607-e61c-5381-bea1-702303a4242c', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('33ec004a-34cf-599d-ba4e-d344796fbf9d', '7d5d2a65-2a27-50a6-89f0-c845d219d935', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8ef477f6-cd5c-5521-9037-6de2a9058577', 'c773ba76-9251-534c-b44a-98573d73a29b', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('cb796889-16ff-5553-b951-c06e73a7d061', 'aae84532-608d-5e10-9812-34f54b4ac01b', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1e304fa5-5bbe-59bd-b7a8-aade2c5176a2', '14a27dfc-7310-57c6-bd62-0eb31bed4820', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('bbebf674-25a5-5f86-904b-7d75d12ccd19', '836cf82d-6731-5019-9d32-f698dae51602', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('71c1efa4-efa0-51a7-b8a4-eff7679caed1', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('20d09ec7-feeb-5173-a7bf-38228a175e1d', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a72d3b5b-d9c8-5c06-b5dc-d0f05d621ec9', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a8c822ff-b6bc-5f5e-a242-164cbcbeed7c', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('95fb1f70-d7a5-50c8-a617-4295dc14a1c0', '8ad2fa15-38bb-5b2e-9b9a-c3f66bd522d5', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9fbd6aa0-8018-5603-9e4a-dc606f2cb542', '11c503cd-ea12-5d00-b27b-a0cff822b212', '2026-08-29 09:51:22', 'ENTRADA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('06bea776-8b48-5e1e-9a47-9af9f4701897', 'afb95ade-b1c8-5abf-a9e1-2bbe3d81b431', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4312aa7e-1a58-5b3a-b537-97732ad599f4', 'b63408f0-ae4f-5662-b329-cfa56bb6e013', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('43835706-d345-5b1c-a0ae-d38eb3523342', '2ed79abc-1650-571a-853e-cac1db1c116a', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('051f24c6-dace-5d37-aae1-41ea559c7c41', 'a5e37607-e61c-5381-bea1-702303a4242c', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7aed7708-e30e-53ee-88e9-048b90a13f0d', '7d5d2a65-2a27-50a6-89f0-c845d219d935', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ceb58a77-af4a-5236-9f67-8fab0e80aab8', 'c773ba76-9251-534c-b44a-98573d73a29b', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4b6da4ab-70dd-54f2-94bf-641f7e5a9695', 'aae84532-608d-5e10-9812-34f54b4ac01b', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('50c94b30-d6a4-5048-ba6e-7f7cb4466813', '14a27dfc-7310-57c6-bd62-0eb31bed4820', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5463a16e-e13c-56e4-8765-8f35f34e7f08', '836cf82d-6731-5019-9d32-f698dae51602', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('462bf98d-963a-57fb-bd5a-cff8e6df6dcd', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ac11b932-6842-51d0-b894-d956ddb13fca', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('95bf0376-0823-57c2-94c1-4177f6cbbeba', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2473cc23-c22f-506d-867a-013023b16500', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4fb6e28a-50c8-5515-9e07-0c17be717e67', '8ad2fa15-38bb-5b2e-9b9a-c3f66bd522d5', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9e23f1e6-0462-590c-9400-a6f353370dcd', '11c503cd-ea12-5d00-b27b-a0cff822b212', '2026-08-29 09:54:32', 'SALIDA', 'Dia', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('23c03912-f0f6-5685-9a4e-6fe74f21ce05', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0d49613d-3b91-56bc-8ab5-feea324f8c26', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('31fca677-4c03-5caf-9ddb-dbf275417b20', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('615ebda5-a9b0-580e-8e42-b7c9d434986e', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d7211849-f5f4-5fdb-a5c9-c4aee5f9db17', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('64f54d59-468f-51f6-9f9d-3284ea50f0d5', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('50e52d5d-615c-598c-8276-85c346c252ca', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('45ceb715-540d-5b5b-a3e0-f56e829959d7', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9275b7c6-1ce7-5456-af97-a55da6d1f215', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8eaddc4b-a04e-5335-8ab4-a663ad5faa57', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('97eaf4e0-728b-55ee-81da-9875562b737c', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6b020044-382f-5b02-ba01-f84ec9a33f81', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e674b2c2-661c-5356-b84f-0a4ad2c11c03', 'c19b5690-3158-5eb9-b0ab-97ceda90e8b4', '2026-08-29 10:00:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1b517e7b-3a8b-543e-9c04-53fbacfab95c', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e3da39d6-649d-57c6-bb15-f61ed9df313f', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d5e176c8-5d00-5f42-866a-e87fa51b183d', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4773532c-6d4e-595a-9f60-fd19ca9ed181', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f09ad7e9-6757-5681-af2b-f3eeefa6db94', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('106fba21-f083-59c5-a985-60e89c2d2f9b', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('35827443-b5d3-5ba7-a72c-440282685458', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('faf79ce0-30f1-5fe7-ae15-a3b4067d4d82', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('40f0eba5-8212-5383-8324-6f1309acecd5', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('078730ba-954d-5aa7-9e41-2860dacff5d1', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('858ac34c-1986-5ce6-83f1-255988e83f27', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('aac564f2-c76a-518a-9316-a3cc18d8f566', 'c19b5690-3158-5eb9-b0ab-97ceda90e8b4', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b9973f64-de5f-5046-ad92-8a8474609f3b', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:02:43', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1e054d2c-1e71-51f3-9456-4e81140775f0', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('57c06e81-0d7f-5ec3-ae0c-55969b7047cd', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('54f77153-2358-54b3-9ece-3318396775a2', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d45ea067-5084-51ca-8ebb-e31b025f1ed1', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a63b76d0-fcc9-5524-aea3-1cd1ae2f91da', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3c3fa2b8-8759-520a-8500-3e2e193f7ced', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a2a5c511-28a2-5a97-b26c-5ef90ed6e545', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9506cc46-4a9d-5f3c-af56-e771d80c0f5d', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c4cfa6a5-7d29-51d6-a2ca-9c2030179380', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2b88f541-0ec5-55e7-81ae-8fbf2d7f5ec4', 'c19b5690-3158-5eb9-b0ab-97ceda90e8b4', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4f28e27f-1a24-5977-b966-da261edfbae4', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ecda3717-abf3-5c95-887d-2165031df258', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:08:24', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6048ec69-c027-5adc-90b4-cb755729c5cb', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('24479dd5-9258-5fc0-880c-ed2fbbe961d3', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('36b0d35a-59e6-5a59-ab21-838d1bd34569', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('98b8be72-b9a4-5a83-96ed-e014d62d73a3', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4509e3d1-515d-5c25-9d78-9f47753fccf6', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('89022496-2309-5d44-95a9-5a1735176457', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('55d9222e-b2a9-5112-a7d6-d09806d7ee8a', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7c84a1e9-a260-5dea-ba1d-426b575a7cd1', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('31b26721-aca7-575a-8c09-bdb4e5018944', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7973fb69-0375-5923-b647-589c78c6d3a4', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8ecdee48-2002-58fb-b6d0-d6ce74945739', 'c19b5690-3158-5eb9-b0ab-97ceda90e8b4', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3754e04b-74fe-5273-ab84-7902cf136635', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:10:29', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5b75b0e2-9bde-570e-a8d0-7867b11e3365', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('85dff008-a583-5add-8d9d-33ab368239ae', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e8e411b3-0fdd-5664-9746-e92986ce20e2', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9db9be6a-6d0f-59df-b63e-f8ee57bac183', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('adb9ac66-557a-5f32-af30-34c6a49a715b', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2eea4742-7d85-5c55-aa4e-fd64fe31be26', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('50dddc23-d212-540d-9b67-80e1ea0218b1', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e9342bf5-39d4-54fd-88d3-98ff0910571f', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('76fee0f4-c1e1-58ea-afed-e697be2a1c51', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('140c0ff1-b5b1-55a9-9ada-d8f35335b0a6', '27a184be-bc1e-575c-b8f3-cfa4d37f038f', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c18b9dcd-2fb7-5faa-8fb0-38302ac619f7', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('41dff8fb-5f8d-57ca-937d-bd519ea9faab', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-08-29 10:30:29', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8426b9d6-76a5-511c-865d-84ff2874a1f7', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1451257d-9dc1-5994-b8b0-4d6f314a50d2', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1c214d72-65fd-5d9f-90fc-de0d919c7d41', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ed0286dd-e5a2-5a5b-b086-38f06e2b3739', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ec3cf252-0b2f-5c4d-80f7-c98b34cc0c2e', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f636522e-d591-52f9-b98e-b4db19a6233b', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d66245a4-3f6c-5dbd-80c0-6b4fa19770fb', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b6b572aa-e6a8-527e-b8c1-d6879789e5f7', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0540c623-2a2c-55d0-a03a-3c0f4d18294f', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2dd6b5bd-5e87-50f7-b46f-d8ea22a0a0c8', '27a184be-bc1e-575c-b8f3-cfa4d37f038f', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1f4f78bf-92f6-5781-a721-b73b26863601', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9cc02fd3-7c14-5f8e-995c-51d4a3d6c2e8', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-08-29 10:33:49', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b43f912f-0af8-56c1-a3bf-20943fee3261', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('20c0c33b-c1c0-5182-8aa3-c217a60c5ca1', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5fd003be-eed7-53b0-b5c1-55cecdfbf1b4', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('022e88ce-4031-5e3c-9049-be4738c002e8', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f70ea4d3-7929-5758-a3be-70b52e9e47be', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8b827029-19b8-5e18-88d5-b404468a460a', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0c91480e-e02c-54a9-9e9b-0ab1e4b243b0', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('480710e7-e8aa-5ca2-9371-cb768fd876b9', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a1c9fe3e-dd07-5691-92ac-6fe6847d547c', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8db835b7-052d-5494-9530-368d67e49a43', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('07ce4579-f76d-5e0e-a16e-fd3be71922d5', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a6f8312d-da5b-53c9-8f91-5b5df6bbbed6', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3d6eabbf-8aac-5667-a727-6b3a0b3885e9', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 10:38:48', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('66554989-ffbc-58dc-857c-53cfe846c5bb', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3260d5ef-8e5a-5aa3-9a63-9d7113c32d20', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('29459dbc-8b8e-5056-a21d-c840fc8aaede', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('58cc40f5-d83b-5756-85ad-6e4efa259c8e', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('418500f2-92eb-5c51-8b1e-6befe0303973', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fb50aec4-6c09-50f7-b7cc-e3c95ec02db3', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3f06af29-be02-5cd1-81ff-b714b3534971', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ef74195a-b918-5dcf-b0f7-bcaead9c532a', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3c9bf475-6412-54d0-8195-2aefa074e02d', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8e5fefc3-a7ef-512c-adfc-236ec62d776c', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('04a65636-4787-5d2c-bd41-2b67ea240001', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('64d8138d-4504-5e10-93c8-fc75e4f802cd', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('17f22077-7273-510b-8c9f-1cb8a2a22220', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:40:32', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5d9a2176-18d5-518c-ba73-a225fc387abc', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5bd478e3-1b29-5d2a-be0f-f97fd04afe68', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b740d2ae-335f-55c5-85a2-4d4304b5e6bd', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6051e1c2-932b-5590-99a9-f34f73d104f6', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9bbdca2d-8ffd-5ed1-862a-ff62f1199c58', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('bbbc9faa-464e-5ee4-9206-6d85339192cf', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('cd26a98c-14cf-5373-b2c5-c99f0b82d9f4', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('824acdcc-bb9b-5817-aaa0-79e67506d196', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('09e44336-c0ee-56bf-a0e4-ccbf32e3c6e1', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fc610b94-6636-5f00-a945-80ae34de7b17', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('591861b9-abaf-597f-a901-25ba8d31a393', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('be6db51b-c0a8-5ab7-a057-482cffbc6b41', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2347c4e7-240f-5bc8-b4c8-2c9db22d7c14', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-08-29 10:43:57', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('62217816-7fa1-5688-96aa-05f886c2c0bd', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fa114ac4-d857-5c95-8226-5cd4df7f5e93', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4f4ef83a-5774-5fb4-b569-1009b453fa58', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('823b85c9-862f-58a6-a3b2-64b00925224a', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c4d3f7b8-e6c0-5873-8df0-9801586ea568', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c2679933-ce8a-5708-95a2-d4f7bee8970d', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4b4c2109-1a3d-52f0-9307-c8a432004aef', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('71fcb12d-050b-59a7-b15f-95ce56471967', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4eb0f647-081d-5b50-a72b-27f013f85f4d', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('385bfee9-c1ae-5242-9bf7-d8ec37da98f8', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f864e3e8-85bc-5871-b180-227393407ca4', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('300ff18a-3633-5463-bd81-4816bab6fa75', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3206c711-f713-5889-9ebe-df7fb88bf33a', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-08-29 10:46:34', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('29572a00-baed-50d3-9336-a51b5e2b90e9', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('cbd498c5-126b-5e53-98bc-f0e4f8786f5e', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e9094493-e3e8-526a-9097-be09f943289e', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b5c50904-7140-593d-bf9c-3333efe7be79', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fbc812c3-3521-5c54-9d44-fffa227b85f9', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3b0153b5-2a40-56dd-8fcf-ec8f4a41ad40', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('933451b9-13d4-5983-a330-e68ccd2c52ec', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('cbe320bc-807a-5ce8-be0d-bd51a2cf6cd6', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('482bc120-2c16-5cc4-9c10-7f234e8b696c', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1ac51d86-7456-5b9d-a647-c66b16c463a4', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3efe3ce9-953d-5046-960d-d7626a7c8073', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b8bf51d0-57b0-52a5-b759-9e1ef7e04fde', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:49:20', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('39a4f675-ea5c-53b4-9008-beb850b187c1', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e4b442d7-38a4-5062-a126-61e3c38d95c6', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d128d031-e19f-5e5d-abaf-e9dc7ce3ca59', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('08a9bbe9-0726-502b-9574-a271919124a6', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5fdf6a10-a9df-5d88-ba5a-250a5299c00d', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('700d09c9-c3b8-5219-a587-9e23373ed5b1', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('befe06a7-a585-5269-9319-a57a19497dcf', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('bbf8e10c-5371-5e42-a0bb-b1c3eea06aa0', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('43d627c5-2eb1-591b-a8f3-b9043ce9c575', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f90e21d1-6867-5bd6-83cf-86608176257c', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0ffc1ec9-4a18-566c-b4af-ac0fef7d5855', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 10:51:33', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('116bf7a3-22a2-5cfb-918e-00c76ec18aa2', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 10:53:59', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f1d27e29-6aa7-58a2-8663-315642e61e87', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 11:06:12', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f1da6c4d-7baf-5a9e-83c0-ba781b4cd38a', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 11:06:59', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2a61935c-c550-5a05-9fd3-d04ac66d65e2', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('77c21fb9-444f-5cee-9c82-2d383fe77eb5', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9aa52930-3cd0-55a2-aed4-083ca7874b06', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('580dc2bb-4f56-527e-b2e2-903397108c06', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ff092a21-c6b7-57f8-afb4-1739ee8390ff', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5ae98ce1-0f64-5114-b3e9-00373c27db33', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('57992b88-8123-5edc-b528-8f4d7f49f682', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('02c91e42-581c-593f-a51f-fdb782b52a85', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f43055ca-4ba6-5f5d-9f25-36b4eccbae74', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('bb4ab483-f9eb-54c6-8fda-4af6e1f4adc6', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('955d7b8a-f4c4-5fd7-b7c6-7b41d7a2924b', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('703ee62c-b2bc-5614-9cef-76335e284cb0', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 11:09:33', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6d3e85c7-36de-5ead-a4c9-40eea7c77612', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4ed90099-eb8a-57d8-a797-02931d2f3406', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c9b565ac-a312-55a2-950c-250a2753f455', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('34f5d3b0-3fb2-54e5-8c26-f26ddbb0576d', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('15576a47-8baa-510a-a879-0c8f57a0d85d', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c1558b5e-781c-5c2d-b875-d8bbbc1b5a7b', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1a8a166a-1a0e-5334-937b-35978b3e46e7', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d1bab971-112c-511b-ac39-3acc92948973', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4a2108a6-751c-5bfd-9914-cd0ae702b8ae', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fce7ccc9-23c4-53a4-ad14-0b99766de38a', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4ff72587-0f90-5495-8ce3-a29ba0d25d63', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('296fe622-0741-56ba-b3bd-8ac8e659d9b5', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 11:11:43', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('87c6e0ff-245b-516a-ab09-a27cdcc813fd', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a28d8ee3-93de-5411-9795-ac2a7f27dd22', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b9fd3b52-6511-5fe6-8d10-525b3e9de4b8', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('df2f0ff5-cc98-5947-bff3-ae9d9af42fc5', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('08cca171-2173-54ce-b924-de00f6472cdb', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ffbd7045-8ace-5732-b138-6b0a0f7b9c83', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2d6c5f9e-9f7a-5153-b388-7d88da894b25', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8f3702ab-5720-554f-8562-8f2717838dc9', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a2338aa5-10e4-5f55-984e-67b76eade728', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('07f8684c-af28-52bc-b9f7-0475b6bd4120', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d4d3b393-f33c-5bf7-bb96-228e77341d87', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d84d26ee-23e7-5cc4-8941-c9cd8dcf7f72', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 11:17:58', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('507e7893-c359-55ed-93d5-83bf2e567af8', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('16ac1418-a6ce-5962-ac48-84cae203cc56', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1355951b-7a17-5016-a41e-059d1c810eb7', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e09570fe-0f62-56e8-9edd-b9be15360b22', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a8e39cc2-9ecb-5249-a422-ab300135dff7', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2b7e3c99-dfdd-5be9-ad16-f30468e7d9c6', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fc203953-3ade-536a-800a-abb95745bc1f', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('01d304dc-cb7e-5f56-b92d-9563fe97b4e1', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8f2c221a-b025-5108-9810-884b72cef6bc', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c5307d47-105c-54d1-8228-460a2de65c7f', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('077b27b8-435b-5147-bb52-b21b03f9ebde', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5c20d25e-7181-5969-970b-d2c2f08eabe2', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 11:19:48', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a436bba2-0e27-59b8-b5e0-d7b7b019f617', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2a60016a-964f-5d49-803b-c59bd2b56724', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('05b64d20-c748-579f-8ded-a3a27ea7d9d8', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7310b794-ae59-5c29-b012-47dfcbdabffb', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c167638f-08cc-5018-ab63-eaccd5cc3c10', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('903fe9bc-3a8e-505b-ab39-48d6fd2faee4', '74eb5e4d-263f-5c1a-8061-6b1f0321b133', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('68618c2d-61ee-5261-b46a-0a08910565d3', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c42eff32-4812-507d-88ee-33715f8a0cf1', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('eaaf6578-29d8-5c4a-bffe-290dd2333d1f', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('68fbd419-86af-5136-bd62-2e7e567d51fa', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b5f2d8bc-9dd6-5ae3-8807-b34117e04f0d', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c5a17a77-ccd2-5579-8e03-e31829ea7d6d', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e448f7ca-7838-5296-85c6-ba2cebfdc59b', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 11:22:55', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('54fdb515-40a2-5f47-b108-9c3c2482888c', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('119c29ff-c06a-58ad-9a22-b1c9aa78d689', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b34f7b92-6286-5e4e-b3b6-4aaa2c5c42aa', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c0c5644a-4ed6-5cb2-b729-84666d0c2e55', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3442a8f1-c704-524c-aa5f-604deb35c3be', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('94a6d4ed-84b2-5c38-9c58-9861b2c90237', '74eb5e4d-263f-5c1a-8061-6b1f0321b133', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('be7e3299-bf0a-5c54-891e-d352ec88952f', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('dd79a0b0-09e3-5a8a-8289-aafcfe0b3023', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('eeec41ba-6c51-5350-9e14-3bc026e04d95', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('992c32da-4ae0-5b01-aab1-3ba087c9c8c8', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2b7b4efa-0e87-51d2-a05c-e2d7129809a9', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2334f782-be7d-5ef5-a123-905ac106c7fe', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('37ff66df-1aca-5f71-acec-ff1c53f98b76', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 11:25:15', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6a779adc-05f8-5779-9a29-c0b4c4cd154e', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('688db430-28a8-5d52-8fcc-c701a1d4d5b1', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('78ddea24-1645-50e7-8635-7b4ead6b031a', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a7f4008a-66dd-58c2-a53d-a712bff6dcef', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7e66ef2a-f1fd-5b33-94fc-6fbd2673e02b', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0dd3174b-8501-52f2-a313-f542ea54e6ed', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4e94ca4c-f4cd-5032-8c68-7f10881d1526', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('72014de7-f306-5652-89db-9627d4f70b0c', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('aaf3e9bb-00cd-5c38-a82f-9f0962440bc3', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0dc7f905-ae3e-5b08-bcfb-daab387132b0', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ad718ba9-9adb-5163-bf71-c77efad0c315', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c00af3f8-4275-50bc-bb9a-94f5783ae6b5', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 11:28:41', 'ENTRADA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d9062c9b-696c-5b54-90b5-c0282d6906c4', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('50abbe7c-f7c2-5e65-9666-95efcf66b3fa', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1996a006-2ff1-5ff5-bae0-2ad70ac7f26c', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('33a91aea-f082-54fa-8fe4-df637aee356c', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8dc55bd4-fc83-5046-8d9c-ab7c02b0045e', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('03251032-6637-51b1-a2fd-eb659d624967', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c1663f8d-2743-515c-819d-7f6009d4b6dd', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7cd813d1-a245-5844-a9f5-fd21293cca99', '37d72b43-c289-5f43-966c-6c5f5a2539fe', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f27c0c6e-7af5-540e-972a-e168638fc807', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('946fd934-3498-5c3d-bb3a-94a063236985', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d362257b-2a3b-5c5b-b452-42138ecfbb4e', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('487abc78-784f-5862-a96e-b3cbbebc8e31', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 11:30:40', 'SALIDA', 'Noche', 'Barras ') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f3df017a-03c0-5f57-8ff0-40978de9e353', 'e5f494c1-6d4a-553c-9674-1f340a7b36a3', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('cdbf6454-9e9d-55ee-8e28-37f216775c1b', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e4bbb827-d0dc-52c1-b1d5-e9654c6d46fa', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c1126b6a-de7b-51c7-9fe9-b20f38840cd8', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fa69e648-b7fd-5ef1-8b35-ef2c2e8ff4cc', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7b124964-cf5d-5eb4-a550-3ba8ab9b6be5', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f0e25090-aeba-59b2-9763-674dc070334e', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3f2a6c22-b514-50be-868e-5963e2946441', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('08ae70c7-efd7-5316-a747-db23e9262acf', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5520de73-3324-568c-a365-ce77d2323ee7', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d5aff9da-104c-5298-b359-1a9df8b3bb1a', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7cf77490-7bf4-5326-b246-d75d7dc1b724', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f353337d-e382-5d90-b9f4-4253b71246a5', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 12:11:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0db3296e-29b2-56da-97db-997d39d62ef5', 'e5f494c1-6d4a-553c-9674-1f340a7b36a3', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b3f545f5-1f2b-5b9c-b159-1f446f7f3a6e', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('41b79253-2ec4-561d-bf15-771ede78fde2', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fdb6d29d-aafe-5829-8887-afdf3eac18d5', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c6ffc217-f2e5-5ff4-bf63-605444a3d258', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fdf405b6-a689-572e-80e1-cdecb8064f3e', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0c476a27-7087-55c8-8a1c-c69c0c885612', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b14cba01-179e-5600-81b3-a5cdbf949299', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('bb57246e-0c56-5cce-93a1-683eb50927a2', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('dab7e0b9-68b9-5350-87ed-508d2da5ad89', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('908fbc2d-de40-5bad-aee4-e1713f7c0019', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8e47cad3-46c0-5f7c-a525-77c91d608dc9', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('62c65487-ed3f-59bc-b940-6e19a763879f', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 12:13:57', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('12258ebd-aa8e-5359-96e7-a1aef86302de', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0afe6481-8d42-5c26-a6bc-bc2d818ee59d', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('65832345-b4ed-50a4-985f-4167ed16be05', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b2a0ccb9-6eca-5a00-b631-23c80ad20731', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('39849081-0a22-5323-8484-fb98f9f3be70', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fc17a2ad-485b-5605-80a0-34f2e587898c', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6e62a715-eb71-51a8-a2c8-47313f671cd2', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('84277c5f-64bd-50d8-aa33-1ea85387cd9f', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('93197536-47d3-5dd7-97af-71cbde72e5fd', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('85885ae2-ae5e-5ba7-bbde-213b4b089b0c', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7dd8d76a-383d-5dfe-8731-2efe2627cf27', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7810b6ad-cd12-53a8-8756-1ad8c630cd10', 'e5f494c1-6d4a-553c-9674-1f340a7b36a3', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fe7f449a-6b22-5319-93ab-bca6d9dbdb97', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 12:16:47', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('443b9982-abce-5132-88f7-077ed8311220', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('982ec3f4-08f5-5c0e-b761-9bf90034959c', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7f5056ce-a8f3-566a-918c-0766b27f2b2c', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c9d6d377-e82b-5fd9-8b43-398e2371f961', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('36069ecf-1885-559e-afe0-7f5a88327263', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('91d1441e-3864-57a3-9a39-e0a94b223fce', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('478e2f24-5988-5b39-ab86-baffbc010cf0', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('76210848-7c8e-52bb-a932-d16200bfa090', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('61f2a274-8d3d-5c4a-b3cf-5fbcb333a0d7', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4b6b3427-68bc-5a8c-abbd-1edaa21110d6', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2af0aef7-35e3-5eba-803f-db25601b8888', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b49df097-fbf9-51f9-988e-8d5803408854', 'e5f494c1-6d4a-553c-9674-1f340a7b36a3', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3326cfbf-1086-56d4-9940-ad080f212161', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 12:19:54', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d55e4716-ac6b-55e9-b631-76c5ecfa021a', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1a65dc84-0828-54f9-b3c8-06fda8f34c43', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d914fbf6-bab8-52ae-be05-c836e330a739', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('865b57fa-6823-52e8-9446-609ad2e6d36a', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1f98a673-fefc-5ca6-b2cf-f25de784f879', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b127f6cb-2b5d-5752-9b05-667443f531e8', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3556f74d-5420-5aec-9668-8d5e24e7354c', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c1ada571-8c32-5fa3-ad0f-91bf56331747', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d97ccc68-de6c-59b8-906f-91f792a08a4a', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('20956df5-c31d-5b5e-97c9-ede0a343c939', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('76a3601d-3f91-5970-acac-44caaf030915', '2c18aee3-5b6c-5458-9b4a-78a40af6102d', '2026-08-29 12:23:03', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('35bc8f95-fda5-5adf-97f7-5dab4bee7dea', 'c26bfdf3-dac7-5450-9e5b-a71952e3ed8b', '2026-08-29 12:24:06', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('51239a92-eb76-5aee-b3a1-283d1f28c0a2', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('309cbc5c-d908-512d-b281-f1990adee4d8', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c0dc32dc-58d4-5369-b83b-e78443292753', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1299d47c-dd3a-5e5f-bd18-fd2207c6dee2', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('eb699370-02a6-563b-b4d3-85378065e38a', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('aac35e59-3697-5993-9aa2-2186fdd68a20', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('1d3e2ba9-89f2-5cd5-b666-fe95f9442086', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0fe5d56f-cdc4-517d-ab62-d5e7b01cd294', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a7a3ad34-3884-50ee-96b4-c2c4d0988830', 'c26bfdf3-dac7-5450-9e5b-a71952e3ed8b', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2bb8a3c1-dbb0-53c2-9738-5341c56a9812', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9dd73988-7b3a-51b6-a7c9-804251c83d13', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6f64a35e-c7af-5cb4-8c10-5e134aa27c6c', '2c18aee3-5b6c-5458-9b4a-78a40af6102d', '2026-08-29 12:26:27', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('99274766-5cb0-5d8e-9f19-0d32fd514b9c', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('cbc36dfb-f444-5a24-a96c-275281d8f0c4', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c43443a1-7ad6-55bf-9514-2b8f9e238005', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('de410013-5631-5870-b953-c31b9e8eae1d', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('18ec05d7-0ad6-5e00-b151-10cac245b6e1', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e929b156-6a25-5458-9a01-6617d1509d45', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('26ce2fd2-3f18-5761-8be3-321c8d0bcc41', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ef24bc4f-f219-5aed-b68c-b330e3a2e147', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('cdb0e45c-80f6-5869-bead-86bb84887ef9', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('41a5a2b8-7be2-5742-ae2f-7f81fa3434da', 'c26bfdf3-dac7-5450-9e5b-a71952e3ed8b', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ee063f58-0896-5a04-bfb8-a75378ad1ba6', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6e7e7f86-8878-5155-b2bd-849323630255', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('08550be5-5743-5ab4-aeea-c1e80f6a546d', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 12:28:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('31e9fea6-34d6-51a3-ae97-eaec6ed072de', '09aa90b1-ff4a-5074-be9f-cbca85a70da1', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('84cd72b5-75fc-5cdf-a6e1-e012e1cf84de', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fb2d00ce-d146-5bd0-9986-2fba59af2877', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('c4d9b8fb-46a4-533b-9993-3ee5c187323e', '7b0f11a2-13b0-59e4-91a1-d9293c421de2', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('85539d22-3e42-59d0-8c89-5056ee7f142c', '83c114de-eef7-5d30-b195-74db6709c09d', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('87241b82-2d31-5596-a376-7ef09f06042e', 'e0a333ee-eda3-5852-b68a-14aa6930e264', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9119919b-97fd-5b60-8d4c-c3014c7a976d', '4ef9cb20-d657-5772-8fc7-656cfebd52f7', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2daad41d-1fff-5028-8841-6da1212e9d2a', 'ca3fb2b3-6fb3-5e50-afae-06238a1f44be', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('cf83fd5b-7dd3-54b8-9a7d-73749bb6a42d', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('dc01fb64-95fb-5399-9fed-87456801af10', 'c26bfdf3-dac7-5450-9e5b-a71952e3ed8b', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0aa7c562-0665-5cb9-921a-612642249f93', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('cd8ca73c-e63f-5b7e-ac33-079b140f63ad', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('940018af-3197-5404-a25e-beb00de79a74', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-08-29 12:31:34', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0ecefcf2-b7c3-5d37-a015-c1282414c33e', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('dca4f72b-a6fb-5a2a-ab91-ef5786ec1e07', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2307922b-078f-5633-b4ed-a4d395ff1538', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('208691f5-ee69-56a9-b1f4-a9d4c242b24e', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('f83a8309-9905-579d-8c35-30aff9acb326', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('7168004c-f214-5853-b7d5-50710bbf568a', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a9aa3192-939e-5daa-b569-6274460ecc88', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('ccf1db6b-4995-5729-a055-e9bafcf7dbd3', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('af444180-9ea4-5cdb-9968-f8e0fdbbf68c', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('5578308b-f415-57cb-a306-d6d3eae81da6', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('4dfa90ad-46a3-5141-b16a-f5c322908271', 'c26bfdf3-dac7-5450-9e5b-a71952e3ed8b', '2026-09-05 07:56:11', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a09f543b-7da4-5ac1-808b-b11371358293', '1416bbf1-76c9-5f4b-86e9-71bae01b8f18', '2026-09-05 07:57:49', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('129604aa-b64d-51dc-bb44-29fb69ecf336', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('0421c45e-7d96-5513-9ac1-03aacbfd6f15', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2870e7f2-0553-5ce0-a698-0f963196655c', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('9a2fc826-6a9b-5bf3-93a3-d296c97304f8', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('93fbfb5e-2916-5419-b8dd-bf0572c36864', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b5091696-2209-5d63-a75c-2f4280d8fe85', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a2133c38-c296-5d75-984e-bc20fc44b0b8', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d79c1d18-e599-5b11-9f2e-e07eaef99ad3', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('bd339102-99e2-54fc-b74f-91c62e93339b', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('17a9c71c-4383-5d27-b3a2-b6958f61fa9e', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a743e0c9-c683-5ab8-9ee5-24220f098e03', 'c26bfdf3-dac7-5450-9e5b-a71952e3ed8b', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('18c34f30-c6a9-563d-b719-5a04149178f5', '1416bbf1-76c9-5f4b-86e9-71bae01b8f18', '2026-09-05 07:59:55', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('2549e35f-b12d-5966-864b-7b34540430df', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b12c27c2-e8cc-5850-8077-db5b5b156d90', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('dd4e5b67-ff0c-57b3-9235-076769ac23b4', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('50082a9b-4e5e-5e84-968d-087eeb5abad3', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e35d2f2b-fbb3-509d-96eb-0e9571fffee7', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('aa17d430-1844-530f-8e9b-83e6b8cb060f', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('413ebdb8-eed1-577a-8acf-b4cbec93f015', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d18cb0c8-d399-53b8-ba77-547382626d98', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('d13e17b4-b04b-5860-ba4c-35cae9b145cc', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('48ea015a-22a1-528c-aaa9-23bc1b221abe', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('b70aa861-efee-53d7-9a77-f2e55204e8fa', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3b075247-3188-5529-9306-a4dde3706616', '744d5d34-0876-5571-bce2-1521a434e448', '2026-09-05 08:03:41', 'ENTRADA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('fd4d191a-3153-53d7-8825-8ff8c6b2b3a2', '1656d9a3-eaa7-5e09-9f3f-9f27795843f9', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3946f5cb-654a-541a-9826-e06c311b24a4', '9f4bde98-48ae-5bf1-a770-619aab95a7af', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('997b0ee6-3e35-51e8-9488-0d9fdc3eaab7', 'ddd37ed1-c590-5977-9a57-5187bbcef2cc', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('a6318e86-db1f-550e-bafe-8d79e5146864', '8f190d3f-9893-5e21-823e-a11c62d81ada', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('8bc8da9c-e7a2-59e2-9c68-4c2f197c9131', '78cbfe55-03ff-5381-9678-701641e48a31', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3d1e2809-fbb4-5d44-a207-ef11676205a9', '46bf853f-f2d3-5139-b666-e14c3451dc9e', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('eeaffc4f-6704-5ca6-b77d-e1072152278b', '22d2e2a5-6983-5b55-b009-ef8fa45b1a75', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('798a5c32-506e-5f29-93fd-f53261006e70', 'b434f5cb-8f9f-572e-80ec-1f441a419607', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('3e6f77db-da0b-545a-aec0-4fd21b47befa', '1ebc5a0f-e170-52b6-99b6-a3db03a33148', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('6abf214e-7715-52c3-9164-5ec0fa8dff1a', '2596ae9d-bc77-522c-9191-b2e967dc0647', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('05b81d15-8b27-5b07-80e0-abffd103a3b2', '11e27f20-c871-55b2-a3e1-4069b6e188ac', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;
INSERT INTO public.registro_asistencia (id_registro, id_trabajador, fecha_hora, tipo, turno, linea) VALUES ('e6ec9605-a2f6-5a18-8dfc-092a742eb0a8', '744d5d34-0876-5571-bce2-1521a434e448', '2026-09-05 08:05:50', 'SALIDA', 'Noche', 'Galletas') ON CONFLICT DO NOTHING;

-- Insertando Jornadas Producción y Bobinas
INSERT INTO public.jornadas_produccion (id_jornada, fecha, turno, tipo, id_supervisor, merma_piso_crudo, merma_maquina, quemados, caja, merma_piso_cocido, cinta_embalaje, tampon, merma_bobinas, sobra_bobina, cant_batch, cant_extruido_tolva, pop_kiwicha, pop_quinua, merma_piso, observaciones, created_at) VALUES ('470b71f7-6f60-5680-8996-7da26ce7d013', '2026-08-25 00:00:00', 'Noche', 'Galletas', '0c7829a8-c706-57e8-85ea-bea33957180d', COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(41.3, 0), COALESCE(33.4, 0), COALESCE(3.0, 0), COALESCE(NULL, 0), COALESCE(5.3, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), 'Se rompió el molde de la troqueladora', COALESCE('2026-09-03 12:09:33', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('8a238ae2-46c9-5dc2-9566-aba129dbafb4', '470b71f7-6f60-5680-8996-7da26ce7d013', 1, 9.95, 9.08) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('22b2c2c0-5de2-5f18-857a-ed6b2cd8a8bf', '470b71f7-6f60-5680-8996-7da26ce7d013', 2, 9.85, 9.6) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('888881a0-75ba-5f53-9392-70b47044ec3d', '470b71f7-6f60-5680-8996-7da26ce7d013', 3, 10.06, 9.7) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('91f844be-9efb-5d6b-9721-993864c091a5', '470b71f7-6f60-5680-8996-7da26ce7d013', 4, 10.05, 9.7) ON CONFLICT DO NOTHING;
INSERT INTO public.jornadas_produccion (id_jornada, fecha, turno, tipo, id_supervisor, merma_piso_crudo, merma_maquina, quemados, caja, merma_piso_cocido, cinta_embalaje, tampon, merma_bobinas, sobra_bobina, cant_batch, cant_extruido_tolva, pop_kiwicha, pop_quinua, merma_piso, observaciones, created_at) VALUES ('8cf94dd2-803f-5494-9900-50425cf03544', '2026-08-25 00:00:00', 'Dia', 'Galletas', '0c7829a8-c706-57e8-85ea-bea33957180d', COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(64.0, 0), COALESCE(42.0, 0), COALESCE(4.0, 0), COALESCE(NULL, 0), COALESCE(4.6, 0), COALESCE(NULL, 0), COALESCE(16.0, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), NULL, COALESCE('2026-09-03 12:14:13', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('a206ad4b-9525-5473-b950-1a458088ff41', '8cf94dd2-803f-5494-9900-50425cf03544', 1, 12.4, 12.15) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('76f85472-fdb1-504a-88f5-0a6ea85cc129', '8cf94dd2-803f-5494-9900-50425cf03544', 2, 12.4, 12.15) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('819c739a-8403-5906-9df2-4d9c03641c0d', '8cf94dd2-803f-5494-9900-50425cf03544', 3, 10.0, 9.26) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('692ffae4-130c-567a-a928-1dd5a33f78a9', '8cf94dd2-803f-5494-9900-50425cf03544', 4, 10.0, 9.66) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('576ce977-39ad-553a-a4a4-2c0d42164860', '8cf94dd2-803f-5494-9900-50425cf03544', 5, 10.0, 9.66) ON CONFLICT DO NOTHING;
INSERT INTO public.jornadas_produccion (id_jornada, fecha, turno, tipo, id_supervisor, merma_piso_crudo, merma_maquina, quemados, caja, merma_piso_cocido, cinta_embalaje, tampon, merma_bobinas, sobra_bobina, cant_batch, cant_extruido_tolva, pop_kiwicha, pop_quinua, merma_piso, observaciones, created_at) VALUES ('ad9c2f7e-8d4a-5df0-91f5-cf6bacf08666', '2026-03-23 00:00:00', 'Dia', 'Galletas', '0c7829a8-c706-57e8-85ea-bea33957180d', COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(40.35, 0), COALESCE(22.8, 0), COALESCE(NULL, 0), COALESCE(4.0, 0), COALESCE(1.0, 0), COALESCE(3.2, 0), COALESCE(2.3, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), NULL, COALESCE('2026-09-03 13:59:15', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('95a3ffc4-9397-51dd-b557-4ec6f7753c94', 'ad9c2f7e-8d4a-5df0-91f5-cf6bacf08666', 1, 8.6, 8.35) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('b145a06f-8c8d-5fab-96af-1fff5c243b84', 'ad9c2f7e-8d4a-5df0-91f5-cf6bacf08666', 2, 12.4, 12.15) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('60b19faa-4af6-5c65-9ab3-51526c702dde', 'ad9c2f7e-8d4a-5df0-91f5-cf6bacf08666', 3, 11.2, 10.95) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('9f2b2344-194d-5b64-9b36-b12be2d53f31', 'ad9c2f7e-8d4a-5df0-91f5-cf6bacf08666', 4, 11.2, 10.95) ON CONFLICT DO NOTHING;
INSERT INTO public.jornadas_produccion (id_jornada, fecha, turno, tipo, id_supervisor, merma_piso_crudo, merma_maquina, quemados, caja, merma_piso_cocido, cinta_embalaje, tampon, merma_bobinas, sobra_bobina, cant_batch, cant_extruido_tolva, pop_kiwicha, pop_quinua, merma_piso, observaciones, created_at) VALUES ('7b79cfe3-3c79-5fc4-b7ab-94ba5eb42755', '2026-08-02 00:00:00', 'Dia', 'Barras', '0c7829a8-c706-57e8-85ea-bea33957180d', COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(2.0, 0), COALESCE(0.0, 0), COALESCE(3.8, 0), COALESCE(0.0, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(0.0, 0), NULL, COALESCE('2026-09-03 15:08:52', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('1c3efde6-082c-5a59-ab76-ac5cba9f3550', '7b79cfe3-3c79-5fc4-b7ab-94ba5eb42755', 1, 14.4, 14.1) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('a32df300-3549-5acf-81c6-9e29a1422d8d', '7b79cfe3-3c79-5fc4-b7ab-94ba5eb42755', 2, 13.8, 13.5) ON CONFLICT DO NOTHING;
INSERT INTO public.jornadas_produccion (id_jornada, fecha, turno, tipo, id_supervisor, merma_piso_crudo, merma_maquina, quemados, caja, merma_piso_cocido, cinta_embalaje, tampon, merma_bobinas, sobra_bobina, cant_batch, cant_extruido_tolva, pop_kiwicha, pop_quinua, merma_piso, observaciones, created_at) VALUES ('d71aff14-83e8-56aa-8971-0343df6fb935', '2026-07-31 00:00:00', 'Noche', 'Barras', '0c7829a8-c706-57e8-85ea-bea33957180d', COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(3.45, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), COALESCE(NULL, 0), NULL, COALESCE('2026-09-03 15:11:36', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('fc1df439-b410-5a69-a4fa-1e4fa8472623', 'd71aff14-83e8-56aa-8971-0343df6fb935', 1, 14.8, 14.5) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('fb14a36b-5b91-55c5-bd60-d1fae14a3a08', 'd71aff14-83e8-56aa-8971-0343df6fb935', 2, 14.4, 14.1) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('d0fe4308-1a46-5fd1-a7cc-94a5da390816', 'd71aff14-83e8-56aa-8971-0343df6fb935', 3, 14.2, 13.9) ON CONFLICT DO NOTHING;
INSERT INTO public.bobinas_produccion (id_bobina, id_jornada, numero_bobina, peso_bruto, peso_neto) VALUES ('be6a08e7-df89-58d7-a7d7-688602948dbe', 'd71aff14-83e8-56aa-8971-0343df6fb935', 4, 14.0, 13.7) ON CONFLICT DO NOTHING;

-- Insertando Lotes
INSERT INTO public.lotes_produccion (id_lote, id_jornada, id_producto, numero_lote, f_vencimiento, cantidad, created_at) VALUES ('b827b29b-cd7e-5263-b6c9-7f36788e363d', '470b71f7-6f60-5680-8996-7da26ce7d013', '59e06cf8-f390-5093-af2e-3685be593a25', 2704, '2027-08-25 00:00:00', COALESCE(144, 0), COALESCE('2026-09-03 12:09:43', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.lotes_produccion (id_lote, id_jornada, id_producto, numero_lote, f_vencimiento, cantidad, created_at) VALUES ('871d07e5-ec7f-514b-b7ba-765aaf3e235a', '8cf94dd2-803f-5494-9900-50425cf03544', '59e06cf8-f390-5093-af2e-3685be593a25', 2704, NULL, COALESCE(101, 0), COALESCE('2026-09-03 12:21:36', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.lotes_produccion (id_lote, id_jornada, id_producto, numero_lote, f_vencimiento, cantidad, created_at) VALUES ('f63a43ac-73ad-5e97-8399-2a8fdc2df75a', '8cf94dd2-803f-5494-9900-50425cf03544', '59e06cf8-f390-5093-af2e-3685be593a25', 2206, NULL, COALESCE(70, 0), COALESCE('2026-09-03 12:14:16', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.lotes_produccion (id_lote, id_jornada, id_producto, numero_lote, f_vencimiento, cantidad, created_at) VALUES ('3d77b450-d1a2-5eab-8138-f750566a6d09', 'ad9c2f7e-8d4a-5df0-91f5-cf6bacf08666', '59e06cf8-f390-5093-af2e-3685be593a25', 1401, '2027-03-23 00:00:00', COALESCE(211, 0), COALESCE('2026-09-03 13:59:37', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.lotes_produccion (id_lote, id_jornada, id_producto, numero_lote, f_vencimiento, cantidad, created_at) VALUES ('7214d17b-868e-5b58-bec8-c844bf9817b7', '7b79cfe3-3c79-5fc4-b7ab-94ba5eb42755', 'd6ed313e-533a-55a6-aa06-4c00bc132812', 306, '2027-07-31 00:00:00', COALESCE(175, 0), COALESCE('2026-09-03 15:08:53', NOW())) ON CONFLICT DO NOTHING;
INSERT INTO public.lotes_produccion (id_lote, id_jornada, id_producto, numero_lote, f_vencimiento, cantidad, created_at) VALUES ('93ec5038-930e-5471-b297-8d6eaac82bad', 'd71aff14-83e8-56aa-8971-0343df6fb935', 'd6ed313e-533a-55a6-aa06-4c00bc132812', 306, NULL, COALESCE(282, 0), COALESCE('2026-09-03 15:11:46', NOW())) ON CONFLICT DO NOTHING;

-- Insertando Recetas (Balance Galletas)

DO $$
DECLARE
    mp_id UUID;
BEGIN
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de trigo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 83.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de trigo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 83.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de trigo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 83.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de trigo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 83.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de trigo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 83.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de trigo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 83.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de quinua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 2.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de quinua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 2.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de quinua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 2.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de Kiwicha' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 2.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Harina de Maca' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 2.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Salvado de trigo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 3.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Hojuela de quinua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 3.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Hojuela de quinua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 3.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Hojuela de quinua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 3.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Ajonjolí' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 0.4);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Azúcar' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 10.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Azúcar' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 10.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Azúcar' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 10.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Azúcar' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 10.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Azúcar' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 10.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Azúcar' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 10.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Leche en polvo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 1.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Leche en polvo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 1.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Leche en polvo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 1.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Leche en polvo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 1.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Leche en polvo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 1.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Leche en polvo' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 1.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Cloruro de sodio (Sal)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Cloruro de sodio (Sal)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Cloruro de sodio (Sal)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Cloruro de sodio (Sal)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Cloruro de sodio (Sal)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Cloruro de sodio (Sal)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de sodio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de sodio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de sodio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de sodio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de sodio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de sodio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 0.45);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de amonio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 0.15);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de amonio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 0.15);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de amonio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 0.15);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de amonio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 0.15);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de amonio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 0.15);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Bicarbonato de amonio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 0.15);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Lecitina de soya' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 0.4);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Lecitina de soya' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 0.4);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Lecitina de soya' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 0.4);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Lecitina de soya' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 0.4);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Lecitina de soya' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 0.4);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Lecitina de soya' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 0.4);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Propionato de calcio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 0.04);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Propionato de calcio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 0.04);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Propionato de calcio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 0.04);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Propionato de calcio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 0.04);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Propionato de calcio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 0.04);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Propionato de calcio' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 0.04);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'BHT (Antioxidante)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 0.02);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'BHT (Antioxidante)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 0.02);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'BHT (Antioxidante)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 0.02);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'BHT (Antioxidante)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 0.02);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'BHT (Antioxidante)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 0.02);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'BHT (Antioxidante)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 0.02);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Manteca vegetal' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 11.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Manteca vegetal' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 11.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Manteca vegetal' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 11.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Manteca vegetal' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 11.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Manteca vegetal' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 11.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Manteca vegetal' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 11.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Agua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 10.5);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Agua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 9.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Agua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 9.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Agua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 9.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Agua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 9.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'Agua' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 9.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'TOTAL FORMULACIÓN BATCH' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 122.01);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'TOTAL FORMULACIÓN BATCH' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 117.91);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'TOTAL FORMULACIÓN BATCH' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 118.51);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'TOTAL FORMULACIÓN BATCH' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 117.51);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'TOTAL FORMULACIÓN BATCH' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 120.51);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'TOTAL FORMULACIÓN BATCH' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 120.51);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'mERMA BALANCE DE MATERIA kg' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 32.41);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'mERMA BALANCE DE MATERIA kg' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 31.32);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'mERMA BALANCE DE MATERIA kg' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 31.476256);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'mERMA BALANCE DE MATERIA kg' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 31.210656);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'mERMA BALANCE DE MATERIA kg' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 32.007456);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'mERMA BALANCE DE MATERIA kg' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 32.007456);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'MERMA BALANCE DE MATERIA (%)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 0.2656339644);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'MERMA BALANCE DE MATERIA (%)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 0.2656263252);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'MERMA BALANCE DE MATERIA (%)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 0.2656);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'MERMA BALANCE DE MATERIA (%)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 0.2656);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'MERMA BALANCE DE MATERIA (%)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 0.2656);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'MERMA BALANCE DE MATERIA (%)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 0.2656);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'RENDIMIENTO PRODUCTO TERMINADO (kg)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 89.6);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'RENDIMIENTO PRODUCTO TERMINADO (kg)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 86.59);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'RENDIMIENTO PRODUCTO TERMINADO (kg)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 87.033744);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'RENDIMIENTO PRODUCTO TERMINADO (kg)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 86.299344);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'RENDIMIENTO PRODUCTO TERMINADO (kg)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 88.502544);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'RENDIMIENTO PRODUCTO TERMINADO (kg)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 88.502544);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'PESO POR EMPAQUE INDIVIDUAL APROX (g)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 32.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'PESO POR EMPAQUE INDIVIDUAL APROX (g)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 32.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'PESO POR EMPAQUE INDIVIDUAL APROX (g)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 32.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'PESO POR EMPAQUE INDIVIDUAL APROX (g)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 32.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'PESO POR EMPAQUE INDIVIDUAL APROX (g)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 32.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'PESO POR EMPAQUE INDIVIDUAL APROX (g)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 32.0);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'CAJAS APROX / BATCH (250 paq/caja)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('QUINUA', mp_id, 11.2);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'CAJAS APROX / BATCH (250 paq/caja)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('KIWICHA', mp_id, 10.82);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'CAJAS APROX / BATCH (250 paq/caja)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('INTEGRAL', mp_id, 10.88);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'CAJAS APROX / BATCH (250 paq/caja)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('MACA', mp_id, 10.79);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'CAJAS APROX / BATCH (250 paq/caja)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CAJAMARQUINA', mp_id, 11.06);
    END IF;
    SELECT id_producto INTO mp_id FROM public.productos_mp WHERE nombre_producto = 'CAJAS APROX / BATCH (250 paq/caja)' LIMIT 1;
    IF FOUND THEN
        INSERT INTO public.recetas (nombre_receta, id_materia_prima, cantidad) VALUES ('CEREALES', mp_id, 11.06);
    END IF;
END $$;
