import 'package:flutter/material.dart';
import 'package:scientia_app/screens/aulas_screen.dart';
import '../models/professor.dart';
import '../database/db_helper.dart';
import 'home_screen.dart';
import 'pesquisa_screen.dart';
import 'perfil_screen.dart';
import 'notificacoes_screen.dart';
import 'detalhes_professor_screen.dart';
import 'filtros_screen.dart'; // 🌟 Import da tela de Filtros

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Professor> _listaFavoritos = [];

  // Controles de Busca e Filtro (Iguais aos da Pesquisa)
  String _textoBusca = '';
  String _ordemSelecionada = 'Menor preço';
  Map<String, dynamic>? _filtrosAplicados;

  @override
  void initState() {
    super.initState();
    _carregarProfessoresFavoritos();
  }

  // 🌟 ATUALIZADO: Agora usa a busca avançada, mas pedindo apenas os favoritos!
  _carregarProfessoresFavoritos() async {
    final favoritosReais = await DBHelper.getProfessoresFiltrados(
      busca: _textoBusca,
      ordem: _ordemSelecionada,
      filtrosAvancados: _filtrosAplicados,
      apenasFavoritos: true, // <--- Isso garante que só traga da Wishlist
    );

    setState(() {
      _listaFavoritos = favoritosReais;
    });
  }

  // 🌟 NOVO: Função para abrir a tela separada de filtros
  _abrirTelaFiltros() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltrosScreen(filtrosAtuais: _filtrosAplicados),
      ),
    );

    if (result != null) {
      setState(() {
        _filtrosAplicados = result;
      });
      _carregarProfessoresFavoritos(); // Refaz a busca na wishlist com os filtros
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo igual ao da pesquisa
      body: SafeArea(
        child: Column(
          children: [
            // 1. CABEÇALHO
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Wishlist",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificacoesScreen(),
                      ),
                    ),
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
            const SizedBox(height: 10),

            // 2. BARRA DE PESQUISA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (valor) {
                  setState(() => _textoBusca = valor);
                  _carregarProfessoresFavoritos();
                },
                decoration: InputDecoration(
                  hintText: "Pesquisar...",
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
                    borderSide: const BorderSide(color: Color(0xFF0066F5)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 3. ORDENAR POR & BOTÃO FILTROS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _ordemSelecionada,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            return ['Menor preço', 'Maior preço'].map((
                              String value,
                            ) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Ordenar por",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                          items: ['Menor preço', 'Maior preço'].map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (novoValor) {
                            if (novoValor != null) {
                              setState(() => _ordemSelecionada = novoValor);
                              _carregarProfessoresFavoritos();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Botão Filtros
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton.icon(
                        onPressed: _abrirTelaFiltros,
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.black87,
                          size: 20,
                        ),
                        label: const Text(
                          "Filtros",
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // 4. LISTA DE RESULTADOS
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _listaFavoritos.isEmpty
                          ? _buildEmptyWishlist()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _listaFavoritos.length,
                              itemBuilder: (context, index) {
                                final prof = _listaFavoritos[index];
                                return _buildPesquisaCard(prof);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // WIDGET DO CARD DE PROFESSOR (Manteve a lógica de remover da wishlist ao clicar no coração)
  Widget _buildPesquisaCard(Professor prof) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesProfessorScreen(professor: prof),
          ),
        );

        _carregarProfessoresFavoritos();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    prof.imagemUrl.isNotEmpty
                        ? prof.imagemUrl
                        : 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80',
                    height: 140,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      width: 100,
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
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () async {
                      // Remove o favorito no banco e recarrega a tela
                      await DBHelper.toggleFavorito(prof.id!, prof.isFavorito);
                      _carregarProfessoresFavoritos();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          prof.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0EDFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          prof.cidadeEstado.split('/')[0],
                          style: const TextStyle(
                            color: Color(0xFF0066F5),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prof.disciplina,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'R\$${prof.valor.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' /hora'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalhesProfessorScreen(professor: prof),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        "Contratar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 80),
          const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            "Sua wishlist está vazia",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Toque no coração nos perfis dos professores\npara salvá-los aqui.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
          selectedItemColor: const Color(0xFF0066F5),
          unselectedItemColor: Colors.grey,
          iconSize: 28,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: 2,
          onTap: (index) {
            if (index == 0)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            else if (index == 1)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PesquisaScreen()),
              );
            else if (index == 3)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AulasScreen()),
              );
            else if (index == 4)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PerfilScreen()),
              );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Pesquisar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
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
    );
  }
}
