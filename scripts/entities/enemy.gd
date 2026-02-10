extends CharacterBody2D
signal died

@export var speed: float = 120.0
@export var clicks_to_kill: int = 1
@export var click_radius: float = 60.0
@export var collision_offset_y: float = 0.0


@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_shape: CollisionShape2D = hitbox.get_node_or_null("CollisionShape2D")
#@onready var enemy_sprite: Sprite2D = $Hitbox/EnemySprite
@onready var enemy_animated_sprite: AnimatedSprite2D = $Hitbox/EnemyAnimatedSprite
@onready var flip_flop_timer: Timer = $FlipFlopTimer 
@onready var tap_effect_sprite: Sprite2D = $TapEffectSprite
@onready var tap_effect_timer: Timer = $TapEffectTimer
@onready var tap_fade_animation_player: AnimationPlayer = $TapFadeAnimationPlayer

# Добавляем звук для исчезновения врага
@onready var enemy_death_sound: AudioStreamPlayer = $AudioStreamPlayer

var target: Node2D # Ссылка на цель (обычно узел Girl)
var waypoints: Array[Vector2] = []
var current_wp: int = 0

var is_dying: bool = false # Флаг, указывающий, что враг в процессе смерти
var is_flipping: bool = false # Переменная для отслеживания состояния зеркалирования

func _ready() -> void:
	hitbox.input_pickable = true
	hitbox.add_to_group("enemies")
	hitbox.input_event.connect(_on_hitbox_input_event)

	# Увеличиваем hitbox под радиус клика
	if hitbox_shape and hitbox_shape.shape is CircleShape2D:
		hitbox_shape.shape.radius = click_radius

	# Подключаем сигналы таймеров
	#flip_flop_timer.timeout.connect(_on_flip_flop_timeout)
	tap_effect_timer.timeout.connect(_on_tap_effect_timeout)

func setup(type: EnemyType, target_node: Node2D, spawn_marker: Node2D) -> void:
	speed = type.base_speed
	clicks_to_kill = type.clicks_to_kill
	target = target_node # Устанавливаем цель
	# enemy_sprite.texture = type.texture

	if type.sprite_frames:
		enemy_animated_sprite.sprite_frames = type.sprite_frames
		#enemy_animated_sprite.play("walk") # Запускаем анимацию

	enemy_animated_sprite.visible = true
	enemy_animated_sprite.scale = type.scale_factor
	is_dying = false # Сбрасываем флаг смерти для нового врага
	
	# Скрываем спрайты эффектов при спавне (они будут проявляться анимацией)
	tap_effect_sprite.visible = false

	# Сбрасываем коллизию до обычного состояния
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("collision_layer", 1) # Предполагаем, что 1 - это обычный слой врага
	hitbox.set_deferred("collision_mask", 1) # И обычная маска
	set_deferred("collision_layer", 1) # Для CharacterBody2D
	set_deferred("collision_mask", 1) # Для CharacterBody2D
	if $CollisionShape2D: $CollisionShape2D.set_deferred("disabled", false)

	waypoints.clear()
	current_wp = 0

	# Собираем точки пути как детей spawn_marker
	if spawn_marker:
		for child in spawn_marker.get_children():
			if child is Node2D:
				waypoints.append((child as Node2D).global_position)

func _physics_process(_delta: float) -> void:
	# Если враг умирает, он больше не должен двигаться или взаимодействовать
	if is_dying:
		return

	var target_pos: Vector2

	# 1) Идём по waypoints, если они есть
	if current_wp < waypoints.size():
		target_pos = waypoints[current_wp]
		if (global_position + Vector2(0, collision_offset_y)).distance_to(target_pos) < 16.0: 
			current_wp += 1
		else:
			_move_towards(target_pos)
			return

	# 2) Когда точки закончились, идём к девушке
	if target:
		target_pos = target.global_position # Цель - глобальная позиция узла Girl
		_move_towards(target_pos)

func _move_towards(target_pos: Vector2) -> void:
	var adjusted_target_pos = target_pos - Vector2(0, collision_offset_y)

	var dir := (adjusted_target_pos - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

	# Поворачиваем спрайт врага в сторону его движения.
	# '+ PI / 2' здесь используется как поправка,
	# если ваша картинка 'human1.png' по умолчанию нарисована так, что "вперед" для нее - это "вверх" (по оси Y).
	# Если ваша картинка по умолчанию нарисована лицом "вправо" (по оси X),
	# то смещение '+ PI / 2' НЕ НУЖНО, и нужно использовать просто 'velocity.angle()'.
	#enemy_animated_sprite.rotation = velocity.angle() + PI / 2
	var current_animation: String = "walk_down" # Анимация по умолчанию
	var angle_rad = velocity.angle()

	var quarter_pi = PI / 4.0
	var three_quarter_pi = 3.0 * PI / 4.0
	
	if angle_rad >= -quarter_pi and angle_rad < quarter_pi: # ОТ -45 ДО +45 ГРАДУСОВ (ВПРАВО)
		current_animation = "walk_right"
	elif angle_rad >= quarter_pi and angle_rad < three_quarter_pi: # ОТ +45 ДО +135 ГРАДУСОВ (ВНИЗ)
		current_animation = "walk_down"
	elif angle_rad >= three_quarter_pi or angle_rad < -three_quarter_pi: # ОТ +135 ДО +180 И ОТ -180 ДО -135 ГРАДУСОВ (ВЛЕВО)
		current_animation = "walk_left"
	elif angle_rad >= -three_quarter_pi and angle_rad < -quarter_pi: # ОТ -135 ДО -45 ГРАДУСОВ (ВВЕРХ)
		current_animation = "walk_up"

	# Воспроизводим выбранную анимацию, только если она отличается от текущей
	if enemy_animated_sprite.animation != current_animation:
		enemy_animated_sprite.play(current_animation)

func _on_hitbox_input_event(_viewport, event, _shape_idx) -> void:
	# Игнорируем клики, если враг уже умирает
	if is_dying:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicks_to_kill -= 1
		if clicks_to_kill <= 0:
			# Враг "убит" кликом, запускаем процесс смерти с типом "tap"
			_start_death_sequence("tap")

#func _on_flip_flop_timeout() -> void:
#	# Не зеркалируем, если враг умирает
#	if is_dying:
#		enemy_sprite.flip_h = false
#		is_flipping = false
#		return

	# Только если враг движется, переключаем зеркальность
	#if velocity.length() > 0:
	#	is_flipping = not is_flipping
	#	enemy_sprite.flip_h = is_flipping
	#else:
		# Если не движется, сбросить зеркальность до исходного состояния
	#	enemy_sprite.flip_h = false
	#	is_flipping = false

func _on_tap_effect_timeout() -> void:
	# Когда таймер эффекта закончился, запускаем анимацию исчезновения "tap"
	tap_fade_animation_player.play("fade_out_tap")
	# Подключаем сигнал, чтобы удалить врага после завершения анимации
	tap_fade_animation_player.animation_finished.connect(_on_animation_finished_and_queue_free, CONNECT_ONE_SHOT)

func _on_animation_finished_and_queue_free(_anim_name: String) -> void:
	# После завершения анимации (fade_out_tap или Bad), удаляем врага
	died.emit()
	queue_free()

func get_is_dying() -> bool:
	return is_dying

# Централизованная функция для запуска последовательности смерти врага
func _start_death_sequence(death_type: String) -> void:
	if is_dying: # Если уже умирает, игнорируем повторный вызов
		return

	is_dying = true # Устанавливаем флаг, что враг умирает

	enemy_animated_sprite.visible = false # Скрываем спрайт врага
	
	# *** ОТКЛЮЧАЕМ ВСЮ КОЛЛИЗИЮ ***
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("collision_layer", 0)
	hitbox.set_deferred("collision_mask", 0)
	
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	if $CollisionShape2D: $CollisionShape2D.set_deferred("disabled", true)

	flip_flop_timer.stop() # Останавливаем таймер зеркалирования
	#enemy_sprite.flip_h = false # Сбрасываем зеркальность

	# Скрываем спрайты эффектов (они будут проявляться анимацией)
	tap_effect_sprite.visible = false

	if death_type == "tap":
		# ВОСПРОИЗВОДИМ ЗВУК ТОЛЬКО ДЛЯ СМЕРТИ ТИПА "tap"
		enemy_death_sound.play()
		
		tap_effect_sprite.top_level = true # Фиксируем эффект на месте
		tap_effect_sprite.global_position = global_position
		tap_effect_sprite.visible = true # Показываем спрайт эффекта
		tap_effect_timer.start() # Запускаем таймер эффекта (который затем запустит fade_out_tap)
	elif death_type == "bad_end":
		# ЗВУК НЕ ВОСПРОИЗВОДИМ ДЛЯ "bad_end"
		tap_fade_animation_player.play("Bad")
