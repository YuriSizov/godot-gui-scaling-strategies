extends Window

# This is the built-in behavior for _get_contents_minimum_size with
# the exception of additional support for CanvasLayer children. It's
# not necessary, but it makes this demo project slightly simpler to
# maintain with all the different permutations.


func _get_contents_minimum_size() -> Vector2:
	var content_min_size := Vector2.ZERO

	for child in get_children():
		if child is Control:
			content_min_size = content_min_size.max(_get_control_minimum_size_with_offset(child))

		if child is CanvasLayer:
			content_min_size = content_min_size.max(_get_canvas_layer_minimum_size(child))

	return content_min_size


func _get_control_minimum_size_with_offset(control: Control) -> Vector2:
	return control.position + control.get_combined_minimum_size()


func _get_canvas_layer_minimum_size(canvas_layer: CanvasLayer) -> Vector2:
	var content_min_size := Vector2.ZERO

	for child in canvas_layer.get_children():
		if child is Control:
			content_min_size = content_min_size.max(_get_control_minimum_size_with_offset(child))

	return content_min_size
