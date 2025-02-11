extends RigidBody2D

const EXPLOSION = preload("res://assets/mobs/Vilão 2/Sprites/explosion.tscn")
@onready var collision: CollisionShape2D = $collision


func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.take_damge()
	visible = false
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	collision.set_deferred("disabled", true)
	await explosion_instance.animation_finished
	queue_free()
