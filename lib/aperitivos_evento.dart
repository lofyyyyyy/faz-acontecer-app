import 'package:flutter/material.dart';
import 'cad_event.dart';
import 'detail_event.dart';
import 'event.dart';

class Item {
  final String name;
  final int quantity;

  Item({required this.name, required this.quantity});
}

class AperitivosEvento extends StatelessWidget {
  final List<Item> items = [
    Item(name: 'Item 1', quantity: 5),
    Item(name: 'Item 2', quantity: 3),
    Item(name: 'Item 3', quantity: 2),
    // Adicione mais itens conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aperitivos do Evento'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ItemCard(item: items[index]);
        },
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;

  ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantidade: ${item.quantity}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Nome: ${item.name}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // Lógica para marcar o item como concluído
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Lógica para excluir o item
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

