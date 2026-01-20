# Chat App (Flutter) — README

## Overview
This project is a cross-platform chat application implemented with Flutter/Dart. It uses Hive for local persistence (chat rooms, messages, users and current user), and contains native code support (Kotlin/Java, C++) and Gradle for Android builds. The Hive persistence is managed in `lib/src/services/hive_service.dart` which registers Hive adapters and opens boxes named: `chat_rooms`, `messages`, `users`, `current_user`.

## Key features
- Local storage of chat rooms, messages and users using Hive.
- Type adapters for `ChatRoom`, `Message`, and `User` (registered in `HiveService`).
- Basic CRUD operations for users, chat rooms and messages.
- Cross-platform Flutter UI / business logic.

## Project structure (high level)
- `lib/` — Flutter app code (Dart).
  - `lib/src/services/hive_service.dart` — Hive initialization and helpers.
  - `lib/src/features/` — feature folders: `auth`, `chat`, `chat_room`, etc.
- `android/` — Android native code (Kotlin/Java, Gradle).
- `ios/` — iOS native code (Objective-C/Swift, Xcode).
- `cpp/` or `native/` (if present) — C++ native modules.
- `pubspec.yaml` — Dart & Flutter dependencies.

## Prerequisites (development)
- macOS (you indicated development on macOS).
- Flutter SDK (stable channel). Install from https://flutter.dev
- Dart SDK (bundled with Flutter).
- Android Studio Otter 2 Feature Drop | 2025.2.2 (or newer) — recommended for editing, running and debugging Android.
- Android SDK & command-line tools (via Android Studio SDK Manager).
- Java JDK (required by Android toolchain).
- Xcode (if building for iOS).
- Optional: C++ toolchain if native modules used.
- `pub` (part of Dart/Flutter tooling).
- If Hive adapters are generated: `build_runner` and `hive_generator` in `dev_dependencies`.

## Setup and run (development)
1. Clone the repo
   - `git clone <repo-url>`
   - `cd <repo-folder>`

2. Install Dart/Flutter packages
   - `flutter pub get`

3. Generate Hive type adapters (if adapters are generated via annotations)
   - `flutter pub run build_runner build --delete-conflicting-outputs`
   - Note: Project already calls `Hive.registerAdapter(ChatRoomAdapter())`, etc. Ensure generated adapter files exist (`*.g.dart` or similar). If adapters were hand-written, this step can be skipped.

4. Initialize Hive before `runApp`
   - Ensure `HiveService.initHive()` is called in `main()` and awaited.
   - Example snippet (place in `lib/main.dart`):
     ```dart
     import 'package:flutter/material.dart';
     import 'src/services/hive_service.dart';

     Future<void> main() async {
       WidgetsFlutterBinding.ensureInitialized();
       await HiveService.initHive();
       runApp(const MyApp());
     }
     ```

5. Run the app
   - For Android: `flutter run -d <device-id>`
   - For iOS: `flutter run -d <device-id>` (requires Xcode & code signing)
   - For an APK: `flutter build apk`
   - For an iOS IPA: `flutter build ios` (see Xcode signing)

## Hive boxes & data
`lib/src/services/hive_service.dart` uses these boxes:
- `chat_rooms` — stores `ChatRoom` models
- `messages` — stores `Message` models
- `users` — stores `User` models
- `current_user` — stores the current logged-in user (keyed by `'user'`)

Adapters registered in `initHive()`:
- `ChatRoomAdapter()`
- `MessageAdapter()`
- `UserAdapter()`

Make sure the adapter classes are available at runtime (generated or implemented manually).

## Common commands
- Fetch deps: `flutter pub get`
- Build runner: `flutter pub run build_runner build --delete-conflicting-outputs`
- Run app: `flutter run`
- Build apk: `flutter build apk`
- Clean: `flutter clean`

## Troubleshooting
- Missing TypeAdapter errors: run build_runner to generate adapters or add/register the concrete adapter implementations.
- Hive initialization errors: ensure `await HiveService.initHive()` runs before any Hive box access.
- If data appears stale: uninstall app or delete Hive boxes with `await Hive.box('boxName').deleteFromDisk()` or use `Hive.deleteBoxFromDisk('boxName')`.
- Android SDK / Gradle issues: ensure Android Studio and SDK paths are configured and `JAVA_HOME` is set.

## Testing
- Run Flutter tests: `flutter test`
- Unit tests for Dart models or services should mock Hive boxes or use a test-specific Hive init.

## Security & notes
- Hive stores data locally and is not encrypted by default. Consider `hive_flutter` encrypted boxes or platform secure storage for sensitive data.
- Review adapter versions and compatibility when upgrading `hive` packages.

## License
Refer to the repository license file (if present).

Files referenced:
- `lib/src/services/hive_service.dart`
- `pubspec.yaml`
- `lib/main.dart` (ensure Hive init placed here)
