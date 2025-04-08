class_name HideByGameState extends CanvasItem 

@export var visibleByDefault: bool
@export var visibleOnPause: bool
@export var visibleOnGameOver: bool
@export var visibleWhilePlaying: bool

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if has_method("hide") and has_method("show"):
		if visibleByDefault:
			show()
		else:
			hide()
		
		GameManager.game_over.connect(_handle_game_over)
		GameManager.game_paused.connect(_handle_game_paused)
		GameManager.game_started.connect(_handle_game_started)

func _handle_game_over():
	if visibleOnGameOver:
		show()
	else:
		hide()
		
func _handle_game_paused():
	if visibleOnPause:
		show()
	else:
		hide()
		
func _handle_game_started():
	if visibleWhilePlaying:
		show()
	else:
		hide()
