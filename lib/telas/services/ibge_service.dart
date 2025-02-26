import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:achei/telas/models/localidade.dart';

class IBGEService {
  static Future<List<Estado>> obterEstados() async {
    const String url = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => Estado(sigla: e['sigla'], nome: e['nome'])).toList();
      } else {
        throw Exception('Erro ao carregar estados');
      }
    } catch (e) {
      throw Exception('Erro ao buscar estados: $e');
    }
  }

  static Future<List<Cidade>> obterCidades(String estadoSigla) async {
    final String url = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$estadoSigla/municipios';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => Cidade(nome: e['nome'])).toList();
      } else {
        throw Exception('Erro ao carregar cidades');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cidades: $e');
    }
  }
}
