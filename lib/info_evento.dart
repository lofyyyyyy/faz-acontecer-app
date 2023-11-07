import 'package:flutter/material.dart';
import 'cad_event.dart';
import 'detail_event.dart';
import 'event.dart';

class InfoEvento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Informações do Evento',
                style: TextStyle(
                  fontSize: 15, // Tamanho de fonte maior
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Nome do Evento',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Data do Evento'),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Local do Evento'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição do Evento'),
                maxLines: 4,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Observações'),
                maxLines: 4,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Orçamento'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Data Final para Confirmação da Presença'),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Lógica para salvar as informações do evento
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                ),
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

