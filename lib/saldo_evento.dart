import 'package:flutter/material.dart';
import 'cad_event.dart';
import 'detail_event.dart';
import 'event.dart';

class Transaction {
  final String description;
  final double amount;

  Transaction({required this.description, required this.amount});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SaldoEvento(),
    );
  }
}

class SaldoEvento extends StatelessWidget {
  final double saldo = 1000.0; // Saldo do usuário
  List<Transaction> get extrato => [
    Transaction(description: 'Compra 1', amount: -50.0),
    Transaction(description: 'Compra 2', amount: -30.0),
    Transaction(description: 'Compra 3', amount: -100.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                left: 20.0,
                top: 20.0
              ),
              child: Text(
                'Saldo',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                'R\$ $saldo',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple
                ),
              ),
            ),
            Divider(
              color: Colors.black26, // Cor da linha
              height: 5, // Altura da linha
              thickness: 2, // Espessura da linha
              indent: 20, // Recuo à esquerda
              endIndent: 20, // Recuo à direita
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: extrato.length,
                itemBuilder: (context, index) {
                  final transaction = extrato[index];
                  return ListTile(
                    title: Text(transaction.description),
                    subtitle: Text(
                      'R\$ ${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: transaction.amount < 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

