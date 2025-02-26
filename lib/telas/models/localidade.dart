class Estado {
  final String sigla;
  final String nome;

  Estado({required this.sigla, required this.nome});

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      sigla: json['sigla'],
      nome: json['nome'],
    );
  }
}

class Cidade {
  final String nome;

  Cidade({required this.nome});

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      nome: json['nome'], // Mapeia o campo 'nome' do JSON para o atributo 'nome'
    );
  }
}
