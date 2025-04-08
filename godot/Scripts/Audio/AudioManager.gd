extends Node3D

var sound_effect_dict: Dictionary = {}

@export var sound_effects: Array[SfxSetting]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	for sound_effect: SfxSetting in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect
		
	var audio = AudioStreamPlayer.new()
	add_child(audio)
	var sound_effect = sound_effect_dict[SfxSetting.SOUND_EFFECT_TYPE.Music]
	audio.stream = sound_effect.sound_effect
	audio.volume_db = sound_effect.volume
	audio.bus = "Music"
	audio.finished.connect(audio.play)
	audio.play()


## Creates a sound effect at a specific location if the limit has not been reached. Pass [param location] for the global position of the audio effect, and [param type] for the SfxSetting to be queued.
func create_audio_at_location(location: Vector3, type: SfxSetting.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SfxSetting = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var audio: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
			add_child(audio)
			audio.position = location
			audio.stream = sound_effect.sound_effect
			audio.volume_db = sound_effect.volume
			audio.bus = "SFΧ"
			audio.pitch_scale = sound_effect.pitch_scale
			audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness )
			audio.finished.connect(sound_effect.on_audio_finished)
			audio.finished.connect(audio.queue_free)
			audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)


## Creates a sound effect if the limit has not been reached. Pass [param type] for the SfxSetting to be queued.
func create_audio(type: SfxSetting.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SfxSetting = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(audio)
			audio.stream = sound_effect.sound_effect
			audio.volume_db = sound_effect.volume
			audio.bus = "SFΧ"
			audio.pitch_scale = sound_effect.pitch_scale
			audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness )
			audio.finished.connect(sound_effect.on_audio_finished)
			audio.finished.connect(audio.queue_free)
			audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)
