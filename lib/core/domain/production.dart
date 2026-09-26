import '../data/app_store.dart';

double number(dynamic v) =>
    v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
String fullName(RowData r) => [
  r['nombre'],
  r['apellido_paterno'],
  r['apellido_materno'],
].where((s) => s != null && '$s'.trim().isNotEmpty).join(' ');
String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
DateTime limaTime(String value) {
  final d = DateTime.parse(value);
  return d.isUtc ? d.add(const Duration(hours: -5)) : d;
}

String workDate(RowData r) {
  if (r['fecha_jornada'] != null) return '${r['fecha_jornada']}';
  var d = limaTime(r['fecha_hora']);
  if (r['turno'] == 'Noche' && d.hour < 12) {
    d = d.subtract(const Duration(days: 1));
  }
  return dateKey(d);
}

class Production {
  Production(this.store, this.row);
  final AppStore store;
  final RowData row;
  String get id => row['id_jornada'];
  bool get isCookies => row['tipo'] == 'Galletas';
  List<RowData> get lots =>
      store
          .rows('lotes_produccion')
          .where((l) => l['id_jornada'] == id)
          .toList()
        ..sort(
          (a, b) => '${a['numero_lote']}'.compareTo('${b['numero_lote']}'),
        );
  List<RowData> get reels =>
      store
          .rows('bobinas_produccion')
          .where((l) => l['id_jornada'] == id)
          .toList()
        ..sort(
          (a, b) =>
              number(a['numero_bobina']).compareTo(number(b['numero_bobina'])),
        );
  double get boxes => lots.fold(0, (s, l) => s + number(l['cantidad']));
  double? get kilograms {
    if (!isCookies) return null;
    double kg = 0;
    for (final l in lots) {
      final grams = RegExp(r'\d+').firstMatch('${l['presentacion']}')?.group(0);
      if (grams != '30' && grams != '48') return null;
      kg += number(l['cantidad']) * (grams == '30' ? 7.5 : 7.68);
    }
    return kg;
  }

  double get waste =>
      (isCookies
              ? [
                  'merma_piso_crudo',
                  'merma_maquina',
                  'quemados',
                  'merma_piso_cocido',
                ]
              : ['merma_piso', 'merma_maquina'])
          .fold<double>(0, (s, k) => s + number(row[k])) +
      (isCookies ? number(row['caja_blanco_rotos'] ?? row['caja']) : 0);
  static const batchKg = {
    'quinua': 122.01,
    'kiwicha': 117.91,
    'integral': 118.51,
    'maca': 117.51,
    'cajamarquina': 120.51,
    'cereales': 120.51,
  };
  double? recipeWeight(RowData lot) {
    final name = product(lot).toLowerCase();
    for (final e in batchKg.entries) {
      if (name.contains(e.key)) return e.value;
    }
    return null;
  }

  double? get inputKg {
    if (!isCookies || lots.isEmpty) return null;
    if (lots.every((l) => number(l['cant_batch']) > 0)) {
      if ((lots.fold<double>(0, (s, l) => s + number(l['cant_batch'])) -
                  number(row['cant_batch']))
              .abs() >
          .01) {
        return null;
      }
      double kg = 0;
      for (final lot in lots) {
        final weight = recipeWeight(lot);
        if (weight == null) return null;
        kg += weight * number(lot['cant_batch']);
      }
      return kg > 0 ? kg : null;
    }
    if (lots.map((l) => l['id_producto']).toSet().length != 1) return null;
    final weight = recipeWeight(lots.first),
        batches = number(row['cant_batch']);
    return weight == null || batches <= 0 ? null : weight * batches;
  }

  double? get yieldPercent =>
      inputKg == null || kilograms == null ? null : kilograms! / inputKg! * 100;
  double? get expectedKg => inputKg == null ? null : inputKg! * (1 - .2656);
  double? get expectedBoxes {
    if (expectedKg == null ||
        lots.map((l) => l['presentacion']).toSet().length != 1) {
      return null;
    }
    return expectedKg! /
        (RegExp(r'\d+').firstMatch('${lots.first['presentacion']}')?.group(0) ==
                '48'
            ? 7.68
            : 7.5);
  }

  bool get goodYield =>
      yieldPercent != null && yieldPercent! >= 73.44 && yieldPercent! <= 100;
  String product(RowData l) =>
      '${store.find('productos_envasados', l['id_producto'])?['nombre_producto'] ?? 'Producto no disponible'}';
  String get supervisor =>
      fullName(store.find('personal', row['id_supervisor']) ?? {});
}
