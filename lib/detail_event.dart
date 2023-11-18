import 'package:faz_acontecer/Models/usuario.dart';
import 'package:faz_acontecer/saldo_evento.dart';
import 'package:flutter/material.dart';

import 'Models/evento.dart';
import 'categoria_aperitivos_evento.dart';
import 'categoria_decoracoes_evento.dart';
import 'convidados_evento.dart';
import 'home.dart';
import 'info_evento.dart';

class DetalhesEventoScreen extends StatelessWidget {
  final Usuario usuario;
  final CustomEvent? evento;

  DetalhesEventoScreen(this.usuario, this.evento);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(this.usuario),
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
