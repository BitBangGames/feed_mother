class_name Mother
extends Unit

static var __singleton: Mother = null

var __eggs: int = 0

static func get_singleton() -> Mother:
	if (__singleton == null):
		__singleton = preload("res://src/mother.tscn").instantiate()

	return __singleton

func _init() -> void:
	set_position(Vector3(80.0, 8.0, 80.0))

func _ready() -> void:
	set_sprite(preload("res://src/mother_sprite.tscn").instantiate() as Sprite2D)

func _physics_process(_delta: float) -> void:
	super(_delta)

	set_velocity(Vector3(0, get_velocity().y, 0))

func _on_timer_timeout() -> void:
	set_broken(true)

func get_eggs() -> int:
	return __eggs

func feed_mother() -> void:
	get_anim_player().play("eye_open")
	__eggs = __eggs + 1
	(get_node("Timer") as Timer).start()
