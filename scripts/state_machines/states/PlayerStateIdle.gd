extends PlayerState
class_name PlayerStateIdle


func enter():
	if player:
		player.set_velocity(Vector3.ZERO)


func physics_process(delta):
	player.check_lean()
	
	if Input.get_vector("left", "right", "forward", "backward"):
		change_to('walk')
	
	if player.can_jump():
		change_to('jump')
	
	if Input.is_action_just_pressed('crouch'):
		change_to('crouch')
	
	if Input.is_action_just_pressed('prone'):
		change_to('prone')
