import 'package:flutter/material.dart';
import 'package:my_dog_app/controller/pet_controller.dart';
import 'package:my_dog_app/models/pet_model.dart';
import 'package:provider/provider.dart';

class TelaCadastroPet extends StatefulWidget {
  const TelaCadastroPet({super.key});

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

  Future<void> _salvarPet() async {
    if (_formKey.currentState!.validate()) {
      try {
        // pega o controller global
        final petController = context.read<PetController>();
        final donoId = petController.donoId;

        if (donoId == null || donoId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erro: dono não configurado no PetController."),
            ),
          );
          return;
        }

        final novoPet = Pet(
          id: '', // Firestore vai gerar o id de verdade
          nome: _nomeController.text.trim(),
          raca: _racaController.text.trim(),
          idade: int.parse(_idadeController.text),
          peso: double.parse(_pesoController.text),
          cor: _corController.text.trim(),
          donoId: donoId, // vem do controller global
        );

        await petController.salvarPet(novoPet);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pet cadastrado com sucesso!")),
        );

        Navigator.pop(context, true); // volta pra lista de pets
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao cadastrar pet: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar Pet")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: "Nome do Pet",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite o nome" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _racaController,
                  decoration: const InputDecoration(
                    labelText: "Raça",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite a raça" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _idadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Idade",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite a idade" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pesoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Peso (kg)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite o peso" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _corController,
                  decoration: const InputDecoration(
                    labelText: "Cor",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite a cor" : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _salvarPet,
                  child: const Text("Salvar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
