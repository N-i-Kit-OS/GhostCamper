extends Area2D
signal died

@export var speed: float = 120.0
@export var clicks_to_kill: int = 1

var target: Node2D

func _ready() -> void:
	input_pickable = true
	add_to_group("enemies")

func setup(type: EnemyType, target_node: Node2D) -> void:
	speed = type.base_speed
	clicks_to_kill = type.clicks_to_kill
	target = target_node

func _process(delta: float) -> void:
	if target:
		var dir := (target.global_position - global_position).normalized()
		global_position += dir * speed * delta

func _input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicks_to_kill -= 1
		if clicks_to_kill <= 0:
			died.emit()
			queue_free()
