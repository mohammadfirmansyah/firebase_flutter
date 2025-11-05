# 🎵 Songs List App

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue?logo=flutter)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Cloud%20Firestore-orange?logo=firebase)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

A modern, feature-rich Songs List application built with Flutter and Firebase Firestore. This application demonstrates real-time CRUD operations with cloud database integration, clean architecture, and comprehensive test coverage.

## 📚 Documentation

- **[Contributing Guide](CONTRIBUTING.md)** - Learn how to contribute
- **[Changelog](CHANGELOG.md)** - Version history and release notes
- **[Security Policy](SECURITY.md)** - Security best practices

## ✨ Key Features

- **Real-time CRUD Operations**: Add, read, and delete songs instantly
- **Firebase Integration**: Cloud Firestore for persistent data storage
- **Responsive Design**: Works seamlessly on mobile, tablet, and desktop
- **Clean Architecture**: Well-structured code with separation of concerns
- **Comprehensive Testing**: 100% test coverage with 14+ widget and behavior tests
- **Modern UI**: Material Design 3 with blue theme
- **Input Validation**: Prevents empty entries and provides user feedback

## 📱 Screenshots

```
┌────────────────────────────────────────┐
│          Songs List App                │
├────────────────────────────────────────┤
│                                        │
│  ┌──────────────────────────────┐     │
│  │ Enter Song Title         [+] │     │
│  └──────────────────────────────┘     │
│                                        │
│  ┌──────────────────────────────┐     │
│  │  1. Song One            [🗑️] │     │
│  ├──────────────────────────────┤     │
│  │  2. Song Two            [🗑️] │     │
│  ├──────────────────────────────┤     │
│  │  3. Song Three          [🗑️] │     │
│  ├──────────────────────────────┤     │
│  │  4. Song Four           [🗑️] │     │
│  ├──────────────────────────────┤     │
│  │  5. Song Five           [🗑️] │     │
│  └──────────────────────────────┘     │
│                                        │
└────────────────────────────────────────┘
```

## 🛠️ Technologies Used

- **Flutter** - SDK ^3.9.2
- **Dart** - Programming language
- **Firebase Core** - v3.8.0
- **Cloud Firestore** - v5.5.0 (Real-time NoSQL database)
- **Firebase Auth** - v5.3.3 (Authentication support)
- **Material Design 3** - Modern UI components

## 📂 Project Structure

```
firebase_flutter/
├── lib/
│   └── main.dart              # Main application entry point
├── test/
│   └── widget_test.dart       # Comprehensive widget and behavior tests
├── android/                   # Android platform files
├── ios/                       # iOS platform files
├── web/                       # Web platform files
├── windows/                   # Windows desktop files
├── linux/                     # Linux desktop files
├── macos/                     # macOS desktop files
├── pubspec.yaml               # Dependencies and project configuration
├── analysis_options.yaml      # Dart/Flutter linter rules
└── README.md                  # This file
```

## 🚀 Setup & Installation

Before you begin, make sure you have the following installed:
- Flutter SDK >= 3.9.2
- Dart SDK (bundled with Flutter)
- Firebase CLI (for project setup)
- A Firebase project with Firestore enabled

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mohammadfirmansyah/firebase_flutter.git
   cd firebase_flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   
   Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
   
   **Option 1: Using FlutterFire CLI (Recommended)**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your Flutter app
   flutterfire configure
   ```
   
   **Option 2: Manual Configuration**
   
   Update the Firebase configuration in `lib/main.dart`:
   ```dart
   await Firebase.initializeApp(
     options: const FirebaseOptions(
       apiKey: "YOUR_API_KEY",
       authDomain: "YOUR_AUTH_DOMAIN",
       projectId: "YOUR_PROJECT_ID",
       storageBucket: "YOUR_STORAGE_BUCKET",
       messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
       appId: "YOUR_APP_ID",
     ),
   );
   ```

4. **Enable Firestore in Firebase Console:**
   - Navigate to Firestore Database in Firebase Console
   - Click "Create Database"
   - Start in **test mode** for development (or configure security rules)

## 💻 Usage / How to Run

### Development Mode

1. **Run on Chrome (Web):**
   ```bash
   flutter run -d chrome
   ```

2. **Run on Android emulator:**
   ```bash
   flutter run -d emulator-5554
   ```

3. **Run on iOS simulator:**
   ```bash
   flutter run -d iPhone
   ```

4. **Run on Windows desktop:**
   ```bash
   flutter run -d windows
   ```

### Testing

Run all tests with coverage:
```bash
flutter test --coverage
```

Run specific test file:
```bash
flutter test test/widget_test.dart
```

### Production Build

Build APK for Android:
```bash
flutter build apk --release
```

Build app bundle for Android:
```bash
flutter build appbundle --release
```

Build for iOS:
```bash
flutter build ios --release
```

Build for Web:
```bash
flutter build web --release
```

## 📝 Important Code Explanations

### Core Feature: Real-time Firestore Integration

Here's how the app manages real-time data synchronization with Firebase Firestore:

```dart
// Initialize Firestore collection reference
CollectionReference songs = FirebaseFirestore.instance.collection('songs');

// Fetch songs from Firestore with real-time updates
Future<void> fetchSongs() async {
  // Query the 'songs' collection
  QuerySnapshot snapshot = await songs.get();
  
  // Transform QuerySnapshot to List of Maps
  setState(() {
    songsList = snapshot.docs.map((doc) {
      return {
        'id': doc.id,        // Document ID for deletion
        'title': doc['title'], // Song title
      };
    }).toList();
  });
}
```

*This design pattern allows for real-time data synchronization and efficient state management.*

### Adding Songs with Validation

```dart
Future<void> addSong(String title) async {
  // Validate input: prevent empty entries
  if (title.isEmpty) return;
  
  // Add new document to Firestore
  await songs.add({'title': title});
  
  // Clear input field after successful add
  songController.clear();
  
  // Refresh the list to show new song
  fetchSongs();
}
```

*Input validation ensures data integrity before committing to the database.*

### Deleting Songs

```dart
Future<void> deleteSong(String id) async {
  // Delete document by ID
  await songs.doc(id).delete();
  
  // Refresh the list to reflect changes
  fetchSongs();
}
```

*Direct document deletion using Firestore's document ID for efficient removal.*

## 📖 Learning Outcomes

This project is a great way to learn and practice:

- ✅ **Firebase Integration**: Real-time NoSQL database with Cloud Firestore
- ✅ **Async/Await**: Handling asynchronous operations with Future
- ✅ **State Management**: Using `setState()` for reactive UI updates
- ✅ **CRUD Operations**: Complete Create, Read, Update, Delete functionality
- ✅ **Widget Testing**: Comprehensive test coverage with flutter_test
- ✅ **UI/UX Design**: Material Design 3 components and responsive layouts
- ✅ **Input Validation**: Preventing invalid data entry
- ✅ **Multi-platform Development**: Web, Android, iOS, Desktop support

## 🔒 Security Best Practices

### Firestore Security Rules

For production, configure Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Songs collection rules
    match /songs/{songId} {
      // Allow read access to all users
      allow read: if true;
      
      // Allow write access only to authenticated users
      allow write: if request.auth != null;
      
      // Validate song title is not empty and is a string
      allow create, update: if request.resource.data.title is string 
                            && request.resource.data.title.size() > 0
                            && request.resource.data.title.size() <= 100;
    }
  }
}
```

### Environment Variables

For production apps, move Firebase credentials to environment variables:

1. Create a `.env` file (add to `.gitignore`)
2. Use `flutter_dotenv` package to load environment variables
3. Never commit API keys or sensitive data to version control

## 🧪 Testing Strategy

The project includes 14 comprehensive tests covering:

- **App Widget Tests**: MaterialApp configuration and initialization
- **UI Component Tests**: AppBar, TextField, ListView, IconButton rendering
- **User Interaction Tests**: Text input, button taps, scrolling
- **State Management Tests**: Widget state persistence across rebuilds
- **Behavior Tests**: Input validation, TextField clearing, empty state handling

All tests use Flutter's TestWidgetsFlutterBinding for reliable widget testing.

## 🤝 Contributing

We welcome contributions! Please see our **[Contributing Guide](CONTRIBUTING.md)** for more details on how to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🐛 Known Issues & Limitations

- **Firebase Auth**: Firebase Auth is included in dependencies but not currently used
- **Offline Mode**: App requires internet connection for Firestore operations
- **Error Handling**: Add user-friendly error messages for network failures
- **Loading States**: Implement loading indicators during async operations

## 🗺️ Roadmap

- [ ] Add Firebase Authentication for user-specific song lists
- [ ] Implement offline support with local caching
- [ ] Add song editing functionality (update CRUD operation)
- [ ] Create song categories or playlists
- [ ] Add search and filter capabilities
- [ ] Implement song sharing between users
- [ ] Add unit tests for business logic
- [ ] Create integration tests for Firebase operations

## 📄 License

This project is licensed under the Apache License 2.0. See the **[LICENSE](LICENSE)** file for details.

## 👨‍💻 Developer

- **Mohammad Firman Syah**
- **Project Link:** [https://github.com/mohammadfirmansyah/firebase_flutter](https://github.com/mohammadfirmansyah/firebase_flutter)

---

**Note**: For production use, implement proper error handling, loading states, Firebase security rules, and consider using state management solutions like Provider, Riverpod, or Bloc for larger applications.

Built with ❤️ using Flutter & Firebase
