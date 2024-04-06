extends Camera3D

@export_group('Head Bob')
@export var enable_head_bob := true
@export var v_frequency := 10.0
@export var v_amplitude := .015
@export var h_frequency := 6.0
@export var h_amplitude := .01
@export var aiming_multiplier_freq := .6
@export var aiming_multiplier_amp := .2

var player: Player
var time: float


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	time += delta
	handle_head_bob(delta)


func handle_head_bob(delta: float):
	if !enable_head_bob:
		return
	
	var aim_amp = aiming_multiplier_amp if player.is_aiming else 1
	var aim_freq = aiming_multiplier_freq if player.is_aiming else 1
	var velocity = player.move_input.length()
	
	if velocity > 0:
		var new_y = sin(time * v_frequency * velocity * aim_freq) * (v_amplitude * velocity * aim_amp)
		var new_x = cos(time * h_frequency * velocity * aim_freq) * (h_amplitude * velocity * aim_amp)
		position.y = lerpf(position.y, new_y, 10 * delta)
		position.x = lerpf(position.x, new_x, 10 * delta)
	
	else:
		position.y = lerpf(position.y, 0, 2 * delta)
		position.x = lerpf(position.x, 0, 2 * delta)
