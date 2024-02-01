@icon("res://addons/godot_states/switchablestate_opt.svg")
extends State
class_name SwitchableState

##This is a special type of node that is designed to run one of its State children at a time if it 
##is activated. By default, the first State child is activated
##Use [code]change_state[/code] on this to switch the state that is run.


##Contains the currently active state
var _active_state


func _supports(node: Node):
	return true ##This can be added to any common node
	
##the [code]_enter_state[/code] callback of this node shouldn't be overwritten. Otherwise,
##changeing_state won't work 
func _enter_state(previous, params = {}):
	if _active_state == null:
		for n in get_children():
			if n._supports(referer):
				if not n.disabled:
					change_state(n.name, {})
					break
			else:
				printerr("state " + n.name + " has been added to " + referer.name + " but doesn't support it!")

	elif not _active_state.disabled:
		_active_state._active = true
		_active_state._enter_state(previous)

##changes the currently active state and call backs
func change_state(state_name, params:Dictionary = {}):
	var next = get_node(NodePath(state_name))
	if _active_state != null:
		if _active_state == next or _active_state.disabled:
			return
		_active_state._active = false
		_active_state._exit_state(next)

	var previous = _active_state

	if next._supports(referer):
		_active_state = next
		_active_state._active = _active
		_active_state._enter_state(previous, params)

##the [code]_exit_state[/code] callback of this node shouldn't be overwritten. Otherwise,
##the active state won't be properly deactivated
func _exit_state(next):
	if _active_state != null :
		_active_state._active = false
		_active_state._exit_state(next)
		_active_state = null
