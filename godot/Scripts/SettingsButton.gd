extends HideByGameState

var _settings_open: bool = false

func _on_pressed() -> void:
	_settings_open = ! _settings_open
	GameManager.open_settings(_settings_open)
