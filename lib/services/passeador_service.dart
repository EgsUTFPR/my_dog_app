import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/passeador_model.dart';


class PasseadorService {
  // Caminho do arquivo JSON
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/passeadores.json';
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(path);
  }

  // Ler todos os passeadores do JSON
  Future<List<Passeador>> carregarPasseadores() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) {
        await file.writeAsString('[]'); // cria arquivo vazio se não existir
      }

      final content = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(content);

      return jsonData.map((p) => Passeador.fromJson(p)).toList();
    } catch (e) {
      print('Erro ao carregar passeadores: $e');
      return [];
    }
  }

  // Salvar todos os passeadores no JSON
  Future<void> salvarPasseadores(List<Passeador> passeadores) async {
    final file = await _localFile;
    final jsonData = jsonEncode(passeadores.map((p) => p.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  // Adicionar um novo passeador
  Future<void> adicionarPasseador(Passeador passeador) async {
    final lista = await carregarPasseadores();
    lista.add(passeador);
    await salvarPasseadores(lista);
  }

  // Atualizar dados de um passeador
  Future<void> atualizarPasseador(Passeador passeador) async {
    final lista = await carregarPasseadores();
    final index = lista.indexWhere((p) => p.email == passeador.email);
    if (index != -1) {
      lista[index] = passeador;
      await salvarPasseadores(lista);
    }
  }

  // Adicionar passeio na agenda do passeador
 

}
