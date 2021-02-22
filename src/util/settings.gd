extends Node

const MAX_VOLUME_DB = 2.0
const MIN_VOLUME_DB = -40.0
const MAX_VOLUME = 100.0
const DEFAULT_VOLUME = 75.0
const MIN_VOLUME = 0.0

var master_volume: float = DEFAULT_VOLUME setget set_master_volume
var sfx_volume:float = DEFAULT_VOLUME setget set_sfx_volume
var music_volume:float = DEFAULT_VOLUME setget set_music_volume
var speech_volume:float = DEFAULT_VOLUME setget set_speech_volume

var _master_bus_idx = -1
var _sfx_bus_idx = -1
var _music_bus_idx = -1
var _speech_bus_idx = -1

func _ready():
	_master_bus_idx = AudioServer.get_bus_index("Master")
	_music_bus_idx = AudioServer.get_bus_index("Music")
	_sfx_bus_idx = AudioServer.get_bus_index("Sfx")
	_speech_bus_idx = AudioServer.get_bus_index("Speech")


func set_master_volume(value: float):
	master_volume = clamp(value, MIN_VOLUME, MAX_VOLUME)
	_set_volume(_master_bus_idx, value)


func set_sfx_volume(value: float):
	sfx_volume = clamp(value, MIN_VOLUME, MAX_VOLUME)
	_set_volume(_sfx_bus_idx, value)


func set_music_volume(value: float):
	music_volume = clamp(value, MIN_VOLUME, MAX_VOLUME)
	_set_volume(_music_bus_idx, value)


func set_speech_volume(value: float):
	speech_volume = clamp(value, MIN_VOLUME, MAX_VOLUME)
	_set_volume(_speech_bus_idx, value)


func _set_volume(bus_idx: int, volume: float):
	if volume > MIN_VOLUME:
		AudioServer.set_bus_mute(bus_idx, false)
		AudioServer.set_bus_volume_db(bus_idx, \
			lerp(MIN_VOLUME_DB, MAX_VOLUME_DB, volume / MAX_VOLUME))
		return
	AudioServer.set_bus_mute(bus_idx, true)
