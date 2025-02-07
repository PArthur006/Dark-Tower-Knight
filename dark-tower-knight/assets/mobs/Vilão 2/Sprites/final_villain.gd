extends CharacterBody2D

const SHADOW_BALL := preload("res://shadow_ball.tscn")
const SPEED = 5000.0
var direction := -1
@onready var wall_detector: RayCast2D = $wall_detector
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shadow_point: Marker2D = %Shadow_point

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

#Flags para estados do Boss
var turn_count := 0 
var shadow_attack_count := 0
var can_attack := true
var attack_count := 0
var player_hit := false
var boss_hp := 260

func _ready():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.sacle.x *= -1
		turn_count += 1
	
	
	
	
	match state_machine.get_current_node():
		"moving":
			if direction == 1:
				velocity.x = SPEED * delta
				sprite_2d.flip_h = true
			else:
				velocity.x = -SPEED * delta
				sprite_2d.flip_h = false
		"shadow_attack":
			velocity.x = 0
			await get_tree().create_timer(2.0).timeout
			if can_attack:
				throw_attack()
				can_attack = false
		"take_hit":
			can_attack = false
			await get_tree().create_timer(2.0).timeout
			player_hit = true

	if turn_count <=2:
		animation_tree.set("parameters/conditions/can_move", true)
		animation_tree.set("parameters/conditions/time_attack", false)
	else:
		animation_tree.set("parameters/conditions/can_move", false)
		animation_tree.set("parameters/conditions/time_attack", false)
	
	

	if boss_hp <=0:
		state_machine.travel("death")
		
	move_and_slide()


func throw_attack():
	if attack_count <= 4:
		var bomb_instance = SHADOW_BALL.instanciate()
		add_sibling(bomb_instance)
		bomb_instance.global_position = shadow_point.global_position
		bomb_instance.apply_impulse(Vector2(randi_range(direction * 30, direction *200), randi_range(0,0)))
		$Timer.start()
		attack_count += 1
		
func _on_attack_cooldown_tiemout():
	can_attack = true


func _on_player_body_entered(body):
	set_physics_process(true)

func _on_hurt_box_body_entered(body: Node2D) -> void:
	body.velocity = Vector2(50, -300)
	boss_hp -= 20
	player_hit = true
	turn_count = 0
