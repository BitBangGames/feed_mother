extends Node

const SCREEN_SIZE: Vector2i = Vector2i(0b101000000, 0b11001000)
const SCREEN_CENTER: Vector2i = Vector2i(SCREEN_SIZE.x >> 1, SCREEN_SIZE.y >> 1)

const SPEED: int = 0b110000
const JUMP_HEIGHT: int = 0b10000000
const ACCEL_Y: int = 0b1000

const WORLD_SIZE: int = 0b1100000

const MAP_CANVAS_PATH: NodePath = "/root/Main/Map/MapCanvas"

enum State {
	TITLE_STATE,
	GAME_STATE,
	ENDING_STATE,
}

enum Ending {
	FEED_ENDING,
	DEVOUR_ENDING,
	FALL_ENDING,
	TRUE_ENDING,
}
