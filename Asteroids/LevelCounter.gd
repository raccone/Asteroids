extends MarginContainer

signal update_level
signal life_changed

var animated_health = 100

onready var HP_NODE = $HBoxContainer/HP
onready var LEVELNUMBER_NODE = $HBoxContainer/LevelNumber
onready var TWEEN_NODE = $Tween


func _process(delta):
	HP_NODE.text = str(round(animated_health))


func _on_LevelCounter_update_level(level):
	LEVELNUMBER_NODE.text = str(level)


func _on_LevelCounter_life_changed(lifePoints):
	TWEEN_NODE.interpolate_property(
		self, "animated_health", animated_health,
		lifePoints, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not TWEEN_NODE.is_active():
		TWEEN_NODE.start()


func _on_Area2D_input_event(viewport, event, shape_idx):
	print(event)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().quit(0)


func _on_Button_pressed():
	get_tree().quit(0)
