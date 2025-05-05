extends StaticBody2D

# Chama nosso nó timer
@onready var state_timer: Timer = get_node("StateTimer")

# Chama nosso nó animation 
@onready var animation: AnimationPlayer = get_node("Animation")

# Variavel que salva o valor máximo de nossa vida
var max_health: int = 0

# Váriavel que salva o fogo estará ativo ou não
var current_state: String = "off"

# Váriavel que salva se o fogo esta invencivel
var is_invincible: bool = false 

# Variavel que salva o valor do dano do fogo
@export var damage: int = 5

# Variavel que salva a vida do fogo
@export var health: int = 15

# Função que reconhece quando o objeto está pronto
func _ready() -> void:
	max_health = health

# Função que é chamada a cada ciclo do timer
func on_state_timer_timeout() -> void:
	state_timer.start()
	
	if current_state == "off":
		current_state = "on"
		is_invincible = true
		animation.play(current_state)
		return
		
	if current_state == "on":
		current_state = "off"
		is_invincible = false
		animation.play(current_state)
		return


# Função que detecta se entrou algum corpo na area do fogo
func on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("mask_dude"):
		body.update_health(global_position, damage, "decrease")
		
# Função que atualiza a vida do fogo
func update_health(value: int) -> void:
	print(health);
	if is_invincible:
		return
		
	health = clamp(health - value, 0, max_health)
	if health == 0:
		is_invincible = true 
		state_timer.stop()
		current_state = "off"
		animation.play(current_state)
		return
	
	animation.play("hit")

# Função de sinal que reconhece se a animação foi finalizada
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit":
		animation.play(current_state)
