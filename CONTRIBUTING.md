# Contributing to Songs List App

Thank you for your interest in contributing to the Songs List App! We welcome contributions from the community and are grateful for your support.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Guidelines](#documentation-guidelines)

## 📜 Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Trolling, insulting, or derogatory comments
- Public or private harassment
- Publishing others' private information without permission
- Other conduct which could reasonably be considered inappropriate

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

**When submitting a bug report, include:**
- Clear and descriptive title
- Steps to reproduce the issue
- Expected vs actual behavior
- Screenshots or error messages
- Flutter version, OS, and device information
- Firebase configuration status

### Suggesting Enhancements

We welcome feature requests and enhancement suggestions!

**When suggesting enhancements, include:**
- Clear and descriptive title
- Detailed explanation of the proposed feature
- Why this feature would be useful
- Example use cases
- Mockups or diagrams (if applicable)

### Pull Requests

We actively welcome your pull requests!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes with clear messages
4. Push to your branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request with detailed description

## 🛠️ Development Setup

### Prerequisites

- Flutter SDK >= 3.9.2
- Dart SDK (bundled with Flutter)
- Git for version control
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)
- Firebase account and project

### Setting Up Your Development Environment

1. **Fork and clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/firebase_flutter.git
   cd firebase_flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase:**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure
   ```

4. **Verify installation:**
   ```bash
   flutter doctor
   flutter analyze
   flutter test
   ```

5. **Run the app:**
   ```bash
   flutter run -d chrome
   ```

## 💻 Coding Standards

### Dart Code Style

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

**Key conventions:**
- Use `lowerCamelCase` for variables, functions, and parameters
- Use `UpperCamelCase` for classes and enums
- Use `lowercase_with_underscores` for libraries and filenames
- Maximum line length: 80 characters
- Use trailing commas for better formatting

**Example:**
```dart
// Good
class SongModel {
  final String id;
  final String title;
  
  SongModel({required this.id, required this.title});
}

// Bad
class song_model {
  String ID;
  String Title;
}
```

### Code Comments

- Write comments in **English**
- Use tutorial-style comments that explain concepts clearly
- Comment complex logic and business rules
- Avoid obvious comments

**Example:**
```dart
// Good: Fetch songs from Firestore and update local state
// This ensures UI stays in sync with database changes
Future<void> fetchSongs() async {
  QuerySnapshot snapshot = await songs.get();
  setState(() {
    songsList = snapshot.docs.map((doc) {
      return {'id': doc.id, 'title': doc['title']};
    }).toList();
  });
}

// Bad: Get songs
Future<void> fetchSongs() async {
  // This function gets songs
  var data = await songs.get();
  setState(() {
    songsList = data.docs.map((d) => {'id': d.id, 'title': d['title']}).toList();
  });
}
```

### Code Formatting

Always format your code before committing:

```bash
# Format all Dart files
dart format .

# Format specific file
dart format lib/main.dart
```

### Linting

Run the analyzer before submitting:

```bash
flutter analyze
```

Fix all warnings and errors before creating a pull request.

## 📝 Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semi-colons, etc.)
- `refactor`: Code refactoring without adding features or fixing bugs
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependency updates, build process, etc.)
- `perf`: Performance improvements

### Examples

```bash
# Feature
feat(songs): add song editing functionality

# Bug fix
fix(firestore): handle network timeout errors gracefully

# Documentation
docs(readme): update installation instructions for Windows

# Test
test(songs): add widget tests for delete functionality

# Refactor
refactor(main): extract Firebase initialization to separate file
```

### Scope

The scope should be the name of the affected component:
- `songs`: Song-related features
- `firestore`: Firebase/Firestore operations
- `ui`: User interface components
- `tests`: Test-related changes
- `docs`: Documentation files

## 🔄 Pull Request Process

### Before Submitting

1. ✅ Run `flutter analyze` - No errors or warnings
2. ✅ Run `flutter test` - All tests pass
3. ✅ Run `dart format .` - Code is properly formatted
4. ✅ Update documentation if needed
5. ✅ Add tests for new features
6. ✅ Ensure commit messages follow conventions

### Pull Request Template

When creating a PR, include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## How Has This Been Tested?
Describe the tests you ran

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or my feature works
- [ ] New and existing unit tests pass locally
```

### Review Process

1. At least one maintainer must review your PR
2. All automated checks must pass (linting, tests)
3. Requested changes must be addressed
4. Once approved, a maintainer will merge your PR

## 🧪 Testing Guidelines

### Writing Tests

- Write tests for all new features
- Maintain or improve code coverage
- Test both success and failure scenarios
- Use descriptive test names

**Example:**
```dart
testWidgets('Adding song with empty title should not add to list', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(MaterialApp(home: SongsListScreen()));
  await tester.pumpAndSettle();
  
  // Act
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  
  // Assert
  expect(find.byType(ListTile), findsNothing);
});
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Coverage

- Aim for at least 80% code coverage
- Focus on critical paths and edge cases
- Don't sacrifice quality for coverage metrics

## 📚 Documentation Guidelines

### Code Documentation

- Document public APIs with DartDoc comments
- Include examples for complex functions
- Explain parameters, return values, and exceptions

**Example:**
```dart
/// Adds a new song to the Firestore collection.
///
/// The [title] parameter must not be empty. If the title is empty,
/// the function returns without adding the song.
///
/// After successfully adding the song, the text field is cleared
/// and the song list is refreshed.
///
/// Example:
/// ```dart
/// await addSong('Bohemian Rhapsody');
/// ```
Future<void> addSong(String title) async {
  if (title.isEmpty) return;
  await songs.add({'title': title});
  songController.clear();
  fetchSongs();
}
```

### README Updates

When adding features, update the README:
- Add to Features section if applicable
- Update screenshots if UI changed
- Add setup instructions for new dependencies
- Update code examples if APIs changed

## 🚀 Release Process

Releases are managed by maintainers. Contributors don't need to worry about versioning.

**Version numbering follows Semantic Versioning:**
- `MAJOR.MINOR.PATCH`
- MAJOR: Breaking changes
- MINOR: New features (backward-compatible)
- PATCH: Bug fixes (backward-compatible)

## ❓ Questions?

If you have questions about contributing:
- Open a [GitHub Discussion](https://github.com/mohammadfirmansyah/firebase_flutter/discussions)
- Create an issue with the `question` label
- Check existing documentation and issues first

## 🙏 Recognition

Contributors will be recognized in:
- CHANGELOG.md for each release
- GitHub Contributors page
- Special mentions for significant contributions

## 📄 License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.

---

Thank you for contributing to Songs List App! Your efforts help make this project better for everyone. 🎵
