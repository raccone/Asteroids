extends Control

var Asteroid = load("res://Asteroid.tscn")

var camera_offset = 0

var BUS_master = "Master"
var BUS_SFX = "SFX"
var BUS_music = "Music"

onready var GLOBALS = get_node("/root/GlobalVariables")
onready var CAMERA_NODE = get_node("/root/MainScene/Viewport/Camera2D")
onready var STARS_NODE = $Stars

func _ready():
	var camera_position = get_viewport().size / 2
	CAMERA_NODE.position = camera_position
	var rect = STARS_NODE.visibility_rect.grow_individual(0,0,1280,0)
	STARS_NODE.visibility_rect = rect
	var part_mat = STARS_NODE.process_material
	part_mat.emission_box_extents = Vector3(2560, 720, 0)
	STARS_NODE.set_process_material(part_mat)


func _process(delta):
	CAMERA_NODE.set_offset(Vector2(lerp(CAMERA_NODE.get_offset().x, camera_offset, 0.07), 0))
	pass


func _on_Quit_pressed():
	get_tree().quit()


func _on_Options_pressed():
	camera_offset = 1280


func _on_Back_pressed():
	camera_offset = 0


func _on_SoundsSlider_value_changed(value):
	var i = AudioServer.get_bus_index(BUS_SFX)
	if value == -73:
		AudioServer.set_bus_mute(i, true)
	else:
		AudioServer.set_bus_mute(i, false)
		AudioServer.set_bus_volume_db(i, value)


func _on_MusicSlider_value_changed(value):
	var i = AudioServer.get_bus_index(BUS_music)
	if value == -73:
		AudioServer.set_bus_mute(i, true)
	else:
		AudioServer.set_bus_mute(i, false)
		AudioServer.set_bus_volume_db(i, value)


func _on_MasterSlider_value_changed(value):
	var i = AudioServer.get_bus_index(BUS_master)
	if value == -73:
		AudioServer.set_bus_mute(i, true)
	else:
		AudioServer.set_bus_mute(i, false)
		AudioServer.set_bus_volume_db(i, value)


func _on_ShakeButton_toggled(button_pressed):
	GLOBALS.screen_shake = ! GLOBALS.screen_shake


func _on_FlashButton_toggled(button_pressed):
	GLOBALS.screen_flash = ! GLOBALS.screen_flash


func _on_NewGame_pressed():
	get_tree().change_scene("res://Viewport.tscn")
