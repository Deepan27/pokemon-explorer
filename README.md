# Pokémon Explorer

A production-quality Flutter mobile application that displays a paginated list of Pokémon with detailed information, featuring robust offline support, intelligent caching, and optimized image handling.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 📱 Features

### Core Functionality
- **Paginated Pokémon List**: Infinite scroll with pull-to-refresh
- **Detailed Pokémon View**: Comprehensive information including stats, types, and abilities
- **Offline-First Architecture**: Full functionality without internet connection
- **Smart Caching**: 24-hour cache expiration with automatic refresh
- **Auto-Sync**: Automatic data synchronization when network is restored
- **Optimized Images**: Resized and compressed images processed in isolates
- **Smooth Performance**: 60 FPS scrolling with lazy loading

### Technical Highlights
- Clean Architecture (Domain, Data, Presentation layers)
- BLoC Pattern for state management
- Dependency Injection with GetIt
- Local-first data strategy with Drift database
- Network resilience with retry logic
- Comprehensive unit test coverage

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── database/          # Drift database configuration
│   ├── di/                # Dependency injection setup
│   ├── errors/            # Error handling and failures
│   ├── network/           # API client and connectivity monitoring
│   ├── services/          # Image optimization service
│   └── widgets/           # Reusable UI components
├── features/
│   ├── pokemon_list/
│   │   ├── data/
│   │   │   ├── datasources/    # Remote and local data sources
│   │   │   ├── models/         # Data models
│   │   │   └── repositories/   # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/       # Business entities
│   │   │   └── repositories/   # Repository interfaces
│   │   └── presentation/
│   │       ├── bloc/           # BLoC state management
│   │       ├── pages/          # UI screens
│   │       └── widgets/        # Feature-specific widgets
│   └── pokemon_detail/
│       └── [similar structure]
└── main.dart
```

### Design Patterns
- **Clean Architecture**: Separation of concerns across layers
- **Repository Pattern**: Abstract data sources
- **BLoC Pattern**: Predictable state management
- **Dependency Injection**: Loose coupling and testability
- **Factory Pattern**: Object creation in models

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / Xcode for mobile development
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pokemon_explorer.git
   cd pokemon_explorer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   # For development
   flutter run

   # For specific platform
   flutter run -d android
   flutter run -d ios
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📦 Dependencies

### Core Packages
- **flutter_bloc** (^8.1.3): State management
- **get_it** (^7.6.4): Dependency injection
- **dio** (^5.3.3): HTTP client
- **drift** (^2.13.1): Local database
- **internet_connection_checker** (^1.0.0+1): Network monitoring

### Utility Packages
- **dartz** (^0.10.1): Functional programming (Either type)
- **equatable** (^2.0.5): Value equality
- **path_provider** (^2.1.1): File system paths
- **image** (^4.1.3): Image processing

### Development Packages
- **build_runner** (^2.4.6): Code generation
- **drift_dev** (^2.13.2): Drift code generation
- **json_serializable** (^6.7.1): JSON serialization
- **mocktail** (^1.0.1): Mocking for tests
- **bloc_test** (^9.1.5): BLoC testing utilities

## 🎯 Key Features Implementation

### 1. Offline Support
- **Local Database**: Drift SQLite database for persistent storage
- **Cache-First Strategy**: Always check local cache before network
- **Graceful Degradation**: Full functionality without internet
- **Offline Indicator**: Visual feedback when offline

### 2. Cache Management
- **24-Hour Expiration**: Automatic cache invalidation after 24 hours
- **Smart Refresh**: Fetch fresh data only when cache is stale
- **Timestamp Tracking**: Each cached item has `lastUpdated` field
- **Fallback Strategy**: Use stale cache when offline

### 3. Auto-Sync
- **Network Monitoring**: Real-time connectivity status tracking
- **Automatic Refresh**: Sync data when connection is restored
- **Seamless UX**: No user interaction required
- **Event-Driven**: BLoC listener pattern for reactive updates

### 4. Image Optimization
- **Isolate Processing**: Image operations in background isolates
- **Resize & Compress**: Optimized for mobile display
- **Local Caching**: Processed images stored locally
- **Lazy Loading**: Load images as needed during scroll

### 5. Performance Optimization
- **Pagination**: Load 20 items at a time
- **Infinite Scroll**: Automatic loading on scroll
- **Debouncing**: Prevent excessive API calls
- **Memory Management**: Efficient image caching

## 🧪 Testing

### Test Coverage
- **Unit Tests**: Repository, BLoC, Services
- **Widget Tests**: UI components
- **Integration Tests**: End-to-end flows

### Test Files
```
test/
├── core/
│   ├── network/
│   │   └── connectivity_cubit_test.dart
│   └── services/
│       └── image_service_test.dart
├── features/
│   ├── pokemon_list/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── pokemon_repository_impl_test.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── pokemon_list_bloc_test.dart
│   └── pokemon_detail/
│       └── presentation/
│           └── bloc/
│               └── pokemon_detail_bloc_test.dart
```

### Running Specific Tests
```bash
# Run specific test file
flutter test test/features/pokemon_list/presentation/bloc/pokemon_list_bloc_test.dart

# Run tests with verbose output
flutter test --reporter expanded
```

## 📊 API Reference

### PokéAPI
This app uses the [PokéAPI](https://pokeapi.co/) for Pokémon data.

**Base URL**: `https://pokeapi.co/api/v2/`

**Endpoints Used**:
- `GET /pokemon?offset={offset}&limit={limit}` - List Pokémon
- `GET /pokemon/{id}` - Get Pokémon details

## 🔧 Configuration

### Network Settings
Configure in `lib/core/network/api_client.dart`:
- Base URL
- Timeout duration
- Retry attempts
- Logging level

### Cache Settings
Configure in `lib/features/pokemon_list/data/repositories/pokemon_repository_impl.dart`:
- Cache expiration time (default: 24 hours)
- Pagination limit (default: 20 items)

### Image Settings
Configure in `lib/core/services/image_service.dart`:
- Image dimensions
- Compression quality
- Cache directory

## 📱 Platform Support

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)

## 🐛 Known Issues

None at this time. Please report issues on GitHub.

## 🔄 Future Enhancements

- [ ] Search functionality
- [ ] Favorites/Bookmarks
- [ ] Filter by type/generation
- [ ] Dark mode
- [ ] Localization (i18n)
- [ ] Background sync
- [ ] Cache size management
- [ ] Analytics integration

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [PokéAPI](https://pokeapi.co/) for the comprehensive Pokémon data
- Flutter team for the amazing framework
- Open source community for the excellent packages

---

**Built with ❤️ using Flutter**

