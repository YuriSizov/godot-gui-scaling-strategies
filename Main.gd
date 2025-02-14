extends Node

const SCALE_FACTOR_OPTIONS: Array[float] = [ 0.5, 0.75, 1.0, 1.25, 1.5, 2.0 ]
const SCALE_FACTOR_DEFAULT := 2

const PRESENTATION_SPACING := 20.0

# Configuration.
@onready var _scale_factor_setting: SettingRow = %ScaleFactorSetting

# Content.
@onready var _window: Window = %Window


func _ready() -> void:
	_apply_configuration()
	
	_scale_factor_setting.set_selected_option(SCALE_FACTOR_DEFAULT)
	_scale_factor_setting.selection_changed.connect(_update_scale_factor)

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


func _update_scale_factor() -> void:
	var scale_factor := _scale_factor_setting.get_selected_option()
	if scale_factor < 0:
		_window.content_scale_factor = SCALE_FACTOR_OPTIONS[SCALE_FACTOR_DEFAULT]
	else:
		_window.content_scale_factor = SCALE_FACTOR_OPTIONS[scale_factor]
	
	# Reset the size.
	_window.size = Vector2.ZERO
