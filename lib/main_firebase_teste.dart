import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FirebaseTesteApp());
}

class FirebaseTesteApp extends StatefulWidget {
  const FirebaseTesteApp({super.key});

  @override
  State<FirebaseTesteApp> createState() => _FirebaseTesteAppState();
}

class _FirebaseTesteAppState extends State<FirebaseTesteApp> {
  String resultado = 'Testando conexão com o Firebase...';

  @override
  void initState() {
    super.initState();
    _testarConexao();
  }

  Future<void> _testarConexao() async {
    try {
      final db = FirebaseFirestore.instance;

      // Cria um documento de teste
      await db.collection('teste_conexao').doc('verificacao').set({
        'mensagem': 'Conectado com sucesso!',
        'timestamp': DateTime.now(),
      });

      // Lê o documento novamente
      final doc =
          await db.collection('teste_conexao').doc('verificacao').get();

      setState(() {
        resultado = "🔥 Sucesso! Dados lidos: ${doc.data()}";
      });

      print('✅ Firestore conectado e testado com sucesso!');
    } catch (e) {
      setState(() {
        resultado = "❌ Erro ao conectar: $e";
      });
      print('❌ Erro ao conectar com Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Teste Firebase')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              resultado,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
        