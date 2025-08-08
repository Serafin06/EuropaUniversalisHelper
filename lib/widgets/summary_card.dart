import 'package:flutter/material.dart';
import '../models/checkbox_state.dart';

class SummaryCard extends StatelessWidget {
  final int currentEra;
  final int currentHalf;
  final CheckboxState checkboxState;
  final int totalOptions;

  const SummaryCard({
    Key? key,
    required this.currentEra,
    required this.currentHalf,
    required this.checkboxState,
    required this.totalOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int checkedCount = checkboxState.getCheckedCount(currentEra, currentHalf);
    double percentage = (checkedCount / totalOptions) * 100;

    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Postęp:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}% ukończone',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Chip(
              label: Text(
                '$checkedCount / $totalOptions',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}