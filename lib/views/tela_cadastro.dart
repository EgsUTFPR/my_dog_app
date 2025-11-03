import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dog_app/controller/donocontroller.dart';

import 'package:my_dog_app/service/auth_service.dart';

import 'package:provider/provider.dart';

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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        hintText: 'xxx@xxx.com',
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
                        hintText: '0000000000',
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
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

                          final auth = Provider.of<AuthService>(
                            context,
                            listen: false,
                          );

                          try {
                            if (_funcaoEscolhida == Funcao.dono) {
                              await auth.cadastrarDono(
                                _emailController.text.trim(),
                                _senhaController.text.trim(),
                                {
                                  'nome': _nomeController.text.trim(),
                                  'telefone': _telefoneController.text.trim(),
                                  'endereco': _enderecoController.text.trim(),
                                  'complemento': _complementoController.text
                                      .trim(),
                                  'funcao': 'dono',
                                },
                              );
                            } else {
                              await auth.cadastrarPasseador(
                                _emailController.text.trim(),
                                _senhaController.text.trim(),
                                {
                                  'nome': _nomeController.text.trim(),
                                  'telefone': _telefoneController.text.trim(),
                                  'funcao': 'passeador',
                                },
                              );
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Usuário cadastrado com sucesso!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            await Future.delayed(const Duration(seconds: 1));
                            GoRouter.of(context).go('/login');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
