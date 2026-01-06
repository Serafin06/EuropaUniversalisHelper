

import '../models/scenarioConfig.dart';

class ScenarioRepository {
  static const List<ScenarioConfig> availableScenarios = [
    ScenarioConfig(
      id: 'grand_campaign',
      displayName: 'The Grand Campaign',
      playerCount: 6,
      erasCount: 4,
      kingdomOptions: [
        KingdomOption(
          id: 'default',
          displayName: 'Standard',
          jsonFileName: 'event_cards_mapping.json',
        ),
      ],
    ),
    ScenarioConfig(
      id: 'enemy_at_gates_4',
      displayName: 'The Enemy at the Gates',
      playerCount: 4,
      erasCount: 4,
      kingdomOptions: [
        KingdomOption(
          id: 'default',
          displayName: 'Standard',
          jsonFileName: 'enemy.json',
        ),
      ],
    ),

    // Tutaj dodasz nowe scenariusze
  ];

  static List<ScenarioConfig> getScenariosForPlayerCount(int playerCount) {
    return availableScenarios
        .where((s) => s.playerCount == playerCount)
        .toList();
  }

  static ScenarioConfig? getScenarioById(String id) {
    try {
      return availableScenarios.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<int> getAvailablePlayerCounts() {
    return availableScenarios
        .map((s) => s.playerCount)
        .toSet()
        .toList()
      ..sort();
  }
}