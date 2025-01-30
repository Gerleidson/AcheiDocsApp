import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FeedbackScreen extends StatefulWidget { // Renomeado para FeedbackScreen
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("feedbacks");

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();

  void _enviarFeedback() {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final comentario = _comentarioController.text.trim();

    if (nome.isNotEmpty && email.isNotEmpty && comentario.isNotEmpty) {
      _dbRef.push().set({
        "nome": nome,
        "email": email,
        "comentario": comentario,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Feedback enviado com sucesso!")),
        );
        _nomeController.clear();
        _emailController.clear();
        _comentarioController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao enviar feedback: $error")),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
          style: TextStyle(color: Colors.white), // Definindo a cor do texto como branco
        ),
        backgroundColor: Color(0xFF001b48),
        foregroundColor: Colors.white, // Garantir que os ícones da AppBar também sejam brancos
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Gostou do site? Tem alguma sugestão ou crítica? Fique à vontade para nos enviar seu comentário!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001b48),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Campo Nome Completo
              _buildTextField(_nomeController, 'Nome Completo'),
              SizedBox(height: 16),

              // Campo Email
              _buildTextField(_emailController, 'Email', isEmail: true),
              SizedBox(height: 16),

              // Campo Comentário
              _buildTextField(_comentarioController, 'Comentário', maxLines: 5),
              SizedBox(height: 20),

              // Botão Enviar Feedback
              Center(
                child: ElevatedButton(
                  onPressed: _enviarFeedback,
                    child: Text(
                      'Enviar Feedback',
                      style: TextStyle(
                          fontSize: 16,
                          color:Colors.white
                      ),
                    ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xFF001b48),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para criar campos de texto
  Widget _buildTextField(TextEditingController controller, String label, {bool isEmail = false, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          style: TextStyle(fontSize: 16),
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          maxLines: maxLines,
        ),
      ),
    );
  }
}
