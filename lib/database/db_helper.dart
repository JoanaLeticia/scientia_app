import 'package:scientia_app/models/aluno.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/professor.dart';

class DBHelper {
  static Future<Database> getDatabase() async {
    final path = join(await getDatabasesPath(), 'professores.db');

    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE professores('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nome TEXT, '
          'disciplina TEXT, '
          'valor REAL, '
          'descricao TEXT, '
          'contato TEXT, '
          'cidadeEstado TEXT, '
          'modalidade TEXT, '
          'imagemUrl TEXT, '
          'isFavorito INTEGER DEFAULT 0'
          ')',
        );

        await db.execute(
          'CREATE TABLE alunos('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nome TEXT, '
          'email TEXT, '
          'senha TEXT'
          ')',
        );

        await db.execute(
          'CREATE TABLE aulas('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'professor_id INTEGER, '
          'data TEXT, '
          'hora TEXT'
          ')',
        );

        await db.insert('professores', {
          'nome': 'Prof. John Doe',
          'disciplina': 'Matemática',
          'valor': 60.00,
          'descricao': 'Aulas focadas em resolução de exercícios.',
          'contato': 'john.doe@email.com',
          'cidadeEstado': 'Palmas/TO',
          'modalidade': 'Presencial',
          'imagemUrl':
              'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?auto=format&fit=crop&w=200&q=80',
        });

        await db.insert('professores', {
          'nome': 'Profa. Maria Silva',
          'disciplina': 'Português',
          'valor': 80.00,
          'descricao': 'Especialista em redação e gramática.',
          'contato': 'maria.silva@email.com',
          'cidadeEstado': 'São Paulo/SP',
          'modalidade': 'Online',
          'imagemUrl':
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=200&q=80',
        });

        await db.insert('professores', {
          'nome': 'Prof. Carlos Santos',
          'disciplina': 'Geografia',
          'valor': 50.00,
          'descricao': 'Preparatório completo com material focado.',
          'contato': 'carlos.geo@email.com',
          'cidadeEstado': 'Palmas/TO',
          'modalidade': 'Híbrido',
          'imagemUrl':
              'https://images.unsplash.com/photo-1580894732444-8ecbef79bd1e?auto=format&fit=crop&w=200&q=80',
        });
      },
      version: 1,
    );
  }

  static Future<void> insert(Professor professor) async {
    final db = await getDatabase();

    await db.insert(
      'professores',
      professor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Professor>> getAll() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('professores');

    return maps.map((m) => Professor.fromMap(m)).toList();
  }

  static Future<void> insertAluno(Aluno aluno) async {
    final db = await getDatabase();
    await db.insert(
      'alunos',
      aluno.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Aluno?> getAlunoPorEmail(String email, String senha) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'alunos',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (maps.isNotEmpty) {
      return Aluno.fromMap(maps.first);
    }
    return null;
  }

  static Future<void> provarCadastroNoConsole() async {
    final db = await getDatabase();

    final listaAlunos = await db.query('alunos');

    print("\n=========================================");
    print("LISTA DE ALUNOS CADASTRADOS:");
    for (var aluno in listaAlunos) {
      print(
        "ID: ${aluno['id']} | Nome: ${aluno['nome']} | Email: ${aluno['email']}",
      );
    }
    print("=========================================\n");
  }

  static Future<void> toggleFavorito(int id, int statusAtual) async {
    final db = await getDatabase();
    int novoStatus = statusAtual == 0 ? 1 : 0;

    await db.update(
      'professores',
      {'isFavorito': novoStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Professor>> getFavoritos() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'professores',
      where: 'isFavorito = 1',
    );
    return List.generate(maps.length, (i) => Professor.fromMap(maps[i]));
  }

  static Future<void> insertAula(
    int professorId,
    String data,
    String hora,
  ) async {
    final db = await getDatabase();
    await db.insert('aulas', {
      'professor_id': professorId,
      'data': data,
      'hora': hora,
    });
  }

  static Future<List<Map<String, dynamic>>> getAulas() async {
    final db = await getDatabase();
    return await db.rawQuery('''
      SELECT a.id as aula_id, a.data, a.hora, p.*
      FROM aulas a
      INNER JOIN professores p ON a.professor_id = p.id
      ORDER BY a.data, a.hora
    ''');
  }

  static Future<List<Professor>> getProfessoresFiltrados({
    String busca = '',
    String ordem = 'Menor preço',
    Map<String, dynamic>? filtrosAvancados,
    bool apenasFavoritos = false,
  }) async {
    final db = await getDatabase();

    String whereString = "1=1";
    List<dynamic> whereArgs = [];

    if (apenasFavoritos) {
      whereString += " AND isFavorito = 1";
    }

    if (busca.isNotEmpty) {
      whereString += " AND (nome LIKE ? OR disciplina LIKE ?)";
      whereArgs.addAll(['%$busca%', '%$busca%']);
    }

    if (filtrosAvancados != null) {
      if (filtrosAvancados['disciplina'] != null) {
        whereString += " AND disciplina = ?";
        whereArgs.add(filtrosAvancados['disciplina']);
      }
      if (filtrosAvancados['tipoAula'] != null) {
        whereString += " AND modalidade LIKE ?";
        whereArgs.add('%${filtrosAvancados['tipoAula']}%');
      }
      if (filtrosAvancados['precoMin'] != null &&
          filtrosAvancados['precoMin'].toString().isNotEmpty) {
        whereString += " AND valor >= ?";
        whereArgs.add(double.parse(filtrosAvancados['precoMin']));
      }
      if (filtrosAvancados['precoMax'] != null &&
          filtrosAvancados['precoMax'].toString().isNotEmpty) {
        whereString += " AND valor <= ?";
        whereArgs.add(double.parse(filtrosAvancados['precoMax']));
      }
      if (filtrosAvancados['cidade'] != null &&
          filtrosAvancados['cidade'].toString().isNotEmpty) {
        whereString += " AND cidadeEstado LIKE ?";
        whereArgs.add('%${filtrosAvancados['cidade']}%');
      }
    }

    String orderBy = "valor ASC";
    if (ordem == 'Maior preço') {
      orderBy = "valor DESC";
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'professores',
      where: whereString,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    return List.generate(maps.length, (i) => Professor.fromMap(maps[i]));
  }

  static Future<void> cancelarAula(
    int professorId,
    String data,
    String hora,
  ) async {
    final db = await getDatabase();

    await db.delete(
      'aulas',
      where: 'professor_id = ? AND data = ? AND hora = ?',
      whereArgs: [professorId, data, hora],
    );
  }
}
