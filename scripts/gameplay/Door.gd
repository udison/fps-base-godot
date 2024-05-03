extends Node3D


@onready var door = $Door

var is_open := false


func toggle_door_state(source = null):
	if is_open:
		close()
	else:
		open()


func open():
	door.rotation.y = deg_to_rad(90)
	is_open = true


func close():
	door.rotation.y = 0
	is_open = false
