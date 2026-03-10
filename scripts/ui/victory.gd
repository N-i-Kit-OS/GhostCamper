extends CanvasLayer

@onready var continue_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/Button/AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CenterContainer/VBoxContainer/Button.text = "Продолжить"
	$CenterContainer/VBoxContainer/Button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	continue_sound.play()
	
	await get_tree().create_timer(0.1).timeout
	
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
