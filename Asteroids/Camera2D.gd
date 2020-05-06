extends Camera2D

var amplitude = 2.0
var EASE = 1.0
var delay_amount = 15

var player
var color = Color(1,0,0,0)

onready var COLOR_NODE = get_node("/root/Control/ColorRect")
onready var CONTROL_NODE = get_node("/root/Control")
onready var SHAKETIMER_NODE = $ShakeTimer
onready var PLAYERTIMER_NODE = $PlayerTimer


func _ready():
	COLOR_NODE.hide()
	position = get_viewport().size/2


func _process(delta):
	var damping = ease(SHAKETIMER_NODE.time_left / SHAKETIMER_NODE.wait_time, EASE)
	var alpha = ease(PLAYERTIMER_NODE.time_left / PLAYERTIMER_NODE.wait_time, EASE)/2
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)
	COLOR_NODE.color = color
	COLOR_NODE.color.a = alpha
#	COLOR_NODE.color = Color(color.r, color.g, color.b, alpha)


func player_hit(amount):
	color = Color(1,0,0)
	COLOR_NODE.show()
	PLAYERTIMER_NODE.start()
	amount = clamp(amount, 0, 20)
	shake(amount)


func explosion(amount):
	color = Color(1,1,1)
	COLOR_NODE.show()
	PLAYERTIMER_NODE.start()
	amount = clamp(amount, 0, 20)
	shake(amount)


func shake(amount):
	amplitude = amount
	OS.delay_msec(amount*2)
	SHAKETIMER_NODE.start()


func _on_PlayerTimer_timeout():
	COLOR_NODE.hide()
