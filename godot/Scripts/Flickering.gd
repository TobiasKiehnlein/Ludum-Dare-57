extends OmniLight3D

@export var flickeringSpeed: float = 5

var time_passed = 0.0

var texture: NoiseTexture2D
var initialEnergy: float
var offset: float

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	texture = NoiseTexture2D.new()
	texture.noise = FastNoiseLite.new()
	initialEnergy = light_energy
	offset = randf_range(0,100)


func _process(delta: float) -> void:
	time_passed += delta
	
	var sampled_noise = texture.noise.get_noise_1d((time_passed+offset)* flickeringSpeed)
	sampled_noise = clamp( abs(sampled_noise), .2, 1)
	light_energy = sampled_noise*initialEnergy
