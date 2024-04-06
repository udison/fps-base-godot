extends PlayerState
class_name PlayerStateJump


func enter():
	player.jump()
	player.lean_to(0)


func physics_process(delta):
	player.handle_movement(delta)
	
	if player.is_falling():
		change_to('fall')
	
	if player.is_on_floor():
		change_to('walk')
