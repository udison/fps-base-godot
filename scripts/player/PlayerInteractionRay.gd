extends RayCast3D
class_name PlayerInteractionRay


func _process(delta):
	if Input.is_action_just_pressed('interact') and is_colliding():
		var object = get_collider()
		
		if object.has_method('on_interaction'):
			print(object)
			object.on_interaction()
		else:
			printerr('[' + str(object) + '] Trying to interact with an object that does not extends "Interactable" class')
