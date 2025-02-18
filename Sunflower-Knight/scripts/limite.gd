extends Area2D

# Armazena o caminho da cena atual, para possível controle de reinício
var current_scene = "" 

func _ready():
	# Obtém o caminho do arquivo da cena atual ao iniciar
	current_scene = get_tree().current_scene.scene_file_path
	print("Cena atual:", current_scene)

func _on_body_entered(body):
	# Verifica se o corpo que entrou na área pertence ao grupo "Player"
	if body.is_in_group("Player"):
		# Aciona a função de morte do jogador (normalmente lida com vidas e reposicionamento)
		body.die()
		print("Jogador caiu na fase:", current_scene)
