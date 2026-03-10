extends CharacterBody2D
signal died

@export var speed: float = 120.0
@export var clicks_to_kill: int = 1
@export var click_radius: float = 60.0
@export var collision_offset_y: float = 0.0


@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_shape: CollisionShape2D = hitbox.get_node_or_null("CollisionShape2D")
@onready var enemy_animated_sprite: AnimatedSprite2D = $Hitbox/EnemyAnimatedSprite
@onready var flip_flop_timer: Timer = $FlipFlopTimer 
@onready var tap_effect_sprite: Sprite2D = $TapEffectSprite
@onready var tap_effect_timer: Timer = $TapEffectTimer
@onready var tap_fade_animation_player: AnimationPlayer = $TapFadeAnimationPlayer
@onready var enemy_death_sound: AudioStreamPlayer = $AudioStreamPlayer

var target: Node2D
var waypoints: Array[Vector2] = []
var current_wp: int = 0

var is_dying: bool = false
var is_flipping: bool = false

func _ready() -> void:
	hitbox.input_pickable = true
	hitbox.add_to_group("enemies")
	hitbox.input_event.connect(_on_hitbox_input_event)

	if hitbox_shape and hitbox_shape.shape is CircleShape2D:
		hitbox_shape.shape.radius = click_radius

	tap_effect_timer.timeout.connect(_on_tap_effect_timeout)

func setup(type: EnemyType, target_node: Node2D, spawn_marker: Node2D) -> void:
	speed = type.base_speed
	clicks_to_kill = type.clicks_to_kill
	target = target_node

	if type.sprite_frames:
		enemy_animated_sprite.sprite_frames = type.sprite_frames

	enemy_animated_sprite.visible = true
	enemy_animated_sprite.scale = type.scale_factor
	is_dying = false
	
	tap_effect_sprite.visible = false

	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("collision_layer", 1)
	hitbox.set_deferred("collision_mask", 1)
	set_deferred("collision_layer", 1)
	set_deferred("collision_mask", 1)
	if $CollisionShape2D: $CollisionShape2D.set_deferred("disabled", false)

	waypoints.clear()
	current_wp = 0

	
	if spawn_marker:
		for child in spawn_marker.get_children():
			if child is Node2D:
				waypoints.append((child as Node2D).global_position)

func _physics_process(_delta: float) -> void:
	if is_dying:
		return

	var target_pos: Vector2

	if current_wp < waypoints.size():
		target_pos = waypoints[current_wp]
		if (global_position + Vector2(0, collision_offset_y)).distance_to(target_pos) < 16.0: 
			current_wp += 1
		else:
			_move_towards(target_pos)
			return

	if target:
		target_pos = target.global_position
		_move_towards(target_pos)

func _move_towards(target_pos: Vector2) -> void:
	var adjusted_target_pos = target_pos - Vector2(0, collision_offset_y)

	var dir := (adjusted_target_pos - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

	var current_animation: String = "walk_down" 
	var angle_rad = velocity.angle()

	var quarter_pi = PI / 4.0
	var three_quarter_pi = 3.0 * PI / 4.0
	
	if angle_rad >= -quarter_pi and angle_rad < quarter_pi:
		current_animation = "walk_right"
	elif angle_rad >= quarter_pi and angle_rad < three_quarter_pi:
		current_animation = "walk_down"
	elif angle_rad >= three_quarter_pi or angle_rad < -three_quarter_pi:
		current_animation = "walk_left"
	elif angle_rad >= -three_quarter_pi and angle_rad < -quarter_pi:
		current_animation = "walk_up"

	if enemy_animated_sprite.animation != current_animation:
		enemy_animated_sprite.play(current_animation)

func _on_hitbox_input_event(_viewport, event, _shape_idx) -> void:
	if is_dying:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicks_to_kill -= 1
		if clicks_to_kill <= 0:
			_start_death_sequence("tap")

func _on_tap_effect_timeout() -> void:
	tap_fade_animation_player.play("fade_out_tap")
	tap_fade_animation_player.animation_finished.connect(_on_animation_finished_and_queue_free, CONNECT_ONE_SHOT)

func _on_animation_finished_and_queue_free(_anim_name: String) -> void:
	died.emit()
	queue_free()

func get_is_dying() -> bool:
	return is_dying

func _start_death_sequence(death_type: String) -> void:
	if is_dying:
		return

	is_dying = true

	enemy_animated_sprite.visible = false
	
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("collision_layer", 0)
	hitbox.set_deferred("collision_mask", 0)
	
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	if $CollisionShape2D: $CollisionShape2D.set_deferred("disabled", true)

	flip_flop_timer.stop() 

	tap_effect_sprite.visible = false

	if death_type == "tap":
		enemy_death_sound.play()
		
		tap_effect_sprite.top_level = true 
		tap_effect_sprite.global_position = global_position
		tap_effect_sprite.visible = true
		tap_effect_timer.start()
	elif death_type == "bad_end":
		tap_fade_animation_player.play("Bad")
