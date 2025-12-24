extends CanvasLayer

# Добавляем звуковой эффект для кнопки
@onready var menu_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/Button/AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CenterContainer/VBoxContainer/Label.text = "Любви конец"
	$CenterContainer/VBoxContainer/Label2.text = ""
	$CenterContainer/VBoxContainer/Button.pressed.connect(_on_menu)

func _on_menu() -> void:
	# Воспроизводим звук при нажатии кнопки
	menu_sound.play()
	
	# Ждем немного перед переходом в меню (чтобы звук успел воспроизвестись)
	await get_tree().create_timer(0.1).timeout
	
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
