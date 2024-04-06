extends Node3D


var head: Node3D
var look_input: Vector2 = Vector2.ZERO
var sway_length := 2
var sway_weight := 5


func _ready():
	head = get_parent()


func _input(event):
	if event is InputEventMouseMotion:
		look_input = event.relative


# TODO: move this to a input handling script
func handle_gamepad_look_input():
	var dir = Input.get_vector("look_left_gamepad", "look_right_gamepad", "look_up_gamepad", "look_down_gamepad")
	# TODO: Add configurable deadzone
	if abs(dir.length()) > .01:
		look_input = dir


func _process(delta):
	handle_gamepad_look_input()
	handle_weapon_sway(delta)


func handle_weapon_sway(delta: float):
	if look_input == null:
		return
	
	var target: Vector3 = Vector3(deg_to_rad(look_input.y), deg_to_rad(look_input.x), 0)
	
	rotation = rotation.lerp(target * sway_length, sway_weight * delta)
	
	look_input = look_input.move_toward(Vector2.ZERO, sway_weight * delta)
