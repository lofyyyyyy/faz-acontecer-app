import 'package:flutter/material.dart';
import 'cad_event.dart';
import 'detail_event.dart';
import 'event.dart';

class CardData {
  final IconData icon;
  final String username;
  final String status;

  CardData({
    required this.icon,
    required this.username,
    required this.status,
  });
}

class ConvidadosEvento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CardListScreen(),
    );
  }
}

class CardListScreen extends StatelessWidget {
  final List<CardData> cardDataList = [
    CardData(icon: Icons.person, username: 'User 1', status: 'Pendente'),
    CardData(icon: Icons.person, username: 'User 2', status: 'Aceitou'),
    CardData(icon: Icons.person, username: 'User 3', status: 'Recusou'),
    // Adicione mais dados de cartão conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: cardDataList.length,
        itemBuilder: (context, index) {
          return CardWidget(cardData: cardDataList[index]);
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardData cardData;

  CardWidget({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinhe o status à direita
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(cardData.icon, size: 30.0),
                  Text(
                    cardData.username,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            Text(
              cardData.status,
              style: TextStyle(color: cardData.status == 'Pendente' ? Colors.black45 : cardData.status == 'Aceitou' ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

