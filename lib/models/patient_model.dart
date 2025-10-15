// lib/models/patient_model.dart
class Patient {
  final String? name;
  final double weight;
  final double height;
  final double creatinine;

  Patient({
    this.name,
    required this.weight,
    required this.height,
    required this.creatinine,
  });
}