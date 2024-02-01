extends State

@export var opacity = 0.5

var old_opacity

func _supports(node):
	return node is CanvasItem

func _enter_state(_previous, _params = {}):
	old_opacity = referer.modulate.a
	referer.modulate.a = opacity
	
func _exit_state(_next):
	referer.modulate.a = old_opacity
