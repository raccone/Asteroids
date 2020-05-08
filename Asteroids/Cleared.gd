extends MarginContainer

signal cleared
signal over

onready var CONTROL_NODE = get_node("/root/Control")
onready var ENEMY_NODE = get_node("/root/Control/Camera2D/Game/Enemy")
onready var BUTTON_NODE = $VBoxContainer/Button
onready var QUIT_NODE = $VBoxContainer/Quit
onready var LABEL_NODE = $VBoxContainer/Label
onready var TIMER_NODE = $Timer


func _ready():
	BUTTON_NODE.hide()
	QUIT_NODE.hide()
	hide()


func _on_Cleared_cleared():
	if ENEMY_NODE.get_child_count() > 0:
		for child in ENEMY_NODE.get_children():
			child.emit_signal("stop")
	BUTTON_NODE.hide()
	QUIT_NODE.hide()
	LABEL_NODE.text = "Level Cleared!"
	show()
	TIMER_NODE.start()


func _on_Timer_timeout():
	if LABEL_NODE.text == "Get Ready":
		CONTROL_NODE.emit_signal("next_level")
		hide()
		TIMER_NODE.stop()
	else:
		LABEL_NODE.text = "Get Ready"


func _on_Cleared_over():
	BUTTON_NODE.show()
	QUIT_NODE.show()
	LABEL_NODE.text = "Game Over"
	if ENEMY_NODE.get_child_count() >= 1:
		ENEMY_NODE.get_child(0).emit_signal("stop")
	show()


func _on_Button_pressed():
	CONTROL_NODE.emit_signal("new_game")
	hide()
	TIMER_NODE.stop()


func _on_Quit_pressed():
	get_tree().quit()
