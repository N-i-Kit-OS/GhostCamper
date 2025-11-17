extends Resource

class_name LevelConfig

@export var level_name: String = ""
@export var total_enemies: int = 100
@export var spawn_radius: float = 520.0
@export var spawn_interval_min: float = 0.5  # минимальный интервал
@export var spawn_interval_max: float = 1.5  # начальный интервал
@export var level_duration: float = 60.0  # длительность уровня в секундах
@export var girl_max_health: int = 100
@export var damage_per_hit: int = 20

# Типы врагов для этого уровня и их веса (вероятность появления)
@export var enemy_types: Array[EnemyType] = []
@export var enemy_weights: Array[float] = []  # должно совпадать с enemy_types по количеству

# Глобальный множитель скорости (растёт со временем)
@export var speed_multiplier_min: float = 1.0
@export var speed_multiplier_max: float = 1.3

# Шаблоны препятствий для этого уровня (гибридная система)
@export var obstacle_layouts: Array[String] = []  # Пути к .tscn файлам шаблонов
