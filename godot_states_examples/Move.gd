extends State

# this state makes any Node2D move with configurable actions

@export var SPEED: float = 200.0

@export var action_left = "ui_left"
@export var action_right = "ui_right"
@export var action_up = "ui_up"
@export var action_down = "ui_down"

# this works on any Node2D
func _supports(node):
	# could also be:
	#return 'position' in node
	return node is Node2D


# simple movement
func _process(delta):
	referer.position += Input.get_vector(action_left, action_right, action_up, action_down) * delta * SPEED
