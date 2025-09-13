import 'package:flutter/material.dart';
import 'package:my_dog_app/views/tela_inicial_dono.dart';
import 'package:my_dog_app/views/tela_login.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  void initState() {
    super.initState();
    // Inicia um timer quando o widget é criado
    _navegarParaLogin();
  }

  _navegarParaLogin() async {
    // Espera por 3 segundos (3000 milissegundos)
    await Future.delayed(const Duration(seconds: 3));

    // Navega para a tela de login e remove a TelaInicial do histórico
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaInicialDono()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset('images/imagem_tela_inicial.png', fit: BoxFit.fill),
      ),
    );
  }
}
