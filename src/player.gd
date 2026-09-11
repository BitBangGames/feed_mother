class_name Player
extends Unit

static var __singleton: Player = null

var __input_vector: Vector2

static func get_singleton() -> Player:
	if (__singleton == null):
		__singleton = preload("res://src/player.tscn").instantiate()

	return __singleton

func _init() -> void:
	set_position(Vector3(32.0, 4.0, 32.0))

func _ready() -> void:
	set_sprite(preload("res://src/player_sprite.tscn").instantiate() as Sprite2D)

func _physics_process(_delta: float) -> void:
	__input_vector = Input.get_vector("left", "right", "up", "down")*Consts.SPEED

	if (is_on_floor() and Input.is_action_just_pressed("confirm")):
		set_vel_y(get_vel_y() + Consts.JUMP_HEIGHT)

	set_velocity(Vector3(__input_vector.x, __vel_y, __input_vector.y))

	if (Input.is_action_just_released("right") or Input.is_action_just_released("down")):
		get_anim_player().play("front")
	elif (Input.is_action_just_released("left") or Input.is_action_just_released("up")):
		get_anim_player().play("back")

	if (Input.is_action_pressed("right") or Input.is_action_pressed("down")):
		get_sprite().set_flip_h(Input.is_action_pressed("down"))
		get_anim_player().play("front_walk")
	elif (Input.is_action_pressed("left") or Input.is_action_pressed("up")):
		get_sprite().set_flip_h(Input.is_action_pressed("up"))
		get_anim_player().play("back_walk")

	update_z_index()

	super(_delta)