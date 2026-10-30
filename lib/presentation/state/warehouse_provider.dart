/// ==============================================================================
/// SISTEMA INTEGRADO DE CONTROL DE PLANTA - PROCESOS M&D
/// ------------------------------------------------------------------------------
/// AUTOR: Delfín Estanis Roque Mullisaca (DERM)
/// AFILIACIÓN: Escuela Profesional de Ingeniería de Software y Sistemas - UNAJ
/// EXPEDIENTE: Registro de Soporte Lógico (Software) - INDECOPI
/// ==============================================================================

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
    final now = DateTime.now();
    final todayStr = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final s = _store;
    final insumos = (s?.rows('almacen_insumos') ?? []).map(InsumoItem.fromMap).toList();
    final lotes = (s?.rows('almacen_lotes') ?? []).map(LoteItem.fromMap).toList();
    final movimientos = (s?.rows('almacen_movimientos') ?? []).map(MovimientoItem.fromMap).toList();

    return WarehouseState(
      insumos: insumos,
      lotes: lotes,
      movimientos: movimientos,
      fechaOperativa: todayStr,
      batchesPorTurno: 20,
      categoriaActiva: 'TODOS',
      textoBusqueda: '',
      soloRojas: false,
    );
  }

  void refreshData() {
    final s = _store;
    if (s == null) return;
    final insumos = s.rows('almacen_insumos').map(InsumoItem.fromMap).toList();
    final lotes = s.rows('almacen_lotes').map(LoteItem.fromMap).toList();
    final movimientos = s.rows('almacen_movimientos').map(MovimientoItem.fromMap).toList();
    state = state.copyWith(insumos: insumos, lotes: lotes, movimientos: movimientos);
  }

  void setFechaOperativa(String f) {
    state = state.copyWith(fechaOperativa: f);
  }

  void setBatchesPorTurno(int b) {
    state = state.copyWith(batchesPorTurno: b);
  }

  void setCategoria(String cat) {
    state = state.copyWith(categoriaActiva: cat, soloRojas: false);
  }

  void setBusqueda(String q) {
    state = state.copyWith(textoBusqueda: q);
  }

  void toggleSoloRojas() {
    state = state.copyWith(soloRojas: !state.soloRojas);
  }

  List<LoteItem> getLotesPeps(int prodId) {
    final list = state.lotes.where((l) => l.prodId == prodId && l.saldo > 0).toList();
    list.sort((a, b) {
      final compVence = a.fVence.compareTo(b.fVence);
      if (compVence != 0) return compVence;
      return a.fIngreso.compareTo(b.fIngreso);
    });
    return list;
  }

  CoberturaTurno calcularCobertura(InsumoItem insumo, [int? batches]) {
    final b = batches ?? state.batchesPorTurno;
    final lotes = getLotesPeps(insumo.id);
    final stockUnidades = lotes.fold<double>(0.0, (acc, l) => acc + l.saldo);
    final stockKg = stockUnidades * insumo.kgPorUnidad;

    final kgNecesariosTurno = insumo.kgPorBatch * b;
    final unidadesNecesariasTurno = (kgNecesariosTurno / insumo.kgPorUnidad).ceil();

    final batchesPosibles = insumo.kgPorBatch > 0 ? (stockKg / insumo.kgPorBatch).floor() : 0;
    final turnosRinde = kgNecesariosTurno > 0 ? double.parse((stockKg / kgNecesariosTurno).toStringAsFixed(1)) : 99.0;

    final esAlertaRoja = stockKg < kgNecesariosTurno;
    final faltaParaTurnoKg = max(0.0, kgNecesariosTurno - stockKg);
    final faltaParaTurnoUnidades = (faltaParaTurnoKg / insumo.kgPorUnidad).ceil();

    return CoberturaTurno(
      stockUnidades: stockUnidades,
      stockKg: stockKg,
      kgNecesariosTurno: kgNecesariosTurno,
      unidadesNecesariasTurno: unidadesNecesariasTurno,
      batchesPosibles: batchesPosibles,
      turnosRinde: turnosRinde,
      esAlertaRoja: esAlertaRoja,
      faltaParaTurnoUnidades: faltaParaTurnoUnidades,
    );
  }

  int get countRojas {
    int total = 0;
    for (final ins in state.insumos) {
      if (calcularCobertura(ins).esAlertaRoja) total++;
    }
    return total;
  }

  List<String> get nombresRojos {
    final list = <String>[];
    for (final ins in state.insumos) {
      if (calcularCobertura(ins).esAlertaRoja) list.add(ins.nombre);
    }
    return list;
  }

  /// Registrar Entrada (Nuevo Ingreso)
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
  }) async {
    final store = _store;
    if (store == null) throw StateError('Base de datos no inicializada');

    final ins = state.insumos.firstWhere((i) => i.id == prodId);
    final idLote = 'lot-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999)}';
    final idMov = 'mov-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999)}';

    final nuevoLote = LoteItem(
      id: idLote,
      prodId: prodId,
      nroLote: nroLote,
      fIngreso: fIngreso,
      fVence: fVence,
      saldo: cant,
    );

    final nuevoMov = MovimientoItem(
      id: idMov,
      fechaHora: '$fIngreso 10:00',
      tipo: 'ENTRADA',
      prodId: prodId,
      prod: ins.nombre,
      lote: nroLote,
      cant: cant,
      unidad: ins.unidad.split(' ').first,
      operario: responsable,
      destino: destino,
      jornadaId: null,
      guia: guia,
      proveedor: proveedor,
    );

    await store.saveBatch([
      ('almacen_lotes', nuevoLote.toMap()),
      ('almacen_movimientos', nuevoMov.toMap()),
    ]);

    refreshData();
    return nuevoMov;
  }

  /// Registrar Salida PEPS (Despacho a Turno)
  Future<List<MovimientoItem>> registrarSalidaPeps({
    required int prodId,
    required double cant,
    required String fSalida,
    required String destino,
    required String operario,
    String? jornadaId,
  }) async {
    final store = _store;
    if (store == null) throw StateError('Base de datos no inicializada');

    final ins = state.insumos.firstWhere((i) => i.id == prodId);
    final lotes = getLotesPeps(prodId);

    double restante = cant;
    final changes = <(String, RowData)>[];
    final generados = <MovimientoItem>[];

    for (final l in lotes) {
      if (restante <= 0) break;
      final aSacar = min(l.saldo, restante);
      l.saldo -= aSacar;
      restante -= aSacar;

      final idMov = 'mov-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9999)}';
      final mov = MovimientoItem(
        id: idMov,
        fechaHora: '$fSalida 11:30',
        tipo: 'SALIDA',
        prodId: prodId,
        prod: ins.nombre,
        lote: l.nroLote,
        cant: aSacar,
        unidad: ins.unidad.split(' ').first,
        operario: operario,
        destino: destino,
        jornadaId: jornadaId,
        guia: null,
        proveedor: null,
      );

      changes.add(('almacen_lotes', l.toMap()));
      changes.add(('almacen_movimientos', mov.toMap()));
      generados.add(mov);
    }

    if (changes.isNotEmpty) {
      await store.saveBatch(changes);
      refreshData();
    }

    return generados;
  }

  /// Despacho automático de insumos requeridos por una Jornada diaria de producción (PEPS)
  Future<List<MovimientoItem>> despacharInsumosPorJornada({
    required Production jornada,
    required String operario,
  }) async {
    final store = _store;
    if (store == null) throw StateError('Base de datos no inicializada');

    final batches = max(1, (number(jornada.row['cant_batch']) > 0
        ? number(jornada.row['cant_batch']).toInt()
        : 16));

    final cambios = <(String, RowData)>[];
    final movimientosGenerados = <MovimientoItem>[];
    final fSalida = jornada.row['fecha'] ?? state.fechaOperativa;
    final destino = jornada.isCookies ? 'Línea Galletas - Horno Túnel' : 'Línea Barras - Marmita';

    for (final ins in state.insumos) {
      final kgReq = ins.kgPorBatch * batches;
      final cantUnidades = (kgReq / ins.kgPorUnitOrOne(ins.kgPorUnidad)).ceilToDouble();
      if (cantUnidades <= 0) continue;

      final lotes = getLotesPeps(ins.id);
      double restante = cantUnidades;

      for (final l in lotes) {
        if (restante <= 0) break;
        final aSacar = min(l.saldo, restante);
        l.saldo -= aSacar;
        restante -= aSacar;

        final idMov = 'mov-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(99999)}';
        final mov = MovimientoItem(
          id: idMov,
          fechaHora: '$fSalida 08:30',
          tipo: 'SALIDA',
          prodId: ins.id,
          prod: ins.nombre,
          lote: l.nroLote,
          cant: aSacar,
          unidad: ins.unidad.split(' ').first,
          operario: operario,
          destino: destino,
          jornadaId: jornada.id,
          guia: null,
          proveedor: null,
        );

        cambios.add(('almacen_lotes', l.toMap()));
        cambios.add(('almacen_movimientos', mov.toMap()));
        movimientosGenerados.add(mov);
      }
    }

    if (cambios.isNotEmpty) {
      await store.saveBatch(cambios);
      refreshData();
    }

    return movimientosGenerados;
  }
}

extension InsumoHelper on InsumoItem {
  double kgPorUnitOrOne(double val) => val > 0 ? val : 1.0;
}
