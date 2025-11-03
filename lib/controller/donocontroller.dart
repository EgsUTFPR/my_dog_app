import 'package:flutter/foundation.dart';
import 'package:my_dog_app/models/dono_model.dart';
import 'package:my_dog_app/service/dono_service.dart';

class DonoController extends ChangeNotifier {
  final DonoService donoService = DonoService();

  Dono? _donoAtual;
  bool _carregando = false;

  Dono? get donoAtual => _donoAtual;
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

  String? validarEndereco(String? endereco) {
    if (endereco == null || endereco.isEmpty) {
      return 'O endereço não pode estar vazio';
    }
    return null;
  }

  String? validarSenha(String? senha) {
    if (senha == null || senha.isEmpty) {
      return "Campo obrigatório.";
    }
    return null;
  }

  Future<void> carregarDono(String email) async {
  _carregando = true;
  notifyListeners();

  final query = await donoService.buscarDonoPorEmail(email);

  if (query != null) {
    _donoAtual = query; // já terá o id vindo do service
  }

  _carregando = false;
  notifyListeners();
}


  Future<void> atualizarDono(Dono donoAtualizado) async {
  _carregando = true;
  notifyListeners();

  try {
    await donoService.atualizarDono(donoAtualizado);
    _donoAtual = donoAtualizado;
  } catch (e) {
    print("Erro no controller ao atualizar dono: $e");
  }

  _carregando = false;
  notifyListeners();
}

}
