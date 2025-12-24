extends CanvasLayer

# Добавляем звуковой эффект для кнопки
@onready var continue_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/Button/AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CenterContainer/VBoxContainer/Button.text = "Продолжить"
	$CenterContainer/VBoxContainer/Button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	# Воспроизводим звук при нажатии кнопки
	continue_sound.play()
	
	# Ждем немного перед переходом в меню
	await get_tree().create_timer(0.1).timeout
	
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
