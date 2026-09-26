import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/data/app_store.dart';
import '../../core/domain/production.dart';
import '../../domain/models/attendance_model.dart';
import '../../domain/models/worker.dart';
import 'personnel_provider.dart';

class AttendanceState {
  const AttendanceState({
    this.workerStatus = const {},
    this.records = const [],
    this.selectedIds = const {},
    this.statusFilter = 'todos', // 'todos' | 'en_planta' | 'fuera'
    this.searchQuery = '',
    this.currentSubtab = 'marcacion', // 'marcacion' | 'reporte'
    this.selectedTurno = 'Dia',
    this.selectedLinea = 'Galletas',
  });

  final Map<String, AttendanceStatus> workerStatus;
  final List<AttendanceRecord> records;
  final Set<String> selectedIds;
  final String statusFilter;
  final String searchQuery;
  final String currentSubtab;
  final String selectedTurno;
  final String selectedLinea;

  int countEnPlanta(List<Worker> activeWorkers) {
    int count = 0;
    for (final w in activeWorkers) {
      if (workerStatus[w.id]?.isEnPlanta == true) count++;
    }
    return count;
  }

  int countFuera(List<Worker> activeWorkers) {
    return activeWorkers.length - countEnPlanta(activeWorkers);
  }

  List<Worker> getFilteredWorkers(List<Worker> activeWorkers) {
    return activeWorkers.where((w) {
      final st = workerStatus[w.id];
      final isInside = st?.isEnPlanta == true;

      if (statusFilter == 'en_planta' && !isInside) return false;
      if (statusFilter == 'fuera' && isInside) return false;

      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        if (!w.fullName.toLowerCase().contains(q)) return false;
      }
      return true;
    }).toList();
  }

  AttendanceState copyWith({
    Map<String, AttendanceStatus>? workerStatus,
    List<AttendanceRecord>? records,
    Set<String>? selectedIds,
    String? statusFilter,
    String? searchQuery,
    String? currentSubtab,
    String? selectedTurno,
    String? selectedLinea,
  }) => AttendanceState(
    workerStatus: workerStatus ?? this.workerStatus,
    records: records ?? this.records,
    selectedIds: selectedIds ?? this.selectedIds,
    statusFilter: statusFilter ?? this.statusFilter,
    searchQuery: searchQuery ?? this.searchQuery,
    currentSubtab: currentSubtab ?? this.currentSubtab,
    selectedTurno: selectedTurno ?? this.selectedTurno,
    selectedLinea: selectedLinea ?? this.selectedLinea,
  );
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier(this._ref) : super(const AttendanceState()) {
    _currentStore = _ref.read(appStoreProvider);
    _syncWithAppStore();
    _currentStore?.addListener(_syncWithAppStore);
    _storeSub = _ref.listen<AppStore?>(appStoreProvider, (prev, next) {
      prev?.removeListener(_syncWithAppStore);
      next?.addListener(_syncWithAppStore);
      _currentStore = next;
      _syncWithAppStore();
    });
  }

  final Ref _ref;
  AppStore? _currentStore;
  ProviderSubscription<AppStore?>? _storeSub;

  void _syncWithAppStore() {
    final store = _currentStore ?? _ref.read(appStoreProvider);
    if (store == null) return;
    final rows = store.rows('registro_asistencia');

    final loadedRecords = rows.map((r) => AttendanceRecord.fromMap(r)).toList();

    // Sincronizar el estado en planta / fuera para cada trabajador
    final Map<String, AttendanceStatus> updatedStatus = Map.from(state.workerStatus);

    final Map<String, List<RowData>> byWorker = {};
    for (final r in rows) {
      final wid = (r['id_trabajador'] ?? r['workerId']) as String?;
      if (wid != null) {
        (byWorker[wid] ??= []).add(r);
      }
    }

    for (final entry in byWorker.entries) {
      final wid = entry.key;
      final marks = entry.value;
      marks.sort((a, b) => '${a['fecha_hora']}'.compareTo('${b['fecha_hora']}'));
      final latest = marks.last;
      final tipo = (latest['tipo'] ?? 'ENTRADA') as String;
      final turno = (latest['turno'] ?? 'Dia') as String;
      final linea = (latest['linea'] ?? 'Galletas') as String;
      final fechaHora = '${latest['fecha_hora']}';
      final hora = fechaHora.contains('T')
          ? fechaHora.split('T')[1].substring(0, 5)
          : '00:00';
      final fechaJornada = latest['fecha_jornada'] as String? ?? workDate(latest);

      updatedStatus[wid] = AttendanceStatus(
        status: tipo == 'ENTRADA' ? 'en_planta' : 'fuera',
        tipo: tipo,
        turno: turno,
        linea: linea,
        fecha: workDate(latest),
        fechaJornada: fechaJornada,
        hora: hora,
      );
    }

    if (mounted) {
      state = state.copyWith(
        records: loadedRecords,
        workerStatus: updatedStatus,
      );
    }
  }

  @override
  void dispose() {
    _storeSub?.close();
    _currentStore?.removeListener(_syncWithAppStore);
    super.dispose();
  }

  void setSubtab(String subtab) {
    state = state.copyWith(currentSubtab: subtab);
  }

  void setStatusFilter(String filter) {
    state = state.copyWith(statusFilter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim());
  }

  void toggleWorkerSelection(String workerId) {
    final newSet = Set<String>.from(state.selectedIds);
    if (newSet.contains(workerId)) {
      newSet.remove(workerId);
    } else {
      newSet.add(workerId);
    }
    state = state.copyWith(selectedIds: newSet);
  }

  void selectAll(List<Worker> visibleWorkers) {
    final allSelected = visibleWorkers.isNotEmpty && visibleWorkers.every((w) => state.selectedIds.contains(w.id));
    if (allSelected) {
      final newSet = Set<String>.from(state.selectedIds);
      for (final w in visibleWorkers) {
        newSet.remove(w.id);
      }
      state = state.copyWith(selectedIds: newSet);
    } else {
      final newSet = Set<String>.from(state.selectedIds);
      for (final w in visibleWorkers) {
        newSet.add(w.id);
      }
      state = state.copyWith(selectedIds: newSet);
    }
  }

  void clearSelection() {
    state = state.copyWith(selectedIds: {});
  }

  /// Registra entrada o salida para los trabajadores seleccionados
  Future<void> registerBatch({
    required String tipo, // 'ENTRADA' | 'SALIDA'
    required String turno, // 'Dia' | 'Noche'
    required String linea, // 'Galletas' | 'Barras'
    required String fecha, // YYYY-MM-DD
    required String hora,  // HH:MM
  }) async {
    final updatedMap = Map<String, AttendanceStatus>.from(state.workerStatus);
    final List<AttendanceRecord> newRecords = List.from(state.records);
    final store = _currentStore ?? _ref.read(appStoreProvider);
    final List<(String, RowData)> ops = [];

    for (final id in state.selectedIds) {
      final fechaJornada = AttendanceRecord.calculateFechaJornada(
        fecha: fecha,
        hora: hora,
        turno: turno,
        tipo: tipo,
      );

      final newStatus = AttendanceStatus(
        status: tipo == 'ENTRADA' ? 'en_planta' : 'fuera',
        tipo: tipo,
        turno: turno,
        linea: linea,
        fecha: fecha,
        fechaJornada: fechaJornada,
        hora: hora,
      );
      updatedMap[id] = newStatus;

      final idRegistro = const Uuid().v4();
      final fechaHora = '${fecha}T$hora:00-05:00';

      final record = AttendanceRecord(
        id: idRegistro,
        workerId: id,
        fechaHora: fechaHora,
        fechaJornada: fechaJornada,
        tipo: tipo,
        turno: turno,
        linea: linea,
      );
      newRecords.add(record);

      ops.add(('registro_asistencia', record.toMap()));
    }

    state = state.copyWith(
      workerStatus: updatedMap,
      records: newRecords,
      selectedIds: {}, // Limpiar selección tras marcar
    );

    if (store != null && ops.isNotEmpty) {
      await store.saveBatch(ops);
    }
  }

  /// Anula o elimina la marcación para los trabajadores seleccionados (vuelven a fuera de planta)
  Future<void> clearMarks(Set<String> workerIds) async {
    final store = _currentStore ?? _ref.read(appStoreProvider);
    final updatedMap = Map<String, AttendanceStatus>.from(state.workerStatus);
    for (final id in workerIds) {
      updatedMap[id] = const AttendanceStatus(status: 'fuera');
    }
    state = state.copyWith(
      workerStatus: updatedMap,
      selectedIds: {},
    );

    if (store != null) {
      final rows = store.rows('registro_asistencia')
          .where((r) => workerIds.contains(r['id_trabajador']))
          .toList();
      for (final r in rows) {
        await store.remove('registro_asistencia', r);
      }
    }
  }
}

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  return AttendanceNotifier(ref);
});
