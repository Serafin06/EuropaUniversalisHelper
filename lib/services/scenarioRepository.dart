

import '../models/scenarioConfig.dart';

class ScenarioRepository {
  static const List<ScenarioConfig> availableScenarios = [
    ScenarioConfig(
      id: 'grand_campaign',
      displayName: 'The Grand Campaign',
      playerCount: 6,
      jsonFileName: 'event_cards_mapping.json',
      erasCount: 4,
    ),
    ScenarioConfig(
      id: 'enemy_at_gates',
      displayName: 'The Enemy at the Gates',
      playerCount: 4,
      jsonFileName: 'enemy.json',
      erasCount: 4,
    ),
  ];

  static ScenarioConfig? getScenarioById(String id) {
    try {
      return availableScenarios.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}