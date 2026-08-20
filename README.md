# Trainer Career

Trainer Career is an observer-only history and statistics mod for Pokémon Red, Blue, and Yellow on [Gen1Recomp](https://github.com/bryanthaboi/gen1recomp).

It is designed to preserve the story of a playthrough without changing gameplay.

> Trainer Career observes. Trainer Career does not alter.  
> If the save proves it, use it. If it does not, do not invent it.

## Status

Trainer Career is currently in early development. The repository contains the initial mod structure and technical foundation; tracking and UI are not implemented yet.

## Planned features

### Journey

A chronological diary containing catches, evolutions, first visits, badges, blackouts, Key Items, releases, Hall of Fame entries and Pokédex completion.

### Pokémon careers

Individual histories covering origin, evolution, battle records, move history and Hall of Fame appearances.

### Stats

Career totals and records such as battles, KOs, damage, critical hits, most-used moves and most-used Poké Balls.

### Trophy Room

Badge and Hall of Fame records with objective team snapshots where the game can prove them.

## Planned menu

```text
TRAINER CAREER
────────────────
> JOURNEY
  POKéMON
  STATS
  TROPHY ROOM
```

The interface will use Gen1Recomp's public menu components so it feels like a natural part of the game and remains compatible with other mods.

## Scope

- Pokémon Red
- Pokémon Blue
- Pokémon Yellow
- Observer-only: no gameplay changes
- No achievements, quests, battle replays, telemetry or leaderboards
- No ROMs, save files or ROM-derived assets distributed with the mod

Gen 2 is not currently supported.

## Development

The mod targets Gen1Recomp Mod API 2. To validate a checkout, provide paths to Gen1Recomp and LuaJIT:

```powershell
./scripts/verify.ps1 -EngineRoot "C:\path\to\gen1recomp" -LuaJit "C:\path\to\luajit.exe"
```

The current public API audit and test strategy are available in [`docs`](docs).

## Contributing

Ideas, bug reports and pull requests are welcome. Use the issue forms for bugs and feature suggestions. Never attach ROMs or private save files.

## License

Trainer Career is available under the [MIT License](LICENSE). Pokémon assets, ROMs and player saves are not included or covered by this license.

Development is AI-assisted and reviewed and directed by the project author.
