import 'package:flutter/material.dart';

class HalfSelectionCard extends StatelessWidget {
  final int currentEra;
  final int currentHalf;
  final List<String> eraNames;
  final Function(int) onHalfChanged;

  const HalfSelectionCard({
    Key? key,
    required this.currentEra,
    required this.currentHalf,
    required this.eraNames,
    required this.onHalfChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${eraNames[currentEra - 1]} - Wybierz Połówkę:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHalfButton(context, 1, 'I Połówka'),
                _buildHalfButton(context, 2, 'II Połówka'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalfButton(BuildContext context, int half, String label) {
    bool isSelected = currentHalf == half;

    return ElevatedButton(
      onPressed: () => onHalfChanged(half),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
