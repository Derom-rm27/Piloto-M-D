import '../data/app_store.dart';
import 'production.dart';

class AttendanceIncident {
  const AttendanceIncident({
    required this.workerId,
    required this.workerName,
    required this.date,
    required this.turno,
    required this.linea,
    required this.tipo,
    required this.descripcion,
    required this.hora,
  });

  final String workerId;
  final String workerName;
  final String date;
  final String turno;
  final String linea;
  final String tipo; // 'Doble Entrada' | 'Salida sin Entrada' | 'Horario Incoherente'
  final String descripcion;
  final String hora;
}

class AttendanceDayRecord {
  const AttendanceDayRecord({
    required this.date,
    required this.turno,
    required this.linea,
    required this.entradaHora,
    this.salidaHora,
    required this.horas,
    required this.isEnPlanta,
  });

  final String date;
  final String turno;
  final String linea;
  final String entradaHora;
  final String? salidaHora;
  final double horas;
  final bool isEnPlanta;
}

class AttendanceSummary {
  AttendanceSummary(this.person);
  final RowData person;
  final Set<String> dates = {}, dayShifts = {}, nightShifts = {};
  final List<AttendanceIncident> incidents = [];
  final List<AttendanceDayRecord> dailyRecords = [];
  double hours = 0;
  int incomplete = 0;
  int sinSalida = 0;
  String get name => fullName(person);
  List<Object> cells(int index) => [
    index,
    name,
    dates.length,
    dayShifts.length,
    nightShifts.length,
    double.parse(hours.toStringAsFixed(2)),
  ];
}

List<AttendanceSummary> attendanceReport(
  List<RowData> people,
  List<RowData> marks,
  DateTime month,
) {
  final prefix = '${month.year}-${month.month.toString().padLeft(2, '0')}';
  final result = {
    for (final p in people) p['id_trabajador']: AttendanceSummary(p),
  };
  final grouped = <String, List<RowData>>{};
  for (final mark in marks.where((r) => r['deleted_at'] == null)) {
    final date = workDate(mark);
    if (!date.startsWith(prefix)) continue;
    final key =
        '${mark['id_trabajador']}|$date|${mark['turno']}|${mark['linea']}';
    (grouped[key] ??= []).add(mark);
  }
  for (final group in grouped.values) {
    group.sort(
      (a, b) => DateTime.parse(
        a['fecha_hora'],
      ).compareTo(DateTime.parse(b['fecha_hora'])),
    );
    final summary = result[group.first['id_trabajador']];
    if (summary == null) continue;
    DateTime? entry;
    String? entryTurno;
    bool ambiguous = false;
    for (final mark in group) {
      final time = DateTime.parse(mark['fecha_hora']);
      final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      if (mark['tipo'] == 'ENTRADA') {
        if (entry != null) {
          ambiguous = true;
          summary.incomplete++;
          final d = workDate(mark);
          summary.incidents.add(AttendanceIncident(
            workerId: '${summary.person['id_trabajador'] ?? ''}',
            workerName: summary.name,
            date: d,
            turno: '${mark['turno'] ?? 'Dia'}',
            linea: '${mark['linea'] ?? 'Galletas'}',
            tipo: 'Doble Entrada',
            descripcion: 'Tiene dos entradas consecutivas registradas ($timeStr) sin haber marcado salida previa.',
            hora: timeStr,
          ));
        }
        entry = time;
        entryTurno = mark['turno'] as String?;
      } else {
        if (entry == null) {
          summary.incomplete++;
          final d = workDate(mark);
          summary.incidents.add(AttendanceIncident(
            workerId: '${summary.person['id_trabajador'] ?? ''}',
            workerName: summary.name,
            date: d,
            turno: '${mark['turno'] ?? 'Dia'}',
            linea: '${mark['linea'] ?? 'Galletas'}',
            tipo: 'Salida sin Entrada',
            descripcion: 'Se registró una Salida a las $timeStr pero no existe una Entrada previa registrada para este turno.',
            hora: timeStr,
          ));
          continue;
        }
        final duration = time.difference(entry).inMinutes;
        if (!ambiguous && duration > 0 && duration <= 24 * 60) {
          final h = duration / 60.0;
          summary.hours += h;
          final date = workDate(mark);
          summary.dates.add(date);
          (mark['turno'] == 'Noche'
                  ? summary.nightShifts
                  : summary.dayShifts)
              .add(date);
          final entryTimeStr = '${entry.hour.toString().padLeft(2, '0')}:${entry.minute.toString().padLeft(2, '0')}';
          summary.dailyRecords.add(AttendanceDayRecord(
            date: date,
            turno: '${mark['turno'] ?? 'Dia'}',
            linea: '${mark['linea'] ?? 'Galletas'}',
            entradaHora: entryTimeStr,
            salidaHora: timeStr,
            horas: double.parse(h.toStringAsFixed(1)),
            isEnPlanta: false,
          ));
        } else {
          summary.incomplete++;
          final d = workDate(mark);
          summary.incidents.add(AttendanceIncident(
            workerId: '${summary.person['id_trabajador'] ?? ''}',
            workerName: summary.name,
            date: d,
            turno: '${mark['turno'] ?? 'Dia'}',
            linea: '${mark['linea'] ?? 'Galletas'}',
            tipo: 'Horario Incoherente',
            descripcion: 'La duración calculada (${(duration / 60).toStringAsFixed(1)} hrs) es inconsistente o excede 24 horas.',
            hora: timeStr,
          ));
        }
        entry = null;
        ambiguous = false;
      }
    }
    // Entrada sin salida registrada (turno en curso o salida pendiente)
    if (entry != null && !ambiguous) {
      summary.sinSalida++;
      final date = workDate(group.first);
      summary.dates.add(date);
      final turno = entryTurno ?? group.first['turno'];
      (turno == 'Noche' ? summary.nightShifts : summary.dayShifts).add(date);

      final isNight = turno == 'Noche';
      final maxHours = isNight ? 10.0 : 8.0;
      final now = DateTime.now();
      double computedHours = maxHours;

      // Si la marcación es de hoy, computar tiempo transcurrido
      if (entry.year == now.year && entry.month == now.month && entry.day == now.day) {
        final elapsedMinutes = now.difference(entry).inMinutes;
        if (elapsedMinutes <= 0) {
          computedHours = maxHours;
        } else {
          final elapsedHours = elapsedMinutes / 60.0;
          final h = elapsedHours < maxHours ? elapsedHours : maxHours;
          computedHours = double.parse((h < 0.5 ? maxHours : h).toStringAsFixed(1));
        }
      } else {
        // Marcación de fecha anterior sin salida: computar jornada estándar
        computedHours = maxHours;
      }
      summary.hours += computedHours;

      final entryTimeStr = '${entry.hour.toString().padLeft(2, '0')}:${entry.minute.toString().padLeft(2, '0')}';
      summary.dailyRecords.add(AttendanceDayRecord(
        date: date,
        turno: '$turno',
        linea: '${group.first['linea'] ?? 'Galletas'}',
        entradaHora: entryTimeStr,
        salidaHora: null,
        horas: computedHours,
        isEnPlanta: true,
      ));
    } else if (entry != null && ambiguous) {
      summary.incomplete++;
    }
  }
  for (final s in result.values) {
    s.dailyRecords.sort((a, b) => a.date.compareTo(b.date));
  }
  return result.values
      .where((r) => r.dates.isNotEmpty || r.incomplete > 0 || r.sinSalida > 0)
      .toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
}
