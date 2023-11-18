import 'package:faz_acontecer/Models/evento.dart';
import 'package:faz_acontecer/login_page.dart';
import 'package:flutter/material.dart';
import 'Models/usuario.dart';
import 'Models/evento.dart' as Models;
import 'cad_event.dart';
import 'detail_event.dart';
import 'event.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final Usuario usuario;

  HomeScreen(this.usuario);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CustomEvent> eventos = [];
  CustomEvent? eventoSelecionado = null;

  @override
  void initState() {
    super.initState();
    // Chame a função para obter os eventos quando o widget for iniciado
    getEventos();
  }

  // Função para obter os eventos do servidor
  Future<void> getEventos() async {
    final response = await http.get(
      Uri.parse('https://localhost:7127/Evento?idUsuario=${widget.usuario.id}'),
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = jsonDecode(response.body);
      List<CustomEvent> eventosList = [];

      if (jsonResponse is List) {
        eventosList = jsonResponse.map((item) => CustomEvent.fromJson(item)).toList();
      } else if (jsonResponse is Map<String, dynamic>) {
        eventosList.add(CustomEvent.fromJson(jsonResponse));
      }
    } else {
      // Tratar erros aqui, como exibir uma mensagem para o usuário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.purple,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Se o nome do usuário estiver disponível, exibí-lo
            if (widget.usuario.nome != null)
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bem vindo(a),',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      widget.usuario.nome!,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: eventos.map((evento) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetalhesEventoScreen(widget.usuario, eventoSelecionado),
                        ),
                      );
                    },
                    child: CustomCard(
                      image: AssetImage('assets/images/icone-calendario.png'),
                      name: evento.nome,
                      eventos: eventos,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetalhesEventoScreen(widget.usuario, eventoSelecionado),
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final AssetImage image;
  final String? name;
  final List<CustomEvent> eventos;
  CustomEvent? eventoSelecionado;

  CustomCard({required this.image, required this.name, required this.eventos, this.eventoSelecionado });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Procura o evento na lista com base no nome
        eventoSelecionado = eventos.firstWhere((evento) => evento.nome == name);
      },
      child: Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Image(
              image: image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  name.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
