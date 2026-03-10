extends CanvasLayer

@onready var resume_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/ResumeButton/AudioStreamPlayer
@onready var restart_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/RestartButton/AudioStreamPlayer
@onready var menu_sound: AudioStreamPlayer = $CenterContainer/VBoxContainer/MenuButton/AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CenterContainer/VBoxContainer/ResumeButton.pressed.connect(_on_resume)
	$CenterContainer/VBoxContainer/RestartButton.pressed.connect(_on_restart)
	$CenterContainer/VBoxContainer/MenuButton.pressed.connect(_on_menu)

func _on_resume() -> void:
	resume_sound.play()
	
	await get_tree().create_timer(0.1).timeout
	
	get_tree().paused = false
	queue_free()

func _on_restart() -> void:
	restart_sound.play()
	
	await get_tree().create_timer(0.1).timeout
	
	get_tree().paused = false
	get_tree().call_deferred("reload_current_scene")

func _on_menu() -> void:
	menu_sound.play()
	
	await get_tree().create_timer(0.1).timeout
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
