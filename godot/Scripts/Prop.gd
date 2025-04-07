extends Node3D

# Minimum difficulty level for this prop to spawn
@export var min_difficulty: float = 0.0
# Probability this prop spawns
@export var chance: float = 1.0

func _ready() -> void:
	if chance < randf():
		self.queue_free()
	
	var difficulty = abs(self.global_position.y / 5.0)
	if difficulty < min_difficulty:
		self.queue_free()
