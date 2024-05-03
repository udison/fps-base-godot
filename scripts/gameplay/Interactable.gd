extends Node3D
class_name Interactable

signal interacted(object: Node3D)


func on_interaction():
	print('emitting')
	interacted.emit(self)
