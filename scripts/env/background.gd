extends ParallaxBackground

# Obtem nosso parallax layer
@onready var parallax_layer: ParallaxLayer = get_node("ParallaxLayer")

# Obtem nosso background layer
@onready var background_layer: TextureRect = get_node("ParallaxLayer/BackgroundLayer")

# Lista de backgrounds
var background_images_list: Array = [
	"res://assets/Background/Blue.png",
	"res://assets/Background/Brown.png",
	"res://assets/Background/Gray.png",
	"res://assets/Background/Green.png",
	"res://assets/Background/Purple.png",
	"res://assets/Background/Yellow.png"
]

# Direção do background
@export var direction: Vector2 = Vector2(-1, 1)

# Velocidade do background
@export var move_speed: float = 19.2

func _ready() -> void:
	background_layer.texture = load(
		background_images_list[randi() % background_images_list.size()
		]
	)
	
func _physics_process(delta: float) -> void:
	parallax_layer.motion_offset += direction * delta * move_speed
