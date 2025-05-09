extends Node

@export var stairCaseScenes: Array[PackedScene]

@onready var player: Node3D = $"/root/Root/Player"

var bottom = 0
var lights: Array

func instantiateNext():
	var randi = randi_range(0, len(stairCaseScenes) - 1)
	var callback = Callable(self, "_handle_loaded_scene")
	SceneLoader.load_packed_scene(stairCaseScenes[randi], callback)

func _handle_loaded_scene(x: Node):
	var height
	if x.has_method("get_section_height"):
		height = x.get_section_height()
	else:
		height = 5.0
		push_warning("Stair section has no get_section_height")
	bottom -= height
	x.position.y = bottom
	self.add_child(x)

func _ready() -> void:
	assert(len(stairCaseScenes) > 0)
	#bottom = self.get_children().map(func(child): return child.get_node('Center')).reduce(func(lowest, child): return child.position.y if child.position.y < lowest else lowest, 1000000000)
	for i in range(5):
		instantiateNext()

func _process(delta: float) -> void:
	if player.position.y - 15 < bottom:
		instantiateNext()
