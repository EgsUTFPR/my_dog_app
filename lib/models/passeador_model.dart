
class Passeador {
  String id;
  String nome;
  String email;
  String telefone;
  String senha;
  String funcao;

  Passeador({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
    required this.funcao,
  });

  factory Passeador.fromJson(Map<String, dynamic> json) {
    return Passeador(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      senha: json['senha']?.toString() ?? '',
      funcao: json['funcao']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'senha': senha,
      'funcao': funcao,
    };
  }
}
