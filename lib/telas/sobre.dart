import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Sobre extends StatelessWidget {
  final String appVersion = "1.0.0"; // Altere para a versão do seu app
  final String privacyPolicyUrl = "https://seusite.com/politica-de-privacidade"; // URL real
  final String suporteEmail = "computech.camacari@gmail.com"; // E-mail de suporte

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre',
          style: TextStyle(
              color: Colors.white), // Definindo a cor do texto como branco
        ),
        backgroundColor: Color(0xFF001b48),
        foregroundColor: Colors
            .white, // Garantir que os ícones da AppBar também sejam brancos
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do app
            Center(
              child: Text(
                'AcheiDocs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001b48),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Descrição do app
            Center(
              child: Text(
                'O AcheiDocs é um aplicativo para ajudar na recuperação de documentos perdidos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            SizedBox(height: 20),

            // Versão do app
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.info, color: Color(0xFF001b48)),
                title: Text(
                  'Versão do Aplicativo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  appVersion,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Política de Privacidade
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.privacy_tip, color: Color(0xFF001b48)),
                title: Text(
                  'Política de Privacidade',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  _abrirUrl(privacyPolicyUrl, context);
                },
                trailing: Icon(Icons.arrow_forward, color: Colors.black54),
              ),
            ),
            SizedBox(height: 10),

            // Contato
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.email, color: Color(0xFF001b48)),
                title: Text(
                  'Contato',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  suporteEmail,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                onTap: () {
                  _abrirEmail(suporteEmail);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para abrir URLs
  void _abrirUrl(String url, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Abrir Link"),
            content: Text("Deseja abrir este link no navegador?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _launchUrl(url); // Alteração aqui
                },
                child: Text("Abrir"),
              ),
            ],
          ),
    );
  }

  // Método para abrir o e-mail
  void _abrirEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    // Use launchUrl em vez de launch
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Caso não consiga abrir o e-mail
      throw 'Não foi possível abrir o app de e-mail.';
    }
  }

  // Método para abrir URLs genéricas (como política de privacidade)
  void _launchUrl(String url) async {
    final Uri urlUri = Uri.parse(url);
    if (await canLaunchUrl(urlUri)) {
      await launchUrl(urlUri);
    } else {
      throw 'Não foi possível abrir o link.';
    }
  }
}
