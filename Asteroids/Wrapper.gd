extends Node

onready var parent = get_parent()


func emit(s):
	parent.emit_signal(s)


func warp(screen_width, screen_height):
	if parent.global_position.x > screen_width:
		parent.global_position.x = parent.global_position.x - screen_width
		emit("warped")
	elif parent.global_position.x < 0:
		parent.global_position.x = parent.global_position.x + screen_width
		emit("warped")
	if parent.global_position.y > screen_height:
		parent.global_position.y = parent.global_position.y - screen_height
		emit("warped")
	elif parent.global_position.y < 0:
		parent.global_position.y = parent.global_position.y + screen_height
		emit("warped")


func _process(delta):
	var screen_width = get_viewport().size.x
	var screen_height = get_viewport().size.y
	warp(screen_width, screen_height)
