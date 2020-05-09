extends Node

onready var parent = get_parent()


func emit(s):
	if len(parent.get_signal_connection_list(s)) > 0:
		parent.emit_signal(s)


func warp(screen_width, screen_height):
	if parent.global_position.x > screen_width:
		emit("warped")
		parent.global_position.x = parent.global_position.x - screen_width
	elif parent.global_position.x < 0:
		emit("warped")
		parent.global_position.x = parent.global_position.x + screen_width
	if parent.global_position.y > screen_height:
		emit("warped")
		parent.global_position.y = parent.global_position.y - screen_height
	elif parent.global_position.y < 0:
		emit("warped")
		parent.global_position.y = parent.global_position.y + screen_height


func _process(delta):
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var screen_height = ProjectSettings.get_setting("display/window/size/height")
	warp(screen_width, screen_height)
