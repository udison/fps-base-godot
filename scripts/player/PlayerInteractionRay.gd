extends RayCast3D
class_name PlayerInteractionRay


var interact_hold_time := 0.0


func _process(delta):
	handle_interaction(delta)


func handle_interaction(delta: float):
	if not is_colliding():
		return
		
	if Input.is_action_just_pressed('interact'):
		var object = get_collider()
		
		if object.has_method('on_interaction'):
			object.on_interaction()
		else:
			printerr('[' + str(object) + '] Trying to interact with an object that does not extends "Interactable" class')
