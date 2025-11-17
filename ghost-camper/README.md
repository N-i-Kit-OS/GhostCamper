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
│  ├─ obstacles/
│  │  ├─ obstacle.tscn (bazowy blok)
│  │  └─ layouts/
│  │     └─ level_1/layout_*.tscn (szablony przeszkód)
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
│     ├─ level_1.tres (Комната девушки)
│     ├─ level_2.tres (Двор)
│     ├─ level_3.tres (Парк)
│     ├─ level_4.tres (Улица)
│     ├─ level_5.tres (Клуб)
│     └─ level_6.tres (Сон девушки)
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
- Przeszkody: hybrydowy system – w `LevelConfig` podajemy listę szablonów (`obstacle_layouts`), a `main.gd` losowo ładuje jedną scenę layoutu; obstacle to `StaticBody2D` z kolizją, format gotowy do rozbudowy.
- **6 poziomów** z narastającą trudnością (od 30 do 150 wrogów, różne prędkości i częstotliwość spawnu).
- Parametry każdego poziomu w `LevelConfig` (`resources/levels/level_*.tres`):
  - `total_enemies`, `spawn_radius`, `spawn_interval_min/max`, `girl_max_health`, `damage_per_hit`,
  - `speed_multiplier_min/max` (narastanie szybkości w czasie),
  - tablice `enemy_types`, `enemy_weights`, listy `obstacle_layouts`.
- System wyboru poziomów: `GameManager.current_level_config_path` ustawiany w `level_select.gd`, `main.gd` ładuje odpowiedni `LevelConfig` przy starcie.
- HUD: pasek HP w lewym górnym rogu, licznik zabójstw wycentrowany u góry (Control ma `Mouse Filter: Ignore`, więc nie blokuje kliknięć).
- Pauza (ESC). Ekran porażki (`game_over.tscn`). Ekran zwycięstwa (`victory.tscn`) po wybiciu wszystkich zespawnowanych wrogów.

## Szczegóły rozgrywki
- Kontakt wroga z bohaterką zadaje obrażenia (`damage_per_hit`). Przy 0 HP — `Game Over`.
- Kliknięcie w wroga zmniejsza jego „życie kliknięciowe”; przy 0 emituje `died` i znika.
- Spawn sterowany timerem w przedziale `[spawn_interval_min; spawn_interval_max]` i zatrzymuje się po `total_enemies`.
- Zwycięstwo: gdy `spawned >= total_enemies` oraz `active_enemies == 0` (liczone na scenie).
- Przeciwnicy to `CharacterBody2D` z wbudowaną kolizją (unikają przeszkód), a strefa trafień (`Area2D`) siedzi w środku – dzięki temu wciąż działają kliknięcia i urazy bohaterki.

## Nowości w tej iteracji
- Integracja `LevelConfig` w `main.gd` (brak hardcodu parametrów i typów wrogów).
- Losowanie ważone typów wrogów, dynamiczny interwał spawnu, wzrost szybkości w czasie.
- Spawn poza krawędzią ekranu z uwzględnieniem bieżącej rozdzielczości.
- HUD wycentrowany; elementy UI nie przechwytują myszy (`Mouse Filter: Ignore`).
- Dodany ekran zwycięstwa oraz poprawna logika zakończenia poziomu.
- Skrót F11 do przełączania pełnego ekranu.
- **Utworzono 6 poziomów** z wyważoną trudnością:
  - Level 1 (Комната девушки): 30 wrogów, łatwy start
  - Level 2 (Двор): 50 wrogów, umiarkowana trudność
  - Level 3 (Парк): 80 wrogów, pierwszy poważny wyzwanie
  - Level 4 (Улица): 100 wrogów, wysoka trudność
  - Level 5 (Клуб): 120 wrogów, ekstremalna trudność
  - Level 6 (Сон девушки): 150 wrogów, finałowy boss
- **System wyboru poziomów**: `GameManager` przechowuje `current_level_config_path`, `level_select.gd` ustawia odpowiedni poziom przed startem gry.
- Hybrydowy system przeszkód: bazowy `StaticBody2D` (`obstacle.tscn`) + zestaw layoutów; `LevelConfig.obstacle_layouts` pozwala losowo wczytać scenę z przeszkodami.
- Przeciwnicy przeniesieni na `CharacterBody2D` + wewnętrzny `Area2D` (Hitbox) – ruch reaguje na kolizje, ale klikanie/obrażenia działają jak wcześniej.

## Plany
- Ekran wyników (czas, zabójstwa, otrzymane obrażenia) na zwycięstwie.
- System zapisywania postępu (odblokowane poziomy, rekordy).
- **Przeszkody na poziomach** (hybrydowy system: predefiniowane szablony + losowy wybór).
- Mechanika omijania przeszkód przez wrogów (A* lub uproszczony algorytm).
- Dźwięki (klik, obrażenia, zwycięstwo) i proste VFX trafień.
- Mechanika ruchu bohaterki (dla poziomu 6).

## Ustawienia okna (dla przypomnienia)
- Project → Project Settings → Display → Window: Mode=Fullscreen, Stretch=`canvas_items`, Aspect=`keep`.
- Zmiana bazowej rozdzielczości może wymagać korekty rozmiarów czcionek w UI (Theme Overrides → Font Sizes).

