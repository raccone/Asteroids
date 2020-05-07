extends Node

onready var parent = get_parent()


func emit(s):
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
	var screen_width = get_viewport().size.x
	var screen_height = get_viewport().size.y
	warp(screen_width, screen_height)
