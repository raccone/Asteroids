extends MarginContainer

var shoot = InputEventAction.new()
var left = InputEventAction.new()
var right = InputEventAction.new()
var up = InputEventAction.new()


func _ready():
	shoot.action = "ui_shoot"
	left.action = "ui_left"
	right.action = "ui_right"
	up.action = "ui_up"


func process_event(e):
	Input.parse_input_event(e)


func _on_FireTouch_pressed():
	shoot.pressed = true
	process_event(shoot)


func _on_FireTouch_released():
	shoot.pressed = false
	process_event(shoot)


func _on_ForwardTouch_pressed():
	up.pressed = true
	process_event(up)


func _on_ForwardTouch_released():
	up.pressed = false
	process_event(up)


func _on_LeftTouch_pressed():
	left.pressed = true
	process_event(left)


func _on_LeftTouch_released():
	left.pressed = false
	process_event(left)


func _on_RightTouch_pressed():
	right.pressed = true
	process_event(right)


func _on_RightTouch_released():
	right.pressed = false
	process_event(right)
