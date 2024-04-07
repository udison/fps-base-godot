extends Node3D
class_name EntityAudioHandler


@onready var footstep_sound = $FootstepsSound
@onready var footstep_timer = $FootstepsTimer

var entity: CharacterBody3D


func _ready():
	entity = get_parent()


func _physics_process(delta):
	if entity.velocity.length() > 0.1 and footstep_timer.is_stopped():
		footstep_timer.start()
	elif entity.velocity.length() == 0 and not footstep_timer.is_stopped():
		footstep_timer.stop()


func on_footsteps_timeout():
	print('playou')
	footstep_sound.play()
