extends PlayerState
class_name PlayerStateFall


func enter():
	player.lean_to(0)


func physics_process(delta):
	player.handle_movement(delta)
	
	if player.is_on_floor():
		change_to('walk')
