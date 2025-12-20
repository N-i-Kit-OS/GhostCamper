extends Node

var current_level_config_path: String = "res://resources/levels/level_1.tres"
enum State { MAIN_MENU, PLAYING, PAUSED, GAME_OVER }
var state: State = State.MAIN_MENU
signal state_changed(state: State)
func set_state(s: State) -> void:
	state = s
	state_changed.emit(s)

var cursor_initialized := false

func _ready() -> void:
	_set_custom_cursor()

func _set_custom_cursor() -> void:
	if cursor_initialized:
		return
	var cursor_tex := load("res://assets/ui/cursor.png")
	if cursor_tex:
		Input.set_custom_mouse_cursor(cursor_tex, Input.CURSOR_ARROW, Vector2(24, 24))
		cursor_initialized = true
