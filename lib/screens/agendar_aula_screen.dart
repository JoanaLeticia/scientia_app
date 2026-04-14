import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/professor.dart';
import '../database/db_helper.dart';
import 'aula_confirmada_screen.dart';

class AgendarAulaScreen extends StatefulWidget {
  final Professor professor;

  const AgendarAulaScreen({super.key, required this.professor});

  @override
  State<AgendarAulaScreen> createState() => _AgendarAulaScreenState();
}

class _AgendarAulaScreenState extends State<AgendarAulaScreen> {
  DateTime _dataSelecionada = DateTime.now();
  String _turnoSelecionado = 'Manhã';
  String? _horarioSelecionado;

  final Map<String, List<String>> _horariosDisponiveis = {
    'Manhã': ['06:00', '07:00', '08:00', '09:00', '10:00', '11:00'],
    'Tarde': ['13:00', '14:00', '15:00', '16:00', '17:00', '18:00'],
    'Noite': ['19:00', '20:00', '21:00', '22:00'],
  };

  void _finalizarAgendamento() async {
    if (_horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecione um horário.")),
      );
      return;
    }

    String dataFormatada = DateFormat('dd/MM/yyyy').format(_dataSelecionada);

    await DBHelper.insertAula(
      widget.professor.id!,
      dataFormatada,
      _horarioSelecionado!,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AulaConfirmadaScreen(nomeProfessor: widget.professor.nome),
        ),
      );
    }
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
          "Selecionar Data e Horário",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: CalendarDatePicker(
                        initialDate: _dataSelecionada,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        onDateChanged: (data) {
                          setState(() {
                            _dataSelecionada = data;
                            _horarioSelecionado =
                                null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Manhã', 'Tarde', 'Noite'].map((turno) {
                        bool ativo = _turnoSelecionado == turno;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _turnoSelecionado = turno;
                            _horarioSelecionado =
                                null;
                          }),
                          child: Column(
                            children: [
                              Text(
                                turno,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: ativo
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: ativo
                                      ? const Color(0xFF0066F5)
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 3,
                                width: 50,
                                color: ativo
                                    ? const Color(0xFF0066F5)
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: _horariosDisponiveis[_turnoSelecionado]!.map((
                        hora,
                      ) {
                        bool ativo = _horarioSelecionado == hora;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _horarioSelecionado = hora),
                          child: Container(
                            width:
                                (MediaQuery.of(context).size.width - 70) /
                                3,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: ativo
                                  ? const Color(0xFF0066F5)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: ativo
                                    ? const Color(0xFF0066F5)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              hora,
                              style: TextStyle(
                                color: ativo
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontSize: 16,
                                fontWeight: ativo
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _finalizarAgendamento,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Agendar Aula",
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
}
