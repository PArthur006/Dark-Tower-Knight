extends Control

# Função chamada quando a tela de título é carregada
func _ready() -> void:
	pass  # Nenhuma ação necessária no momento ao iniciar a tela

# Função chamada a cada quadro (frame)
func _process(delta: float) -> void:
	pass  # Não há atualizações necessárias por frame neste momento

# Inicia o jogo ao pressionar o botão "Start"
func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fase_1.tscn")

# Exibe os créditos ao pressionar o botão "Credits" (a ser implementado)
func _on_credits_btn_pressed() -> void:
	pass  # Implementar a lógica de exibição dos créditos posteriormente

# Encerra o jogo ao pressionar o botão "Quit"
func _on_quit_btn_pressed() -> void:
	get_tree().quit()
