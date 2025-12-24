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
│     ├─ victory.tscn
│     └─ settings_menu.tscn
├─ resources/
│  ├─ enemies/
│  │  ├─ basic_enemy.tres
│  │  ├─ fast_enemy.tres
│  │  └─ tank_enemy.tres
│  └─ levels/
│     ├─ level_1.tres (Комната девушки)
│     ├─ level_2.tres (Двор)
│     └─ level_3.tres (Парк)
├─ scripts/
│  ├─ effects/bad_end_effect.gd
│  ├─ entities/enemy.gd
│  ├─ game/main.gd
│  ├─ obstacle/obstacle.gd
│  └─ ui/
│     ├─ main_menu.gd
│     ├─ level_select.gd
│     ├─ pause_menu.gd
│     ├─ game_over.gd
│     ├─ victory.gd
│     └─ settings_menu.gd
├─ assets/
│  ├─ actors/
│  ├─ backgrounds/
│  └─ music/
└─ scripts/resources/
   ├─ enemy_type.gd
   └─ level_config.gd
```

## Stan gry
- Domyślnie pełny ekran, bazowa rozdzielczość: 1920×1080 (Stretch: `canvas_items`, Aspect: `keep`).
- Przeciwnicy spawnują się poza ekranem i podążają do bohaterki.
- Typy przeciwników definiowane przez zasoby `EnemyType` (`basic/fast/tank`) i losowane z wagami.
- Przeszkody: hybrydowy system – w `LevelConfig` podajemy listę szablonów (`obstacle_layouts`), a `main.gd` losowo ładuje jedną scenę layoutu; obstacle to `StaticBody2D` z kolizją, format gotowy do rozbudowy.
- **3 poziomy** z narastającą trudnością.
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
- Dodano ekran zwycięstwa oraz poprawna logika zakończenia poziomu.
- Skrót F11 do przełączania pełnego ekranu.
- **Dodano zaawansowany system ścieżek dla wrogów**, pozwalający im na omijanie przeszkód na poziomie, co czyni rozgrywkę bardziej dynamiczną.
- **Dodano animację "chodzenia" dla przeciwników**, urealniając ich ruch.
- **Wprowadzono animację "Złego Końca" (Bad End)**: gdy wróg dotrze do dziewczyny, przed ekranem porażki odtwarzana jest specjalna animacja serca.
- **Wprowadzono animację "Dobrego Końca" (Victory)**: po pomyślnym ukończeniu poziomu i uratowaniu dziewczyny, wyświetlana jest specjalna animacja zwycięstwa.
- **Odświeżono design WSZYSTKICH scen UI** (menu główne, wybór poziomu, pauza, porażka, zwycięstwo) z niestandardowym tłem i jednolitym motywem pikselowym dla przycisków.
- **Dodano menu ustawień** (`settings_menu.tscn`), umożliwiające przełączanie między niestandardowym a domyślnym kursorem myszy.
- **Zaimplementowano dźwięki kliknięć dla wszystkich przycisków UI** we wszystkich scenach menu.
- **Dodano dźwięk "puk" przy kliknięciu w przeciwnika.**
- **Dziewczyna wydaje okrzyk na początku każdego poziomu.**
- **W menu głównym dodano muzykę w tle.**
- **Skorygowano liczbę poziomów do 3** (usunięto poziomy 4, 5, 6).
- **System wyboru poziomów**: `GameManager` przechowuje `current_level_config_path`, `level_select.gd` ustawia odpowiedni poziom przed startem gry.
- Hybrydowy system przeszkód: bazowy `StaticBody2D` (`obstacle.tscn`) + zestaw layoutów; `LevelConfig.obstacle_layouts` pozwala losowo wczytać scenę z przeszkodami.
- Przeciwnicy przeniesieni na `CharacterBody2D` + wewnętrzny `Area2D` (Hitbox) – ruch reaguje na kolizje, ale klikanie/obrażenia działają jak wcześniej.
- **Usunięto liczne błędy krytyczne** związane z nieprawidłowymi ścieżkami węzłów, podwójnymi połączeniami sygnałów, błędnym ładowaniem zasobów i `GameManager`, co znacząco zwiększyło stabilność gry.

## Plany
- Ekran wyników (czas, zabójstwa, otrzymane obrażenia) na zwycięstwie.
- System zapisywania postępu (odblokowane poziomy, rekordy).
- Mechanika ruchu bohaterki (dla poziomu 6).

## Ustawienia okna (dla przypomnienia)
- Project → Project Settings → Display → Window: Mode=Fullscreen, Stretch=`canvas_items`, Aspect=`keep`.
- Zmiana bazowej rozdzielczości może wymagać korekty rozmiarów czcionek w UI (Theme Overrides → Font Sizes).