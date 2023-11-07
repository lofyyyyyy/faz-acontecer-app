import 'package:flutter/material.dart';
import 'home.dart';
import 'cad_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  @override
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fundo_telas.png'), // Substitua pelo caminho da sua imagem de fundo
            fit: BoxFit.cover, // Ajuste a imagem para cobrir toda a tela
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 20),
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
                    'email': emailController.text,
                    'senha': senhaController.text,
                  };

                  final String dataJson = jsonEncode(data);

                  final response = await http.post(
                    Uri.parse('https://localhost:7127/Login'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: dataJson,
                  );

                  if (response.statusCode == 200) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
                  } if (response.statusCode == 401) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email ou senha inválidos'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  else if(response.statusCode == 500) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro na solicitação: ${response.statusCode}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                ),
                child: Text('Entrar'),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CadastroScreen(),
                  ));
                },
                child: Text(
                  "Não tem cadastro? Clique aqui para cadastrar",
                  style: TextStyle(
                    color: Color(0xFF43575F),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}