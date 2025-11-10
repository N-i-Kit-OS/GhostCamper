# Ghost Camper (Godot 4.5)

Niewielka top‑down arcade na Godot 4.5. Celem jest przetrwać falę i zlikwidować wszystkich przeciwników.

## Jak uruchomić
- Otwórz `project.godot` w Godot 4.5.
- Główna scena: `scenes/game/main.tscn`.
- Sterowanie: LPM — zabicie/cios, ESC — pauza, F11 — przełączanie pełnego ekranu.

## Struktura
```
res://
├─ autoload/
│  └─ game_manager.gd
├─ scenes/
│  ├─ entities/enemy.tscn
│  ├─ game/main.tscn
│  └─ ui/
│     ├─ main_menu.tscn
│     ├─ level_select.tscn
│     ├─ pause_menu.tscn
│     ├─ game_over.tscn
│     └─ victory.tscn
├─ resources/
│  ├─ enemies/
│  │  ├─ basic_enemy.tres
│  │  ├─ fast_enemy.tres
│  │  └─ tank_enemy.tres
│  └─ levels/
│     └─ level_1.tres
├─ scripts/
│  ├─ entities/enemy.gd
│  ├─ game/main.gd
│  └─ ui/
│     ├─ main_menu.gd
│     ├─ level_select.gd
│     ├─ pause_menu.gd
│     ├─ game_over.gd
│     └─ victory.gd
└─ scripts/resources/
   ├─ enemy_type.gd
   └─ level_config.gd
```

## Stan gry
- Domyślnie pełny ekran, bazowa rozdzielczość: 1920×1080 (Stretch: `canvas_items`, Aspect: `keep`).
- Przeciwnicy spawnują się poza ekranem i podążają do bohaterki.
- Typy przeciwników definiowane przez zasoby `EnemyType` (`basic/fast/tank`) i losowane z wagami.
- Parametry poziomu z `LevelConfig` (`resources/levels/level_1.tres`):
  - `total_enemies`, `spawn_radius`, `spawn_interval_min/max`, `girl_max_health`, `damage_per_hit`,
  - `speed_multiplier_min/max` (narastanie szybkości w czasie),
  - tablice `enemy_types` i `enemy_weights`.
- HUD: pasek HP w lewym górnym rogu, licznik zabójstw wycentrowany u góry (Control ma `Mouse Filter: Ignore`, więc nie blokuje kliknięć).
- Pauza (ESC). Ekran porażki (`game_over.tscn`). Ekran zwycięstwa (`victory.tscn`) po wybiciu wszystkich zespawnowanych wrogów.

## Szczegóły rozgrywki
- Kontakt wroga z bohaterką zadaje obrażenia (`damage_per_hit`). Przy 0 HP — `Game Over`.
- Kliknięcie w wroga zmniejsza jego „życie kliknięciowe”; przy 0 emituje `died` i znika.
- Spawn sterowany timerem w przedziale `[spawn_interval_min; spawn_interval_max]` i zatrzymuje się po `total_enemies`.
- Zwycięstwo: gdy `spawned >= total_enemies` oraz `active_enemies == 0` (liczone na scenie).

## Nowości w tej iteracji
- Integracja `LevelConfig` w `main.gd` (brak hardcodu parametrów i typów wrogów).
- Losowanie ważone typów wrogów, dynamiczny interwał spawnu, wzrost szybkości w czasie.
- Spawn poza krawędzią ekranu z uwzględnieniem bieżącej rozdzielczości.
- HUD wycentrowany; elementy UI nie przechwytują myszy (`Mouse Filter: Ignore`).
- Dodany ekran zwycięstwa oraz poprawna logika zakończenia poziomu.
- Skrót F11 do przełączania pełnego ekranu.

## Plany
- Ekran wyników (czas, zabójstwa, otrzymane obrażenia) na zwycięstwie.
- Progresja poziomów (kilka `LevelConfig`, przejścia, zapisy).
- Dźwięki (klik, obrażenia, zwycięstwo) i proste VFX trafień.
- Balans: płynne zmniejszanie interwału spawnu, mini‑fale.

## Ustawienia okna (dla przypomnienia)
- Project → Project Settings → Display → Window: Mode=Fullscreen, Stretch=`canvas_items`, Aspect=`keep`.
- Zmiana bazowej rozdzielczości może wymagać korekty rozmiarów czcionek w UI (Theme Overrides → Font Sizes).

