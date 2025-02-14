extends Node

const SCALE_FACTOR_OPTIONS: Array[float] = [ 0.5, 0.75, 1.0, 1.25, 1.5, 2.0 ]
const SCALE_FACTOR_DEFAULT := 2
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
	preload("res://scene/assets/font_oversampling.ttf"),
	preload("res://scene/assets/font_msdf24.ttf"),
	preload("res://scene/assets/font_msdf48.ttf"),
]
const FONT_SCALE_DEFAULT := 0

const PRESENTATION_SPACING := 20.0

# Configuration.
@onready var _scale_factor_setting: SettingRow = %ScaleFactorSetting
@onready var _texture_scale_setting: SettingRow = %TextureScaleSetting
@onready var _texture_mipmaps_setting: SettingRow = %TextureMipmapsSetting
@onready var _font_scale_setting: SettingRow = %FontScaleSetting

# Content.
@onready var _window: Window = %Window
@onready var _texture_16x16: TextureRect = %Texture16x16
@onready var _texture_32x32: TextureRect = %Texture32x32
@onready var _texture_64x64: TextureRect = %Texture64x64
@onready var _texture_128x128: TextureRect = %Texture128x128
@onready var _text_label_40px: Label = %TextLabel40px
@onready var _text_label_24px: Label = %TextLabel24px
@onready var _text_label_10px: Label = %TextLabel10px


func _ready() -> void:
	_apply_configuration()

	_scale_factor_setting.set_selected_option(SCALE_FACTOR_DEFAULT)
	_scale_factor_setting.selection_changed.connect(_update_scale_factor)
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
	_update_scale_factor()
	_update_texture_scale()
	_update_texture_mipmaps()
	_update_font_scale()


func _update_scale_factor() -> void:
	var scale_factor_idx := _scale_factor_setting.get_selected_option()
	if scale_factor_idx < 0:
		_window.content_scale_factor = SCALE_FACTOR_OPTIONS[SCALE_FACTOR_DEFAULT]
	else:
		_window.content_scale_factor = SCALE_FACTOR_OPTIONS[scale_factor_idx]

	# Reset the size.
	_window.size = Vector2.ZERO


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
