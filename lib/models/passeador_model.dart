class Passeador {
  final String nome;
  final String email;
  final String telefone;
  final String senha;
  final String funcao;

  Passeador({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
    required this.funcao,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'email': email,
    'telefone': telefone,
    'senha': senha,
    'funcao': funcao,
  };

  factory Passeador.fromJson(Map<String, dynamic> json) => Passeador(
    nome: json['nome'],
    email: json['email'],
    telefone: json['telefone'],
    senha: json['senha'],
    funcao: json['funcao'],
  );
}
