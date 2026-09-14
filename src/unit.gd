@abstract
class_name Unit
extends CharacterBody3D

var __collided: bool
var __collided_prev: bool
var __vel_y: int
var __broken: bool = false

var __sprite: Sprite2D = null

static func isometric(cartesian: Vector3) -> Vector2:
	return Vector2(
		cartesian.x - cartesian.z + Consts.SCREEN_CENTER.x,
		0.5*(cartesian.x + cartesian.z) - cartesian.y + Consts.SCREEN_CENTER.y
	)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			get_sprite().queue_free()

func _physics_process(_delta: float) -> void:
	if not (is_on_floor()):
		set_vel_y(get_vel_y() - Consts.ACCEL_Y)
	elif (get_vel_y() < 0):
		set_vel_y(0)

	set_velocity(Vector3(get_velocity().x, get_vel_y(), get_velocity().z))
	__collided_prev = __collided
	__collided = (move_and_slide() and not is_on_floor_only())

	get_sprite().set_position(isometric(get_position()))

func set_sprite(val: Sprite2D) -> void:
	__sprite = val
	get_node(Consts.MAP_CANVAS_PATH).add_child(__sprite)

func get_sprite() -> Sprite2D:
	return __sprite

func get_anim_player() -> AnimationPlayer:
	return get_sprite().get_child(0) if (get_sprite().get_child(0) is AnimationPlayer) else null

func set_vel_y(val: int) -> void:
	__vel_y = val

func get_vel_y() -> int:
	return __vel_y

func is_collided() -> bool:
	return __collided

func just_collided() -> bool:
	return (__collided and not __collided_prev)

func is_broken() -> bool:
	return __broken

func set_broken(val: bool) -> void:
	__broken = val
	if (get_anim_player()):
		get_anim_player().play("broken")
	else:
		get_sprite().set_frame(1)

func update_z_index() -> void:
	get_sprite().set_z_index(int(get_position().y) >> 0b11)
