extends Node

const config_path: String = "user://settings.cfg"
var _config: ConfigFile

enum Quality {HIGH=3, MEDIUM=2, LOW=1}
enum Resolution {NATIVE=4, HIGH=3, MEDIUM=2, POTATO=0}

signal quality_updated(quality: Quality)
signal resolution_updated(resolution: Resolution)

enum AudioBus {Music = 0, SFX = 1}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_config = ConfigFile.new()
	var err = _config.load(config_path)
	# err != OK can be ignored
	
	set_quality(get_quality())
	set_resolution(get_resolution())


func _process(delta: float) -> void:
	pass

func set_quality(quality: Quality):
	match quality:
		Quality.HIGH:
			pass
		Quality.MEDIUM:
			# Torches will disable shadow by themselves
			pass
		Quality.LOW:
			# Currently unused
			# Options: Disable Procedural Sky and Glow, Tonemapping
			pass
	_config.set_value("Graphics", "Quality", quality)
	self.quality_updated.emit(quality)
	_config.save(config_path)

func set_resolution(resolution: Resolution):
	match resolution:
		Resolution.NATIVE:
			get_viewport().scaling_3d_scale = 1.0
		Resolution.HIGH:
			get_viewport().scaling_3d_scale = 0.75
		Resolution.MEDIUM:
			get_viewport().scaling_3d_scale = 0.5
		Resolution.POTATO:
			get_viewport().scaling_3d_scale = 0.25
	_config.set_value("Graphics", "Resolution", resolution)
	self.resolution_updated.emit(resolution)
	_config.save(config_path)

func set_audio_volume(bus: AudioBus, value: float):
	_config.set_value("Audio", AudioBus.keys()[bus], value)
	_config.save(config_path)
	
func get_quality() -> Quality:
	return _config.get_value("Graphics", "Quality", Quality.MEDIUM)

func get_resolution() -> Resolution:
	return _config.get_value("Graphics", "Resolution", Resolution.MEDIUM)

func get_audio_volume(bus: AudioBus) -> float:
	return _config.get_value("Audio", AudioBus.keys()[bus], 0.0)
