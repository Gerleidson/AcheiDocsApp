import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Sobre extends StatelessWidget {
  final String appVersion = "1.0.1"; // Versão do app
  final String privacyPolicyUrl = "https://www.acheidocs.com.br/politica.html"; // URL real da política de privacidade
  final String suporteEmail = "computech.camacari@gmail.com"; // E-mail de suporte

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF001b48),
        foregroundColor: Colors.white,
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
                ),
              ),
            ),
            SizedBox(height: 10),

            // Descrição do app
            Center(
              child: Text(
                'O AcheiDocs é um aplicativo para ajudar na recuperação de documentos perdidos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
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
                leading: Icon(Icons.info),
                title: Text(
                  'Versão do Aplicativo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  appVersion,
                  style: TextStyle(fontSize: 16),
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
                leading: Icon(Icons.privacy_tip),
                title: Text(
                  'Política de Privacidade',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  _abrirUrl(privacyPolicyUrl);
                },
                trailing: Icon(Icons.arrow_forward),
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
                leading: Icon(Icons.email),
                title: Text(
                  'Contato',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  suporteEmail,
                  style: TextStyle(fontSize: 16),
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

  // Método para abrir URLs no navegador externo
  void _abrirUrl(String url) async {
    final Uri urlUri = Uri.parse(url);
    if (await canLaunchUrl(urlUri)) {
      await launchUrl(urlUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o link.';
    }
  }

  // Método para abrir o app de e-mail
  void _abrirEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri(queryParameters: {'subject': 'Ajuda com o AcheiDocs'}).query,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o app de e-mail.';
    }
  }
}