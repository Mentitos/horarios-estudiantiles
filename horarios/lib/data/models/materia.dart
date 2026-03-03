import 'package:isar/isar.dart';

part 'materia.g.dart';

@collection
class Materia {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? materiaId;

  String? nombre;
}
