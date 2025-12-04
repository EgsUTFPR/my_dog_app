import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapaLocal extends StatelessWidget {
  final double lat;
  final double lng;
  final String endereco;

  const MapaLocal({
    super.key,
    required this.lat,
    required this.lng,
    required this.endereco,
  });

  @override
  Widget build(BuildContext context) {
    final destino = LatLng(lat, lng);

    return Scaffold(
      appBar: AppBar(title: const Text("Local do Passeio")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: destino, zoom: 16),
              markers: {
                Marker(
                  markerId: const MarkerId("local"),
                  position: destino,
                  infoWindow: InfoWindow(title: endereco),
                ),
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final url =
                    "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              icon: const Icon(Icons.directions),
              label: const Text("Abrir no Google Maps"),
            ),
          ),
        ],
      ),
    );
  }
}
