import 'dart:convert';

import 'package:flutter/material.dart';
import 'Models/evento.dart';
import 'Models/usuario.dart';
import 'package:http/http.dart' as http;

import 'Models/convidado.dart';

class CardData {
  final IconData icon;
  final String username;
  final String status;
  final Convidado? convidado;

  CardData({
    required this.icon,
    required this.username,
    required this.status,
    this.convidado
  });
}

class ConvidadosEvento extends StatefulWidget {
  final Usuario? usuario;
  final CustomEvent? evento;

  ConvidadosEvento(this.usuario, this.evento);

  @override
  _ConvidadosEvento createState() => _ConvidadosEvento();
}

class _ConvidadosEvento extends State<ConvidadosEvento> {
  List<Convidado> convidados = [];
  late CardListScreen _cardListScreen;

  @override
  void initState() {
    super.initState();
    _cardListScreen = CardListScreen(this, widget.evento, null, widget.usuario);
    getConvidados();
  }

  Future<List<CardData>> getConvidados() async {
    try {
      final response = await http.get(
        Uri.parse('https://localhost:7127/Convidado/idEvento?idEvento=${widget.evento?.id}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> convidadosList = jsonDecode(response.body) as List;
        convidados = convidadosList.map((json) => Convidado.fromJson(json)).toList();

        return convidados.map((convidado) {
          return CardData(
              icon: Icons.person,
              username: convidado!.nome.toString(),
              status: convidado.aceitou_convite == null ? 'Pendente' : convidado.aceitou_convite == true ? 'Aceito' : 'Recusado',
              convidado: convidado
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

  Widget build(BuildContext context) {
    return MaterialApp(
      home: CardListScreen(this, widget.evento, null, widget.usuario),
    );
  }

}

class CardListScreen extends StatelessWidget {
  final _ConvidadosEvento convidadosEvento;
  final CustomEvent? evento;
  final Convidado? convidado;
  final Usuario? usuario;

  CardListScreen(this.convidadosEvento, this.evento, this.convidado, this.usuario);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CardData>>(
        future: convidadosEvento.getConvidados(), // Substitua pela chamada real do seu método
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os convidados'));
          } else if(snapshot.data?.length == 0) {
            return Center(child: Text('Nenhum Convidado Registrado'));
          } else {
            List<CardData> convidados = snapshot.data ?? [];
            return ListView.builder(
              itemCount: convidados.length,
              itemBuilder: (context, index) {
                return CardWidget(cardData: convidados[index], convidado: convidados[index].convidado, evento: evento, convidadosEvento: convidadosEvento);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGuestModal(context);
        },
        tooltip: 'Adicionar Convidado',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddGuestModal(BuildContext context)  {
    TextEditingController nomeConvidadoController = TextEditingController();
    TextEditingController emailConvidadeController = TextEditingController();
    TextEditingController telefoneConvidadoController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Convidado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: nomeConvidadoController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: emailConvidadeController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: telefoneConvidadoController,
                  decoration: InputDecoration(labelText: 'Telefone'),
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
                  'nome': nomeConvidadoController.text,
                  'email': emailConvidadeController.text,
                  'telefone': telefoneConvidadoController.text,
                  'idEvento': evento?.id?.toString() ?? ''
                };

                final String dataJson = jsonEncode(data);

                if(convidado == null){
                  final response = await http.post(
                    Uri.parse('https://localhost:7127/Convidado'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: dataJson,
                  );

                  if (response.statusCode == 200) {
                    Convidado convidado = Convidado.fromJson(jsonDecode(response.body));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Convidado Criado com sucesso'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ConvidadosEvento(usuario, evento),
                    ));
                  } if (response.statusCode == 401) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao Criar Convidado. Tente Novamente.'),
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

class CardWidget extends StatelessWidget {
  final CardData cardData;
  final Convidado? convidado;
  final CustomEvent? evento;
  final _ConvidadosEvento convidadosEvento;

  CardWidget({required this.cardData, this.convidado, this.evento, required this.convidadosEvento});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showAddGuestModalUpdateConvidado(context);
      },
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(cardData.icon, size: 30.0),
                        Text(
                          cardData.username,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    cardData.status,
                    style: TextStyle(
                      color: cardData.status == 'Pendente'
                          ? Colors.black45
                          : cardData.status == 'Aceito'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGuestModalUpdateConvidado(BuildContext context)  {
    TextEditingController nomeConvidadoController = TextEditingController();
    TextEditingController emailConvidadeController = TextEditingController();
    TextEditingController telefoneConvidadoController = TextEditingController();

    nomeConvidadoController.text = convidado!.nome.toString();
    emailConvidadeController.text = convidado!.email.toString();
    telefoneConvidadoController.text = convidado!.telefone.toString();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atualizar Convidado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: nomeConvidadoController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: emailConvidadeController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: telefoneConvidadoController,
                  decoration: InputDecoration(labelText: 'Telefone'),
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
                  'nome': nomeConvidadoController.text,
                  'email': emailConvidadeController.text,
                  'telefone': telefoneConvidadoController.text,
                  'idEvento': evento?.id?.toString() ?? ''
                };

                final String dataJson = jsonEncode(data);

                if(convidado == null){
                  final response = await http.post(
                    Uri.parse('https://localhost:7127/Convidado'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: dataJson,
                  );

                  if (response.statusCode == 200) {
                    Convidado convidado = Convidado.fromJson(jsonDecode(response.body));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Convidado Criado com sucesso'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } if (response.statusCode == 401) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao Criar Convidado. Tente Novamente.'),
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
                }
                else {
                  final response = await http.put(
                    Uri.parse('https://localhost:7127/Convidado/${convidado!.id}'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: dataJson,
                  );

                  if (response.statusCode == 200) {
                    Convidado convidado = Convidado.fromJson(jsonDecode(response.body));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Convidado Atualizado com sucesso'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    convidadosEvento.getConvidados();
                  } if (response.statusCode == 401) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao Atualizar Convidado. Tente Novamente.'),
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
                }

                Navigator.of(context).pop();
              },
              child: Text('Atualizar'),
            ),
          ],
        );
      },
    );
  }
}

