extends Control

const LEVEL_SCENE_PATH := "res://scenes/ui/level_select.tscn"
const SETTINGS_SCENE_PATH := "res://scenes/ui/settings_menu.tscn"

# Объявляем @onready переменные для кнопок и их звуков, чтобы пути были надежными
@onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton
@onready var settings_button: Button = $CenterContainer/VBoxContainer/SettingsButton
@onready var exit_button: Button = $CenterContainer/VBoxContainer/ExitButton

@onready var play_button_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/PlayButton/AudioStreamPlayer
@onready var settings_button_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/SettingsButton/AudioStreamPlayer
@onready var exit_button_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/ExitButton/AudioStreamPlayer
@onready var start_sound: AudioStreamPlayer = $AudioStreamPlayer2

func _ready() -> void:
	
	start_sound.play()
	
	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)


func _on_play_button_pressed() -> void:
	play_button_sound.play() # Используем @onready переменную для звука
	if Engine.has_singleton("GameManager"):
		GameManager.set_state(GameManager.State.PLAYING)
	get_tree().change_scene_to_file(LEVEL_SCENE_PATH)

func _on_settings_button_pressed() -> void:
	settings_button_sound.play() # Используем @onready переменную для звука
	var settings_menu_instance = load(SETTINGS_SCENE_PATH).instantiate() # Загружаем сцену через load()
	get_tree().get_root().add_child(settings_menu_instance)

func _on_exit_button_pressed() -> void:
	exit_button_sound.play() # Используем @onready переменную для звука
	get_tree().quit()
