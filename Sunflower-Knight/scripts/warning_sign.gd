extends Node2D

# Referências para o sprite de interação e a área de detecção
@onready var texture: Sprite2D = $texture
@onready var area_sign: Area2D = $area_sign

# Mensagens exibidas no diálogo
const lines: Array[String] = [
	"Mesmo nas trevas,",
	"um girassol resiste...",
	"As trevas avançam...",
	"Está pronto para enfrentá-las?",
	"Use ◀️ para andar à esquerda.",
	"Use ▶️ para andar à direita.",
	"Pressione ⬆ para pular.",
	"Pressione espaço para atacar!",
	"Coragem. Força. Determinação.",
	"Sua jornada começa agora...",
]

# Verifica entradas não tratadas para ativar o sinal e iniciar o diálogo
func _unhandled_input(event):
	# Se o jogador estiver próximo (corpo dentro da área)
	if area_sign.get_overlapping_bodies().size() > 0:
		texture.show()  # Mostra o ícone que indica interação

		# Inicia o diálogo ao pressionar o botão de interação (ui_focus_next)
		if event.is_action_pressed("ui_focus_next") && !DialogManager.is_message_active:
			texture.hide()  # Esconde o ícone após iniciar o diálogo
			DialogManager.start_message(global_position, lines)
	else:
		# Esconde o ícone se não houver ninguém próximo
		texture.hide()

		# Fecha o diálogo se ainda existir uma caixa ativa
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false
