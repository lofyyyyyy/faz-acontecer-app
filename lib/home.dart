import 'package:faz_acontecer/login_page.dart';
import 'package:flutter/material.dart';
import 'cad_event.dart'; 
import 'detail_event.dart';
import 'event.dart';

class HomeScreen extends StatelessWidget {
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
        child: Column( // Usando uma coluna para empilhar widgets verticalmente
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
                    'Sabine Freiman',
                    style: TextStyle(
                      fontSize: 25, // Tamanho de fonte maior
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetalhesEventoScreen(),
                        ),
                      );
                    },
                    child:  CustomCard(
                      image: AssetImage('assets/images/icone-calendario.png'),
                      name: 'Encontro Brilhante',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetalhesEventoScreen(),
                        ),
                      );
                    },
                    child:  CustomCard(
                      image: AssetImage('assets/images/icone-calendario.png'),
                      name: 'Evento Encantado',
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
}

class CustomCard extends StatelessWidget {
  final AssetImage image;
  final String name;

  CustomCard({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: <Widget>[
          Image(
            image: image,
            width: 100,
            height: 100,
            fit: BoxFit.cover, // Ajusta a imagem ao espaço do Card
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
