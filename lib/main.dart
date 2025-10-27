import 'package:flutter/material.dart';
import 'package:my_dog_app/controller/donocontroller.dart';
import 'package:my_dog_app/controller/passeador_controller.dart';
import 'package:my_dog_app/meu_aplicativo.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DonoController()),
        ChangeNotifierProvider(create: (_) => PasseadorController()),
        // ChangeNotifierProvider(create: (_) => AlgumOutroController()),
      ],
      child: const MyApp(),
    ),
  );
}
