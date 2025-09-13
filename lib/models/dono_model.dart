class Dono {
  final String nome;
  final String email;
  final String telefone;
  final String endereco;
  final String complemento;
  final String senha;
  final String funcao;

  Dono({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.endereco,
    this.complemento = '',
    required this.senha,
    required this.funcao,
  });


  // Converte objeto -> JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
      'complemento': complemento,
      'senha': senha,
      'funcao': funcao,
    };
  }

  // Converte JSON -> objeto
  factory Dono.fromJson(Map<String, dynamic> json) {
    return Dono(
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      endereco: json['endereco'],
      complemento: json['complemento'] ?? '',
      senha: json['senha'],
      funcao: json['funcao'],
    );
  }
}
