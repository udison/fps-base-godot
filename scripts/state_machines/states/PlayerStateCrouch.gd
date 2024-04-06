extends PlayerState
class_name PlayerStateCrouch


var stance_mode := 'press'
var willing_to_stand_up := false


func enter():
	player.set_stance(player.Stance.CROUCH)


func physics_process(delta):
	player.handle_movement(delta)
	player.check_lean()
	
	if Input.is_action_just_pressed('prone'):
		change_to('prone')
	
	if !willing_to_stand_up:
		var when_press = stance_mode == 'press' and Input.is_action_just_pressed('crouch')
		var when_hold = stance_mode == 'hold' and Input.is_action_just_released('crouch')
		willing_to_stand_up = when_press or when_hold
	
	if willing_to_stand_up and !player.standing_ceilling_check.is_colliding():
		willing_to_stand_up = false
		change_to('walk')
