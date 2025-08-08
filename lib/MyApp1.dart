import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp to główny widget, który konfiguruje wygląd całej aplikacji
    return MaterialApp(
      title: 'Europa Universalis Masters',
      // Tytuł aplikacji (widoczny na pasku zadań)
      theme: ThemeData(
        primarySwatch: Colors.blue, // Główny kolor aplikacji
        useMaterial3: true,
        brightness: Brightness.light, // Używa najnowszej wersji Material Design
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
        // Ciemny motyw
        scaffoldBackgroundColor: Colors.black,
        // Czarne tło jak w systemie
        cardColor: Colors.grey[900],
        // Ciemne karty
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      home: CheckboxErasScreen(),
      // Ustawia ekran startowy
      debugShowCheckedModeBanner: false,
    );
  }
}

// CheckboxErasScreen to główny ekran aplikacji - rozszerza StatefulWidget
// StatefulWidget to widget ze stanem (może się zmieniać w trakcie działania)
class CheckboxErasScreen extends StatefulWidget {
  @override
  _CheckboxErasScreenState createState() => _CheckboxErasScreenState();
}

// Klasa State przechowuje i zarządza stanem widgetu
class _CheckboxErasScreenState extends State<CheckboxErasScreen> {
  // === ZMIENNE STANU APLIKACJI ===

  int currentEra = 1; // Aktualna era (1, 2 lub 3)
  int currentHalf = 1; // Aktualna połówka (1 lub 2)

  // Lista nazw er - indeks 0 = Era 1, indeks 1 = Era 2, itd.
  List<String> eraNames = ['Era 1', 'Era 2', 'Era 3'];

  // Lista opcji checkboxów - możesz dodać lub usunąć opcje
  List<String> checkboxOptions = ['plus', 'trojkat', 'kwadrat', 'kolo'];

  // Zagnieżdżona mapa przechowująca stan checkboxów:
  // Struktura: eraCheckboxStates[era][połówka][opcja] = true/false
  // Przykład: eraCheckboxStates[1][2]['Technologia'] = true
  Map<int, Map<int, Map<String, bool>>> eraCheckboxStates = {};

  // === METODY CYKLU ŻYCIA WIDGETU ===

  @override
  void initState() {
    // initState() wywoływane jest raz, gdy widget zostaje utworzony
    super.initState();
    print('Startujemy z Mastersami');
    _initializeCheckboxStates(); // Inicjalizacja pustych stanów
    _loadData(); // Ładowanie zapisanych danych
  }

  // === METODY INICJALIZACJI I ZARZĄDZANIA DANYMI ===

  // Inicjalizacja stanów checkboxów dla wszystkich er i połówek
  void _initializeCheckboxStates() {
    // Pętla przez wszystkie ery (1, 2, 3)
    for (int era = 1; era <= 3; era++) {
      eraCheckboxStates[era] = {}; // Tworzenie mapy dla ery

      // Pętla przez połówki (1, 2) dla każdej ery
      for (int half = 1; half <= 2; half++) {
        eraCheckboxStates[era]![half] = {}; // Tworzenie mapy dla połówki

        // Pętla przez wszystkie opcje checkboxów
        for (String option in checkboxOptions) {
          // Ustawianie domyślnej wartości false dla każdego checkboxa
          eraCheckboxStates[era]![half]![option] = false;
        }
      }
    }
  }

  // Asynchroniczne ładowanie danych z lokalnej pamięci telefonu
  Future<void> _loadData() async {
    // SharedPreferences to sposób na zapisywanie prostych danych lokalnie
    final prefs = await SharedPreferences.getInstance();

    // Ładowanie ostatnio wybranej ery i połówki
    // getInt zwraca zapisaną wartość lub domyślną (1), jeśli nic nie zapisano
    int savedEra = prefs.getInt('currentEra') ?? 1;
    int savedHalf = prefs.getInt('currentHalf') ?? 1;

    // setState() informuje Flutter, że stan się zmienił i trzeba odświeżyć UI
    setState(() {
      currentEra = savedEra;
      currentHalf = savedHalf;
    });

    // Ładowanie stanów checkboxów dla każdej kombinacji era-połówka
    for (int era = 1; era <= 3; era++) {
      for (int half = 1; half <= 2; half++) {
        // Klucz do identyfikacji danych w SharedPreferences
        String key = 'era_${era}_half_$half';
        String? savedState = prefs.getString(key);

        // Jeśli znaleziono zapisane dane
        if (savedState != null) {
          // json.decode konwertuje tekst JSON na mapę Dart
          Map<String, dynamic> decodedState = json.decode(savedState);

          setState(() {
            // Konwersja dynamic na bool i zapisanie do naszej mapy
            eraCheckboxStates[era]![half] = decodedState.map(
              (key, value) => MapEntry(key, value as bool),
            );
          });
        }
      }
    }
  }

  // Asynchroniczne zapisywanie danych do lokalnej pamięci
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Zapisywanie aktualnej ery i połówki
    await prefs.setInt('currentEra', currentEra);
    await prefs.setInt('currentHalf', currentHalf);

    // Zapisywanie stanów checkboxów dla każdej kombinacji
    for (int era = 1; era <= 3; era++) {
      for (int half = 1; half <= 2; half++) {
        String key = 'era_${era}_half_$half';
        // json.encode konwertuje mapę Dart na tekst JSON
        String encodedState = json.encode(eraCheckboxStates[era]![half]);
        await prefs.setString(key, encodedState);
      }
    }
  }

  // === METODY OBSŁUGI AKCJI UŻYTKOWNIKA ===

  // Reset wszystkich checkboxów do stanu false
  void _resetAllCheckboxes() {
    print('Reset wszystkich checkboxów'); // Debug log

    setState(() {
      // Pętla przez wszystkie ery i połówki
      for (int era = 1; era <= 3; era++) {
        for (int half = 1; half <= 2; half++) {
          for (String option in checkboxOptions) {
            eraCheckboxStates[era]![half]![option] = false;
          }
        }
      }
    });

    // Pokazanie komunikatu potwierdzenia
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Wszystkie checkboxy zostały zresetowane'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Zmiana stanu konkretnego checkboxa
  void _toggleCheckbox(String option) {
    setState(() {
      // Pobranie aktualnego stanu i odwrócenie go
      bool currentState = eraCheckboxStates[currentEra]![currentHalf]![option]!;
      eraCheckboxStates[currentEra]![currentHalf]![option] = !currentState;
    });
    _saveData(); // Automatyczne zapisywanie po każdej zmianie
  }

  // Zmiana ery (wywołana przy kliknięciu przycisku Era 1, 2 lub 3)
  void _changeEra(int newEra) {
    setState(() {
      currentEra = newEra;
      // Przy zmianie ery wracamy do pierwszej połówki
      currentHalf = 1;
    });
    _saveData();
  }

  // Zmiana połówki (wywołana przy kliknięciu I połówka / II połówka)
  void _changeHalf(int newHalf) {
    setState(() {
      currentHalf = newHalf;
    });
    _saveData();
  }

  // Obliczanie ile checkboxów jest zaznaczonych w aktualnej era-połówka
  int _getCheckedCount() {
    return eraCheckboxStates[currentEra]![currentHalf]!.values
        .where((isChecked) => isChecked) // Filtrowanie tylko zaznaczonych
        .length; // Liczenie
  }

  // === BUDOWANIE INTERFEJSU UŻYTKOWNIKA ===

  @override
  Widget build(BuildContext context) {
    // Scaffold to podstawowa struktura ekranu (AppBar + Body + inne elementy)
    return Scaffold(
      appBar: AppBar(
        title: Text('Europa Universalis Masters'),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.inversePrimary, // Użycie głównego koloru aplikacji
        centerTitle: true, // Wyśrodkowanie tytułu
      ),

      // Główna zawartość ekranu
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Margines wokół całej zawartości
        child: Column(
          children: [
            // === SEKCJA WYBORU ERY ===
            _buildEraSelectionCard(),

            const SizedBox(height: 8), // Odstęp między sekcjami
            // === SEKCJA WYBORU POŁÓWKI ===
            _buildHalfSelectionCard(),

            const SizedBox(height: 8),

            // === SEKCJA Z CHECKBOXAMI ===
            _buildCheckboxSection(),

            const SizedBox(height: 8),

            _buildResetButton(),

            const SizedBox(height: 8),

            // === SEKCJA PODSUMOWANIA ===
            _buildSummaryCard(),
          ],
        ),
      ),
    );
  }

  // Metoda budująca kartę z wyborem ery
  Widget _buildEraSelectionCard() {
    return Card(
      elevation: 4, // Cień karty
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

            // Row układa elementy poziomo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Równe odstępy
              children: [
                // Pętla tworząca przyciski dla er 1, 2, 3
                for (int era = 1; era <= 3; era++) _buildEraButton(era),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Metoda budująca pojedynczy przycisk ery
  Widget _buildEraButton(int era) {
    // Sprawdzenie czy ten przycisk reprezentuje aktualnie wybraną erę
    bool isSelected = currentEra == era;

    return ElevatedButton(
      onPressed: () => _changeEra(era), // Funkcja wywoływana przy kliknięciu
      style: ElevatedButton.styleFrom(
        // Różne kolory dla wybranego i niewybranego przycisku
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

  // Metoda budująca kartę z wyborem połówki
  Widget _buildHalfSelectionCard() {
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
                _buildHalfButton(1, 'I Połówka'),
                _buildHalfButton(2, 'II Połówka'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Metoda budująca pojedynczy przycisk połówki
  Widget _buildHalfButton(int half, String label) {
    bool isSelected = currentHalf == half;

    return ElevatedButton.icon(
      onPressed: () => _changeHalf(half),

      // Icon dodaje ikonkę do przycisku
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  // Metoda budująca sekcję z checkboxami
  Widget _buildCheckboxSection() {
    return Expanded(
      // Expanded sprawia, że widget zajmuje całą dostępną przestrzeń
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Wyrównanie do lewej
            children: [
              Text(
                'Opcje dla ${eraNames[currentEra - 1]} - ${currentHalf == 1 ? "I" : "II"} Połówka:',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // ListView.builder tworzy przewijalną listę
              Expanded(
                child: ListView.builder(
                  itemCount: checkboxOptions.length, // Liczba elementów
                  itemBuilder: (context, index) {
                    // Funkcja wywoływana dla każdego elementu listy
                    String option = checkboxOptions[index];
                    bool isChecked =
                        eraCheckboxStates[currentEra]![currentHalf]![option] ??
                        false;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: isChecked
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : null,
                      ),
                      child: CheckboxListTile(
                        // Zamieniam tekst na ikonę systemową
                        title: Row(
                          children: [
                            Icon(
                              isChecked
                                  ? _getFilledGeometricIcon(
                                      option,
                                    ) // Wypełniona gdy zaznaczona
                                  : _getDefaultGeometricIcon(option),
                              // Kontury gdy niezaznaczona
                              color: isChecked
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).iconTheme.color,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                // Przekreślenie dla zaznaczonych opcji
                                decoration: isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                        value: isChecked,
                        onChanged: (bool? value) {
                          _toggleCheckbox(option);
                        },
                        activeColor: Theme.of(context).primaryColor,
                        checkColor: Colors.white,
                        secondary: _getIconForOption(option, isChecked),
                      ),
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

  // Metoda zwracająca ikonkę dla konkretnej opcji
  Widget _getIconForOption(String option, bool isChecked) {
    // Ścieżka do obrazka .jpg (nazwę konwertujemy na małe litery)
    String imagePath = 'assets/icons/${option.toLowerCase()}.jpg';

    // Włącz to gdy dodasz swoje obrazki .jpg - jak nie ma obrazkow wylaczamy ifa
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
            // Obrazek wypełnia kontener
            errorBuilder: (context, error, stackTrace) {
              // Jeśli obrazek nie istnieje, użyj domyślnej ikony
              print('Nie można załadować: $imagePath');
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
            // Przyciemniaj gdy niezaznaczone
            colorBlendMode: isChecked ? null : BlendMode.multiply,
          ),
        ),
      );
    } else {
      // Używanie ikon geometrycznych (domyślnie)
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

  // Pomocna metoda zwracająca ikony geometryczne - więcej opcji
  IconData _getDefaultGeometricIcon(String option) {
    switch (option) {
      case 'trojkat':
        return Icons.change_history_outlined; // Kontury trójkąta
      case 'kwadrat':
        return Icons.crop_square_sharp; // Ostry kwadrat
      case 'kolo':
        return Icons.radio_button_unchecked; // Koło z konturem
      case 'plus':
        return Icons.add_circle_outline; // Plus w kółku
      default:
        return Icons.help_outline; // Znak zapytania dla nieznanych
    }
  }

  // Dodatkowe ikony dla lepszego wyglądu gdy zaznaczone
  IconData _getFilledGeometricIcon(String option) {
    switch (option) {
      case 'trojkat':
        return Icons.change_history; // Wypełniony trójkąt
      case 'kwadrat':
        return Icons.square; // Wypełniony kwadrat
      case 'kolo':
        return Icons.circle; // Wypełnione koło
      case 'plus':
        return Icons.add_circle; // Wypełniony plus
      default:
        return Icons.help; // Wypełniony znak zapytania
    }
  }

  // Metoda budująca przycisk reset
  Widget _buildResetButton() {
    // Oblicz ile w sumie jest zaznaczonych checkboxów
    int totalChecked = 0;
    for (int era = 1; era <= 3; era++) {
      for (int half = 1; half <= 2; half++) {
        totalChecked += eraCheckboxStates[era]![half]!.values
            .where((isChecked) => isChecked)
            .length;
      }
    }

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
                  SizedBox(height: 4),
                  Text(
                    totalChecked > 0
                        ? 'Zaznaczonych: $totalChecked checkboxów'
                        : 'Brak zaznaczonych checkboxów',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: totalChecked > 0 ? _resetAllCheckboxes : null,
              icon: Icon(Icons.refresh),
              label: Text('Reset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: totalChecked > 0 ? Colors.red : Colors.grey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Metoda budująca kartę podsumowania
  Widget _buildSummaryCard() {
    int checkedCount = _getCheckedCount();
    double percentage = (checkedCount / checkboxOptions.length) * 100;

    return Card(
      elevation: 4,
      color: Colors.blue[50], // Lekko niebieskie tło
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Postęp:', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '${percentage.toStringAsFixed(0)}% ukończone',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),

            // Cip pokazujący liczbę zaznaczonych opcji
            Chip(
              label: Text(
                '$checkedCount / ${checkboxOptions.length}',
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
