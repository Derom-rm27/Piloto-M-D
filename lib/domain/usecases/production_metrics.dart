import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../models/production_run.dart';

class MermaSlice {
  const MermaSlice({
    required this.name,
    required this.kg,
    required this.percent,
    required this.color,
  });

  final String name;
  final double kg;
  final double percent;
  final Color color;
}

class DashboardMetrics {
  const DashboardMetrics({
    required this.rendimientoAvg,
    required this.totalCajas,
    required this.totalInsumosKg,
    required this.totalMermaKg,
    required this.mermaSlices,
  });

  final double rendimientoAvg;
  final int totalCajas;
  final double totalInsumosKg;
  final double totalMermaKg;
  final List<MermaSlice> mermaSlices;
}

class ProductionMetricsCalculator {
  static DashboardMetrics calculate(List<ProductionRun> runs, {String selectedRunId = 'all'}) {
    final activeRuns = selectedRunId == 'all'
        ? runs
        : runs.where((r) => r.id == selectedRunId).toList();

    if (activeRuns.isEmpty) {
      return const DashboardMetrics(
        rendimientoAvg: 94.8,
        totalCajas: 701,
        totalInsumosKg: 2440.0,
        totalMermaKg: 76.2,
        mermaSlices: [
          MermaSlice(name: 'Piso Crudo', kg: 23.5, percent: 30.8, color: AppTokens.mermaPisoCrudo),
          MermaSlice(name: 'Máquina', kg: 22.5, percent: 29.5, color: AppTokens.mermaMaquina),
          MermaSlice(name: 'Bobinas', kg: 17.5, percent: 23.0, color: AppTokens.mermaBobinas),
          MermaSlice(name: 'Piso Cocido', kg: 7.2, percent: 9.4, color: AppTokens.mermaPisoCocido),
          MermaSlice(name: 'Quemados / Rotas', kg: 5.5, percent: 7.3, color: AppTokens.mermaQuemados),
        ],
      );
    }

    final totalCajas = activeRuns.fold<int>(0, (s, r) => s + r.totalCajas);
    final totalMerma = activeRuns.fold<double>(0, (s, r) => s + r.mermaTotal);
    final avgRendimiento = activeRuns.fold<double>(0, (s, r) => s + r.rendimiento) / activeRuns.length;
    final totalBatches = activeRuns.fold<double>(0, (s, r) => s + r.cantBatch);
    final totalInsumos = totalBatches * 76.25;

    // Calcular suma de sub-mermas
    final Map<String, double> aggregatedMermas = {
      'Piso Crudo': 0.0,
      'Máquina': 0.0,
      'Bobinas': 0.0,
      'Piso Cocido': 0.0,
      'Quemados': 0.0,
      'Caja': 0.0,
    };

    for (final r in activeRuns) {
      r.mermasDetalle.forEach((key, val) {
        if (key.contains('piso_crudo')) {
          aggregatedMermas['Piso Crudo'] = (aggregatedMermas['Piso Crudo'] ?? 0) + val;
        } else if (key.contains('maquina')) {
          aggregatedMermas['Máquina'] = (aggregatedMermas['Máquina'] ?? 0) + val;
        } else if (key.contains('bobina')) {
          aggregatedMermas['Bobinas'] = (aggregatedMermas['Bobinas'] ?? 0) + val;
        } else if (key.contains('piso_cocido')) {
          aggregatedMermas['Piso Cocido'] = (aggregatedMermas['Piso Cocido'] ?? 0) + val;
        } else if (key.contains('quemado')) {
          aggregatedMermas['Quemados'] = (aggregatedMermas['Quemados'] ?? 0) + val;
        } else {
          aggregatedMermas['Caja'] = (aggregatedMermas['Caja'] ?? 0) + val;
        }
      });
    }

    final double validTotal = totalMerma > 0 ? totalMerma : 1.0;
    final List<MermaSlice> slices = [
      MermaSlice(name: 'Piso Crudo', kg: aggregatedMermas['Piso Crudo']!, percent: (aggregatedMermas['Piso Crudo']! / validTotal) * 100, color: AppTokens.mermaPisoCrudo),
      MermaSlice(name: 'Máquina', kg: aggregatedMermas['Máquina']!, percent: (aggregatedMermas['Máquina']! / validTotal) * 100, color: AppTokens.mermaMaquina),
      MermaSlice(name: 'Bobinas', kg: aggregatedMermas['Bobinas']!, percent: (aggregatedMermas['Bobinas']! / validTotal) * 100, color: AppTokens.mermaBobinas),
      MermaSlice(name: 'Piso Cocido', kg: aggregatedMermas['Piso Cocido']!, percent: (aggregatedMermas['Piso Cocido']! / validTotal) * 100, color: AppTokens.mermaPisoCocido),
      MermaSlice(name: 'Quemados / Rotas', kg: aggregatedMermas['Quemados']!, percent: (aggregatedMermas['Quemados']! / validTotal) * 100, color: AppTokens.mermaQuemados),
    ];

    return DashboardMetrics(
      rendimientoAvg: double.parse(avgRendimiento.toStringAsFixed(1)),
      totalCajas: totalCajas > 0 ? totalCajas : 701,
      totalInsumosKg: double.parse((totalInsumos > 0 ? totalInsumos : 2440.0).toStringAsFixed(0)),
      totalMermaKg: double.parse((totalMerma > 0 ? totalMerma : 76.2).toStringAsFixed(1)),
      mermaSlices: slices,
    );
  }
}
