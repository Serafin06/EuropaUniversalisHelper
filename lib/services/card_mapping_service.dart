import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/event_card.dart';

// Serwis mapujący rzeczywiste nazwy plików do tytułów i organizujący karty
class CardsMappingService {
  static Map<String, List<Map<String, String>>>? _cardsData;

  // Ładuje mapowanie z pliku JSON
  static Future<void> loadCardsMapping() async {
    if (_cardsData != null) return;

    try {
      final String jsonString = await rootBundle.loadString('assets/eventCards_mapping.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      _cardsData = {};
      jsonData.forEach((key, value) {
        _cardsData![key] = (value as List).map((item) => Map<String, String>.from(item)).toList();
      });
    } catch (e) {
      print('Błąd ładowania mapowania kart: $e');
      _cardsData = {};
    }
  }

  // Pobiera karty dla konkretnej ery i połówki
  static Future<List<EventCard>> getEventCards(int era, int half) async {
    await loadCardsMapping();

    String key = 'era${era}_half${half}';
    List<EventCard> cards = [];

    if (_cardsData!.containsKey(key)) {
      List<Map<String, String>> cardsList = _cardsData![key]!;

      for (Map<String, String> cardData in cardsList) {
        String folderPath = 'assets/events/Era${era}Half${half}/${cardData['filename']}';
        cards.add(EventCard(
          id: cardData['title']!,
          title: cardData['title']!,
          thumbnailPath: folderPath,
          fullImagePath: folderPath,
                  ));
      }
    }

    return cards;
  }

  // Pobiera liczbę kart dla ery/połówki
  static Future<int> getCardCount(int era, int half) async {
    final cards = await getEventCards(era, half);
    return cards.length;
  }
}