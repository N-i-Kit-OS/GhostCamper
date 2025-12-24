extends CanvasLayer

const LEVEL_SCENE := "res://scenes/game/main.tscn"
const LEVEL_CONFIGS := [
	"res://resources/levels/level_1.tres.tres",
	"res://resources/levels/level_2.tres",
	"res://resources/levels/level_3.tres",
]

# НОВЫЕ СТРОКИ: Объявляем @onready переменные для звуков клика
@onready var level_1_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/level_1/AudioStreamPlayer
@onready var level_2_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/level_2/AudioStreamPlayer
@onready var level_3_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/level_3/AudioStreamPlayer
@onready var back_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/back_btn/AudioStreamPlayer


func _ready() -> void:
	for i in 3:  # 
		var btn := $CenterContainer/VBoxContainer.get_node("level_%d" % (i + 1)) as Button
		btn.pressed.connect(func(): _start_level(i + 1))
	$CenterContainer/VBoxContainer/back_btn.pressed.connect(_on_back)

func _start_level(_idx: int) -> void:
	# НОВЫЕ СТРОКИ: Воспроизведение звука клика в зависимости от выбранного уровня
	match _idx:
		1: level_1_sound.play()
		2: level_2_sound.play()
		3: level_3_sound.play()
		
	GameManager.current_level_config_path = LEVEL_CONFIGS[_idx - 1]
	get_tree().change_scene_to_file(LEVEL_SCENE)

func _on_back() -> void:
	# НОВАЯ СТРОКА: Воспроизведение звука для кнопки "Назад"
	back_sound.play()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
