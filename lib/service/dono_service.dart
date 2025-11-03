import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_dog_app/models/dono_model.dart';

class DonoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Dono>> lerDonos() async {
    try {
      final snapshot = await _db.collection('donos').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // adiciona o ID do documento
        return Dono.fromJson(data);
      }).toList();
    } catch (e) {
        print('Erro ao ler donos: $e');
        return [];
    }
  }

  Future<Dono?> buscarDonoPorId(String uid) async {
    final doc = await _db.collection('donos').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      data['id'] = doc.id;
      return Dono.fromJson(data);
    }
    return null;
  }

  Future<Dono?> buscarDonoPorEmail(String email) async {
    try {
      final query = await _db
          .collection('donos')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final doc = query.docs.first;
      final dados = doc.data();
      dados['id'] = doc.id;

      return Dono.fromJson(dados);
    } catch (e) {
      print('Erro ao buscar dono por email: $e');
      return null;
    }
  }

  
  Future<void> atualizarDono(Dono dono) async {
    try {
      await _db.collection('donos').doc(dono.id).update(dono.toJson());
    } catch (e) {
      print("Erro ao atualizar dono: $e");
      rethrow;
    }
  }
}

