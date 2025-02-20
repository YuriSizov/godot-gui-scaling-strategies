extends Node

# Scene options.

enum AnchorOption {
	FULL_RECT,
	TOP_LEFT,
	CENTER,
}
const ANCHOR_OPTIONS: Array[int] = [ AnchorOption.FULL_RECT, AnchorOption.TOP_LEFT, AnchorOption.CENTER ]
const ANCHOR_DEFAULT := 0

enum BackgroundOption {
	VOID,
	WORLD_2D,
	WORLD_3D,
}
const BACKGROUND_OPTIONS: Array[int] = [ BackgroundOption.VOID, BackgroundOption.WORLD_2D, BackgroundOption.WORLD_3D ]
const BACKGROUND_DEFAULT := 0

# Scaling options.

enum ScaleTargetOption {
	CONTROL,
	WINDOW,
}
const SCALE_TARGET_OPTIONS: Array[int] = [ ScaleTargetOption.CONTROL, ScaleTargetOption.WINDOW ]
const SCALE_TARGET_DEFAULT := 1

const SCALE_FACTOR_OPTIONS: Array[float] = [ 0.5, 0.75, 1.0, 1.25, 1.5, 2.0 ]
const SCALE_FACTOR_DEFAULT := 2

const RESET_SIZE_OPTIONS: Array[bool] = [ false, true ]
const RESET_SIZE_DEFAULT := 1

# Asset options.

const TEXTURE_SCALE_OPTIONS: Array[Texture2D] = [
	preload("res://scene/assets/texture_1x.svg"),
	preload("res://scene/assets/texture_2x.svg"),
	preload("res://scene/assets/texture_4x.svg"),
]
const TEXTURE_SCALE_DEFAULT := 0

const TEXTURE_MIPMAPS_OPTIONS: Array[bool] = [ false, true ]
const TEXTURE_MIPMAPS_DEFAULT := 0

const FONT_SCALE_OPTIONS: Array[FontFile] = [
	preload("res://scene/assets/font_normal.ttf"),
	preload("res://scene/assets/font_oversampling_2x.ttf"),
	preload("res://scene/assets/font_oversampling_4x.ttf"),
	preload("res://scene/assets/font_msdf_24.ttf"),
	preload("res://scene/assets/font_msdf_48.ttf"),
]
const FONT_SCALE_DEFAULT := 0

const PRESENTATION_SPACING := 20.0

# Configuration.

@onready var _anchor_setting: SettingRow = %AnchorSetting
@onready var _background_setting: SettingRow = %BackgroundSetting

@onready var _scale_target_setting: SettingRow = %ScaleTargetSetting
@onready var _scale_factor_setting: SettingRow = %ScaleFactorSetting
@onready var _reset_size_setting: SettingRow = %ResetSizeSetting

@onready var _texture_scale_setting: SettingRow = %TextureScaleSetting
@onready var _texture_mipmaps_setting: SettingRow = %TextureMipmapsSetting
@onready var _font_scale_setting: SettingRow = %FontScaleSetting

# Content.

@onready var _window: Window = %Window
@onready var _ui_content: Control = %UIContent

@onready var _void_environment: Node = %EnvironmentVoid
@onready var _2d_environment: Node2D = %Environment2D
@onready var _3d_environment: Node3D = %Environment3D

@onready var _texture_16x16: TextureRect = %Texture16x16
@onready var _texture_32x32: TextureRect = %Texture32x32
@onready var _texture_64x64: TextureRect = %Texture64x64
@onready var _texture_128x128: TextureRect = %Texture128x128
@onready var _text_label_40px: Label = %TextLabel40px
@onready var _text_label_24px: Label = %TextLabel24px
@onready var _text_label_10px: Label = %TextLabel10px


func _ready() -> void:
	_apply_configuration()

	_anchor_setting.set_selected_option(ANCHOR_DEFAULT)
	_anchor_setting.selection_changed.connect(_update_anchor)
	_background_setting.set_selected_option(BACKGROUND_DEFAULT)
	_background_setting.selection_changed.connect(_update_background)

	_scale_target_setting.set_selected_option(SCALE_TARGET_DEFAULT)
	_scale_target_setting.selection_changed.connect(_update_scale_factor)
	_scale_factor_setting.set_selected_option(SCALE_FACTOR_DEFAULT)
	_scale_factor_setting.selection_changed.connect(_update_scale_factor)
	_reset_size_setting.set_selected_option(RESET_SIZE_DEFAULT)

	_texture_scale_setting.set_selected_option(TEXTURE_SCALE_DEFAULT)
	_texture_scale_setting.selection_changed.connect(_update_texture_scale)
	_texture_mipmaps_setting.set_selected_option(TEXTURE_MIPMAPS_DEFAULT)
	_texture_mipmaps_setting.selection_changed.connect(_update_texture_mipmaps)
	_font_scale_setting.set_selected_option(FONT_SCALE_DEFAULT)
	_font_scale_setting.selection_changed.connect(_update_font_scale)

	_window.popup_centered()
	_spread_windows()


# Configuration management.

func _spread_windows() -> void:
	if not is_node_ready():
		return

	var main_window := get_window()
	var combined_width := PRESENTATION_SPACING + main_window.size.x + _window.size.x
	var allowed_width := DisplayServer.screen_get_size().x

	var window_offset := (allowed_width - combined_width) / 2.0
	main_window.position.x = window_offset

	window_offset += PRESENTATION_SPACING + main_window.size.x
	_window.position.x = window_offset


func _apply_configuration() -> void:
	_update_anchor()
	_update_background()

	_update_scale_factor()
	_update_texture_scale()
	_update_texture_mipmaps()
	_update_font_scale()


func _get_reset_size() -> bool:
	var reset_idx := _reset_size_setting.get_selected_option()
	var reset_size := RESET_SIZE_OPTIONS[RESET_SIZE_DEFAULT]
	if reset_idx >= 0:
		reset_size = RESET_SIZE_OPTIONS[reset_idx]

	return reset_size


func _update_anchor() -> void:
	var anchor_idx := _anchor_setting.get_selected_option()

	var anchor_preset := ANCHOR_OPTIONS[ANCHOR_DEFAULT]
	if anchor_idx >= 0:
		anchor_preset = ANCHOR_OPTIONS[anchor_idx]

	match anchor_preset:
		AnchorOption.FULL_RECT:
			_ui_content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		AnchorOption.TOP_LEFT:
			_ui_content.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		AnchorOption.CENTER:
			_ui_content.set_anchors_and_offsets_preset(Control.PRESET_CENTER)

	# Reset the size.
	if _get_reset_size():
		_window.size = Vector2.ZERO
	else:
		_window.child_controls_changed()


func _update_background() -> void:
	var background_idx := _background_setting.get_selected_option()

	_2d_environment.visible = (background_idx == BackgroundOption.WORLD_2D)
	_3d_environment.visible = (background_idx == BackgroundOption.WORLD_3D)
	_window.disable_3d = (background_idx != BackgroundOption.WORLD_3D)


func _update_scale_factor() -> void:
	var scale_target_idx := _scale_target_setting.get_selected_option()
	var scale_factor_idx := _scale_factor_setting.get_selected_option()

	var scale_factor := SCALE_FACTOR_OPTIONS[SCALE_FACTOR_DEFAULT]
	if scale_factor_idx >= 0:
		scale_factor = SCALE_FACTOR_OPTIONS[scale_factor_idx]

	# Reset scales.
	_ui_content.scale = Vector2.ONE
	_window.content_scale_factor = 1.0

	match scale_target_idx:
		ScaleTargetOption.CONTROL:
			_ui_content.scale = Vector2.ONE * scale_factor

		ScaleTargetOption.WINDOW:
			_window.content_scale_factor = scale_factor

	# Reset the size.
	if _get_reset_size():
		_window.size = Vector2.ZERO
	else:
		_window.child_controls_changed()

	# Adjust background environments.
	if scale_target_idx == ScaleTargetOption.WINDOW:
		_2d_environment.camera.zoom = Vector2.ONE / scale_factor
	else:
		_2d_environment.camera.zoom = Vector2.ONE


func _update_texture_scale() -> void:
	var texture_scale_idx := _texture_scale_setting.get_selected_option()
	var scaled_texture := TEXTURE_SCALE_OPTIONS[TEXTURE_SCALE_DEFAULT]
	if texture_scale_idx >= 0:
		scaled_texture = TEXTURE_SCALE_OPTIONS[texture_scale_idx]

	_texture_16x16.texture = scaled_texture
	_texture_32x32.texture = scaled_texture
	_texture_64x64.texture = scaled_texture
	_texture_128x128.texture = scaled_texture


func _update_texture_mipmaps() -> void:
	var use_mipmaps_idx := _texture_mipmaps_setting.get_selected_option()
	var use_mipmaps := TEXTURE_MIPMAPS_OPTIONS[TEXTURE_MIPMAPS_DEFAULT]
	if use_mipmaps_idx >= 0:
		use_mipmaps = TEXTURE_MIPMAPS_OPTIONS[use_mipmaps_idx]

	_texture_16x16.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC if use_mipmaps else CanvasItem.TEXTURE_FILTER_LINEAR
	_texture_32x32.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC if use_mipmaps else CanvasItem.TEXTURE_FILTER_LINEAR
	_texture_64x64.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC if use_mipmaps else CanvasItem.TEXTURE_FILTER_LINEAR
	_texture_128x128.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC if use_mipmaps else CanvasItem.TEXTURE_FILTER_LINEAR


func _update_font_scale() -> void:
	var font_scale_idx := _font_scale_setting.get_selected_option()
	var scaled_font := FONT_SCALE_OPTIONS[FONT_SCALE_DEFAULT]
	if font_scale_idx >= 0:
		scaled_font = FONT_SCALE_OPTIONS[font_scale_idx]

	_text_label_40px.add_theme_font_override("font", scaled_font)
	_text_label_24px.add_theme_font_override("font", scaled_font)
	_text_label_10px.add_theme_font_override("font", scaled_font)
