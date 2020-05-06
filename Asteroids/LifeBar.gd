extends Node2D

signal show

var screen_w
var screen_h

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
	draw_line(Vector2(-length/4,-50)+Vector2(0,screen_h), Vector2(length/4,-50)+Vector2(0,screen_h), Color(255, 255, 255), 5)
	draw_line(Vector2(-length/4,-50)+Vector2(0,-screen_h), Vector2(length/4,-50)+Vector2(0,-screen_h), Color(255, 255, 255), 5)
	draw_line(Vector2(-length/4,-50)+Vector2(screen_w,0), Vector2(length/4,-50)+Vector2(screen_w,0), Color(255, 255, 255), 5)
	draw_line(Vector2(-length/4,-50)+Vector2(-screen_w,0), Vector2(length/4,-50)+Vector2(-screen_w,0), Color(255, 255, 255), 5)
	draw_line(Vector2(-length/4,-50)+Vector2(-screen_w,screen_h), Vector2(length/4,-50)+Vector2(-screen_w,screen_h), Color(255, 255, 255), 5)
	draw_line(Vector2(-length/4,-50)+Vector2(-screen_w,-screen_h), Vector2(length/4,-50)+Vector2(-screen_w,-screen_h), Color(255, 255, 255), 5)
	draw_line(Vector2(-length/4,-50)+Vector2(screen_w,screen_h), Vector2(length/4,-50)+Vector2(screen_w,screen_h), Color(255, 255, 255), 5)
	draw_line(Vector2(-length/4,-50)+Vector2(screen_w,-screen_h), Vector2(length/4,-50)+Vector2(screen_w,-screen_h), Color(255, 255, 255), 5)


func _process(delta):
	rotation = -get_parent().rotation
	update()
	pass


func _on_Timer_timeout():
	hide()


func _on_LifeBar_show(new_length):
	show()
	TWEEN_NODE.interpolate_property(self, "length", length, new_length, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not TWEEN_NODE.is_active():
		TWEEN_NODE.start()
	TIMER_NODE.start()
