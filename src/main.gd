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
		Consts.State.GAME_STATE:
			__map = preload("res://map/map.tscn").instantiate()
			add_child(__map)

			__map.add_child(Player.get_singleton())
			__map.add_child(Mother.get_singleton())
			__map.add_child(TextBox.get_singleton())

		Consts.State.ENDING_STATE:
			Player.get_singleton().set_velocity(Vector3(0, 0, 0))
			Player.get_singleton().get_anim_player().play("front")
			TextBox.get_singleton().set_text("")

func get_state() -> Consts.State:
	return __state

func init_ending(ending: Consts.Ending) -> void:
	set_state(Consts.State.ENDING_STATE)

	match ending:
		_:
			pass

func exit(err: Error = Error.OK) -> void:
	queue_free()
	get_tree().quit(err)
