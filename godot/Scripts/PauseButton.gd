extends Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var width = get_viewport_rect().size.x * .1
	self.size = Vector2(width, width)
	self.position.x = get_viewport_rect().size.x - self.size.x * 1.3
	self.position.y = width * .3
	hide()
	GameManager.game_started.connect(show)
	GameManager.game_paused.connect(hide)
	GameManager.game_over.connect(hide)

func _on_pressed() -> void:
	GameManager.pauseGame()
