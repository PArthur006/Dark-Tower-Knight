extends StaticBody2D

@export var next_level: String = "res://Scenes/fase_2.tscn"  # Caminho da próxima fase
@onready var message_key = $ColorRect


func _ready():
	$Area2D.body_entered.connect(_on_body_entered)  # Conectar o evento

func show_message_key():
	message_key.visible = true
	await get_tree().create_timer(2.0).timeout  # Espera 2 segundos
	message_key.visible = false  # Esconde a mensagem


func _on_body_entered(body):
	if body.is_in_group("Player"):
		if KeyManager.key:
			print("Porta aberta!")
			$CollisionShape2D.disabled = true  # Desativa a colisão física
			queue_free()  # Remove a porta visualmente
			print("Passando para a próxima fase!")
			get_tree().change_scene_to_file(next_level)  # Muda de fase
		else:
			print("Você precisa de uma chave!")  # Mensagem no console
			show_message_key()
