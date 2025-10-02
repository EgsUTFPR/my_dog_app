import 'package:flutter/material.dart';
import '../controller/pet_controller.dart';


class MeusPets extends StatefulWidget {
  final String emailLogado;
  const MeusPets({super.key, required this.emailLogado});

  @override
  State<MeusPets> createState() => _MeusPetsState();
}

class _MeusPetsState extends State<MeusPets> {
  late PetController _petController;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _petController = PetController(widget.emailLogado);
    _loadPets();
  }

  Future<void> _loadPets() async {
    await _petController.carregarPets();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Pets')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _petController.pets.isEmpty
          ? Center(child: Text('Nenhum pet cadastrado'))
          : ListView.builder(
              itemCount: _petController.pets.length,
              itemBuilder: (context, index) {
                final pet = _petController.pets[index];
                return Card(
                  child: ListTile(
                    title: Text(pet.nome),
                    subtitle: Text(pet.raca),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await _petController.removerPet(index);
                        setState(() {}); // atualiza a UI
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:(context) => TelaCadastroPer(
                donoEmail: widget.emailLogado,
                petController: _petController,
              ),
            ),
          );
          if (resultado == true){
            await _loadPets();
          }
        },
      ),
    );
  }
}
