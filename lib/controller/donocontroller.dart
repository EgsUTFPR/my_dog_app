import 'package:my_dog_app/models/dono_model.dart';
import 'package:my_dog_app/service/dono_service.dart';

class DonoController {
  final DonoService donoService = DonoService();

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

  Future<Dono?> verificarLogin(String email, String senha) async {
    final List<Dono> donosExistentes = await donoService.lerDonos();

    for (var d in donosExistentes) {
      if (d.email == email && d.senha == senha) {
        return d; // encontrou, já pode devolver o dono
      }
    }

    // se percorreu a lista inteira e não achou
    return null;
  }

  // =======================
  // Salvar dono no JSON
  // =======================

  Future<void> cadastrarDono(Dono dono) async {
    // Lê os donos existentes do JSON
    final List<Dono> donosExistentes = await donoService.lerDonos();

    // Adiciona o novo dono
    donosExistentes.add(dono);

    // Salva tudo de volta no JSON
    await donoService.salvarDonos(donosExistentes);
  }

  // Carrega apenas o dono que corresponde ao email logado
  Future<Dono> carregarDono(String email) async {
    final donos = await donoService.lerDonos();
    return donos.firstWhere(
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
  }

  // Atualiza o dono existente no JSON
  Future<void> atualizarDono(Dono donoAtualizado) async {
    final donos = await donoService.lerDonos();
    final index = donos.indexWhere((d) => d.email == donoAtualizado.email);
    if (index != -1) {
      donos[index] = donoAtualizado;
      await donoService.salvarDonos(donos);
    }
  }

  Future<Dono> atualizarDonoComController(Dono donoAtual) async {
    await atualizarDono(donoAtual); // usa método existente
    return donoAtual;
  }
}
