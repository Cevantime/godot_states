extends RigidBody2D
class_name StateRigidBody2D

##A RigidBody2D designed to work with States
##You can inherit from it or just copy those three lines of code to make your RigidBodies
##work with this plugin
##[codeblock]
##signal _forces_integrated
##
##func _integrate_forces(state):
##    emit_signal("_forces_integrated", state)
##[/codeblock]

##The plugin will automatically connect this signal to the [code]_integrate_forces[/code] callback 
##of the State nodes
signal _forces_integrated

func _integrate_forces(state):
	emit_signal("_forces_integrated", state)
