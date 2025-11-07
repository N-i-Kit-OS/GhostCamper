extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 520.0
@export var spawn_interval: float = 1.2
@export var girl_max_health: int = 100
@export var damage_per_hit: int = 20  # урон за касание

@onready var girl: Area2D = $Girl
@onready var spawn_timer: Timer = $SpawnTimer
@onready var health_bar: ProgressBar = $HUD/HUDRoot/HealthBar
@onready var kills_label: Label = $HUD/HUDRoot/Progress
var killed: int = 0

var girl_health: int

func _ready() -> void:
	kills_label.text = "0"
	randomize()
	girl.global_position = get_viewport_rect().size * 0.5
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timeout)
	health_bar.min_value = 0
	health_bar.max_value = 100
	health_bar.value = 100
	
	# Инициализируем здоровье девушки
	girl_health = girl_max_health
	girl.area_entered.connect(_on_girl_area_entered)  # меняем на area_entered

func _on_spawn_timeout() -> void:
	var enemy := enemy_scene.instantiate()
	add_child(enemy)
	var unit := enemy.get_node("Men") as Area2D
	unit.global_position = _random_edge_position()
	unit.set("target", girl)
	unit.connect("died", _on_enemy_died)

func _random_edge_position() -> Vector2:
	var a := randf() * TAU
	return girl.global_position + Vector2(cos(a), sin(a)) * spawn_radius

func _on_girl_area_entered(area: Area2D) -> void:  # меняем на area_entered
	# Если коснулся враг - отнимаем ХП
	if area.is_in_group("enemies"):
		girl_health -= damage_per_hit
		health_bar.value = float(girl_health) / girl_max_health * 100
		area.call_deferred("queue_free")  # Удаляем врага после касания
		
		# Если ХП закончилось - рестарт
		if girl_health <= 0:
			get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/game_over.tscn")

func _process(_delta: float) -> void:
	pass  # Убираем старую логику

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
