import 'package:flutter/foundation.dart';
import 'package:my_dog_app/service/passeador_service.dart';
import '../models/passeador_model.dart';

class PasseadorController extends ChangeNotifier {
  final PasseadorService _service = PasseadorService();

  Passeador? _passeadorAtual;
  bool _carregando = false;

  Passeador? get passeadorAtual => _passeadorAtual;
  bool get carregando => _carregando;

  // ===============================
  // Métodos principais
  // ===============================

  Future<void> carregarTodosPasseadores() async {
    _carregando = true;
    notifyListeners();

    await _service.carregarPasseadores();

    _carregando = false;
    notifyListeners();
  }

  Future<void> cadastrarPasseador(Passeador passeador) async {
    _carregando = true;
    notifyListeners();

    await _service.adicionarPasseador(passeador);

    _carregando = false;
    notifyListeners();
  }

  // Recuperar apenas o passeador logado pelo email
  Future<void> carregarPasseador(String email) async {
    _carregando = true;
    notifyListeners();

    final lista = await _service.carregarPasseadores();
    try {
      _passeadorAtual = lista.firstWhere((p) => p.email == email);
    } catch (_) {
      _passeadorAtual = null;
    }

    _carregando = false;
    notifyListeners();
  }

  Future<void> atualizarPasseador(Passeador passeadorAtualizado) async {
    _carregando = true;
    notifyListeners();

    final passeadores = await _service.carregarPasseadores();
    final index = passeadores.indexWhere(
      (p) => p.email == passeadorAtualizado.email,
    );

    if (index != -1) {
      passeadores[index] = passeadorAtualizado;
      await _service.salvarPasseadores(passeadores);
      _passeadorAtual = passeadorAtualizado;
    }

    _carregando = false;
    notifyListeners();
  }

  // ===============================
  // Validações
  // ===============================
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

  // ===============================
  // Outros utilitários
  // ===============================
  void logout() {
    _passeadorAtual = null;
    notifyListeners();
  }
}
