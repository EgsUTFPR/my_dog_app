import 'package:my_dog_app/service/passeador_service.dart';

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

  Future<Passeador> atualizarPasseadorController(
    Passeador passeadorAtual,
  ) async {
    await atualizarPasseador(passeadorAtual);
    return passeadorAtual;
  }

  // Recuperar apenas o passeador logado pelo email
  Future<Passeador?> carregarPasseador(String email) async {
    final lista = await _service.carregarPasseadores();
    try {
      return lista.firstWhere((p) => p.email == email);
    } catch (e) {
      return null;
    }
  }

  Future<void> atualizarPasseador(Passeador passeadorAtualizado) async {
    final passeador = await _service.carregarPasseadores();
    final index = passeador.indexWhere(
      (d) => d.email == passeadorAtualizado.email,
    );
    if (index != -1) {
      passeador[index] = passeadorAtualizado;
      await _service.salvarPasseadores(passeador);
    }
  }

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
}
