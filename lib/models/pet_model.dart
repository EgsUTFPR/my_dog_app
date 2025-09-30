class Pet {
  final String nome;
  final String raca;
  final int idade;
  final double peso;
  final String cor;
  final String donoEmail;

  Pet({
    required this.nome,
    required this.raca,
    required this.idade,
    required this.peso,
    required this.cor,
    required this.donoEmail,
  });

  // Converte o Pet para Map (útil para salvar em JSON ou banco)
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'raca': raca,
      'idade': idade,
      'peso': peso,
      'cor': cor,
      'donoEmail': donoEmail,
    };
  }

  // Cria um Pet a partir de um Map
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      nome: json['nome'],
      raca: json['raca'],
      idade: json['idade'],
      peso: json['peso'].toDouble(),
      cor: json['cor'],
      donoEmail: json['donoEmail'],
    );
  }
}
