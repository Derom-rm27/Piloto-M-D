/// Insumo / Materia Prima de Planta
class InsumoItem {
  const InsumoItem({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.unidad,
    required this.kgPorUnidad,
    required this.kgPorBatch,
  });

  final int id;
  final String nombre;
  final String categoria; // 'MATERIA_PRIMA', 'INSUMOS', 'EMPAQUES'
  final String unidad;
  final double kgPorUnidad;
  final double kgPorBatch;

  String get categoriaLabel {
    switch (categoria) {
      case 'MATERIA_PRIMA':
        return 'Harinas y Granos';
      case 'INSUMOS':
        return 'Insumos y Grasas';
      case 'EMPAQUES':
        return 'Material de Empaque';
      default:
        return 'General';
    }
  }

  Map<String, dynamic> toMap() => {
    'id_insumo': id.toString(),
    'id_num': id,
    'nombre': nombre,
    'categoria': categoria,
    'unidad': unidad,
    'kg_por_unidad': kgPorUnidad,
    'kg_por_batch': kgPorBatch,
  };

  factory InsumoItem.fromMap(Map<String, dynamic> map) => InsumoItem(
    id: map['id_num'] is int
        ? map['id_num']
        : int.tryParse('${map['id_insumo'] ?? map['id']}') ?? 0,
    nombre: '${map['nombre'] ?? map['nombre_producto'] ?? ''}',
    categoria: '${map['categoria'] ?? 'MATERIA_PRIMA'}',
    unidad: '${map['unidad'] ?? map['unidad_medida'] ?? 'Unidades'}',
    kgPorUnidad: (map['kg_por_unidad'] is num)
        ? (map['kg_por_unidad'] as num).toDouble()
        : double.tryParse('${map['kg_por_unidad']}') ?? 1.0,
    kgPorBatch: (map['kg_por_batch'] is num)
        ? (map['kg_por_batch'] as num).toDouble()
        : double.tryParse('${map['kg_por_batch']}') ?? 1.0,
  );
}

/// Lote Físico en Planta (100% Numérico)
class LoteItem {
  LoteItem({
    required this.id,
    required this.prodId,
    required this.nroLote,
    required this.fIngreso,
    required this.fVence,
    required this.saldo,
  });

  final String id;
  final int prodId;
  final String nroLote;
  final String fIngreso; // YYYY-MM-DD
  final String fVence;   // YYYY-MM-DD
  double saldo;

  Map<String, dynamic> toMap() => {
    'id_lote': id,
    'prod_id': prodId,
    'nro_lote': nroLote,
    'f_ingreso': fIngreso,
    'f_vence': fVence,
    'saldo': saldo,
  };

  factory LoteItem.fromMap(Map<String, dynamic> map) => LoteItem(
    id: '${map['id_lote'] ?? map['id'] ?? ''}',
    prodId: map['prod_id'] is int
        ? map['prod_id']
        : int.tryParse('${map['prod_id']}') ?? 0,
    nroLote: '${map['nro_lote'] ?? map['numero_lote'] ?? ''}',
    fIngreso: '${map['f_ingreso'] ?? map['fecha_ingreso'] ?? ''}',
    fVence: '${map['f_vence'] ?? map['fecha_vencimiento'] ?? ''}',
    saldo: (map['saldo'] is num)
        ? (map['saldo'] as num).toDouble()
        : double.tryParse('${map['saldo']}') ?? 0.0,
  );
}

/// Movimiento de Almacén (Trazabilidad y Kardex)
class MovimientoItem {
  const MovimientoItem({
    required this.id,
    required this.fechaHora,
    required this.tipo,
    required this.prodId,
    required this.prod,
    required this.lote,
    required this.cant,
    required this.unidad,
    required this.operario,
    required this.destino,
    this.jornadaId,
    this.guia,
    this.proveedor,
  });

  final String id;
  final String fechaHora; // DD/MM/YYYY HH:mm o YYYY-MM-DD HH:mm
  final String tipo; // 'ENTRADA' | 'SALIDA'
  final int prodId;
  final String prod;
  final String lote;
  final double cant;
  final String unidad;
  final String operario;
  final String destino;
  final String? jornadaId;
  final String? guia;
  final String? proveedor;

  bool get esEntrada => tipo.toUpperCase() == 'ENTRADA';

  Map<String, dynamic> toMap() => {
    'id_movimiento': id,
    'fecha_hora': fechaHora,
    'tipo': tipo,
    'prod_id': prodId,
    'prod': prod,
    'lote': lote,
    'cant': cant,
    'unidad': unidad,
    'operario': operario,
    'destino': destino,
    'jornada_id': jornadaId,
    'guia': guia,
    'proveedor': proveedor,
  };

  factory MovimientoItem.fromMap(Map<String, dynamic> map) => MovimientoItem(
    id: '${map['id_movimiento'] ?? map['id'] ?? ''}',
    fechaHora: '${map['fecha_hora'] ?? map['fechaHora'] ?? ''}',
    tipo: '${map['tipo'] ?? 'SALIDA'}',
    prodId: map['prod_id'] is int
        ? map['prod_id']
        : int.tryParse('${map['prod_id']}') ?? 0,
    prod: '${map['prod'] ?? map['nombre_producto'] ?? ''}',
    lote: '${map['lote'] ?? map['numero_lote'] ?? ''}',
    cant: (map['cant'] is num)
        ? (map['cant'] as num).toDouble()
        : double.tryParse('${map['cant']}') ?? 0.0,
    unidad: '${map['unidad'] ?? ''}',
    operario: '${map['operario'] ?? ''}',
    destino: '${map['destino'] ?? ''}',
    jornadaId: map['jornada_id'] != null ? '${map['jornada_id']}' : null,
    guia: map['guia'] != null ? '${map['guia']}' : null,
    proveedor: map['proveedor'] != null ? '${map['proveedor']}' : null,
  );
}

/// Cálculo de Cobertura de Turno según Balance de Materia
class CoberturaTurno {
  const CoberturaTurno({
    required this.stockUnidades,
    required this.stockKg,
    required this.kgNecesariosTurno,
    required this.unidadesNecesariasTurno,
    required this.batchesPosibles,
    required this.turnosRinde,
    required this.esAlertaRoja,
    required this.faltaParaTurnoUnidades,
  });

  final double stockUnidades;
  final double stockKg;
  final double kgNecesariosTurno;
  final int unidadesNecesariasTurno;
  final int batchesPosibles;
  final double turnosRinde;
  final bool esAlertaRoja;
  final int faltaParaTurnoUnidades;
}
