# Security Policy

## 🔒 Security Overview

The Songs List App uses Firebase services for data storage and authentication. Security is a critical aspect of any cloud-connected application. This document outlines our security practices, how to report vulnerabilities, and best practices for deploying the app.

## 📋 Supported Versions

We release security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## 🚨 Reporting a Vulnerability

### How to Report

If you discover a security vulnerability, please **DO NOT** open a public issue. Instead, report it privately:

1. **Email:** Send details to the project maintainer
2. **GitHub Security Advisory:** Use GitHub's private vulnerability reporting feature
3. **Include:**
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if available)

### Response Timeline

- **Initial Response:** Within 48 hours
- **Status Update:** Within 7 days
- **Fix Deployment:** Varies by severity
  - Critical: Within 24-48 hours
  - High: Within 7 days
  - Medium: Within 14 days
  - Low: Next scheduled release

### What to Expect

- Acknowledgment of your report
- Regular updates on our progress
- Credit in the security advisory (if desired)
- Notification when the issue is resolved

## 🛡️ Security Best Practices

### 1. Firebase Security Rules

The current app uses test mode Firebase rules, which are **NOT secure for production**. Implement proper security rules before deploying:

#### Recommended Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Songs collection rules
    match /songs/{songId} {
      // Allow anyone to read songs
      allow read: if true;
      
      // Only authenticated users can write
      allow write: if request.auth != null;
      
      // Validate data structure
      allow create, update: if request.resource.data.keys().hasAll(['title'])
                            && request.resource.data.title is string
                            && request.resource.data.title.size() > 0
                            && request.resource.data.title.size() <= 100;
      
      // Only owner can delete (if you add user ownership)
      allow delete: if request.auth != null 
                    && resource.data.userId == request.auth.uid;
    }
  }
}
```

#### User-Specific Song Lists (Future Implementation)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User-specific songs
    match /users/{userId}/songs/{songId} {
      // Users can only read their own songs
      allow read: if request.auth != null 
                  && request.auth.uid == userId;
      
      // Users can only write to their own songs
      allow write: if request.auth != null 
                   && request.auth.uid == userId;
      
      // Validate song data
      allow create, update: if request.resource.data.title is string
                            && request.resource.data.title.size() > 0
                            && request.resource.data.title.size() <= 100;
    }
  }
}
```

### 2. API Key Security

#### Current Issue

The app currently has Firebase credentials hardcoded in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "AIza...",  // ⚠️ EXPOSED
    // ...
  ),
);
```

#### Recommended Solution

**Option 1: FlutterFire CLI (Best Practice)**

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Auto-generate secure configuration
flutterfire configure

# This creates firebase_options.dart with proper platform-specific configs
```

Then use in your app:
```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

**Option 2: Environment Variables**

1. Add `flutter_dotenv` to `pubspec.yaml`
2. Create `.env` file (add to `.gitignore`)
3. Load environment variables:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

await dotenv.load(fileName: ".env");

await Firebase.initializeApp(
  options: FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    // ...
  ),
);
```

### 3. Authentication Best Practices

When implementing Firebase Authentication:

#### Email/Password Authentication

```dart
// ✅ Good: Validate input before authentication
Future<UserCredential> signInUser(String email, String password) async {
  // Validate email format
  if (!email.contains('@')) {
    throw FirebaseAuthException(
      code: 'invalid-email',
      message: 'Email address is not valid',
    );
  }
  
  // Validate password length
  if (password.length < 6) {
    throw FirebaseAuthException(
      code: 'weak-password',
      message: 'Password must be at least 6 characters',
    );
  }
  
  return await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}
```

#### Secure Password Storage

- ❌ **NEVER** store passwords in SharedPreferences or local storage
- ✅ Use Firebase Auth tokens (automatically managed)
- ✅ Implement biometric authentication for sensitive operations

### 4. Data Validation

Always validate user input before sending to Firebase:

```dart
// ✅ Good: Input validation
Future<void> addSong(String title) async {
  // Check for empty title
  if (title.trim().isEmpty) {
    throw ArgumentError('Song title cannot be empty');
  }
  
  // Check for maximum length
  if (title.length > 100) {
    throw ArgumentError('Song title too long (max 100 characters)');
  }
  
  // Sanitize input (remove potentially harmful characters)
  final sanitizedTitle = title.trim().replaceAll(RegExp(r'[<>]'), '');
  
  await songs.add({'title': sanitizedTitle});
}
```

### 5. Network Security

#### HTTPS Only

Firebase automatically uses HTTPS, but ensure your app:
- Only makes secure connections
- Validates SSL certificates
- Doesn't bypass certificate validation

#### Network Security Config (Android)

Add to `android/app/src/main/res/xml/network_security_config.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <!-- Block all cleartext (HTTP) traffic -->
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
```

Reference in `AndroidManifest.xml`:
```xml
<application
    android:networkSecurityConfig="@xml/network_security_config">
```

### 6. Dependency Security

#### Keep Dependencies Updated

```bash
# Check for outdated packages
flutter pub outdated

# Update dependencies
flutter pub upgrade
```

#### Security Audits

- Regularly review `pubspec.yaml` dependencies
- Remove unused dependencies
- Check for known vulnerabilities in packages
- Use `pub.dev` package scores and verified publishers

### 7. Error Handling

Never expose sensitive information in error messages:

```dart
// ❌ Bad: Exposes internal details
catch (e) {
  print('Firebase error: ${e.toString()}');
  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text('Error'),
    content: Text('Database error: ${e.toString()}'), // ⚠️ Too much info
  ));
}

// ✅ Good: User-friendly error messages
catch (e) {
  // Log detailed error for debugging (remove in production)
  debugPrint('Firestore error: $e');
  
  // Show generic error to user
  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text('Error'),
    content: Text('Failed to load songs. Please check your internet connection.'),
  ));
}
```

### 8. Code Obfuscation

For production builds, enable code obfuscation:

```bash
# Android
flutter build apk --release --obfuscate --split-debug-info=/<project-directory>/symbols

# iOS
flutter build ios --release --obfuscate --split-debug-info=/<project-directory>/symbols
```

### 9. User Data Privacy

#### Minimal Data Collection

- Only collect data necessary for app functionality
- Don't store sensitive user information unnecessarily
- Implement data retention policies

#### GDPR Compliance (if applicable)

- Provide data export functionality
- Implement account deletion
- Obtain user consent for data processing

#### Privacy Policy

Create a privacy policy that discloses:
- What data is collected
- How data is used
- How data is stored
- Third-party services used (Firebase)
- User rights (access, deletion)

## 🔍 Security Checklist

Before deploying to production, ensure:

### Firebase Configuration
- [ ] Firestore security rules configured (not test mode)
- [ ] Firebase API keys secured (not hardcoded)
- [ ] Firebase Auth configured if using authentication
- [ ] App Check enabled for API abuse prevention

### Code Security
- [ ] Input validation on all user inputs
- [ ] Error handling doesn't expose sensitive info
- [ ] No hardcoded secrets or credentials
- [ ] Dependencies up to date and audited

### Build Configuration
- [ ] Code obfuscation enabled for release builds
- [ ] Debug logs removed from production code
- [ ] Network security config set (Android)
- [ ] App Transport Security configured (iOS)

### Testing
- [ ] Security testing performed
- [ ] Penetration testing conducted (for sensitive apps)
- [ ] Code review completed

### Documentation
- [ ] Security practices documented
- [ ] Privacy policy created
- [ ] Terms of service defined
- [ ] Data retention policy established

## 📚 Additional Resources

### Firebase Security

- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Firebase App Check](https://firebase.google.com/docs/app-check)
- [Firebase Security Best Practices](https://firebase.google.com/support/guides/security-checklist)

### Flutter Security

- [Flutter Security Best Practices](https://flutter.dev/security)
- [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/)
- [Dart Security Guidelines](https://dart.dev/guides/security)

### Compliance

- [GDPR Compliance Guide](https://gdpr.eu/)
- [COPPA Compliance](https://www.ftc.gov/enforcement/rules/rulemaking-regulatory-reform-proceedings/childrens-online-privacy-protection-rule)

## 🏆 Security Acknowledgments

We appreciate security researchers who responsibly disclose vulnerabilities. Contributors who report valid security issues will be acknowledged in our security advisories (unless they prefer to remain anonymous).

## 📄 License

This security policy is part of the Songs List App and is licensed under the Apache License 2.0.

---

**Last Updated:** January 29, 2025  
**Next Review:** July 2025

For questions about this security policy, please open a GitHub Discussion or contact the maintainer directly.
