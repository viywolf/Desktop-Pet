extends Node

var volume: float = 50
var is_audio_playing: bool = false
var audio_playing: Array[bool] = [
	false,
	false,
	false,
	false,
]

var stop_movement_setting_changed: bool = false
var stop_movement: bool = false

var music_effects: bool = true
