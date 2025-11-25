// lib/models/patient_model.dart

enum Gender { M, F }

class Patient {
  final int? id;
  final String nome;
  final Gender sexo;
  final DateTime dataNascimento;
  final double peso;
  final double altura;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Patient({
    this.id,
    required this.nome,
    required this.sexo,
    required this.dataNascimento,
    required this.peso,
    required this.altura,
    this.createdAt,
    this.updatedAt,
  });

  // Calculate age from birth date
  int get idade {
    final today = DateTime.now();
    int age = today.year - dataNascimento.year;
    if (today.month < dataNascimento.month || 
        (today.month == dataNascimento.month && today.day < dataNascimento.day)) {
      age--;
    }
    return age;
  }

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'sexo': sexo.name,
      'data_nascimento': dataNascimento.toIso8601String().substring(0, 10),
      'peso': peso,
      'altura': altura,
    };
  }

  // Create Patient from database map
  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      nome: map['nome'],
      sexo: Gender.values.firstWhere((e) => e.name == map['sexo']),
      dataNascimento: DateTime.parse(map['data_nascimento']),
      peso: (map['peso'] as num).toDouble(),
      altura: (map['altura'] as num).toDouble(),
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  // Copy with method for updates
  Patient copyWith({
    int? id,
    String? nome,
    Gender? sexo,
    DateTime? dataNascimento,
    double? peso,
    double? altura,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      sexo: sexo ?? this.sexo,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      peso: peso ?? this.peso,
      altura: altura ?? this.altura,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}