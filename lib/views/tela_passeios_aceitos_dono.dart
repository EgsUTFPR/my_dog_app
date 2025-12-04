import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class PasseiosDono extends StatelessWidget {
  final String donoId;

  const PasseiosDono({super.key, required this.donoId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Passeios'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Pendentes"),
              Tab(text: "Aceitos"),
              Tab(text: "Finalizados"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLista(context, "pendente"),
            _buildLista(context, "aceito"),
            _buildLista(context, "finalizado"),
          ],
        ),
      ),
    );
  }

  Widget _buildLista(BuildContext context, String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("passeios")
          .where("donoId", isEqualTo: donoId)
          .where("status", isEqualTo: status)
          .orderBy("dataHora", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("Erro ao carregar dados."));
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return Center(
            child: Text(
              status == "pendente"
                  ? "Nenhum passeio pendente."
                  : status == "aceito"
                  ? "Nenhum passeio aceito."
                  : "Nenhum passeio finalizado.",
              style: const TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final nomePet = data['pet'] ?? "Pet";
            final endereco = data['endereco'] ?? "Endereço";

            // Conversão da data
            dynamic bruto = data['dataHora'];
            DateTime? date;

            if (bruto is Timestamp) {
              date = bruto.toDate();
            } else if (bruto is String) {
              try {
                date = DateTime.parse(bruto);
              } catch (_) {
                date = null;
              }
            }

            final dataFormatada = date != null
                ? "${date.day.toString().padLeft(2, '0')}/"
                      "${date.month.toString().padLeft(2, '0')}/"
                      "${date.year} às "
                      "${date.hour.toString().padLeft(2, '0')}:"
                      "${date.minute.toString().padLeft(2, '0')}"
                : "Data não informada";

            final passeadorId = data['passeadorId'];

            Future<String> obterNomePasseador() async {
              if (passeadorId == null) return "Aguardando passeador";

              final snap = await FirebaseFirestore.instance
                  .collection("passeadores")
                  .doc(passeadorId)
                  .get();

              if (!snap.exists) return "Passeador";

              return (snap.data()?['nome'] ?? "Passeador") as String;
            }

            return FutureBuilder<String>(
              future: obterNomePasseador(),
              builder: (context, nomeSnapshot) {
                final nomePasseador =
                    nomeSnapshot.data ?? "Aguardando passeador";

                return FutureBuilder<LatLng?>(
                  future: _converterEnderecoParaLatLng(endereco),
                  builder: (context, mapaSnapshot) {
                    final destino = mapaSnapshot.data;

                    //final inicioLat = data["inicioLat"];
                    //final inicioLng = data["inicioLng"];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
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

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    endereco,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

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

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(Icons.person),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    nomePasseador,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            if (destino != null)
                              SizedBox(
                                height: 200,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: destino,
                                    zoom: 15,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId("destino"),
                                      position: destino,
                                      infoWindow: InfoWindow(
                                        title: nomePet,
                                        snippet: "Destino do passeio",
                                      ),
                                    ),
                                  },
                                  zoomControlsEnabled: false,
                                  myLocationButtonEnabled: false,
                                ),
                              ),

                            const SizedBox(height: 12),

                            // Botão para escolher endereço inicial
                            if (status == "pendente")
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EscolherEnderecoPage(
                                        passeioId: docs[index].id,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit_location),
                                label: const Text("Escolher endereço inicial"),
                              ),

                            const SizedBox(height: 12),

                            if (status == "pendente" || status == "aceito")
                              Align(
                                alignment: Alignment.bottomRight,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("passeios")
                                        .doc(docs[index].id)
                                        .delete();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Passeio cancelado!"),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  child: const Text("Cancelar Passeio"),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<LatLng?> _converterEnderecoParaLatLng(String endereco) async {
    try {
      List<Location> locations = await locationFromAddress(endereco);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print("Erro ao converter endereço: $e");
    }
    return null;
  }

  void _abrirRotasPersonalizada(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    final url =
        "https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng";

    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class EscolherEnderecoPage extends StatefulWidget {
  final String passeioId;

  const EscolherEnderecoPage({super.key, required this.passeioId});

  @override
  State<EscolherEnderecoPage> createState() => _EscolherEnderecoPageState();
}

class _EscolherEnderecoPageState extends State<EscolherEnderecoPage> {
  LatLng? selecionado;
  String endereco = "Toque no mapa para selecionar o início.";

  final TextEditingController enderecoController = TextEditingController();
  GoogleMapController? controller;

  Future<void> _buscarEnderecoDigitado() async {
    final texto = enderecoController.text.trim();
    if (texto.isEmpty) return;

    try {
      final results = await locationFromAddress(texto);

      if (results.isNotEmpty) {
        final loc = results.first;

        final pos = LatLng(loc.latitude, loc.longitude);

        setState(() {
          selecionado = pos;
          endereco = texto;
        });

        controller?.animateCamera(CameraUpdate.newLatLngZoom(pos, 16));
      }
    } catch (e) {
      print("Erro ao buscar endereço: $e");
      setState(() {
        endereco = "Endereço não encontrado";
      });
    }
  }

  Future<void> _buscarMinhaLocalizacao() async {
    // 1. Verificar se o serviço de localização está ativo
    final servicoHabilitado = await Geolocator.isLocationServiceEnabled();

    if (!servicoHabilitado) {
      await Geolocator.openLocationSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ative o GPS para continuar")),
      );
      return;
    }

    // 2. Verificar permissão
    LocationPermission status = await Geolocator.checkPermission();

    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
      if (status == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permissão de localização negada.")),
        );
        return;
      }
    }

    if (status == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Permissão negada permanentemente. Habilite nas configurações.",
          ),
        ),
      );
      await Geolocator.openAppSettings();
      return;
    }

    // 3. Buscar localização atual
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    final latlng = LatLng(pos.latitude, pos.longitude);

    // 4. Atualizar estado
    setState(() {
      selecionado = latlng;
    });

    // 5. Mover a câmera
    controller?.animateCamera(CameraUpdate.newLatLngZoom(latlng, 16));

    // 6. Converter coordenada → endereço
    final placemarks = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );
    final p = placemarks.first;

    final texto =
        "${p.street ?? ""}, ${p.subLocality ?? ""}, ${p.locality ?? ""}".trim();

    setState(() {
      endereco = texto;
      enderecoController.text = texto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escolher endereço inicial")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: enderecoController,
              decoration: InputDecoration(
                labelText: "Digite o endereço",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarEnderecoDigitado,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton.icon(
              onPressed: _buscarMinhaLocalizacao,
              icon: const Icon(Icons.my_location),
              label: const Text("Usar minha localização"),
            ),
          ),

          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-23.5505, -46.6333), // São Paulo
                zoom: 14,
              ),
              onMapCreated: (c) => controller = c,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (pos) async {
                setState(() => selecionado = pos);

                try {
                  final lugares = await placemarkFromCoordinates(
                    pos.latitude,
                    pos.longitude,
                  );

                  final p = lugares.first;
                  setState(() {
                    endereco =
                        "${p.street ?? ""}, ${p.subLocality ?? ""}, ${p.locality}";
                    enderecoController.text = endereco;
                  });
                } catch (_) {
                  endereco = "Endereço não encontrado";
                }
              },
              markers: selecionado == null
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId("inicio"),
                        position: selecionado!,
                      ),
                    },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  endereco,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: selecionado == null
                      ? null
                      : () async {
                          await FirebaseFirestore.instance
                              .collection("passeios")
                              .doc(widget.passeioId)
                              .update({
                                "enderecoInicio": endereco,
                                "inicioLat": selecionado!.latitude,
                                "inicioLng": selecionado!.longitude,
                              });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Endereço inicial salvo!"),
                            ),
                          );
                        },
                  child: const Text("Salvar endereço inicial"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
