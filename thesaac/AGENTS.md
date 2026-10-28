# The SAAC - Development Notes

## Project Status

The MVP foundation is complete with additional Relic/Trinket system. The game has the following systems implemented:

### Completed Systems

1. **Core Architecture**
   - 8 autoload singletons (GameManager, DataManager, InputManager, StatsManager, RoomManager, ItemManager, RelicManager, SaveManager)
   - Component-based entity system
   - Data-driven JSON configuration
   - Mod loading system

2. **Player System**
   - Movement component with keyboard/mouse/gamepad support
   - 360-degree shooting (mouse aim, gamepad right stick)
   - Health component with damage/healing
   - Gun component with fire rate and modifiers
   - Camera follows player

3. **Item System**
   - Hybrid data-driven (JSON) + scriptable (GDScript) items
   - Stat modifiers
   - Shooting modifiers (projectile count, spread, pierce, bounce)
   - Item pickup system
   - Item description popup

4. **Relic/Trinket System** ⭐ NEW
   - Data-driven relic definitions
   - Stat modifiers from relics
   - Special effects system (damage reduction, health regen, etc.)
   - Rarity system (common, uncommon, rare, legendary)
   - Relic HUD display
   - Max 3 relic slots
   - Color-coded by rarity

5. **Enemy System**
   - Basic AI (chase player, attack on contact)
   - Health component
   - Data-driven enemy definitions

6. **Room/Floor System**
   - Template-based room generation
   - Floor progression system
   - Room types (normal, treasure, boss)

7. **UI System**
   - Main menu
   - Stats HUD (displays health, damage, fire rate, speed, luck)
   - Relics HUD (displays collected relics with rarity colors)
   - Item description popup

8. **Save/Load System**
   - Single save slot
   - Multi-slot support
   - Game state persistence

9. **Modding System**
   - JSON-based mod loading
   - Support for characters, items, rooms, enemies, relics
   - Comprehensive modding documentation

### Data Files Created

- Characters: default_character.json
- Items: damage_up.json, triple_shot.json
- Stats: stat_definitions.json
- Rooms: normal_room_1.json, boss_room.json, treasure_room.json
- Floors: floor_1.json, floor_2.json
- Enemies: basic_enemy.json, floor_boss.json
- Relics: lucky_clover.json, iron_ring.json, swift_boots.json, golden_heart.json

### Scenes Created

- main_menu.tscn
- main_game.tscn
- player.tscn
- enemy.tscn
- projectile.tscn
- item_pickup.tscn
- relic_pickup.tscn ⭐ NEW
- room_base.tscn
- stats_hud.tscn
- relics_hud.tscn ⭐ NEW
- item_description_popup.tscn

## How to Test

1. Open the project in Godot 4.7
2. Press F5 to run the game
3. You should see the main menu
4. Click "Start Game"
5. Use WASD to move, mouse to aim, click to shoot
6. Walk over the blue item pickup to collect "Damage Up"
7. Walk over the grey relic pickup to collect "Lucky Clover"
8. Check the stats HUD in the bottom-left to see stat changes
9. Check the relics HUD in the bottom-right to see collected relics
10. Item/relic description popups will appear when picked up

## Relic System Details

### Relic Types

- **Lucky Clover** (Common): +1.0 Luck
- **Iron Ring** (Common): +2.0 Health, damage reduction effect
- **Swift Boots** (Uncommon): +0.3 Speed
- **Golden Heart** (Rare): +4.0 Health, health regen effect

### Rarity Colors

- Common: Grey
- Uncommon: Green
- Rare: Blue
- Legendary: Gold

### Modding Relics

Create new relics in `data/relics/` following the template in `_template.json`:
```json
{
  "id": "my_relic",
  "name": "My Relic",
  "description": "Does something cool",
  "rarity": "common",
  "stat_modifiers": {
    "luck": 0.5
  },
  "special_effects": []
}
```

## Known Limitations

- No actual room layout rendering (rooms are abstract for now)
- No enemy spawning in rooms (needs room template integration)
- No touch controls UI (gamepad/keyboard/mouse only)
- No character selection screen (defaults to "default_character")
- No paper art assets (using colored rectangles as placeholders)
- Room transitions not fully implemented
- No active item system yet
- Special effects in relics are not fully implemented (only stat modifiers work)

## Next Steps for Full Game

1. Implement actual room rendering from templates
2. Add enemy spawning based on room templates
3. Create character selection UI
4. Add touch control UI for mobile
5. Implement room transition system
6. Add paper art sprites
7. Create more room templates
8. Implement active item system with cooldowns
9. Add boss behaviors
10. Implement floor completion logic
11. Implement relic special effects (damage reduction, health regen, etc.)

## Modding

See `mods/README.md` for complete modding guide. The mod system is fully functional and ready for use.

## Controls

- WASD / Arrow Keys: Move
- Mouse: Aim
- Left Click / Space: Shoot
- Escape / P: Pause (not fully implemented yet)
- Gamepad: Left stick to move, right stick to aim, A/X to shoot

## File Structure

```
thesaac/
├── autoload/          # Singleton scripts
├── data/              # JSON data files
│   ├── characters/
│   ├── items/
│   ├── stats/
│   ├── rooms/
│   ├── floors/
│   ├── enemies/
│   └── relics/        # ⭐ NEW
├── scripts/
│   ├── core/          # Not used yet
│   ├── entities/      # Player, enemy, projectile, item pickup, relic pickup
│   ├── components/    # Movement, health, gun
│   ├── systems/       # Not used yet
│   └── ui/            # HUD, popups, menus
├── scenes/
│   ├── core/          # Main game, player, enemy, projectile, item pickup, relic pickup
│   ├── rooms/         # Room templates
│   └── ui/            # UI scenes
├── assets/            # Sprites, audio, shaders (empty)
├── mods/              # Mod directory with README
└── docs/              # Architecture documentation
```

## Build Commands

When ready to build:
- Export for Windows: Project → Export → Add Windows preset → Export
- Export for other platforms similarly
