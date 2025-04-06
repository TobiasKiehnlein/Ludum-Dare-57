extends RigidBody3D

@export var maxFlyTime = 1
@export var secondsUntilGameOver = 3

@onready var head: MeshInstance3D = $SkeleTON/Skeleton/Skeleton3D/Head_2/Head_2
@onready var jaw: MeshInstance3D = $SkeleTON/Skeleton/Skeleton3D/Jaw_2/Jaw_2
@onready var skeleton: Node3D = $SkeleTON


var flyTime = -1;
var isAscending = false

func _ready() -> void:
	self.freeze = true
	
	GameManager.game_started.connect(handleGameStart)
	GameManager.game_over.connect(func(): self.freeze = true)

func handleGameStart():
	self.freeze = false
	head.reparent(self)
	jaw.reparent(self)
	skeleton.hide()
	

func checkGrounded() -> bool:
	var from = self.global_position
	var to = from - Vector3.UP * 0.6  # Adjust length as needed
	DebugDraw3D.draw_arrow(from, to, Color(1,0,0), .1)
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
	

func _physics_process(delta: float) -> void:
	if !GameManager.hasGameStarted:
		return
		
	checkGameOver(delta)
	
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
