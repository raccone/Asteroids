extends Node2D

signal show

var screen_w
var screen_h

var left
var right
var white
var thickness

var borders = {
	"left": true,
	"right": true,
	"top": true,
	"bottom": true
}

var length
var pos

onready var TWEEN_NODE = $Tween
onready var TIMER_NODE = $Timer


func _ready():
	screen_w = ProjectSettings.get_setting("display/window/size/width")
	screen_h = ProjectSettings.get_setting("display/window/size/height")
	hide()
	length = get_parent().lifePoints
	pos = get_parent().global_position
	left = Vector2(-length/4, -50)
	right = Vector2(length/4, -50)
	white = Color(1, 1, 1)
	thickness = 5


func _draw():
	draw_line(left, right, white, thickness)
	if borders["left"]:
		draw_line(left+Vector2(screen_w,0), right+Vector2(screen_w,0), white, thickness)
	if borders["right"]:
		draw_line(left+Vector2(-screen_w,0), right+Vector2(-screen_w,0), white, thickness)
	if borders["top"]:
		draw_line(left+Vector2(0,screen_h), right+Vector2(0,screen_h), white, thickness)
	if borders["bottom"]:
		draw_line(left+Vector2(0,-screen_h), right+Vector2(0,-screen_h), white, thickness)
	if borders["left"] and borders["top"]:
		draw_line(left+Vector2(screen_w,screen_h), right+Vector2(screen_w,screen_h), white, thickness)
	if borders["right"] and borders["top"]:
		draw_line(left+Vector2(-screen_w,screen_h), right+Vector2(-screen_w,screen_h), white, thickness)
	if borders["left"] and borders["bottom"]:
		draw_line(left+Vector2(screen_w,-screen_h), right+Vector2(screen_w,-screen_h), white, thickness)
	if borders["right"] and borders["bottom"]:
		draw_line(left+Vector2(-screen_w,-screen_h), right+Vector2(-screen_w,-screen_h), white, thickness)


func _process(delta):
	if get_parent().has_method("update_border"):
		borders = get_parent().borders
	rotation = -get_parent().rotation
	update()


func _on_Timer_timeout():
	hide()


func _on_LifeBar_show(new_length):
	show()
	TWEEN_NODE.interpolate_property(self, "length", length, new_length, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not TWEEN_NODE.is_active():
		TWEEN_NODE.start()
	TIMER_NODE.start()
