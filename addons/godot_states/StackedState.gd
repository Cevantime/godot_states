@icon("res://addons/godot_states/stacked_opt.svg")
extends State
class_name StackedState

##This is a special type of State that is designed to make all of its children active when it is 
##activated

func _supports(node: Node):
	return true #Any node can receive this State
	
##the [code]_enter_state[/code] callback of this node shouldn't be overwritten. Otherwise,
##stacking won't work 
func _enter_state(previous, params = {}):
	for n in get_children():
		if not(n._supports(referer)) :
			printerr("state " + n.name + " has been added to " + referer.name + " but doesn't support it!")
			continue
		if n.disabled:
			continue
		n._active = true
		n._enter_state(previous, params)

##the [code]_exit_state[/code] callback of this node shouldn't be overwritten. Otherwise,
##stacked nodes won't be properly deactivated
func _exit_state(next):
	for n in get_children():
		n._active = false
		n._exit_state(next)

