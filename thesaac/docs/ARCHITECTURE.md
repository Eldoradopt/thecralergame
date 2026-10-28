# The SAAC - Architecture Documentation

## Overview

The SAAC is a modular, data-driven roguelike game built in Godot 4.7. The architecture prioritizes moddability and simplicity.

## Core Systems

### Autoload Singletons

The game uses several autoloaded singletons (defined in `project.godot`):

- **GameManager**: Global game state, scene transitions, game flow
- **DataManager**: JSON data loading, mod system integration
- **InputManager**: Cross-platform input abstraction (keyboard/mouse, gamepad, touch)
- **StatsManager**: Stat calculations, modifiers, display formatting
- **RoomManager**: Room generation, floor progression, room templates
- **ItemManager**: Item registry, effect application, inventory management
- **SaveManager**: Game state persistence, save slots

### Data Flow

1. **Game Start**: Main menu → GameManager.start_game() → Load character data
2. **Character Setup**: StatsManager.reset_to_character() → Apply base stats
3. **Gameplay Loop**: Player moves/shoots → InputManager processes input → Components handle behavior
4. **Item Pickup**: ItemPickup → ItemManager.collect_item() → StatsManager.apply_item_stats()
5. **Room Transition**: RoomManager.generate_room() → Load room template → Spawn enemies/items
6. **Save Game**: SaveManager.save_game() → Serialize state to JSON

## Component System

Entities use a component-based architecture:

### Player Components

- **MovementComponent**: Handles movement physics and input
- **HealthComponent**: Manages health, damage, healing, invulnerability
- **GunComponent**: Shooting logic, fire rate, projectile spawning, modifiers

### Enemy Components

- **HealthComponent**: Same as player
- AI behavior is in the Enemy script itself (simpler for now)

## Data System

### JSON Structure

All game data is stored in JSON files in `data/`:

- `characters/`: Character definitions
- `items/`: Item definitions (passive/active)
- `stats/`: Stat system configuration
- `rooms/`: Room templates
- `floors/`: Floor progression rules
- `enemies/`: Enemy definitions

### Mod Loading

Mods are loaded from `mods/` directory. Each mod can have subdirectories matching the data structure. Mods override/merge with base data.

## Input System

### Input Abstraction

InputManager provides a unified interface for:
- Keyboard/mouse (WASD + mouse aim)
- Gamepad (left stick move, right stick aim)
- Touch (virtual joystick + drag aim)

### Input Methods

The game automatically detects the active input method and switches behavior accordingly.

## Room Generation

### Template-Based

Rooms are defined as JSON templates with:
- Layout dimensions
- Door positions
- Enemy spawn points
- Item spawn points
- Obstacles (future)

### Floor Progression

Each floor has:
- Number of rooms
- Difficulty multiplier
- Boss ID
- Room type distribution

## Item System

### Hybrid Approach

- **Simple items**: JSON-only (stat modifiers, shooting changes)
- **Complex items**: JSON + GDScript (custom behaviors)

### Item Effects

Items can modify:
- Player stats (damage, fire rate, speed, etc.)
- Shooting behavior (projectile count, spread, pierce, bounce)
- Custom behavior via scripts

## Scene Structure

### Core Scenes

- `main_menu.tscn`: Title screen
- `main_game.tscn`: Main gameplay scene
- `player.tscn`: Player entity
- `enemy.tscn`: Enemy entity
- `projectile.tscn`: Bullet entity
- `item_pickup.tscn`: Collectible item
- `room_base.tscn`: Base room template

### UI Scenes

- `stats_hud.tscn`: In-game stats display
- `item_description_popup.tscn`: Item details popup
- `main_menu.tscn`: Main menu UI

## Save System

### Save Data Structure

```json
{
  "character_id": "default_character",
  "current_floor": 1,
  "current_room_id": "room_123",
  "collected_items": ["damage_up", "triple_shot"],
  "stats": {...},
  "visited_rooms": [...],
  "timestamp": 1234567890
}
```

### Save Slots

Multiple save slots are supported via `save_slot_N.json` files.

## Future Expansions

### Planned Features

- Character selection screen
- Touch control UI (virtual joystick)
- More room types (challenge, secret, shop)
- Active item cooldown system
- Achievement system
- Online leaderboards
- Steam Workshop integration

### Architecture Considerations

- The component system allows easy addition of new behaviors
- The data-driven nature makes adding content simple
- The mod system is designed to be extensible
- Cross-platform support is built into the input system

## Performance Considerations

- Stats are recalculated only when modifiers change
- Room templates are loaded on-demand
- Projectiles are pooled or queued for deletion
- Mod data is loaded once at startup

## Security

- Mod data is validated before application
- Scripted items run in a controlled context
- Save files are validated on load
