import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:my_dog_app/models/dono_model.dart';

class DonoService {
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/donos.json');
  }

  Future<List<Dono>> lerDonos() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];

      final conteudo = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(conteudo);

      return jsonData.map((e) => Dono.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> salvarDonos(List<Dono> donos) async {
    final file = await _getFile();
    final jsonData = donos.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }
}
