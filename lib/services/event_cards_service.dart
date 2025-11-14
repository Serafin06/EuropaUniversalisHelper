import '../models/event_card.dart';
import 'card_mapping_service.dart';

// Serwis zarządzający kartami wydarzeń - używa rzeczywistych plików i tytułów
class EventCardsService {
  static Future<List<EventCard>> getEventCards(int era, int half, String jsonFileName) async {
    return await CardsMappingService.getEventCards(era, half, jsonFileName);
  }

  static Future<int> getCardCount(int era, int half, String jsonFileName) async {
    return await CardsMappingService.getCardCount(era, half, jsonFileName);
  }
}