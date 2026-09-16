class_name TextBox
extends Label

static var __singleton: TextBox = null

var __text_arr: PackedStringArray = Consts.TEXT_NO_EGGS
var __index: int = 0

static func get_singleton() -> TextBox:
	if (__singleton == null):
		__singleton = preload("res://src/text_box.tscn").instantiate()

	return __singleton

func _init() -> void:
	update_text()

func _on_timer_timeout() -> void:
	if (not Mother.get_singleton().is_broken() and __index + 1 < __text_arr.size()):
		__index = __index + 1
		update_text()

func update_text() -> void:
	set_text(__text_arr[__index])

func set_text_arr(eggs: int) -> void:
	match eggs:
		1:
			__text_arr = Consts.TEXT_ONE_EGG
		0b10:
			__text_arr = Consts.TEXT_TWO_EGGS
		0b11:
			__text_arr = Consts.TEXT_THREE_EGGS
		_:
			set_text("")
			return

	__index = 0
	(get_node("Timer") as Timer).start()
	update_text()
