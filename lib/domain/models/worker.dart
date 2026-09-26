class Worker {
  const Worker({
    required this.id,
    required this.nombre,
    required this.apPaterno,
    this.apMaterno = '',
    this.cargo = 'Operario',
    this.dni,
    this.telefono,
    this.direccion,
    this.activo = true,
  });

  final String id;
  final String nombre;
  final String apPaterno;
  final String apMaterno;
  final String cargo;
  final String? dni;
  final String? telefono;
  final String? direccion;
  final bool activo;

  String get fullName {
    final mat = apMaterno.trim();
    return '$nombre $apPaterno${mat.isNotEmpty ? ' $mat' : ''}'.trim();
  }

  String get initials {
    final n = nombre.trim().isNotEmpty ? nombre.trim()[0] : '';
    final p = apPaterno.trim().isNotEmpty ? apPaterno.trim()[0] : '';
    return '$n$p'.toUpperCase();
  }

  Worker copyWith({
    String? id,
    String? nombre,
    String? apPaterno,
    String? apMaterno,
    String? cargo,
    String? dni,
    String? telefono,
    String? direccion,
    bool? activo,
  }) => Worker(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    apPaterno: apPaterno ?? this.apPaterno,
    apMaterno: apMaterno ?? this.apMaterno,
    cargo: cargo ?? this.cargo,
    dni: dni ?? this.dni,
    telefono: telefono ?? this.telefono,
    direccion: direccion ?? this.direccion,
    activo: activo ?? this.activo,
  );

  Map<String, dynamic> toMap() => {
    'id_trabajador': id,
    'nombre': nombre,
    'apellido_paterno': apPaterno,
    'apellido_materno': apMaterno,
    'cargo': cargo,
    'dni': dni,
    'telefono': telefono,
    'direccion': direccion,
    'activo': activo,
  };

  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker(
      id: (map['id_trabajador'] ?? map['id'] ?? '') as String,
      nombre: (map['nombre'] ?? '') as String,
      apPaterno: (map['apellido_paterno'] ?? map['apPaterno'] ?? '') as String,
      apMaterno: (map['apellido_materno'] ?? map['apMaterno'] ?? '') as String,
      cargo: (map['cargo'] ?? 'Operario') as String,
      dni: map['dni']?.toString(),
      telefono: map['telefono']?.toString(),
      direccion: map['direccion']?.toString(),
      activo: map['activo'] != false,
    );
  }
}
