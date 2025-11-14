import 'package:flutter/material.dart';
import '../models/checkbox_state.dart';
import '../models/event_card.dart';
import '../services/event_cards_service.dart';
import '../widgets/event_card_widget.dart';
import '../widgets/event_card_dialog.dart';

// Ekran pokazujący siatke kart wydarzeń dla wybranej ery i połówki
class EventCardsScreen extends StatefulWidget {
  final int era;
  final int half;
  final List<String> eraNames;
  final CheckboxState checkboxState;

  final String jsonFileName;

  const EventCardsScreen({
    Key? key,
    required this.era,
    required this.half,
    required this.eraNames,
    required this.checkboxState,
    required this.jsonFileName,
  }) : super(key: key);


  @override
  _EventCardsScreenState createState() => _EventCardsScreenState();
}

class _EventCardsScreenState extends State<EventCardsScreen> {
  List<EventCard> eventCards = [];
  bool isLoading = true;
  bool isSelection = false;

  @override
  void initState() {
    super.initState();
    _loadEventCards();
  }

  Future<void> _loadEventCards() async {
    final cards = await EventCardsService.getEventCards(
      widget.era,
      widget.half,
      widget.jsonFileName,
    );
    setState(() {
      eventCards = cards;
      isLoading = false;
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelection = !isSelection;
    });
  }

  void _handleCardTap(EventCard card) {
    if (isSelection) {
      // W trybie zaznaczania - toggle zaznaczenia
      setState(() {
        widget.checkboxState.toggleCardMark(widget.era, widget.half, card.id);
      });
    } else {
      // W normalnym trybie - pokaż pełny obraz
      _showEventCard(card);
    }
  }

  void _showEventCard(EventCard eventCard) {
    EventCardDialog.show(context, eventCard);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.eraNames[widget.era - 1]} - ${widget.half == 1 ? "I" : "II"} Połówka'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    int markedCount = widget.checkboxState.getMarkedCardsCount(widget.era, widget.half);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eraNames[widget.era - 1]} - ${widget.half == 1 ? "I" : "II"} Połówka'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header z informacją i przyciskiem
            Card(
              elevation: 4,
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_note,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Karty wydarzeń',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.deepPurple,
                            ),
                          ),
                          Text(
                            isSelection
                                ? 'Tryb zaznaczania: $markedCount/${eventCards.length} zaznaczonych'
                                : 'Kliknij na kartę aby zobaczyć pełny obraz. $markedCount/${eventCards.length} zaznaczonych',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _toggleSelectionMode,
                      icon: Icon(isSelection ? Icons.check_circle : Icons.radio_button_unchecked),
                      label: Text(isSelection ? 'Zakończ' : 'Zaznacz\nOdznacz'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelection ? Colors.lightBlueAccent : Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Siatka kart
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: eventCards.length,
                itemBuilder: (context, index) {
                  EventCard card = eventCards[index];
                  bool isMarked = widget.checkboxState.isCardMarked(widget.era, widget.half, card.id);

                  return EventCardWidget(
                    eventCard: card,
                    isMarked: isMarked,
                    isSelection: isSelection,
                    onTap: () => _handleCardTap(card),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}