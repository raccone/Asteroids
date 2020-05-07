extends RigidBody2D

var Bullet = load("res://Bullet.tscn")

signal hit

var lifePoints = 100.0
var can_control = true
var is_shooting = false
var rotation_amount = 2
var acceleration = 5
var max_velocity = 150
var is_vulnerable = true
var alpha = 1

onready var LEVELCOUNTER_NODE = get_node("/root/Control/LevelCounter")
onready var CLEARED_NODE = get_node("/root/Control/Cleared")
onready var CAMERA_NODE = get_node("/root/Control/Viewport/Camera2D")
onready var LIFEBAR_NODE = $LifeBar
onready var COLLISION_NODE = $CollisionPolygon2D
onready var PARTICLES_NODE = $Particles2D
onready var SHOOTCOOLDOWN_NODE = $ShootCooldown
onready var DEATHANIM_NODE = $DeathAnim
onready var SOUND_NODE = $Engine
onready var HITSOUND_NODE = $HitSound
onready var EXPLOSIONSOUND_NODE = $ExplosionSound
onready var INVUL_NODE = $Invulnerability


func _ready():
	LIFEBAR_NODE.emit_signal("show",lifePoints)
	LEVELCOUNTER_NODE.emit_signal("life_changed", lifePoints)
	LEVELCOUNTER_NODE.show()
	COLLISION_NODE.call_deferred("set_disabled", false)
	can_control = true
	update()


func reset(scr_w,scr_h):
	if lifePoints <= 0:
		lifePoints = 100.0
	var center = Vector2(scr_w / 2, scr_h / 2)
	linear_velocity = Vector2(0,0)
	rotation = 0
	position = center
	_ready()


func _draw():
	if lifePoints > 0:
		var points = PoolVector2Array()
		
		points.push_back(Vector2(0, -10))
		points.push_back(Vector2(-10, 10))
		points.push_back(Vector2(0, 5))
		points.push_back(Vector2(10, 10))
		
		draw_polygon(points, PoolColorArray([Color(1,1,1,alpha)]))



func _physics_process(delta):
	if not is_vulnerable:
		alpha = sin(INVUL_NODE.time_left / INVUL_NODE.wait_time * 70)
		update()
	angular_velocity = 0
	PARTICLES_NODE.emitting = false
	SOUND_NODE.stop()
	if lifePoints > 0 and can_control:
		if Input.is_action_pressed("ui_drain"):
			damage_calc(100)
		if Input.is_action_pressed("ui_right"):
			angular_velocity = rotation_amount
		if Input.is_action_pressed("ui_left"):
			angular_velocity = -rotation_amount
		if Input.is_action_pressed("ui_up"):
			SOUND_NODE.play(SOUND_NODE.get_playback_position())
			PARTICLES_NODE.emitting = true
			linear_velocity += Vector2(acceleration,0).rotated(rotation -PI/2)
		if Input.is_action_pressed("ui_shoot") and not is_shooting:
			is_shooting = true
			SHOOTCOOLDOWN_NODE.start()
			var knockback = Vector2(cos(rotation - PI/2), sin(rotation - PI/2)).normalized() * -acceleration
			linear_velocity += knockback
			var bullet = Bullet.instance()
			get_parent().get_node("./Bullets").add_child(bullet)
			bullet.position = position
			bullet.rotation = rotation - PI/2
			bullet.set_linear_velocity(Vector2(400, 0).rotated(rotation - PI/2))
	linear_velocity = linear_velocity.clamped(max_velocity)


func game_over():
	EXPLOSIONSOUND_NODE.play()
	update()
	LEVELCOUNTER_NODE.hide()
	LIFEBAR_NODE.hide()
	COLLISION_NODE.call_deferred("set_disabled", true)
	DEATHANIM_NODE.emitting = true
	CLEARED_NODE.emit_signal("over")


func damage_calc(dmg):
	if not is_vulnerable:
		return
	is_vulnerable = false
	INVUL_NODE.start()
	HITSOUND_NODE.play(0)
	CAMERA_NODE.player_hit(dmg)
	lifePoints -= dmg
	if lifePoints > 0:
		LIFEBAR_NODE.emit_signal("show",lifePoints)
		LEVELCOUNTER_NODE.emit_signal("life_changed", lifePoints)
	else:
		CAMERA_NODE.player_hit(dmg/5)
		game_over()


func _on_Ship_body_entered(body):
	damage_calc(10 * body.scl)


func _on_Ship_hit(damage):
	damage_calc(damage)


func _on_ShootCooldown_timeout():
	is_shooting = false


func _on_Invulnerability_timeout():
	alpha = 1
	is_vulnerable = true
	update()
