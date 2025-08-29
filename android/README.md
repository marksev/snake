# Android/Gradle Update Instructions

## Changes Made

This directory has been regenerated with the latest Android/Gradle configuration for Flutter 3.24+ compatibility:

- **Gradle Plugin:** Updated to 8.1.0 (from 7.3.0)
- **Kotlin:** Updated to 1.9.10 (from 1.7.10)  
- **Gradle Wrapper:** Using Gradle 8.0
- **Memory Settings:** JVM args updated to `-Xmx2048m -XX:+HeapDumpOnOutOfMemoryError`
- **Plugin System:** Uses modern Flutter plugin loader (`dev.flutter.flutter-plugin-loader`)
- **Build Configuration:** Updated to use `dev.flutter.flutter-gradle-plugin`

## Flutter Regeneration (if needed)

To regenerate Android project files with latest Flutter:

```bash
# From project root
flutter create . --project-name snake_game
```

This will:
- Refresh android/ directory structure
- Keep existing Dart code, assets, and pubspec.yaml
- Overwrite Gradle-related and Android config files

## Build Verification

After regeneration, verify the build works:

```bash
flutter pub get
flutter build apk --release
```

## Key Features of This Modern Configuration

### Modern Plugin System
- Uses `pluginManagement` block in `settings.gradle`
- Includes `dev.flutter.flutter-plugin-loader` plugin
- Uses `includeBuild` for Flutter tools integration

### Updated Build Configuration
- Modern Android Gradle Plugin (8.1.0)
- Kotlin 1.9.10 with proper JVM target
- Gradle 8.0 wrapper
- Proper namespace configuration
- AndroidX support enabled

### Flutter Integration
- Uses `dev.flutter.flutter-gradle-plugin` in app/build.gradle
- Proper Flutter SDK version references (compileSdkVersion, minSdkVersion, etc.)
- Modern manifest structure with Flutter embedding v2

## GitHub Actions

The CI workflow has been updated to use:
- Java 17
- Flutter 3.24.3 (stable)
- Latest build tools

The APK build should now succeed in GitHub Actions.

## Project Structure

```
android/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── kotlin/com/example/snake_game/
│   │   │   │   └── MainActivity.kt
│   │   │   ├── res/
│   │   │   │   ├── values/
│   │   │   │   ├── values-night/
│   │   │   │   └── drawable/
│   │   │   └── AndroidManifest.xml
│   │   ├── debug/
│   │   │   └── AndroidManifest.xml
│   │   └── profile/
│   │       └── AndroidManifest.xml
│   └── build.gradle
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.properties
│       └── gradle-wrapper.jar
├── build.gradle
├── gradle.properties
├── gradlew
└── settings.gradle
```

This structure is fully compatible with Flutter 3.24+ and uses the latest Android development patterns.