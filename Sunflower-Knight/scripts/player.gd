extends CharacterBody2D

#MOVIMENTACAO
@onready var animacao := $animacao as AnimatedSprite2D
const SPEED = 125.0
const JUMP_VELOCITY = -350.0
var jumping := false

#VARIAVEIS de VIDA
var health: int = 100 #Valor inicial de saude
var lives: int = 3 #valor inicial de vidas
var dano
var death
#VARIAVEIS de COMBATE
var is_atacking = false #atacando
var atack_damage = 20 #dano

#VARIAVEIS DE ORIENTACAO
var current_scene = "" #fase atual
var start_position: Vector2 #posicao inicial do jogador
var direction

func _ready():
	start_position = global_position # Salva a posição inicial do jogador

#---------------------------------------------

#inputs
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Atribui em project seengs a tecla UP para pular
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
	elif is_on_floor():
		jumping = false

	# Get the input direction and handle the movement/decelera\on.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animacao.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_left"):
		$hitbox/collsion.position.x = -13
	if Input.is_action_just_pressed("ui_right"):
		$hitbox/collsion.position.x = 13
	
	if Input.is_action_just_pressed("ui_select"):
		print("jogador pressionou espaco, chamando a funcao ataque")
		atack()
	# COLISOR COM A PLATAFORMA
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
	_set_state()
	move_and_slide()
	
# atribui a barra de espaco para o ataque


#-------------------------------------------

#COMBATE

#ATAQUE
func atack():
	is_atacking = true
	await get_tree().create_timer(0.5).timeout
	is_atacking = false

# SE O PLAYER FOR ATINGIDO
func _on_hurtbox_body_entered(body):
	if body.is_in_group("Inimigo"): # Verifica se é um inimigo
		take_damage(body.damage) # O player sofre 10 de dano


# DANO
func take_damage(amount: int):
	print("take_damage chamado em:", name)
	if health > 0:
		dano = true
		health -= amount
		print("Vida do jogador:", health)
		await get_tree().create_timer(0.2).timeout # Pequeno delay para mostrar o impacto
		dano = false
	if health <= 0:
		print("Vida do jogador acabou, chamando função die", health)
		die()

#GAME OVER
func die():
	# Marca o jogador como morto
	death = true
	print("O jogador morreu")

	# Reduz uma vida
	lives -= 1
	print("Vidas restantes:", lives)

	# Aguarda 1 segundo antes de continuar a execução
	await get_tree().create_timer(1.0).timeout

	# Reativa o jogador após o tempo de espera
	death = false

	# Verifica se ainda há vidas restantes
	if lives > 0:
		print("Reaparecendo na posição inicial")
		health = 100  # Restaura a vida ao máximo
		global_position = start_position  # Retorna o jogador à posição inicial
	else:
		# Se não houver vidas, muda para a cena de game over
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		
#ANIMAÇÕES
func _set_state():
	var state = "idle"
	if jumping:
		state = "jump"
	if direction != 0:
		state = "run"
	if is_atacking:
		state = "atack"
	if dano:
		state = "hit"
	if death:
		state = "death"
	
	if animacao.name != state:
		animacao.play(state)
		
		

# SE O PLAYER ATINGIR O INIMIGO
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Inimigo") and is_atacking: # se é inimigo e o player está atacando
		body.take_damage(atack_damage) # Causa dano no inimigo
