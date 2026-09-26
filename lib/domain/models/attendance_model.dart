class AttendanceStatus {
  const AttendanceStatus({
    this.status = 'fuera',
    this.tipo,
    this.turno,
    this.linea,
    this.fecha,
    this.fechaJornada,
    this.hora,
  });

  final String status; // 'en_planta' | 'fuera'
  final String? tipo; // 'ENTRADA' | 'SALIDA'
  final String? turno; // 'Dia' | 'Noche'
  final String? linea; // 'Galletas' | 'Barras'
  final String? fecha; // YYYY-MM-DD
  final String? fechaJornada; // YYYY-MM-DD
  final String? hora; // HH:MM

  bool get isEnPlanta => status == 'en_planta';

  AttendanceStatus copyWith({
    String? status,
    String? tipo,
    String? turno,
    String? linea,
    String? fecha,
    String? fechaJornada,
    String? hora,
  }) => AttendanceStatus(
    status: status ?? this.status,
    tipo: tipo ?? this.tipo,
    turno: turno ?? this.turno,
    linea: linea ?? this.linea,
    fecha: fecha ?? this.fecha,
    fechaJornada: fechaJornada ?? this.fechaJornada,
    hora: hora ?? this.hora,
  );
}

class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.workerId,
    required this.fechaHora,
    required this.fechaJornada,
    required this.tipo,
    required this.turno,
    required this.linea,
  });

  final String id;
  final String workerId;
  final String fechaHora; // ISO string
  final String fechaJornada; // YYYY-MM-DD
  final String tipo; // 'ENTRADA' | 'SALIDA'
  final String turno; // 'Dia' | 'Noche'
  final String linea; // 'Galletas' | 'Barras'

  Map<String, dynamic> toMap() => {
    'id_registro': id,
    'id_trabajador': workerId,
    'fecha_hora': fechaHora,
    'fecha_jornada': fechaJornada,
    'tipo': tipo,
    'turno': turno,
    'linea': linea,
  };

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) => AttendanceRecord(
    id: (map['id_registro'] ?? map['id'] ?? '') as String,
    workerId: (map['id_trabajador'] ?? map['workerId'] ?? '') as String,
    fechaHora: (map['fecha_hora'] ?? '') as String,
    fechaJornada: (map['fecha_jornada'] ?? '') as String,
    tipo: (map['tipo'] ?? 'ENTRADA') as String,
    turno: (map['turno'] ?? 'Dia') as String,
    linea: (map['linea'] ?? 'Galletas') as String,
  );

  /// Helper que deriva la fecha_jornada considerando el cruce de medianoche
  /// del Turno Noche (Regla GEMINI.md: Salida entre 00:00 y 11:59 AM de turno noche pertenece al Día N-1).
  static String calculateFechaJornada({
    required String fecha,
    required String hora,
    required String turno,
    required String tipo,
  }) {
    if (turno == 'Noche' && tipo == 'SALIDA') {
      final hourNum = int.tryParse(hora.split(':').first) ?? 0;
      if (hourNum < 12) {
        final parsedDate = DateTime.tryParse(fecha);
        if (parsedDate != null) {
          final previousDay = parsedDate.subtract(const Duration(days: 1));
          return '${previousDay.year.toString().padLeft(4, '0')}-${previousDay.month.toString().padLeft(2, '0')}-${previousDay.day.toString().padLeft(2, '0')}';
        }
      }
    }
    return fecha;
  }
}
