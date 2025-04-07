extends Node

@export var stairCaseScenes: Array[PackedScene]

@onready var player: Node3D = $"/root/Root/Player"

var bottom = 0
var lights: Array

func instantiateNext():
	var randi = randi_range(0, len(stairCaseScenes) - 1)
	var x = stairCaseScenes[randi].instantiate()
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
	_find_lights()

func _find_lights() -> void:
	#var children = self.find_children("*", "Light3D", true)
	lights = []
	var children = self.get_children()
	_search_lights_children(children)

func _search_lights_children(children: Array[Node]) -> void:
	for c in children:
		if c is OmniLight3D or c is SpotLight3D:
			lights.append(c)
		_search_lights_children(c.get_children())

func _process(delta: float) -> void:
	var remove_freed = func(a) -> bool:
		if is_instance_valid(a):
			return true
		return false
	
	lights = lights.filter(remove_freed)
	
	var player_dist_sort = func(a: Node3D, b: Node3D) -> bool:
		var cmp_pos = player.global_position + Vector3.DOWN * 2.5
		var dist_a = a.global_position.distance_to(cmp_pos)
		var dist_b = b.global_position.distance_to(cmp_pos)
		return dist_a < dist_b

	# Only leave 8 Lights enabled based on distance
	lights.sort_custom(player_dist_sort)
	var count: int = 0
	for light in lights:
		if count < 16:
			light.show()
		else:
			light.hide()
		count += 1
		pass
		
	
	if player.position.y - 15 < bottom:
		instantiateNext()
		_find_lights()
