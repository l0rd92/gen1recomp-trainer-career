# Gen1Recomp architecture audit

Audit date: 2026-08-20  
Upstream: `bryanthaboi/gen1recomp`  
Audited commit: `0dd889b35b96866146947b4af355be03bd056054`  
Engine source version: `0.0.0-dev`  
Mod API: `2`  
Save format: `4`  
ROM cache: `rom-cache-v5`

This snapshot is evidence for the scaffold, not a permanent API guarantee. Re-run the audit after updating upstream.

## Conclusions

1. Trainer Career can remain a normal API-2 `content` profile mod with category `TOOL` and no elevated permissions.
2. The public `ui.start_menu.items`, `content.screens`, `mod.ui.ListMenu` and screen-stack APIs support a game-style menu without replacing vanilla UI.
3. `mod.save` is the correct playthrough-bound persistence surface. It is backed by the mod's private `save.modData.trainer_career` namespace.
4. Data-only fields placed in a Pokémon's `mon.extra.trainer_career` namespace survive normal save serialization and link packing. Only the TC identity pointer belongs there; full history remains in `mod.save`.
5. Direct Gen 1 events exist for catches, evolutions, map entry, blackouts, battle start/end, moves, damage, faints, move learning and save lifecycle.
6. The engine already guards hot battle events with subscriber checks in relevant paths. Trainer Career must still aggregate in memory and avoid persistent writes per action.
7. There is no complete direct public event surface for every gift/first-partner path, Key Item acquisition, badge award, release confirmation or every move-replacement path. Narrow contextual reconciliation remains necessary.
8. The manifest should claim only `gen1`: that covers Red, Blue and Yellow together. Gold must not be claimed merely because private Gen 2 fixtures exist.

## Confirmed public seams

| Need | Public seam | Relevant payload/behavior |
|---|---|---|
| Add entry to START | `ui.start_menu.items` | Decorate the result after calling `next`; anchor before `SAVE` by label, never by index. |
| Register screens | `mod.content.screens:register` | Factory receives the live game. |
| Game-style lists | `mod.ui.ListMenu` | Built-in empty state and normal B-button exit behavior. |
| Save-bound state | `mod.save:get/set` | Stored under the mod-private save namespace and travels with normal SAVE. |
| New/existing save | `save.created`, `save.loading`, `save.loaded` | Suitable entry points for baseline/import decisions. |
| Catch | `pokemon.caught` | Includes `mon`, `species`, `isNew`, `ball`, `destination`, `game`. |
| Evolution | `pokemon.evolved` | Includes `mon`, previous/next species and `via`. |
| Travel | `map.entered` | Includes stable `mapId`, previous map and travel context. |
| Blackout | `world.blacked_out` | Includes save and heal target. |
| Battle lifecycle | `battle.started`, `battle.ended` | Start exposes kind/trainer/species; end exposes result. |
| Battle aggregation | `battle.move_used`, `battle.damage_dealt`, `battle.fainted` | Sufficient for aggregated counters; do not retain battle objects. |
| Move history | `pokemon.move_learned` | Direct coverage exists, but deduplication and contextual moveset comparison are still required. |
| Script context | `script.command` | Hook, not a generic telemetry stream; use only for proven narrow contexts. |
| Save checkpoint | `save.writing` | Final low-frequency reconciliation point where appropriate. |

## Persistence boundary

Use `mod.save` for the versioned Trainer Career root. Do not write an independent parallel store through `mod.storage`: that store deliberately does not rewind with checkpoints and is intended for independently durable tool records. Career truth must rewind with the playthrough.

Use `mon.extra.trainer_career = { id = "TC-000042" }` for identity only. Never store battle history or rendered strings on the Pokémon object.

## UI boundary

Follow the `example_dexnav` pattern:

- register screens through the public registry;
- insert one `TRAINER CAREER` row before `SAVE`;
- call the previous hook first and decorate its returned list;
- use stable screen IDs and public `mod.ui` helpers;
- persist event IDs and render localized text on demand.

This produces a menu that looks native and coexists with other menu mods.

## Known gaps requiring implementation audits

- Yellow first-partner versus other received Pokémon.
- Gift Pokémon paths beyond catches and link receipt.
- All Key Item acquisition paths.
- Release confirmation/cancellation and PC edge cases.
- Exact badge snapshot timing.
- Hall of Fame snapshot/final-battle context.
- Move replacement paths not covered by the direct event.
- Existing-save party/box/Day Care normalization, including current-box mirrors.

None of these gaps justifies continuous polling or a generic reconcile-everything loop.
