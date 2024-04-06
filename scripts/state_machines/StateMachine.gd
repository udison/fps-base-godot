extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_changed.connect(on_state_change)
	
	if initial_state:
		current_state = initial_state
		current_state.enter()


func _input(event):
	if current_state:
		current_state.input(event)


func _process(delta):
	if current_state:
		current_state.process(delta)


func _physics_process(delta):
	if current_state:
		current_state.physics_process(delta)


func on_state_change(state: State, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		printerr('[StateMachine] State "' + new_state_name + '" not found!')
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
