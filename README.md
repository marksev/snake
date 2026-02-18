# Lane Escape

A simple Flutter lane-dodging game.

## Run

```bash
flutter pub get
flutter run
```

## How to play

- Swipe left/right to change lanes.
- Avoid holes appearing in random lanes every 3 seconds.
- Hit a hole and it's game over.


## Build APK in GitHub Actions

This repository includes a workflow at `.github/workflows/android-apk.yml` that:

- installs Flutter (stable) and Java 17,
- creates Android platform files if missing (`flutter create --platforms android .`),
- builds a release APK,
- uploads `app-release.apk` as a workflow artifact.

You can run it by pushing to `main`/`master` or manually via **Actions → Build Android APK → Run workflow**.
