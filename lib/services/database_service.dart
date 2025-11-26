// lib/services/database_service.dart

import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import 'package:insuguia_mobile/models/patient_model.dart';
import 'package:insuguia_mobile/models/daily_monitoring_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Connection? _connection;
  
  // Mock data for web platform
  final List<Patient> _mockPatients = [];
  final List<DailyMonitoring> _mockMonitoring = [];
  int _nextPatientId = 1;
  int _nextMonitoringId = 1;

  // Database connection configuration
  static const String _host = 'localhost';
  static const int _port = 5432;
  static const String _database = 'insuguia_mobile';
  static const String _username = 'postgres';
  static const String _password = 'postgres';

  // Connect to PostgreSQL database
  Future<void> connect() async {
    // Skip database connection on web platform
    if (kIsWeb) {
      print('Database connection skipped on web platform');
      return;
    }
    
    try {
      _connection = await Connection.open(
        Endpoint(
          host: _host,
          port: _port,
          database: _database,
          username: _username,
          password: _password,
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.disable,
        ),
      );
      print('Connected to PostgreSQL database');
    } catch (e) {
      print('Error connecting to database: $e');
      rethrow;
    }
  }

  // Close database connection
  Future<void> close() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
      print('Database connection closed');
    }
  }

  // Ensure connection is established
  Future<void> _ensureConnection() async {
    if (kIsWeb) {
      // Skip connection check on web
      return;
    }
    if (_connection == null || _connection!.isOpen == false) {
      await connect();
    }
  }

  // ========== PATIENT OPERATIONS ==========

  // Insert a new patient
  Future<int> insertPatient(Patient patient) async {
    await _ensureConnection();
    
    if (kIsWeb) {
      // Mock implementation for web
      final patientWithId = patient.copyWith(id: _nextPatientId);
      _mockPatients.add(patientWithId);
      print('Mock: Patient registered - ${patient.nome} (ID: $_nextPatientId)');
      return _nextPatientId++;
    }
    
    final result = await _connection!.execute(
      '''
      INSERT INTO paciente (nome, sexo, data_nascimento, peso, altura)
      VALUES (\$1, \$2, \$3, \$4, \$5)
      RETURNING id
      ''',
      parameters: [
        patient.nome,
        patient.sexo.name,
        patient.dataNascimento.toIso8601String().substring(0, 10),
        patient.peso,
        patient.altura,
      ],
    );
    
    return result.first.first as int;
  }

  // Get all patients
  Future<List<Patient>> getAllPatients() async {
    await _ensureConnection();
    
    if (kIsWeb) {
      // Return mock data for web
      return List.from(_mockPatients);
    }
    
    final result = await _connection!.execute(
      'SELECT id, nome, sexo, data_nascimento, peso, altura, created_at, updated_at FROM paciente ORDER BY nome'
    );
    
    return result.map((row) {
      return Patient.fromMap({
        'id': row[0],
        'nome': row[1],
        'sexo': row[2],
        'data_nascimento': row[3].toString(),
        'peso': row[4],
        'altura': row[5],
        'created_at': row[6]?.toString(),
        'updated_at': row[7]?.toString(),
      });
    }).toList();
  }

  // Get patient by ID
  Future<Patient?> getPatientById(int id) async {
    await _ensureConnection();
    
    final result = await _connection!.execute(
      'SELECT id, nome, sexo, data_nascimento, peso, altura, created_at, updated_at FROM paciente WHERE id = \$1',
      parameters: [id],
    );
    
    if (result.isEmpty) return null;
    
    final row = result.first;
    return Patient.fromMap({
      'id': row[0],
      'nome': row[1],
      'sexo': row[2],
      'data_nascimento': row[3].toString(),
      'peso': row[4],
      'altura': row[5],
      'created_at': row[6]?.toString(),
      'updated_at': row[7]?.toString(),
    });
  }

  // Update patient
  Future<void> updatePatient(Patient patient) async {
    await _ensureConnection();
    
    await _connection!.execute(
      '''
      UPDATE paciente 
      SET nome = \$1, sexo = \$2, data_nascimento = \$3, peso = \$4, altura = \$5
      WHERE id = \$6
      ''',
      parameters: [
        patient.nome,
        patient.sexo.name,
        patient.dataNascimento.toIso8601String().substring(0, 10),
        patient.peso,
        patient.altura,
        patient.id,
      ],
    );
  }

  // Delete patient
  Future<void> deletePatient(int id) async {
    await _ensureConnection();
    
    await _connection!.execute(
      'DELETE FROM paciente WHERE id = \$1',
      parameters: [id],
    );
  }

  // ========== DAILY MONITORING OPERATIONS ==========

  // Insert daily monitoring record
  Future<int> insertDailyMonitoring(DailyMonitoring monitoring) async {
    await _ensureConnection();
    
    if (kIsWeb) {
      // Mock implementation for web
      final monitoringWithId = monitoring.copyWith(id: _nextMonitoringId);
      _mockMonitoring.add(monitoringWithId);
      print('Mock: Daily monitoring saved (ID: $_nextMonitoringId)');
      return _nextMonitoringId++;
    }
    
    final result = await _connection!.execute(
      '''
      INSERT INTO acompanhamento_diario (paciente_id, data_acompanhamento, creatinina, peso, nivel_glicose, prescricao_gerada)
      VALUES (\$1, \$2, \$3, \$4, \$5, \$6)
      RETURNING id
      ''',
      parameters: [
        monitoring.pacienteId,
        monitoring.dataAcompanhamento.toIso8601String().substring(0, 10),
        monitoring.creatinina,
        monitoring.peso,
        monitoring.nivelGlicose,
        monitoring.prescricaoGerada,
      ],
    );
    
    return result.first.first as int;
  }

  // Get daily monitoring records for a patient
  Future<List<DailyMonitoring>> getDailyMonitoringByPatient(int pacienteId) async {
    await _ensureConnection();
    
    final result = await _connection!.execute(
      '''
      SELECT id, paciente_id, data_acompanhamento, creatinina, peso, nivel_glicose, prescricao_gerada, created_at
      FROM acompanhamento_diario 
      WHERE paciente_id = \$1 
      ORDER BY data_acompanhamento DESC
      ''',
      parameters: [pacienteId],
    );
    
    return result.map((row) {
      return DailyMonitoring.fromMap({
        'id': row[0],
        'paciente_id': row[1],
        'data_acompanhamento': row[2].toString(),
        'creatinina': row[3],
        'peso': row[4],
        'nivel_glicose': row[5],
        'prescricao_gerada': row[6],
        'created_at': row[7]?.toString(),
      });
    }).toList();
  }

  // Get all daily monitoring records
  Future<List<DailyMonitoring>> getAllDailyMonitoring() async {
    await _ensureConnection();
    
    final result = await _connection!.execute(
      '''
      SELECT id, paciente_id, data_acompanhamento, creatinina, peso, nivel_glicose, prescricao_gerada, created_at
      FROM acompanhamento_diario 
      ORDER BY data_acompanhamento DESC
      '''
    );
    
    return result.map((row) {
      return DailyMonitoring.fromMap({
        'id': row[0],
        'paciente_id': row[1],
        'data_acompanhamento': row[2].toString(),
        'creatinina': row[3],
        'peso': row[4],
        'nivel_glicose': row[5],
        'prescricao_gerada': row[6],
        'created_at': row[7]?.toString(),
      });
    }).toList();
  }

  // Delete daily monitoring record
  Future<void> deleteDailyMonitoring(int id) async {
    await _ensureConnection();
    
    await _connection!.execute(
      'DELETE FROM acompanhamento_diario WHERE id = \$1',
      parameters: [id],
    );
  }
}