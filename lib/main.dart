import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:insuguia_mobile/screens/home_screen.dart';
import 'package:insuguia_mobile/screens/patient_input_screen.dart';
import 'package:insuguia_mobile/screens/patient_registration_screen.dart';
import 'package:insuguia_mobile/screens/daily_prescription_screen.dart';
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/patient_input': (context) => const PatientInputScreen(),
        '/patient_registration': (context) => const PatientRegistrationScreen(),
        '/daily_prescription': (context) => const DailyPrescriptionScreen(),
        // A rota de resultado será chamada com argumentos, então não precisa ser registrada aqui
      },
    );
  }
}