import 'dart:io';

void main() {
  final dir = Directory('lib/data/models');
  final maxSafe = 9007199254740991;
  final minSafe = -maxSafe;
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.g.dart'));

  int count = 0;
  for (var file in files) {
    var text = file.readAsStringSync();
    var newText = text.replaceAllMapped(RegExp(r'(id:\s*)(-?\d+)(,)'), (m) {
      if (m.group(2) == null) return m.group(0)!;
      var val = int.tryParse(m.group(2)!);
      if (val == null) return m.group(0)!;

      if (val > maxSafe || val < minSafe) {
        var newVal = val.toString();
        // Truncate the string to 15 characters to ensure it fits comfortably within safe max (16 digits)
        final isNegative = newVal.startsWith('-');
        final targetLength = isNegative ? 16 : 15;
        if (newVal.length > targetLength) {
          newVal = newVal.substring(0, targetLength);
        }
        return '${m.group(1)}$newVal${m.group(3)}';
      }
      return m.group(0)!;
    });

    if (text != newText) {
      file.writeAsStringSync(newText);
      // ignore: avoid_print
      print('Patched ${file.path}');
      count++;
    }
  }
  // ignore: avoid_print
  print('Patching complete. Modified $count files.');
}
