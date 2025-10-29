extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CenterContainer/VBoxContainer/Label.text = "Любви конец"
	$CenterContainer/VBoxContainer/Label2.text = ""
	$CenterContainer/VBoxContainer/Button.pressed.connect(_on_menu)

func _on_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
