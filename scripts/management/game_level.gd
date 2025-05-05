extends Node2D

# Chama o nó Fruit
@onready var player: CharacterBody2D = get_node("MaskDude")

# Chama o nó Texture
@onready var interface: CanvasLayer = get_node("Interface")

# Variavel que salva o caminho de cena
@export var scene_path: String = ""

# Função que reconhece quando o objeto está pronto 
func _ready() -> void:
	interface.update_health(player.max_health)
	transition_screen.target_path = scene_path
	
	transition_screen.connect(
		"start_level", Callable(self, "start_level")
	)
	
	if transition_screen.current_score != 0:
		player.total_score = transition_screen.current_score
		interface.update_score(transition_screen.current_score)
	
	if transition_screen.current_health != 0:
		player.health = transition_screen.current_health
		interface.update_health(transition_screen.current_health)

# Função que você pode colocar as coisas que irão acontecer após iniciar um level
func start_level() -> void:
	pass
