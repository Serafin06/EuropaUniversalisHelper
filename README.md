# Europa Universalis Masters 🎮

A Flutter mobile application designed to help **Europa Universalis IV** players track their progress and manage objectives across different game eras.

## 📱 Features

- **Era Management**: Track progress across 3 different game eras
- **Half-Era Division**: Each era is divided into two halves for better organization
- **Interactive Checkboxes**: Mark completed objectives with visual feedback
- **Progress Tracking**: Real-time progress indicators and completion percentages
- **Data Persistence**: Automatic saving of all progress using local storage
- **Dark/Light Theme**: System-adaptive theming support
- **Reset Functionality**: Quick reset of all checkboxes when starting new campaigns
- **Visual Icons**: Custom geometric icons for different objective types

## 🎯 Perfect for EU Board Game Players Who Want To:

- Track campaign objectives systematically
- Manage complex achievement runs
- Monitor progress across different game phases
- Keep organized records of completed goals
- Plan and execute multi-era strategies


## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart (>=2.17.0)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/europa-universalis-masters.git
   cd europa-universalis-masters
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS required)
flutter build ios --release
```

## 📋 How to Use

1. **Select Era**: Choose from Era 1, 2, or 3 depending on your current game phase
2. **Choose Half**: Select first or second half of the era
3. **Track Objectives**: Check off completed objectives as you progress
4. **Monitor Progress**: View completion percentage and statistics
5. **Reset When Needed**: Use the reset button to clear all progress for new campaigns

## 🛠️ Technical Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **Storage**: SharedPreferences for local data persistence
- **Architecture**: StatefulWidget with organized component structure
- **Theming**: Material Design 3 with system theme support

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme/
│   └── app_theme.dart       # Theme configuration
├── models/
│   └── checkbox_state.dart  # Data models
├── services/
│   └── storage_service.dart # Local storage management
├── screens/
│   └── checkbox_eras_screen.dart # Main screen
└── widgets/
    ├── era_selection_card.dart
    ├── half_selection_card.dart
    ├── checkbox_section.dart
    ├── checkbox_item.dart
    ├── reset_button_card.dart
    └── summary_card.dart
```

## 🎨 Customization

### Adding New Objectives

Edit the `checkboxOptions` list in `checkbox_eras_screen.dart`:

```dart
List<String> checkboxOptions = [
  'plus', 
  'trojkat', 
  'kwadrat', 
  'kolo',
  'your_new_objective' // Add here
];
```

### Custom Icons

Place your custom icons in `assets/icons/` directory:
```
assets/
└── icons/
    ├── plus.jpg
    ├── trojkat.jpg
    ├── kwadrat.jpg
    └── kolo.jpg
```

### Modifying Eras

To change the number of eras, update the era loops in:
- `CheckboxState._initializeStates()`
- `StorageService` methods
- UI components

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Areas for Contribution

- [ ] Add more customizable objective types
- [ ] Implement data export/import functionality
- [ ] Create achievement integration
- [ ] Add campaign templates
- [ ] Improve UI/UX design
- [ ] Add unit tests
- [ ] Internationalization support

## 🐛 Bug Reports

Found a bug? Please create an issue with:

- Device information (Android/iOS version)
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Paradox Interactive** for creating Europa Universalis IV
- **Flutter Team** for the amazing framework
- **EU4 Community** for inspiration and feedback
- All contributors who help improve this tool

## 📞 Contact

- **GitHub**: [@Serafin06](https://github.com/Serafin06)
- **Issues**: [GitHub Issues](https://github.com/yourusername/europa-universalis-masters/issues)

---

**Happy conquering, and may your campaigns be successful!** 🏰⚔️

> *"The Empire must expand to survive."* - Europa Universalis IV
