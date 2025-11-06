class Pet {
  final String id;      // id do documento no Firestore
  final String nome;
  final String raca;
  final int idade;
  final double peso;
  final String cor;
  final String donoId;  // uid do dono (Firebase Auth)

  Pet({
    required this.id,
    required this.nome,
    required this.raca,
    required this.idade,
    required this.peso,
    required this.cor,
    required this.donoId,
  });

  /// copyWith: cria um novo Pet reaproveitando os campos antigos
  /// e trocando só o que você passar como argumento.
  Pet copyWith({
    String? id,
    String? nome,
    String? raca,
    int? idade,
    double? peso,
    String? cor,
    String? donoId,
  }) {
    return Pet(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      raca: raca ?? this.raca,
      idade: idade ?? this.idade,
      peso: peso ?? this.peso,
      cor: cor ?? this.cor,
      donoId: donoId ?? this.donoId,
    );
  }

  /// Converte o Pet para Map (pra salvar no Firestore)
  /// Repara que eu **não** mando o `id` aqui, porque ele vem de doc.id
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'raca': raca,
      'idade': idade,
      'peso': peso,
      'cor': cor,
      'donoId': donoId,
    };
  }

  /// Cria um Pet a partir de um Map (lido do Firestore)
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '', // a gente injeta esse campo no service com data['id'] = doc.id
      nome: json['nome'] ?? '',
      raca: json['raca'] ?? '',
      idade: (json['idade'] ?? 0) as int,
      peso: (json['peso'] as num?)?.toDouble() ?? 0.0,
      cor: json['cor'] ?? '',
      donoId: json['donoId'] ?? '',
    );
  }
}
