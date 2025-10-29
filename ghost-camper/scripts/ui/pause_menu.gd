extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CenterContainer/VBoxContainer/ResumeButton.pressed.connect(_on_resume)
	$CenterContainer/VBoxContainer/RestartButton.pressed.connect(_on_restart)
	$CenterContainer/VBoxContainer/MenuButton.pressed.connect(_on_menu)

func _on_resume() -> void:
	get_tree().paused = false
	queue_free()

func _on_restart() -> void:
	get_tree().paused = false
	get_tree().call_deferred("reload_current_scene")

func _on_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
