extends Node2D

const MOVEMENT_SPEED := 40.0

@onready var moving_sprite: Sprite2D = $Sprite2D2
@onready var camera: Camera2D = $Camera2D

var _base_position: Vector2 = Vector2.ZERO
var _offset_position: Vector2 = Vector2.ZERO
var _offset_height_limit: float = 40.0
var _movement_direction: int = 1


func _ready() -> void:
	_base_position = moving_sprite.position


func _process(delta: float) -> void:
	_offset_position.y += _movement_direction * MOVEMENT_SPEED * delta
	if _offset_position.y <= 0 || _offset_position.y >= _offset_height_limit:
		_movement_direction *= -1

	moving_sprite.position.y = _base_position.y + _offset_position.y
