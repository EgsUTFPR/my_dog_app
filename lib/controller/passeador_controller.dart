// ...existing code...
import 'package:flutter/foundation.dart';
import 'package:my_dog_app/models/passeador_model.dart';
import 'package:my_dog_app/service/passeador_service.dart';

class PasseadorController extends ChangeNotifier {
  final PasseadorService _service = PasseadorService();

  Passeador? _passeadorAtual;
  bool _carregando = false;

  Passeador? get passeadorAtual => _passeadorAtual;
  bool get carregando => _carregando;

  String? validarNome(String? nome) {
    if (nome == null || nome.isEmpty) return 'O nome não pode estar vazio';
    return null;
  }

  String? validarEmail(String? email) {
    if (email == null || email.isEmpty) return 'O email não pode estar vazio';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Formato de email inválido';
    }
    return null;
  }

  String? validarTelefone(String? telefone) {
    if (telefone == null || telefone.isEmpty) {
      return 'O telefone não pode estar vazio';
    }
    if (!RegExp(r'^\d{10,11}$').hasMatch(telefone)) {
      return 'Formato de telefone inválido';
    }
    return null;
  }



  // Carrega o passeador pelo email (usa service que consulta Firestore)
  Future<void> carregarPasseador(String email) async {
    _carregando = true;
    notifyListeners();

    try {
      final resultado = await _service.buscarPasseadorPorEmail(email);
      _passeadorAtual = resultado;
    } catch (e) {
      _passeadorAtual = null;
      debugPrint('Erro ao carregar passeador: $e');
    }

    _carregando = false;
    notifyListeners();
  }

  // Atualiza o passeador no Firestore
  Future<void> atualizarPasseador(Passeador passeadorAtualizado) async {
    _carregando = true;
    notifyListeners();

    try {
      await _service.atualizarPasseador(passeadorAtualizado);
      _passeadorAtual = passeadorAtualizado;
    } catch (e) {
      debugPrint('Erro no controller ao atualizar passeador: $e');
    }

    _carregando = false;
    notifyListeners();
  }

  void logout() {
    _passeadorAtual = null;
    notifyListeners();
  }
}
