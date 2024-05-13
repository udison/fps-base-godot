extends Node3D


@onready var door = $Door

@export var open_degrees: float = 120
@export var time_to_open: float = 1 # in seconds

var is_open := false
var target_rotation: float = 0
var tween: Tween


func toggle_door_state(source = null):
	if is_open:
		close()
	else:
		open()
		
	if (tween):
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(door, 'rotation_degrees:y', target_rotation, 1)


func open():
	target_rotation = open_degrees
	is_open = true


func close():
	target_rotation = 0
	is_open = false
