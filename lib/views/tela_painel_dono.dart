import 'package:flutter/material.dart';
import 'package:my_dog_app/controller/donocontroller.dart';
import 'package:my_dog_app/models/dono_model.dart';

class PainelDono extends StatefulWidget {
  final String emailLogado;

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
    _loadDono();
  }

  Future<void> _loadDono() async {
    dono = await _donoController.carregarDono(widget.emailLogado);

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
        title: const Text("Painel do Dono"),
        centerTitle: true,
        actions: [
          if (dono != null)
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () async {
                if (isEditing) {
                  if (_formKey.currentState!.validate()) {
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

                    setState(() => isEditing = false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Dados atualizados com sucesso!"),
                        backgroundColor: Colors.green.shade600,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else {
                  setState(() => isEditing = true);
                }
              },
            ),
        ],
      ),
      body: dono == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _textField(
                      label: "Nome",
                      controller: _nomeController,
                      validator: _donoController.validarNome,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      label: "Email",
                      controller: _emailController,
                      validator: _donoController.validarEmail,
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      label: "Telefone",
                      controller: _telefoneController,
                      validator: _donoController.validarTelefone,
                      icon: Icons.phone,
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      label: "Endereço",
                      controller: _enderecoController,
                      validator: _donoController.validarEndereco,
                      icon: Icons.home,
                    ),
                    const SizedBox(height: 16),
                    _textField(
                      label: "Complemento",
                      controller: _complementoController,
                      validator: null,
                      icon: Icons.map,
                    ),
                    const SizedBox(height: 24),
                    if (isEditing)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Salvar Alterações"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dono = await _donoController
                                .atualizarDonoComController(
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

                            setState(() => isEditing = false);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Dados atualizados com sucesso!",
                                ),
                                backgroundColor: Colors.green.shade600,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    IconData? icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: isEditing,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isEditing ? Colors.white : Colors.grey.shade200,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
