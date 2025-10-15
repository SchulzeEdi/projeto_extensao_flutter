import 'package:flutter/material.dart';
import 'package:insuguia_mobile/models/patient_model.dart';
import 'package:insuguia_mobile/screens/prescription_result_screen.dart';
import 'package:insuguia_mobile/services/prescription_service.dart';

class PatientInputScreen extends StatefulWidget {
  const PatientInputScreen({super.key});

  @override
  State<PatientInputScreen> createState() => _PatientInputScreenState();
}

class _PatientInputScreenState extends State<PatientInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _creatinineController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _creatinineController.dispose();
    super.dispose();
  }

  void _generatePrescription() {
    if (_formKey.currentState!.validate()) {
      final patient = Patient(
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        creatinine: double.parse(_creatinineController.text),
      );

      final prescriptionService = PrescriptionService();
      final suggestion = prescriptionService.generatePrescription(patient);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrescriptionResultScreen(
            prescriptionSuggestion: suggestion,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do Paciente Não-Crítico'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextFormField(
                  controller: _weightController,
                  labelText: 'Peso (kg)',
                  icon: Icons.monitor_weight,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _heightController,
                  labelText: 'Altura (cm)',
                  icon: Icons.height,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _creatinineController,
                  labelText: 'Creatinina (mg/dL)',
                  icon: Icons.science_outlined,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _generatePrescription,
                  child: const Text('Gerar Sugestão de Prescrição'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        if (double.tryParse(value) == null) {
          return 'Por favor, insira um número válido';
        }
        return null;
      },
    );
  }
}