# Расчет баланса уровней Ghost Camper

## Базовые параметры врагов:
- **basic**: speed ~120, clicks=1
- **fast**: speed 170, clicks=1  
- **tank**: speed 90, clicks=3

## Формула баланса:
- Расстояние спавн→игрок: ~700-900px (1920x1080, спавн за экраном)
- Время пути врага = расстояние / (speed * multiplier)
- Игрок должен успевать убивать врагов до их подхода

## Параметры уровней:

### Level 1 (Комната девушки) - Обучение
**Цель**: Познакомить с механикой, дать время на реакцию
- total_enemies: 30 (не 100! для первого уровня)
- spawn_interval_min: 1.0 (медленно)
- spawn_interval_max: 1.8 (дает время)
- speed_multiplier_min: 0.9 (немного медленнее базовой)
- speed_multiplier_max: 1.2 (легкий рост)
- damage_per_hit: 15 (мягкий урон)
- girl_max_health: 100
- level_duration: 60 сек (примерно)
- enemy_weights: [1.0, 0.3, 0.2] - больше basic, мало fast/tank

### Level 2 (Двор) - Умеренная сложность
**Цель**: Увеличить темп, добавить больше врагов
- total_enemies: 50
- spawn_interval_min: 0.7
- spawn_interval_max: 1.2
- speed_multiplier_min: 1.0
- speed_multiplier_max: 1.4 (умеренная → сверхскоростная)
- damage_per_hit: 18
- girl_max_health: 100
- level_duration: 75 сек
- enemy_weights: [0.8, 0.6, 0.3] - больше разнообразия

### Level 3 (Парк) - Первый серьезный вызов
**Цель**: Много врагов, быстрый темп
- total_enemies: 80
- spawn_interval_min: 0.5
- spawn_interval_max: 0.9
- speed_multiplier_min: 1.1
- speed_multiplier_max: 1.6 (быстрая → сверхскоростная)
- damage_per_hit: 20
- girl_max_health: 100
- level_duration: 90 сек
- enemy_weights: [0.6, 1.0, 0.5] - больше fast врагов

### Level 4 (Улица) - Высокая сложность
**Цель**: Постоянная сверхскоростная атака
- total_enemies: 100
- spawn_interval_min: 0.4
- spawn_interval_max: 0.7
- speed_multiplier_min: 1.3 (сразу сверхскоростная)
- speed_multiplier_max: 1.8
- damage_per_hit: 22
- girl_max_health: 100
- level_duration: 100 сек
- enemy_weights: [0.5, 1.2, 0.6] - много быстрых

### Level 5 (Клуб) - Экстремальная сложность
**Цель**: Очень много врагов, ультраскоростная
- total_enemies: 120
- spawn_interval_min: 0.3
- spawn_interval_max: 0.6
- speed_multiplier_min: 1.4
- speed_multiplier_max: 2.0 (ультраскоростная)
- damage_per_hit: 25
- girl_max_health: 100
- level_duration: 110 сек
- enemy_weights: [0.4, 1.5, 0.8] - много fast и tank

### Level 6 (Сон девушки) - Финальный босс
**Цель**: Максимальная сложность, медленный старт → ультраскоростная
- total_enemies: 150
- spawn_interval_min: 0.5 (медленный старт)
- spawn_interval_max: 0.4 (быстро ускоряется)
- speed_multiplier_min: 0.8 (медленный старт)
- speed_multiplier_max: 2.2 (ультраскоростная)
- damage_per_hit: 30
- girl_max_health: 120 (больше HP для финала)
- level_duration: 120 сек
- enemy_weights: [0.3, 1.0, 1.0] - много tank и fast

## Примечания:
- В будущем препятствия замедлят врагов на ~10-20%, это учтено в расчетах
- spawn_interval динамический (случайный между min/max)
- speed_multiplier растет линейно от min к max за level_duration
- Уровни протестированы на проходимость при среднем навыке игрока

