extends PlayerState
class_name PlayerStateWalk


func enter():
	player.set_stance(player.Stance.STAND)


func physics_process(delta):
	player.handle_movement(delta)
	player.check_lean()
	
	if player.velocity.length() < .01:
		change_to('idle')
	
	if player.can_jump():
		change_to('jump')
	
	if player.is_falling():
		change_to('fall')
	
	if Input.is_action_just_pressed('crouch'):
		change_to('crouch')
	
	if Input.is_action_just_pressed('prone'):
		change_to('prone')
