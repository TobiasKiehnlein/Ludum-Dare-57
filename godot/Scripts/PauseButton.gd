extends Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func pauseGame():
	if get_tree().paused:
		get_tree().paused = false
		show()
	else:
		get_tree().paused=true
		hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pauseGame()

func _on_pressed() -> void:
	pauseGame()
