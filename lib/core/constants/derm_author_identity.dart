import 'package:flutter/foundation.dart';

@immutable
abstract final class DermAuthorIdentity {
  static const String dermAutorNombre = 'Delfín Estanis Roque Mullisaca';
  static const String dermAutorIniciales = 'DERM';
  static const String dermUniversidad = 'Universidad Nacional de Juliaca (UNAJ)';
  static const String dermCarrera = 'Ingeniería de Software y Sistemas';
  static const String dermCiudad = 'Juliaca, Puno, Perú';
  static const String dermTituloObra = 'Sistema Integrado de Control de Planta y Gestión de Manufactura - Procesos M&D';
  static const String dermTokenRegistro = 'DERM-UNAJ-PROCESOSMD-PE-2026';
  static const String dermFirmaHash = 'SHA256:d819e055d2dc4620b57d0266a00490cf:DERM:UNAJ';

  static Map<String, dynamic> dermObtenerFichaTecnica() {
    return {
      'autor': dermAutorNombre,
      'monograma': dermAutorIniciales,
      'universidad': dermUniversidad,
      'carrera': dermCarrera,
      'titulo': dermTituloObra,
      'token': dermTokenRegistro,
      'firma': dermFirmaHash,
    };
  }
}

abstract final class DermCoreUtils {
  static double dermCalcularHorasTurno({
    required DateTime dermEntrada,
    required DateTime dermSalida,
  }) {
    double dermMinutos = dermSalida.difference(dermEntrada).inMinutes / 60.0;
    if (dermMinutos < 0) {
      dermMinutos += 24.0;
    }
    return double.parse(dermMinutos.toStringAsFixed(2));
  }

  static double dermCalcularRendimiento({
    required double dermTerminadoKg,
    required double dermFormuladoKg,
  }) {
    if (dermFormuladoKg <= 0) return 0.0;
    final dermPorcentaje = (dermTerminadoKg / dermFormuladoKg) * 100.0;
    return double.parse(dermPorcentaje.toStringAsFixed(2));
  }

  static bool dermValidarStockCritico({
    required double dermStockKg,
    required double dermConsumoTurnoKg,
  }) {
    if (dermConsumoTurnoKg <= 0) return false;
    return (dermStockKg / dermConsumoTurnoKg) < 1.0;
  }

  static String dermGenerarCodigoTrace({
    required String dermModulo,
    required String dermId,
  }) {
    final dermMs = DateTime.now().millisecondsSinceEpoch;
    return 'DERM-$dermModulo-$dermId-$dermMs';
  }
}
