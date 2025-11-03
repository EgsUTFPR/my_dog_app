import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_dog_app/models/dono_model.dart';
import 'package:my_dog_app/models/passeador_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? usuario; // usuário logado (ou null)
  bool isLoading = true; // carregando estado de auth (primeiro boot)
  String? funcaoUsuario; // "dono" ou "passeador"
  bool carregandoFuncao = false; // carregando papel do usuário

  AuthService() {
    _authCheck();
  }

  void _authCheck() {
    _auth.authStateChanges().listen((User? user) async {
      usuario = user;
      if (usuario == null) {
        // ninguém logado
        funcaoUsuario = null;
        isLoading = false;
        notifyListeners();
      } else {
        // logado: buscar função no Firestore
        await carregarFuncaoUsuario();
        isLoading = false;
        notifyListeners();
      }
    });
  }

  /// Busca em Firestore: `usuarios/{uid}` -> campo "funcao"
  Future<void> carregarFuncaoUsuario() async {
    if (usuario == null) return;
    try {
      carregandoFuncao = true;
      notifyListeners();

      final doc = await _db.collection('usuarios').doc(usuario!.uid).get();
      if (doc.exists) {
        funcaoUsuario = (doc.data() ?? const {})['funcao'] as String?;
      } else {
        // caso não exista, deixa null (força tratar no app)
        funcaoUsuario = null;
      }
    } catch (_) {
      funcaoUsuario = null;
    } finally {
      carregandoFuncao = false;
      notifyListeners();
    }
  }

  Future<void> cadastrarDono(
    String email,
    String senha,
    Map<String, dynamic> dadosDono,
  ) async {
    try {
      // 1️⃣ Cria o usuário no Firebase Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      final uid = cred.user!.uid;
      // 2️⃣ Cria o documento no Firestore
      await _db.collection('donos').doc(cred.user!.uid).set({
        'email': email,
        ...dadosDono,
        'criadoEm': Timestamp.now(),
        'id': uid,
      });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzirErro(e.code));
    }
  }

  Future<void> cadastrarPasseador(
    String email,
    String senha,
    Map<String, dynamic> dadosPasseador,
  ) async {
    try {
      // 1️⃣ Cria o usuário no Firebase Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final uid = cred.user!.uid;

      // 2️⃣ Cria o documento no Firestore
      await _db.collection('passeadores').doc(cred.user!.uid).set({
        'email': email,
        ...dadosPasseador,
        'criadoEm': Timestamp.now(),
        'id': uid,
      });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzirErro(e.code));
    }
  }

  Future<Object?> verificarLogin(String email, String senha) async {
    try {
      // Faz login com FirebaseAuth
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final uid = cred.user?.uid;
      if (uid == null) return null;

      final donoDoc = await _db.collection('donos').doc(uid).get();
      if (donoDoc.exists && donoDoc.data() != null) {
        final dados = Map<String, dynamic>.from(donoDoc.data()!);
        dados['id'] = uid;
        final dono = Dono.fromJson(dados);
        usuario = cred.user;
        funcaoUsuario = 'dono';
        notifyListeners();
        return dono;
      }

      final passeadorDoc = await _db.collection('passeadores').doc(uid).get();
      if (passeadorDoc.exists && passeadorDoc.data() != null) {
        final dados = Map<String, dynamic>.from(passeadorDoc.data()!);
        dados['id'] = uid;
        final passeador = Passeador.fromJson(dados); // cria a instância
        usuario = cred.user;
        funcaoUsuario = 'passeador';
        notifyListeners();
        return passeador; // retorna a instância
      }

      return null; // não achou o usuário
    } on FirebaseAuthException catch (e) {
      print("🔥 Erro no login: ${e.code} — ${e.message}");
      return null;
    } catch (e, st) {
      debugPrint('verificarLogin erro inesperado: $e\n$st');
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    usuario = null;
    notifyListeners();
  }

  String _traduzirErro(String code) {
    switch (code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Usuário desativado.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'E-mail já está sendo usado.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      default:
        return 'Erro desconhecido. Tente novamente.';
    }
  }
}
