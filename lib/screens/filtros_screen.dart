import 'package:flutter/material.dart';

class FiltrosScreen extends StatefulWidget {
  final Map<String, dynamic>? filtrosAtuais;

  const FiltrosScreen({super.key, this.filtrosAtuais});

  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  final List<String> _disciplinas = [
    'Matemática',
    'Português',
    'História',
    'Geografia',
    'Física',
    'Química',
    'Biologia',
    'Artes',
    'Inglês',
  ];
  final List<String> _tiposAula = ['Presencial', 'Online', 'Híbrido'];

  String? _disciplinaSelecionada;
  String? _tipoAulaSelecionado;
  final _precoMinController = TextEditingController();
  final _precoMaxController = TextEditingController();
  final _cidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.filtrosAtuais != null) {
      _disciplinaSelecionada = widget.filtrosAtuais!['disciplina'];
      _tipoAulaSelecionado = widget.filtrosAtuais!['tipoAula'];
      _precoMinController.text = widget.filtrosAtuais!['precoMin'] ?? '';
      _precoMaxController.text = widget.filtrosAtuais!['precoMax'] ?? '';
      _cidadeController.text = widget.filtrosAtuais!['cidade'] ?? '';
    }
  }

  void _limparFiltros() {
    setState(() {
      _disciplinaSelecionada = null;
      _tipoAulaSelecionado = null;
      _precoMinController.clear();
      _precoMaxController.clear();
      _cidadeController.clear();
    });
  }

  void _aplicarFiltros() {
    Map<String, dynamic> filtrosAplicados = {
      'disciplina': _disciplinaSelecionada,
      'tipoAula': _tipoAulaSelecionado,
      'precoMin': _precoMinController.text,
      'precoMax': _precoMaxController.text,
      'cidade': _cidadeController.text,
    };
    Navigator.pop(context, filtrosAplicados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF0066F5),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Filtros",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _limparFiltros,
            child: const Text(
              "Limpar",
              style: TextStyle(color: Color(0xFF0066F5), fontSize: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Disciplinas",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _disciplinas
                          .map(
                            (disc) => _buildChip(
                              disc,
                              _disciplinaSelecionada,
                              (val) =>
                                  setState(() => _disciplinaSelecionada = val),
                            ),
                          )
                          .toList(),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(),
                    ),

                    const Text(
                      "Tipo de Aula",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: _tiposAula
                          .map(
                            (tipo) => _buildChip(
                              tipo,
                              _tipoAulaSelecionado,
                              (val) =>
                                  setState(() => _tipoAulaSelecionado = val),
                            ),
                          )
                          .toList(),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(),
                    ),

                    const Text(
                      "Preço",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            "Min.",
                            _precoMinController,
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildTextField(
                            "Máx.",
                            _precoMaxController,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(),
                    ),

                    const Text(
                      "Cidade",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _cidadeController,
                      decoration: InputDecoration(
                        hintText: "Pesquisar cidade...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 30,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _aplicarFiltros,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Aplicar Filtros",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    String label,
    String? selectedValue,
    Function(String?) onSelect,
  ) {
    bool isSelected = selectedValue == label;
    return ChoiceChip(
      label: Text(
        label.toUpperCase(),
      ),
      selected: isSelected,
      onSelected: (selected) => onSelect(selected ? label : null),
      backgroundColor: const Color(0xFFE0EDFF),
      selectedColor: const Color(0xFF0066F5),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF0066F5),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
