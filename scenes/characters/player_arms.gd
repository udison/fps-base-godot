extends Node3D

func go_to_idle():
	print("Idleing")
	$AnimationPlayer.stop()
	$AnimationPlayer.play("punch_idle")
