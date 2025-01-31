extends RigidBody3D
class_name PhysicalObject


@export_category('Features')
@export var can_hold := false
@export var can_pickup := false


func _ready():
	pass


func _process(delta):
	pass


func on_interaction():
	apply_force(Vector3.UP * 10000 + Vector3.FORWARD * 500)
