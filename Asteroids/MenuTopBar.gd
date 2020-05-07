extends Control

signal update_level
signal life_changed

var animated_health = 100

onready var HP_NODE = $LevelCounter/HBoxContainer/HP
onready var LEVELNUMBER_NODE = $LevelCounter/HBoxContainer/LevelNumber
onready var TWEEN_NODE = $LevelCounter/Tween
onready var PAUSE_NODE = $PauseMenu
onready var OPTIONS_NODE = $PauseMenu/Options
onready var PAUSE_MENU_NODE = $PauseMenu/VBoxContainer


func _ready():
	PAUSE_NODE.hide()


func _process(delta):
	HP_NODE.text = str(round(animated_health))


func _on_MenuTopBar_update_level(level):
	LEVELNUMBER_NODE.text = str(level)


func _on_MenuTopBar_life_changed(lifePoints):
	TWEEN_NODE.interpolate_property(
		self, "animated_health", animated_health,
		lifePoints, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not TWEEN_NODE.is_active():
		TWEEN_NODE.start()


#func _on_Area2D_input_event(viewport, event, shape_idx):
#	print(event)
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and event.pressed:
#			get_tree().quit(0)


func _on_PauseButton_pressed():
	PAUSE_NODE.show()
	get_tree().paused = true


func _on_Resume_pressed():
	PAUSE_NODE.hide()
	get_tree().paused = false


func _on_MainMenu_pressed():
	PAUSE_NODE.hide()
	get_tree().paused = false
	get_tree().change_scene("res://MainScene.tscn")


func _on_Options_pressed():
	PAUSE_MENU_NODE.hide()
	OPTIONS_NODE.show()


func _on_QuitButton_pressed():
	get_tree().quit(0)


func come_back():
	PAUSE_MENU_NODE.show()
	OPTIONS_NODE.hide()



