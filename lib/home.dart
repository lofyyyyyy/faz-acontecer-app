import 'package:faz_acontecer/Models/evento.dart';
import 'package:faz_acontecer/login_page.dart';
import 'package:flutter/material.dart';
import 'Models/usuario.dart';
import 'detail_event.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Usuario usuario;

  HomeScreen(this.usuario);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CustomEvent> eventos = [];
  CustomEvent? eventoSelecionado = null;
  List<Widget> customCards = [];

  bool isDataLoaded = false; // Variável para verificar se os dados foram carregados

  @override
  void initState() {
    super.initState();
    // Chame a função para obter os eventos quando o widget for iniciado
    getEventos();
  }

  // Função para obter os eventos do servidor
  Future<List<Widget>> getEventos() async {
    print('Chamando getEventos');
    try {
      final response = await http.get(
        Uri.parse('https://localhost:7127/Evento?idUsuario=${widget.usuario.id}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> eventosList = jsonDecode(response.body) as List;
        eventos = eventosList.map((json) => CustomEvent.fromJson(json)).toList();
        print('Número de eventos: ${eventos.length}');

        return eventos.map((evento) {
          return CustomCard(
            image: AssetImage('assets/images/icone-calendario.png'),
            name: evento.nome,
            eventos: eventos,
            eventoSelecionado: eventoSelecionado,
            onCardTap: onCardTap,
            onTap: () {
              setState(() {
                // Atualiza o eventoSelecionado quando o card é tocado
                eventoSelecionado = evento;
                print('Evento selecionado: $eventoSelecionado');
              });
            },
          );
        }).toList();
      } else {
        // Tratar erros aqui, como exibir uma mensagem para o usuário
        return []; // Retorna uma lista vazia em caso de erro
      }
    } catch (error) {
      // Tratar erros aqui, como exibir uma mensagem para o usuário
      print('Erro ao obter eventos: $error');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  void onCardTap(CustomEvent? evento) {
    setState(() {
      eventoSelecionado = evento;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FutureBuilder(
                  future: getEventos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Erro ao carregar eventos');
                    } else if (snapshot.data != null) {
                      List<Widget> customCardRows = [];

                      for (int i = 0; i < snapshot.data!.length; i += 2) {
                        customCardRows.add(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              snapshot.data![i],
                              if (i + 1 < snapshot.data!.length) snapshot.data![i + 1],
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: customCardRows,
                      );
                    } else {
                      return Text('Dados nulos'); // Adicione a lógica de tratamento de dados nulos conforme necessário
                    }
                  },
                ),
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
        foregroundColor: Colors.white, // Definindo a cor da fonte
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0), // Definindo a borda para tornar o botão redondo
        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final AssetImage image;
  final String? name;
  final List<CustomEvent> eventos;
  CustomEvent? eventoSelecionado;
  final VoidCallback onTap;
  final Function(CustomEvent?) onCardTap;

  CustomCard({
    required this.image,
    required this.name,
    required this.eventos,
    required this.eventoSelecionado,
    required this.onTap,
    required this.onCardTap,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCardTap(widget.eventos.firstWhere((evento) => evento.nome == widget.name));
      },
      child: Container(
        width: 200.0, // Defina a largura desejada para os cards
        height: 170.0,
        child: Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Image(
                image: widget.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    widget.name.toString(),
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
      ),
    );
  }
}


