import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dog_app/controller/donocontroller.dart';
import 'package:my_dog_app/models/dono_model.dart';
import 'package:my_dog_app/models/passeador_model.dart';

class telaLogin extends StatefulWidget {
  const telaLogin({super.key});

  @override
  State<telaLogin> createState() => _telaLoginState();
}

class _telaLoginState extends State<telaLogin> {
  final _form = GlobalKey<FormState>();

  DonoController dono = DonoController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // espaço nas bordas
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16.0),

            Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.0), // espaço entre os campos

                  TextFormField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    obscureText: true, // para esconder a senha
                  ),
                  SizedBox(height: 16.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_form.currentState!.validate()) {
                            final resultado = await dono.verificarLogin(
                              _emailController.text,
                              _senhaController.text,
                            );

                            if (resultado == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Email ou senha incorretos!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (resultado is Dono) {
                              GoRouter.of(
                                context,
                              ).go('/tela-inicial-dono', extra: resultado);
                            } else if (resultado is Passeador) {
                              GoRouter.of(
                                context,
                              ).go('/tela-inicial-passeador', extra: resultado);
                            }   
                          }
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.login),
                            SizedBox(width: 8),
                            Text('Login', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),

                      SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).go('/cadastro'); // rota lógica
                        },
                        child: Row(
                          children: [
                            Text('Cadastre-se', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
