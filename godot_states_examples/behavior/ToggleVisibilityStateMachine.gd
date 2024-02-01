extends State

# this is an other style of behaviour which target an other node than the one it is added to
# can still be useful when inside a SwitchableStateMachine

# this state toggles the visibility of a target node when toggle_node is called

@export var node_to_toggle: NodePath

var target_node

func _supports(_node):
	target_node = get_node(node_to_toggle)
	var has_visibility = 'visible' in target_node
	if not has_visibility:
		printerr("Toggle visibility state was added to a node that doesn't have a *visible* field")
		return false
	return true

func toggle_node():
	if _active: # this checks that the state is currently active
		target_node.visible = ! target_node.visible
