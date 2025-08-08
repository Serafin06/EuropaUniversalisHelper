import 'package:flutter/material.dart';
import '../models/checkbox_state.dart';
import 'checkbox_item.dart';

class CheckboxSection extends StatelessWidget {
  final int currentEra;
  final int currentHalf;
  final List<String> eraNames;
  final List<String> checkboxOptions;
  final CheckboxState checkboxState;
  final Function(String) onCheckboxChanged;

  const CheckboxSection({
    Key? key,
    required this.currentEra,
    required this.currentHalf,
    required this.eraNames,
    required this.checkboxOptions,
    required this.checkboxState,
    required this.onCheckboxChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Opcje dla ${eraNames[currentEra - 1]} - ${currentHalf == 1 ? "I" : "II"} Połówka:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: checkboxOptions.length,
                  itemBuilder: (context, index) {
                    String option = checkboxOptions[index];
                    bool isChecked = checkboxState.getCheckboxValue(
                        currentEra,
                        currentHalf,
                        option
                    );

                    return CheckboxItem(
                      option: option,
                      isChecked: isChecked,
                      onChanged: () => onCheckboxChanged(option),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}