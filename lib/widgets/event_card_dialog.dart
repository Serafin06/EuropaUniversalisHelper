import 'package:flutter/material.dart';
import '../models/event_card.dart';

// Dialog pełnoekranowy pokazujący szczegóły karty wydarzenia
class EventCardDialog extends StatelessWidget {
  final EventCard eventCard;

  const EventCardDialog({Key? key, required this.eventCard}) : super(key: key);

  static void show(BuildContext context, EventCard eventCard) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => EventCardDialog(eventCard: eventCard),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // Header z tytułem i przyciskiem zamknięcia
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      eventCard.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Główny obraz
            Expanded(
              child: Container(
                width: double.infinity,
                child: Image.asset(
                  eventCard.fullImagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback gdy nie ma pełnego obrazka
                    return Container(
                      color: Colors.grey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 100,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Pełny obraz niedostępny',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
