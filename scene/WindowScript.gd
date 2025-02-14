extends Window


# HACK: This is a naive fix to an engine bug. For some reason, window's content scale factor
# affects controls' combined required minimum size, making it smaller the larger the scale is.
# This doesn't seem rational or logical, and the difference isn't even proportional to scale.
#
# Experimentally, I identified that global transform matrices of child controls help to
# counter-act the issue. So here we are.
func _get_contents_minimum_size() -> Vector2:
	var content_min_size := Vector2.ZERO

	for child in get_children():
		if child is Control:
			var child_control := child as Control
			var child_pos := child_control.position
			var child_min_size := (child_control.get_combined_minimum_size() * child_control.get_global_transform()).floor()
			content_min_size = content_min_size.max(child_pos + child_min_size)

		# Unrelated to the hack, but since we're here, we can also account for top-level
		# canvas layers, which is where UI nodes often are.
		if child is CanvasLayer:
			content_min_size = content_min_size.max(_get_canvas_layer_minimum_size(child))

	# Adjusting by the scale factor allows us to correctly shrink the window for scales < 1.0.
	# Previous logic was only tested with scales >= 1.0, which worked by happenstance.
	return content_min_size * content_scale_factor


func _get_canvas_layer_minimum_size(canvas_layer: CanvasLayer) -> Vector2:
	var content_min_size := Vector2.ZERO

	for child in canvas_layer.get_children():
		if child is Control:
			var child_control := child as Control
			var child_pos := child_control.position
			var child_min_size := (child_control.get_combined_minimum_size() * child_control.get_global_transform()).floor()
			content_min_size = content_min_size.max(child_pos + child_min_size)

	return content_min_size
