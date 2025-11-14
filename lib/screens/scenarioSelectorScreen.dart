import 'package:flutter/material.dart';
import '../models/scenarioConfig.dart';
import '../services/scenarioRepository.dart';
import '../services/storage_service.dart';

class ScenarioSelectionScreen extends StatelessWidget {
  final VoidCallback onScenarioSelected;

  const ScenarioSelectionScreen({Key? key, required this.onScenarioSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Scenario'),
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
            ...ScenarioRepository.availableScenarios.map((scenario) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () async {
                      await StorageService.saveSelectedScenario(
                        scenario.id,
                        scenario.playerCount,
                      );
                      onScenarioSelected();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.displayName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.people, size: 20, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${scenario.playerCount} players',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.timeline, size: 20, color: Colors.grey[600]),
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
}