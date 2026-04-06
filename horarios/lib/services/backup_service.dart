import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:share_plus/share_plus.dart';
import '../data/sources/local_datasource.dart';

class BackupService {
  Future<bool> exportarBackup() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbFile = File('${dir.path}/default.isar');

      if (!await dbFile.exists()) {
        return false;
      }

      final tempDir = await getTemporaryDirectory();
      final copyFile = File(
        '${tempDir.path}/Copia_Seguridad_Horarios_UNGS.bak',
      );
      await dbFile.copy(copyFile.path);

      await Share.shareXFiles([
        XFile(copyFile.path),
      ], text: 'Copia de seguridad de Mis Horarios');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> importarBackup() async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'Archivos de base de datos Isar (.bak, .isar)',
      );
      final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

      if (file == null) {
        return 'Cancelado por el usuario';
      }

      final sourceFile = File(file.path);
      if (!await sourceFile.exists()) {
        return 'El archivo seleccionado no existe';
      }

      if (await sourceFile.length() < 100) {
        return 'El archivo es demasiado pequeño para ser una base de datos válida';
      }
      final cerrado = await LocalDatasource().cerrarConexion();
      if (!cerrado) {
        return 'No se pudo cerrar la base de datos actual para reemplazarla.';
      }

      final dir = await getApplicationDocumentsDirectory();
      final targetFile = File('${dir.path}/default.isar');

      await sourceFile.copy(targetFile.path);

      SystemNavigator.pop();
      return 'OK';
    } catch (e) {
      return 'Error al restaurar: $e';
    }
  }
}
