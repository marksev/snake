# Snake Game

A Flutter implementation of the classic Snake Game with cartoon-like graphics.

## Features

- 🐍 Blue snake with rounded edges and cartoon eyes
- 🍎 Red apple with green leaf as food
- 🏁 Green checkered background
- 🏆 Score tracking with apples eaten and trophy counter
- ⌨️ Arrow key controls (desktop) and swipe controls (mobile)
- 🎮 Smooth gameplay with collision detection

## How to Play

- Use arrow keys (desktop) or swipe gestures (mobile) to control the snake
- Eat the red apples to grow longer and increase your score
- Avoid hitting the walls or the snake's own body
- Press Space to pause/resume the game

## Building

This project uses Flutter. To build:

1. Install Flutter SDK
2. Run `flutter pub get` to get dependencies
3. Run `flutter run` to start the app
4. Build APK with `flutter build apk --release`

## GitHub Actions

The project includes automated builds that create Android APK files on every push to the main branch. Download the APK from the Actions artifacts.
