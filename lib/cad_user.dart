import 'package:flutter/material.dart';
import 'login_page.dart'; 

class CadastroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
        backgroundColor: Colors.purple, 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 250,
              height: 250,
              child: Image.asset('assets/images/logo.png'), 
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // adicionar a lógica para processar o cadastro
                // navegar de volta para a tela de login
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.purple, 
              ),
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
