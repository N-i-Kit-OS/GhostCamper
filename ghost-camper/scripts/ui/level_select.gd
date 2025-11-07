extends CanvasLayer

const LEVEL_SCENE := "res://scenes/game/main.tscn"  # пока запускаем твою текущую игровую сцену

func _ready() -> void:
	for i in 6:  # 0..5
		var btn := $CenterContainer/VBoxContainer.get_node("level_%d" % (i + 1)) as Button
		btn.pressed.connect(func(): _start_level(i + 1))
	$CenterContainer/VBoxContainer/back_btn.pressed.connect(_on_back)

func _start_level(_idx: int) -> void:
	get_tree().change_scene_to_file(LEVEL_SCENE)

func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
