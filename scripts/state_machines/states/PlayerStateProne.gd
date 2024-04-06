extends PlayerState
class_name PlayerStateProne


var stance_mode := 'press'
var willing_to_stand_up := false


func enter():
	player.set_stance(player.Stance.PRONE)


func physics_process(delta):
	player.handle_movement(delta)
	player.check_lean()
	
	if Input.is_action_just_pressed('crouch') and !player.crouching_ceilling_check.is_colliding():
		change_to('crouch')
	
	if !willing_to_stand_up:
		var when_press = stance_mode == 'press' and Input.is_action_just_pressed('prone')
		var when_hold = stance_mode == 'hold' and Input.is_action_just_released('prone')
		willing_to_stand_up = when_press or when_hold
	
	if willing_to_stand_up:
		if !player.standing_ceilling_check.is_colliding():
			willing_to_stand_up = false
			change_to('walk')
		
		# TODO: This is not working
		elif !player.crouching_ceilling_check.is_colliding():
			willing_to_stand_up = false
			change_to('crouch')
