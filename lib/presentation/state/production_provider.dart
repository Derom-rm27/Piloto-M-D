import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/app_store.dart';
import '../../core/domain/production.dart';
import '../../domain/models/production_run.dart';
import '../../domain/usecases/production_metrics.dart';
import 'personnel_provider.dart';

class ProductionState {
  const ProductionState({
    required this.runs,
    this.selectedRunFilterId = 'all',
  });

  final List<ProductionRun> runs;
  final String selectedRunFilterId;

  DashboardMetrics get metrics => ProductionMetricsCalculator.calculate(
    runs,
    selectedRunId: selectedRunFilterId,
  );

  ProductionState copyWith({
    List<ProductionRun>? runs,
    String? selectedRunFilterId,
  }) => ProductionState(
    runs: runs ?? this.runs,
    selectedRunFilterId: selectedRunFilterId ?? this.selectedRunFilterId,
  );
}

class ProductionNotifier extends StateNotifier<ProductionState> {
  ProductionNotifier(this._ref) : super(ProductionState(runs: _seedRuns)) {
    reloadFromStore();
  }

  final Ref _ref;

  void setFilter(String filterId) {
    state = state.copyWith(selectedRunFilterId: filterId);
  }

  void reloadFromStore() {
    final store = _ref.read(appStoreProvider);
    if (store == null) return;
    final rows = store.rows('jornadas_produccion');
    if (rows.isNotEmpty) {
      final loaded = rows.map((r) => _fromProduction(Production(store, r))).toList();
      loaded.sort((a, b) => b.fecha.compareTo(a.fecha));
      state = state.copyWith(runs: loaded);
    }
  }

  Future<void> deleteRun(String id) async {
    state = state.copyWith(runs: state.runs.where((r) => r.id != id).toList());
    final store = _ref.read(appStoreProvider);
    if (store != null) {
      final nowUtc = DateTime.now().toUtc().toIso8601String();
      final jRow = store.find('jornadas_produccion', id);
      if (jRow != null) {
        final toSave = <(String, RowData)>[
          ('jornadas_produccion', {...jRow, 'deleted_at': nowUtc}),
        ];
        for (final l in store.rows('lotes_produccion').where((x) => x['id_jornada'] == id)) {
          toSave.add(('lotes_produccion', {...l, 'deleted_at': nowUtc}));
        }
        for (final b in store.rows('bobinas_produccion').where((x) => x['id_jornada'] == id)) {
          toSave.add(('bobinas_produccion', {...b, 'deleted_at': nowUtc}));
        }
        await store.saveBatch(toSave);
      }
    }
  }

  static ProductionRun _fromProduction(Production p) {
    final row = p.row;
    final supervisorName = p.supervisor.trim().isNotEmpty
        ? p.supervisor.trim()
        : (row['supervisor']?.toString() ?? 'Supervisor de Planta');

    final lotesList = p.lots.map((l) {
      return ProductionLote(
        idProducto: (l['id_producto'] ?? '').toString(),
        numero: (l['numero_lote'] ?? '').toString(),
        producto: p.product(l),
        presentacion: (l['presentacion'] ?? '30 g').toString(),
        fVencimiento: (l['f_vencimiento'] ?? '').toString(),
        cantidad: number(l['cantidad']).toInt(),
      );
    }).toList();

    final bobinasList = p.reels.map((b) {
      return BobinaDetalle(
        num: number(b['numero_bobina']).toInt(),
        bruto: number(b['peso_bruto']),
        neto: number(b['peso_neto']),
        tuco: number(b['tuco_envoltorio'] ?? 0.3),
      );
    }).toList();

    final mermasDetalle = <String, double>{};
    if (p.isCookies) {
      if (number(row['merma_piso_crudo']) > 0) mermasDetalle['piso_crudo'] = number(row['merma_piso_crudo']);
      if (number(row['merma_maquina']) > 0) mermasDetalle['maquina'] = number(row['merma_maquina']);
      if (number(row['quemados']) > 0) mermasDetalle['quemados'] = number(row['quemados']);
      final caja = number(row['caja_blanco_rotos'] ?? row['caja']);
      if (caja > 0) mermasDetalle['caja_blanco_rotos'] = caja;
      if (number(row['merma_piso_cocido']) > 0) mermasDetalle['piso_cocido'] = number(row['merma_piso_cocido']);
      if (number(row['merma_bobinas']) > 0) mermasDetalle['bobinas'] = number(row['merma_bobinas']);
    } else {
      if (number(row['merma_bobinas']) > 0) mermasDetalle['bobinas'] = number(row['merma_bobinas']);
      if (number(row['merma_piso']) > 0) mermasDetalle['piso'] = number(row['merma_piso']);
      if (number(row['merma_maquina']) > 0) mermasDetalle['maquina'] = number(row['merma_maquina']);
    }

    final double yieldVal = p.yieldPercent ?? (number(row['rendimiento']) > 0 ? number(row['rendimiento']) : 95.0);

    return ProductionRun(
      id: p.id,
      fecha: '${row['fecha'] ?? ''}',
      turno: '${row['turno'] ?? 'Dia'}',
      tipo: '${row['tipo'] ?? 'Galletas'}',
      supervisor: supervisorName,
      horaInicio: '${row['hora_inicio_envasado'] ?? '07:30'}',
      cantBatch: number(row['cant_batch']),
      mermaTotal: p.waste > 0 ? double.parse(p.waste.toStringAsFixed(1)) : number(row['merma_total']),
      rendimiento: double.parse(yieldVal.toStringAsFixed(1)),
      observaciones: '${row['observaciones'] ?? ''}',
      mermasDetalle: mermasDetalle,
      lotes: lotesList,
      bobinas: bobinasList.length,
      bobinasDetalle: bobinasList,
      cantExtruidoTolva: number(row['cant_extruido_tolva']),
      batchJarabe: number(row['batch_jarabe']),
      cantTinas: number(row['cant_tinas']).toInt(),
      sacosExtruidoTolva: number(row['cant_extruido_tolva']),
      popQuinua: number(row['pop_quinua']),
      popKiwicha: number(row['pop_kiwicha']),
      cajasPasas: number(row['cajas_pasas']),
      cintaEmbalaje: number(row['cinta_embalaje']).toInt(),
      tampon: number(row['tampon']).toInt(),
    );
  }

  Future<void> addRun(ProductionRun newRun) async {
    final updated = [newRun, ...state.runs];
    state = state.copyWith(runs: updated);

    final store = _ref.read(appStoreProvider);
    if (store != null) {
      await store.save('jornadas_produccion', {
        'id_jornada': newRun.id,
        'fecha': newRun.fecha,
        'turno': newRun.turno,
        'tipo': newRun.tipo,
        'cant_batch': newRun.cantBatch,
        'merma_total': newRun.mermaTotal,
        'observaciones': newRun.observaciones,
      });
    }
  }

  static final List<ProductionRun> _seedRuns = [
    const ProductionRun(
      id: "7b79cfe3-3c79-5fc4-b7ab-94ba5eb42755",
      fecha: "2026-08-30",
      turno: "Dia",
      tipo: "Barras",
      supervisor: "Ing. Jhon Alex Quispe Puma",
      horaInicio: "07:30",
      cantBatch: 12.0,
      mermaTotal: 12.3,
      rendimiento: 96.2,
      batchJarabe: 12.0,
      cantTinas: 4,
      sacosExtruidoTolva: 6.0,
      popQuinua: 3.0,
      popKiwicha: 2.0,
      cajasPasas: 4.0,
      cintaEmbalaje: 2,
      tampon: 1,
      mermasDetalle: {
        'bobinas': 5.2,
        'piso': 3.1,
        'maquina': 4.0,
      },
      observaciones: "Producción de Barras conforme según dosimetría. Sin paradas de línea.",
      lotes: [
        ProductionLote(
          idProducto: "d6ed313e-533a-55a6-aa06-4c00bc132812",
          numero: "0306",
          producto: "Barra de extruidos con Kiwicha",
          presentacion: "30 g",
          fVencimiento: "2027-07-31",
          cantidad: 175,
        ),
      ],
      bobinas: 2,
      bobinasDetalle: [
        BobinaDetalle(num: 1, bruto: 14.40, neto: 14.10),
        BobinaDetalle(num: 2, bruto: 13.80, neto: 13.50),
      ],
    ),
    const ProductionRun(
      id: "8cf94dd2-803f-5494-9900-50425cf03544",
      fecha: "2026-08-29",
      turno: "Noche",
      tipo: "Galletas",
      supervisor: "Ing. Jhon Alex Quispe Puma",
      horaInicio: "19:00",
      cantBatch: 16.0,
      mermaTotal: 28.5,
      rendimiento: 96.4,
      cintaEmbalaje: 3,
      tampon: 1,
      mermasDetalle: {
        'piso_crudo': 8.5,
        'caja_blanco_rotos': 4.7,
        'piso_cocido': 6.8,
        'bobinas': 8.5,
      },
      observaciones: "Línea Galletera turno noche. Batches de amasado completos.",
      lotes: [
        ProductionLote(
          idProducto: "59e06cf8-f390-5093-af2e-3685be593a25",
          numero: "2704",
          producto: "Galleta con Kiwicha",
          presentacion: "30 g",
          fVencimiento: "2027-02-28",
          cantidad: 101,
        ),
        ProductionLote(
          idProducto: "59e06cf8-f390-5093-af2e-3685be593a25",
          numero: "2206",
          producto: "Galleta con Kiwicha",
          presentacion: "30 g",
          fVencimiento: "2027-02-28",
          cantidad: 70,
        ),
      ],
      bobinas: 4,
      bobinasDetalle: [
        BobinaDetalle(num: 1, bruto: 18.5, neto: 17.2),
        BobinaDetalle(num: 2, bruto: 18.2, neto: 17.0),
        BobinaDetalle(num: 3, bruto: 18.8, neto: 17.5),
        BobinaDetalle(num: 4, bruto: 18.0, neto: 16.8),
      ],
    ),
    const ProductionRun(
      id: "470b71f7-6f60-5680-8996-7da26ce7d013",
      fecha: "2026-08-28",
      turno: "Dia",
      tipo: "Galletas",
      supervisor: "Miriam Tito Sanca",
      cantBatch: 14.0,
      cantExtruidoTolva: 10.0,
      mermaTotal: 32.0,
      rendimiento: 94.1,
      mermasDetalle: {
        'piso_crudo': 6.0,
        'maquina': 8.5,
        'quemados': 3.5,
        'caja': 2.0,
        'piso_cocido': 5.0,
        'bobinas': 7.0,
      },
      lotes: [
        ProductionLote(
          idProducto: "996ad860-2a9a-504f-8861-aeafd0b2ae29",
          numero: "1401",
          producto: "Galleta con Quinua",
          cantidad: 211,
        ),
      ],
      bobinas: 5,
      bobinasDetalle: [
        BobinaDetalle(num: 1, bruto: 19.0, neto: 17.5),
        BobinaDetalle(num: 2, bruto: 18.5, neto: 17.1),
        BobinaDetalle(num: 3, bruto: 18.0, neto: 16.8),
        BobinaDetalle(num: 4, bruto: 18.7, neto: 17.2),
        BobinaDetalle(num: 5, bruto: 18.2, neto: 16.9),
      ],
    ),
    const ProductionRun(
      id: "jor_301",
      fecha: "2026-08-27",
      turno: "Noche",
      tipo: "Galletas",
      supervisor: "Delfin Estanis Roque",
      cantBatch: 10.0,
      cantExtruidoTolva: 8.0,
      mermaTotal: 28.5,
      rendimiento: 89.8,
      mermasDetalle: {
        'piso_crudo': 5.0,
        'maquina': 7.5,
        'quemados': 4.0,
        'caja': 2.5,
        'piso_cocido': 4.5,
        'bobinas': 5.0,
      },
      lotes: [
        ProductionLote(
          idProducto: "22fe83ae-a20f-54fc-b436-cec85c94c5e8",
          numero: "306",
          producto: "Gallleta Integral",
          cantidad: 175,
        ),
      ],
      bobinas: 3,
      bobinasDetalle: [
        BobinaDetalle(num: 1, bruto: 18.5, neto: 17.0),
        BobinaDetalle(num: 2, bruto: 18.0, neto: 16.8),
        BobinaDetalle(num: 3, bruto: 18.2, neto: 17.1),
      ],
    ),
  ];
}

final productionProvider = StateNotifierProvider<ProductionNotifier, ProductionState>((ref) {
  return ProductionNotifier(ref);
});
