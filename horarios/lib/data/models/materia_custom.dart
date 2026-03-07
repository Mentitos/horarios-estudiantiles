import 'package:isar/isar.dart';

part 'materia_custom.g.dart';

@collection
class MateriaCustom {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? materiaId;

  String? nombrePersonalizado;
  bool estaOculta = false;

  bool esAgregadaLocalmente = false;
  String? carreraAsociada;
}
