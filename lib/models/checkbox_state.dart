class CheckboxState {
  final Map<int, Map<int, Map<String, bool>>> _eraStates = {};
  final Map<int, Map<int, Set<String>>> _markedCards = {};

  CheckboxState() {
    _initializeStates();
  }

  void _initializeStates() {
    for (int era = 1; era <= 4; era++) {
      _eraStates[era] = {};
      _markedCards[era] = {};
      for (int half = 1; half <= 2; half++) {
        _eraStates[era]![half] = {};
        _markedCards[era]![half] = <String>{};
      }
    }
  }

  bool getCheckboxValue(int era, int half, String option) {
    return _eraStates[era]?[half]?[option] ?? false;
  }

  void setCheckboxValue(int era, int half, String option, bool value) {
    _eraStates[era]![half]![option] = value;
  }

  void resetAll(List<String> options) {
    for (int era = 1; era <= 4; era++) {
      for (int half = 1; half <= 2; half++) {
        for (String option in options) {
          _eraStates[era]![half]![option] = false;
        }
        // Reset zaznaczonych kart
        _markedCards[era]![half]!.clear();
      }
    }
  }

  Map<int, Map<int, Map<String, bool>>> get allStates => _eraStates;

  int getCheckedCount(int era, int half) {
    return _eraStates[era]![half]!.values
        .where((isChecked) => isChecked)
        .length;
  }

  int getTotalCheckedCount() {
    int total = 0;
    for (int era = 1; era <= 4; era++) {
      for (int half = 1; half <= 2; half++) {
        total += _eraStates[era]![half]!.values
            .where((isChecked) => isChecked)
            .length;
      }
    }
    return total;
  }
  bool isCardMarked(int era, int half, String cardId) {
    return _markedCards[era]?[half]?.contains(cardId) ?? false;
  }

  void toggleCardMark(int era, int half, String cardId) {
    if (isCardMarked(era, half, cardId)) {
      _markedCards[era]![half]!.remove(cardId);
    } else {
      _markedCards[era]![half]!.add(cardId);
    }
  }

  int getMarkedCardsCount(int era, int half) {
    return _markedCards[era]?[half]?.length ?? 0;
  }

  int getTotalMarkedCardsCount() {
    int total = 0;
    for (int era = 1; era <= 4; era++) {
      for (int half = 1; half <= 2; half++) {
        total += _markedCards[era]![half]!.length;
      }
    }
    return total;
  }

  List<String> getMarkedCardsList(int era, int half) {
    return _markedCards[era]?[half]?.toList() ?? [];
  }

  void setMarkedCardsList(int era, int half, List<String> cards) {
    _markedCards[era]![half] = cards.toSet();
  }
}