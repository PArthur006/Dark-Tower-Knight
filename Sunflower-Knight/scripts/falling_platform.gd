extends AnimatableBody2D

# Inicialização de nós e variáveis
@onready var anim := $anim as AnimationPlayer  # Controla as animações da plataforma
@onready var respawn_timer := $respawn as Timer  # Temporizador para respawn da plataforma
@onready var respawn_position := global_position  # Posição inicial para o respawn

@export var reset_timer := 3.0  # Tempo (em segundos) para a plataforma reaparecer

# Velocidade e gravidade
var velocity := Vector2.ZERO  # Velocidade vertical da plataforma
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # Obtém a gravidade padrão do projeto
var is_triggered := false  # Indica se a plataforma foi ativada (balançou e caiu)

# Desativa o processamento de física ao iniciar
func _ready():
	set_physics_process(false)

# Processamento físico: aplica gravidade e move a plataforma
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta  # Aumenta a velocidade devido à gravidade
	position += velocity * delta  # Move a plataforma com base na velocidade calculada

# Verifica se houve colisão com o jogador
func has_collided_with(collision: KinematicCollision2D, collider: CharacterBody2D):
	# Ativa a plataforma apenas na primeira colisão
	if !is_triggered:
		is_triggered = true
		anim.play("shake")  # Inicia a animação de "balançar"
		velocity = Vector2.ZERO  # Reseta a velocidade para evitar movimentos indevidos

# Quando a animação termina, inicia a queda
func _on_anim_animation_finished(anim_name: StringName) -> void:
	set_physics_process(true)  # Ativa o processamento de física, permitindo a queda
	respawn_timer.start(reset_timer)  # Inicia o temporizador para o respawn

# Quando o temporizador expira, reposiciona e reseta a plataforma
func _on_respawn_timeout() -> void:
	set_physics_process(false)  # Desativa a física para reposicionar corretamente
	global_position = respawn_position  # Retorna a plataforma à posição inicial
	
	# Anima o reaparecimento da plataforma com um efeito de crescimento
	if is_triggered:
		var spawn_tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
		spawn_tween.tween_property($texture, "scale", Vector2(1, 1), 0.2).from(Vector2(0, 0))
	
	is_triggered = false  # Reseta o estado da plataforma
