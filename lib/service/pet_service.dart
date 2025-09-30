import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/pet_model.dart';

class PetService {
  final String donoEmail;

  PetService(this.donoEmail);

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'pets_${donoEmail.replaceAll('@', '_')}.json';
    return '${dir.path}/$fileName';
  }

  Future<List<Pet>> carregarPets() async {
    try {
      final path = await _getFilePath();
      final file = File(path);

      if (!await file.exists()) {
        await file.writeAsString('[]');
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Pet.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao carregar pets: $e');
      return [];
    }
  }

  Future<void> salvarPets(List<Pet> pets) async {
    final path = await _getFilePath();
    final file = File(path);
    final jsonString = json.encode(pets.map((p) => p.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}
