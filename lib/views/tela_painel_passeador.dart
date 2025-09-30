import 'package:flutter/material.dart';

class PainelPasseador extends StatefulWidget {
  const PainelPasseador({super.key});

  @override
  State<PainelPasseador> createState() => _PainelPasseadorState();
}

class _PainelPasseadorState extends State<PainelPasseador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Painel do Passeador')));
  }
}
