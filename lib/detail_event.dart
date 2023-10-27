import 'package:flutter/material.dart';
import 'event.dart';


class DetalhesEventoScreen extends StatelessWidget {
  final Evento evento; // Recebe o evento como argumento

  DetalhesEventoScreen(this.evento);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Evento'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(evento.imagem), 
            SizedBox(height: 16),
            Text(
              evento.nome,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ), // Exibe o nome do evento
            SizedBox(height: 16),
            Text(
              'Data: 12 de novembro de 2023', 
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Descrição do evento: Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
