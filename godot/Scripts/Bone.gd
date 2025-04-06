extends MeshInstance3D

@export var forceMultiplier: float

@onready var root: Node3D = $"/root/Root"
@onready var player: Node3D = $"/root/Root/Player"

var rb: RigidBody3D
var col: CollisionShape3D

func _init() -> void:
	GameManager.game_started.connect(makeRollin)
	
	if forceMultiplier == null or forceMultiplier == 0:
		forceMultiplier = 1

var wasInitialized = false
func makeRollin():
	if wasInitialized:
		return
	wasInitialized = true
	
	col = get_parent().get_children().filter(func(c): return c.name == name+"Collider").get(0)
	rb = RigidBody3D.new()
	#rb.continuous_cd = true
	rb.collision_layer = 4
	
	print(name)
	col.reparent(rb)
	self.reparent(rb)
	root.add_child(rb)
	
	rb.transform = col.transform * rb.transform
	self.transform = col.transform.inverse() * self.transform
	col.transform = Transform3D.IDENTITY
	var material := PhysicsMaterial.new()
	material.friction = 0.1
	material.friction = 0
	material.bounce = 0.2
	rb.physics_material_override = material

	initalBoost()
	
func initalBoost():
	var centerPosition = Vector3(0, col.position.z, 0)
	var outwards = col.position - centerPosition
	var targetDirection = outwards.cross(Vector3.UP);
	rb.apply_central_impulse(targetDirection*5)
	
func _physics_process(delta: float) -> void:
	if rb == null:
		return
	
	var verticalPlayerDistance = col.global_position.y - player.global_position.y 
	#print(verticalPlayerDistance)
	
	var centerPosition = Vector3(0, col.global_position.z, 0)
	var outwards = col.global_position - centerPosition
	var targetDirection = outwards.cross(Vector3.UP);
	targetDirection = targetDirection.rotated(Vector3.UP, -1.0)
	var targetDirectionBack = targetDirection.rotated(Vector3.UP, -1 * PI / 2)
	
	DebugDraw3D.draw_arrow(col.global_position, col.global_position+targetDirection, Color(1,0,0), .05)
	DebugDraw3D.draw_arrow(col.global_position, col.global_position+targetDirectionBack, Color(0,1,0), .05)

	if verticalPlayerDistance > 0:
		rb.apply_central_force(targetDirection.normalized() * 10 * forceMultiplier)
		#rb.apply_central_impulse(targetDirection.normalized()*0.3*forceMultiplier)
		#rb.linear_velocity += targetDirection.normalized() * .1
		pass
	elif verticalPlayerDistance > -2:
		rb.apply_central_force(targetDirection.normalized() * 5 * forceMultiplier)
		#rb.apply_central_impulse(targetDirection.normalized()*0.1*forceMultiplier)
		pass
	elif verticalPlayerDistance > -5:
		rb.apply_central_force(targetDirection.normalized() * 3 * forceMultiplier)
		#rb.apply_central_impulse(targetDirection.normalized()*.05*forceMultiplier)
		pass
	elif verticalPlayerDistance < -7:
		rb.apply_central_force(targetDirectionBack.normalized() * 10 * forceMultiplier)
		#rb.apply_central_impulse(targetDirection.normalized()*-.01*forceMultiplier)
		pass
	
	
