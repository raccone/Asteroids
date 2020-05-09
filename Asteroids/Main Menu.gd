extends Control

var Asteroid = load("res://Asteroid.tscn")

var camera_offset = 0

onready var CAMERA_NODE = get_node("/root/MainScene/Camera2D")
onready var STARS_NODE = $Stars


func _ready():
	var screen_w = ProjectSettings.get_setting("display/window/size/width")
	var screen_h = ProjectSettings.get_setting("display/window/size/height")
	var camera_position = Vector2(screen_w, screen_h) / 2
	CAMERA_NODE.position = camera_position
	var rect = STARS_NODE.visibility_rect.grow_individual(0,0,1280,0)
	STARS_NODE.visibility_rect = rect
	var part_mat = STARS_NODE.process_material
	part_mat.emission_box_extents = Vector3(2560, 720, 0)
	STARS_NODE.set_process_material(part_mat)


func _process(delta):
	CAMERA_NODE.set_offset(Vector2(lerp(CAMERA_NODE.get_offset().x, camera_offset, delta*4), 0))
	pass


func _on_NewGame_pressed():
	get_tree().change_scene("res://Viewport.tscn")


func _on_Options_pressed():
	camera_offset = 1280


func _on_Quit_pressed():
	get_tree().quit()


func come_back():
	camera_offset = 0




