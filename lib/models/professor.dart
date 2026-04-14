class Professor {
  final int? id;
  final String nome;
  final String disciplina;
  final double valor;
  final String descricao;
  final String contato;
  final String cidadeEstado;
  final String modalidade;
  final String imagemUrl;
  final int isFavorito;

  Professor({
    this.id,
    required this.nome,
    required this.disciplina,
    required this.valor,
    required this.descricao,
    required this.contato,
    required this.cidadeEstado,
    required this.modalidade,
    required this.imagemUrl,
    this.isFavorito = 0
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'disciplina': disciplina,
      'valor': valor,
      'descricao': descricao,
      'contato': contato,
      'cidadeEstado': cidadeEstado,
      'modalidade': modalidade,
      'imagemUrl': imagemUrl,
      'isFavorito': isFavorito
    };
  }

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      id: map['id'],
      nome: map['nome'],
      disciplina: map['disciplina'],
      valor: map['valor'] is int ? (map['valor'] as int).toDouble() : map['valor'],
      descricao: map['descricao'],
      contato: map['contato'],
      cidadeEstado: map['cidadeEstado'] ?? '',
      modalidade: map['modalidade'] ?? '',
      imagemUrl: map['imagemUrl'] ?? '',
      isFavorito: map['isFavorito'] ?? 0,
    );
  }
}