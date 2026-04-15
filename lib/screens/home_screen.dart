import 'package:flutter/material.dart';
import 'package:scientia_app/screens/perfil_screen.dart';
import 'package:scientia_app/screens/aulas_screen.dart';
import 'package:scientia_app/screens/wishlist_screen.dart';
import '../database/db_helper.dart';
import '../models/professor.dart';
import 'notificacoes_screen.dart';
import 'detalhes_professor_screen.dart';
import 'pesquisa_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Professor> _listaProfessores = [];
  List<Professor> _listaDestaques = [];

  final TextEditingController _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  Future<void> _atualizarLista() async {
    final destaques = await DBHelper.getProfessoresDestaque();
    final todos = await DBHelper.getAll();

    setState(() {
      _listaDestaques = destaques;
      _listaProfessores = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Bem-vinda,",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          "Joana Letícia",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificacoesScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0EDFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Color(0xFF0066F5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _buscaController,
                        onSubmitted: (valor) => _irParaPesquisa(),
                        decoration: InputDecoration(
                          hintText: "Pesquisar professores...",
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF0066F5),
                            size: 26,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xFF0066F5),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    GestureDetector(
                      onTap: _irParaPesquisa,
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0066F5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // SEÇAO DE PROFESSORES DESTAQUES
              SizedBox(
                height: 224,
                child:
                    _listaDestaques
                        .isEmpty
                    ? const Center(
                        child: Text(
                          "Nenhum destaque no momento.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      // EXPLICAÇÃO: Uso de Carrossel
                      // Carrossel de professores destaque é um construtor de lista configurado com eixo de rolagem na horizontal
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: _listaDestaques
                            .length,
                        itemBuilder: (context, index) {
                          final prof =
                              _listaDestaques[index];
                          return _buildDestaqueCard(prof);
                        },
                      ),
              ),
              const SizedBox(height: 20),

              // SEÇÃO DISCIPLINAS
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Disciplinas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoriaIcon(Icons.calculate, "Matemática"),
                    const SizedBox(width: 12),
                    _buildCategoriaIcon(Icons.menu_book, "Português"),
                    const SizedBox(width: 12),
                    _buildCategoriaIcon(Icons.create, "Redação"),
                    const SizedBox(width: 12),
                    _buildCategoriaIcon(Icons.functions, "Física"),
                    const SizedBox(width: 12),
                    _buildCategoriaIcon(Icons.science, "Química"),
                    const SizedBox(width: 12),
                    _buildCategoriaIcon(Icons.eco, "Biologia"),
                    const SizedBox(width: 12),
                    _buildCategoriaIcon(Icons.account_balance, "História"),
                    const SizedBox(width: 12),
                    _buildCategoriaIcon(Icons.public, "Geografia"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // SEÇÃO PROFESSORES DISPONÍVEIS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Professores Disponíveis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PesquisaScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Ver todos",
                        style: TextStyle(
                          color: Color(0xFF0066F5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _listaProfessores.length,
                  itemBuilder: (context, index) {
                    final prof = _listaProfessores[index];
                    return _buildProfessorCard(prof);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: 95,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF0066F5),
            unselectedItemColor: Colors.grey,
            iconSize: 28,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PesquisaScreen(),
                  ),
                );
              } else if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WishlistScreen(),
                  ),
                );
              } else if (index == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AulasScreen()),
                );
              } else if (index == 4) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilScreen()),
                );
              }
            },

            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Pesquisar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: "Wishlist",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: "Aulas",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: "Perfil",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _irParaPesquisa() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PesquisaScreen(termoBuscaInicial: _buscaController.text),
      ),
    );
  }

  Widget _buildDestaqueCard(Professor prof) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesProfessorScreen(professor: prof),
          ),
        );
        _atualizarLista();
      },
      child: Container(
        width: 145,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    prof.imagemUrl,
                    width: 125,
                    height: 155,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 155,
                      width: 125,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: GestureDetector(
                    onTap: () async {
                      // 1. Altera no banco SQLite
                      await DBHelper.toggleFavorito(prof.id!, prof.isFavorito);
                      // 2. Atualiza a Home (Corações mudam de cor em toda a tela)
                      _atualizarLista();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        prof.isFavorito == 1
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: const Color(0xFF0066F5),
                        size:
                            16, // Um pouco menor para caber no card de destaque
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3, top: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prof.disciplina,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      children: [
                        TextSpan(
                          text: 'R\$${prof.valor.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: '/hora'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaIcon(IconData icon, String titulo) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PesquisaScreen(filtrosIniciais: {'disciplina': titulo}),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: Color(0xFFE0EDFF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0066F5), size: 30),
          ),
          const SizedBox(height: 8),
          Text(titulo, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildProfessorCard(Professor prof) {
    return GestureDetector(
      onTap: () async{
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesProfessorScreen(professor: prof),
          ),
        );
        _atualizarLista();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // EXPLICAÇÃO: Uso da Imagem
                // Para poder aplicar o borderRadius
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // Renderiza a imagem do professor ou um ícone genérico em caso de erro
                  child: Image.network(
                    prof.imagemUrl,
                    height: 130,
                    width: 100,
                    fit: BoxFit.cover,
                    // Em caso de erro ao carregar a imagem, exibe um placeholder
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 130,
                        width: 100,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () async {
                      await DBHelper.toggleFavorito(prof.id!, prof.isFavorito);

                      _atualizarLista();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        prof.isFavorito == 1
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: const Color(0xFF0066F5),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prof.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        prof.disciplina,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      Text(
                        prof.cidadeEstado,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      children: [
                        TextSpan(
                          text: 'R\$${prof.valor.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: '/hora'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalhesProfessorScreen(professor: prof),
                          ),
                        );
                        _atualizarLista();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Contratar",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
