extends CharacterBody2D
signal died

@export var speed: float = 120.0
@export var clicks_to_kill: int = 1
@export var click_radius: float = 30.0  # радиус клика

@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_shape: CollisionShape2D = hitbox.get_node_or_null("CollisionShape2D")

var target: Node2D
var waypoints: Array[Vector2] = []
var current_wp: int = 0

func _ready() -> void:
	hitbox.input_pickable = true
	hitbox.add_to_group("enemies")
	hitbox.input_event.connect(_on_hitbox_input_event)

	# Увеличиваем hitbox под радиус клика
	if hitbox_shape and hitbox_shape.shape is CircleShape2D:
		hitbox_shape.shape.radius = click_radius

func setup(type: EnemyType, target_node: Node2D, spawn_marker: Node2D) -> void:
	speed = type.base_speed
	clicks_to_kill = type.clicks_to_kill
	target = target_node

	waypoints.clear()
	current_wp = 0

	# Собираем точки пути как детей spawn_marker
	if spawn_marker:
		for child in spawn_marker.get_children():
			if child is Node2D:
				waypoints.append((child as Node2D).global_position)

func _physics_process(_delta: float) -> void:
	var target_pos: Vector2

	# 1) Идём по waypoints, если они есть
	if current_wp < waypoints.size():
		target_pos = waypoints[current_wp]
		if global_position.distance_to(target_pos) < 8.0:
			current_wp += 1
		else:
			_move_towards(target_pos)
			return

	# 2) Когда точки закончились, идём к девушке
	if target:
		target_pos = target.global_position
		_move_towards(target_pos)

func _move_towards(target_pos: Vector2) -> void:
	var dir := (target_pos - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

func _on_hitbox_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicks_to_kill -= 1
		if clicks_to_kill <= 0:
			died.emit()
			queue_free()
