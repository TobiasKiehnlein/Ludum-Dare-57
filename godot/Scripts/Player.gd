extends RigidBody3D

@export var maxFlyTime = 1
@export var secondsUntilGameOver = 3
@export var is_grounded_grace_time: float = 0.2
@export var jump_timeout: float = 0.3

@onready var head: MeshInstance3D = $SkeleTON/Skeleton/Skeleton3D/Head_2/Head_2
@onready var jaw: MeshInstance3D = $SkeleTON/Skeleton/Skeleton3D/Jaw_2/Jaw_2
@onready var skeleton: Node3D = $SkeleTON


var flyTime = -1;
var isAscending = false
var is_grounded_grace_time_left: float = 0.0
var jump_timeout_left: float = 0.0

func _ready() -> void:
	self.freeze = true
	
	GameManager.game_started.connect(handleGameStart)
	GameManager.game_over.connect(func(): self.freeze = true)

var wasInitialized = false
func handleGameStart():
	if wasInitialized:
		return
	wasInitialized = true
	
	self.freeze = false
	head.reparent(self)
	jaw.reparent(self)
	var sphere = head.get_node("SphereCollider")
	var capsule = head.get_node("CapsuleCollider")
	sphere.reparent(self)
	capsule.reparent(self)
	
	var old_global_transform = self.global_transform
	var new_global_transform = sphere.global_transform
	self.global_transform = new_global_transform
	sphere.transform = Transform3D.IDENTITY
	
	var child_transform = old_global_transform * new_global_transform.inverse()
	capsule.global_transform = child_transform * capsule.global_transform
	head.global_transform = child_transform * head.global_transform
	jaw.global_transform = child_transform * jaw.global_transform
	
	skeleton.hide()
	

func checkGrounded() -> bool:
	var from = self.global_position
	var to = from - Vector3.UP * 0.5  # Adjust length as needed
	#DebugDraw3D.draw_arrow(from, to, Color(1,0,0), .1)
	var params = PhysicsRayQueryParameters3D.create(from, to, 0xFFFFFFFF,[self])
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	return 'position' in result


func controlSpeed():
	var centerPosition = Vector3(0, self.position.z, 0)
	var outwards = self.position - centerPosition
	var targetDirection = outwards.cross(Vector3.UP);
	if linear_velocity.length() < 4:
		self.apply_central_force(targetDirection.normalized() * 2.5)
	if linear_velocity.length() > 5:
		self.apply_central_force(targetDirection.normalized() * -1)
	
var positions: Array[Vector2] = []
func checkGameOver(delta: float):
	positions.append(Vector2(self.position.x, self.position.z))
	
	if len(positions) <  secondsUntilGameOver / delta:
		return
		
	positions.remove_at(0)
	var l1 = (positions[0] - positions[len(positions) - 1]).length()
	var l2 = (positions[0] - positions[int(len(positions) / 2)]).length()
	
	if l1 < .5 && l2 < .5:
		GameManager.gameOver()

func _on_body_entered(body: Node) -> void:
	if body.name == 'Stairs' || body.name == 'FloorCollider':
		AudioManager.create_audio_at_location(position, SfxSetting.SOUND_EFFECT_TYPE.Stair)
	elif body.name.to_lower().contains('wood'):
		AudioManager.create_audio_at_location(position, SfxSetting.SOUND_EFFECT_TYPE.Wood)
	else:
		print(body.name)
	

func _physics_process(delta: float) -> void:
	if !GameManager.hasGameStarted || GameManager.isGameOver:
		return
	
	GameManager.setScore((self.position.y - 5) * -1)
	
	checkGameOver(delta)
	
	var isGrounded = checkGrounded()
	if isGrounded:
		if jump_timeout_left <= 0.0:
			is_grounded_grace_time_left = is_grounded_grace_time
	else:
		jump_timeout_left = -1.0
		
	# print("{isGrounded} {is_grounded_grace_time_left} {jump_timeout_left}".format({"isGrounded": isGrounded, "is_grounded_grace_time_left": is_grounded_grace_time_left, "jump_timeout_left": jump_timeout_left}))
		
	if is_grounded_grace_time_left > 0.0:
		isGrounded = true
		
	
	
	if Input.is_action_just_pressed("Jump"):
		if isGrounded and jump_timeout_left <= 0.0:
			# print("Jump")
			flyTime = maxFlyTime;
			isAscending = true
			is_grounded_grace_time_left = -1.0
			jump_timeout_left = jump_timeout
			self.linear_velocity.y = 0
			self.apply_central_impulse(Vector3(0, 3, 0))
			AudioManager.create_audio_at_location(self.position, SfxSetting.SOUND_EFFECT_TYPE.Jump)
		else:
			flyTime = -1
			isAscending = false
			self.linear_velocity.y = 0
			self.apply_central_impulse(Vector3(0, -9, 0))
			AudioManager.create_audio_at_location(self.position, SfxSetting.SOUND_EFFECT_TYPE.Swoosh)
		
	if Input.is_action_pressed("Jump") && isAscending:
		flyTime -= delta;
		self.apply_central_force(Vector3(0, max(10 * (flyTime / maxFlyTime), 3), 0))
	elif linear_velocity.y < 0 && !isGrounded && isAscending:
		self.apply_central_force(Vector3(0, 3, 0))
	
	jump_timeout_left -=delta
	is_grounded_grace_time_left -= delta
	
	controlSpeed()
