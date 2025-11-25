// lib/screens/daily_prescription_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:insuguia_mobile/models/patient_model.dart';
import 'package:insuguia_mobile/models/daily_monitoring_model.dart';
import 'package:insuguia_mobile/services/database_service.dart';
import 'package:insuguia_mobile/services/prescription_service.dart';
import 'package:insuguia_mobile/screens/prescription_result_screen.dart';

class DailyPrescriptionScreen extends StatefulWidget {
  const DailyPrescriptionScreen({super.key});

  @override
  State<DailyPrescriptionScreen> createState() => _DailyPrescriptionScreenState();
}

class _DailyPrescriptionScreenState extends State<DailyPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _creatinineController = TextEditingController();
  final _weightController = TextEditingController();
  final _glucoseController = TextEditingController();
  
  Patient? _selectedPatient;
  DateTime _selectedDate = DateTime.now();
  List<Patient> _patients = [];
  bool _isLoading = false;
  bool _isLoadingPatients = false;

  final _databaseService = DatabaseService();
  final _prescriptionService = PrescriptionService();

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  @override
  void dispose() {
    _creatinineController.dispose();
    _weightController.dispose();
    _glucoseController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    setState(() => _isLoadingPatients = true);
    try {
      final patients = await _databaseService.getAllPatients();
      setState(() => _patients = patients);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar pacientes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoadingPatients = false);
    }
  }

  void _onPatientSelected(Patient? patient) {
    setState(() {
      _selectedPatient = patient;
      if (patient != null) {
        // Pre-fill weight with patient's registered weight
        _weightController.text = patient.peso.toString();
      } else {
        _weightController.clear();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _generatePrescription() async {
    if (!_formKey.currentState!.validate() || _selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos corretamente.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create a temporary patient object with current data for prescription calculation
      final currentPatientData = _selectedPatient!.copyWith(
        peso: double.parse(_weightController.text),
      );

      // Generate prescription using current patient data and creatinine
      final prescriptionText = _prescriptionService.generatePrescription(
        currentPatientData,
        double.parse(_creatinineController.text),
      );

      // Save to database
      final dailyMonitoring = DailyMonitoring(
        pacienteId: _selectedPatient!.id!,
        dataAcompanhamento: _selectedDate,
        creatinina: double.parse(_creatinineController.text),
        peso: double.parse(_weightController.text),
        nivelGlicose: int.parse(_glucoseController.text),
        prescricaoGerada: prescriptionText,
      );

      await _databaseService.insertDailyMonitoring(dailyMonitoring);

      if (mounted) {
        // Navigate to result screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrescriptionResultScreen(
              prescriptionSuggestion: prescriptionText,
              patient: _selectedPatient,
              monitoringDate: _selectedDate,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar prescrição: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Prescrição Diária'),
      ),
      body: _isLoadingPatients 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.medical_services,
                    size: 64,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  
                  // Patient Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selecionar Paciente',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          if (_patients.isEmpty)
                            const Text(
                              'Nenhum paciente cadastrado. Cadastre um paciente primeiro.',
                              style: TextStyle(color: Colors.red),
                            )
                          else
                            DropdownButtonFormField<Patient>(
                              value: _selectedPatient,
                              decoration: const InputDecoration(
                                labelText: 'Paciente',
                                prefixIcon: Icon(Icons.person),
                              ),
                              items: _patients.map((patient) {
                                return DropdownMenuItem(
                                  value: patient,
                                  child: Text('${patient.nome} (${patient.idade} anos)'),
                                );
                              }).toList(),
                              onChanged: _onPatientSelected,
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione um paciente';
                                }
                                return null;
                              },
                            ),
                          if (_selectedPatient != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Peso cadastrado: ${_selectedPatient!.peso} kg | '
                              'Altura: ${_selectedPatient!.altura} cm',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Date Selection
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Data do Acompanhamento'),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Current Weight
                  TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Peso Atual (kg)',
                      prefixIcon: Icon(Icons.monitor_weight),
                      helperText: 'Pode ser diferente do peso cadastrado',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      final weight = double.tryParse(value);
                      if (weight == null || weight <= 0 || weight > 500) {
                        return 'Digite um peso válido (1-500 kg)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Creatinine
                  TextFormField(
                    controller: _creatinineController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Creatinina (mg/dL)',
                      prefixIcon: Icon(Icons.science_outlined),
                      helperText: 'Exemplo: 1.2',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      final creatinine = double.tryParse(value);
                      if (creatinine == null || creatinine <= 0 || creatinine > 20) {
                        return 'Digite um valor válido (0-20 mg/dL)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Glucose Level
                  TextFormField(
                    controller: _glucoseController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Nível de Glicose (mg/dL)',
                      prefixIcon: Icon(Icons.bloodtype),
                      helperText: 'Exemplo: 180',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      final glucose = int.tryParse(value);
                      if (glucose == null || glucose <= 0 || glucose > 1000) {
                        return 'Digite um valor válido (1-1000 mg/dL)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Generate Prescription Button
                  ElevatedButton(
                    onPressed: (_isLoading || _patients.isEmpty) ? null : _generatePrescription,
                    child: _isLoading 
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Gerar Prescrição'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Add Patient Button if no patients
                  if (_patients.isEmpty)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text('Cadastrar Novo Paciente'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/patient_registration').then((_) {
                          // Reload patients when returning from registration
                          _loadPatients();
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
    );
  }
}