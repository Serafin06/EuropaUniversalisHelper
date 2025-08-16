import 'package:flutter/material.dart';
import '../models/event_card.dart';

/// Widget pojedynczej karty wydarzenia.
/// Pokazuje miniaturkę, obsługuje kliknięcie i zaznaczenie (mark/selection)
class EventCardWidget extends StatelessWidget {
  final EventCard eventCard;
  final VoidCallback onTap;
  final bool isMarked; // Czy karta jest zaznaczona (czerwona ramka + krzyż)
  final bool isSelection; // Czy tryb selekcji jest włączony

  const EventCardWidget({
    Key? key,
    required this.eventCard,
    required this.onTap,
    required this.isMarked,
    required this.isSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isMarked
                  ? Colors.red.withOpacity(
                      0.8,
                    ) // Czerwona ramka dla zaznaczonych
                  : Theme.of(context).dividerColor.withOpacity(0.3),
              width: isMarked ? 3 : 1, // Grubsza ramka dla zaznaczonych
            ),
          ),
          child: Stack(
            children: [
              // Główna zawartość karty: obrazek + ewentualny tytuł
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Image.asset(
                        eventCard.thumbnailPath,
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_note,
                                  size: 40,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Karta ${eventCard.id.split('card')[1]}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // 🔘 Ikona w prawym górnym rogu w trybie selekcji
              if (isSelection)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isMarked ? Icons.cancel : Icons.radio_button_unchecked,
                      color: isMarked ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                  ),
                ),

              // Overlay przyciemniony + duży krzyż w trybie selekcji
              if (!isSelection && isMarked) ...[
                // Overlay przyciemniony
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red, width: 3),
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),

                // Mały krzyż w prawym górnym rogu
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.cancel, color: Colors.red, size: 28),
                ),

                // Duży krzyż przez środek
                Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.red.withOpacity(0.7),
                    size: 80,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
