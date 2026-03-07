import 'package:isar/isar.dart';

part 'horario_usuario.g.dart';

@collection
class HorarioUsuario {
  Id id = Isar.autoIncrement;

  String? titulo;
  DateTime? fechaActualizacion;

  List<MateriaSeleccionada> materiasSeleccionadas = [];
}

@embedded
class MateriaSeleccionada {
  String? materiaId;
  String? materiaNombre;
  int? colorARGB;

  List<String> profesores = [];
  String? aula;

  List<BloqueHorario> bloques = [];
  String? notas;
}

@embedded
class BloqueHorario {
  String? dia;
  String? horaInicio;
  String? horaFin;
  String? aula;
}
