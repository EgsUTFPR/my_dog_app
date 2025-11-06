import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

class PetService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'pets';

  /// Busca todos os pets de um dono específico
  Future<List<Pet>> buscarPetsPorDono(String donoId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('donoId', isEqualTo: donoId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // injeta o id do documento
        return Pet.fromJson(data);
      }).toList();
    } catch (e) {
      print('Erro ao buscar pets do dono: $e');
      return [];
    }
  }

  /// Salva um novo pet (criação) – 1 por vez
  Future<Pet?> salvarPet(Pet pet) async {
    try {
      final data = pet.toJson();

      // garante que o donoId está salvo no doc
      data['donoId'] = pet.donoId;

      final docRef = await _db.collection(_collection).add(data);

      // retorna um Pet já com o id gerado pelo Firestore
      return Pet.fromJson({
        'id': docRef.id,
        ...data,
      });
    } catch (e) {
      print('Erro ao salvar pet: $e');
      return null;
    }
  }

  /// Atualiza um pet existente (precisa ter id)
  Future<void> atualizarPet(Pet pet) async {
    try {
      if (pet.id.isEmpty) {
        throw Exception('Pet sem id não pode ser atualizado.');
      }

      final data = pet.toJson();
      data['donoId'] = pet.donoId;

      await _db.collection(_collection).doc(pet.id).update(data);
    } catch (e) {
      print('Erro ao atualizar pet: $e');
      rethrow;
    }
  }

  /// Exclui um pet pelo id
  Future<void> excluirPet(String petId) async {
    try {
      await _db.collection(_collection).doc(petId).delete();
    } catch (e) {
      print('Erro ao excluir pet: $e');
      rethrow;
    }
  }
}
