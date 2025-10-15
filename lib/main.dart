import 'package:flutter/material.dart';
import 'package:insuguia_mobile/screens/home_screen.dart';
import 'package:insuguia_mobile/screens/patient_input_screen.dart';
import 'package:insuguia_mobile/screens/prescription_result_screen.dart';
import 'package:insuguia_mobile/utils/app_theme.dart';

void main() {
  runApp(const InsuGuiaApp());
}

class InsuGuiaApp extends StatelessWidget {
  const InsuGuiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsuGuia Mobile',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/patient_input': (context) => const PatientInputScreen(),
        // A rota de resultado será chamada com argumentos, então não precisa ser registrada aqui
        // a menos que você queira um acesso direto a ela por algum motivo.
      },
    );
  }
}