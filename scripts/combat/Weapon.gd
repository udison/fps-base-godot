extends Node3D
class_name Weapon


@export var aim_position := Vector3.ZERO
@export var aim_speed := 10

var holder: Player
var start_position := Vector3.ZERO
var start_rotation := Vector3.ZERO
var target_position: Vector3
var target_rotation: Vector3


func _ready():
	start_position = position
	start_rotation = rotation
	target_position = start_position
	target_position = start_rotation


func _process(delta):
	position = position.lerp(target_position, aim_speed * delta)
	rotation = rotation.lerp(target_rotation, aim_speed * delta)


func initialize_weapon(in_holder):
	holder = in_holder
	holder.attack.connect(fire)
	holder.start_aim.connect(_on_player_start_aim)
	holder.stop_aim.connect(_on_player_stop_aim)


func fire():
	#print('bang!')
	pass


func _on_player_start_aim():
	target_position = aim_position
	target_rotation = Vector3(0, deg_to_rad(180), 0)


func _on_player_stop_aim():
	target_position = start_position
	target_rotation = start_rotation
