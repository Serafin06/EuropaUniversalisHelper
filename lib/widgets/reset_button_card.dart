import 'package:flutter/material.dart';
import '../models/checkbox_state.dart';

class ResetButtonCard extends StatelessWidget {
  final CheckboxState checkboxState;
  final VoidCallback onReset;

  const ResetButtonCard({
    Key? key,
    required this.checkboxState,
    required this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalChecked = checkboxState.getTotalCheckedCount();

    return Card(
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
                    'Reset Wszystkich Checkboxów',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalChecked > 0
                        ? 'Zaznaczonych: $totalChecked checkboxów'
                        : 'Brak zaznaczonych checkboxów',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: totalChecked > 0 ? onReset : null,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: totalChecked > 0 ? Colors.red : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
