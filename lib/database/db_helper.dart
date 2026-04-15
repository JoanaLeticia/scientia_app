import 'package:scientia_app/models/aluno.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/professor.dart';

class DBHelper {
  static Future<Database> getDatabase() async {
    final path = join(await getDatabasesPath(), 'professores.db');

    // Criando o banco de dados e as tabelas necessárias
    return openDatabase(
      path,
      onCreate: (db, version) async {

        // Criando a tabela de professores
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
          'isFavorito INTEGER DEFAULT 0,'
          'isDestaque INTEGER DEFAULT 0'
          ')',
        );

        // Criando a tabela de alunos
        await db.execute(
          'CREATE TABLE alunos('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nome TEXT, '
          'email TEXT, '
          'senha TEXT'
          ')',
        );

        // Criando a tabela de aulas
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
              'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?auto=format&fit=crop&w=500&q=100',
          'isFavorito': 1,
          'isDestaque': 1,
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
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=500&q=100',
          'isFavorito': 0,
          'isDestaque': 1,
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
              'https://images.unsplash.com/photo-1580894732444-8ecbef79bd1e?auto=format&fit=crop&w=500&q=100',
          'isFavorito': 0,
          'isDestaque': 1,
        });

        await db.insert('professores', {
          'nome': 'Dr. Ricardo Santos',
          'disciplina': 'História',
          'valor': 85.00,
          'descricao': 'Especialista em história brasileira e mundial.',
          'contato': 'ricardo.santos@email.com',
          'cidadeEstado': 'Palmas/TO',
          'modalidade': 'Presencial',
          'imagemUrl':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=500&q=100',
          'isFavorito': 0,
          'isDestaque': 1,
        });

        await db.insert('professores', {
          'nome': 'Mariana Luz',
          'disciplina': 'Física',
          'valor': 70.00,
          'descricao': 'Aulas dinâmicas com foco em vestibulares e ENEM.',
          'contato': 'mariana.luz@email.com',
          'cidadeEstado': 'Remoto',
          'modalidade': 'Online',
          'imagemUrl':
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=500&q=100',
          'isFavorito': 1,
          'isDestaque': 1,
        });

        await db.insert('professores', {
          'nome': 'Eng. Carlos Eduardo',
          'disciplina': 'Química',
          'valor': 95.00,
          'descricao': 'Aulas práticas e teóricas para dominar a química.',
          'contato': 'cadu.quimica@email.com',
          'cidadeEstado': 'Palmas/TO',
          'modalidade': 'Híbrido',
          'imagemUrl':
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=500&q=100',
          'isFavorito': 0,
          'isDestaque': 1,
        });

        await db.insert('professores', {
          'nome': 'Ana Beatriz',
          'disciplina': 'Matemática',
          'valor': 65.00,
          'descricao': 'Aulas personalizadas para todas as idades e níveis.',
          'contato': 'ana.beatriz@email.com',
          'cidadeEstado': 'Remoto',
          'modalidade': 'Online',
          'imagemUrl':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=500&q=100',
          'isFavorito': 0,
          'isDestaque': 1,
        });

        await db.insert('aulas', {
          'professor_id': 1, // ID do Prof. John Doe
          'data': '10/04/2026', // Data passada
          'hora': '14:00 - 15:00',
        });

        await db.insert('aulas', {
          'professor_id': 2, // ID da Profa. Maria Silva
          'data': '12/04/2026', // Data passada
          'hora': '09:00 - 11:00',
        });
      },
      version: 1,
    );
  }

  // Método para inserir um novo professor
  static Future<void> insert(Professor professor) async {
    final db = await getDatabase();

    await db.insert(
      'professores',
      professor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para obter todos os professores
  static Future<List<Professor>> getAll() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('professores');

    return maps.map((m) => Professor.fromMap(m)).toList();
  }

  // Método para inserir um novo aluno
  static Future<void> insertAluno(Aluno aluno) async {
    final db = await getDatabase();
    await db.insert(
      'alunos',
      aluno.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para alternar o status de favorito de um professor
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

  // Método para obter apenas os professores favoritos
  static Future<List<Professor>> getFavoritos() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'professores',
      where: 'isFavorito = 1',
    );
    return List.generate(maps.length, (i) => Professor.fromMap(maps[i]));
  }

  // Método para inserir uma aula agendada
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

  // Método para obter todas as aulas agendadas, juntando com os dados dos professores
  static Future<List<Map<String, dynamic>>> getAulas() async {
    final db = await getDatabase();
    return await db.rawQuery('''
      SELECT a.id as aula_id, a.data, a.hora, p.*
      FROM aulas a
      INNER JOIN professores p ON a.professor_id = p.id
      ORDER BY a.data, a.hora
    ''');
  }

  // Método para obter professores filtrados com base em múltiplos critérios
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

  // Método para cancelar uma aula específica
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

  // Método para obter os professores em destaque (isDestaque = 1)
  static Future<List<Professor>> getProfessoresDestaque() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'professores',
      where: 'isDestaque = 1',
      limit: 5,
    );
    return List.generate(maps.length, (i) => Professor.fromMap(maps[i]));
  }

  // Método para obter os horários ocupados de um professor em uma data específica
  static Future<List<String>> getHorariosOcupados(
    int professorId,
    String data,
  ) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'aulas',
      where: 'professor_id = ? AND data = ?',
      whereArgs: [professorId, data],
    );

    List<String> ocupados = [];

    for (var row in maps) {
      String horaBanco = row['hora'];

      var partes = horaBanco.split(' - ');
      if (partes.length == 2) {
        int inicio = int.parse(partes[0].split(':')[0]);
        int fim = int.parse(partes[1].split(':')[0]);

        for (int i = inicio; i < fim; i++) {
          ocupados.add('${i.toString().padLeft(2, '0')}:00');
        }
      } else {
        ocupados.add(horaBanco);
      }
    }
    return ocupados;
  }
}
