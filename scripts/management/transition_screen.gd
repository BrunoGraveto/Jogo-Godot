extends CanvasLayer

# Sinal que iniciou nosso level
signal start_level

# Chama nosso nó animation
@onready var animation: AnimationPlayer = get_node("Animation")
 
# Caminho da pasta da cena que irá chamar
var target_path: String

# Variavel que salvará nossa vida independente de nossa fase
var current_health: int = 0

# Variavel que salvará nossa pontuação independente de nossa fase
var current_score: int = 0

# Função para chamar nossa animação de fade in
func fade_in() -> void:
	animation.play("fade_in")

# Função de sinal que reconhece quando a animação finaliza
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		var _change_scene: bool = get_tree().change_scene_to_file(target_path)
		animation.play("fade_out")
		
	if anim_name == "fade_out":
		var _start: bool = emit_signal("start_level")

# Reseta a vida e pontuação de nosso personagem
func reset() -> void:
	current_health = 0
	current_score = 0
