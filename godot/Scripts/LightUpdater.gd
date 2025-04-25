extends Node3D

@export
var enable_shadows: bool = false

var parent: Light3D

func _ready():
	parent = get_parent()
	_handle_quality_updated(SettingsManager.get_quality())
	SettingsManager.quality_updated.connect(_handle_quality_updated)

func _handle_quality_updated(quality: SettingsManager.Quality):
	var use_shadows: bool = enable_shadows and quality > SettingsManager.Quality.MEDIUM
	parent.shadow_enabled = use_shadows
