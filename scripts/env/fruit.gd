extends Area2D

# Chama nosso Sprite2D 
@onready var sprite: Sprite2D = get_node("Texture")

# Array de caminhos das Frutas
var fruits_list: Array = [
	"res://assets/Items/Fruits/Apple.png",
	"res://assets/Items/Fruits/Bananas.png",
	"res://assets/Items/Fruits/Cherries.png",
	"res://assets/Items/Fruits/Kiwi.png",
	"res://assets/Items/Fruits/Melon.png",
	"res://assets/Items/Fruits/Orange.png",
	"res://assets/Items/Fruits/Pineapple.png",
	"res://assets/Items/Fruits/Strawberry.png",
]

# Array com as pontuações de cada fruta
var scores_list: Array = [
	3,
	2,
	5,
	7,
	4,
	8,
	1,
	6
]

# Variavel que salva a pontuação da fruta
var score: int = 0

# Chama o efeito de coletada
@export var collected_effect: PackedScene = null

# Função que reconhece quando o objeto está pronto
func _ready() -> void:
	randomize()
	
	var random_number: int = randi() % fruits_list.size()
	
	sprite.texture = load(
		fruits_list[random_number]
	)
	
	score = scores_list[random_number]
	
# Função que reconhece quando um corpo entra na colisão
func on_body_entered(body) -> void:
	if body.is_in_group("mask_dude"):
		body.update_score(score)
		body.update_health(Vector2.ZERO, randi() % 3 + 1, "increase")
		spawn_effect()
		queue_free()

# Função que chama o efeito de coletado
func spawn_effect() -> void:
	var effect = collected_effect.instantiate()
	effect.global_position = global_position
	get_tree().root.call_deferred("add_child", effect)
	
