extends Node3D

@export var height: float = 5.0
@onready var player: Node3D = $"/root/Root/Player"

func get_section_height() -> float:
	return height
	

func _process(delta: float) -> void:
	if position.y - player.position.y > 7:
		queue_free()
