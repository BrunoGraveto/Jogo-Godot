extends Sprite2D

# Variavel para verificar se existe um action_behavior ativo
var on_action: bool = false

# Chama o nó particulas
@export var dust_particles: GPUParticles2D = null

# Chama o nó do animation
@export var animation: AnimationPlayer = null

# Chama o nó do CharacterBody2D
@export var mask_dude: CharacterBody2D = null

# Função que atualiza a direção e os sprites
func animate(velocity: Vector2) -> void:
	change_orientation_based_on_direction(velocity.x)
	
	if on_action:
		dust_particles.emitting = false
		return
		
	if velocity.y != 0:
		dust_particles.emitting = false
		vertical_move_behavior(velocity.y)
		return
	
	horizontal_move_behavior(velocity.x)

# Função que atualiza a direção
func change_orientation_based_on_direction(direction: float) -> void:
	# Direita
	if direction > 0:
		flip_h = false
	
	# Esquerda
	if direction < 0:
		flip_h = true

# Função para chamar determinada animação
func action_behavior(action: String) -> void:
	animation.play(action)
	on_action = true

# Função que atualiza os sprites na vertical
func vertical_move_behavior(direction: float) -> void:
	if direction > 0:
		animation.play("fall")
		
	if direction < 0:
		animation.play("jump")

# Função que atualiza os sprites na horizontal
func horizontal_move_behavior(direction: float) -> void:
	# Se não estiver parado entra no if, caso contrário passa
	if direction != 0:
		animation.play("run")
		dust_particles.emitting = true
		return
		
	dust_particles.emitting = false
	animation.play("idle")

# Função de sinal que reconhece qunado a animação finaliza
func _on_animation_animation_finished(anim_name: StringName) -> void:
	on_action = false
	
	if anim_name == "hit":
		mask_dude.on_knockback = false
		
	if anim_name == "dead":
		hide()
		transition_screen.fade_in()
