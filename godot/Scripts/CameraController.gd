extends Node3D

@onready
var camera = $Camera3D

@export
var ball: Node3D

@export
var cameraOffset: Vector3
@export var cameraLookOffset: Vector3

func _ready() -> void:
	GameManager.ready()
	self.position.y = ball.position.y
	camera.look_at_from_position(self.position + cameraOffset, self.position + cameraLookOffset)

func _physics_process(delta):
	var newY = lerp(self.position.y, ball.position.y, .1 if self.position.y > ball.position.y else .03)
	
	self.position.y = newY
	
	var ballVector = Vector2(ball.position.x, ball.position.z)
	var ballAngle = ballVector.angle_to_point(Vector2.ZERO)
	
	self.rotation_degrees = Vector3(0, ballAngle * -360 / (2 * PI) + 90, 0)
