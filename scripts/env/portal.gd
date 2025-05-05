extends Area2D

# Salva o caminho da cena
@export var scene_path: String = ""

# Função que verifica quando um corpo atravessa o portal(no caso, troféu)
func on_body_entered(body) -> void:
	if body.is_in_group("mask_dude"):
		body.sprite.action_behavior("dead")
		body.set_physics_process(false)
