extends Label

func _ready() -> void:
	resize()
	get_tree().get_root().size_changed.connect(resize)
	hide()
	GameManager.game_started.connect(show)
	GameManager.game_over.connect(handle_game_over)
	GameManager.score.connect(set_score)

func resize():
	self.label_settings.font_size = get_viewport_rect().size.y * .05
	self.size.x = get_viewport_rect().size.x
	self.size.y = get_viewport_rect().size.y * .2

func handle_game_over():
	self.size.y = get_viewport_rect().size.y / 2

func set_score(score: int):
	self.text = str(score)
