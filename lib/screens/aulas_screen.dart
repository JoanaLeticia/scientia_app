import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/professor.dart';
import '../database/db_helper.dart';
import 'home_screen.dart';
import 'pesquisa_screen.dart';
import 'wishlist_screen.dart';
import 'perfil_screen.dart';
import 'notificacoes_screen.dart';
import 'detalhes_professor_screen.dart';
import 'filtros_screen.dart';
import 'detalhes_aula_screen.dart';

class AulasScreen extends StatefulWidget {
  const AulasScreen({super.key});

  @override
  State<AulasScreen> createState() => _AulasScreenState();
}

class _AulasScreenState extends State<AulasScreen> {
  List<Map<String, dynamic>> _listaAulasOriginais = [];
  List<Map<String, dynamic>> _listaAulasExibidas = [];

  bool _isProximasAulas = true;

  String _textoBusca = '';
  String _ordemSelecionada = 'Menor preço';
  Map<String, dynamic>? _filtrosAplicados;

  @override
  void initState() {
    super.initState();
    _carregarAulas();
  }

  _carregarAulas() async {
    final dados = await DBHelper.getAulas();
    setState(() {
      _listaAulasOriginais = dados;
    });
    _aplicarTodosOsFiltros();
  }

  void _aplicarTodosOsFiltros() {
    List<Map<String, dynamic>> temp = List.from(_listaAulasOriginais);

    DateTime agora = DateTime.now();
    DateTime hoje = DateTime(agora.year, agora.month, agora.day);

    temp = temp.where((aula) {
      final prof = Professor.fromMap(aula);

      DateTime dataAula;
      try {
        dataAula = DateFormat('dd/MM/yyyy').parse(aula['data']);
      } catch (e) {
        dataAula = hoje.add(const Duration(days: 1));
      }

      if (_isProximasAulas) {
        if (dataAula.isBefore(hoje)) return false;
      } else {
        if (dataAula.isAfter(hoje) || dataAula.isAtSameMomentAs(hoje))
          return false;
      }

      if (_textoBusca.isNotEmpty) {
        final buscaLower = _textoBusca.toLowerCase();
        if (!prof.nome.toLowerCase().contains(buscaLower) &&
            !prof.disciplina.toLowerCase().contains(buscaLower)) {
          return false;
        }
      }

      if (_filtrosAplicados != null) {
        if (_filtrosAplicados!['disciplina'] != null &&
            prof.disciplina != _filtrosAplicados!['disciplina'])
          return false;
        if (_filtrosAplicados!['tipoAula'] != null &&
            !prof.modalidade.contains(_filtrosAplicados!['tipoAula']))
          return false;
        if (_filtrosAplicados!['cidade'] != null &&
            _filtrosAplicados!['cidade'].toString().isNotEmpty) {
          if (!prof.cidadeEstado.toLowerCase().contains(
            _filtrosAplicados!['cidade'].toString().toLowerCase(),
          ))
            return false;
        }
        if (_filtrosAplicados!['precoMin'] != null &&
            _filtrosAplicados!['precoMin'].toString().isNotEmpty) {
          if (prof.valor < double.parse(_filtrosAplicados!['precoMin']))
            return false;
        }
        if (_filtrosAplicados!['precoMax'] != null &&
            _filtrosAplicados!['precoMax'].toString().isNotEmpty) {
          if (prof.valor > double.parse(_filtrosAplicados!['precoMax']))
            return false;
        }
      }

      return true;
    }).toList();

    if (_ordemSelecionada == 'Menor preço') {
      temp.sort(
        (a, b) =>
            Professor.fromMap(a).valor.compareTo(Professor.fromMap(b).valor),
      );
    } else {
      temp.sort(
        (a, b) =>
            Professor.fromMap(b).valor.compareTo(Professor.fromMap(a).valor),
      );
    }

    setState(() {
      _listaAulasExibidas = temp;
    });
  }

  _abrirTelaFiltros() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltrosScreen(filtrosAtuais: _filtrosAplicados),
      ),
    );

    if (result != null) {
      setState(() => _filtrosAplicados = result);
      _aplicarTodosOsFiltros();
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
                    "Minhas Aulas",
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      true,
                      "Próximas Aulas",
                      Icons.event_note,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTabButton(false, "Histórico", Icons.history),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (valor) {
                  setState(() => _textoBusca = valor);
                  _aplicarTodosOsFiltros();
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
                              _aplicarTodosOsFiltros();
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _listaAulasExibidas.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Column(
                            children: [
                              Icon(
                                _isProximasAulas
                                    ? Icons.event_busy
                                    : Icons.history_toggle_off,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                _isProximasAulas
                                    ? "Nenhuma aula agendada."
                                    : "Seu histórico está vazio.",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _listaAulasExibidas.length,
                        itemBuilder: (context, index) {
                          final aula = _listaAulasExibidas[index];
                          final prof = Professor.fromMap(aula);
                          final dataReal = aula['data'];
                          final horaReal = aula['hora'];
                          return _buildAulaCard(prof, dataReal, horaReal);
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

  Widget _buildTabButton(bool isPrimaryTab, String title, IconData icon) {
    bool isActive = _isProximasAulas == isPrimaryTab;
    return GestureDetector(
      onTap: () {
        setState(() => _isProximasAulas = isPrimaryTab);
        _aplicarTodosOsFiltros();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8F1FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? const Color(0xFF0066F5) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? const Color(0xFF0066F5) : Colors.grey.shade500,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: isActive
                    ? const Color(0xFF0066F5)
                    : Colors.grey.shade600,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAulaCard(Professor prof, String data, String hora) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  prof.imagemUrl.isNotEmpty
                      ? prof.imagemUrl
                      : 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80',
                  height: 120,
                  width: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    width: 90,
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prof.disciplina,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 13,
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
                            prof.modalidade,
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
                      prof.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          prof.cidadeEstado,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hora,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text(
                          "Cancelar Aula",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          "Você tem certeza que deseja cancelar este agendamento? Esta ação não pode ser desfeita.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Voltar",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);

                              await DBHelper.cancelarAula(prof.id!, data, hora);

                              _carregarAulas();
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Aula cancelada com sucesso!"),
                                ),
                              );
                            },
                            child: const Text(
                              "Sim, cancelar",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Cancelar Aula",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesAulaScreen(
                          professor: prof,
                          data: data,
                          hora: hora,
                          reservaId: prof.id ?? 1,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Visualizar Detalhes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
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
          currentIndex: 3,
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
            else if (index == 2)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
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
