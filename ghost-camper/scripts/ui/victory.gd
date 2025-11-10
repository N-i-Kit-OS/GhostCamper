extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CenterContainer/VBoxContainer/Label.text = "Любовь спас"
	$CenterContainer/VBoxContainer/Label2.text = ""
	$CenterContainer/VBoxContainer/Button.text = "Продолжить"
	$CenterContainer/VBoxContainer/Button.pressed.connect(func ():
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
)
