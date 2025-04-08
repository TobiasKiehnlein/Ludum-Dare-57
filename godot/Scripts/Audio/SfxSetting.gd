class_name SfxSetting 
extends Resource

enum SOUND_EFFECT_TYPE {
	Swoosh,
	Jump,
	GameOver,
	Stair,
	Wood,
	Music
}

@export_range(0, 10) var limit: int = 5 ## Maximum number of this SoundEffect to play simultaneously before culled.
@export var type: SOUND_EFFECT_TYPE ## The unique sound effect in the [enum SOUND_EFFECT_TYPE] to associate with this effect. Each SoundEffect resource should have it's own unique [enum SOUND_EFFECT_TYPE] setting.
@export var sound_effect: AudioStreamMP3 ## The [AudioStreamMP3] audio resource to play.
@export_range(-40, 20) var volume: float = 0 ## The volume of the [member sound_effect].
@export_range(0.0, 4.0,.01) var pitch_scale: float = 1.0 ## The pitch scale of the [member sound_effect].
@export_range(0.0, 1.0,.01) var pitch_randomness: float = 0.0 ## The pitch randomness setting of the [member sound_effect].

var audio_count: int = 0

func change_audio_count(amount: int) -> void:
	audio_count = max(0, audio_count + amount)

func has_open_limit() -> bool:
	return audio_count < limit

func on_audio_finished() -> void:
	change_audio_count(-1)
