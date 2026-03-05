import 'package:isar/isar.dart';

part 'perfil_usuario.g.dart';

@collection
class PerfilUsuario {
  Id id = Isar.autoIncrement;

  List<String> carrerasSeleccionadas = [];

  List<String> materiasAprobadas = [];
}
