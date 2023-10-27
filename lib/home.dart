import 'package:flutter/material.dart';
import 'cad_event.dart'; 
import 'event.dart';

class HomeScreen extends StatelessWidget {
  final List<Evento> eventos = [
    Evento('Evento 1', 'imagem_evento_1.png'), 
    Evento('Evento 2', 'imagem_evento_2.png'), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start, // Alterado de "center" para "start"
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Bem vindo(a),",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 3),
          Text(
            "Usuário",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            "Meus Eventos",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: eventos.map((evento) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(evento.imagem),
                        SizedBox(height: 8),
                        Text(evento.nome),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CadastroEvento(),
                ));
              },
              backgroundColor: Colors.purple,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
