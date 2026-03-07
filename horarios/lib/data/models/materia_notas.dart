import 'package:isar/isar.dart';

part 'materia_notas.g.dart';

@collection
class MateriaNotas {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String materiaId;

  String contenido;

  DateTime ultimaActualizacion;

  MateriaNotas({
    required this.materiaId,
    required this.contenido,
    required this.ultimaActualizacion,
  });
}
