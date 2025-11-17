extends Node

var current_level_config_path: String = "res://resources/levels/level_1.tres"
enum State { MAIN_MENU, PLAYING, PAUSED, GAME_OVER }
var state: State = State.MAIN_MENU
signal state_changed(state: State)
func set_state(s: State) -> void:
	state = s
	state_changed.emit(s)
