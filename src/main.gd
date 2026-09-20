# Feed Mother
# Copyright (C) 2026 Bit Bang Games

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

class_name Main
extends Node

static var __singleton: Main = null

var __fullscreen: bool = true
var __map: StaticBody3D
var __state: Consts.State
var __endings: PackedByteArray = [false, false, false]

static func get_singleton() -> Main:
	if (__singleton == null):
		__singleton = Main.new()

	return __singleton

func _init() -> void:
	if (__singleton != null and __singleton != self):
		queue_free()

	__singleton = self

	print("Feed Mother by Bit Bang Games")
	print("Source code: https://github.com/BitBangGames/feed_mother")
	print("https://godotengine.org/license")

func _ready() -> void:
	set_state(Consts.State.TITLE_STATE)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			__singleton = null
			print_orphan_nodes()

		NOTIFICATION_WM_CLOSE_REQUEST:
			exit()

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("fullscreen")):
		set_fullscreen(not __fullscreen)

	if (get_state() == Consts.State.TITLE_STATE and (
		Input.is_action_just_pressed("confirm")
		or Input.is_action_just_pressed("click")
	)):
		set_state(Consts.State.GAME_STATE)

func set_fullscreen(val: bool) -> void:
	__fullscreen = val
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if (__fullscreen)
		else DisplayServer.WINDOW_MODE_WINDOWED
	)

func set_state(val: Consts.State) -> void:
	__state = val
	match val:
		Consts.State.TITLE_STATE:
			if (__map):
				__map.queue_free()
			add_child(preload("res://src/title_screen.tscn").instantiate())
			(get_node("./TitleScreen/EndingsBox") as Label).set_text(
				"Endings: " + str(__endings.count(true)) + "/4"
			)

		Consts.State.GAME_STATE:
			get_node("./TitleScreen").queue_free()
			__map = preload("res://map/map.tscn").instantiate()
			add_child(__map)

			__map.add_child(Player.get_singleton())
			__map.add_child(Mother.get_singleton())
			__map.add_child(TextBox.get_singleton())

		Consts.State.ENDING_STATE:
			Player.get_singleton().set_velocity(Vector3(0, Player.get_singleton().get_vel_y(), 0))
			Player.get_singleton().get_anim_player().play("front")
			TextBox.get_singleton().set_text("")

func get_state() -> Consts.State:
	return __state

func init_ending(ending: Consts.Ending) -> void:
	set_state(Consts.State.ENDING_STATE)
	match ending:
		Consts.Ending.FEED_ENDING:
			Mother.get_singleton().get_anim_player().play("mouth_open")
			await get_tree().create_timer(2.0).timeout
			Mother.get_singleton().get_anim_player().play("laugh")

		Consts.Ending.FALL_ENDING:
			Mother.get_singleton().get_anim_player().play("eye_open")
			await get_tree().create_timer(2.0).timeout

			for canvas_item: CanvasItem in get_node(Consts.MAP_CANVAS_PATH).get_children():
				if not (canvas_item.is_visible()):
					canvas_item.set_visible(true)

	if (ending != Consts.Ending.TRUE_ENDING):
		__endings[ending] = true

		await get_tree().create_timer(4.0).timeout
		set_state(Consts.State.TITLE_STATE)

func exit(err: Error = Error.OK) -> void:
	queue_free()
	get_tree().quit(err)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
