# Architecture Overview

## Core layers

- **UI layer (`lib/src/widgets`)**
  - `GameScreen` handles gestures (left/right swipe), and composes visual layers:
    1. Road background + edge lines
    2. Active game world (car + holes)
    3. Game-over overlay
- **Controller layer (`lib/src/controller`)**
  - `GameController` is a `ChangeNotifier` that owns mutable game state and game loop logic.
- **Model layer (`lib/src/models`)**
  - `Hole` is a lightweight data model containing lane and vertical progress.

## State management

- Uses Flutter-native `ChangeNotifier` + `AnimatedBuilder`.
- `GameController` exposes:
  - `currentLane`
  - active `holes`
  - `isGameOver`
- UI listens reactively via `AnimatedBuilder(animation: controller, ...)`.

## Game loop and timing

- A periodic timer (`16ms`) drives updates (`~60fps`).
- Controller computes frame delta (`dt`) and advances each hole downward.
- A spawn accumulator creates a new hole every `3 seconds` in a random lane.
- Collision checks run every frame against the car's lane and collision line.

## Gestures

- `GestureDetector.onHorizontalDragEnd` reads swipe velocity.
- Swipe left/right changes lane index in range `[0, 2]`.
- Car movement is animated with `AnimatedPositioned` for smooth lane transitions.

## Extensibility

This structure keeps gameplay rules in the controller, visuals in widgets, and data in models, making it straightforward to add:

- scoring and difficulty scaling,
- additional obstacle types,
- power-ups,
- a pause state,
- sound effects.
