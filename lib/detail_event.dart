import 'package:faz_acontecer/aperitivos_evento.dart';
import 'package:faz_acontecer/categoria_decoracoes_evento.dart';
import 'package:faz_acontecer/convidados_evento.dart';
import 'package:faz_acontecer/decoracoes_evento.dart';
import 'package:faz_acontecer/home.dart';
import 'package:faz_acontecer/info_evento.dart';
import 'package:faz_acontecer/saldo_evento.dart';
import 'package:flutter/material.dart';
import 'categoria_aperitivos_evento.dart';
import 'event.dart';


class DetalhesEventoScreen extends StatelessWidget {

  DetalhesEventoScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5, // Número de abas
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
              },
            ),
            title: Text('Detalhes do Evento'),
            backgroundColor: Colors.purple,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.info),
                ),
                Tab(
                  icon: Icon(Icons.group),
                ),
                Tab(
                  icon: Icon(Icons.fastfood),
                ),
                Tab(
                  icon: Icon(Icons.celebration),
                ),
                Tab(
                  icon: Icon(Icons.attach_money),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              InfoEvento(),
              ConvidadosEvento(),
              CategoriaAperitivosEvento(),
              CategoriaDecoracoesEvento(),
              SaldoEvento(),
            ],
          ),
        ),
      ),
    );
  }
}
