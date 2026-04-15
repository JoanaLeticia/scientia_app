import 'package:flutter/material.dart';
import 'package:scientia_app/screens/aulas_screen.dart';
import 'package:scientia_app/screens/filtros_screen.dart';
import 'package:scientia_app/screens/wishlist_screen.dart';
import '../models/professor.dart';
import '../database/db_helper.dart';
import 'home_screen.dart';
import 'perfil_screen.dart';
import 'notificacoes_screen.dart';
import 'detalhes_professor_screen.dart';

class PesquisaScreen extends StatefulWidget {
  final String? termoBuscaInicial;

  final Map<String, dynamic>? filtrosIniciais;

  const PesquisaScreen({
    super.key,
    this.termoBuscaInicial,
    this.filtrosIniciais,
  });

  @override
  State<PesquisaScreen> createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  List<Professor> _listaProfessores = [];

  String _textoBusca = '';
  String _ordemSelecionada = 'Menor preço';
  Map<String, dynamic>? _filtrosAplicados;

  late TextEditingController _buscaController;

  int _contarFiltrosAtivos() {
    if (_filtrosAplicados == null) return 0;

    int contador = 0;
    if (_filtrosAplicados!['disciplina'] != null) contador++;
    if (_filtrosAplicados!['tipoAula'] != null) contador++;
    if (_filtrosAplicados!['precoMin'] != null &&
        _filtrosAplicados!['precoMin'].toString().isNotEmpty)
      contador++;
    if (_filtrosAplicados!['precoMax'] != null &&
        _filtrosAplicados!['precoMax'].toString().isNotEmpty)
      contador++;
    if (_filtrosAplicados!['cidade'] != null &&
        _filtrosAplicados!['cidade'].toString().isNotEmpty)
      contador++;

    return contador;
  }

  @override
  void initState() {
    super.initState();

    _textoBusca = widget.termoBuscaInicial ?? '';
    _buscaController = TextEditingController(text: _textoBusca);

    _filtrosAplicados = widget.filtrosIniciais;

    _carregarProfessores();
  }

  _carregarProfessores() async {
    final dados = await DBHelper.getProfessoresFiltrados(
      busca: _textoBusca,
      ordem: _ordemSelecionada,
      filtrosAvancados: _filtrosAplicados,
    );
    // EXPLICAÇÃO: Gerência de Estado
    // Sempre que há uma ação de alterar dados será invocado esse método setState, que é responsável por notificar o Flutter que os dados foram alterados e a interface precisa ser reconstruída para refletir as mudanças.
    setState(() => _listaProfessores = dados);
  }

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
      _carregarProfessores();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                    "Pesquisar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _buscaController,
                onChanged: (valor) {
                  setState(() => _textoBusca = valor);
                  _carregarProfessores();
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
                ),
              ),
            ),
            const SizedBox(height: 10),

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
                              _carregarProfessores();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        onPressed: _abrirTelaFiltros,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          // Se tem filtro, a borda fica azul. Se não, fica cinza.
                          side: BorderSide(
                            color: _contarFiltrosAtivos() > 0
                                ? const Color(0xFF0066F5)
                                : Colors.grey.shade300,
                            width: _contarFiltrosAtivos() > 0 ? 1.5 : 1.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets
                              .zero, // Importante para centralizar o conteúdo
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: _contarFiltrosAtivos() > 0
                                  ? const Color(0xFF0066F5)
                                  : Colors.black87,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Filtros",
                              style: TextStyle(
                                color: _contarFiltrosAtivos() > 0
                                    ? const Color(0xFF0066F5)
                                    : Colors.black87,
                                fontSize: 14,
                                fontWeight: _contarFiltrosAtivos() > 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            // 🌟 A MÁGICA DA BOLINHA ACONTECE AQUI!
                            if (_contarFiltrosAtivos() > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0066F5),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  _contarFiltrosAtivos().toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _listaProfessores.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            "Nenhum professor encontrado.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _listaProfessores.length,
                        itemBuilder: (context, index) {
                          final prof = _listaProfessores[index];
                          return _buildPesquisaCard(prof);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPesquisaCard(Professor prof) {
    return GestureDetector(
      onTap: () async{
        // EXPLICAÇÃO: Navegação entre telas
        // Ao clicar em um professor, navegamos para a tela de detalhes daquele professor, passando o objeto "professor" como argumento.
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesProfessorScreen(professor: prof),
          ),
        );

        _carregarProfessores();
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
                    prof.imagemUrl,
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
                      await DBHelper.toggleFavorito(prof.id!, prof.isFavorito);
                      _carregarProfessores();
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
                          prof.cidadeEstado,
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
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
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
    );
  }
}
