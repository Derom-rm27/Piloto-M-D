import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/app_store.dart';
import '../../domain/models/worker.dart';

// Provider global opcional para acceder a AppStore
final appStoreProvider = StateProvider<AppStore?>((ref) => null);

class PersonnelState {
  const PersonnelState({
    required this.workers,
    this.statusFilter = 'todos', // 'todos' | 'activos' | 'inactivos'
    this.searchQuery = '',
    this.selectedWorkerForFicha,
  });

  final List<Worker> workers;
  final String statusFilter;
  final String searchQuery;
  final Worker? selectedWorkerForFicha;

  int get countTotal => workers.length;
  int get countActivos => workers.where((w) => w.activo).length;
  int get countInactivos => workers.where((w) => !w.activo).length;

  List<Worker> get filteredWorkers {
    return workers.where((w) {
      if (statusFilter == 'activos' && !w.activo) return false;
      if (statusFilter == 'inactivos' && w.activo) return false;

      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final match = w.fullName.toLowerCase().contains(query) ||
            (w.dni?.toLowerCase().contains(query) ?? false) ||
            w.cargo.toLowerCase().contains(query);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  PersonnelState copyWith({
    List<Worker>? workers,
    String? statusFilter,
    String? searchQuery,
    Worker? Function()? selectedWorkerForFicha,
  }) => PersonnelState(
    workers: workers ?? this.workers,
    statusFilter: statusFilter ?? this.statusFilter,
    searchQuery: searchQuery ?? this.searchQuery,
    selectedWorkerForFicha: selectedWorkerForFicha != null
        ? selectedWorkerForFicha()
        : this.selectedWorkerForFicha,
  );
}

class PersonnelNotifier extends StateNotifier<PersonnelState> {
  PersonnelNotifier(this._ref) : super(PersonnelState(workers: _seedWorkers)) {
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
    final store = _currentStore;
    if (store == null) return;
    final rows = store.rows('personal');
    if (rows.isNotEmpty && mounted) {
      final loaded = rows.map((r) => Worker.fromMap(r)).toList();
      state = state.copyWith(workers: loaded);
    }
  }

  @override
  void dispose() {
    _storeSub?.close();
    _currentStore?.removeListener(_syncWithAppStore);
    super.dispose();
  }

  void setFilter(String filter) {
    state = state.copyWith(statusFilter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim());
  }

  void openFicha(Worker worker) {
    state = state.copyWith(selectedWorkerForFicha: () => worker);
  }

  void closeFicha() {
    state = state.copyWith(selectedWorkerForFicha: () => null);
  }

  Future<void> addWorker(Worker newWorker) async {
    final updated = [newWorker, ...state.workers];
    state = state.copyWith(workers: updated);
    final store = _currentStore ?? _ref.read(appStoreProvider);
    if (store != null) {
      await store.save('personal', newWorker.toMap());
    }
  }

  Future<void> updateWorker(Worker updatedWorker) async {
    final updated = state.workers.map((w) {
      return w.id == updatedWorker.id ? updatedWorker : w;
    }).toList();

    state = state.copyWith(
      workers: updated,
      selectedWorkerForFicha: state.selectedWorkerForFicha?.id == updatedWorker.id
          ? () => updatedWorker
          : null,
    );

    final store = _currentStore ?? _ref.read(appStoreProvider);
    if (store != null) {
      await store.save('personal', updatedWorker.toMap());
    }
  }

  Future<void> toggleActive(String id) async {
    Worker? updatedTarget;
    final updated = state.workers.map((w) {
      if (w.id == id) {
        updatedTarget = w.copyWith(activo: !w.activo);
        return updatedTarget!;
      }
      return w;
    }).toList();

    state = state.copyWith(
      workers: updated,
      selectedWorkerForFicha: updatedTarget != null ? () => updatedTarget : null,
    );

    if (updatedTarget != null) {
      final store = _currentStore ?? _ref.read(appStoreProvider);
      if (store != null) {
        await store.save('personal', updatedTarget!.toMap());
      }
    }
  }

  Future<void> deleteWorker(String id) async {
    final target = state.workers.firstWhere((w) => w.id == id, orElse: () => state.workers.first);
    final updated = state.workers.where((w) => w.id != id).toList();
    state = state.copyWith(
      workers: updated,
      selectedWorkerForFicha: () => null,
    );

    final store = _currentStore ?? _ref.read(appStoreProvider);
    if (store != null) {
      await store.remove('personal', target.toMap());
    }
  }

  static const List<Worker> _seedWorkers = [
    Worker(id: "ca3fb2b3-6fb3-5e50-afae-06238a1f44be", activo: true, nombre: "Aldemar Leonel", apPaterno: "cha", apMaterno: "M", cargo: "Operario", dni: "72149810", telefono: "984729103"),
    Worker(id: "46bf853f-f2d3-5139-b666-e14c3451dc9e", activo: true, nombre: "Alejandra", apPaterno: "Chambi", apMaterno: "Sucasaca", cargo: "Operario", dni: "74839201", telefono: "951839204"),
    Worker(id: "9f4bde98-48ae-5bf1-a770-619aab95a7af", activo: true, nombre: "Amelia Evelyn", apPaterno: "Ticona", apMaterno: "Pari", cargo: "Operario", dni: "60177245", telefono: "904850808"),
    Worker(id: "e0a333ee-eda3-5852-b68a-14aa6930e264", activo: true, nombre: "Belen", apPaterno: "Sucasaca", apMaterno: "Quispe", cargo: "Operario", dni: "71938472", telefono: "961829384"),
    Worker(id: "2596ae9d-bc77-522c-9191-b2e967dc0647", activo: true, nombre: "Brenda", apPaterno: "Coaquira", apMaterno: "Ramos", cargo: "Operario", dni: "76541298", telefono: "971829384"),
    Worker(id: "1656d9a3-eaa7-5e09-9f3f-9f27795843f9", activo: true, nombre: "Delfin Estanis", apPaterno: "Roque", apMaterno: "Mullisaca", cargo: "Maquinista", dni: "71505474", telefono: "963165439"),
    Worker(id: "c19b5690-3158-5eb9-b0ab-97ceda90e8b4", activo: true, nombre: "Diana", apPaterno: "Panca", apMaterno: "Belizario", cargo: "Operario", dni: "73219845", telefono: "981293847"),
    Worker(id: "744d5d34-0876-5571-bce2-1521a434e448", activo: true, nombre: "Diane Esther", apPaterno: "Mamani", apMaterno: "Maraza", cargo: "Operario", dni: "70928374", telefono: "951928374"),
    Worker(id: "e5f494c1-6d4a-553c-9674-1f340a7b36a3", activo: true, nombre: "Diego", apPaterno: "Rivera", apMaterno: "B", cargo: "Operario", dni: "74928172", telefono: "971928374"),
    Worker(id: "836cf82d-6731-5019-9d32-f698dae51602", activo: true, nombre: "Edu J", apPaterno: "Quispe", apMaterno: "Puma", cargo: "Operario", dni: "75502135", telefono: "981928374"),
    Worker(id: "c26bfdf3-dac7-5450-9e5b-a71952e3ed8b", activo: true, nombre: "Edwin carita", apPaterno: "Carita", apMaterno: "Smari", cargo: "Operario", dni: "70392819", telefono: "961928374"),
    Worker(id: "7d5d2a65-2a27-50a6-89f0-c845d219d935", activo: true, nombre: "Elizabeth", apPaterno: "Chambi", apMaterno: "Flores", cargo: "Operario", dni: "75839201", telefono: "951928375"),
    Worker(id: "1416bbf1-76c9-5f4b-86e9-71bae01b8f18", activo: true, nombre: "Emmanel E", apPaterno: "Quispe", apMaterno: "Sucari", cargo: "Operario", dni: "73829102", telefono: "981928376"),
    Worker(id: "aae84532-608d-5e10-9812-34f54b4ac01b", activo: true, nombre: "Evelyn kelly", apPaterno: "Marcedo", apMaterno: "Equise", cargo: "Operario", dni: "71029384", telefono: "971928376"),
    Worker(id: "37d72b43-c289-5f43-966c-6c5f5a2539fe", activo: true, nombre: "Genoveva", apPaterno: "Turpo", apMaterno: "TY", cargo: "Operario", dni: "70293847", telefono: "961928376"),
    Worker(id: "fe4a8ed9-6423-5a53-baea-fe31ae0e87e3", activo: true, nombre: "Ismael", apPaterno: "Mamani", apMaterno: "Mamani", cargo: "Operario", dni: "76584930", telefono: "951928377"),
    Worker(id: "0c7829a8-c706-57e8-85ea-bea33957180d", activo: true, nombre: "Jhon Alex", apPaterno: "Quispe", apMaterno: "Puma", cargo: "Ingeniero", dni: "75502136", telefono: "981928377"),
    Worker(id: "11c503cd-ea12-5d00-b27b-a0cff822b212", activo: true, nombre: "Juan Carlos", apPaterno: "a", apMaterno: "s", cargo: "Operario", dni: "72938475", telefono: "971928377"),
    Worker(id: "b434f5cb-8f9f-572e-80ec-1f441a419607", activo: true, nombre: "Juan Jose", apPaterno: "Nuñoa", apMaterno: "Suyo", cargo: "Operario", dni: "71029382", telefono: "961928377"),
    Worker(id: "1ebc5a0f-e170-52b6-99b6-a3db03a33148", activo: true, nombre: "Leydi Estefany", apPaterno: "Caceres", apMaterno: "Quispe", cargo: "Operario", dni: "73928174", telefono: "951928378"),
    Worker(id: "83c114de-eef7-5d30-b195-74db6709c09d", activo: true, nombre: "Lily", apPaterno: "yerba", apMaterno: "Quispe", cargo: "Operario", dni: "72839401", telefono: "981928378"),
    Worker(id: "5c075c99-f126-5fab-a2a6-a93bb26dbf9c", activo: true, nombre: "Luz Noelia", apPaterno: "Flores", apMaterno: "Arias", cargo: "Operario", dni: "74839205", telefono: "971928378"),
    Worker(id: "78442442-8aef-53a6-9692-a9d07e4ac910", activo: true, nombre: "Marco", apPaterno: "Mamani", apMaterno: "Miranda", cargo: "Operario", dni: "71928374", telefono: "961928378"),
    Worker(id: "afb95ade-b1c8-5abf-a9e1-2bbe3d81b431", activo: true, nombre: "Mariela", apPaterno: "Mendoza", apMaterno: "Puma", cargo: "Operario", dni: "70293819", telefono: "951928379"),
    Worker(id: "7b0f11a2-13b0-59e4-91a1-d9293c421de2", activo: true, nombre: "Marily Liz", apPaterno: "Quispe", apMaterno: "Mamani", cargo: "Operario", dni: "75839204", telefono: "981928379"),
    Worker(id: "ddd37ed1-c590-5977-9a57-5187bbcef2cc", activo: true, nombre: "Marisol", apPaterno: "Huacasi", apMaterno: "Mamani", cargo: "Operario", dni: "74928103", telefono: "971928379"),
    Worker(id: "c773ba76-9251-534c-b44a-98573d73a29b", activo: true, nombre: "Mary Luz", apPaterno: "Laura", apMaterno: "Chirinos", cargo: "Operario", dni: "71029385", telefono: "961928379"),
    Worker(id: "11e27f20-c871-55b2-a3e1-4069b6e188ac", activo: true, nombre: "Mayomy Roxana", apPaterno: "Ccalla", apMaterno: "C", cargo: "Operario", dni: "72938471", telefono: "951928380"),
    Worker(id: "b63408f0-ae4f-5662-b329-cfa56bb6e013", activo: true, nombre: "Miguel", apPaterno: "Zapana", apMaterno: "Puma", cargo: "Operario", dni: "73829104", telefono: "981928380"),
    Worker(id: "74eb5e4d-263f-5c1a-8061-6b1f0321b133", activo: true, nombre: "Milagros", apPaterno: "calderon", apMaterno: "Ojera", cargo: "Operario", dni: "76543210", telefono: "971928380"),
    Worker(id: "e5bace15-c502-50bb-8915-1165753414ea", activo: true, nombre: "Miriam", apPaterno: "Tito", apMaterno: "Sanca", cargo: "Supervisor", dni: "70192837", telefono: "961928380"),
    Worker(id: "3b786555-ca49-51e3-8afa-877c3802cf01", activo: true, nombre: "Miriam", apPaterno: "Quispe", apMaterno: "Coaquira", cargo: "Operario", dni: "74920193", telefono: "951928381"),
    Worker(id: "27a184be-bc1e-575c-b8f3-cfa4d37f038f", activo: true, nombre: "Niflin  Alan", apPaterno: "ccari", apMaterno: "Quispe", cargo: "Operario", dni: "73829105", telefono: "981928381"),
    Worker(id: "2c18aee3-5b6c-5458-9b4a-78a40af6102d", activo: true, nombre: "Saul", apPaterno: "Sucari", apMaterno: "Huanca", cargo: "Operario", dni: "71029386", telefono: "971928381"),
    Worker(id: "e50ed02b-15e7-5b79-b419-d4b9ff179935", activo: true, nombre: "shaleira gomez", apPaterno: "Gomez", apMaterno: "Sile", cargo: "Operario", dni: "75839205", telefono: "961928381"),
    Worker(id: "2ed79abc-1650-571a-853e-cac1db1c116a", activo: true, nombre: "Silvia E", apPaterno: "Mamani", apMaterno: "Zea", cargo: "Operario", dni: "72938472", telefono: "951928382"),
    Worker(id: "14a27dfc-7310-57c6-bd62-0eb31bed4820", activo: true, nombre: "Sugely", apPaterno: "Humpire", apMaterno: "Humpire", cargo: "Operario", dni: "74839206", telefono: "981928382"),
    Worker(id: "8ad2fa15-38bb-5b2e-9b9a-c3f66bd522d5", activo: true, nombre: "Ubaldo", apPaterno: "Huaccachi", apMaterno: "Borda", cargo: "Operario", dni: "70192838", telefono: "971928382"),
    Worker(id: "09aa90b1-ff4a-5074-be9f-cbca85a70da1", activo: true, nombre: "Vianet", apPaterno: "Charca", apMaterno: "Mamani", cargo: "Operario", dni: "73928175", telefono: "961928382"),
    Worker(id: "78cbfe55-03ff-5381-9678-701641e48a31", activo: true, nombre: "Wilmer Henry", apPaterno: "Ccallohuanca", apMaterno: "Condori", cargo: "Operario", dni: "76543211", telefono: "951928383"),
    Worker(id: "a5e37607-e61c-5381-bea1-702303a4242c", activo: true, nombre: "Wilson", apPaterno: "Muchico", apMaterno: "Jove", cargo: "Operario", dni: "71928375", telefono: "981928383"),
    Worker(id: "8f190d3f-9893-5e21-823e-a11c62d81ada", activo: true, nombre: "Yolanda CASAZOLA", apPaterno: "Cazasola", apMaterno: "Mamani", cargo: "Operario", dni: "75839206", telefono: "971928383"),
    Worker(id: "22d2e2a5-6983-5b55-b009-ef8fa45b1a75", activo: true, nombre: "Yolanda CONDORI", apPaterno: "Condori", apMaterno: "Ramos", cargo: "Operario", dni: "74928104", telefono: "961928383"),
    Worker(id: "ea7af948-0e5b-5424-8bec-32886f6a60b5", activo: true, nombre: "Yoselin Diana", apPaterno: "Panca", apMaterno: "Belizario", cargo: "Operario", dni: "71029387", telefono: "951928384"),
    Worker(id: "170733e1-bb01-58a9-97c2-1be7b40f8b19", activo: true, nombre: "yudith calisaya", apPaterno: "Calisaya", apMaterno: "Machaca", cargo: "Operario", dni: "72938473", telefono: "981928384"),
    Worker(id: "4ef9cb20-d657-5772-8fc7-656cfebd52f7", activo: true, nombre: "Yudith Mrgoth", apPaterno: "", apMaterno: "M", cargo: "Operario", dni: "73829106", telefono: "971928384"),
  ];
}

final personnelProvider = StateNotifierProvider<PersonnelNotifier, PersonnelState>((ref) {
  return PersonnelNotifier(ref);
});
