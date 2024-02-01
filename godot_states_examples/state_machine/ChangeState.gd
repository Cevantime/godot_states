extends State

@export var target_state: String

func _supports(node):
	return get_state_changer().has_node(target_state)
	
	
func change_the_state():
	if _active:
		change_state(target_state)
