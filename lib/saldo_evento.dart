import 'dart:convert';
import 'package:flutter/material.dart';
import 'Models/evento.dart';
import 'Models/usuario.dart';
import 'package:http/http.dart' as http;

class Transaction {
  final double saldo;
  final List<ItensTransaction> itens;

  Transaction({required this.saldo, required this.itens});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    List<dynamic> itensJson = json['itens'] ?? [];
    List<ItensTransaction> itens = itensJson.map((item) {
      return ItensTransaction.fromJson(item);
    }).toList();

    return Transaction(
      saldo: json['saldo'],
      itens: itens,
    );
  }
}

class ItensTransaction {
  final String descricao;
  final int quantidade;
  final double preco;

  ItensTransaction({required this.descricao, required this.quantidade, required this.preco});

  factory ItensTransaction.fromJson(Map<String, dynamic> json) {
    return ItensTransaction(
      descricao: json['descricao'],
      quantidade: json['quantidade'],
      preco: json['preco'],
    );
  }
}

class SaldoEvento extends StatefulWidget {
  final Usuario? usuario;
  final CustomEvent? evento;

  SaldoEvento(this.usuario, this.evento);

  @override
  _SaldoEvento createState() => _SaldoEvento();
}

class _SaldoEvento extends State<SaldoEvento> {
  Transaction? transaction = null;

  @override
  void initState() {
    super.initState();
    getSaldoDaConta();
  }

  Future<Transaction?> getSaldoDaConta() async {
    try {
      final response = await http.get(
        Uri.parse('https://localhost:7127/Evento/CalcularSaldo/${widget.evento?.id}'),
      );

      if (response.statusCode == 200) {
        Transaction transactions = Transaction.fromJson(jsonDecode(response.body));
        transaction = Transaction(
          saldo: transactions.saldo,
          itens: transactions.itens.map((transaction) {
            return ItensTransaction(
              descricao: transaction.descricao,
              quantidade: transaction.quantidade,
              preco: transaction.preco,
            );
          }).toList(),
        );

        return transaction;
      }
    } catch (error) {
      print('Erro ao obter saldo: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Transaction?>(
        future: getSaldoDaConta(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Transaction transaction = snapshot.data!;

            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        left: 20.0,
                        top: 20.0,
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
                        'R\$ ${transaction.saldo}',
                        style: TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black26,
                      height: 5,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: transaction.itens.length,
                        itemBuilder: (context, index) {
                          final transactionItem = transaction.itens[index];
                          return ListTile(
                            title:  Text('${transactionItem.quantidade.toString()}x ${transactionItem.descricao.toString()}'),
                            subtitle: Text(
                              'R\$ ${transactionItem.preco.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: transactionItem.preco < 0 ? Colors.red : Colors.green,
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
        },
      ),
    );
  }
}

