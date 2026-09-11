class_name Mother
extends RigidBody3D

static var __singleton: Mother = null

var __sprite: Sprite2D
var __animation_player: AnimationPlayer

static func get_singleton() -> Mother:
	if (__singleton == null):
		__singleton = preload("res://src/mother.tscn").instantiate()

	return __singleton

func _init() -> void:
	set_position(Vector3(80.0, 8.0, 80.0))

func _ready() -> void:
	__sprite = preload("res://src/mother_sprite.tscn").instantiate()
	__animation_player = __sprite.get_child(0)
	get_node("../MapCanvas").add_child(__sprite)

func _physics_process(_delta: float) -> void:
	__sprite.set_position(Main.isometric(get_position()))
	#__sprite.set_z_index(int(get_position().y) >> 0b11)
