import 'package:flutter/material.dart';
import '../models/checkbox_state.dart';
import '../services/storage_service.dart';
import '../widgets/era_selection_card.dart';
import '../widgets/half_selection_card.dart';
import '../widgets/checkbox_section.dart';
import '../widgets/reset_button_card.dart';

import 'event_card_screen.dart';

class CheckboxErasScreen extends StatefulWidget {
  @override
  _CheckboxErasScreenState createState() => _CheckboxErasScreenState();
}

class _CheckboxErasScreenState extends State<CheckboxErasScreen> {
  int currentEra = 1;
  int currentHalf = 1;

  final List<String> eraNames = ['Era 1', 'Era 2', 'Era 3'];
  final List<String> checkboxOptions = ['plus', 'trojkat', 'kwadrat', 'kolo'];
  final CheckboxState checkboxState = CheckboxState();

  @override
  void initState() {
    super.initState();
    print('Startujemy z Mastersami');
    _loadData();
  }

  Future<void> _loadData() async {
    // Ładowanie aktualnego stanu ery i połówki
    final currentState = await StorageService.loadCurrentState();

    // Ładowanie stanów checkboxów
    await StorageService.loadCheckboxStates(checkboxState, checkboxOptions);

    setState(() {
      currentEra = currentState['era']!;
      currentHalf = currentState['half']!;
    });
  }

  Future<void> _saveData() async {
    await StorageService.saveCurrentState(currentEra, currentHalf);
    await StorageService.saveCheckboxStates(checkboxState);
  }

  void _changeEra(int newEra) {
    setState(() {
      currentEra = newEra;
      currentHalf = 1;
    });
    _saveData();
  }

  void _navigateToEventCards() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventCardsScreen(
          era: currentEra,
          half: currentHalf,
          eraNames: eraNames,
          checkboxState: checkboxState,
        ),
      ),
    );
  }

  void _changeHalf(int newHalf) {
    setState(() {
      currentHalf = newHalf;
    });
    _saveData();
  }

  void _toggleCheckbox(String option) {
    setState(() {
      bool currentValue = checkboxState.getCheckboxValue(
        currentEra,
        currentHalf,
        option,
      );
      checkboxState.setCheckboxValue(
        currentEra,
        currentHalf,
        option,
        !currentValue,
      );
    });
    _saveData();
  }

  void _resetAllCheckboxes() {
    print('Reset wszystkich checkboxów');

    setState(() {
      checkboxState.resetAll(checkboxOptions);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Wszystkie checkboxy zostały zresetowane'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),

      ),
    );
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Europa Universalis Masters'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            EraSelectionCard(currentEra: currentEra, onEraChanged: _changeEra),
            const SizedBox(height: 8),
            HalfSelectionCard(
              currentEra: currentEra,
              currentHalf: currentHalf,
              eraNames: eraNames,
              onHalfChanged: _changeHalf,
            ),
            const SizedBox(height: 8),
            CheckboxSection(
              currentEra: currentEra,
              currentHalf: currentHalf,
              eraNames: eraNames,
              checkboxOptions: checkboxOptions,
              checkboxState: checkboxState,
              onCheckboxChanged: _toggleCheckbox,
            ),
            const SizedBox(height: 8),
            ResetButtonCard(
              checkboxState: checkboxState,
              onReset: _resetAllCheckboxes,
            ),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Karty wydarzeń',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Zobacz karty dla ${eraNames[currentEra - 1]} - ${currentHalf == 1 ? "I" : "II"} Połówka',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _navigateToEventCards,
                      icon: const Icon(Icons.event_note),
                      label: const Text('Zobacz karty'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
