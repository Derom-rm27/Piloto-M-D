-- Migración para el nuevo Módulo de Almacén & Control PEPS
-- Procesos M&D Planta

CREATE TABLE IF NOT EXISTS public.almacen_insumos (
    id_insumo VARCHAR(50) PRIMARY KEY,
    id_num INTEGER NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    categoria VARCHAR(100) NOT NULL, -- 'MATERIA_PRIMA', 'INSUMOS', 'EMPAQUES'
    unidad VARCHAR(100) NOT NULL,
    kg_por_unidad DECIMAL(10, 2) NOT NULL DEFAULT 1.0,
    kg_por_batch DECIMAL(10, 2) NOT NULL DEFAULT 1.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.almacen_lotes (
    id_lote VARCHAR(50) PRIMARY KEY,
    prod_id INTEGER NOT NULL,
    nro_lote VARCHAR(100) NOT NULL,
    f_ingreso DATE NOT NULL,
    f_vence DATE NOT NULL,
    saldo DECIMAL(10, 2) NOT NULL DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.almacen_movimientos (
    id_movimiento VARCHAR(50) PRIMARY KEY,
    fecha_hora VARCHAR(50) NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('ENTRADA', 'SALIDA')),
    prod_id INTEGER NOT NULL,
    prod VARCHAR(255) NOT NULL,
    lote VARCHAR(100) NOT NULL,
    cant DECIMAL(10, 2) NOT NULL,
    unidad VARCHAR(50) NOT NULL,
    operario VARCHAR(255) NOT NULL,
    destino VARCHAR(255) NOT NULL,
    jornada_id VARCHAR(100),
    guia VARCHAR(100),
    proveedor VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Seed de los 19 insumos oficiales de formulación
INSERT INTO public.almacen_insumos (id_insumo, id_num, nombre, categoria, unidad, kg_por_unidad, kg_por_batch) VALUES
('1', 1, 'Harina de Trigo Especial', 'MATERIA_PRIMA', 'Sacos x 50 kg', 50.0, 83.0),
('2', 2, 'Harina de Quinua', 'MATERIA_PRIMA', 'Sacos x 25 kg', 25.0, 2.0),
('3', 3, 'Harina de Kiwicha', 'MATERIA_PRIMA', 'Sacos x 25 kg', 25.0, 2.0),
('4', 4, 'Harina de Maca', 'MATERIA_PRIMA', 'Sacos x 25 kg', 25.0, 2.0),
('5', 5, 'Salvado de Trigo', 'MATERIA_PRIMA', 'Sacos x 40 kg', 40.0, 3.0),
('6', 6, 'Hojuela de Quinua', 'MATERIA_PRIMA', 'Sacos x 25 kg', 25.0, 3.0),
('7', 7, 'Manteca Vegetal Industrial', 'INSUMOS', 'Cajas x 15 kg', 15.0, 11.0),
('8', 8, 'Azúcar Industrial', 'INSUMOS', 'Sacos x 50 kg', 50.0, 10.0),
('9', 9, 'Leche en Polvo Descremada', 'INSUMOS', 'Sacos x 25 kg', 25.0, 1.0),
('10', 10, 'Cloruro de Sodio (Sal)', 'INSUMOS', 'Sacos x 25 kg', 25.0, 0.45),
('11', 11, 'Bicarbonato de Sodio', 'INSUMOS', 'Sacos x 25 kg', 25.0, 0.45),
('12', 12, 'Bicarbonato de Amonio', 'INSUMOS', 'Sacos x 25 kg', 25.0, 0.15),
('13', 13, 'Lecitina de Soya', 'INSUMOS', 'Baldes x 20 kg', 20.0, 0.40),
('14', 14, 'Propionato de Calcio', 'INSUMOS', 'Sacos x 25 kg', 25.0, 0.04),
('15', 15, 'BHT Antioxidante', 'INSUMOS', 'Frascos x 1 kg', 1.0, 0.02),
('16', 16, 'Cajas Corrugadas Verdes M&D', 'EMPAQUES', 'Paquetes x 20 u', 20.0, 11.2),
('17', 17, 'Cajas Corrugadas Azules M&D', 'EMPAQUES', 'Paquetes x 20 u', 20.0, 11.2),
('18', 18, 'Cinta de Embalaje 2 pulg.', 'EMPAQUES', 'Cajas x 32 rollos', 32.0, 0.15),
('19', 19, 'Bobinas de Envoltura Galletas', 'EMPAQUES', 'Bobinas x 15 kg', 15.0, 0.75)
ON CONFLICT (id_insumo) DO NOTHING;

-- Seed inicial de Lotes Físicos Numéricos
INSERT INTO public.almacen_lotes (id_lote, prod_id, nro_lote, f_ingreso, f_vence, saldo) VALUES
('lot-1', 1, '2608', '2026-08-15', '2026-11-10', 10.0),
('lot-2', 1, '2609', '2026-09-05', '2027-03-05', 18.0),
('lot-3', 2, '1401', '2026-08-18', '2027-02-18', 2.0),
('lot-4', 3, '2206', '2026-08-22', '2027-02-22', 1.0),
('lot-5', 4, '2704', '2026-08-20', '2027-02-20', 2.0),
('lot-6', 5, '3108', '2026-09-10', '2027-01-10', 1.0),
('lot-7', 6, '4015', '2026-09-12', '2027-03-12', 3.0),
('lot-8', 7, '5020', '2026-08-10', '2026-11-05', 8.0),
('lot-9', 8, '6102', '2026-08-25', '2028-08-25', 6.0),
('lot-10', 9, '7011', '2026-09-04', '2027-06-04', 1.0),
('lot-11', 10, '8015', '2026-07-15', '2029-07-15', 1.0),
('lot-12', 11, '8020', '2026-08-12', '2027-08-12', 1.0),
('lot-13', 12, '8025', '2026-08-12', '2027-08-12', 1.0),
('lot-14', 13, '9005', '2026-08-20', '2027-02-20', 1.0),
('lot-15', 14, '9010', '2026-08-10', '2027-08-10', 1.0),
('lot-16', 15, '9015', '2026-08-10', '2027-08-10', 2.0),
('lot-17', 16, '1104', '2026-09-10', '2028-09-10', 15.0),
('lot-18', 17, '1105', '2026-09-10', '2028-09-10', 12.0),
('lot-19', 18, '1201', '2026-09-01', '2028-09-01', 4.0),
('lot-20', 19, '1301', '2026-09-15', '2027-09-15', 3.0)
ON CONFLICT (id_lote) DO NOTHING;
