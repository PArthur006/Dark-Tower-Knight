extends CharacterBody2D


const SPEED = 125.0
const JUMP_VELOCITY = -300.0 #Pulo alterado de -400 para -300. Motivo: Pulo exagerado.

@onready var animacao := $animacao as AnimatedSprite2D
var jumping := false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
	elif is_on_floor():
		jumping = false
		
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animacao.scale.x = direction
		if !jumping:
			if is_on_floor():
				animacao.play("run")
	elif !is_on_floor():
		velocity.x = direction * SPEED
		animacao.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animacao.play("idle")

	move_and_slide()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
