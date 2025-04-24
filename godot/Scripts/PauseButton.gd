extends Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	GameManager.game_started.connect(show)
	GameManager.game_paused.connect(hide)
	GameManager.game_over.connect(hide)

func _on_pressed() -> void:
	GameManager.pauseGame()
