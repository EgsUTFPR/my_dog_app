import 'package:my_dog_app/services/passeador_service.dart';
import '../models/passeador_model.dart';



class PasseadorController {
  final PasseadorService _service = PasseadorService();

  // ===============================
  // Métodos principais
  // ===============================

  Future<List<Passeador>> carregarTodosPasseadores() async {
    return await _service.carregarPasseadores();
  }

  Future<void> cadastrarPasseador(Passeador passeador) async {
    await _service.adicionarPasseador(passeador);
  }

  Future<void> atualizarPasseador(Passeador passeador) async {
    await _service.atualizarPasseador(passeador);
  }



  // Recuperar apenas o passeador logado pelo email
  Future<Passeador?> carregarPasseadorLogado(String email) async {
    final lista = await _service.carregarPasseadores();
    try {
      return lista.firstWhere((p) => p.email == email);
    } catch (e) {
      return null;
    }
  }
}
