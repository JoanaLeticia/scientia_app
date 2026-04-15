import 'package:flutter/material.dart';
import 'package:scientia_app/database/db_helper.dart';
import '../models/professor.dart';

class DetalhesAulaScreen extends StatelessWidget {
  final Professor professor;
  final String data;
  final String hora;
  final int reservaId;

  const DetalhesAulaScreen({
    super.key,
    required this.professor,
    required this.data,
    required this.hora,
    required this.reservaId,
  });

  // Função simples para deixar a data por extenso (Ex: 14 de abril de 2026)
  String _formatarDataExtenso(String dataRaw) {
    try {
      final partes = dataRaw.split('/');
      if (partes.length == 3) {
        final dia = partes[0];
        final mesMap = {
          '01': 'janeiro',
          '02': 'fevereiro',
          '03': 'março',
          '04': 'abril',
          '05': 'maio',
          '06': 'junho',
          '07': 'julho',
          '08': 'agosto',
          '09': 'setembro',
          '10': 'outubro',
          '11': 'novembro',
          '12': 'dezembro',
        };
        final mes = mesMap[partes[1]] ?? partes[1];
        final ano = partes[2];
        return "Segunda-feira, $dia de $mes de $ano"; // Adicionado dia fixo para o MVP visual
      }
      return dataRaw;
    } catch (e) {
      return dataRaw;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isOnline = professor.modalidade.toLowerCase().contains('online');

    // Personalização do local baseada na modalidade
    String local = isOnline
        ? "Link da Reunião (Google Meet)"
        : "Universidade Estadual do Tocantins (UNITINS) - Campus Graciosa, Palmas/TO";

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
          "Detalhes da Aula",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. INFORMAÇÕES DO PROFESSOR
            const Text(
              "Informações do Professor",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      professor.imagemUrl,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 60,
                        width: 60,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          professor.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          professor.disciplina,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          professor.contato,
                          style: TextStyle(
                            color: Color(0xFF0066F5),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0EDFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: Color(0xFF0066F5),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 2. INFORMAÇÕES DA AULA
            const Text(
              "Informações",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Id da Aula:", "12380$reservaId"),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  _buildInfoRow("Data:", _formatarDataExtenso(data)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  _buildInfoRow("Horário:", hora),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  _buildInfoRow("Modalidade:", professor.modalidade),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  _buildInfoRow("Localização:", local),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. VALOR PAGO
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFE0EDFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Valor pago",
                    style: TextStyle(
                      color: Color(0xFF0066F5),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "R\$${professor.valor.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Color(0xFF0066F5),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 4. CANCELAMENTO E AVISO
            const Text(
              "Cancelamento",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Cancelamentos gratuitos podem ser feitos com até 24 horas de antecedência. Para imprevistos de última hora, por favor, entre em contato direto com o professor.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 35),

            // 5. BOTÃO CANCELAR AULA
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: () {
                  if (!_podeCancelar(data, hora)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "O cancelamento só é permitido com pelo menos 24 horas de antecedência.",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

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
                        "Você tem certeza que deseja cancelar este agendamento?",
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
                            Navigator.pop(context);

                            await DBHelper.cancelarAula(
                              professor.id!,
                              data,
                              hora,
                            );

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
                  backgroundColor: const Color(0xFFF5F6F8),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Cancelar Aula",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _podeCancelar(String dataRaw, String horaRaw) {
    try {
      final dateParts = dataRaw.split('/');
      final timeStr = horaRaw.split(' - ')[0].trim();
      final timeParts = timeStr.split(':');

      DateTime dataAula = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      return dataAula.difference(DateTime.now()).inHours >= 24;
    } catch (e) {
      return false;
    }
  }

  Widget _buildInfoRow(String label, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            valor,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
