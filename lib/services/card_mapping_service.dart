import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/event_card.dart';

// Serwis mapujący rzeczywiste nazwy plików do tytułów i organizujący karty
class CardsMappingService {
  static Map<String, List<Map<String, String>>>? _cardsData;

  // Ładuje mapowanie z pliku JSON
  static String? _currentJsonFile;

  static Future<void> loadCardsMapping(String jsonFileName) async {
    // Przeładuj tylko jeśli zmienił się plik
    if (_cardsData != null && _currentJsonFile == jsonFileName) return;

    try {
      final String jsonString = await rootBundle.loadString(
          'assets/$jsonFileName');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      _cardsData = {};
      jsonData.forEach((key, value) {
        _cardsData![key] = (value as List)
            .map((item) => Map<String, String>.from(item))
            .toList();
      });

      _currentJsonFile = jsonFileName;
    } catch (e) {
      print('Błąd ładowania mapowania kart: $e');
      _cardsData = {};
    }
  }

  // Pobiera karty dla konkretnej ery i połówki
  static Future<List<EventCard>> getEventCards(int era, int half,
      String jsonFileName) async {
    await loadCardsMapping(jsonFileName);

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
  static Future<int> getCardCount(int era, int half,
      String jsonFileName) async {
    final cards = await getEventCards(era, half, jsonFileName);
    return cards.length;
  }
}