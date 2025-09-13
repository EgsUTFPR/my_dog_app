import 'package:flutter/material.dart';
import 'package:my_dog_app/views/tela_meus_pets.dart';
import 'package:my_dog_app/views/tela_painel_dono.dart';
import 'package:my_dog_app/views/tela_passeios.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TelaInicialDono extends StatefulWidget {
  const TelaInicialDono({super.key});

  @override
  State<TelaInicialDono> createState() => _TelaInicialDonoState();
}

class _TelaInicialDonoState extends State<TelaInicialDono> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  @override
  void dispose() {
    pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: const [PainelDono(), MeusPets(), Passeios()],
        onPageChanged: (value) {
          setState(() {
            paginaAtual = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Painel"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Meus Pets"),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.dog),
            label: 'Passeios',
          ),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
