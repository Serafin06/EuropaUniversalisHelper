import 'package:flutter/material.dart';
import '../models/scenarioConfig.dart';
import '../services/scenarioRepository.dart';
import '../services/storage_service.dart';


class ScenarioSelectionScreen extends StatelessWidget {
  final int playerCount;
  final Function(ScenarioConfig, String) onScenarioSelected; // dodaj kingdomId

  const ScenarioSelectionScreen({
    Key? key,
    required this.playerCount,
    required this.onScenarioSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scenarios = ScenarioRepository.getScenariosForPlayerCount(playerCount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Scenario ($playerCount Players)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose Your Campaign',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...scenarios.map((scenario) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () => _handleScenarioTap(context, scenario),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.displayName,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.timeline,
                                  size: 20, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${scenario.erasCount} eras',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _handleScenarioTap(BuildContext context, ScenarioConfig scenario) async {
    // Jeśli scenariusz wymaga wyboru królestwa - pokaż popup
    if (scenario.requiresKingdomSelection && scenario.kingdomOptions.length > 1) {
      _showKingdomDialog(context, scenario);
    } else {
      // Brak wyboru - użyj domyślnego
      await StorageService.saveSelectedScenario(
        scenario.id,
        scenario.playerCount,
        scenario.kingdomOptions.first.id,
      );
      onScenarioSelected(scenario, scenario.kingdomOptions.first.id);
    }
  }

  void _showKingdomDialog(BuildContext context, ScenarioConfig scenario) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Kingdom'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: scenario.kingdomOptions.map((kingdom) {
            return ListTile(
              leading: const Icon(Icons.castle),
              title: Text(kingdom.displayName),
              onTap: () async {
                Navigator.of(dialogContext).pop(); // Zamknij dialog

                // Zapisz dane
                await StorageService.saveSelectedScenario(
                  scenario.id,
                  scenario.playerCount,
                  kingdom.id,
                );

                // Wywołaj callback (który jest z PlayerCountSelectionScreen)
                onScenarioSelected(scenario, kingdom.id);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}