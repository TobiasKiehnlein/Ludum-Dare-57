extends Node

@export var stairCaseScenes: Array[PackedScene]
@export var player: Node3D

var bottom = 0

func instantiateNext():
	var randi = randi_range(0, len(stairCaseScenes) - 1)
	var x = stairCaseScenes[randi].instantiate()
	var height = x.get_node('Center').shape.height
	bottom -= height
	x.position.y = bottom
	self.add_child(x)

func _ready() -> void:
	assert(len(stairCaseScenes) > 0)
	#bottom = self.get_children().map(func(child): return child.get_node('Center')).reduce(func(lowest, child): return child.position.y if child.position.y < lowest else lowest, 1000000000)
	for i in range(10):
		instantiateNext()

func _process(delta: float) -> void:
	if player.position.y - 100 < bottom:
		instantiateNext()
