extends Button

func _ready():
	var width = get_viewport_rect().size.x * .3
	self.size = Vector2(width, width)
	self.position.x = (get_viewport_rect().size.x - width) * .5
	self.position.y = (get_viewport_rect().size.y - width) * .65
	GameManager.game_started.connect(hide)
	

func _on_pressed() -> void:
	if !GameManager.hasGameStarted:
		GameManager.startGame()
	else:
		GameManager.pauseGame()
