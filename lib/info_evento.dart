import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'Models/usuario.dart';
import 'package:faz_acontecer/Models/evento.dart';

class InfoEvento extends StatefulWidget {
  final Usuario usuario;
  final CustomEvent? evento;
  final Function(CustomEvent) onSaveEvento;

  InfoEvento(this.usuario, this.onSaveEvento, this.evento);

  @override
  _InfoEventScreenState createState() => _InfoEventScreenState();
}

class _InfoEventScreenState extends State<InfoEvento> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController dtEventoController = TextEditingController();
  TextEditingController localEventoController = TextEditingController();
  TextEditingController descricaoEventoController = TextEditingController();
  TextEditingController observacaoEventoController = TextEditingController();
  TextEditingController orcamentoEventoController = TextEditingController();

  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();

    if (widget.evento != null) {
      nomeController.text = widget.evento!.nome ?? '';
      dtEventoController.text = widget.evento!.data_evento?.toString() ?? '';
      localEventoController.text = widget.evento!.local_evento ?? '';
      descricaoEventoController.text = widget.evento!.descricao ?? '';
      observacaoEventoController.text = widget.evento!.observacao ?? '';
      orcamentoEventoController.text = widget.evento!.orcamento.toString() ?? '';
    }
  }
  Future<void> _selectDateTime(BuildContext context) async {
    // Exibir o seletor de data
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) return;

    // Exibir o seletor de hora
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
    );

    if (pickedTime == null) return;

    // Combinar data e hora
    final DateTime combinedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      selectedDateTime = combinedDateTime;
      dtEventoController.text = combinedDateTime.toString();
    });
  }

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
                controller: nomeController,
                decoration: InputDecoration(
                    labelText: 'Nome do Evento',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: dtEventoController,
                decoration: InputDecoration(
                  labelText: 'Data do Evento',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDateTime(context),
                  ),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: localEventoController,
                decoration: InputDecoration(labelText: 'Local do Evento'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: descricaoEventoController,
                decoration: InputDecoration(labelText: 'Descrição do Evento'),
                maxLines: 4,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: observacaoEventoController,
                decoration: InputDecoration(labelText: 'Observações'),
                maxLines: 4,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: orcamentoEventoController,
                decoration: InputDecoration(labelText: 'Orçamento'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final Map<String, String> data = {
                    'nome': nomeController.text,
                    'data_evento': dtEventoController.text,
                    'horario': dtEventoController.text,
                    'local_evento': localEventoController.text,
                    'descricao': descricaoEventoController.text,
                    'observacao': observacaoEventoController.text,
                    'orcamento': orcamentoEventoController.text,
                    'id_usuario': widget.usuario.id.toString()
                  };

                  final String dataJson = jsonEncode(data);

                  if(widget.evento == null){
                    final response = await http.post(
                      Uri.parse('https://localhost:7127/Evento'),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: dataJson,
                    );

                    if (response.statusCode == 200) {
                      CustomEvent evento = CustomEvent.fromJson(jsonDecode(response.body));

                      widget.onSaveEvento(evento);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Evento Criado com sucesso'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } if (response.statusCode == 401) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao Criar Evento. Tente Novamente.'),
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
                  }
                  else {
                    final response = await http.put(
                      Uri.parse('https://localhost:7127/Evento/${widget.evento!.id}'),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: dataJson,
                    );

                    if (response.statusCode == 200) {
                      CustomEvent evento = CustomEvent.fromJson(jsonDecode(response.body));

                      widget.onSaveEvento(evento);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Evento Atualizado com sucesso'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } if (response.statusCode == 401) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao Atualizar Evento. Tente Novamente.'),
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
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                ),
                child: Text(
                  'Salvar',
                  style: TextStyle(
                    color: Colors.white,
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

