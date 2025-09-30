import 'package:flutter/material.dart';

class PasseiosPasseador extends StatefulWidget {
  const PasseiosPasseador({super.key});

  @override
  State<PasseiosPasseador> createState() => _PasseiosPasseadorState();
}

class _PasseiosPasseadorState extends State<PasseiosPasseador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Passeios do Passeador')));
  }
}
