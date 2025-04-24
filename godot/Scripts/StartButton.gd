extends Button

func _ready():
	GameManager.game_started.connect(hide)
	

func _on_pressed() -> void:
	if !GameManager.hasGameStarted:
		GameManager.startGame()
	else:
		GameManager.pauseGame()
