class Convidado {
  final int id;
  final String? nome;
  final String? telefone;
  final String? email;
  final int? idEvento;
  final bool? aceitou_convite;
  final DateTime? data_criacao;
  final DateTime? data_modificacao;
  final bool? ativo;

  Convidado({
    required this.id,
    this.nome,
    this.telefone,
    this.email,
    this.idEvento,
    this.aceitou_convite,
    this.data_criacao,
    this.data_modificacao,
    this.ativo
  });

  factory Convidado.fromJson(Map<String, dynamic> json) {
    return Convidado(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
      idEvento: json['idEvento'],
      aceitou_convite: json['aceitou_convite'],
      data_criacao: DateTime.parse(json['data_criacao']),
      data_modificacao: DateTime.parse(json['data_modificacao']),
      ativo: json['ativo'],
    );
  }
  
}
