import 'package:flutter/material.dart';
import 'package:my_dog_app/models/passeador_model.dart';
import 'package:my_dog_app/views/tela_painel_passeador.dart';
import 'package:my_dog_app/views/tela_passeios_passeador.dart';

class TelaInicialPasseador extends StatefulWidget {
  const TelaInicialPasseador({super.key, required Passeador passeador});

  @override
  State<TelaInicialPasseador> createState() => _TelaInicialPasseadorState();
}

class _TelaInicialPasseadorState extends State<TelaInicialPasseador> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [PainelPasseador(), PasseiosPasseador()],
      ),
    );
  }
}
