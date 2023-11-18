import 'dart:convert';

import 'aperitivo.dart';
import 'decoracao.dart';

class CustomEvent {
  int id;
  String? nome;
  DateTime data_evento;
  DateTime horario;
  String? local_evento;
  String? descricao;
  String? observacao;
  double orcamento;
  DateTime data_final_confirmacao_convite;
  DateTime data_criacao;
  DateTime data_modificacao;
  bool ativo;
  int id_usuario;

  CustomEvent({
    required this.id,
    this.nome,
    required this.data_evento,
    required this.horario,
    this.local_evento,
    this.descricao,
    this.observacao,
    required this.orcamento,
    required this.data_final_confirmacao_convite,
    required this.data_criacao,
    required this.data_modificacao,
    required this.ativo,
    required this.id_usuario,
  });

  factory CustomEvent.fromJson(Map<String, dynamic> json) {
    return CustomEvent(
      id: json['id'],
      nome: json['nome'],
      data_evento: DateTime.parse(json['data_evento']),
      horario: DateTime.parse(json['horario']),
      local_evento: json['local_evento'],
      descricao: json['descricao'],
      observacao: json['observacao'],
      orcamento: json['orcamento'].toDouble(),
      data_final_confirmacao_convite: DateTime.parse(json['data_final_confirmacao_convite']),
      data_criacao: DateTime.parse(json['data_criacao']),
      data_modificacao: DateTime.parse(json['data_modificacao']),
      ativo: json['ativo'],
      id_usuario: json['id_usuario'],
    );
  }
}

class NovoEvento {
  String? nome;
  DateTime data_evento;
  DateTime horario;
  String? local_evento;
  String? descricao;
  String? observacao;
  double orcamento;
  int id_usuario;

  NovoEvento({
    this.nome,
    required this.data_evento,
    required this.horario,
    this.local_evento,
    this.descricao,
    this.observacao,
    required this.orcamento,
    required this.id_usuario,
  });
}

class AtualizarEvento {
  String? nome;
  DateTime data_evento;
  DateTime horario;
  String? local_evento;
  String? descricao;
  String? observacao;
  double orcamento;
  bool ativo;

  AtualizarEvento({
    this.nome,
    required this.data_evento,
    required this.horario,
    this.local_evento,
    this.descricao,
    this.observacao,
    required this.orcamento,
    required this.ativo,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'data_evento': data_evento.toIso8601String(),
      'horario': horario.toIso8601String(),
      'local_evento': local_evento,
      'descricao': descricao,
      'observacao': observacao,
      'orcamento': orcamento,
      'ativo': ativo,
    };
  }
}

class RetornarExtratoEvento {
  double saldo;
  List<Aperitivo>? aperitivos;
  List<Decoracao>? decoracoes;

  RetornarExtratoEvento({
    required this.saldo,
    this.aperitivos,
    this.decoracoes,
  });

  factory RetornarExtratoEvento.fromJson(Map<String, dynamic> json) {
    return RetornarExtratoEvento(
      saldo: json['saldo'].toDouble(),
      aperitivos: json['aperitivos'] != null
          ? List<Aperitivo>.from(json['aperitivos'].map((x) => Aperitivo.fromJson(x)))
          : null,
      decoracoes: json['decoracoes'] != null
          ? List<Decoracao>.from(json['decoracoes'].map((x) => Decoracao.fromJson(x)))
          : null,
    );
  }
}