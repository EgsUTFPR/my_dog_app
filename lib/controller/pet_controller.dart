import 'package:flutter/foundation.dart';
import '../models/pet_model.dart';
import '../service/pet_service.dart';

class PetController extends ChangeNotifier {
  final PetService _service = PetService();

  String? _donoId;        // dono atual (uid)
  List<Pet> _pets = [];
  bool _carregando = false;

  List<Pet> get pets => _pets;
  bool get carregando => _carregando;
  String? get donoId => _donoId;

  /// Chamar isso depois que o login carregar o Dono
  void configurarDono(String donoId) {
    _donoId = donoId;
    notifyListeners();
  }

  Future<void> carregarPets() async {
    if (_donoId == null) return; // ninguém logado ainda

    _carregando = true;
    notifyListeners();

    _pets = await _service.buscarPetsPorDono(_donoId!);

    _carregando = false;
    notifyListeners();
  }

  Future<void> salvarPet(Pet pet) async {
    if (_donoId == null) return;

    _carregando = true;
    notifyListeners();

    final petComDono = pet.copyWith(donoId: _donoId!);
    final petSalvo = await _service.salvarPet(petComDono);

    if (petSalvo != null) {
      _pets.add(petSalvo);
    }

    _carregando = false;
    notifyListeners();
  }

 

  Future<void> excluirPet(Pet pet) async {
    if (_donoId == null) return;

    _carregando = true;
    notifyListeners();

    await _service.excluirPet(pet.id);
    _pets.removeWhere((p) => p.id == pet.id);

    _carregando = false;
    notifyListeners();
  }
}
