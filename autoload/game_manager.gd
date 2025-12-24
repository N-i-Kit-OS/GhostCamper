extends Node

var current_level_config_path: String = "res://resources/levels/level_1.tres"
enum State { MAIN_MENU, PLAYING, PAUSED, GAME_OVER }
var state: State = State.MAIN_MENU
var use_custom_cursor: bool = true # Изначально используем кастомный курсор
signal state_changed(state: State)
func set_state(s: State) -> void:
	state = s
	state_changed.emit(s)

var cursor_initialized := false

func _ready() -> void:
	_set_custom_cursor()

func _set_custom_cursor() -> void:
	if use_custom_cursor:
		var cursor_tex := load("res://assets/ui/cursor.png")
		if cursor_tex:
			Input.set_custom_mouse_cursor(cursor_tex, Input.CURSOR_ARROW, Vector2(24, 24))	
	else:
		Input.set_custom_mouse_cursor(null) # Устанавливаем стандартный курсор
	cursor_initialized = true # Помечаем, что курсор инициализирован хотя бы раз

func toggle_custom_cursor() -> void:
	use_custom_cursor = not use_custom_cursor
	_set_custom_cursor() # Обновляем курсор на основе нового значения
