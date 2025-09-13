import 'package:flutter/material.dart';

class MeusPets extends StatefulWidget {
  const MeusPets({super.key});

  @override
  State<MeusPets> createState() => _MeusPetsState();
}

class _MeusPetsState extends State<MeusPets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Meus Pets'),
      ),
    );
  }
}