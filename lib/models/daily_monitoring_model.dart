// lib/models/daily_monitoring_model.dart

class DailyMonitoring {
  final int? id;
  final int pacienteId;
  final DateTime dataAcompanhamento;
  final double creatinina;
  final double peso;
  final int nivelGlicose;
  final String prescricaoGerada;
  final DateTime? createdAt;

  DailyMonitoring({
    this.id,
    required this.pacienteId,
    required this.dataAcompanhamento,
    required this.creatinina,
    required this.peso,
    required this.nivelGlicose,
    required this.prescricaoGerada,
    this.createdAt,
  });

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paciente_id': pacienteId,
      'data_acompanhamento': dataAcompanhamento.toIso8601String().substring(0, 10),
      'creatinina': creatinina,
      'peso': peso,
      'nivel_glicose': nivelGlicose,
      'prescricao_gerada': prescricaoGerada,
    };
  }

  // Create DailyMonitoring from database map
  factory DailyMonitoring.fromMap(Map<String, dynamic> map) {
    return DailyMonitoring(
      id: map['id'],
      pacienteId: map['paciente_id'],
      dataAcompanhamento: DateTime.parse(map['data_acompanhamento']),
      creatinina: (map['creatinina'] as num).toDouble(),
      peso: (map['peso'] as num).toDouble(),
      nivelGlicose: map['nivel_glicose'],
      prescricaoGerada: map['prescricao_gerada'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  // Copy with method for updates
  DailyMonitoring copyWith({
    int? id,
    int? pacienteId,
    DateTime? dataAcompanhamento,
    double? creatinina,
    double? peso,
    int? nivelGlicose,
    String? prescricaoGerada,
    DateTime? createdAt,
  }) {
    return DailyMonitoring(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      dataAcompanhamento: dataAcompanhamento ?? this.dataAcompanhamento,
      creatinina: creatinina ?? this.creatinina,
      peso: peso ?? this.peso,
      nivelGlicose: nivelGlicose ?? this.nivelGlicose,
      prescricaoGerada: prescricaoGerada ?? this.prescricaoGerada,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}