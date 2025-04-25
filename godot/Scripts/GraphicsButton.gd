extends Button

@export
var set_quality: bool = false
@export
var quality: SettingsManager.Quality

@export
var set_resolution: bool = false
@export
var resolution: SettingsManager.Resolution

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_handle_quality_updated(SettingsManager.get_quality())
	_handle_resolution_updated(SettingsManager.get_resolution())
	SettingsManager.quality_updated.connect(_handle_quality_updated)
	SettingsManager.resolution_updated.connect(_handle_resolution_updated)

func _pressed() -> void:
	if set_quality:
		SettingsManager.set_quality(quality)
	if set_resolution:
		SettingsManager.set_resolution(resolution)

func _handle_quality_updated(quality: SettingsManager.Quality):
	if ! set_quality:
		return
	
	self.set_pressed_no_signal(quality == self.quality)

func _handle_resolution_updated(resolution: SettingsManager.Resolution):
	if ! set_resolution:
		return
	
	self.set_pressed_no_signal(resolution == self.resolution)
