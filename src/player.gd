class_name Player
extends CharacterBody3D

static var __singleton: Player = null

var __input_vector: Vector2
var __vel_y: int
var __collided: bool
var __collided_prev: bool

var __sprite: Sprite2D
var __animation_player: AnimationPlayer

static func get_singleton() -> Player:
	if (__singleton == null):
		__singleton = preload("res://src/player.tscn").instantiate()

	return __singleton

func _init() -> void:
	set_position(Vector3(32.0, 32.0, 32.0))

func _ready() -> void:
	__sprite = preload("res://src/player_sprite.tscn").instantiate()
	__animation_player = __sprite.get_child(0)
	get_node("../MapCanvas").add_child(__sprite)

func _physics_process(_delta: float) -> void:
	__input_vector = Input.get_vector("left", "right", "up", "down")*Consts.SPEED

	if not (is_on_floor()):
		__vel_y = __vel_y - Consts.ACCEL_Y
	elif (Input.is_action_just_pressed("confirm")):
		__vel_y = __vel_y + Consts.JUMP_HEIGHT
	else:
		__vel_y = 0

	set_velocity(Vector3(__input_vector.x, __vel_y, __input_vector.y))

	__collided_prev = __collided
	__collided = false

	__collided = (move_and_slide() and not is_on_floor_only())

	__sprite.set_position(Main.isometric(get_position()))
	__sprite.set_z_index(int(get_position().y) >> 0b11)

	if (Input.is_action_just_released("right") or Input.is_action_just_released("down")):
		__animation_player.play("front")
	elif (Input.is_action_just_released("left") or Input.is_action_just_released("up")):
		__animation_player.play("back")

	if (Input.is_action_pressed("right") or Input.is_action_pressed("down")):
		__sprite.set_flip_h(Input.is_action_pressed("down"))
		__animation_player.play("front_walk")
	elif (Input.is_action_pressed("left") or Input.is_action_pressed("up")):
		__sprite.set_flip_h(Input.is_action_pressed("up"))
		__animation_player.play("back_walk")