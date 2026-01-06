import 'package:europa_universalis/screens/scenarioSelectorScreen.dart';
import 'package:flutter/material.dart';
import '../services/scenarioRepository.dart';
import '../services/storage_service.dart';
import 'app_router.dart';

class PlayerCountSelectionScreen extends StatelessWidget {
  const PlayerCountSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerCounts = ScenarioRepository.getAvailablePlayerCounts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Player Count'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How many players?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...playerCounts.map((count) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      final currentContext = context; // Zachowaj context
                      Navigator.of(currentContext).pushReplacement(
                        MaterialPageRoute(
                          builder: (newContext) => ScenarioSelectionScreen(
                            playerCount: count,
                            onScenarioSelected: (scenario, kingdomId) {
                              // Ten callback będzie wywołany z ScenarioSelectionScreen
                              // Użyj Navigator z NOWEGO contextu
                              Navigator.of(newContext).pushReplacement(
                                MaterialPageRoute(builder: (_) => const AppRouter()),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '$count Players',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
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