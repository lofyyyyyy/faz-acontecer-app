import 'dart:convert';

class Decoracao {
  int id;
  String? nome;
  double preco_unidade;
  int quantidade;
  int idCategoria;
  int idEvento;
  DateTime data_criacao;
  DateTime data_modificacao;
  bool ativo;
  bool check;

  Decoracao({
    required this.id,
    this.nome,
    required this.preco_unidade,
    required this.quantidade,
    required this.idCategoria,
    required this.idEvento,
    required this.data_criacao,
    required this.data_modificacao,
    required this.ativo,
    required this.check,
  });

  factory Decoracao.fromJson(Map<String, dynamic> json) {
    return Decoracao(
      id: json['id'],
      nome: json['nome'],
      preco_unidade: json['preco_unidade'].toDouble(),
      quantidade: json['quantidade'],
      idCategoria: json['idCategoria'],
      idEvento: json['idEvento'],
      data_criacao: DateTime.parse(json['data_criacao']),
      data_modificacao: DateTime.parse(json['data_modificacao']),
      ativo: json['ativo'],
      check: json['check'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'preco_unidade': preco_unidade,
      'quantidade': quantidade,
      'idCategoria': idCategoria,
      'idEvento': idEvento,
      'data_criacao': data_criacao.toIso8601String(),
      'data_modificacao': data_modificacao.toIso8601String(),
      'ativo': ativo,
      'check': check,
    };
  }
}

class NovaDecoracao {
  String? nome;
  double preco_unidade;
  int quantidade;
  int idCategoria;
  int idEvento;

  NovaDecoracao({
    this.nome,
    required this.preco_unidade,
    required this.quantidade,
    required this.idCategoria,
    required this.idEvento,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'preco_unidade': preco_unidade,
      'quantidade': quantidade,
      'idCategoria': idCategoria,
      'idEvento': idEvento,
    };
  }
}

class AtualizarDecoracao {
  String? nome;
  double preco_unidade;
  int quantidade;
  int idCategoria;
  bool check;
  bool ativo;

  AtualizarDecoracao({
    this.nome,
    required this.preco_unidade,
    required this.quantidade,
    required this.idCategoria,
    required this.check,
    required this.ativo,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'preco_unidade': preco_unidade,
      'quantidade': quantidade,
      'idCategoria': idCategoria,
      'check': check,
      'ativo': ativo,
    };
  }
}
