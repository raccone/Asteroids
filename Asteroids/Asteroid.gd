extends RigidBody2D

signal hit

var screen_w
var screen_h

var borders = {
	"left": false,
	"right": false,
	"top": false,
	"bottom": false
}

var color = Color(1, 1, 1)
var lifePoints = 100.00

var scl = 1

var min_velocity = 5
var max_velocity = 20

onready var CAMERA_NODE = get_node("/root/Control/Camera2D")
onready var COLLISION_NODE = $MainCollision
onready var LIFEBAR_NODE = $LifeBar
onready var EXPLOSION_NODE = $Explosion
onready var DEATHTIMER_NODE = $DeathTimer
onready var DAMAGETIMER_NODE = $DamageTimer
onready var HITSOUND_NODE = $HitSound
onready var EXPLODESOUND_NODE = $ExplodeSound


func _ready():
	lifePoints *= scl
	screen_w = ProjectSettings.get_setting("display/window/size/width")
	screen_h = ProjectSettings.get_setting("display/window/size/height")


func draw_shape(x: Vector2):
	var points = Array()
	var first_point = Vector2(0,-30)
	points.append(first_point*scl)
	points.append(Vector2(-30,-10)*scl)
	points.append(Vector2(-20, 20)*scl)
	points.append(Vector2( 20, 20)*scl)
	points.append(Vector2( 30,-10)*scl)
	points.append(first_point*scl)
	
	if lifePoints > 0:
		if x != Vector2.ZERO:
			var new_col = COLLISION_NODE.duplicate()
			new_col.position += x.rotated(-rotation)
			add_child(new_col)
		for i in range(0,5):
			draw_line(points[i] + x.rotated(-rotation),
					  points[i+1] + x.rotated(-rotation),
					  color, 1)


func _draw():
	COLLISION_NODE.scale = Vector2(scl,scl)
	EXPLOSION_NODE.scale = Vector2(scl,scl)
	
	draw_shape(Vector2.ZERO)
	if borders["left"]:
		draw_shape(Vector2(screen_w, 0))
	if borders["right"]:
		draw_shape(Vector2(-screen_w, 0))
	if borders["top"]:
		draw_shape(Vector2(0, screen_h))
	if borders["bottom"]:
		draw_shape(Vector2(0, -screen_h))
	if borders["left"] and borders["top"]:
		draw_shape(Vector2(screen_w, screen_h))
	if borders["right"] and borders["top"]:
		draw_shape(Vector2(-screen_w, screen_h))
	if borders["left"] and borders["bottom"]:
		draw_shape(Vector2(screen_w, -screen_h))
	if borders["right"] and borders["bottom"]:
		draw_shape(Vector2(-screen_w, -screen_h))


func update_borders(border, is_overlapping):
	borders[border] = is_overlapping
	update()


func _physics_process(delta):
	if not DAMAGETIMER_NODE.is_stopped():
		var variation = DAMAGETIMER_NODE.time_left / DAMAGETIMER_NODE.wait_time
		color = Color(1, 1-variation, 1-variation)
		update()


func _on_Asteroid_hit(damage):
	HITSOUND_NODE.set_pitch_scale(1/scl + rand_range(-0.2, 0.2))
	HITSOUND_NODE.play()
	DAMAGETIMER_NODE.start()
	lifePoints -= damage
	if lifePoints> 0:
		CAMERA_NODE.shake(damage * scl / 5)
		LIFEBAR_NODE.emit_signal("show", lifePoints)
	else:
		explode()


func explode():
	EXPLODESOUND_NODE.set_pitch_scale(0.7/scl)
	EXPLODESOUND_NODE.play()
	CAMERA_NODE.explosion(5*scl)
	update()
	LIFEBAR_NODE.hide()
	var children_of_bindings = get_children()
	for child in children_of_bindings:
		if child is CollisionPolygon2D:
			child.call_deferred("set_disabled", true)
	DEATHTIMER_NODE.start()
	EXPLOSION_NODE.emitting = true


func _on_DeathTimer_timeout():
	queue_free()

