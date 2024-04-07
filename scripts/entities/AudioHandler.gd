extends Node3D
class_name EntityAudioHandler

@export_group('Footstep')
@export var footstep_timeout_walking := .6
@export var footstep_timeout_crouching := .8
@onready var footstep_sound = $FootstepsSound
@onready var footstep_timer = $FootstepsTimer

var entity: Player


func _ready():
	entity = get_parent()


func _physics_process(delta):
	handle_footstep()


func handle_footstep():
	footstep_timer.wait_time = footstep_timeout_crouching if entity.is_crouching() else footstep_timeout_walking
	
	if entity.is_proning() or not entity.is_on_floor():
		return
	
	if entity.velocity.length() > 0.1 and footstep_timer.is_stopped():
		footstep_timer.start()
	elif entity.velocity.length() == 0 and not footstep_timer.is_stopped():
		footstep_timer.stop()


func on_footsteps_timeout():
	footstep_sound.play()
