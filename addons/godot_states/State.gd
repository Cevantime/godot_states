@icon("res://addons/godot_states/state_opt.svg")
extends Node
class_name State

##This class is responsible for managing a very specific part of the node logic
##it can be added as a direct child of any node but can also be intricated inside a [SwitchableState]
##or a [StackedState].


##The node affected by this state. 
var referer: Node

##Is this state active or not ? Shouldn't be updated mannually but using SwitchableState or using
##disabled property[br]
##Inactive states are not processed at all
var _active: bool: set = _set_active

##If set to true, explicitly prevent this node from being processed ([code]_active[/code]) even if 
##it should be
@export var disabled: bool: set = set_disabled

func set_disabled(value: bool):
	disabled = value
	if referer == null:
		return
	
	if _active and disabled:
		_set_active(false)
		call_deferred("_exit_state", null, [] )
		
	elif !disabled and !_active :
		if _should_be_active_by_default():
			_set_active(true)
			call_deferred("_enter_state", null, [])
		
		else:
			_set_active(false)

func _set_active(value):
	_active = value
	set_process(_active)
	set_physics_process(_active)
	set_process_input(_active)
	set_process_unhandled_input(_active)
	if referer != null && referer.has_signal("_forces_integrated"):
		if _active and not referer.is_connected("_forces_integrated", Callable(self, "_integrate_forces")):
			referer.connect("_forces_integrated", Callable(self, "_integrate_forces"))
		elif referer.is_connected("_forces_integrated", Callable(self, "_integrate_forces")):
			referer.disconnect("_forces_integrated", Callable(self, "_integrate_forces"))

##return true if this state should be active
func _should_be_active_by_default():
	var parent: Node = get_parent()
	return (not(parent is State) and _supports(parent)) or (parent is StackedState and parent._active and _supports(parent.referer))
		
func _enter_tree():
	var parent = get_parent()
	_active = _should_be_active_by_default()
	if _active:
		if parent.has_method("change_state"):
			referer = parent.referer
		else :
			referer = parent
	elif parent.has_method("change_state"):
		referer = parent.referer
		

func _ready():
	_set_active(_active)
	if _active:
		call_deferred("_enter_state", null, [])
	
	
##Change the state to the specified state name, optionnally passing parameter to it in a Dictionnary
func change_state(state_name: String, params: Dictionary = {}):
	var state_changer = get_state_changer()
	if state_changer != null:
		state_changer.change_state(state_name, params)

##Gets the SwitchableState ancestor that manages this state
func get_state_changer():
	var parent = get_parent()
	while parent != null and not "selected_state" in parent:
		parent = parent.get_parent()
		
	return parent

##Gets all the states of the referer that belong to the specified group
func get_referer_states_in_group(group_name: String):
	var referer_states = []
	for n in get_tree().get_nodes_in_group(group_name):
		if n.referer == referer and n.has_method("change_state"):
			referer_states.push_back(n)

	return referer_states

##Disable all the states of the referer that belong to the specified group
func disable_group(group_name: String, disabled: bool = true):
	for n in get_referer_states_in_group(group_name):
		n.disabled = disabled

##Enable all the states of the referer that belong to the specified group		
func enable_group(group_name: String):
	disable_group(group_name, false)

##[b]Must[/b] be implemented to specify if the node targeted by this state is really supported by it
##You can modify this to return true for a more permissive policy
func _supports(node: Node):
	return false
	
##[b]Can[/b] be implemented to do some work when this state is entered/activated. 
##If previous state passed parameters when using [code]change_state[/code], those parameters can be 
##found here. If this is the initial state, [code]_previous_state[/code] is null
func _enter_state(_previous_state, _params = {}):
	pass
	
##[b]Can[/b] be implemented to do some work when this state is exited/deactivated. 
##If this state has no next state, [code]_next_state[/code] is null
func _exit_state(_next_state):
	pass
	
##Special callback for rigidbodies, equivalent of RigidBodies [code]_integrate_forces[/code]
##The RigidBody must emit a [code]_forces_integrated[/code] signal or inherit from [StateRigidBody]
##for this to work.
func _integrate_forces(_physical_state:PhysicsDirectBodyState2D):
	pass
