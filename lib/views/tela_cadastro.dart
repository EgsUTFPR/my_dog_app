import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dog_app/controller/donocontroller.dart';
import 'package:my_dog_app/models/dono_model.dart';

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
                          final dono = Dono(
                            nome: _nomeController.text,
                            email: _emailController.text,
                            telefone: _telefoneController.text,
                            endereco: _enderecoController.text,
                            complemento: _complementoController.text,
                            senha: _senhaController.text,
                            funcao: _funcaoEscolhida == Funcao.dono
                                ? 'dono'
                                : 'passeador',
                          );

                          await _donoController.cadastrarDono(dono);

                          _nomeController.clear();
                          _emailController.clear();
                          _telefoneController.clear();
                          _enderecoController.clear();
                          _complementoController.clear();
                          _senhaController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuário cadastrado com sucesso.'),
                            ),
                          );


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
