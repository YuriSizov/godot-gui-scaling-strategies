@tool
class_name ScaledTexture extends Texture2D

@export var texture: Texture2D = null:
	set = set_texture
@export var target_size: Vector2 = Vector2.ZERO:
	set = set_target_size


func _draw(to_canvas_item: RID, pos: Vector2, modulate: Color, transpose: bool) -> void:
	if not texture:
		return

	var scaled_rect := Rect2(pos, target_size)
	texture.draw_rect(to_canvas_item, scaled_rect, false, modulate, transpose)


func _draw_rect(to_canvas_item: RID, rect: Rect2, tile: bool, modulate: Color, transpose: bool) -> void:
	if not texture:
		return

	texture.draw_rect(to_canvas_item, rect, tile, modulate, transpose)


func _draw_rect_region(to_canvas_item: RID, rect: Rect2, src_rect: Rect2, modulate: Color, transpose: bool, clip_uv: bool) -> void:
	if not texture:
		return

	texture.draw_rect_region(to_canvas_item, rect, src_rect, modulate, transpose, clip_uv)


func _get_width() -> int:
	return int(target_size.x)


func _get_height() -> int:
	return int(target_size.y)


# Properties.

func set_texture(value: Texture2D) -> void:
	if texture == value:
		return

	if texture:
		texture.changed.disconnect(emit_changed)

	texture = value

	if texture:
		texture.changed.connect(emit_changed)

	emit_changed()


func set_target_size(value: Vector2) -> void:
	if target_size == value:
		return

	target_size = value
	emit_changed()
