extends Node2D

@onready var texture: Sprite2D = $texture
@onready var area_sign: Area2D = $area_sign

const lines: Array[String] = [
	"Mesmo nas trevas,",
	"um girassol resiste...",
	"As trevas avançam...",
	"Está pronto para enfrentá-las?",
	"Use ◀️ para andar à esquerda.",
	"Use ▶️ para andar à direita.",
	"Pressione ⬆ para pular.",
	"Pressione espaço para atacar!",
	"Coragem. Força. Determinação",
	"Sua jornada começa agora...",
]


func _unhandled_input(event):
	if area_sign.get_overlapping_bodies().size() > 0:
		texture.show()
		if event.is_action_pressed("ui_focus_next") && !DialogManager.is_message_active:
			texture.hide()
			DialogManager.start_message(global_position, lines)
	else:
		texture.hide()
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue.free()
			DialogManager.is_message_active = false
			
