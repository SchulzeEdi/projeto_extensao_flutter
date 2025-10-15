import 'package:flutter/material.dart';

class PrescriptionResultScreen extends StatelessWidget {
  final String prescriptionSuggestion;

  const PrescriptionResultScreen({
    super.key,
    required this.prescriptionSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugestão de Prescrição'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  prescriptionSuggestion,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDisclaimerCard(), // Aviso legal 
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Finalizar e Voltar ao Início'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Card(
      color: Colors.yellow[100],
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 32),
            SizedBox(height: 10),
            Text(
              'AVISO IMPORTANTE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Este é um protótipo acadêmico, sem validade clínica ou regulatória. As sugestões são meramente orientadoras, baseadas nas diretrizes da SBD. As decisões terapêuticas são de inteira responsabilidade do médico prescritor.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}