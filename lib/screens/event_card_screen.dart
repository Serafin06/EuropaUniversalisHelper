import 'package:flutter/material.dart';
import '../models/event_card.dart';
import '../services/event_cards_service.dart';
import '../widgets/event_card_widget.dart';
import '../widgets/event_card_dialog.dart';

// Ekran pokazujący siatke kart wydarzeń dla wybranej ery i połówki
class EventCardsScreen extends StatefulWidget {
  final int era;
  final int half;
  final List<String> eraNames;

  const EventCardsScreen({
    Key? key,
    required this.era,
    required this.half,
    required this.eraNames,
  }) : super(key: key);

  @override
  _EventCardsScreenState createState() => _EventCardsScreenState();
}

class _EventCardsScreenState extends State<EventCardsScreen> {
  List<EventCard> eventCards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEventCards();
  }

  Future<void> _loadEventCards() async {
    final cards = await EventCardsService.getEventCards(widget.era, widget.half);
    setState(() {
      eventCards = cards;
      isLoading = false;
    });
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
            // Header z informacją
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Kliknij na kartę aby zobaczyć pełny obraz',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
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
                  crossAxisCount: 3, // 3 karty w rzędzie
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75, // Proporcje kart
                ),
                itemCount: eventCards.length,
                itemBuilder: (context, index) {
                  EventCard card = eventCards[index];
                  return EventCardWidget(
                    eventCard: card,
                    onTap: () => _showEventCard(context, card),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventCard(BuildContext context, EventCard eventCard) {
    EventCardDialog.show(context, eventCard);
  }
}