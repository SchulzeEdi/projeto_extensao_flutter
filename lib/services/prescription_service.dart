import 'package:insuguia_mobile/models/patient_model.dart';

class PrescriptionService {
  /// Gera uma sugestão de prescrição com base nos dados do paciente.
  /// A lógica aqui é uma simplificação para o protótipo acadêmico.
  String generatePrescription(Patient patient) {
    // --- LÓGICA DE CÁLCULO BASEADA NAS DIRETRIZES ---
    // Esta é uma implementação simplificada para fins de protótipo.

    // Passo 1: Calcular Dose Total Diária (DTD) de Insulina [cite: 122]
    // Usando uma média de 0.4 UI/kg/dia para o protótipo.
    // Variação: 0.2 a 0.6 UI/kg/dia, dependendo da sensibilidade.
    double dtd = patient.weight * 0.4;

    // Passo 2: Calcular Insulina Basal (50% da DTD) [cite: 123]
    double basalDose = dtd * 0.5;

    // Passo 3: Calcular Insulina Bôlus/Prandial (50% da DTD) [cite: 128]
    double bolusTotalDose = dtd * 0.5;
    double bolusPerMeal = bolusTotalDose / 3;

    // Arredondamento das doses para números inteiros [cite: 125]
    int roundedBasalDose = basalDose.round();
    int roundedBolusPerMeal = bolusPerMeal.round();
    
    // --- MONTAGEM DO TEXTO DA PRESCRIÇÃO [cite: 136] ---
    
    final prescription = """
1. Dieta para Diabetes. [cite: 137]

2. Monitorização da Glicemia Capilar: [cite: 138]
   - Antes do café, almoço, jantar e às 22h. [cite: 139]

3. Insulina Basal:
   - Ex: Insulina NPH, via subcutânea, $roundedBasalDose UI às 22h.
   (Ajustar tipo e horários conforme disponibilidade e protocolo do hospital).

4. Insulina Bôlus de Refeição (Rápida):
   - Ex: Insulina Regular, via subcutânea, $roundedBolusPerMeal UI antes do café, almoço e jantar.

5. Dose de Correção (Exemplo de Tabela): [cite: 147]
   - Glicemia 181-250: +2 UI de Insulina Rápida
   - Glicemia 251-300: +4 UI de Insulina Rápida
   - Glicemia >300: +6 UI de Insulina Rápida
   (Acrescentar à dose de bôlus se glicemia > 180 mg/dL).

6. Orientações para Hipoglicemia (Glicemia < 70 mg/dL): [cite: 149]
   - Se consciente e capaz de deglutir: Oferecer 15g de carboidrato de ação rápida (ex: 1 colher de sopa de açúcar em água ou 150ml de suco).
   - Reavaliar glicemia em 15 minutos.
   - Se inconsciente: Administrar Glicose 50% IV.
""";

    return prescription;
  }
}