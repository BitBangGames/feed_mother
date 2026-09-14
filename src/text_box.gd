class_name TextBox
extends Label

static var __singleton: TextBox = null

static func get_singleton() -> TextBox:
	if (__singleton == null):
		__singleton = preload("res://src/text_box.tscn").instantiate()

	return __singleton
