import 'dart:convert';

import 'package:flutter/material.dart';
import 'Models/decoracao.dart';
import 'Models/evento.dart';
import 'Models/usuario.dart';
import 'package:http/http.dart' as http;

class Item {
  final int id;
  final String name;
  final int quantity;
  final bool check;

  Item({required this.id, required this.name, required this.quantity, required this.check});
}

class DecoracoesEvento extends StatefulWidget {
  final Usuario? usuario;
  final CustomEvent? evento;

  DecoracoesEvento(this.usuario, this.evento);

  @override
  _DecoracoesEvento createState() => _DecoracoesEvento();
}

class _DecoracoesEvento extends State<DecoracoesEvento> {
  List<Decoracao> decoracoes = [];

  @override
  void initState() {
    super.initState();
    getDecoracoes();
  }

  Future<List<Item>> getDecoracoes() async {
    try {
      final response = await http.get(
        Uri.parse('https://localhost:7127/Decoracao?idEvento=${widget.evento?.id}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> decoracoesList = jsonDecode(response.body) as List;
        decoracoes = decoracoesList.map((json) => Decoracao.fromJson(json)).toList();

        return decoracoes.map((decoracao) {
          return Item(
              id: decoracao.id,
              name: decoracao.nome.toString(),
              quantity: decoracao.quantidade,
              check: decoracao.check
          );
        }).toList();
      } else {
        return [];
      }
    } catch (error) {
      print('Erro ao obter decoracoes: $error');
      return [];
    }
  }

  Future<void> checkDecoracao(decoracaoId) async {
    try {
      final response = await http.put(
        Uri.parse('https://localhost:7127/Decoracao/Check?decoracaoId=${decoracaoId}'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Decoração Concluída com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao Concluir Decoração'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Erro ao Concluir Decoração: $error');
      return;
    }
  }

  Future<void> deletarDecoracao(decoracaoId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://localhost:7127/Decoracao/${decoracaoId}'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Decoração Deletada com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao Deletar Decoração'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Erro ao Deletar Decoração: $error');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Item>>(
        future: getDecoracoes(), // Substitua pela chamada real do seu método
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar as decorações'));
          } else if(snapshot.data?.length == 0) {
            return Center(child: Text('Nenhuma Decoração Registrado'));
          } else {
            List<Item> decoracoes = snapshot.data ?? [];
            return  ListView.builder(
              itemCount: decoracoes.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  item: decoracoes[index],
                  onCheckPressed: (decoracaoId) {
                    checkDecoracao(decoracaoId);
                  },
                  onDeletePressed: (decoracaoId){
                    deletarDecoracao(decoracaoId);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDecoracaoModal(context);
        },
        tooltip: 'Adicionar Decoração',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDecoracaoModal(BuildContext context)  {
    TextEditingController nomeDecoracaoController = TextEditingController();
    TextEditingController precoUnidadeDecoracaoController = TextEditingController();
    TextEditingController quantidadeController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Decoracao'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: nomeDecoracaoController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: precoUnidadeDecoracaoController,
                  decoration: InputDecoration(labelText: 'Preço Unitário'),
                ),
                TextFormField(
                  controller: quantidadeController,
                  decoration: InputDecoration(labelText: 'Quantidade'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final Map<String, String> data = {
                  'nome': nomeDecoracaoController.text,
                  'preco_unidade': precoUnidadeDecoracaoController.text,
                  'quantidade': quantidadeController.text,
                  'idCategoria': '1',
                  'idEvento': widget.evento?.id?.toString() ?? ''
                };

                final String dataJson = jsonEncode(data);

                final response = await http.post(
                  Uri.parse('https://localhost:7127/Decoracao'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: dataJson,
                );

                if (response.statusCode == 200) {
                  Decoracao decoracao = Decoracao.fromJson(jsonDecode(response.body));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Decoração Criada com sucesso'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } if (response.statusCode == 401) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao Criar Decoração. Tente Novamente.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                else if(response.statusCode == 500) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro na solicitação: ${response.statusCode}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  final Function(int) onCheckPressed;
  final Function(int) onDeletePressed;

  ItemCard({required this.item, required this.onCheckPressed, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.name}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Quantidade: ${item.quantity}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            if (!item.check) // Verifica se item.check é false
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      onCheckPressed(item.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      onDeletePressed(item.id);
                    },
                  ),
                ],
              ),
            if (item.check)
              Text(
                'Concluído',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}

