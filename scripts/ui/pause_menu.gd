extends CanvasLayer

# Добавляем звуковые эффекты
@onready var resume_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/ResumeButton/AudioStreamPlayer
@onready var restart_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/RestartButton/AudioStreamPlayer
@onready var menu_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/MenuButton/AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CenterContainer/VBoxContainer/ResumeButton.pressed.connect(_on_resume)
	$CenterContainer/VBoxContainer/RestartButton.pressed.connect(_on_restart)
	$CenterContainer/VBoxContainer/MenuButton.pressed.connect(_on_menu)

func _on_resume() -> void:
	# Воспроизводим звук при нажатии кнопки "Продолжить"
	resume_sound.play()
	
	# Ждем немного перед снятием паузы (чтобы звук успел воспроизвестись)
	await get_tree().create_timer(0.1).timeout
	
	get_tree().paused = false
	queue_free()

func _on_restart() -> void:
	# Воспроизводим звук при нажатии кнопки "Перезапустить"
	restart_sound.play()
	
	# Ждем немного перед перезапуском сцены
	await get_tree().create_timer(0.1).timeout
	
	get_tree().paused = false
	get_tree().call_deferred("reload_current_scene")

func _on_menu() -> void:
	# Воспроизводим звук при нажатии кнопки "Меню"
	menu_sound.play()
	
	# Ждем немного перед переходом в меню
	await get_tree().create_timer(0.1).timeout
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
