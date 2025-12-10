### About Flame (Coming from Unity)

Flame is a lightweight, modular 2D game engine built on top of Flutter, which means it's written in Dart and integrates seamlessly with Flutter's widget system for UI elements like menus, HUDs, or overlays. Unlike Unity, which is a full-fledged editor with scene management, physics, and 3D support out of the box, Flame is more code-centric and focuses on sprite-based rendering, input handling, collisions, and animations without a visual editor. It's great for simple mobile/web games since Flutter compiles to native code for iOS/Android and WebAssembly for web.

Key similarities to Unity:
- **Game Loop**: Flame has an update/render loop like Unity's Update/FixedUpdate.
- **Components**: You build games using composable components (like Unity's GameObjects with scripts), but in Flame, they're classes extending `Component` (e.g., sprites, particles).
- **Assets**: Load sprites, audio, etc., similar to Unity's asset pipeline, but managed via pubspec.yaml.

Differences:
- No built-in physics engine like Unity's (use Forge2D if needed, a Box2D port).
- Input: Handles touch/keyboard/mouse natively via Flutter.
- Deployment: One codebase for mobile/web, no separate builds like Unity.
- Simpler for 2D shooters: Focus on performance for mobiles.

To get started, add Flame to your Flutter project via `flutter pub add flame`. For audio, add `flame_audio`. For storage (highscores), use `hive` or `shared_preferences`.

### Project Structure Plan

For a simple plane shooter (like a vertical scroller where the player plane shoots enemies), I'll outline a clean, modular structure. This follows Flutter/Flame best practices: separate game logic, UI, assets, and utilities. The game will be a single screen that starts on tap, with overlays for game over/highscore input.

#### Overall Setup
- **Flutter Project Root**: Create with `flutter create plane_shooter`.
- **Dependencies** (in `pubspec.yaml`):
  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    flame: ^1.0.0  # Latest version as of now
    flame_audio: ^2.0.0  # For sounds
    shared_preferences: ^2.0.0  # For simple highscore storage (or use hive for more complex)
  assets:
    - assets/images/  # Sprites for plane, enemies, bullets, explosions
    - assets/audio/   # Sounds for shooting, explosions, etc.
  ```
- **Run Modes**: Use `flutter run` for mobile (emulator/device) or `flutter run -d chrome` for web. Flame handles platform differences automatically for input.

#### Folder Structure
Here's the planned structure under `lib/` (main code folder). Keep it flat for simplicity, but group related files.

```
lib/
├── main.dart                  # Entry point: Sets up Flutter app, loads game.
├── game/
│   ├── plane_shooter_game.dart  # Main game class (extends FlameGame): Manages world, player, enemies, effects.
│   ├── components/            # Reusable game objects (extend Component or SpriteAnimationComponent).
│   │   ├── player.dart        # Player plane: Handles movement (touch drag/wheel for mobile, WASD for web).
│   │   ├── bullet.dart        # Player/enemy bullets: Simple moving sprites with collision.
│   │   ├── enemy.dart         # Base enemy class: Extend for diverse types (e.g., straight mover, shooter, rammer).
│   │   ├── enemy_types/       # Subfolder for variants if many.
│   │   │   ├── straight_enemy.dart
│   │   │   ├── shooting_enemy.dart
│   │   │   └── ramming_enemy.dart
│   │   ├── explosion.dart     # Particle or animation for explosions.
│   │   ├── laser_beam.dart    # Special power-up: Activates after hit streak, full-screen beam.
│   │   └── power_up.dart      # Logic for stacking hits to unlock laser (could be in player).
│   ├── managers/              # Systems for spawning, scoring, audio.
│   │   ├── enemy_manager.dart # Spawns diverse enemies at intervals.
│   │   ├── collision_manager.dart # Handles bullet-enemy/player collisions (use HasCollisionDetection mixin).
│   │   ├── audio_manager.dart # Plays sounds (e.g., FlameAudio.play('shoot.wav')).
│   │   └── score_manager.dart # Tracks score, hit streaks for laser.
│   └── overlays/              # Flutter widgets overlaid on game (for HUD, game over).
│       ├── hud.dart           # Score display, laser charge bar.
│       ├── game_over.dart     # Screen with score, highscore input (TextField for name), play again button.
│       └── highscore_list.dart # Displays top 5 scores (fetched from storage).
├── utils/
│   ├── constants.dart         # Game constants: Speeds, sizes, asset paths.
│   ├── input_handler.dart     # Unified input: Detects mobile (Tappable/Gesturable) vs web (KeyboardListener).
│   └── storage.dart           # Highscore logic: Save/load top 5 (list of {name, score, date}) using SharedPreferences.
└── assets/                    # Outside lib/, but referenced here.
    ├── images/
    │   ├── player_plane.png   # Sprites (use sprite sheets for animations).
    │   ├── enemy1.png
    │   ├── bullet.png
    │   ├── explosion_sheet.png  # For animation.
    │   └── laser_beam.png
    └── audio/
        ├── shoot.wav
        ├── explosion.mp3
        └── bg_music.mp3       # Optional loop.
```

#### Key Implementation Notes by Feature
- **Game Effects (Bullets, Explosions)**:
    - Bullets: Extend `SpriteComponent` with velocity; add to game in `update()`.
    - Explosions: Use `SpriteAnimationComponent` from a sprite sheet or `ParticleSystemComponent` for particle effects.
    - In `plane_shooter_game.dart`: Use `add()` to spawn them dynamically.

- **Sounds**:
    - Preload in `onLoad()` of the game: `FlameAudio.audioCache.loadAll([...])`.
    - Play via `AudioManager`: e.g., on collision, `FlameAudio.play('explosion.mp3')`.

- **Mobile (Wheel Movement) + Web (WASD) Support**:
    - Assume "wheel" means virtual joystick/touch drag for mobile.
    - In `input_handler.dart`: Use `Draggable` for mobile touch (drag plane), `KeyboardEvents` for web (WASD keys map to velocity).
    - In `PlaneShooterGame`: Mix in `KeyboardEvents` and `MultiTapListener`/`DragCallbacks` based on platform (Flame detects via `kIsWeb`).

- **Diverse Enemies**:
    - Base `Enemy` class with `update()` for movement.
    - Variants: `StraightEnemy` moves down; `ShootingEnemy` fires periodically; `RammingEnemy` targets player position.
    - `EnemyManager`: Timer to spawn randomly, e.g., `Timer.periodic` with random type.

- **Special Beam Laser**:
    - Track hit streak in `ScoreManager` (e.g., int _streak; reset on miss).
    - When streak >= threshold (e.g., 10), enable laser (tap/ space to fire).
    - `LaserBeam`: Full-screen sprite/particle that damages all enemies, with cooldown.

- **One Screen, Tap and Play**:
    - In `main.dart`: `GameWidget(game: PlaneShooterGame())` as the home widget.
    - Start paused; on first tap (use `TapCallbacks`), unpause and start spawning.

- **Save Highscore**:
    - In `storage.dart`: Use `SharedPreferences` to store JSON list of top 5: e.g., `[{ "name": "Player", "score": 1000, "date": "2025-12-10" }]`.
    - Sort and trim to 5 on save.
    - On game over: Check if score > lowest in top 5; show overlay with `TextField` for name, save, then display list.

- **Game Over with Play Again**:
    - Detect player death (collision) in `CollisionManager`.
    - Show `GameOver` overlay (via `overlays.add('gameOver')` in FlameGame).
    - Overlay: Flutter `Column` with score, highscore prompt if needed, `ElevatedButton` to restart (remove overlay, reset game state via `gameRef.reset()` method you implement).

#### Development Flow
1. Set up base game: `PlaneShooterGame` with player and basic bullet shooting.
2. Add enemies and collisions.
3. Implement inputs, effects, sounds.
4. Add power-ups and managers.
5. Handle overlays and storage last.
6. Test on mobile/web: Ensure responsive (use `camera.viewport` for screen sizes).

This should be straightforward for a seminar demo—aim for 500-1000 lines total. If you need code snippets for specific parts, let me know!