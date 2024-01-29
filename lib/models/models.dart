class Usuario {
  String? id;
  String? nombre;
  String? email;
  String? password;
  DateTime? fechaRegistro;

  Usuario(
      {this.id, this.nombre, this.email, this.password, this.fechaRegistro});

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['_id'],
        nombre: json['nombre'],
        email: json['email'],
        password: json['password'],
        fechaRegistro: json['fecha_registro'] == null
            ? null
            : DateTime.parse(json['fecha_registro']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'nombre': nombre,
        'email': email,
        'password': password,
        'fecha_registro': fechaRegistro?.toIso8601String(),
      };
}

class EntradaDiario {
  String? id;
  String? usuarioId;
  String? titulo;
  String? contenido;
  List<String>? etiquetas;
  DateTime? fechaCreacion;

  EntradaDiario(
      {this.id,
      this.usuarioId,
      this.titulo,
      this.contenido,
      this.etiquetas,
      this.fechaCreacion});

  factory EntradaDiario.fromJson(Map<String, dynamic> json) => EntradaDiario(
        id: json['_id'],
        usuarioId: json['usuario_id'],
        titulo: json['titulo'],
        contenido: json['contenido'],
        etiquetas: List<String>.from(json['etiquetas'] ?? []),
        fechaCreacion: json['fecha_creacion'] == null
            ? null
            : DateTime.parse(json['fecha_creacion']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'usuario_id': usuarioId,
        'titulo': titulo,
        'contenido': contenido,
        'etiquetas': etiquetas,
        'fecha_creacion': fechaCreacion?.toIso8601String(),
      };
}

class Habito {
  String? id;
  String? usuarioId;
  String habito;
  DateTime? fecha;
  bool completado;

  Habito(
      {this.id,
      this.usuarioId,
      required this.habito,
      this.fecha,
      required this.completado});

  factory Habito.fromJson(Map<String, dynamic> json) => Habito(
        id: json['_id'],
        usuarioId: json['usuario_id']?['_id'],
        habito: json['habito'],
        fecha: json['fecha'] == null ? null : DateTime.parse(json['fecha']),
        completado: json['completado'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'usuario_id': usuarioId,
        'habito': habito,
        'fecha': fecha?.toIso8601String(),
        'completado': completado,
      };
}

class EstadoAnimo {
  String? id;
  String? usuarioId;
  String estadoAnimo;
  DateTime? fecha;

  EstadoAnimo({this.id, this.usuarioId,  required this.estadoAnimo, this.fecha});

  factory EstadoAnimo.fromJson(Map<String, dynamic> json) => EstadoAnimo(
        id: json['_id'],
        usuarioId: json['usuario_id'],
        estadoAnimo: json['estado_animo'],
        fecha: json['fecha'] == null ? null : DateTime.parse(json['fecha']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'usuario_id': usuarioId,
        'estado_animo': estadoAnimo,
        'fecha': fecha?.toIso8601String(),
      };
}
