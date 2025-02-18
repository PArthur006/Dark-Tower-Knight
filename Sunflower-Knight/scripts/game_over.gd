extends Control

# Função chamada ao pressionar o botão de reinício
func _on_restart_btn_pressed() -> void:
	# Retorna o jogador para a tela inicial do jogo
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

# Função chamada ao pressionar o botão de sair
func _on_quit_btn_pressed() -> void:
	# Encerra o jogo
	get_tree().quit()
