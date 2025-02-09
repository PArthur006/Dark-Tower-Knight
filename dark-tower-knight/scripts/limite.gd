extends Area2D

var current_scene = "" 


func _ready():
	current_scene = get_tree().current_scene.scene_file_path #pega em qual fase está
	print (current_scene)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
		print("jogador caiu! na fase:", current_scene)














		#if current_scene == "res://Scenes/fase_1.tscn":
			#get_tree().change_scene_to_file("res://Scenes/fase_1.tscn") #esta voltando do zero 

		#if current_scene == "res://Scenes/fase_2.tscn":
			#get_tree().change_scene_to_file("res://Scenes/fase_2.tscn")
			
# da pra adicionar uma transicao de GAMEOVER aqui e voltar para o menu
# POR ENQUANTO NAO ESTA CONSIDERANDO ViDAS, pois o script do player esta incompleto
