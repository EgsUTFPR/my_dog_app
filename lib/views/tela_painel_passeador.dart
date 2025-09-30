import 'package:flutter/material.dart';
import 'package:my_dog_app/controller/passeador_controller.dart';
import 'package:my_dog_app/models/passeador_model.dart';
import 'package:my_dog_app/service/passeador_service.dart';


class PainelPasseador extends StatefulWidget {
  final String emailLogado; // email do passeador logado

  const PainelPasseador({super.key, required this.emailLogado});

  @override
  State<PainelPasseador> createState() => _PainelPasseadorState();
}

class _PainelPasseadorState extends State<PainelPasseador> {
  bool isEditing = false;
  Passeador? passeador;

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  final PasseadorController _passeadorController = PasseadorController();
  final PasseadorService _passeadorService = PasseadorService();

  @override
  void initState() {
    super.initState();
    _loadPasseador();
  }

  Future<void> _loadPasseador() async {
    passeador = await _passeadorController.carregarPasseador(
      widget.emailLogado,
    );

    _nomeController.text = passeador!.nome;
    _emailController.text = passeador!.email;
    _telefoneController.text = passeador!.telefone;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Passeador'),
        centerTitle: true,
        actions: [
          if (passeador != null)
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () async {
                if (isEditing) {
                  if (_formKey.currentState!.validate()) {
                    // Atualiza o passeador mantendo senha e função
                    passeador = await _passeadorController
                        .atualizarPasseadorController(
                          Passeador(
                            nome: _nomeController.text,
                            email: _emailController.text,
                            telefone: _telefoneController.text,
                            senha: passeador!.senha,
                            funcao: passeador!.funcao,
                          ),
                        );

                    setState(() {
                      isEditing = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dados atualizados com sucesso!'),
                      ),
                    );

                    // Mostra todos os passeadores no console
                    print("=== Passeadores cadastrados ===");
                    final todosPasseadores = await _passeadorService
                        .carregarPasseadores();
                    for (var p in todosPasseadores) {
                      print(
                        "${p.nome} | ${p.email} | ${p.telefone} | ${p.funcao}",
                      );
                    }
                  }
                } else {
                  setState(() {
                    isEditing = true;
                  });
                }
              },
            ),
        ],
      ),
      body: passeador == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _textField(
                      "Nome",
                      _nomeController,
                      _passeadorController.validarNome,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      "Email",
                      _emailController,
                      _passeadorController.validarEmail,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      "Telefone",
                      _telefoneController,
                      _passeadorController.validarTelefone,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) => TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    style: const TextStyle(fontSize: 18),
    validator: validator,
    enabled: isEditing,
  );
}
