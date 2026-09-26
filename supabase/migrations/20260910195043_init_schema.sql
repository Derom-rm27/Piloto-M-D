-- Habilitar extensión para UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Catálogos
CREATE TABLE public.personal (
    id_trabajador UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(255) NOT NULL,
    apellido_paterno VARCHAR(255),
    apellido_materno VARCHAR(255),
    dni VARCHAR(20),
    telefono VARCHAR(50),
    cargo VARCHAR(100),
    precio_h DECIMAL(10, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.productos_mp (
    id_producto UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_producto VARCHAR(255) NOT NULL,
    unidad_medida VARCHAR(50) NOT NULL,
    categoria VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.productos_envasados (
    id_producto UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_producto VARCHAR(255) NOT NULL,
    tipo VARCHAR(100) NOT NULL, -- Galletas, Barras, etc.
    unidad_medida VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Transaccionales: Asistencia
CREATE TABLE public.registro_asistencia (
    id_registro UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_trabajador UUID NOT NULL REFERENCES public.personal(id_trabajador) ON DELETE CASCADE,
    fecha_hora TIMESTAMP WITH TIME ZONE NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('ENTRADA', 'SALIDA')),
    turno VARCHAR(50) NOT NULL CHECK (turno IN ('Dia', 'Noche')),
    linea VARCHAR(100),
    id_supervisor UUID REFERENCES public.personal(id_trabajador) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Transaccionales: Producción
CREATE TABLE public.jornadas_produccion (
    id_jornada UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fecha DATE NOT NULL,
    turno VARCHAR(50) NOT NULL CHECK (turno IN ('Dia', 'Noche')),
    tipo VARCHAR(100) NOT NULL, -- Ej: Galletas, Barras
    id_supervisor UUID REFERENCES public.personal(id_trabajador) ON DELETE SET NULL,
    
    -- Mermas y desperdicios globales de la jornada
    merma_piso_crudo DECIMAL(10, 2) DEFAULT 0,
    merma_maquina DECIMAL(10, 2) DEFAULT 0,
    quemados DECIMAL(10, 2) DEFAULT 0,
    caja DECIMAL(10, 2) DEFAULT 0,
    merma_piso_cocido DECIMAL(10, 2) DEFAULT 0,
    cinta_embalaje DECIMAL(10, 2) DEFAULT 0,
    tampon DECIMAL(10, 2) DEFAULT 0,
    merma_bobinas DECIMAL(10, 2) DEFAULT 0,
    sobra_bobina DECIMAL(10, 2) DEFAULT 0,
    
    observaciones TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Resuelve la violación a 1FN de las bobinas (AppSheet: bobina_1, bobina_2...)
CREATE TABLE public.bobinas_produccion (
    id_bobina UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_jornada UUID NOT NULL REFERENCES public.jornadas_produccion(id_jornada) ON DELETE CASCADE,
    numero_bobina INTEGER NOT NULL, -- 1, 2, 3...
    peso_bruto DECIMAL(10, 2),
    peso_neto DECIMAL(10, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Detalles de lotes producidos (1 Jornada puede tener varios lotes)
CREATE TABLE public.lotes_produccion (
    id_lote UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_jornada UUID NOT NULL REFERENCES public.jornadas_produccion(id_jornada) ON DELETE CASCADE,
    id_producto UUID NOT NULL REFERENCES public.productos_envasados(id_producto) ON DELETE CASCADE,
    numero_lote VARCHAR(100) NOT NULL,
    f_vencimiento DATE,
    cantidad INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Detalle de materias primas consumidas por jornada
CREATE TABLE public.consumo_materiales (
    id_consumo UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_jornada UUID NOT NULL REFERENCES public.jornadas_produccion(id_jornada) ON DELETE CASCADE,
    id_materia_prima UUID NOT NULL REFERENCES public.productos_mp(id_producto) ON DELETE CASCADE,
    cantidad DECIMAL(10, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Vistas para reemplazar tablas calculadas (ej: Jornadas_Personal)
CREATE OR REPLACE VIEW public.vw_jornadas_personal AS
SELECT 
    DATE(ra.fecha_hora) AS fecha_laboral,
    ra.id_trabajador,
    p.nombre || ' ' || COALESCE(p.apellido_paterno, '') AS trabajador,
    ra.turno,
    MIN(CASE WHEN ra.tipo = 'ENTRADA' THEN ra.fecha_hora END) AS entrada,
    MAX(CASE WHEN ra.tipo = 'SALIDA' THEN ra.fecha_hora END) AS salida,
    EXTRACT(EPOCH FROM (MAX(CASE WHEN ra.tipo = 'SALIDA' THEN ra.fecha_hora END) - MIN(CASE WHEN ra.tipo = 'ENTRADA' THEN ra.fecha_hora END))) / 3600 AS horas_trabajadas
FROM 
    public.registro_asistencia ra
JOIN 
    public.personal p ON p.id_trabajador = ra.id_trabajador
GROUP BY 
    DATE(ra.fecha_hora),
    ra.id_trabajador,
    p.nombre,
    p.apellido_paterno,
    ra.turno;
