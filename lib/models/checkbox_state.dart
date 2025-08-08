class CheckboxState {
  final Map<int, Map<int, Map<String, bool>>> _eraStates = {};

  CheckboxState() {
    _initializeStates();
  }

  void _initializeStates() {
    for (int era = 1; era <= 3; era++) {
      _eraStates[era] = {};
      for (int half = 1; half <= 2; half++) {
        _eraStates[era]![half] = {};
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
    for (int era = 1; era <= 3; era++) {
      for (int half = 1; half <= 2; half++) {
        for (String option in options) {
          _eraStates[era]![half]![option] = false;
        }
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
    for (int era = 1; era <= 3; era++) {
      for (int half = 1; half <= 2; half++) {
        total += _eraStates[era]![half]!.values
            .where((isChecked) => isChecked)
            .length;
      }
    }
    return total;
  }
}