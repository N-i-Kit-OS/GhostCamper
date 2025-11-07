# Ghost Camper (Godot 4.5)

## Stan projektu

- **Silnik**: Godot Engine 4.5, projekt `ghost_camper` (prototyp roguelike/top-down).
- **Platforma**: PC, renderer Forward+.
- **Git**: repozytorium zainicjalizowane lokalnie, struktura katalogów uporządkowana; katalogi `.import`, `.godot`, pliki IDE itp. wpisane do `.gitignore`.
- **Gra**: `scenes/game/main.tscn` – statyczna arena z dziewczyną-trójkątem (`Girl`) i przeciwnikami-kwadratami (`Enemy`).

## Aktualna struktura

```
res://
├── autoload/
│   └── game_manager.gd
├── scenes/
│   ├── entities/
│   │   └── enemy.tscn
│   ├── game/
│   │   └── main.tscn
│   └── ui/
│       ├── MainMenu.tscn
│       ├── LevelSelect.tscn
│       ├── PauseMenu.tscn
│       └── GameOver.tscn
├── scripts/
│   ├── entities/
│   │   └── enemy.gd
│   ├── game/
│   │   └── main.gd
│   └── ui/
│       ├── main_menu.gd
│       ├── level_select.gd
│       ├── pause_menu.gd
│       └── game_over.gd
├── scripts/resources/
└── assets/
```

## Co działa

- **Pętla rozgrywki**: przeciwnicy pojawiają się cyklicznie, idą do dziewczyny, kliknięcie eliminuje przeciwnika. Kontakt zabiera HP; przy 0 HP przechodzimy do sceny `GameOver`.
- **HUD**: pasek zdrowia (ProgressBar) oraz licznik zabitych (`Progress`) wyśrodkowany u góry. Brak innych widżetów.
- **Pauza**: ESC otwiera `PauseMenu` (CanvasLayer z przyciemnieniem i przyciskami "Kontynuuj / Rrestart / Menu").
- **Menu**: `MainMenu` → `LevelSelect` → start `main.tscn`. Przycisk "Nazad" wraca do menu.
- **Game Over**: przyciemnienie + przyciski "Restart / W menu".
- **Sygnały**: skrypt `enemy.gd` emituje `died`, `main.gd` zlicza zabitych.
- **Zdrowie**: zarządzane przez `damage_per_hit`, usuwanie przeciwników i restart sceny obsługiwane przez `call_deferred`.
- **HUD**: warstwa `HUD` to CanvasLayer z wewnętrznym Control, elementy pozycjonowane przez Layout.

## Technologie / szczegóły

- GDScript (Godot 4.5).
- Sceny `.tscn`, skrypty `.gd`, Unicode tylko w tekstach UI.
- Uzły Area2D/Node2D, Timery, sygnały.
- CanvasLayer dla interfejsu.
- `GameManager` (autoload) – obecnie prosty enum stanu, planowany rozwój.
- Brak jeszcze zasobów `.tres` (EnemyType/LevelConfig planowane).

## Zachowanie gry

1. Uruchomienie → `MainMenu` → `LevelSelect` → `main.tscn`.
2. Dziewczyna stoi w centrum; wrogowie spawnują się na promieniu 520 i poruszają się do niej.
3. Licznik zabitych startuje od 0 na środku ekranu; pasek HP w lewym górnym rogu.
4. Przy 0 HP scena `GameOver` z opcjami restart/menu.
5. Pauza (ESC) działa, zamyka się przyciskiem lub ponownym ESC.
6. Brak błędów przy śmierci (użycie `call_deferred`).

## Zadania na przyszłość

- Rozszerzyć `GameManager` o stany, progres, ekran zwycięstwa.
- Dodać zasoby konfiguracyjne (EnemyType, LevelConfig), różne typy przeciwników i krzywe spawnów.
- Przygotować ekran rezultatu (czas, zabici, rankingi) oraz ekran zwycięstwa.
- Wprowadzić progresję poziomów (blokada/odblokowanie) i zapisy.
- Polishing: art, VFX, dźwięk.

Tę notkę można wykorzystać przy przeniesieniu projektu lub odtworzeniu kontekstu w nowym czacie.

