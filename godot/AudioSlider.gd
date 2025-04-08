extends HSlider

enum BUS {
	Music,
	Sfx
}

@export var bus: BUS
@export var visibleOnPause: bool
@export var visibleOnGameOver: bool
@export var visibleWhilePlaying: bool

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resize()
	get_tree().get_root().size_changed.connect(resize)
	value_changed.connect(adjust_audio)
	value = 0
	max_value = 15
	min_value = -60
	
	if has_method("hide") and has_method("show"):
		show()
		GameManager.game_over.connect(_handle_game_over)
		GameManager.game_paused.connect(_handle_game_paused)
		GameManager.game_started.connect(_handle_game_started)

func resize():
	var screenSize = get_viewport_rect().size
	size.x = screenSize.x * .8
	position.x = screenSize.x * .1
	
	position.y = screenSize.y * (.8 if bus == BUS.Music else .9)

func adjust_audio(amount: float):
	var index = AudioServer.get_bus_index("Music" if bus == BUS.Music else "SFX")
	print(index)
	if index < 0:
		return
	AudioServer.set_bus_volume_db(index, amount)

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
