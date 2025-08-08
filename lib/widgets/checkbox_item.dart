import 'package:flutter/material.dart';

class CheckboxItem extends StatelessWidget {
  final String option;
  final bool isChecked;
  final VoidCallback onChanged;

  const CheckboxItem({
    Key? key,
    required this.option,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(8),
        color: isChecked
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Icon(
              isChecked
                  ? _getFilledGeometricIcon(option)
                  : _getDefaultGeometricIcon(option),
              color: isChecked
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).iconTheme.color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              option,
              style: TextStyle(
                fontSize: 16,
                decoration: isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        value: isChecked,
        onChanged: (bool? value) => onChanged(),
        activeColor: Theme.of(context).primaryColor,
        checkColor: Colors.white,
        secondary: _getIconForOption(context, option, isChecked),
      ),
    );
  }

  Widget _getIconForOption(BuildContext context, String option, bool isChecked) {
    String imagePath = 'assets/icons/${option.toLowerCase()}.png';
    bool useCustomImages = true;

    if (useCustomImages) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isChecked
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[100],
                child: Icon(
                  _getDefaultGeometricIcon(option),
                  color: isChecked
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 20,
                ),
              );
            },
            color: isChecked ? null : Colors.grey,
            colorBlendMode: isChecked ? null : BlendMode.multiply,
          ),
        ),
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isChecked
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isChecked
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Icon(
          _getDefaultGeometricIcon(option),
          color: isChecked ? Theme.of(context).primaryColor : Colors.grey,
          size: 24,
        ),
      );
    }
  }

  IconData _getDefaultGeometricIcon(String option) {
    switch (option) {
      case 'trojkat':
        return Icons.change_history_outlined;
      case 'kwadrat':
        return Icons.crop_square_sharp;
      case 'kolo':
        return Icons.radio_button_unchecked;
      case 'plus':
        return Icons.add_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  IconData _getFilledGeometricIcon(String option) {
    switch (option) {
      case 'trojkat':
        return Icons.change_history;
      case 'kwadrat':
        return Icons.square;
      case 'kolo':
        return Icons.circle;
      case 'plus':
        return Icons.add_circle;
      default:
        return Icons.help;
    }
  }
}