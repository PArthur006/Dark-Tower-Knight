extends StaticBody2D

# Caminho da próxima fase; pode ser definido no editor
@export var next_level: String = "res://Scenes/fase_2.tscn"

# Referência ao nó que exibe a mensagem de necessidade da chave
@onready var message_key = $ColorRect


# Inicialização do nó
func _ready():
	# Conecta o sinal de detecção de entrada na área ao método correspondente
	$Area2D.body_entered.connect(_on_body_entered)


# Exibe a mensagem informando que a chave é necessária
func show_message_key():
	message_key.visible = true  # Torna a mensagem visível
	await get_tree().create_timer(2.0).timeout  # Aguarda 2 segundos
	message_key.visible = false  # Esconde a mensagem após o tempo definido


# Função chamada ao detectar a entrada de um corpo na área
func _on_body_entered(body):
	# Verifica se o corpo que entrou é o jogador
	if body.is_in_group("Player"):
		# Verifica se o jogador possui a chave necessária
		if KeyManager.key:
			print("Porta aberta!")  # Log no console
			$CollisionShape2D.disabled = true  # Desativa a colisão da porta
			queue_free()  # Remove a porta da cena
			print("Passando para a próxima fase!")
			get_tree().change_scene_to_file(next_level)  # Muda para a fase indicada
		else:
			# Caso não tenha a chave, exibe uma mensagem de aviso
			print("Você precisa de uma chave!")
			show_message_key()
