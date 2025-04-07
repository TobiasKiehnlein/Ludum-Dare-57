extends AnimationPlayer

func _ready() -> void:
	GameManager.game_started.connect(handleGameStart)
	
func handleGameStart():
	self.stop(true)
