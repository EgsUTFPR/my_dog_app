import 'package:flutter/foundation.dart';
import '../models/pet_model.dart';
import '../service/pet_service.dart';

class PetController extends ChangeNotifier {
  final PetService _service;
  List<Pet> _pets = [];
  bool _carregando = false;

  PetController(String donoEmail) : _service = PetService(donoEmail);

  // ==========================
  // Getters públicos
  // ==========================
  List<Pet> get pets => _pets;
  bool get carregando => _carregando;

  // ==========================
  // Métodos principais
  // ==========================
  Future<void> carregarPets() async {
    _carregando = true;
    notifyListeners();

    _pets = await _service.carregarPets();

    _carregando = false;
    notifyListeners();
  }

  Future<void> adicionarPet(Pet pet) async {
    _carregando = true;
    notifyListeners();

    _pets.add(pet);
    await _service.salvarPets(_pets);

    _carregando = false;
    notifyListeners();
  }

  Future<void> atualizarPet(int index, Pet petAtualizado) async {
    _carregando = true;
    notifyListeners();

    _pets[index] = petAtualizado;
    await _service.salvarPets(_pets);

    _carregando = false;
    notifyListeners();
  }

  Future<void> removerPet(int index) async {
    _carregando = true;
    notifyListeners();

    _pets.removeAt(index);
    await _service.salvarPets(_pets);

    _carregando = false;
    notifyListeners();
  }
}
