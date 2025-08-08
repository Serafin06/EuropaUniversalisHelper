import 'package:flutter/material.dart';

class EraSelectionCard extends StatelessWidget {
  final int currentEra;
  final Function(int) onEraChanged;

  const EraSelectionCard({
    Key? key,
    required this.currentEra,
    required this.onEraChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Wybierz Erę:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int era = 1; era <= 3; era++)
                  _buildEraButton(context, era),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEraButton(BuildContext context, int era) {
    bool isSelected = currentEra == era;

    return ElevatedButton(
      onPressed: () => onEraChanged(era),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        'Era $era',
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
