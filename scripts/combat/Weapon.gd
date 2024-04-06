extends Node3D
class_name Weapon


@export var aim_position := Vector3.ZERO
@export var aim_speed := 10

var holder: Player
var start_position := Vector3.ZERO
var target_position: Vector3


func _ready():
	start_position = position
	target_position = start_position


func _process(delta):
	position = position.lerp(target_position, aim_speed * delta)


func initialize_weapon(in_holder):
	holder = in_holder
	holder.attack.connect(fire)
	holder.start_aim.connect(_on_player_start_aim)
	holder.stop_aim.connect(_on_player_stop_aim)


func fire():
	print('bang!')


func _on_player_start_aim():
	target_position = aim_position


func _on_player_stop_aim():
	target_position = start_position
