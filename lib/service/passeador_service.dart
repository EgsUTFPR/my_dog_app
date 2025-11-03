// ...existing code...
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_dog_app/models/passeador_model.dart';

class PasseadorService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Passeador>> lerPasseadores() async {
    try {
      final snapshot = await _db.collection('passeadores').get();
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        // garante que o id do documento seja passado para o model
        data['id'] = doc.id;
        return Passeador.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('Erro ao ler passeadores: $e');
      return [];
    }
  }

  Future<Passeador?> buscarPasseadorPorId(String uid) async {
    try {
      final doc = await _db.collection('passeadores').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return Passeador.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao buscar passeador por id: $e');
      return null;
    }
  }

  Future<Passeador?> buscarPasseadorPorEmail(String email) async {
    try {
      final query = await _db
          .collection('passeadores')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final doc = query.docs.first;
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      return Passeador.fromJson(data);
    } catch (e) {
      debugPrint('Erro ao buscar passeador por email: $e');
      return null;
    }
  }

  Future<void> atualizarPasseador(Passeador passeador) async {
    try {
      await _db.collection('passeadores').doc(passeador.id).update(passeador.toJson());
    } catch (e) {
      debugPrint('Erro ao atualizar passeador: $e');
      rethrow;
    }
  }
}
