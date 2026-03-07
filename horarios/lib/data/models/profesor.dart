class Profesor {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String correo;
  final String direccion;
  final String? rutaImagen;
  final String sitioWeb;

  Profesor({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
    required this.direccion,
    this.rutaImagen,
    required this.sitioWeb,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'correo': correo,
      'direccion': direccion,
      'rutaImagen': rutaImagen,
      'sitioWeb': sitioWeb,
    };
  }

  factory Profesor.fromJson(Map<String, dynamic> json) {
    return Profesor(
      id: json['id'] as String,
      nombre: json['nombre'] as String? ?? '',
      apellido: json['apellido'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      direccion: json['direccion'] as String? ?? '',
      rutaImagen: json['rutaImagen'] as String?,
      sitioWeb: json['sitioWeb'] as String? ?? '',
    );
  }

  String get nombreCompleto {
    if (nombre.isNotEmpty && apellido.isNotEmpty) {
      return '$nombre $apellido'.trim();
    } else if (nombre.isNotEmpty) {
      return nombre.trim();
    } else {
      return apellido.trim();
    }
  }
}
