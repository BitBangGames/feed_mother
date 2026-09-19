class_name Mother
extends Unit

static var __singleton: Mother = null

var __eggs: int
var __timer: Timer

static func get_singleton() -> Mother:
	if (__singleton == null):
		__singleton = preload("res://src/mother.tscn").instantiate()

	return __singleton

func _init() -> void:
	__eggs = 0
	set_position(Vector3(80.0, 8.0, 80.0))

func _ready() -> void:
	__timer = get_node("Timer") as Timer
	set_sprite(preload("res://src/mother_sprite.tscn").instantiate() as Sprite2D)

func _physics_process(_delta: float) -> void:
	super(_delta)

	if (get_velocity().y < 0):
		await Main.get_singleton().init_ending(Consts.Ending.TRUE_ENDING)
		get_anim_player().play("scream")
	set_velocity(Vector3(0, get_velocity().y, 0))

func _process(_delta: float) -> void:
	if not (is_broken()):
		if (__timer.get_time_left() < 15.0):
			get_anim_player().play("shake_fast")
		elif (__timer.get_time_left() < 30.0):
			get_anim_player().play("shake")

func _on_timer_timeout() -> void:
	get_anim_player().stop()
	set_broken(true)

func set_broken(val: bool) -> void:
	TextBox.get_singleton().set_text("")
	super(val)

func get_eggs() -> int:
	return __eggs

func feed_mother() -> void:
	__eggs = __eggs + 1
	if (__eggs > 0b11):
		set_broken(true)
		return

	get_anim_player().play("eye_open")
	__timer.start()
	if (__eggs == 0b11):
		__timer.set_paused(true)

	TextBox.get_singleton().set_text_arr(__eggs)
