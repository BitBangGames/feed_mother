class_name Mother
extends Unit

static var __singleton: Mother = null

static func get_singleton() -> Mother:
	if (__singleton == null):
		__singleton = preload("res://src/mother.tscn").instantiate()

	return __singleton

func _init() -> void:
	set_position(Vector3(80.0, 8.0, 80.0))

func _ready() -> void:
	set_sprite(preload("res://src/mother_sprite.tscn").instantiate() as Sprite2D)
