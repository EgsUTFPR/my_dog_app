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
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email))
      return 'Formato de email inválido';
    return null;
  }

  String? validarTelefone(String? telefone) {
    if (telefone == null || telefone.isEmpty)
      return 'O telefone não pode estar vazio';
    if (!RegExp(r'^\d{10,11}$').hasMatch(telefone))
      return 'Formato de telefone inválido';
    return null;
  }

  String? validarEndereco(String? endereco) {
    if (endereco == null || endereco.isEmpty)
      return 'O endereço não pode estar vazio';
    return null;
  }

  // =======================
  // Salvar dono no JSON
  // =======================

  Future<void> salvarDono(Dono dono) async {
    // Lê os donos existentes do JSON
    final List<Dono> donosExistentes = await donoService.lerDonos();

    // Adiciona o novo dono
    donosExistentes.add(dono);

    // Salva tudo de volta no JSON
    await donoService.salvarDonos(donosExistentes);
  }

  // =======================
  // Verificar login
  // =======================
  Future<Dono?> verificarLogin(String email, String telefone) async {
    final List<Dono> donosExistentes = await donoService.lerDonos();
    try {
      return donosExistentes.firstWhere(
        (d) => d.email == email && d.telefone == telefone,
      );
    } catch (e) {
      return null; // Não encontrou
    }
  }

  Future<void> atualizarDono(Dono donoAtualizado) async {
    
    final List<Dono> donosExistentes = await donoService.lerDonos();

    for (int i = 0; i < donosExistentes.length; i++) {
      if (donosExistentes[i].email == donoAtualizado.email) {
        // Cria um novo dono com a senha antiga
        final donoComSenhaAntiga = Dono(
          nome: donoAtualizado.nome,
          email: donoAtualizado.email,
          telefone: donoAtualizado.telefone,
          endereco: donoAtualizado.endereco,
          complemento: donoAtualizado.complemento,
          senha: donosExistentes[i].senha, // mantém a senha
          funcao: donosExistentes[i].funcao, // mantém a função
        );

        donosExistentes[i] = donoComSenhaAntiga;
        break;
      }
    }

    await donoService.salvarDonos(donosExistentes);
  }
}
