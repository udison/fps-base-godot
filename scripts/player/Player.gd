extends CharacterBody3D
class_name Player

signal attack
signal start_aim
signal stop_aim

const MAX_HEAD_ROTATION = deg_to_rad(89)

enum Stance {
	STAND,
	CROUCH,
	PRONE
}

@export var walk_speed := 4.0
@export var run_speed := 6.0
@export var crouch_speed := 2.0
@export var prone_speed := 1.0
@export var acceleration := 7.0

@export_group("Combat")
@export var velocity_multiplier_when_aiming := .5

@export_group("Lean")
@export var lean_degrees := 18.0
@export var lean_velocity := 5.0
@export var velocity_multiplier_when_leaning := .5

@export_group("Jump")
@export var jump_velocity := 4.5

@export_group("Stances")
@export var stance_change_speed = 5.0

@export_subgroup("Standing")
@export var character_height_standing := 1.75
@export var head_height_standing := 1.6

@export_subgroup("Crouching")
@export var character_height_crouching := .875
@export var head_height_crouching := .725

@export_subgroup("Prone")
@export var character_height_prone := .5
@export var head_height_prone := .45

@export_group("Mouse and Keyboard")
@export_range(0.01, 5) var mouse_sensitivity := .1

@export_group("Controller")
@export_range(1, 10) var gamepad_sensitivity := 3

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var collision: CollisionShape3D = $Collision
@onready var standing_ceilling_check: RayCast3D = $StandingCeillingCheck
@onready var crouching_ceilling_check: RayCast3D = $CrouchingCeillingCheck
@onready var state_machine: StateMachine = $StateMachine
@onready var arms: Node3D = $Head/Arms
@onready var arms_animation: AnimationPlayer = $Head/Arms/Arms/AnimationPlayer

@onready var GLOBALS: GlobalsAL = get_node('/root/Globals')

var speed := 4.0
var move_input := Vector2.ZERO
var direction := Vector3.ZERO
var head_height := head_height_standing
var lean_direction := 0.0 # -1 left | right +1
var is_aiming := false
var aiming_mode := 'press' # TODO: move this to a configuration
var current_stance := Stance.STAND

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	GLOBALS.player = self
	camera.player = self
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for state in state_machine.states:
		state_machine.states.get(state).player = self
	
	check_equipped_weapon()


func _input(event):
	if event is InputEventMouseMotion:
		look(event.relative, mouse_sensitivity)


func _physics_process(delta: float):
	apply_gravity(delta)
	lerp_head_height(delta)
	handle_gamepad_look()
	move_and_slide()
	handle_lean(delta)
	handle_attack()
	handle_aiming()


# TODO: move this to a input handling script
func handle_gamepad_look():
	var dir = Input.get_vector("look_left_gamepad", "look_right_gamepad", "look_up_gamepad", "look_down_gamepad")
	# TODO: Add configurable deadzone
	if abs(dir.length()) > .01:
		look(dir, gamepad_sensitivity)


func look(direction: Vector2, sensitivity: float = 1):
	# Rotates player
	rotate_y(-deg_to_rad(direction.x * sensitivity))
	
	# Rotates head
	head.rotate_x(-deg_to_rad(direction.y * sensitivity))
	head.rotation.x = clamp(head.rotation.x, -MAX_HEAD_ROTATION, MAX_HEAD_ROTATION)


func apply_gravity(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


func can_jump() -> bool:
	return Input.is_action_just_pressed("jump") and is_on_floor()


func jump():
	velocity.y = jump_velocity


func is_falling() -> bool:
	return velocity.y < 0


func get_state_name() -> String:
	if (!state_machine.current_state):
		return 'null'
	
	return state_machine.current_state.name


func set_stance(stance: Stance):
	var character_height = character_height_standing
	current_stance = stance
	
	match stance:
		Stance.STAND:
			speed = walk_speed
			character_height = character_height_standing
			head_height = head_height_standing
		
		Stance.CROUCH:
			speed = crouch_speed
			character_height = character_height_crouching
			head_height = head_height_crouching
		
		Stance.PRONE:
			speed = prone_speed
			character_height = character_height_prone
			head_height = head_height_prone
	
	collision.shape.height = character_height
	collision.position.y = character_height / 2


func is_standing():
	return current_stance == Stance.STAND


func is_crouching():
	return current_stance == Stance.CROUCH


func is_proning():
	return current_stance == Stance.PRONE


func lerp_head_height(delta: float):
	head.position.y = lerp(head.position.y, head_height, delta * stance_change_speed)


func handle_movement(delta: float):
	# Get the input direction and handle the movement/deceleration.
	move_input = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized(), delta * acceleration)
	
	var lean_multiplier = velocity_multiplier_when_leaning if lean_direction != 0 else 1
	var aim_multiplier = velocity_multiplier_when_aiming if is_aiming else 1
	
	if direction:
		velocity.x = direction.x * speed * lean_multiplier * aim_multiplier
		velocity.z = direction.z * speed * lean_multiplier * aim_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


# TODO: move these input handlers to a separate script
func handle_attack():
	if Input.is_action_just_pressed('fire'):
		attack.emit()
		arms_animation.play("punch_attack_1")


func handle_aiming():
	if aiming_mode == 'press':
		if Input.is_action_just_pressed('aim'):
			if not is_aiming:
				start_aim.emit()
				is_aiming = true
			else:
				stop_aim.emit()
				is_aiming = false
		


func check_equipped_weapon():
	for child in arms.get_children():
		if child is Weapon:
			child.initialize_weapon(self)
			break


func check_lean():
	if Input.is_action_just_pressed('lean_right'):
		lean_direction = 1 if not lean_direction else 0
	elif Input.is_action_just_pressed('lean_left'):
		lean_direction = -1 if not lean_direction else 0


func lean_to(direction: float):
	lean_direction = direction


func handle_lean(delta: float):
	rotation.z = lerp_angle(rotation.z, deg_to_rad(-lean_direction * lean_degrees), lean_velocity * delta)
