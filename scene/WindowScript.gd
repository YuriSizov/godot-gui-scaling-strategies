extends Window

# There are a couple of things to consider when working with windows
# and scales.
#
# First, the minimum size of the window is not influenced by the scale
# factor, neither Window's own content_scale_factor, nor scales of
# individual top-level controls.
#
# Second, Window's built-in content minimum size computation doesn't
# handle all grow direction options very well.
#
# We override _get_contents_minimum_size to change how the content
# size computations work to work around these issues.


func _get_contents_minimum_size() -> Vector2:
	var content_min_size := Vector2.ZERO

	for child in get_children():
		if child is Control:
			content_min_size = content_min_size.max(_get_control_minimum_size_with_offset(child))

		if child is CanvasLayer:
			content_min_size = content_min_size.max(_get_canvas_layer_minimum_size(child))

	return content_min_size * content_scale_factor


# To address the first issue, we must add necessary scaling to both
# the total computed size (which must be influenced by content_scale_factor)
# and the size of each individual control (which must account for
# its own scale).
#
# The second issue is trickier. The original code tries to account for
# the positional offset of the control. This helps when the control is
# not anchored to the window on all side and is instead positioned
# manually. This, however, breaks when grow direction is set to "both"
# on either axis, which makes the offset negative and leads to the
# overall computed size to be smaller than the control actually is.
#
# Instead of adding the offset directly we calculate a rectangle that
# encompasses both the entire control and the coordinate system origin,
# a.k.a. Vector2.ZERO, a.k.a. the top-left corner of the window.

func _get_control_minimum_size_with_offset(control: Control) -> Vector2:
	if not control.visible:
		return Vector2.ZERO

	var control_min_size := control.get_combined_minimum_size()
	var control_rect := Rect2(control.position, control_min_size)
	control_rect = control_rect.expand(Vector2.ZERO)

	return control_rect.size * control.scale


# As an extra, we include a small improvement that helps us to also
# account for UI elements inside of top-level canvas layers. Canvas
# layers are often used to separate UI node from the world, especially
# in 2D games where the UI might be affected by the camera otherwise.

func _get_canvas_layer_minimum_size(canvas_layer: CanvasLayer) -> Vector2:
	var content_min_size := Vector2.ZERO

	for child in canvas_layer.get_children():
		if child is Control:
			content_min_size = content_min_size.max(_get_control_minimum_size_with_offset(child))

	return content_min_size
