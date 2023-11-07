import 'package:faz_acontecer/aperitivos_evento.dart';
import 'package:flutter/material.dart';
import 'cad_event.dart';
import 'detail_event.dart';
import 'event.dart';

class CategoriaAperitivosEvento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column( // Usando uma coluna para empilhar widgets verticalmente
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Categorias',
                      style: TextStyle(
                        fontSize: 20, // Tamanho de fonte maior
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
            ),
            Container(
              padding:  EdgeInsets.only(
                left: 50.0,
                right: 50.0,
                top: 10.0, // Reduzido o valor do espaçamento superior
                bottom: 10.0, // Reduzido o valor do espaçamento inferior
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AperitivosEvento(),
                        ),
                      );
                    },
                    child:  CustomCard(
                      image: AssetImage('assets/images/categorias/categoriaSalgados.png'),
                      name: 'Salgados',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AperitivosEvento(),
                        ),
                      );
                    },
                    child:  CustomCard(
                      image: AssetImage('assets/images/categorias/categoriaRefrigerantes.png'),
                      name: 'Refrigerantes',
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: image,
            height: 70,
            fit: BoxFit.cover, // Ajusta a imagem ao espaço do Card
          ),
          Container(
            padding: EdgeInsets.only(
              left: 50.0,
              right: 50.0,
              top: 20.0, // Reduzido o valor do espaçamento superior
              bottom: 20.0, // Reduzido o valor do espaçamento inferior
            ),
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
