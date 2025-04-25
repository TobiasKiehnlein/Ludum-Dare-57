extends WorldEnvironment

@export
var glow_enabled: bool = true

func _ready():
	_handle_quality_updated(SettingsManager.get_quality())
	SettingsManager.quality_updated.connect(_handle_quality_updated)

func _handle_quality_updated(quality: SettingsManager.Quality):
	if quality < SettingsManager.Quality.MEDIUM:
		environment.glow_enabled = false
		environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	else:
		environment.glow_enabled = self.glow_enabled
		environment.tonemap_mode = Environment.TONE_MAPPER_ACES
	
