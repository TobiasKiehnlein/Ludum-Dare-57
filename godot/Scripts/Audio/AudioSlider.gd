extends HSlider

@export var bus: SettingsManager.AudioBus

var volume: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.max_value = 15
	self.min_value = -60
	
	volume = SettingsManager.get_audio_volume(bus)
	adjust_audio(volume)
	set_value_no_signal(volume)
	value_changed.connect(adjust_audio)
	mouse_exited.connect(_on_mouse_exited)

func adjust_audio(amount: float):
	var bus_name = SettingsManager.AudioBus.keys()[bus]
	var index = AudioServer.get_bus_index(bus_name)
	if index < 0:
		push_warning("Failed to find audio bus for " + bus_name)
		return
	volume = amount
	AudioServer.set_bus_volume_db(index, amount)

func _on_mouse_exited():
	SettingsManager.set_audio_volume(bus, volume)
