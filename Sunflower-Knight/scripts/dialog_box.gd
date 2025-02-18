extends MarginContainer

# Referências aos nós necessários
@onready var text_label: Label = $label_margin/text_label  # Rótulo onde o texto será exibido
@onready var letter_timer_display: Timer = $letter_timer_display  # Timer para exibir as letras gradualmente

const MAX_WIDTH = 256  # Largura máxima da caixa de diálogo

# Variáveis para controle do texto
var text = ""  # Armazena o texto a ser exibido
var letter_index = 0  # Índice atual da letra sendo exibida

# Tempos para exibição de letras, espaços e pontuações
var letter_display_timer := 0.07  # Tempo entre cada letra
var space_display_timer := 0.05  # Tempo entre cada espaço
var punctuaction_display_timer := 0.2  # Tempo maior para pontuações

# Sinal emitido quando todo o texto for exibido
signal text_display_finished()

# Função para iniciar a exibição do texto
func display_text(text_to_display: String):
	text = text_to_display  # Armazena o texto recebido
	text_label.text = text_to_display  # Define o texto completo inicialmente
	
	await resized  # Aguarda o redimensionamento para ajustar a interface
	
	# Ajusta a largura mínima para não ultrapassar o limite máximo
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	# Se a largura exceder o limite, aplica a quebra automática de linha
	if size.x > MAX_WIDTH:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized  # Aguarda dois ciclos de redimensionamento para garantir a exibição correta
		custom_minimum_size.y = size.y
		
	# Centraliza o texto horizontalmente e posiciona acima da origem
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	
	# Limpa o texto inicial e começa a exibição gradual
	text_label.text = ""
	display_letter()

# Função que exibe as letras uma a uma
func display_letter():
	# Adiciona a letra atual ao texto visível
	text_label.text += text[letter_index]
	letter_index += 1  # Avança para a próxima letra
	
	# Se todas as letras foram exibidas, emite o sinal de finalização
	if letter_index >= text.length():
		text_display_finished.emit()
		return
	
	# Determina o tempo de exibição com base no caractere atual
	match text[letter_index]:
		"!", "?", ",", ".":  # Pontuações recebem um tempo maior
			letter_timer_display.start(punctuaction_display_timer)
		" ":  # Espaços têm um tempo ligeiramente menor
			letter_timer_display.start(space_display_timer)
		_:  # Letras comuns seguem o tempo padrão
			letter_timer_display.start(letter_display_timer)

# Função chamada automaticamente quando o timer termina
func _on_letter_timer_display_timeout() -> void:
	display_letter()  # Exibe a próxima letra
