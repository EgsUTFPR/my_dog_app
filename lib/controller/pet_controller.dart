import '../models/pet_model.dart';
import '../services/pet_service.dart';

class PetController {
  final PetService _service;
  List<Pet> pets = [];

  PetController(String donoEmail) : _service = PetService(donoEmail);

  Future<void> carregarPets() async {
    pets = await _service.carregarPets();
  }

  Future<void> adicionarPet(Pet pet) async {
    pets.add(pet);
    await _service.salvarPets(pets);
  }

  Future<void> atualizarPet(int index, Pet petAtualizado) async {
    pets[index] = petAtualizado;
    await _service.salvarPets(pets);
  }

  Future<void> removerPet(int index) async {
    pets.removeAt(index);
    await _service.salvarPets(pets);
  }
}
