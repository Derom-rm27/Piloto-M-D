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
  static DashboardMetrics dermCalcularMetricasDashboard(
    List<ProductionRun> dermRuns, {
    String dermSelectedRunId = 'all',
  }) {
    final dermActiveRuns = dermSelectedRunId == 'all'
        ? dermRuns
        : dermRuns.where((r) => r.id == dermSelectedRunId).toList();

    if (dermActiveRuns.isEmpty) {
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

    final dermTotalCajas = dermActiveRuns.fold<int>(0, (s, r) => s + r.totalCajas);
    final dermTotalMerma = dermActiveRuns.fold<double>(0, (s, r) => s + r.mermaTotal);
    final dermAvgRendimiento = dermActiveRuns.fold<double>(0, (s, r) => s + r.rendimiento) / dermActiveRuns.length;
    final dermTotalBatches = dermActiveRuns.fold<double>(0, (s, r) => s + r.cantBatch);
    final dermTotalInsumos = dermTotalBatches * 76.25;

    final Map<String, double> dermAggregatedMermas = {
      'Piso Crudo': 0.0,
      'Máquina': 0.0,
      'Bobinas': 0.0,
      'Piso Cocido': 0.0,
      'Quemados': 0.0,
      'Caja': 0.0,
    };

    for (final dermR in dermActiveRuns) {
      dermR.mermasDetalle.forEach((key, val) {
        if (key.contains('piso_crudo')) {
          dermAggregatedMermas['Piso Crudo'] = (dermAggregatedMermas['Piso Crudo'] ?? 0) + val;
        } else if (key.contains('maquina')) {
          dermAggregatedMermas['Máquina'] = (dermAggregatedMermas['Máquina'] ?? 0) + val;
        } else if (key.contains('bobina')) {
          dermAggregatedMermas['Bobinas'] = (dermAggregatedMermas['Bobinas'] ?? 0) + val;
        } else if (key.contains('piso_cocido')) {
          dermAggregatedMermas['Piso Cocido'] = (dermAggregatedMermas['Piso Cocido'] ?? 0) + val;
        } else if (key.contains('quemado')) {
          dermAggregatedMermas['Quemados'] = (dermAggregatedMermas['Quemados'] ?? 0) + val;
        } else {
          dermAggregatedMermas['Caja'] = (dermAggregatedMermas['Caja'] ?? 0) + val;
        }
      });
    }

    final double dermValidTotal = dermTotalMerma > 0 ? dermTotalMerma : 1.0;
    final List<MermaSlice> dermSlices = [
      MermaSlice(name: 'Piso Crudo', kg: dermAggregatedMermas['Piso Crudo']!, percent: (dermAggregatedMermas['Piso Crudo']! / dermValidTotal) * 100, color: AppTokens.mermaPisoCrudo),
      MermaSlice(name: 'Máquina', kg: dermAggregatedMermas['Máquina']!, percent: (dermAggregatedMermas['Máquina']! / dermValidTotal) * 100, color: AppTokens.mermaMaquina),
      MermaSlice(name: 'Bobinas', kg: dermAggregatedMermas['Bobinas']!, percent: (dermAggregatedMermas['Bobinas']! / dermValidTotal) * 100, color: AppTokens.mermaBobinas),
      MermaSlice(name: 'Piso Cocido', kg: dermAggregatedMermas['Piso Cocido']!, percent: (dermAggregatedMermas['Piso Cocido']! / dermValidTotal) * 100, color: AppTokens.mermaPisoCocido),
      MermaSlice(name: 'Quemados / Rotas', kg: dermAggregatedMermas['Quemados']!, percent: (dermAggregatedMermas['Quemados']! / dermValidTotal) * 100, color: AppTokens.mermaQuemados),
    ];

    return DashboardMetrics(
      rendimientoAvg: double.parse(dermAvgRendimiento.toStringAsFixed(1)),
      totalCajas: dermTotalCajas > 0 ? dermTotalCajas : 701,
      totalInsumosKg: double.parse(dermTotalInsumos.toStringAsFixed(1)),
      totalMermaKg: double.parse(dermTotalMerma.toStringAsFixed(1)),
      mermaSlices: dermSlices,
    );
  }

  static DashboardMetrics calculate(List<ProductionRun> runs, {String selectedRunId = 'all'}) {
    return dermCalcularMetricasDashboard(runs, dermSelectedRunId: selectedRunId);
  }
}
