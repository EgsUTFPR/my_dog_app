class Passeio {
  final int idPasseio;
  final String donoEmail;
  final String petNome;
  final DateTime data;
  final String status; // 'pendente', 'aceito', 'concluido'

  Passeio({
    required this.idPasseio,
    required this.donoEmail,
    required this.petNome,
    required this.data,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'donoEmail': donoEmail,
    'petNome': petNome,
    'data': data.toIso8601String(),
    'status': status,
  };

  factory Passeio.fromJson(Map<String, dynamic> json) => Passeio(
    idPasseio: json['idPasseio'],
    donoEmail: json['donoEmail'],
    petNome: json['petNome'],
    data: DateTime.parse(json['data']),
    status: json['status'],
  );
}
