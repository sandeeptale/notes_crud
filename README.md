# Flutter Notes App

A simple notes app with Firebase sync built with Flutter following Clean Architecture principles.

## Features

- Create, edit, delete notes
- Pin/unpin notes
- Firebase Authentication (Email/Password)
- Firestore for storing notes per user
- Realtime updates

## Architecture

This app follows Clean Architecture principles with three main layers:

1. **Presentation Layer**
    - UI components (screens, widgets)
    - Providers for state management

2. **Domain Layer**
    - Entities (Note, User)
    - Repository interfaces
    - Use cases

3. **Data Layer**
    - Repository implementations
    - Data sources (Firebase)

## Setup Instructions

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase account

### Installation

1. Clone the repository:
   \`\`\`
   git clone https://github.com/yourusername/flutter_notes_app.git
   cd flutter_notes_app
   \`\`\`

2. Install dependencies:
   \`\`\`
   flutter pub get
   \`\`\`

3. Generate the required code:
   \`\`\`
   flutter pub run build_runner build --delete-conflicting-outputs
   \`\`\`

### Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)

2. Add a new Android app:
    - Package name: `com.example.flutter_notes_app` (or your package name)
    - Download the `google-services.json` file and place it in the `android/app` directory

3. Add a new iOS app:
    - Bundle ID: `com.example.flutterNotesApp` (or your bundle ID)
    - Download the `GoogleService-Info.plist` file and place it in the `ios/Runner` directory

4. Enable Authentication:
    - Go to Authentication > Sign-in method
    - Enable Email/Password authentication

5. Create Firestore Database:
    - Go to Firestore Database
    - Create a database (start in test mode for development)

6. Set up security rules for Firestore:
   \`\`\`
   rules_version = '2';
   service cloud.firestore {
   match /databases/{database}/documents {
   match /users/{userId}/{document=**} {
   allow read, write: if request.auth != null && request.auth.uid == userId;
   }
   }
   }
   \`\`\`

## Running the App

\`\`\`
flutter run
\`\`\`

## Project Structure

\`\`\`
lib/
├── core/
│   └── constants.dart
├── data/
│   ├── datasources/
│   │   ├── firebase_auth_datasource.dart
│   │   └── firebase_notes_datasource.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       └── notes_repository_impl.dart
├── di/
│   └── service_locator.dart
├── domain/
│   ├── entities/
│   │   ├── note.dart
│   │   └── user.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   └── notes_repository.dart
│   └── usecases/
│       ├── auth_usecases.dart
│       └── notes_usecases.dart
├── presentation/
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   └── notes_provider.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── notes/
│   │   │   ├── note_detail_screen.dart
│   │   │   └── notes_screen.dart
│   │   └── splash_screen.dart
│   └── widgets/
│       └── note_card.dart
└── main.dart
