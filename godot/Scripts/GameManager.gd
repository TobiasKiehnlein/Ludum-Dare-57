extends Node

signal game_started()
signal game_paused()
signal game_over()
signal score(score: int)
var _score = 0

signal settings_opened(open: bool)

var audioManager: AudioManager

var hasGameStarted = false
var isGameOver = false
var startOnReady = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func startGame():
	hasGameStarted = true
	_score = 0
	game_started.emit()

func pauseGame():
	if !hasGameStarted:
		startGame()
		return
	if isGameOver:
		return
	
	if get_tree().paused:
		get_tree().paused = false
		game_started.emit()
	else:
		get_tree().paused=true
		game_paused.emit()

func gameOver():
	if isGameOver:
		return
	isGameOver = true
	AudioManager.create_audio(SfxSetting.SOUND_EFFECT_TYPE.GameOver)
	game_over.emit()

func setScore(score: int):
	if score > _score:
		_score = score
		self.score.emit(score)
		# print(score)
	
func restart(force = false):
	if !(isGameOver or force):
		return
	hasGameStarted = false
	isGameOver = false
	startOnReady = true
	get_tree().reload_current_scene()

func open_settings(open: bool):
	self.settings_opened.emit(open)

func ready():
	return
	#if startOnReady:
		#await get_tree().create_timer(.1).timeout
		#startGame()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pauseGame()
