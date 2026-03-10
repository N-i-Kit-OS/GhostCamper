extends Node

var current_level_config_path: String = "res://resources/levels/level_1.tres"
enum State { MAIN_MENU, PLAYING, PAUSED, GAME_OVER }
var state: State = State.MAIN_MENU

enum CursorMode { SYSTEM, CROSSHAIR, HAND }
var cursor_mode: CursorMode = CursorMode.CROSSHAIR

signal state_changed(state: State)
func set_state(s: State) -> void:
	state = s
	state_changed.emit(s)

var cursor_initialized := false

func _ready() -> void:
	_set_custom_cursor()

func _set_custom_cursor() -> void:
	var tex: Texture2D = null
	var hotspot := Vector2.ZERO

	match cursor_mode:
		CursorMode.SYSTEM:
			tex = null
		CursorMode.CROSSHAIR:
			tex = load("res://assets/ui/cursor.png")
			hotspot = Vector2(24, 24)
		CursorMode.HAND:
			tex = load("res://assets/ui/hand.png")
			hotspot = Vector2(8, 2)

	Input.set_custom_mouse_cursor(tex, Input.CURSOR_ARROW, hotspot)
	cursor_initialized = true

func cycle_cursor_mode() -> void:
	cursor_mode = (cursor_mode + 1) % 3
	_set_custom_cursor()
