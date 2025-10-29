extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/PlayButton.pressed.connect(_on_play)
	$CenterContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit)
	$CenterContainer/VBoxContainer/SettingsButton.pressed.connect(_on_settings)

func _on_play() -> void:
	if Engine.has_singleton("GameManager"):
		GameManager.set_state(GameManager.State.PLAYING)
	get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn")

func _on_settings() -> void:
	# Пока заглушка: вернуться в меню
	pass

func _on_exit() -> void:
	get_tree().quit()
