extends AnimatedSprite2D

# Função chamada ao detectar a entrada de um corpo na área da chave
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Verifica se o corpo que entrou pertence ao grupo "Player"
	if body.is_in_group('Player'):
		# Define a variável "key" no KeyManager como verdadeira, indicando que o jogador pegou a chave
		KeyManager.key = true
		print("Chave coletada! key =", KeyManager.key)
		# Remove a chave da cena após ser coletada
		queue_free()
