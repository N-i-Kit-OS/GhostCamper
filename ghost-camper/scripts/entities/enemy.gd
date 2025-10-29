extends Area2D

@export var speed: float = 120.0
@export var max_health: int = 1
var health: int
var target: Node2D

func _ready() -> void:
	health = max_health
	input_pickable = true
	add_to_group("enemies")
	monitoring = true  # убедись, что включено

func _process(delta: float) -> void:
	if target:
		var dir := (target.global_position - global_position).normalized()
		global_position += dir * speed * delta

func _input_event(_vp: Viewport, e: InputEvent, _i: int) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		health -= 1
		if health <= 0:
			queue_free()
