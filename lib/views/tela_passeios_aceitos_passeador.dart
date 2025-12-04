import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_dog_app/views/mapa_local.dart';

class PasseiosAceitosPasseador extends StatelessWidget {
  final String passeadorId;

  const PasseiosAceitosPasseador({super.key, required this.passeadorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Passeios Aceitos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("passeios")
            .where("passeadorId", isEqualTo: passeadorId)
            .where("status", isEqualTo: "aceito")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dados = snapshot.data!.docs;

          if (dados.isEmpty) {
            return const Center(
              child: Text(
                "Você não aceitou nenhum passeio ainda.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: dados.length,
            itemBuilder: (context, index) {
              final doc = dados[index].data() as Map<String, dynamic>;

              final nomePet = doc['pet'] ?? 'Pet';

              final enderecoInicio =
                  doc['enderecoInicio'] ?? 'Ainda não definido';

              final inicioLat = doc['inicioLat'];
              final inicioLng = doc['inicioLng'];

              final dataIso = doc['dataHora'] ?? '';
              final dataHora = DateTime.tryParse(dataIso);

              final dataFormatada = dataHora != null
                  ? "${dataHora.day.toString().padLeft(2, '0')}/"
                        "${dataHora.month.toString().padLeft(2, '0')}/"
                        "${dataHora.year} "
                        "${dataHora.hour.toString().padLeft(2, '0')}:"
                        "${dataHora.minute.toString().padLeft(2, '0')}"
                  : "Data não informada";

              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nomePet,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.my_location),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Início do passeio:\n$enderecoInicio",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      if (inicioLat != null && inicioLng != null)
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MapaLocal(
                                  lat: inicioLat,
                                  lng: inicioLng,
                                  endereco: enderecoInicio,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.map),
                          label: const Text("Ver no Mapa"),
                        ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.schedule),
                          const SizedBox(width: 6),
                          Text(
                            dataFormatada,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("passeios")
                                .doc(dados[index].id)
                                .update({"status": "finalizado"});

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Passeio marcado como finalizado!",
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Finalizar Passeio"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
