# Ghost Camper (Godot 4.5)

A small top-down arcade game built in Godot 4.5. The goal is to survive the wave and eliminate all enemies to protect the girl.

## How to Run
- Open `project.godot` in Godot 4.5 (tested on Godot 4.5).
- Main scene: `scenes/game/main.tscn`.
- Controls:
  - **LMB (Left Mouse Button)**: Attack/kill enemies
  - **ESC**: Pause game
  - **F11**: Toggle fullscreen mode

## Game Overview
Ghost Camper is a defense arcade game where players must protect a girl from waves of enemies by clicking on them before they reach her. The game features 3 progressively difficult levels, each with unique settings and enemy configurations.

## Project Structure
```
res://
├─ autoload/
│  └─ game_manager.gd              # Global game state manager (singleton)
├─ scenes/
│  ├─ entities/
│  │  └─ enemy.tscn                # Enemy scene (CharacterBody2D + Hitbox)
│  ├─ game/
│  │  └─ main.tscn                 # Main game scene
│  ├─ obstacles/
│  │  ├─ obstacle.tscn             # Base obstacle (StaticBody2D)
│  │  └─ layouts/
│  │     ├─ level_1/
│  │     │  └─ layout_1.tscn       # Room level obstacles
│  │     ├─ level_2/
│  │     │  └─ layout_1.tscn       # Yard level obstacles
│  │     └─ level_3/
│  │        └─ layout_1.tscn       # Park level obstacles
│  └─ ui/
│     ├─ theme/
│     │  └─ main_ui_theme.tres     # Custom UI theme
│     ├─ main_menu.tscn            # Main menu screen
│     ├─ level_select.tscn         # Level selection screen
│     ├─ pause_menu.tscn           # Pause menu
│     ├─ game_over.tscn            # Game over screen ("Любви конец")
│     ├─ victory.tscn              # Victory screen
│     └─ settings_menu.tscn        # Settings menu (cursor options)
├─ resources/
│  ├─ enemies/
│  │  ├─ basic_enemy.tres          # Basic enemy type (1 click, speed 120)
│  │  ├─ fast_enemy.tres           # Fast enemy type (1 click, speed 170)
│  │  └─ tank_enemy.tres           # Tank enemy type (3 clicks, speed 90)
│  ├─ levels/
│  │  ├─ level_1.tres.tres         # Room level (Комната девушки)
│  │  ├─ level_2.tres              # Yard level (Двор)
│  │  └─ level_3.tres              # Park level (Парк)
│  ├─ basic_man.tres               # SpriteFrames for basic enemy
│  ├─ fast_man.tres                # SpriteFrames for fast enemy
│  └─ tank_man.tres                # SpriteFrames for tank enemy
├─ scripts/
│  ├─ entities/
│  │  └─ enemy.gd                  # Enemy behavior script
│  ├─ game/
│  │  └─ main.gd                   # Main game logic
│  ├─ obstacle/
│  │  └─ obstacle.gd               # Obstacle script (currently empty)
│  ├─ resources/
│  │  ├─ enemy_type.gd             # EnemyType resource class
│  │  └─ level_config.gd           # LevelConfig resource class
│  └─ ui/
│     ├─ main_menu.gd              # Main menu logic
│     ├─ level_select.gd           # Level selection logic
│     ├─ pause_menu.gd             # Pause menu logic
│     ├─ game_over.gd              # Game over screen logic
│     ├─ victory.gd                # Victory screen logic
│     └─ settings_menu.gd          # Settings menu logic
├─ assets/
│  ├─ actors/                      # Character sprites and animations
│  ├─ backgrounds/                 # Level background images
│  ├─ music/                       # Sound effects and background music
│  └─ ui/                          # UI assets (cursor, buttons, icons)
└─ project.godot                    # Godot project configuration
```

## Game Configuration
- **Default Resolution**: 1920×1080 (Fullscreen mode)
- **Stretch Mode**: `canvas_items`
- **Aspect Ratio**: `keep`
- **Base Health**: 100 HP (displayed as 5-heart icon in HUD)

### Enemy Types
| Type | Clicks to Kill | Base Speed | Description |
|------|---------------|------------|-------------|
| **Basic** | 1 | 120 | Standard enemy, balanced |
| **Fast** | 1 | 170 | Quick but fragile, harder to click |
| **Tank** | 3 | 90 | Slow but requires multiple clicks |

### Levels
| Level | Name | Total Enemies | Spawn Interval | Speed Multiplier | Damage per Hit |
|-------|------|---------------|----------------|------------------|----------------|
| **1** | Room (Комната девушки) | 30 | 1.0 - 1.8s | 0.9 - 1.2 | 15 |
| **2** | Yard (Двор) | 50 | 0.7 - 1.2s | 1.0 - 1.4 | 18 |
| **3** | Park (Парк) | 80 | 0.5 - 0.9s | 1.1 - 1.6 | 20 |

**Note**: Enemy speed increases linearly throughout the level duration. Enemy spawn uses weighted random selection based on `enemy_weights` array in LevelConfig.

## Gameplay Mechanics
- **Health System**: Girl has a health bar (5-heart icon). Each enemy contact deals `damage_per_hit` damage. At 0 HP, game over is triggered.
- **Enemy Click-Kill**: Clicking an enemy reduces their "click life". At 0, the enemy dies with a "tap" effect and sound.
- **Spawn System**: Enemies spawn at random edge positions (outside screen) using a timer with interval `[spawn_interval_min; spawn_interval_max]`. Spawning stops after `total_enemies` have been spawned.
- **Victory Condition**: Win when `spawned >= total_enemies` AND `active_enemies == 0` (all spawned enemies eliminated).
- **Enemy Movement**: Enemies are `CharacterBody2D` with built-in collision detection (they avoid obstacles). Hitbox (`Area2D`) is inside the enemy for click detection and girl damage.
- **Waypoint System**: Enemies can follow waypoint paths defined by spawn markers in level layouts for more strategic movement patterns.
- **Speed Progression**: Enemy speed multiplier increases linearly from `speed_multiplier_min` to `speed_multiplier_max` over `level_duration`.

### HUD Elements
- **Health Icon**: Top-left corner, shows 5-heart texture based on current HP ratio
- **Kill Counter**: Top-center, displays current kill count (Control has `Mouse Filter: Ignore` to not block clicks)

### Game States (GameManager)
- `MAIN_MENU`: Initial state, main menu active
- `PLAYING`: Game in progress
- `PAUSED`: Game paused (via ESC)
- `GAME_OVER`: Player lost

### Cursor Modes (Settings)
- **System**: Default OS cursor
- **Crosshair**: Custom pixel-art crosshair (default)
- **Hand**: Custom pixel-art hand cursor

## Features & Recent Updates
- **LevelConfig Integration**: All level parameters loaded from resource files (no hardcoded values in `main.gd`)
- **Weighted Enemy Spawning**: Enemies selected randomly based on configurable weights
- **Dynamic Spawn Interval**: Random interval between min/max values for varied pacing
- **Progressive Speed Increase**: Enemy speed scales linearly throughout the level
- **Edge Spawn System**: Enemies spawn outside screen edge based on current viewport resolution
- **Centered HUD**: UI elements properly positioned; UI controls don't block mouse clicks (`Mouse Filter: Ignore`)
- **Victory Screen**: Dedicated victory scene after eliminating all enemies
- **Fullscreen Toggle**: F11 hotkey to switch fullscreen mode
- **Advanced Enemy Pathfinding**: Waypoint system allows enemies to follow predefined paths around obstacles
- **Enemy Walking Animation**: AnimatedSprite2D with directional walking animations (up/down/left/right)
- **Bad End Animation**: Special heart animation plays when enemy reaches the girl (before game over screen)
- **Victory Animation**: Special animation plays upon level completion
- **Redesigned UI**: All menu scenes (main menu, level select, pause, game over, victory) feature custom backgrounds and unified pixel-art button theme
- **Settings Menu**: Option to switch between system, crosshair, and hand cursor modes
- **UI Click Sounds**: All menu buttons play click sound effects
- **Enemy Hit Sound**: "Puk" sound plays when clicking an enemy
- **Girl Voice Cry**: Audio plays at the start of each level
- **Background Music**: Main menu features background music (`fon_menu.mp3`)
- **3 Levels**: Adjusted to 3 balanced levels (removed levels 4, 5, 6)
- **Level Select System**: `GameManager` stores `current_level_config_path`, `level_select.gd` sets the level before starting
- **Hybrid Obstacle System**: Base `StaticBody2D` (`obstacle.tscn`) + layout scenes; `LevelConfig.obstacle_layouts` allows random loading of obstacle layouts
- **Enemy CharacterBody2D**: Enemies use `CharacterBody2D` + internal `Area2D` (Hitbox) – movement reacts to collisions, but clicking/damage works as before
- **Critical Bug Fixes**: Fixed numerous issues with incorrect node paths, duplicate signal connections, broken resource loading, and GameManager references, significantly improving game stability

## Audio Assets
### Music
- `fon_menu.mp3`: Background music for main menu
- `cry.mp3`: Girl's voice cry at level start

### Sound Effects
- `click.mp3`: UI button click sound
- `puk.mp3`: Enemy hit/death sound

## Technical Details
### Resource Classes
- **EnemyType** (`scripts/resources/enemy_type.gd`): Defines enemy properties (scene, clicks_to_kill, base_speed, sprite_frames, scale_factor)
- **LevelConfig** (`scripts/resources/level_config.gd`): Defines level configuration (enemy types, weights, spawn parameters, health, damage, speed multipliers, obstacle layouts, girl texture, target position)

### Key Nodes & Scenes
- **Girl**: `Area2D` node in main scene that detects enemy collisions
- **Hitbox**: `Area2D` child of enemy for click detection
- **SpawnTimer**: Timer controlling enemy spawn rate
- **Obstacles**: `Node2D` parent for dynamically loaded obstacle layouts
- **window_spawn**: Node group for waypoint spawn points in obstacle layouts

### Signals
- `GameManager.state_changed(state: State)`: Emitted when game state changes
- `Enemy.died`: Emitted when enemy is killed

## Future Plans
- Score screen (time, kills, damage taken) on victory
- Progress save system (unlocked levels, high scores)
- Girl movement mechanics (for future levels)

## Window Settings (Reference)
- Project → Project Settings → Display → Window: Mode=Fullscreen, Stretch=`canvas_items`, Aspect=`keep`.
- Changing base resolution may require adjusting UI font sizes (Theme Overrides → Font Sizes).

## Additional Documentation
- See `LEVEL_BALANCE_CALCULATIONS.md` for detailed level balance calculations and design notes.

---

## Обзор игры
Ghost Camper — это аркадная игра в жанре защиты, где игрок должен защитить девушку от волн врагов, кликая по ним до того, как они достигнут её. Игра содержит 3 уровня с возрастающей сложностью, каждый со своими настройками и конфигурациями врагов.

## Как запустить
- Откройте `project.godot` в Godot 4.5 (протестировано на Godot 4.5).
- Главная сцена: `scenes/game/main.tscn`.
- Управление:
  - **ЛКМ (левая кнопка мыши)**: Атака/убийство врагов
  - **ESC**: Пауза
  - **F11**: Переключение полноэкранного режима

## Структура проекта
```
res://
├─ autoload/
│  └─ game_manager.gd              # Глобальный менеджер состояния игры (синглтон)
├─ scenes/
│  ├─ entities/
│  │  └─ enemy.tscn                # Сцена врага (CharacterBody2D + Hitbox)
│  ├─ game/
│  │  └─ main.tscn                 # Основная игровая сцена
│  ├─ obstacles/
│  │  ├─ obstacle.tscn             # Базовое препятствие (StaticBody2D)
│  │  └─ layouts/
│  │     ├─ level_1/
│  │     │  └─ layout_1.tscn       # Препятствия уровня "Комната"
│  │     ├─ level_2/
│  │     │  └─ layout_1.tscn       # Препятствия уровня "Двор"
│  │     └─ level_3/
│  │        └─ layout_1.tscn       # Препятствия уровня "Парк"
│  └─ ui/
│     ├─ theme/
│     │  └─ main_ui_theme.tres     # Пользовательская тема интерфейса
│     ├─ main_menu.tscn            # Главное меню
│     ├─ level_select.tscn         # Меню выбора уровня
│     ├─ pause_menu.tscn           # Меню паузы
│     ├─ game_over.tscn            # Экран проигрыша ("Любви конец")
│     ├─ victory.tscn              # Экран победы
│     └─ settings_menu.tscn        # Меню настроек (выбор курсора)
├─ resources/
│  ├─ enemies/
│  │  ├─ basic_enemy.tres          # Тип обычного врага (1 клик, скорость 120)
│  │  ├─ fast_enemy.tres           # Тип быстрого врага (1 клик, скорость 170)
│  │  └─ tank_enemy.tres           # Тип танка (3 клика, скорость 90)
│  ├─ levels/
│  │  ├─ level_1.tres.tres         # Уровень "Комната девушки"
│  │  ├─ level_2.tres              # Уровень "Двор"
│  │  └─ level_3.tres              # Уровень "Парк"
│  ├─ basic_man.tres               # SpriteFrames для обычного врага
│  ├─ fast_man.tres                # SpriteFrames для быстрого врага
│  └─ tank_man.tres                # SpriteFrames для врага-танка
├─ scripts/
│  ├─ entities/
│  │  └─ enemy.gd                  # Скрипт поведения врага
│  ├─ game/
│  │  └─ main.gd                   # Основная игровая логика
│  ├─ obstacle/
│  │  └─ obstacle.gd               # Скрипт препятствия (пока пустой)
│  ├─ resources/
│  │  ├─ enemy_type.gd             # Класс ресурса EnemyType
│  │  └─ level_config.gd           # Класс ресурса LevelConfig
│  └─ ui/
│     ├─ main_menu.gd              # Логика главного меню
│     ├─ level_select.gd           # Логика выбора уровня
│     ├─ pause_menu.gd             # Логика меню паузы
│     ├─ game_over.gd              # Логика экрана проигрыша
│     ├─ victory.gd                # Логика экрана победы
│     └─ settings_menu.gd          # Логика меню настроек
├─ assets/
│  ├─ actors/                      # Спрайты персонажей и анимации
│  ├─ backgrounds/                 # Фоновые изображения уровней
│  ├─ music/                       # Звуковые эффекты и фоновая музыка
│  └─ ui/                          # Ресурсы интерфейса (курсор, кнопки, иконки)
└─ project.godot                    # Конфигурация проекта Godot
```

## Конфигурация игры
- **Разрешение по умолчанию**: 1920×1080 (полноэкранный режим)
- **Режим растяжки**: `canvas_items`
- **Соотношение сторон**: `keep`
- **Базовое здоровье**: 100 HP (отображается как 5 сердец в HUD)

### Типы врагов
| Тип | Кликов для убийства | Базовая скорость | Описание |
|-----|---------------------|------------------|----------|
| **Обычный (Basic)** | 1 | 120 | Стандартный враг, сбалансированный |
| **Быстрый (Fast)** | 1 | 170 | Быстрый, но хрупкий, сложнее попасть |
| **Танк (Tank)** | 3 | 90 | Медленный, но требует нескольких кликов |

### Уровни
| Уровень | Название | Всего врагов | Интервал спавна | Множитель скорости | Урон за удар |
|---------|----------|--------------|-----------------|-------------------|--------------|
| **1** | Комната девушки | 30 | 1.0 - 1.8 сек | 0.9 - 1.2 | 15 |
| **2** | Двор | 50 | 0.7 - 1.2 сек | 1.0 - 1.4 | 18 |
| **3** | Парк | 80 | 0.5 - 0.9 сек | 1.1 - 1.6 | 20 |

**Примечание**: Скорость врагов увеличивается линейно в течение длительности уровня. Спавн врагов использует взвешенный случайный выбор на основе массива `enemy_weights` в LevelConfig.

## Механика игры
- **Система здоровья**: У девушки есть полоска здоровья (иконка с 5 сердцами). Каждый контакт с врагом наносит урон `damage_per_hit`. При 0 HP игра заканчивается.
- **Убийство кликом**: Клик по врагу уменьшает его «жизнь кликов». При 0 враг умирает с эффектом «tap» и звуком.
- **Система спавна**: Враги появляются в случайных позициях за краем экрана через таймер с интервалом `[spawn_interval_min; spawn_interval_max]`. Спавн останавливается после `total_enemies`.
- **Условие победы**: Победа, когда `spawned >= total_enemies` И `active_enemies == 0` (все заспавненные враги уничтожены).
- **Движение врагов**: Враги — это `CharacterBody2D` со встроенной детекцией коллизий (избегают препятствий). Hitbox (`Area2D`) находится внутри врага для детекции кликов и нанесения урона девушке.
- **Система waypoints**: Враги могут следовать по заранее заданным маршрутам, определённым маркерами спавна в компоновках уровней, для более стратегического движения.
- **Прогрессия скорости**: Множитель скорости врагов увеличивается линейно от `speed_multiplier_min` до `speed_multiplier_max` в течение `level_duration`.

### Элементы HUD
- **Иконка здоровья**: Левый верхний угол, показывает текстуру с 5 сердцами на основе текущего соотношения HP
- **Счётчик убийств**: Центр вверху, отображает текущее количество убийств (Control имеет `Mouse Filter: Ignore`, чтобы не блокировать клики)

### Состояния игры (GameManager)
- `MAIN_MENU`: Начальное состояние, активно главное меню
- `PLAYING`: Игра в процессе
- `PAUSED`: Игра на паузе (через ESC)
- `GAME_OVER`: Игрок проиграл

### Режимы курсора (настройки)
- **System**: Стандартный курсор ОС
- **Crosshair**: Пользовательский пиксельный прицел (по умолчанию)
- **Hand**: Пользовательский пиксельный курсор-рука

## Возможности и последние обновления
- **Интеграция LevelConfig**: Все параметры уровня загружаются из файлов ресурсов (без жёстко закодированных значений в `main.gd`)
- **Взвешенный спавн врагов**: Враги выбираются случайно на основе настраиваемых весов
- **Динамический интервал спавна**: Случайный интервал между мин/макс значениями для разнообразия темпа
- **Прогрессивное увеличение скорости**: Скорость врагов масштабируется линейно в течение уровня
- **Система спавна за краем**: Враги появляются за краем экрана на основе текущего разрешения viewport
- **Центрированный HUD**: Элементы UI правильно позиционированы; элементы управления UI не блокируют клики мыши
- **Экран победы**: Специальная сцена победы после уничтожения всех врагов
- **Переключение полноэкранного режима**: Горячая клавиша F11
- **Продвинутая система путей врагов**: Система waypoints позволяет врагам следовать по заранее заданным путям вокруг препятствий
- **Анимация ходьбы врагов**: AnimatedSprite2D с направленными анимациями ходьбы (вверх/вниз/влево/вправо)
- **Анимация плохого конца**: Специальная анимация сердца воспроизводится, когда враг достигает девушки (перед экраном проигрыша)
- **Анимация победы**: Специальная анимация воспроизводится при завершении уровня
- **Обновлённый UI**: Все сцены меню (главное меню, выбор уровня, пауза, проигрыш, победа) имеют пользовательские фоны и единую тему кнопок в пиксельном стиле
- **Меню настроек**: Возможность переключения между системным курсором, прицелом и рукой
- **Звуки кликов UI**: Все кнопки меню воспроизводят звуковые эффекты клика
- **Звук попадания врага**: Звук «puk» воспроизводится при клике по врагу
- **Крик девушки**: Аудио воспроизводится в начале каждого уровня
- **Фоновая музыка**: Главное меню имеет фоновую музыку (`fon_menu.mp3`)
- **3 уровня**: Настроено 3 сбалансированных уровня (уровни 4, 5, 6 удалены)
- **Система выбора уровней**: `GameManager` хранит `current_level_config_path`, `level_select.gd` устанавливает уровень перед запуском
- **Гибридная система препятствий**: Базовый `StaticBody2D` (`obstacle.tscn`) + сцены компоновок; `LevelConfig.obstacle_layouts` позволяет случайную загрузку компоновок препятствий
- **Enemy CharacterBody2D**: Враги используют `CharacterBody2D` + внутренний `Area2D` (Hitbox) — движение реагирует на коллизии, но клики/урон работают как прежде
- **Исправление критических ошибок**: Исправлены многочисленные проблемы с неправильными путями узлов, дублированными подключениями сигналов, broken загрузкой ресурсов и ссылками GameManager, что значительно повысило стабильность игры

## Аудио ресурсы
### Музыка
- `fon_menu.mp3`: Фоновая музыка для главного меню
- `cry.mp3`: Крик девушки в начале уровня

### Звуковые эффекты
- `click.mp3`: Звук клика кнопки UI
- `puk.mp3`: Звук попадания/смерти врага

## Технические детали
### Классы ресурсов
- **EnemyType** (`scripts/resources/enemy_type.gd`): Определяет свойства врага (сцена, clicks_to_kill, base_speed, sprite_frames, scale_factor)
- **LevelConfig** (`scripts/resources/level_config.gd`): Определяет конфигурацию уровня (типы врагов, веса, параметры спавна, здоровье, урон, множители скорости, компоновки препятствий, текстура девушки, позиция назначения)

### Ключевые узлы и сцены
- **Girl**: Узел `Area2D` в основной сцене, который детектирует столкновения с врагами
- **Hitbox**: `Area2D` дочерний элемент врага для детекции кликов
- **SpawnTimer**: Таймер, управляющий частотой спавна врагов
- **Obstacles**: Родительский узел `Node2D` для динамически загружаемых компоновок препятствий
- **window_spawn**: Группа узлов для точек спавна waypoints в компоновках препятствий

### Сигналы
- `GameManager.state_changed(state: State)`: Излучается при изменении состояния игры
- `Enemy.died`: Излучается при убийстве врага

## Планы на будущее
- Экран результатов (время, убийства, полученный урон) при победе
- Система сохранения прогресса (открытые уровни, рекорды)
- Механика движения девушки (для будущих уровней)

## Настройки окна (для справки)
- Project → Project Settings → Display → Window: Mode=Fullscreen, Stretch=`canvas_items`, Aspect=`keep`.
- Изменение базового разрешения может потребовать корректировки размеров шрифтов в UI (Theme Overrides → Font Sizes).

## Дополнительная документация
- См. `LEVEL_BALANCE_CALCULATIONS.md` для подробных расчётов баланса уровней и заметок по дизайну.
