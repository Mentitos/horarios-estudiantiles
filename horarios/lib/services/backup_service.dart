import 'dart:io';
import 'dart:convert';
import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/sources/local_datasource.dart';

class BackupService {
  static const String _eventosKey = 'eventos_calendario';
  static const String _profesoresKey = 'profesores_data';

  Future<bool> exportarBackup() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbFile = File('${dir.path}/default.isar');

      if (!await dbFile.exists()) {
        return false;
      }

      // Leer eventos de SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final eventosJson = prefs.getString(_eventosKey) ?? '[]';
      final profesoresJson = prefs.getString(_profesoresKey) ?? '[]';

      // Crear un ZIP con la DB + los eventos + los profesores
      final encoder = ZipFileEncoder();
      final tempDir = await getTemporaryDirectory();
      final zipPath = '${tempDir.path}/Mis_Horarios.horarios';

      encoder.create(zipPath);
      encoder.addFile(dbFile, 'default.isar');

      // Agregar eventos como archivo JSON dentro del ZIP
      final eventosFile = File('${tempDir.path}/eventos.json');
      await eventosFile.writeAsString(eventosJson);
      encoder.addFile(eventosFile, 'eventos.json');

      // Agregar profesores como archivo JSON dentro del ZIP
      final profesoresFile = File('${tempDir.path}/profesores.json');
      await profesoresFile.writeAsString(profesoresJson);
      encoder.addFile(profesoresFile, 'profesores.json');

      encoder.close();

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(zipPath)],
          text: 'Copia de seguridad de Mis Horarios (incluye calendario)',
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> importarBackup() async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'Copias de seguridad de Horarios (.horarios)',
      );
      final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

      if (file == null) {
        return 'Cancelado por el usuario';
      }

      return await importarBackupDesdePath(file.path);
    } catch (e) {
      return 'Error al restaurar: $e';
    }
  }

  Future<String> importarBackupDesdePath(String filePath) async {
    try {
      final sourceFile = File(filePath);
      if (!await sourceFile.exists()) {
        return 'El archivo seleccionado no existe';
      }

      if (await sourceFile.length() < 100) {
        return 'El archivo es demasiado pequeño para ser una copia válida';
      }

      await LocalDatasource().cerrarConexion();

      final dir = await getApplicationDocumentsDirectory();

      // Intentar descomprimir como ZIP (formato nuevo con eventos)
      try {
        final bytes = await sourceFile.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);

        bool dbRestored = false;
        String? eventosJsonStr;
        String? profesoresJsonStr;

        for (final file in archive) {
          if (file.isFile) {
            if (file.name == 'default.isar') {
              final outFile = File('${dir.path}/default.isar');
              await outFile.writeAsBytes(file.content as List<int>);
              dbRestored = true;
            } else if (file.name == 'eventos.json') {
              eventosJsonStr =
                  utf8.decode(file.content as List<int>);
            } else if (file.name == 'profesores.json') {
              profesoresJsonStr =
                  utf8.decode(file.content as List<int>);
            }
          }
        }

        if (!dbRestored) {
          return 'El archivo ZIP no contiene una base de datos válida';
        }

        // Restaurar eventos al SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        if (eventosJsonStr != null) {
          await prefs.setString(_eventosKey, eventosJsonStr);
        }
        if (profesoresJsonStr != null) {
          await prefs.setString(_profesoresKey, profesoresJsonStr);
        }

        SystemNavigator.pop();
        return 'OK';
      } catch (_) {
        // Si falla como ZIP, intentar como DB directa (formato viejo .isar plano)
        final targetFile = File('${dir.path}/default.isar');
        await sourceFile.copy(targetFile.path);
        SystemNavigator.pop();
        return 'OK';
      }
    } catch (e) {
      return 'Error al restaurar desde archivo: $e';
    }
  }
}
