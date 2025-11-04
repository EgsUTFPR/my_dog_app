import 'package:flutter/material.dart';
import 'package:my_dog_app/controller/donocontroller.dart';
import 'package:my_dog_app/controller/passeador_controller.dart';
import 'package:my_dog_app/controller/pet_controller.dart';
import 'package:my_dog_app/meu_aplicativo.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_dog_app/service/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DonoController()),
        ChangeNotifierProvider(create: (_) => PasseadorController()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => PetController()),
      ],
      child: const MyApp(),
    ),
  );
}
