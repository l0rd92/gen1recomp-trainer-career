# Testing strategy

Tests should not require completing a game manually.

## ROM-free tests

- manifest validation and lint;
- clean API-2 loader startup for Gen 1;
- schema migrations and idempotence;
- TC ID allocation, malformed IDs and duplicates;
- counters, ties and biggest-hit records;
- Journey append/deduplication and first-location sets;
- synthetic event aggregation;
- synthetic party, box, Day Care and current-box-mirror states.

## Private integration tests

- Red, Blue and Yellow basic saves;
- complete-dex Red/Blue and Yellow saves;
- YOSHIRA: exactly 202 logical Mew and 202 distinct OT IDs;
- full boxes, long Journey and high counters;
- repeated Hall of Fame and release confirm/cancel.

Private tests must accept fixture paths through local configuration and skip clearly when fixtures are unavailable.

## Performance gates

- no continuous watcher;
- no full Pokémon scan on hot battle events;
- no disk/save write per move or damage event;
- no persistent turn log;
- records calculated lazily where possible.
