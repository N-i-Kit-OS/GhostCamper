extends CanvasLayer

@onready var cursor_toggle_button: Button = $CenterContainer/VBoxContainer/CursorToggleButton
@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton

# Добавляем звуковые эффекты
@onready var cursor_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/CursorToggleButton/AudioStreamPlayer
@onready var back_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/BackButton/AudioStreamPlayer

func _ready() -> void:
	_update_cursor_button_text()
	cursor_toggle_button.pressed.connect(_on_cursor_toggle_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

func _update_cursor_button_text() -> void:
	if GameManager.use_custom_cursor:
		cursor_toggle_button.text = "Курсор: Прицел"
	else:
		cursor_toggle_button.text = "Курсор: Обычный"

func _on_cursor_toggle_pressed() -> void:
	# Воспроизводим звук при переключении курсора
	cursor_sound.play()
	
	# Ждем немного перед применением изменений
	await get_tree().create_timer(0.1).timeout
	
	GameManager.toggle_custom_cursor()
	_update_cursor_button_text()

func _on_back_button_pressed() -> void:
	# Воспроизводим звук при нажатии кнопки "Назад"
	back_sound.play()
	
	# Ждем немного перед переходом
	await get_tree().create_timer(0.1).timeout
	
	queue_free()
	# Возвращаемся в главное меню
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
