class_name Egg
extends Unit

func _ready() -> void:
	set_sprite(preload("res://src/egg_sprite.tscn").instantiate() as Sprite2D)

func _physics_process(_delta: float) -> void:
	update_z_index()
	super(_delta)
