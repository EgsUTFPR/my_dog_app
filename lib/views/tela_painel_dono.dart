import 'package:flutter/material.dart';
import 'package:my_dog_app/controller/donocontroller.dart';
import 'package:my_dog_app/models/dono_model.dart';



class PainelDono extends StatefulWidget {
  final String emailLogado; // email do dono logado

  const PainelDono({super.key, required this.emailLogado});

  @override
  State<PainelDono> createState() => _PainelDonoState();
}

class _PainelDonoState extends State<PainelDono> {
  bool isEditing = false;
  Dono? dono;

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _complementoController = TextEditingController();

  final DonoController _donoController = DonoController();

  @override
  void initState() {
    super.initState();
    _loadDono(); // chama direto do controller
  }

  Future<void> _loadDono() async {
    dono = await _donoController.carregarDono(widget.emailLogado);

    // atualiza os controllers com os dados do dono
    _nomeController.text = dono!.nome;
    _emailController.text = dono!.email;
    _telefoneController.text = dono!.telefone;
    _enderecoController.text = dono!.endereco;
    _complementoController.text = dono!.complemento;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Dono'),
        centerTitle: true,
        actions: [
          if (dono != null)
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () async {
                if (isEditing) {
                  if (_formKey.currentState!.validate()) {
                    // chama diretamente o controller
                    dono = await _donoController.atualizarDonoComController(
                      Dono(
                        nome: _nomeController.text,
                        email: _emailController.text,
                        telefone: _telefoneController.text,
                        endereco: _enderecoController.text,
                        complemento: _complementoController.text,
                        senha: dono!.senha,
                        funcao: dono!.funcao,
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
      body: dono == null
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
                      _donoController.validarNome,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      "Email",
                      _emailController,
                      _donoController.validarEmail,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      "Telefone",
                      _telefoneController,
                      _donoController.validarTelefone,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      "Endereço",
                      _enderecoController,
                      _donoController.validarEndereco,
                    ),
                    const SizedBox(height: 16),
                    _textField("Complemento", _complementoController, null),
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
