extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var wall_det := $WallDetector as RayCast2D
@onready var texture := $texture as Sprite2D


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if wall_det.is_colliding():
		direction = -1
		wall_det.scale.x *= -1
	

	if direction == 1:
		texture.flip_h = false
	else:
		texture.flip_h = true
	velocity.x = direction * gravity * delta

	move_and_slide()
