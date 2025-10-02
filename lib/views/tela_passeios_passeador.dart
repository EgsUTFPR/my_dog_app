import 'package:flutter/material.dart';

class PasseiosPasseador extends StatefulWidget {
  const PasseiosPasseador({super.key});

  @override
  State<PasseiosPasseador> createState() => _PasseiosPasseadorState();
}

class _PasseiosPasseadorState extends State<PasseiosPasseador> {
  // Mock de passeios (simulação)
  List<Map<String, dynamic>> passeios = [
    {
      "id": "1",
      "cachorro": "Rex",
      "dono": "João Silva",
      "data": DateTime.now().add(Duration(hours: 2)),
      "status": "solicitado",
    },
    {
      "id": "2",
      "cachorro": "Luna",
      "dono": "Maria Oliveira",
      "data": DateTime.now().add(Duration(days: 1)),
      "status": "solicitado",
    },
  ];

  void aceitarPasseio(String id) {
    setState(() {
      passeios = passeios.map((p) {
        if (p["id"] == id) {
          p["status"] = "aceito";
        }
        return p;
      }).toList();
    });
  }

  void recusarPasseio(String id) {
    setState(() {
      passeios = passeios.map((p) {
        if (p["id"] == id) {
          p["status"] = "recusado";
        }
        return p;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Passeios")),
      body: ListView.builder(
        itemCount: passeios.length,
        itemBuilder: (context, index) {
          final passeio = passeios[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.pets, color: Colors.blue),
              title: Text("${passeio["cachorro"]} (${passeio["dono"]})"),
              subtitle: Text(
                "Data: ${passeio["data"].day}/${passeio["data"].month} "
                "às ${passeio["data"].hour}:${passeio["data"].minute.toString().padLeft(2, '0')}\n"
                "Status: ${passeio["status"]}",
              ),
              isThreeLine: true,
              trailing: passeio["status"] == "solicitado"
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => aceitarPasseio(passeio["id"]),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => recusarPasseio(passeio["id"]),
                        ),
                      ],
                    )
                  : Text(
                      passeio["status"].toUpperCase(),
                      style: TextStyle(
                        color: passeio["status"] == "aceito"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
