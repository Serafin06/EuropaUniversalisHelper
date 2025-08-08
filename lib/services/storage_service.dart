import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/checkbox_state.dart';

class StorageService {
  static const String _currentEraKey = 'currentEra';
  static const String _currentHalfKey = 'currentHalf';

  static Future<void> saveCurrentState(int era, int half) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentEraKey, era);
    await prefs.setInt(_currentHalfKey, half);
  }

  static Future<Map<String, int>> loadCurrentState() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'era': prefs.getInt(_currentEraKey) ?? 1,
      'half': prefs.getInt(_currentHalfKey) ?? 1,
    };
  }

  static Future<void> saveCheckboxStates(CheckboxState checkboxState) async {
    final prefs = await SharedPreferences.getInstance();

    for (int era = 1; era <= 3; era++) {
      for (int half = 1; half <= 2; half++) {
        String key = 'era_${era}_half_$half';
        String encodedState = json.encode(
            checkboxState.allStates[era]![half]!
        );
        await prefs.setString(key, encodedState);
      }
    }
  }

  static Future<void> loadCheckboxStates(
      CheckboxState checkboxState,
      List<String> options
      ) async {
    final prefs = await SharedPreferences.getInstance();

    for (int era = 1; era <= 3; era++) {
      for (int half = 1; half <= 2; half++) {
        String key = 'era_${era}_half_$half';
        String? savedState = prefs.getString(key);

        if (savedState != null) {
          Map<String, dynamic> decodedState = json.decode(savedState);

          for (String option in options) {
            bool value = decodedState[option] ?? false;
            checkboxState.setCheckboxValue(era, half, option, value);
          }
        } else {
          // Inicjalizacja jeśli nie ma zapisanych danych
          for (String option in options) {
            checkboxState.setCheckboxValue(era, half, option, false);
          }
        }
      }
    }
  }
}