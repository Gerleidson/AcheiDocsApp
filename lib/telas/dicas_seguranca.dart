import 'package:flutter/material.dart';

class DicasSeguranca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dicas de Segurança'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Center(
                child: Text(
                  'Dicas de Segurança para Entrega e Recebimento de Documentos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Dica 1
              Text(
                '1. Verifique a autenticidade:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Ao receber ou entregar documentos, sempre confirme a autenticidade da pessoa envolvida.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Dica 2
              Text(
                '2. Marque um local seguro para entrega:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Combine a entrega ou recebimento em locais públicos, movimentados e, preferencialmente, com câmeras de segurança.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Dica 3
              Text(
                '3. Deixe os documentos em um local seguro ou órgão público:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Se você não deseja devolver os documentos pessoalmente, pode deixá-los em um local seguro, como uma delegacia e informe a pessoa sobre o local para que ela possa retirá-los com segurança.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
