@tool
extends EditorPlugin

func _enter_tree():
	var scriptState = preload("State.gd")
	var textureState = preload("state_opt.svg")
	var scriptSwitchableState = preload("SwitchableState.gd")
	var textureSwitchableState = preload("switchable_opt.svg")
	var scriptMultipleState = preload("StackedState.gd")
	var textureMultipleState = preload("stacked_opt.svg")
	var scriptStateRigidBody2D = preload("StateRigidBody2D.gd")
	var scriptStateRigidBody3D = preload("StateRigidBody3D.gd")
	add_custom_type("State", "Node", scriptState, textureState)
	add_custom_type("SwitchableState", "Node", scriptSwitchableState, textureSwitchableState)
	add_custom_type("StackedState", "Node", scriptMultipleState, textureMultipleState)
	add_custom_type("StateRigidBody2D", "RigidBody2D", scriptStateRigidBody2D, null)
	add_custom_type("StateRigidBody3D", "RigidBody3D", scriptStateRigidBody3D, null)

func _exit_tree():
	remove_custom_type("State")
	remove_custom_type("SwitchableState")
	remove_custom_type("StackedState")
	remove_custom_type("StateRigidBody2D")
	remove_custom_type("StateRigidBody3D")
