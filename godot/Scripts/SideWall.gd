extends Node3D

var camera: Node3D

func _ready() -> void:
	camera = get_parent().get_node("Camera")
	
func _process(delta: float) -> void:
	if camera.global_position.y < self.global_position.y:
		self.global_position.y = camera.global_position.y
	
	self.global_rotation = camera.global_rotation
