import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/professor.dart';

class CadastroProfessorScreen extends StatefulWidget {
  const CadastroProfessorScreen({super.key});

  @override
  State<CadastroProfessorScreen> createState() =>
      _CadastroProfessorScreenState();
}

class _CadastroProfessorScreenState extends State<CadastroProfessorScreen> {
  final _nomeController = TextEditingController();
  final _disciplinaController = TextEditingController();
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _contatoController = TextEditingController();
  final _cidadeEstadoController = TextEditingController();
  final _modalidadeController = TextEditingController();

  Future<void> _salvarProfessor() async {
    if (_nomeController.text.trim().isEmpty ||
        _disciplinaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha Nome e Disciplina.")),
      );
      return;
    }

    final novoProfessor = Professor(
      nome: _nomeController.text,
      disciplina: _disciplinaController.text,
      valor: double.tryParse(_valorController.text) ?? 0.0,
      descricao: _descricaoController.text,
      contato: _contatoController.text,
      cidadeEstado: _cidadeEstadoController.text,
      modalidade: _modalidadeController.text,
      imagemUrl: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=200&q=80",
    );

    await DBHelper.insert(novoProfessor);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anunciar Aula")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: "Nome do Professor"),
            ),
            TextField(
              controller: _disciplinaController,
              decoration: const InputDecoration(
                labelText: "Disciplina",
              ),
            ),
            TextField(
              controller: _cidadeEstadoController,
              decoration: const InputDecoration(
                labelText: "Cidade/Estado",
              ),
            ),
            TextField(
              controller: _modalidadeController,
              decoration: const InputDecoration(
                labelText: "Modalidade (ex: Online, Presencial)",
              ),
            ),

            TextField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: "Valor por Hora (R\$)",
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            TextField(
              controller: _contatoController,
              decoration: const InputDecoration(
                labelText: "Telefone",
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarProfessor,
              child: const Text("Salvar Anúncio"),
            ),
          ],
        ),
      ),
    );
  }
}
