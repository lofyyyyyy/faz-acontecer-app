import 'package:faz_acontecer/home.dart';
import 'package:flutter/material.dart';
import 'Models/usuario.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroScreen extends StatelessWidget {
  @override
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

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
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              child: TextField(
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final Map<String, String> data = {
                  'nome': nomeController.text,
                  'email': emailController.text,
                  'senha': senhaController.text,
                };

                final String dataJson = jsonEncode(data);

                final response = await http.post(
                  Uri.parse('https://localhost:7127/Usuario'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: dataJson,
                );

                if (response.statusCode == 200) {
                  Usuario usuario = Usuario.fromJson(jsonDecode(response.body));

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(usuario),
                  ));
                }
                else if(response.statusCode == 500) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Usuário já existe'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
