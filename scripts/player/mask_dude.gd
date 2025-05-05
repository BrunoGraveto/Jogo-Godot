extends CharacterBody2D

# Variavel que obtem nossa textura
@onready var sprite: Sprite2D = get_node("Texture")

# Variavel que chama a Colisão
@onready var stomp_area_collision: CollisionShape2D = get_node("StompArea/Collision")

# Variavel que salva a pontuação do personagem
var total_score: int = 0

# Variavel que salva quantos pulos foram dados até o personagem encostar no chão
var jump_count: int = 0

# Variavel que salva se o personagem está morto
var is_dead: bool = false

# Variavel que salva se o personagem está recebendo knockback
var on_knockback: bool = false

# Variavel para saber se está no double jump
var is_on_double_jump: bool = false

# Variavel que salva a vida 
var max_health: float = 0.0

# Variavel que salva a direção do knockback
var knockback_direction: Vector2

# Variavel que salva a vida do personagem
@export var health: float = 25.0

# Variavel que define a velocidade de nosso personagem
@export var move_speed: float = 96.0

# Varivel da "velocidade" do pulo
@export var jump_speed: float = -256.0

# Variavel que define a velocidade da gravidade
@export var gravity_speed: float = 512.0

# Variavel que salva o dano que o personagem 
@export var damage: int = 5

# Função que reconhece quando o objeto está pronto
func _ready() -> void:
	max_health = health

# Função que atualiza a cada frame nosso jogo
func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if on_knockback:
		knockback_move()
		return
			
	move()
	velocity.y += delta * gravity_speed
	var _move := move_and_slide()
	jump()
	
	sprite.animate(velocity)
	
# Função para dar knockback
func knockback_move() -> void:
	velocity = knockback_direction * move_speed * 2
	var _move := move_and_slide()
	sprite.animate(velocity)
	
# Função que move nosso personagem
func move() -> void:
	var direction: float = get_direction()
	velocity.x = direction * move_speed
	
# Função que captura as teclas de movimentação do teclado
func get_direction() -> float:
	return (
		Input.get_axis("walk_left", "walk_right")
	)

# Função para dar pulo
func jump() -> void:
	if is_on_floor():
		jump_count = 0
		is_on_double_jump = false
		stomp_area_collision.set_deferred("disabled", true)
	
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		stomp_area_collision.set_deferred("disabled", false)
		velocity.y = jump_speed
		jump_count += 1
		
	if jump_count == 2 and not is_on_double_jump:
		sprite.action_behavior("double_jump")
		is_on_double_jump = true
		
# Função para atualizar a vida do personagem
func update_health(target_position: Vector2, value: int, type: String) -> void:
	if is_dead:
		return
	
	if type == "decrease":
		knockback_direction = (global_position - target_position).normalized()
		sprite.action_behavior("hit")
		on_knockback = true
	
		health = clamp(health - value, 0, max_health)
		transition_screen.current_health = health
		get_tree().call_group("interface", "update_health", health)
		
		if health == 0:
			is_dead = true
			transition_screen.reset()
			sprite.action_behavior("dead")
		
		return
	
	if type == "increase":
		health = clamp(health + value, 0, max_health)
		transition_screen.current_health = health
		get_tree().call_group("interface", "update_health", health)
	

# Função para verificar se o personagem está pulando em um inimigo
func on_stomp_body_entered(body) -> void:
	if body.is_in_group("hazard") and not body.is_invincible:
		body.update_health(damage)
		
		knockback_direction = (global_position - body.global_position).normalized()
		sprite.action_behavior("hit")
		on_knockback = true

# Função para atualizar a pontuação
func update_score(score: int) -> void:
	total_score += score
	transition_screen.current_score = total_score
	get_tree().call_group("interface", "update_score", total_score)
	
