import 'dart:convert';

import 'package:faz_acontecer/Models/aperitivo.dart';
import 'package:flutter/material.dart';
import 'Models/evento.dart';
import 'Models/usuario.dart';
import 'package:http/http.dart' as http;

class Item {
  final int id;
  final String name;
  final int quantity;
  final bool check;

  Item({required this.id,required this.name, required this.quantity, required this.check});
}

class AperitivosEvento extends StatefulWidget {
  final Usuario? usuario;
  final CustomEvent? evento;

  AperitivosEvento(this.usuario, this.evento);

  @override
  _AperitivosEvento createState() => _AperitivosEvento();
}

class _AperitivosEvento extends State<AperitivosEvento> {
  List<Aperitivo> aperitivos = [];

  @override
  void initState() {
    super.initState();
    getAperitivos();
  }

  Future<List<Item>> getAperitivos() async {
    try {
      final response = await http.get(
        Uri.parse('https://localhost:7127/Aperitivo?idEvento=${widget.evento?.id}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> aperitivosList = jsonDecode(response.body) as List;
        aperitivos = aperitivosList.map((json) => Aperitivo.fromJson(json)).toList();

        return aperitivos.map((aperitivo) {
          return Item(
            id: aperitivo.id,
            name: aperitivo.nome.toString(),
            quantity: aperitivo.quantidade,
            check: aperitivo.check
          );
        }).toList();
      } else {
        return [];
      }
    } catch (error) {
      print('Erro ao obter eventos: $error');
      return [];
    }
  }

  Future<void> checkAperitivo(aperitivoId) async {
    try {
      final response = await http.put(
        Uri.parse('https://localhost:7127/Aperitivo/Check?aperitivoId=${aperitivoId}'),
      );

      if (response.statusCode == 200) {
        Aperitivo aperitivo = Aperitivo.fromJson(jsonDecode(response.body));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aperitivo Concluído com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao Concluir Aperitivo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Erro ao Concluir Aperitivo: $error');
      return;
    }
  }

  Future<void> deletarAperitivo(aperitivoId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://localhost:7127/Aperitivo/${aperitivoId}'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aperitivo Deletado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao Deletar Aperitivo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Erro ao Deletar Aperitivo: $error');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Item>>(
          future: getAperitivos(), // Substitua pela chamada real do seu método
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar os aperitivos'));
            } else {
              List<Item> aperitivos = snapshot.data ?? [];
              return  ListView.builder(
                itemCount: aperitivos.length,
                itemBuilder: (context, index) {
                  return ItemCard(
                    item: aperitivos[index],
                    onCheckPressed: (aperitivoId) {
                      checkAperitivo(aperitivoId);
                    },
                    onDeletePressed: (aperitivoId){
                      deletarAperitivo(aperitivoId);
                    },
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddAperitivoModal(context);
          },
          tooltip: 'Adicionar Aperitivo',
          child: Icon(Icons.add),
        ),
    );
  }

  void _showAddAperitivoModal(BuildContext context)  {
    TextEditingController nomeAperitivoController = TextEditingController();
    TextEditingController precoUnidadeAperitivoController = TextEditingController();
    TextEditingController quantidadeController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Aperitivo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: nomeAperitivoController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: precoUnidadeAperitivoController,
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
                  'nome': nomeAperitivoController.text,
                  'preco_unidade': precoUnidadeAperitivoController.text,
                  'quantidade': quantidadeController.text,
                  'idCategoria': '1',
                  'idEvento': widget.evento?.id?.toString() ?? ''
                };

                final String dataJson = jsonEncode(data);

                final response = await http.post(
                  Uri.parse('https://localhost:7127/Aperitivo'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: dataJson,
                );

                if (response.statusCode == 200) {
                  Aperitivo aperitivo = Aperitivo.fromJson(jsonDecode(response.body));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Aperitivo Criado com sucesso'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } if (response.statusCode == 401) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao Criar Aperitivo. Tente Novamente.'),
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

