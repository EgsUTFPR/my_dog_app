import 'package:flutter/material.dart';
import 'package:my_dog_app/controller/pet_controller.dart';
import 'package:my_dog_app/models/pet_model.dart';

class TelaCadastroPet extends StatefulWidget {
  final String donoEmail;
  final PetController petController;

  const TelaCadastroPet({
    super.key,
    required this.donoEmail,
    required this.petController,
  });

  @override
  State<TelaCadastroPet> createState() => _TelaCadastroPetState();
}

class _TelaCadastroPetState extends State<TelaCadastroPet> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _corController = TextEditingController();

  void _salvarPet() async {
    if (_formKey.currentState!.validate()) {
      final novoPet = Pet(
        nome: _nomeController.text,
        raca: _racaController.text,
        idade: int.parse(_idadeController.text),
        peso: double.parse(_pesoController.text),
        cor: _corController.text,
        donoEmail: widget.donoEmail,
      );

      await widget.petController.adicionarPet(novoPet);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Pet cadastrado com sucesso!")));

      Navigator.pop(context, true); // volta
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar Pet")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: "Nome do Pet",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite o nome" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _racaController,
                  decoration: InputDecoration(
                    labelText: "Raça",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite a raça" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _idadeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Idade",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite a idade" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _pesoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Peso (kg)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite o peso" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _corController,
                  decoration: InputDecoration(
                    labelText: "Cor",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite a cor" : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _salvarPet, child: Text("Salvar")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
