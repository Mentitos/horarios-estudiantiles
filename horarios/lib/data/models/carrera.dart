import 'package:isar/isar.dart';

part 'carrera.g.dart';

@collection
class Carrera {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? nombre;

  List<String> materiasIds = [];
}
