import 'package:flutter/material.dart';

class Passeios extends StatefulWidget {
  const Passeios({super.key});

  @override
  State<Passeios> createState() => _TelaPasseiosState();
}

class _TelaPasseiosState extends State<Passeios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passeios')),
      body: const Center(child: Text('Conteúdo da tela de Passeios')),
    );
  }
}
