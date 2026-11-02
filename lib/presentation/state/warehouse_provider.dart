import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/app_store.dart';
import '../../core/domain/production.dart';
import '../../domain/models/warehouse_model.dart';
import 'personnel_provider.dart';

class WarehouseState {
  const WarehouseState({
    required this.insumos,
    required this.lotes,
    required this.movimientos,
    required this.fechaOperativa,
    required this.batchesPorTurno,
    required this.categoriaActiva,
    required this.textoBusqueda,
    required this.soloRojas,
  });

  final List<InsumoItem> insumos;
  final List<LoteItem> lotes;
  final List<MovimientoItem> movimientos;
  final String fechaOperativa;
  final int batchesPorTurno;
  final String categoriaActiva;
  final String textoBusqueda;
  final bool soloRojas;

  WarehouseState copyWith({
    List<InsumoItem>? insumos,
    List<LoteItem>? lotes,
    List<MovimientoItem>? movimientos,
    String? fechaOperativa,
    int? batchesPorTurno,
    String? categoriaActiva,
    String? textoBusqueda,
    bool? soloRojas,
  }) => WarehouseState(
    insumos: insumos ?? this.insumos,
    lotes: lotes ?? this.lotes,
    movimientos: movimientos ?? this.movimientos,
    fechaOperativa: fechaOperativa ?? this.fechaOperativa,
    batchesPorTurno: batchesPorTurno ?? this.batchesPorTurno,
    categoriaActiva: categoriaActiva ?? this.categoriaActiva,
    textoBusqueda: textoBusqueda ?? this.textoBusqueda,
    soloRojas: soloRojas ?? this.soloRojas,
  );
}

final warehouseProvider = NotifierProvider<WarehouseNotifier, WarehouseState>(
  WarehouseNotifier.new,
);

class WarehouseNotifier extends Notifier<WarehouseState> {
  AppStore? get _store => ref.watch(appStoreProvider);

  @override
  WarehouseState build() {
    final dermNow = DateTime.now();
    final dermFechaHoy = '${dermNow.year.toString().padLeft(4, '0')}-${dermNow.month.toString().padLeft(2, '0')}-${dermNow.day.toString().padLeft(2, '0')}';

    final dermStore = _store;
    final dermInsumos = (dermStore?.rows('almacen_insumos') ?? []).map(InsumoItem.fromMap).toList();
    final dermLotes = (dermStore?.rows('almacen_lotes') ?? []).map(LoteItem.fromMap).toList();
    final dermMovs = (dermStore?.rows('almacen_movimientos') ?? []).map(MovimientoItem.fromMap).toList();

    return WarehouseState(
      insumos: dermInsumos,
      lotes: dermLotes,
      movimientos: dermMovs,
      fechaOperativa: dermFechaHoy,
      batchesPorTurno: 20,
      categoriaActiva: 'TODOS',
      textoBusqueda: '',
      soloRojas: false,
    );
  }

  void dermRefrescarDatos() {
    final dermStore = _store;
    if (dermStore == null) return;
    final dermInsumos = dermStore.rows('almacen_insumos').map(InsumoItem.fromMap).toList();
    final dermLotes = dermStore.rows('almacen_lotes').map(LoteItem.fromMap).toList();
    final dermMovs = dermStore.rows('almacen_movimientos').map(MovimientoItem.fromMap).toList();
    state = state.copyWith(insumos: dermInsumos, lotes: dermLotes, movimientos: dermMovs);
  }

  void refreshData() => dermRefrescarDatos();

  void setFechaOperativa(String dermFecha) {
    state = state.copyWith(fechaOperativa: dermFecha);
  }

  void setBatchesPorTurno(int dermBatches) {
    state = state.copyWith(batchesPorTurno: dermBatches);
  }

  void setCategoria(String dermCat) {
    state = state.copyWith(categoriaActiva: dermCat, soloRojas: false);
  }

  void setBusqueda(String dermQuery) {
    state = state.copyWith(textoBusqueda: dermQuery);
  }

  void toggleSoloRojas() {
    state = state.copyWith(soloRojas: !state.soloRojas);
  }

  List<LoteItem> dermObtenerLotesPeps(int dermProdId) {
    final dermLista = state.lotes.where((l) => l.prodId == dermProdId && l.saldo > 0).toList();
    dermLista.sort((a, b) {
      final dermCompVence = a.fVence.compareTo(b.fVence);
      if (dermCompVence != 0) return dermCompVence;
      return a.fIngreso.compareTo(b.fIngreso);
    });
    return dermLista;
  }

  List<LoteItem> getLotesPeps(int prodId) => dermObtenerLotesPeps(prodId);

  CoberturaTurno dermCalcularCobertura(InsumoItem dermInsumo, [int? dermBatches]) {
    final dermB = dermBatches ?? state.batchesPorTurno;
    final dermLotes = dermObtenerLotesPeps(dermInsumo.id);
    final dermStockUnidades = dermLotes.fold<double>(0.0, (acc, l) => acc + l.saldo);
    final dermStockKg = dermStockUnidades * dermInsumo.kgPorUnidad;

    final dermKgTurno = dermInsumo.kgPorBatch * dermB;
    final dermUnidadesTurno = (dermKgTurno / dermInsumo.kgPorUnidad).ceil();

    final dermBatchesPosibles = dermInsumo.kgPorBatch > 0 ? (dermStockKg / dermInsumo.kgPorBatch).floor() : 0;
    final dermTurnosRinde = dermKgTurno > 0 ? double.parse((dermStockKg / dermKgTurno).toStringAsFixed(1)) : 99.0;

    final dermAlertaRoja = dermStockKg < dermKgTurno;
    final dermFaltaKg = max(0.0, dermKgTurno - dermStockKg);
    final dermFaltaUnidades = (dermFaltaKg / dermInsumo.kgPorUnidad).ceil();

    return CoberturaTurno(
      stockUnidades: dermStockUnidades,
      stockKg: dermStockKg,
      kgNecesariosTurno: dermKgTurno,
      unidadesNecesariasTurno: dermUnidadesTurno,
      batchesPosibles: dermBatchesPosibles,
      turnosRinde: dermTurnosRinde,
      esAlertaRoja: dermAlertaRoja,
      faltaParaTurnoUnidades: dermFaltaUnidades,
    );
  }

  CoberturaTurno calcularCobertura(InsumoItem insumo, [int? batches]) => dermCalcularCobertura(insumo, batches);

  int get countRojas {
    int dermTotal = 0;
    for (final dermIns in state.insumos) {
      if (dermCalcularCobertura(dermIns).esAlertaRoja) dermTotal++;
    }
    return dermTotal;
  }

  List<String> get nombresRojos {
    final dermList = <String>[];
    for (final dermIns in state.insumos) {
      if (dermCalcularCobertura(dermIns).esAlertaRoja) dermList.add(dermIns.nombre);
    }
    return dermList;
  }

  Future<MovimientoItem> dermRegistrarEntrada({
    required int prodId,
    required double cant,
    required String nroLote,
    required String fIngreso,
    required String fVence,
    required String proveedor,
    required String guia,
    required String responsable,
    String destino = 'Almacén Central',
  }) async {
    final dermStore = _store;
    if (dermStore == null) throw StateError('Base de datos no inicializada');

    final dermIns = state.insumos.firstWhere((i) => i.id == prodId);
    final dermIdLote = 'lot-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999)}';
    final dermIdMov = 'mov-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999)}';

    final dermNuevoLote = LoteItem(
      id: dermIdLote,
      prodId: prodId,
      nroLote: nroLote,
      fIngreso: fIngreso,
      fVence: fVence,
      saldo: cant,
    );

    final dermNuevoMov = MovimientoItem(
      id: dermIdMov,
      fechaHora: '$fIngreso 10:00',
      tipo: 'ENTRADA',
      prodId: prodId,
      prod: dermIns.nombre,
      lote: nroLote,
      cant: cant,
      unidad: dermIns.unidad.split(' ').first,
      operario: responsable,
      destino: destino,
      jornadaId: null,
      guia: guia,
      proveedor: proveedor,
    );

    await dermStore.saveBatch([
      ('almacen_lotes', dermNuevoLote.toMap()),
      ('almacen_movimientos', dermNuevoMov.toMap()),
    ]);

    dermRefrescarDatos();
    return dermNuevoMov;
  }

  Future<MovimientoItem> registrarEntrada({
    required int prodId,
    required double cant,
    required String nroLote,
    required String fIngreso,
    required String fVence,
    required String proveedor,
    required String guia,
    required String responsable,
    String destino = 'Almacén Central',
  }) {
    return dermRegistrarEntrada(
      prodId: prodId,
      cant: cant,
      nroLote: nroLote,
      fIngreso: fIngreso,
      fVence: fVence,
      proveedor: proveedor,
      guia: guia,
      responsable: responsable,
      destino: destino,
    );
  }

  Future<List<MovimientoItem>> dermRegistrarSalidaPeps({
    required int prodId,
    required double cant,
    required String fSalida,
    required String destino,
    required String operario,
    String? jornadaId,
  }) async {
    final dermStore = _store;
    if (dermStore == null) throw StateError('Base de datos no inicializada');

    final dermIns = state.insumos.firstWhere((i) => i.id == prodId);
    final dermLotes = dermObtenerLotesPeps(prodId);

    double dermRestante = cant;
    final dermChanges = <(String, RowData)>[];
    final dermGenerados = <MovimientoItem>[];

    for (final dermL in dermLotes) {
      if (dermRestante <= 0) break;
      final dermASacar = min(dermL.saldo, dermRestante);
      dermL.saldo -= dermASacar;
      dermRestante -= dermASacar;

      final dermIdMov = 'mov-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9999)}';
      final dermMov = MovimientoItem(
        id: dermIdMov,
        fechaHora: '$fSalida 11:30',
        tipo: 'SALIDA',
        prodId: prodId,
        prod: dermIns.nombre,
        lote: dermL.nroLote,
        cant: dermASacar,
        unidad: dermIns.unidad.split(' ').first,
        operario: operario,
        destino: destino,
        jornadaId: jornadaId,
        guia: null,
        proveedor: null,
      );

      dermChanges.add(('almacen_lotes', dermL.toMap()));
      dermChanges.add(('almacen_movimientos', dermMov.toMap()));
      dermGenerados.add(dermMov);
    }

    if (dermChanges.isNotEmpty) {
      await dermStore.saveBatch(dermChanges);
      dermRefrescarDatos();
    }

    return dermGenerados;
  }

  Future<List<MovimientoItem>> registrarSalidaPeps({
    required int prodId,
    required double cant,
    required String fSalida,
    required String destino,
    required String operario,
    String? jornadaId,
  }) {
    return dermRegistrarSalidaPeps(
      prodId: prodId,
      cant: cant,
      fSalida: fSalida,
      destino: destino,
      operario: operario,
      jornadaId: jornadaId,
    );
  }

  Future<List<MovimientoItem>> dermDespacharInsumosPorJornada({
    required Production jornada,
    required String operario,
  }) async {
    final dermStore = _store;
    if (dermStore == null) throw StateError('Base de datos no inicializada');

    final dermBatches = max(1, (number(jornada.row['cant_batch']) > 0
        ? number(jornada.row['cant_batch']).toInt()
        : 16));

    final dermCambios = <(String, RowData)>[];
    final dermMovsGenerados = <MovimientoItem>[];
    final dermFSalida = jornada.row['fecha'] ?? state.fechaOperativa;
    final dermDestino = jornada.isCookies ? 'Línea Galletas - Horno Túnel' : 'Línea Barras - Marmita';

    for (final dermIns in state.insumos) {
      final dermKgReq = dermIns.kgPorBatch * dermBatches;
      final dermCantUnidades = (dermKgReq / dermIns.kgPorUnitOrOne(dermIns.kgPorUnidad)).ceilToDouble();
      if (dermCantUnidades <= 0) continue;

      final dermLotes = dermObtenerLotesPeps(dermIns.id);
      double dermRestante = dermCantUnidades;

      for (final dermL in dermLotes) {
        if (dermRestante <= 0) break;
        final dermASacar = min(dermL.saldo, dermRestante);
        dermL.saldo -= dermASacar;
        dermRestante -= dermASacar;

        final dermIdMov = 'mov-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(99999)}';
        final dermMov = MovimientoItem(
          id: dermIdMov,
          fechaHora: '$dermFSalida 08:30',
          tipo: 'SALIDA',
          prodId: dermIns.id,
          prod: dermIns.nombre,
          lote: dermL.nroLote,
          cant: dermASacar,
          unidad: dermIns.unidad.split(' ').first,
          operario: operario,
          destino: dermDestino,
          jornadaId: jornada.id,
          guia: null,
          proveedor: null,
        );

        dermCambios.add(('almacen_lotes', dermL.toMap()));
        dermCambios.add(('almacen_movimientos', dermMov.toMap()));
        dermMovsGenerados.add(dermMov);
      }
    }

    if (dermCambios.isNotEmpty) {
      await dermStore.saveBatch(dermCambios);
      dermRefrescarDatos();
    }

    return dermMovsGenerados;
  }

  Future<List<MovimientoItem>> despacharInsumosPorJornada({
    required Production jornada,
    required String operario,
  }) {
    return dermDespacharInsumosPorJornada(
      jornada: jornada,
      operario: operario,
    );
  }
}
