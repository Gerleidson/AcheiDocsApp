import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/services.dart';

// Importação das telas
import 'package:achei/telas/dicas_seguranca.dart';
import 'package:achei/telas/sobre.dart';
import 'package:achei/telas/feedback.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("documentos");

  // Controlador da página atual
  int _selectedIndex = 0;

  // Controle de dados do formulário de busca
  final TextEditingController _buscaController = TextEditingController();

  List<String> documentos = [
    'RG', 'CPF', 'CTPS', 'CNH', 'Passaporte', 'Título de Eleitor', 'Certidão', 'Outros'
  ];

  List<String> estadosBrasil = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AcheiDocs', style: TextStyle(fontWeight: FontWeight.bold)), foregroundColor: Colors.white,

        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
      ),

      // Muda drawer para endDrawer
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Página Inicial'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Dicas de Segurança'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => DicasSeguranca()));
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu
                Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu
                Navigator.push(context, MaterialPageRoute(builder: (context) => Sobre()));
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Banner informativo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Confira se seu nome está em nosso banco de dados. Se estiver, entre em contato com o responsável através do telefone cadastrado.\n\n'
                    'O cadastro será mantido por 120 dias a partir da data de registro.\n\n'
                    'Nosso objetivo é facilitar a recuperação de seus documentos de forma rápida e segura!',
                style: TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            // Formulário de busca de documento
            _buildFormularioBusca(),

            const SizedBox(height: 30),

            // Formulário para cadastrar documentos
            CadastrarDocumento(),

            const SizedBox(height: 30),

            // Contador atualizado em tempo real
            StreamBuilder<DatabaseEvent>(
              stream: _dbRef.onValue,
              builder: (context, snapshot) {
                int totalCadastros = snapshot.hasData && snapshot.data!.snapshot.children.isNotEmpty
                    ? snapshot.data!.snapshot.children.length
                    : 0;
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Total de cadastros: $totalCadastros',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Formulário de busca de documentos
  Widget _buildFormularioBusca() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            TextFormField(
              controller: _buscaController,
              decoration: InputDecoration(
                labelText: 'Digite o nome completo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                prefixIcon: Icon(
                  Icons.search, // Ícone de lupa
                  color: Colors.blue,
                ),
              ),
              style: const TextStyle(fontSize: 16),
              onChanged: (value) {
                // Inicia a busca automaticamente à medida que o usuário digita
                _buscarDocumento(value);
              },
            ),
            const SizedBox(height: 16),
            // Exibir o resultado da busca, caso tenha encontrado um documento
            if (_documentoEncontrado != null) ...[
              Text('Documento encontrado: ${_documentoEncontrado!['documento']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Nome: ${_documentoEncontrado!['nome']}'),
              Text('Documento: ${_documentoEncontrado!['documento']}'),
              Text('Telefone: ${_documentoEncontrado!['telefone']}'),
              Text('Cidade: ${_documentoEncontrado!['cidade']}'),
              Text('Estado: ${_documentoEncontrado!['estado']}'),
              Text('Situação: ${_documentoEncontrado!['tipo']}'),
              const SizedBox(height: 16),
              // Botão OK para limpar o formulário
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _buscaController.clear();  // Limpa o campo de texto
                    _documentoEncontrado = null;  // Limpa os dados encontrados
                  });
                },
                child: Text('Limpar Busca'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ] else if (_documentoEncontrado == null && _buscaController.text.isNotEmpty) ...[
              Text('Nenhum documento encontrado.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }

  // Função para buscar o documento automaticamente
  void _buscarDocumento(String nome) async {
    if (nome.isEmpty) {
      setState(() {
        _documentoEncontrado = null;
      });
      return;
    }

    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final resultado = data.entries
          .firstWhere(
            (entry) => entry.value["nome"]?.toLowerCase() == nome.toLowerCase(),
        orElse: () => MapEntry(null, null),
      )
          .value;

      setState(() {
        _documentoEncontrado = resultado != null ? Map<String, dynamic>.from(resultado) : null;
      });
    } else {
      setState(() {
        _documentoEncontrado = null;
      });
    }
  }

  // Documento encontrado
  Map<String, dynamic>? _documentoEncontrado;
}

// Componente Cadastrar Documento
class CadastrarDocumento extends StatefulWidget {
  @override
  _CadastrarDocumentoState createState() => _CadastrarDocumentoState();
}

class _CadastrarDocumentoState extends State<CadastrarDocumento> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("documentos");

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String _tipoSelecionado = 'Achado';
  String? _documentoSelecionado;
  String? _estadoSelecionado;

  List<String> documentos = [
    'RG', 'CPF', 'CTPS', 'CNH', 'Passaporte', 'Título de Eleitor', 'Certidão', 'Outros'
  ];

  List<String> estadosBrasil = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  void _cadastrarDocumento() {
    final nome = _nomeController.text.trim();
    final telefone = _telefoneController.text.trim();
    final cidade = _cidadeController.text.trim();

    if (nome.isNotEmpty && telefone.isNotEmpty && _documentoSelecionado != null && _estadoSelecionado != null) {
      _dbRef.push().set({
        "tipo": _tipoSelecionado,
        "nome": nome,
        "documento": _documentoSelecionado,
        "telefone": telefone,
        "cidade": cidade,
        "estado": _estadoSelecionado,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Documento cadastrado com sucesso!")),
        );
        _nomeController.clear();
        _telefoneController.clear();
        _cidadeController.clear();
        setState(() {
          _documentoSelecionado = null;
          _estadoSelecionado = null;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao cadastrar: $error")),
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Cadastro de Documento',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Tipo - Radio Buttons
          Text(
            'Situação:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Achado',
                groupValue: _tipoSelecionado,
                onChanged: (value) {
                  setState(() {
                    _tipoSelecionado = value!;
                  });
                },
              ),
              Text('Achado'),
              SizedBox(width: 20),
              Radio<String>(
                value: 'Perdido',
                groupValue: _tipoSelecionado,
                onChanged: (value) {
                  setState(() {
                    _tipoSelecionado = value!;
                  });
                },
              ),
              Text('Perdido'),
            ],
          ),
          SizedBox(height: 20),

          _buildTextField(_nomeController, 'Nome Completo'),
          SizedBox(height: 16),

          _buildDropdown(
            value: _documentoSelecionado,
            options: documentos,
            hint: 'Selecione o Documento',
            onChanged: (value) {
              setState(() {
                _documentoSelecionado = value;
              });
            },
          ),
          SizedBox(height: 16),

          _buildTextField(_telefoneController, 'Telefone', inputFormatters: [maskFormatter]),
          SizedBox(height: 16),

          _buildTextField(_cidadeController, 'Cidade'),
          SizedBox(height: 16),

          _buildDropdown(
            value: _estadoSelecionado,
            options: estadosBrasil,
            hint: 'Selecione o Estado',
            onChanged: (value) {
              setState(() {
                _estadoSelecionado = value;
              });
            },
          ),
          SizedBox(height: 16),

          Center(
            child: InkWell(
              onTap: _cadastrarDocumento,
              borderRadius: BorderRadius.circular(12), // Bordas arredondadas
              splashColor: Colors.blue.withOpacity(0.3), // Cor do splash
              highlightColor: Colors.blue.withOpacity(0.2), // Cor do highlight
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()..scale(0.95), // Efeito de escala ao pressionar
                child: ElevatedButton(
                  onPressed: _cadastrarDocumento,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Cor do texto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    elevation: 5, // Sombra do botão
                    shadowColor: Colors.blue.withOpacity(0.3), // Cor da sombra
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      inputFormatters: inputFormatters,
      keyboardType: inputFormatters != null ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> options,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      items: options
          .map<DropdownMenuItem<String>>((String item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
