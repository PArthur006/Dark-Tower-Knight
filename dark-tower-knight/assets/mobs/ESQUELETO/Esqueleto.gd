extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var wall_det := $WallDetector as RayCast2D
@onready var anim := $Anim as AnimatedSprite2D
@onready var hitbox := $Hitbox 
@onready var hurtbox := $HurtBox 


var health = 50
var damage = 10


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if wall_det.is_colliding(): #processo para virar
		direction = -1
		wall_det.scale.x *= -1
	
	if direction == 1:
		anim.flip_h = false
	else:
		anim.flip_h = true
	velocity.x = direction * gravity * delta
	move_and_slide()

func take_damage(amount:int):
	health -= amount
	anim.play("Hit")
	if health <= 0:
		die()

func die():
	anim.play("Death")
	queue_free()
	

#Ataque esqueleto
func _on_hitbox_body_entered(body):
	if body.is_in_group("Player") and not body.is_attacking:
		body.take_damage(damage)

#Levou dano
func _on_hurt_box_body_entered(body):
	if body.is_in_group("Player") and body.is_attacking:
		take_damage(body.attack_damage)
