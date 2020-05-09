#extends Node2D
extends PhysicsBody2D

signal warped

var is_enemy = false
var color = Color(1,1,1)
var gradient = Gradient.new()
var trail
var is_visible = true
var scl = 1

onready var COLLISION_NODE = $CollisionShape2D
onready var TIMER_NODE = $Timer
onready var PARTICLES_NODE = $OnHit
onready var AUDIO_NODE = $Sound
onready var TRAIL_NODE = $Trail


func _ready():
	if is_enemy:
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(10, false)
		scl = 0
		color = Color(1,0,0)
	gradient.set_color(0, Color(color.r, color.g, color.b, 0))
	gradient.set_color(1, Color(color.r, color.g, color.b, 1))
	new_trail()
	var circle_shape = CircleShape2D.new()
	circle_shape.set_radius(2)
	COLLISION_NODE.set_shape(circle_shape)
	AUDIO_NODE.set_pitch_scale(rand_range(0.85, 1.15))
	AUDIO_NODE.play(0)


func _physics_process(delta):
	var point = global_position
	trail.add_point(point)
	for child in TRAIL_NODE.get_children():
		if child.get_point_count() <= 0:
			child.queue_free()
			continue
		child.global_position = Vector2(0,0)
		child.global_rotation = 0
		if child.get_point_count() > 10 or child != trail:
			child.remove_point(0)


func new_trail():
	trail = Line2D.new()
	trail.set_width(3)
	trail.set_gradient(gradient)
	TRAIL_NODE.add_child(trail)


func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)


func _draw():
	if is_visible:
		draw_circle_arc_poly(Vector2(0,0), 3, 0, 360, color)
#		draw_line(Vector2(0,0), Vector2(10,0), color, 1)


func _on_Timer_timeout():
	queue_free()


func _on_Bullet_body_entered(body):
	body.emit_signal("hit", 10)
	PARTICLES_NODE.emitting = true
	is_visible = false
	COLLISION_NODE.call_deferred("set_disabled", true)
	update()


func _on_Bullet_warped():
#	set_process(false)
	new_trail()
