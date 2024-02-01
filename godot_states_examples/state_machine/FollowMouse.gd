extends State

func _supports(node):
	return node is Node2D

func _process(delta):
	referer.global_position = referer.get_global_mouse_position()
