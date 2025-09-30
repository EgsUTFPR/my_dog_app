import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dog_app/controller/donocontroller.dart';
import 'package:my_dog_app/controller/passeador_controller.dart';
import 'package:my_dog_app/models/dono_model.dart';
import 'package:my_dog_app/models/passeador_model.dart';
import 'package:my_dog_app/services/dono_service.dart';
import 'package:my_dog_app/services/passeador_service.dart';

enum Funcao { dono, passeador }

class telaCadastro extends StatefulWidget {
  const telaCadastro({super.key});

  @override
  State<telaCadastro> createState() => _telaCadastroState();
}

class _telaCadastroState extends State<telaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _complementoController = TextEditingController();
  final _senhaController = TextEditingController();

  final DonoController _donoController = DonoController();
  final PasseadorController _passeadorController = PasseadorController();
  final DonoService _donoService = DonoService();
  final PasseadorService _passeadorService = PasseadorService();

  Funcao? _funcaoEscolhida;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Usuário'), centerTitle: true),
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

                    TextFormField(
                      controller: _senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      validator: _donoController.validarSenha,
                    ),

                    Column(
                      children: <Widget>[
                        ListTile(
                          title: const Text('Dono'),
                          leading: Radio<Funcao>(
                            value: Funcao.dono,
                            groupValue: _funcaoEscolhida,
                            onChanged: (Funcao? value) {
                              setState(() {
                                _funcaoEscolhida = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Passeador'),
                          leading: Radio<Funcao>(
                            value: Funcao.passeador,
                            groupValue: _funcaoEscolhida,
                            onChanged: (Funcao? value) {
                              setState(() {
                                _funcaoEscolhida = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_funcaoEscolhida == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor, selecione uma função.',
                                ),
                              ),
                            );
                            return;
                          }

                          if (_funcaoEscolhida == Funcao.dono) {
                            final dono = Dono(
                              nome: _nomeController.text,
                              email: _emailController.text,
                              telefone: _telefoneController.text,
                              endereco: _enderecoController.text,
                              complemento: _complementoController.text,
                              senha: _senhaController.text,
                              funcao: 'dono',
                            );

                            await _donoController.cadastrarDono(dono);
                            print("=== Donos cadastrados ===");
                            final todosDonos = await _donoService.lerDonos();
                            for (var d in todosDonos) {
                              print(
                                "${d.nome} | ${d.email} | ${d.telefone} | ${d.funcao}",
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Usuário cadastrado com sucesso.',
                                ),
                              ),
                            );
                          }

                          if (_funcaoEscolhida == Funcao.passeador) {
                            final passeador = Passeador(
                              nome: _nomeController.text,
                              email: _emailController.text,
                              telefone: _telefoneController.text,
                              senha: _senhaController.text,
                              funcao: 'passeador',
                            );

                            await _passeadorController.cadastrarPasseador(
                              passeador,
                            );
                            print("=== Passeadores cadastrados ===");
                            final todosPasseadores = await _passeadorService
                                .carregarPasseadores();
                            for (var p in todosPasseadores) {
                              print(
                                "${p.nome} | ${p.email} | ${p.telefone} | ${p.funcao}",
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Usuário cadastrado com sucesso.',
                                ),
                              ),
                            );
                          }

                          _nomeController.clear();
                          _emailController.clear();
                          _telefoneController.clear();
                          _enderecoController.clear();
                          _complementoController.clear();
                          _senhaController.clear();

                          await Future.delayed(Duration(seconds: 1));
                          GoRouter.of(context).go('/login');

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
                              'Cadastrar',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
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
