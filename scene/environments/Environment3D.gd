extends Node3D

const MOVEMENT_SPEED := 5.0

@onready var moving_box: CSGBox3D = $CSGBox3D2

var _base_position: Vector3 = Vector3.ZERO
var _offset_position: Vector3 = Vector3.ZERO
var _offset_height_limit: float = 5.0
var _movement_direction: int = 1


func _ready() -> void:
	_base_position = moving_box.position


func _process(delta: float) -> void:
	_offset_position.y += _movement_direction * MOVEMENT_SPEED * delta
	if _offset_position.y <= 0 || _offset_position.y >= _offset_height_limit:
		_movement_direction *= -1

	moving_box.position.y = _base_position.y + _offset_position.y
