import 'package:flutter/material.dart';

class CadastroEvento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualização de Eventos'),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Ação do botão "Adicionar"
            },
            child: Icon(Icons.add),
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Código')),
              DataColumn(label: Text('Nome do Evento')),
              DataColumn(label: Text('Descrição')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('1')),
                DataCell(Text('Evento 1')),
                DataCell(Text('Descrição do Evento 1')),
              ]),
              DataRow(cells: [
                DataCell(Text('2')),
                DataCell(Text('Evento 2')),
                DataCell(Text('Descrição do Evento 2')),
              ]),
              // Adicione mais linhas conforme necessário
            ],
          ),
        ],
      ),
    );
  }
}
