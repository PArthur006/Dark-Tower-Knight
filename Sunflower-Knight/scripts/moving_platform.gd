extends Node2D

# Tempo de espera no fim do movimento da plataforma
const WAIT_DURATION := 1.0

# Referência ao corpo da plataforma
@onready var platform := $platfom as AnimatableBody2D

# Velocidade de movimento da plataforma
@export var move_speed := 5.0

# Distância que a plataforma percorrerá
@export var distance := 192

# Define se a plataforma se moverá na horizontal (true) ou na vertical (false)
@export var move_horizontal := true

# Ponto de destino atual da plataforma
var follow := Vector2.ZERO

# Fator usado para calcular a duração do movimento com base no tamanho da plataforma
var platform_center := 8

func _ready() -> void:
	# Inicia o movimento da plataforma ao carregar a cena
	move_platform()

func move_platform():
	# Define a direção do movimento: horizontal (direita) ou vertical (para cima)
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance
	
	# Calcula a duração com base na distância e na velocidade definida
	var duration = move_direction.length() / float(move_speed * platform_center)
	
	# Cria uma animação de movimento repetitiva e linear, indo e voltando
	var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	# Move a plataforma até o ponto máximo
	platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
	
	# Retorna a plataforma para a posição inicial após o tempo de espera
	platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(WAIT_DURATION)

func _physics_process(delta: float) -> void:
	# Move a plataforma suavemente em direção ao ponto definido (follow)
	platform.position = platform.position.lerp(follow, 0.5)
