extends State
class_name PlayerState

var player: Player


func enter():
	player = get_tree().get_first_node_in_group('player')
