import 'package:flutter/material.dart';
import 'package:my_dog_app/models/passeador_model.dart';
import 'package:my_dog_app/views/tela_painel_passeador.dart';
import 'package:my_dog_app/views/tela_passeios_passeador.dart';

class TelaInicialPasseador extends StatefulWidget {
  final Passeador passeador;
  const TelaInicialPasseador({super.key, required  this.passeador});

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
        children: [PainelPasseador(
          emailLogado: widget.passeador.email,
        ), PasseiosPasseador()],
        onPageChanged: (pagina) {
          setState(() {
            paginaAtual = pagina;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: 'Passeios',
          ),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
