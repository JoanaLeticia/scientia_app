class Aula {
  final int? id;
  final int professorId;
  final String data;
  final String hora;

  Aula({
    this.id,
    required this.professorId,
    required this.data,
    required this.hora,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'professor_id': professorId,
      'data': data,
      'hora': hora,
    };
  }

  factory Aula.fromMap(Map<String, dynamic> map) {
    return Aula(
      id: map['id'],
      professorId: map['professor_id'],
      data: map['data'],
      hora: map['hora'],
    );
  }
}