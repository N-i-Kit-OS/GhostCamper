extends Node2D

@export var level_config: LevelConfig
@export var enemy_scene: PackedScene

@onready var girl: Area2D = $Girl
@onready var spawn_timer: Timer = $SpawnTimer
@onready var health_bar: ProgressBar = $HUD/HUDRoot/HealthBar
@onready var kills_label: Label = $HUD/HUDRoot/Progress

var active_enemies: int = 0
var killed: int = 0
var girl_health: int
var spawned: int = 0
var elapsed_time: float = 0.0

func _ready() -> void:
	if not level_config:
		push_error("LevelConfig не назначен!")
		return
		
	active_enemies = 0
	
	kills_label.text = "0"
	randomize()
	girl.global_position = get_viewport_rect().size * 0.5
	
	spawned = 0
	elapsed_time = 0.0
	
	spawn_timer.wait_time = level_config.spawn_interval_min
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timeout)
	
	health_bar.min_value = 0
	health_bar.max_value = level_config.girl_max_health
	health_bar.value = level_config.girl_max_health
	
	girl_health = level_config.girl_max_health
	girl.area_entered.connect(_on_girl_area_entered)

func _on_spawn_timeout() -> void:
	# Останавливаем спавн, если достигли лимита врагов
	if spawned >= level_config.total_enemies:
		spawn_timer.stop()
		return
	
	var type: EnemyType = _get_random_enemy_type()
	if not type:
		return
	
	var enemy := type.scene.instantiate()
	add_child(enemy)
	var unit := enemy.get_node("Men") as Area2D
	unit.global_position = _random_edge_position()
	unit.setup(type, girl)
	
	# Применяем множитель скорости, растущий со временем
	var m := _get_speed_multiplier()
	if "speed" in unit:
		unit.speed *= m
	
	unit.connect("died", _on_enemy_died)
	
	active_enemies += 1
	spawned += 1
	
	if spawned >= level_config.total_enemies and active_enemies == 0:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/victory.tscn")
	
	# Случайный интервал между min и max
	spawn_timer.wait_time = randf_range(level_config.spawn_interval_min, level_config.spawn_interval_max)

func _get_random_enemy_type() -> EnemyType:
	if level_config.enemy_types.is_empty():
		return null
	if level_config.enemy_weights.is_empty() or level_config.enemy_weights.size() != level_config.enemy_types.size():
		return level_config.enemy_types[randi() % level_config.enemy_types.size()]
	
	var total_weight: float = 0.0
	for w in level_config.enemy_weights:
		total_weight += w
	
	var r := randf() * total_weight
	var acc: float = 0.0
	for i in range(level_config.enemy_types.size()):
		acc += level_config.enemy_weights[i]
		if r <= acc:
			return level_config.enemy_types[i]
	return level_config.enemy_types[0]

func _get_speed_multiplier() -> float:
	if level_config.level_duration <= 0.0:
		return level_config.speed_multiplier_max
	var t := clampf(elapsed_time / level_config.level_duration, 0.0, 1.0)
	return lerpf(level_config.speed_multiplier_min, level_config.speed_multiplier_max, t)

func _random_edge_position() -> Vector2:
	var view := get_viewport_rect().size
	var center := girl.global_position
	var margin := 96.0
	var half_diag := sqrt(view.x * view.x + view.y * view.y) * 0.5
	var radius := maxf(level_config.spawn_radius, half_diag + margin)
	var a := randf() * TAU
	return center + Vector2(cos(a), sin(a)) * radius

func _on_girl_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		girl_health -= level_config.damage_per_hit
		health_bar.value = float(girl_health) / level_config.girl_max_health * 100
		active_enemies = max(active_enemies - 1, 0)
		area.call_deferred("queue_free")
		if girl_health <= 0:
			get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/game_over.tscn")

func _process(delta: float) -> void:
	elapsed_time += delta

const PAUSE_MENU := preload("res://scenes/ui/pause_menu.tscn")

func _unhandled_input(e: InputEvent) -> void:
	if e.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			return
		get_tree().paused = true
		var ui := PAUSE_MENU.instantiate()
		add_child(ui)

func _on_enemy_died() -> void:
	killed += 1
	kills_label.text = str(killed)
	active_enemies = max(active_enemies - 1, 0)
	
	if spawned >= level_config.total_enemies and active_enemies == 0:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/victory.tscn")
