import 'package:flutter/material.dart';
import 'package:scientia_app/screens/agendar_aula_screen.dart';
import '../models/professor.dart';
import '../database/db_helper.dart';

class DetalhesProfessorScreen extends StatefulWidget {
  final Professor professor;

  const DetalhesProfessorScreen({super.key, required this.professor});

  @override
  State<DetalhesProfessorScreen> createState() =>
      _DetalhesProfessorScreenState();
}

class _DetalhesProfessorScreenState extends State<DetalhesProfessorScreen> {
  late bool _isFavoritoLocal;
  
  @override
  void initState() {
    super.initState();
    _isFavoritoLocal = widget.professor.isFavorito == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF0066F5),
                      size: 20,
                    ),
                  ),
                  const Text(
                    "Detalhes do Professor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      int statusAtualNoBanco = _isFavoritoLocal ? 1 : 0;

                      await DBHelper.toggleFavorito(
                        widget.professor.id!,
                        statusAtualNoBanco,
                      );

                      setState(() {
                        _isFavoritoLocal = !_isFavoritoLocal;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        _isFavoritoLocal
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: const Color(0xFF0066F5),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.professor.imagemUrl,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 280,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  _buildTag(
                    Icons.location_on_outlined,
                    widget.professor.cidadeEstado,
                  ),
                  const SizedBox(width: 10),
                  _buildTag(Icons.school_outlined, widget.professor.modalidade),
                ],
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.professor.nome,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.professor.disciplina,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                      children: [
                        TextSpan(
                          text:
                              'R\$${widget.professor.valor.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF0066F5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' /hora'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                "Sobre mim",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.professor.descricao,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildFooter(),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFC1D5F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0066F5)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0066F5),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 17, bottom: 45),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AgendarAulaScreen(professor: widget.professor),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066F5),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Agendar Aula",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
