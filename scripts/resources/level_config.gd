extends Resource

class_name LevelConfig

@export var level_name: String = ""
@export var total_enemies: int = 100
@export var spawn_radius: float = 520.0
@export var spawn_interval_min: float = 0.5
@export var spawn_interval_max: float = 1.5
@export var level_duration: float = 60.0
@export var girl_max_health: int = 100
@export var damage_per_hit: int = 20

@export var enemy_types: Array[EnemyType] = []
@export var enemy_weights: Array[float] = [] 

@export var speed_multiplier_min: float = 1.0
@export var speed_multiplier_max: float = 1.3

@export var obstacle_layouts: Array[String] = [] 
@export var girl_texture: Texture2D
@export var target_position: Vector2
