# The SAAC - Modding Guide

Welcome to The SAAC modding system! This guide will help you create custom content for the game.

## Overview

The SAAC is designed to be fully moddable. You can add:
- New characters
- New items (passive and active)
- New room templates
- New enemies
- Custom stats

All modding is done through JSON files, with optional GDScript for complex behaviors.

## Directory Structure

Create your mod in the `mods/` directory:

```
mods/
└── your_mod_name/
    ├── characters/
    │   └── your_character.json
    ├── items/
    │   └── your_item.json
    ├── rooms/
    │   └── your_room.json
    └── enemies/
        └── your_enemy.json
```

## Creating Characters

Copy the template from `data/characters/_template.json`:

```json
{
  "id": "my_character",
  "name": "My Character",
  "description": "A custom character",
  "sprite": "res://mods/your_mod_name/sprites/my_character.png",
  "stats": {
    "health": 6.0,
    "damage": 1.0,
    "fire_rate": 1.0,
    "speed": 1.0,
    "luck": 1.0
  },
  "starting_items": ["damage_up"],
  "unique_trait": ""
}
```

### Character Fields

- `id`: Unique identifier (required)
- `name`: Display name (required)
- `description`: Short description
- `sprite`: Path to sprite image
- `stats`: Base stats for the character
- `starting_items`: Array of item IDs to start with
- `unique_trait`: Reserved for future features

## Creating Items

### Simple Items (Data-Only)

Copy the template from `data/items/_template.json`:

```json
{
  "id": "my_item",
  "name": "My Item",
  "description": "Does something cool",
  "type": "passive",
  "sprite": "res://mods/your_mod_name/sprites/my_item.png",
  "stats": {
    "damage": 0.5,
    "fire_rate": 0.2
  },
  "shooting_modifiers": {
    "projectile_count": 2,
    "spread": 10.0,
    "pierce": 1,
    "bounce": 0
  },
  "script": ""
}
```

### Item Fields

- `id`: Unique identifier (required)
- `name`: Display name (required)
- `description`: What the item does
- `type`: "passive" or "active"
- `sprite`: Path to sprite image
- `stats`: Stat modifiers (adds to player stats)
- `shooting_modifiers`: Shooting behavior changes
  - `projectile_count`: Additional projectiles per shot
  - `spread`: Angle spread in degrees
  - `pierce`: Number of enemies pierced
  - `bounce`: Number of wall bounces
- `script`: Path to GDScript for complex behavior (optional)

### Complex Items (Scripted)

For items with custom behavior, create a GDScript:

```gdscript
# res://mods/your_mod_name/scripts/my_complex_item.gd
extends Resource

func use():
    # Custom item logic here
    print("Using complex item!")
    # You can access game systems:
    # - GameManager
    # - ItemManager
    # - StatsManager
    # etc.
```

Then reference it in your item JSON:

```json
{
  "id": "complex_item",
  "name": "Complex Item",
  "description": "Has custom behavior",
  "type": "active",
  "sprite": "res://mods/your_mod_name/sprites/complex_item.png",
  "stats": {},
  "shooting_modifiers": {},
  "script": "res://mods/your_mod_name/scripts/complex_item.gd"
}
```

## Creating Rooms

Copy the template from `data/rooms/_template.json`:

```json
{
  "id": "my_room",
  "type": "normal",
  "name": "My Room",
  "description": "A custom room layout",
  "layout": {
    "width": 10,
    "height": 10,
    "walls": [],
    "doors": [
      {
        "position": {"x": 0, "y": 5},
        "direction": "left",
        "connects_to": ""
      }
    ]
  },
  "enemy_spawns": [
    {
      "enemy_id": "basic_enemy",
      "position": {"x": 5, "y": 5}
    }
  ],
  "item_spawns": [
    {
      "item_id": "damage_up",
      "position": {"x": 3, "y": 3}
    }
  ],
  "obstacles": []
}
```

### Room Types

- `normal`: Standard combat room
- `treasure`: Contains item pickups
- `boss`: End-of-floor boss encounter
- `shop`: (Future) Shop room
- `secret`: (Future) Secret room

### Room Fields

- `id`: Unique identifier
- `type`: Room type
- `name`: Display name
- `description`: Room description
- `layout`: Room dimensions and structure
- `enemy_spawns`: Array of enemies to spawn
- `item_spawns`: Array of items to place
- `obstacles`: (Future) Obstacles placement

## Creating Enemies

Create an enemy JSON file:

```json
{
  "id": "my_enemy",
  "name": "My Enemy",
  "description": "A custom enemy",
  "sprite": "res://mods/your_mod_name/sprites/my_enemy.png",
  "health": 5.0,
  "damage": 1.5,
  "speed": 120.0,
  "detection_range": 350.0,
  "attack_range": 60.0
}
```

### Enemy Fields

- `id`: Unique identifier
- `name`: Display name
- `description`: Enemy description
- `sprite`: Path to sprite image
- `health`: Enemy health points
- `damage`: Damage dealt to player
- `speed`: Movement speed
- `detection_range`: Distance to detect player
- `attack_range`: Distance to attack player

## Creating Relics/Trinkets

Copy the template from `data/relics/_template.json`:

```json
{
  "id": "my_relic",
  "name": "My Relic",
  "description": "A powerful trinket",
  "sprite": "res://mods/your_mod_name/sprites/my_relic.png",
  "rarity": "uncommon",
  "stat_modifiers": {
    "health": 2.0,
    "luck": 0.5
  },
  "special_effects": [
    {
      "type": "damage_reflection",
      "value": 0.2
    }
  ]
}
```

### Relic Fields

- `id`: Unique identifier
- `name`: Display name
- `description`: What the relic does
- `sprite`: Path to sprite image
- `rarity`: "common", "uncommon", "rare", or "legendary"
- `stat_modifiers`: Stat modifiers (adds to player stats)
- `special_effects`: Array of special effect objects
  - `type`: Effect type (damage_reflection, health_regen, luck_boost, etc.)
  - `value`: Effect strength

### Relic Rarity Colors

- **Common**: Grey
- **Uncommon**: Green
- **Rare**: Blue
- **Legendary**: Gold

Players can collect up to 3 relics per run.

## Custom Stats

You can define custom stats in `data/stats/stat_definitions.json` (for the base game) or override them in mods (future feature).

## Asset Guidelines

### Sprites

- Place sprites in your mod's `sprites/` directory
- Use PNG format
- Recommended size: 32x32 or 64x64 pixels
- Ensure transparent backgrounds

### Naming Conventions

- Use lowercase with underscores: `my_item`, `my_character`
- Be descriptive but concise
- Avoid spaces and special characters

## Testing Your Mod

1. Create your mod directory structure
2. Add your JSON files
3. Add any custom scripts
4. Add sprite assets
5. Start the game
6. The game will automatically load mods from the `mods/` directory

## Tips

- Start with simple items (stat changes) before attempting complex scripted items
- Test frequently
- Check the console for errors if your mod doesn't load
- Look at the example files in `data/` for reference

## Limitations

- Currently, mods cannot modify core game systems
- Scripted items have access to game managers but should be used carefully
- Asset paths in mods should be relative to the mod directory

## Future Features

- Steam Workshop integration
- In-game mod browser
- Mod versioning and compatibility checking
- More complex script APIs

## Support

If you encounter issues or have questions:
- Check the example files in the `data/` directory
- Review the game's source code in `scripts/` and `autoload/`
- Check the console for error messages

Happy modding!
