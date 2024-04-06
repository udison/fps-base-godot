extends Control
class_name Debug


@onready var fpsLabel: Label = $Margin/Container/FPS/Value
@onready var stateLabel: Label = $Margin/Container/State/Value
@onready var velocityLabel: Label = $Margin/Container/Velocity/Value
@onready var speedLabel: Label = $Margin/Container/Speed/Value
@onready var rotationLabel: Label = $Margin/Container/Rotation/Value

@onready var GLOBALS: GlobalsAL = get_node('/root/Globals')

var player: Player


func _ready():
	player = GLOBALS.player


func _process(delta):
	if Input.is_action_just_pressed('debug'):
		visible = !visible
	
	update_values(delta)


func update_values(delta: float):
	if !visible:
		return
	
	fpsLabel.text = str(Engine.get_frames_per_second())
	stateLabel.text = player.get_state_name().to_lower()
	velocityLabel.text = str(player.velocity)
	speedLabel.text = str(player.speed)
	rotationLabel.text = str(Vector3(
		player.head.global_rotation_degrees.x, player.global_rotation_degrees.y, 0
	))
