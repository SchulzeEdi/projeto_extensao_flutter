// lib/screens/patient_registration_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:insuguia_mobile/models/patient_model.dart';
import 'package:insuguia_mobile/services/database_service.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _birthDateController = TextEditingController();
  
  Gender _selectedGender = Gender.M;
  DateTime? _selectedDate;
  bool _isLoading = false;

  final _databaseService = DatabaseService();

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)), // 30 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _registerPatient() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
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
      final patient = Patient(
        nome: _nameController.text.trim(),
        sexo: _selectedGender,
        dataNascimento: _selectedDate!,
        peso: double.parse(_weightController.text),
        altura: double.parse(_heightController.text),
      );

      final patientId = await _databaseService.insertPatient(patient);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paciente cadastrado com sucesso! ID: $patientId'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form after successful registration
        _formKey.currentState!.reset();
        _nameController.clear();
        _weightController.clear();
        _heightController.clear();
        _birthDateController.clear();
        setState(() {
          _selectedDate = null;
          _selectedGender = Gender.M;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar paciente: $e'),
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
        title: const Text('Cadastro de Paciente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_add,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              
              // Nome
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (value.trim().length < 2) {
                    return 'Nome deve ter pelo menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Sexo
              const Text('Sexo:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<Gender>(
                      title: const Text('Masculino'),
                      value: Gender.M,
                      groupValue: _selectedGender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<Gender>(
                      title: const Text('Feminino'),
                      value: Gender.F,
                      groupValue: _selectedGender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Data de Nascimento
              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  prefixIcon: const Icon(Icons.cake),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              if (_selectedDate != null) 
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Idade: ${_calculateAge(_selectedDate!)} anos',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              
              // Peso
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                  helperText: 'Exemplo: 75.5',
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
              
              // Altura
              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Altura (cm)',
                  prefixIcon: Icon(Icons.height),
                  helperText: 'Exemplo: 175.0',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  final height = double.tryParse(value);
                  if (height == null || height <= 0 || height > 300) {
                    return 'Digite uma altura válida (1-300 cm)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              // Botão Cadastrar
              ElevatedButton(
                onPressed: _isLoading ? null : _registerPatient,
                child: _isLoading 
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Cadastrar Paciente'),
              ),
              
              const SizedBox(height: 16),
              
              // Disclaimer
              Card(
                color: Colors.yellow[50],
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Os dados do paciente serão armazenados localmente para uso no aplicativo.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}