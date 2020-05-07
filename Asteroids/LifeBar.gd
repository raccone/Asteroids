extends Node2D

signal show

var screen_w
var screen_h

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
	screen_w = get_viewport().size.x
	screen_h = get_viewport().size.y
	hide()
	length = get_parent().lifePoints
	pos = get_parent().global_position


func _draw():
	draw_line(Vector2(-length/4,-50), Vector2(length/4,-50), Color(255, 255, 255), 5)
	if borders["left"]:
		draw_line(Vector2(-length/4,-50)+Vector2(screen_w,0), Vector2(length/4,-50)+Vector2(screen_w,0), Color(255, 255, 255), 5)
	if borders["right"]:
		draw_line(Vector2(-length/4,-50)+Vector2(-screen_w,0), Vector2(length/4,-50)+Vector2(-screen_w,0), Color(255, 255, 255), 5)
	if borders["top"]:
		draw_line(Vector2(-length/4,-50)+Vector2(0,screen_h), Vector2(length/4,-50)+Vector2(0,screen_h), Color(255, 255, 255), 5)
	if borders["bottom"]:
		draw_line(Vector2(-length/4,-50)+Vector2(0,-screen_h), Vector2(length/4,-50)+Vector2(0,-screen_h), Color(255, 255, 255), 5)
	if borders["left"] and borders["top"]:
		draw_line(Vector2(-length/4,-50)+Vector2(screen_w,screen_h), Vector2(length/4,-50)+Vector2(screen_w,screen_h), Color(255, 255, 255), 5)
	if borders["right"] and borders["top"]:
		draw_line(Vector2(-length/4,-50)+Vector2(-screen_w,screen_h), Vector2(length/4,-50)+Vector2(-screen_w,screen_h), Color(255, 255, 255), 5)
	if borders["left"] and borders["bottom"]:
		draw_line(Vector2(-length/4,-50)+Vector2(screen_w,-screen_h), Vector2(length/4,-50)+Vector2(screen_w,-screen_h), Color(255, 255, 255), 5)
	if borders["right"] and borders["bottom"]:
		draw_line(Vector2(-length/4,-50)+Vector2(-screen_w,-screen_h), Vector2(length/4,-50)+Vector2(-screen_w,-screen_h), Color(255, 255, 255), 5)


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
