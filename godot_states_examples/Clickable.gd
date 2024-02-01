extends State

# this state make any Sprite2D emits signals when mouse actions are tirggered on the sprite

signal pressed
signal released
signal clicked

var click_down = false

func _supports(node):
	# define the specs to make it work
	# could also be :
	#return node.has_method("get_rect") and node.has_method('to_local')
	return node is Sprite2D

func _unhandled_input(event):
	if event is InputEventMouseButton:
		var has_point = referer.get_rect().has_point(referer.to_local(event.position))
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT and has_point:
			click_down = true
			emit_signal("pressed")
			
		elif event.button_mask == 0:
			if click_down and has_point:
				emit_signal("released")
				emit_signal("clicked")
				
			click_down = false
