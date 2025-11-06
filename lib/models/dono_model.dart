// ...existing code...
class Dono {
  String id;
  String nome;
  String email;
  String telefone;
  String endereco;
  String complemento;
  String senha;
  String funcao;

  Dono({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.endereco,
    required this.complemento,
    required this.senha,
    required this.funcao,
  });

  factory Dono.fromJson(Map<String, dynamic> json) {
    return Dono(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      endereco: json['endereco']?.toString() ?? '',
      complemento: json['complemento']?.toString() ?? '',
      senha: json['senha']?.toString() ?? '', // evita erro quando for null
      funcao: json['funcao']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
      'complemento': complemento,
      'senha': senha,
      'funcao': funcao,
    };
  }
}
// ...existing code...