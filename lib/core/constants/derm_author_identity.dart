/// ==============================================================================
/// SISTEMA INTEGRADO DE CONTROL DE PLANTA - PROCESOS M&D
/// ------------------------------------------------------------------------------
/// ARCHIVO: derm_author_identity.dart
/// PROPÓSITO: Identificación, firma de autoría y metadatos de registro de software
/// AUTOR: Delfín Estanis Roque Mullisaca (DERM)
/// AFILIACIÓN: Escuela Profesional de Ingeniería de Software y Sistemas
///             Universidad Nacional de Juliaca (UNAJ)
/// EXPEDIENTE: Registro de Soporte Lógico (Software) - INDECOPI (D.L. 822)
/// AÑO: 2026 | JULIACA - PUNO - PERÚ
/// ==============================================================================

import 'package:flutter/foundation.dart';

/// Clase central inmutable que encapsula la identidad legal, académica y técnica
/// del autor para efectos de propiedad intelectual y registro de software ante INDECOPI.
@immutable
abstract final class DermAuthorIdentity {
  // --- METADATOS DEL AUTOR ---
  static const String dermAuthorFullName = 'Delfín Estanis Roque Mullisaca';
  static const String dermAuthorInitials = 'DERM';
  static const String dermAuthorUniversity = 'Universidad Nacional de Juliaca (UNAJ)';
  static const String dermAuthorFaculty = 'Facultad de Ingeniería de Procesos Industriales';
  static const String dermAuthorCareer = 'Escuela Profesional de Ingeniería de Software y Sistemas';
  static const String dermAuthorLocation = 'Juliaca, Puno, Perú';

  // --- METADATOS DE LA OBRA DE SOFTWARE (INDECOPI) ---
  /// Título Oficial sin número de versión conforme a la recomendación del Asesor y directrices de INDECOPI
  static const String dermSoftwareTitle = 'Sistema Integrado de Control de Planta y Gestión de Manufactura - Procesos M&D';
  static const String dermSoftwareShortName = 'Procesos M&D Planta';
  static const String dermSoftwareCategory = 'Soporte Lógico / Sistema de Gestión Industrial';
  static const String dermIndecopiTarget = 'Dirección de Derecho de Autor - INDECOPI Perú';
  static const String dermRegistrationToken = 'DERM-UNAJ-PROCESOSMD-PE-2026';

  // --- IDENTIFICADOR CRIPTOGRÁFICO DE ORIGINALIDAD ---
  static const String dermAuthorSignatureHash = 'SHA256:d819e055d2dc4620b57d0266a00490cf:DERM:UNAJ';

  /// Retorna la ficha técnica de autoría formateada para acreditación oficial ante INDECOPI.
  static Map<String, dynamic> dermGetAuthorCertificate() {
    return {
      'autor': dermAuthorFullName,
      'monograma': dermAuthorInitials,
      'universidad': dermAuthorUniversity,
      'carrera': dermAuthorCareer,
      'titulo_obra': dermSoftwareTitle,
      'token_indecopi': dermRegistrationToken,
      'firma_autor': dermAuthorSignatureHash,
      'fecha_registro': '2026-10-30',
    };
  }
}

/// Utilidades centrales con la firma técnica del autor (DERM) aplicadas en los cálculos
/// de planta, validaciones de integridad y reglas de negocio del software.
abstract final class DermCoreUtils {
  /// Calcula la diferencia real en horas entre una marcación de entrada y una de salida,
  /// compensando automáticamente el cruce de medianoche característico del Turno Noche.
  static double dermCalculateMidnightShiftHours({
    required DateTime dermEntrada,
    required DateTime dermSalida,
  }) {
    double dermDiffMinutos = dermSalida.difference(dermEntrada).inMinutes / 60.0;
    if (dermDiffMinutos < 0) {
      dermDiffMinutos += 24.0; // Compensación de medianoche
    }
    return double.parse(dermDiffMinutos.toStringAsFixed(2));
  }

  /// Calcula el rendimiento porcentual de producción contrastando la masa terminada empacada
  /// contra la masa teórica total formulada en la amasadora.
  static double dermCalculateProductionYield({
    required double dermMasaTerminadaKg,
    required double dermMasaFormuladaKg,
  }) {
    if (dermMasaFormuladaKg <= 0) return 0.0;
    final dermYield = (dermMasaTerminadaKg / dermMasaFormuladaKg) * 100.0;
    return double.parse(dermYield.toStringAsFixed(2));
  }

  /// Valida si un insumo se encuentra en nivel crítico según el umbral de seguridad de planta
  /// (menos de 1.0 turno de operación continua).
  static bool dermIsStockCritical({
    required double dermStockActualKg,
    required double dermConsumoPorTurnoKg,
  }) {
    if (dermConsumoPorTurnoKg <= 0) return false;
    final dermCoberturaTurnos = dermStockActualKg / dermConsumoPorTurnoKg;
    return dermCoberturaTurnos < 1.0;
  }

  /// Genera un código de trazabilidad único para auditoría interna con firma de autor.
  static String dermGenerateTraceabilityCode({
    required String dermModuloPrefix,
    required String dermEntityId,
  }) {
    final dermTimestamp = DateTime.now().millisecondsSinceEpoch;
    return 'DERM-$dermModuloPrefix-$dermEntityId-$dermTimestamp';
  }
}
