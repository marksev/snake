# Android/Gradle Update Instructions

## Changes Made

This directory has been updated with the latest Android/Gradle configuration:

- **Gradle Plugin:** Updated to 8.1.0 (from 7.3.0)
- **Kotlin:** Updated to 1.9.10 (from 1.7.10)  
- **Gradle Wrapper:** Using Gradle 8.0.2
- **Memory Settings:** JVM args updated to `-Xmx2048m -XX:+HeapDumpOnOutOfMemoryError`

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

## GitHub Actions

The CI workflow has been updated to use:
- Java 17
- Flutter 3.24.3 (stable)
- Latest build tools

The APK build should now succeed in GitHub Actions.