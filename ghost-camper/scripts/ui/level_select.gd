extends CanvasLayer

const LEVEL_SCENE := "res://scenes/game/main.tscn"  # пока запускаем твою текущую игровую сцену
const LEVEL_CONFIGS := [
	"res://resources/levels/level_1.tres.tres",
	"res://resources/levels/level_2.tres",
	"res://resources/levels/level_3.tres",
	"res://resources/levels/level_4.tres",
	"res://resources/levels/level_5.tres",
	"res://resources/levels/level_6.tres",
]

func _ready() -> void:
	for i in 6:  # 0..5
		var btn := $CenterContainer/VBoxContainer.get_node("level_%d" % (i + 1)) as Button
		btn.pressed.connect(func(): _start_level(i + 1))
	$CenterContainer/VBoxContainer/back_btn.pressed.connect(_on_back)

func _start_level(_idx: int) -> void:
	GameManager.current_level_config_path = LEVEL_CONFIGS[_idx - 1]
	get_tree().change_scene_to_file(LEVEL_SCENE)

func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
