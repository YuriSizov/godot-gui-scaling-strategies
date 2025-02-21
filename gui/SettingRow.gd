@tool
class_name SettingRow extends HBoxContainer

signal selection_changed()

@export var text: String = "":
	set = set_text
@export var options: Array[String] = []:
	set = set_options

var _button_group: ButtonGroup = null
var _buttons: Array[Button] = []

@onready var _text_label: Label = %Label
@onready var _button_box: HBoxContainer = %Buttons


func _ready() -> void:
	_button_group = ButtonGroup.new()
	_button_group.pressed.connect(_handle_selection_changed.unbind(1))

	_update_label()
	_update_buttons()


# Properties.

func set_text(value: String) -> void:
	if text == value:
		return

	text = value
	_update_label()


func set_options(value: Array[String]) -> void:
	if options == value:
		return

	options = value
	_update_buttons()


func get_selected_option() -> int:
	var active_button := _button_group.get_pressed_button()
	if not active_button:
		return -1

	return active_button.get_index()


func set_selected_option(value: int) -> void:
	var buttons := _button_group.get_buttons()
	if value < 0 || value >= buttons.size():
		return

	buttons[value].button_pressed = true


func _update_label() -> void:
	if not is_node_ready():
		return

	_text_label.text = text


func _update_buttons() -> void:
	if not is_node_ready():
		return

	_buttons.clear()
	for child_node in _button_box.get_children():
		_button_box.remove_child(child_node)
		child_node.queue_free()

	for option_text in options:
		var button := Button.new()
		button.theme_type_variation = "SettingButton"
		button.text = option_text
		button.toggle_mode = true
		button.button_group = _button_group
		button.focus_mode = Control.FOCUS_NONE
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		_button_box.add_child(button)
		_buttons.push_back(button)


func _handle_selection_changed() -> void:
	selection_changed.emit()
