import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InsuGuia Mobile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.medical_services_outlined, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo ao InsuGuia',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ferramenta de apoio ao manejo da hiperglicemia hospitalar em pacientes não-críticos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.start),
                label: const Text('Iniciar Nova Avaliação'),
                onPressed: () {
                  // Navega para a tela de inserção de dados do paciente
                  Navigator.pushNamed(context, '/patient_input');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}