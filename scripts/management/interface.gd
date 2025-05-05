extends CanvasLayer

# Variavel que chama a Label de Pontuação
@onready var score: Label = get_node("Score")

# Variavel que chama a Label de Vida
@onready var health: Label = get_node("Health")

# Função que reconhece quando o objeto está pronto
func _ready() -> void:
	score.text = 'Score: 0'
	
	if transition_screen.current_score != 0:
		update_score(transition_screen.current_score)

# Função que atualiza a vida na interface
func update_health(value: int) -> void:
	health.text = str(value) + " Health"
	
# Função que atualiza a vida na pontuação
func update_score(new_score: int) -> void:
	score.text = 'Score: ' + str(new_score)
