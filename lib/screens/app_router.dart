import 'package:flutter/material.dart';
import '../services/scenarioRepository.dart';
import '../services/storage_service.dart';
import 'player_count_selection_screen.dart';
import 'scenarioSummaryScreen.dart';
import 'checkbox_eras_screen.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: StorageService.getSelectedScenario(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final scenarioData = snapshot.data;

        // Brak danych - wybór liczby graczy
        if (scenarioData == null) {
          return const PlayerCountSelectionScreen();
        }

        final scenario = ScenarioRepository.getScenarioById(
          scenarioData['scenarioId'],
        );

        // Nieprawidłowy scenariusz
        if (scenario == null) {
          return const PlayerCountSelectionScreen();
        }

        // Pokaż ekran potwierdzenia
        return ScenarioSummaryScreen(
          scenario: scenario,
          onContinue: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => CheckboxErasScreen()),
            );
          },
          onReset: () async {
            await StorageService.clearAllData();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AppRouter()),
            );
          },
        );
      },
    );
  }
}