extends CanvasLayer

const LEVEL_SCENE := "res://scenes/game/main.tscn"  # пока запускаем твою текущую игровую сцену

func _ready() -> void:
	for i in 0:
		var btn := $CenterContainer/VBoxContainer.get_node("Level%d" % (i + 1)) as Button
		btn.pressed.connect(func(): _start_level(i + 1))
	$CenterContainer/VBoxContainer/back_btn.pressed.connect(_on_back)

func _start_level(idx: int) -> void:
	# пока просто запускаем один и тот же main.tscn; позже подменим конфиг уровня
	get_tree().change_scene_to_file(LEVEL_SCENE)

func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
