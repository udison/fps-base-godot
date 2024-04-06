extends Node
class_name State

signal state_changed


func enter():
	pass


func exit():
	pass


func input(event):
	pass


func process(delta: float):
	pass


func physics_process(delta: float):
	pass


func change_to(new_state_name: String):
	state_changed.emit(self, new_state_name)
