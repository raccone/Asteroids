extends VBoxContainer

var max_o = 0
var min_o = -24

var BUS_master = "Master"
var BUS_SFX = "SFX"
var BUS_music = "Music"

onready var GLOBALS = get_node("/root/GlobalVariables")

onready var SFXSlider = $VolumeContainer/Sounds/SoundsSlider
onready var MusicSlider =$VolumeContainer/Music/MusicSlider
onready var MasterSlider = $VolumeContainer/Master/MasterSlider
onready var ShakeButton = $VFXContainer/ScreenShake/ShakeButton
onready var FlashButton = $VFXContainer/ScreenFlashing/FlashButton

func _ready():
	SFXSlider.value = GLOBALS.sfx_volume
	MusicSlider.value = GLOBALS.music_volume
	MasterSlider.value = GLOBALS.master_volume
	ShakeButton.pressed = GLOBALS.screen_shake
	FlashButton.pressed = GLOBALS.screen_flash


func map(input, min_input, max_input, min_output, max_output):
	return (input - min_input) / (max_input - min_input) * (max_output - min_output) + min_output


func _on_Back_pressed():
	get_node("../../").come_back()


func _on_SoundsSlider_value_changed(value):
	GLOBALS.sfx_volume = value
	var i = AudioServer.get_bus_index(BUS_SFX)
	if value == 0:
		AudioServer.set_bus_mute(i, true)
	else:
		var real = map(value, 0, 100, min_o, max_o)
		AudioServer.set_bus_mute(i, false)
		AudioServer.set_bus_volume_db(i, real)


func _on_MusicSlider_value_changed(value):
	GLOBALS.music_volume = value
	var i = AudioServer.get_bus_index(BUS_music)
	if value == 0:
		AudioServer.set_bus_mute(i, true)
	else:
		var real = map(value, 0, 100, min_o, max_o)
		AudioServer.set_bus_mute(i, false)
		AudioServer.set_bus_volume_db(i, real)


func _on_MasterSlider_value_changed(value):
	GLOBALS.master_volume = value
	var i = AudioServer.get_bus_index(BUS_master)
	if value == 0:
		AudioServer.set_bus_mute(i, true)
	else:
		var real = map(value, 0, 100, min_o, max_o)
		AudioServer.set_bus_mute(i, false)
		AudioServer.set_bus_volume_db(i, real)


func _on_ShakeButton_toggled(button_pressed):
	GLOBALS.screen_shake = button_pressed


func _on_FlashButton_toggled(button_pressed):
	GLOBALS.screen_flash = button_pressed
