import 'package:flutter/material.dart';
import 'package:my_dog_app/controller/donocontroller.dart';
import 'package:my_dog_app/models/dono_model.dart';
import 'package:my_dog_app/service/dono_service.dart';

class PainelDono extends StatefulWidget {
  const PainelDono({super.key});

  @override
  State<PainelDono> createState() => _PainelDonoState();
}

class _PainelDonoState extends State<PainelDono> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _complementoController = TextEditingController();

  final DonoController _donoController = DonoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Painel do Dono'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: 20),
                      validator: _donoController.validarNome,
                    ),

                    SizedBox(height: 20),

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: 20),
                      validator: _donoController.validarEmail,
                    ),

                    SizedBox(height: 20),

                    TextFormField(
                      controller: _telefoneController,
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: 20),
                      validator: _donoController.validarTelefone,
                    ),

                    SizedBox(height: 20),

                    TextFormField(
                      controller: _enderecoController,
                      decoration: InputDecoration(
                        labelText: 'Endereço',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: 20),
                      validator: _donoController.validarEndereco,
                    ),

                    SizedBox(height: 20),

                    TextFormField(
                      controller: _complementoController,
                      decoration: InputDecoration(
                        labelText: 'Complemento',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: 20),
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final dono = Dono(
                            nome: _nomeController.text,
                            email: _emailController.text,
                            telefone: _telefoneController.text,
                            endereco: _enderecoController.text,
                            complemento: _complementoController.text,
                            senha: '',
                            funcao: '',
                          );

                          await _donoController.atualizarDono(dono);

                          _nomeController.clear();
                          _emailController.clear();
                          _telefoneController.clear();
                          _enderecoController.clear();
                          _complementoController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dados atualizados com sucesso!'),
                            ),
                          );

                          // Processar os dados
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Atualizar Dados',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final donos = await _donoController.donoService
                            .lerDonos();

                        if (donos.isEmpty) {
                          print("Nenhum dono cadastrado.");
                        } else {
                          for (var d in donos) {
                            print(
                              "Nome: ${d.nome}, Email: ${d.email}, Telefone: ${d.telefone}",
                            );
                          }
                        }
                      },
                      child: Text("Mostrar Donos"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
