


class ScenarioConfig
{

final String id;
final String displayName;
final int playerCount;
final int erasCount;
final List<KingdomOption> kingdomOptions;

const ScenarioConfig
(
{
required this.id,
required this.displayName,
required this.playerCount,
required this.erasCount,
  required this.kingdomOptions,
}
);
bool get requiresKingdomSelection => kingdomOptions.isNotEmpty;
}

class KingdomOption {
  final String id;
  final String displayName;
  final String jsonFileName;

  const KingdomOption({
    required this.id,
    required this.displayName,
    required this.jsonFileName,
  });
}