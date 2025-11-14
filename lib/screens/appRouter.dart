import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/scenarioRepository.dart';
import 'scenarioSelectorScreen.dart';
import 'scenarioSummaryScreen.dart';
import 'checkbox_eras_screen.dart';

// Router decydujący o starcie aplikacji na podstawie zapisanego stanu
class AppRouter extends StatelessWidget {
  const AppRouter({Key? key}) : super(key: key);

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

        // Brak scenariusza - pokaż ekran wyboru
        if (scenarioData == null) {
          return ScenarioSelectionScreen(
            onScenarioSelected: () => _reloadApp(context),
          );
        }

        final scenario = ScenarioRepository.getScenarioById(
          scenarioData['scenarioId'],
        );

        // Nieprawidłowe ID scenariusza - pokaż ekran wyboru
        if (scenario == null) {
          return ScenarioSelectionScreen(
            onScenarioSelected: () => _reloadApp(context),
          );
        }

        // Mamy wybrany scenariusz - pokaż ekran potwierdzenia
        return ScenarioSummaryScreen(
          scenario: scenario,
          onContinue: () => _navigateToGame(context),
          onReset: () => _resetAndReload(context),
        );
      },
    );
  }

  void _reloadApp(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppRouter()),
    );
  }

  void _navigateToGame(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => CheckboxErasScreen()),
    );
  }

  Future<void> _resetAndReload(BuildContext context) async {
    await StorageService.clearAllData();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppRouter()),
    );
  }
}