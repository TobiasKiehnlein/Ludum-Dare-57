extends RigidBody3D

@export var maxFlyTime = 1

var flyTime = -1;
var isAscending = false

func checkGrounded() -> bool:
	var from = self.position
	var to = from - Vector3.UP * 0.6  # Adjust length as needed
	var params = PhysicsRayQueryParameters3D.create(from, to, 0xFFFFFFFF,[self])
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	return 'position' in result

func controlSpeed():
	if linear_velocity.length() < 4:
		self.apply_central_force(linear_velocity.normalized() * 2.5)
	if linear_velocity.length() > 5:
		self.apply_central_force(linear_velocity.normalized() * -1)

func _physics_process(delta: float) -> void:
	var isGrounded = checkGrounded()
	
	if Input.is_action_just_pressed("Jump"):
		if isGrounded:
			flyTime = maxFlyTime;
			isAscending = true
			self.linear_velocity.y = 0
			self.apply_central_impulse(Vector3(0, 3, 0))
		else:
			flyTime = -1
			isAscending = false
			self.linear_velocity.y = 0
			self.apply_central_impulse(Vector3(0, -9, 0))
		
	if Input.is_action_pressed("Jump") && isAscending:
		flyTime -= delta;
		self.apply_central_force(Vector3(0, max(10 * (flyTime / maxFlyTime), 3), 0))
	elif linear_velocity.y < 0 && !isGrounded && isAscending:
		self.apply_central_force(Vector3(0, 3, 0))
	
	controlSpeed()
