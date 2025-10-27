import 'package:flutter/foundation.dart';
import 'package:my_dog_app/models/dono_model.dart';
import 'package:my_dog_app/service/dono_service.dart';
import 'package:my_dog_app/service/passeador_service.dart';

class DonoController extends ChangeNotifier {
  final DonoService donoService = DonoService();
  final PasseadorService passeadorService = PasseadorService();

  // =======================
  // ESTADO INTERNO
  // =======================
  Dono? _donoAtual;
  bool _carregando = false;

  Dono? get donoAtual => _donoAtual;
  bool get carregando => _carregando;

  // =======================
  // Métodos de validação
  // =======================
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

  // =======================
  // LOGIN
  // =======================
  Future<dynamic> verificarLogin(String email, String senha) async {
    _carregando = true;
    notifyListeners();

    final donosExistentes = await donoService.lerDonos();

    for (var d in donosExistentes) {
      if (d.email == email && d.senha == senha) {
        _donoAtual = d;
        _carregando = false;
        notifyListeners();
        return d;
      }
    }

    final passeadoresExistentes = await passeadorService.carregarPasseadores();

    for (var passeador in passeadoresExistentes) {
      if (passeador.email == email && passeador.senha == senha) {
        _carregando = false;
        notifyListeners();
        return passeador;
      }
    }

    _carregando = false;
    notifyListeners();
    return null;
  }

  // =======================
  // CRUD com JSON
  // =======================

  Future<void> cadastrarDono(Dono dono) async {
    _carregando = true;
    notifyListeners();

    final donosExistentes = await donoService.lerDonos();
    donosExistentes.add(dono);
    await donoService.salvarDonos(donosExistentes);

    _donoAtual = dono;
    _carregando = false;
    notifyListeners();
  }

  Future<void> carregarDono(String email) async {
    _carregando = true;
    notifyListeners();

    final donos = await donoService.lerDonos();
    _donoAtual = donos.firstWhere(
      (d) => d.email == email,
      orElse: () => Dono(
        nome: '',
        email: '',
        telefone: '',
        endereco: '',
        complemento: '',
        senha: '',
        funcao: '',
      ),
    );

    _carregando = false;
    notifyListeners();
  }

  Future<void> atualizarDono(Dono donoAtualizado) async {
    _carregando = true;
    notifyListeners();

    final donos = await donoService.lerDonos();
    final index = donos.indexWhere((d) => d.email == donoAtualizado.email);
    if (index != -1) {
      donos[index] = donoAtualizado;
      await donoService.salvarDonos(donos);
      _donoAtual = donoAtualizado;
    }

    _carregando = false;
    notifyListeners();
  }

  // =======================
  // Outros utilitários
  // =======================

  void logout() {
    _donoAtual = null;
    notifyListeners();
  }
}
