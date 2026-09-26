class ProductionLote {
  const ProductionLote({
    required this.idProducto,
    required this.numero,
    required this.producto,
    this.presentacion = '30 g',
    this.fVencimiento = '',
    required this.cantidad,
  });

  final String idProducto;
  final String numero;
  final String producto;
  final String presentacion;
  final String fVencimiento;
  final int cantidad;

  Map<String, dynamic> toMap() => {
    'id_producto': idProducto,
    'numero_lote': numero,
    'producto': producto,
    'presentacion': presentacion,
    'f_vencimiento': fVencimiento,
    'cantidad': cantidad,
  };

  factory ProductionLote.fromMap(Map<String, dynamic> map) => ProductionLote(
    idProducto: (map['id_producto'] ?? '') as String,
    numero: (map['numero'] ?? map['numero_lote'] ?? '') as String,
    producto: (map['producto'] ?? map['nombre_producto'] ?? 'Producto') as String,
    presentacion: (map['presentacion'] ?? '30 g') as String,
    fVencimiento: (map['f_vencimiento'] ?? '') as String,
    cantidad: (map['cantidad'] is num) ? (map['cantidad'] as num).toInt() : int.tryParse('${map['cantidad']}') ?? 0,
  );
}

class BobinaDetalle {
  const BobinaDetalle({
    required this.num,
    required this.bruto,
    required this.neto,
    this.tuco = 0.3,
  });

  final int num;
  final double bruto;
  final double neto;
  final double tuco;

  Map<String, dynamic> toMap() => {
    'numero_bobina': num,
    'peso_bruto': bruto,
    'peso_neto': neto,
    'tuco_envoltorio': tuco,
  };

  factory BobinaDetalle.fromMap(Map<String, dynamic> map) {
    final b = map['bruto'] ?? map['peso_bruto'];
    final n = map['neto'] ?? map['peso_neto'];
    final t = map['tuco'] ?? map['tuco_envoltorio'];
    return BobinaDetalle(
      num: int.tryParse('${map['num'] ?? map['numero_bobina']}') ?? 1,
      bruto: b is double ? b : double.tryParse('$b') ?? 0.0,
      neto: n is double ? n : double.tryParse('$n') ?? 0.0,
      tuco: t is double ? t : double.tryParse('$t') ?? 0.3,
    );
  }
}

class ProductionRun {
  const ProductionRun({
    required this.id,
    required this.fecha,
    required this.turno,
    required this.tipo,
    required this.supervisor,
    this.horaInicio = '07:30',
    this.cantBatch = 0.0,
    this.mermaTotal = 0.0,
    this.rendimiento = 0.0,
    this.observaciones = '',
    this.mermasDetalle = const {},
    this.lotes = const [],
    this.bobinas = 0,
    this.bobinasDetalle = const [],
    // Campos específicos para Galletas
    this.cantExtruidoTolva = 0.0,
    // Campos específicos para Barras
    this.batchJarabe = 0.0,
    this.cantTinas = 0,
    this.sacosExtruidoTolva = 0.0,
    this.popQuinua = 0.0,
    this.popKiwicha = 0.0,
    this.cajasPasas = 0.0,
    this.cintaEmbalaje = 0,
    this.tampon = 0,
  });

  final String id;
  final String fecha;
  final String turno; // 'Dia' | 'Noche'
  final String tipo; // 'Galletas' | 'Barras'
  final String supervisor;
  final String horaInicio;
  final double cantBatch;
  final double mermaTotal;
  final double rendimiento;
  final String observaciones;
  final Map<String, double> mermasDetalle;
  final List<ProductionLote> lotes;
  final int bobinas;
  final List<BobinaDetalle> bobinasDetalle;

  final double cantExtruidoTolva;
  final double batchJarabe;
  final int cantTinas;
  final double sacosExtruidoTolva;
  final double popQuinua;
  final double popKiwicha;
  final double cajasPasas;
  final int cintaEmbalaje;
  final int tampon;

  int get totalCajas => lotes.fold<int>(0, (s, l) => s + l.cantidad);
  double get totalInsumosKg => cantBatch * 76.25;

  ProductionRun copyWith({
    String? id,
    String? fecha,
    String? turno,
    String? tipo,
    String? supervisor,
    String? horaInicio,
    double? cantBatch,
    double? mermaTotal,
    double? rendimiento,
    String? observaciones,
    Map<String, double>? mermasDetalle,
    List<ProductionLote>? lotes,
    int? bobinas,
    List<BobinaDetalle>? bobinasDetalle,
    double? cantExtruidoTolva,
    double? batchJarabe,
    int? cantTinas,
    double? sacosExtruidoTolva,
    double? popQuinua,
    double? popKiwicha,
    double? cajasPasas,
    int? cintaEmbalaje,
    int? tampon,
  }) => ProductionRun(
    id: id ?? this.id,
    fecha: fecha ?? this.fecha,
    turno: turno ?? this.turno,
    tipo: tipo ?? this.tipo,
    supervisor: supervisor ?? this.supervisor,
    horaInicio: horaInicio ?? this.horaInicio,
    cantBatch: cantBatch ?? this.cantBatch,
    mermaTotal: mermaTotal ?? this.mermaTotal,
    rendimiento: rendimiento ?? this.rendimiento,
    observaciones: observaciones ?? this.observaciones,
    mermasDetalle: mermasDetalle ?? this.mermasDetalle,
    lotes: lotes ?? this.lotes,
    bobinas: bobinas ?? this.bobinas,
    bobinasDetalle: bobinasDetalle ?? this.bobinasDetalle,
    cantExtruidoTolva: cantExtruidoTolva ?? this.cantExtruidoTolva,
    batchJarabe: batchJarabe ?? this.batchJarabe,
    cantTinas: cantTinas ?? this.cantTinas,
    sacosExtruidoTolva: sacosExtruidoTolva ?? this.sacosExtruidoTolva,
    popQuinua: popQuinua ?? this.popQuinua,
    popKiwicha: popKiwicha ?? this.popKiwicha,
    cajasPasas: cajasPasas ?? this.cajasPasas,
    cintaEmbalaje: cintaEmbalaje ?? this.cintaEmbalaje,
    tampon: tampon ?? this.tampon,
  );
}
