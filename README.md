# Eduspace Flutter App

A teacher-focused mobile application built with Flutter. This app enforces role-based access control, allowing only users with "RoleTeacher" to authenticate and access the platform.

## Features

- **Teacher Authentication**: Secure login system with role validation
- **Role-Based Access Control**: Only teachers can access the application
- **Firebase Integration**: Firebase services for analytics and monitoring
- **Secure Storage**: Uses Flutter Secure Storage for sensitive data
- **Clean Architecture**: Feature-based architecture with BLoC pattern

## Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)
- A valid backend API endpoint

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd eduspace_flutter_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Configuration

Create a `.env` file at the project root with your API base URL:

```env
API_BASE_URL=<backend_url>
```

**Environment-specific URLs:**
- **Android Emulator**: `http://10.0.2.2:8080/api/v1`
- **iOS Simulator**: `http://localhost:8080/api/v1`
- **Production**: `https://eduspace-platform-production-e783.up.railway.app/api/v1`

### 4. Run the App

```bash
flutter run
```

## Architecture

This project follows a **feature-based architecture** with clean architecture principles:

```
lib/
├── core/                      # Shared utilities and constants
│   ├── constants/            # API endpoints and configuration
│   └── enums/               # Shared enumerations (Status, etc.)
└── features/                 # Feature modules
    └── auth/                # Authentication feature
        ├── data/            # Data sources and services
        ├── domain/          # Business entities
        └── presentation/    # UI layer (BLoC + Pages)
            ├── blocs/       # State management with flutter_bloc
            └── pages/       # UI screens
```

### Key Patterns

- **BLoC Pattern**: State management using `flutter_bloc`
- **Service Layer**: Data operations through service classes
- **Domain Models**: Pure Dart entities for business logic
- **Environment Configuration**: `.env` file for API configuration

## Development Commands

### Code Quality

```bash
flutter analyze                 # Run static analysis
flutter test                    # Run all tests
flutter test path/to/test.dart  # Run specific test
```

### Build Commands

```bash
flutter build apk              # Build Android APK
flutter build ios              # Build iOS (macOS only)
flutter build web              # Build for web
```

### Dependencies Management

```bash
flutter pub get                 # Install dependencies
flutter pub upgrade             # Update dependencies
```

## Key Dependencies

- **flutter_bloc**: ^9.1.1 - State management
- **flutter_dotenv**: ^6.0.0 - Environment configuration
- **http**: ^1.5.0 - HTTP requests
- **flutter_secure_storage**: ^9.0.0 - Secure data storage
- **intl**: ^0.20.2 - Internationalization
- **firebase_core**: ^4.2.1 - Firebase integration

## Authentication Flow

1. User enters credentials on login page
2. App sends authentication request to backend API
3. Backend validates credentials and returns user data
4. App validates user has "RoleTeacher" role (lib/features/auth/data/auth_service.dart:29)
5. If valid, user is granted access; otherwise, authentication fails

## Project Structure

- **/lib/core**: Shared utilities, constants, and enums
- **/lib/features**: Feature modules organized by domain
- **/lib/presentation/widgets**: Reusable UI components
- **/assets**: Images, icons, and other static resources
- **/.env**: Environment configuration (not committed to version control)

## Contributing

1. Follow the existing code structure and patterns
2. Use BLoC pattern for state management
3. Keep code clean and self-documenting
4. Write tests for new features
5. Run `flutter analyze` before committing

## License

This project is proprietary and confidential.
