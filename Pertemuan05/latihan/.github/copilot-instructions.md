# Copilot Instructions for Flutter Application

## Project Overview
This is a Flutter application project that targets multiple platforms (Android, iOS, web, Windows, Linux, macOS). The project follows standard Flutter architecture and conventions.

## Key Technologies
- Flutter SDK: ^3.9.2
- Dart
- Material Design (Material 2.0)
- Cupertino (iOS-style) components available

## Project Structure
```
lib/               # Main application code
├── main.dart      # Application entry point
test/             # Test files
├── widget_test.dart
```

## Development Workflows

### Setting Up
1. Ensure Flutter SDK ^3.9.2 is installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter doctor` to verify setup

### Building and Running
- Development: `flutter run`
- Release: `flutter build <platform>`
  - Supported platforms: android, ios, web, windows, linux, macos

### Testing
- Run tests: `flutter test`
- Widget tests are located in `test/widget_test.dart`

## Project Conventions
1. State Management: Using standard StatelessWidget/StatefulWidget pattern
2. Theme: Material Design with primary color blue
3. Code Organization:
   - Main app widget in `lib/main.dart`
   - Follow Flutter's standard widget composition pattern

## Key Integration Points
1. Platform-specific code:
   - Android: `android/` directory
   - iOS: `ios/` directory
   - Web: `web/` directory
   - Desktop: `windows/`, `linux/`, `macos/` directories

## Common Tasks
- Adding dependencies: Update `pubspec.yaml` and run `flutter pub get`
- Platform configuration changes: Check respective platform folders
- Theme changes: Modify `ThemeData` in `main.dart`

## Debugging Tips
1. Use Flutter DevTools for widget inspection and debugging
2. Hot reload (`r`) and hot restart (`R`) available in debug mode
3. Check platform-specific logs in respective IDE tools

## Important Notes
- The project is configured to not publish to pub.dev
- Material 3 is currently disabled (`useMaterial3: false`)
- Uses recommended lints from `flutter_lints` package