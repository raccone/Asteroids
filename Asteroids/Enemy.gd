extends RigidBody2D

var Bullet = load("res://Bullet.tscn")

var lifePoints = 100
var scl = 1
var fighting = true
var color = Color(0.5,0,0)

var max_vel = 50
var max_force = 10
var acceleration = Vector2()

signal hit
signal stop

onready var CONTROL_NODE = get_node("/root/Control")
onready var BULLETS_NODE = get_node("/root/Control/Viewport/Camera2D/Game/Bullets")
onready var CAMERA_NODE = get_node("/root/Control/Viewport/Camera2D")
onready var LIFEBAR_NODE = $LifeBar
onready var TIMER_NODE = $Timer
onready var DAMAGETIMER_NODE = $DamageTimer
onready var DEATHTIMER_NODE = $DeathTimer
onready var EXPLOSION_NODE = $Explosion
onready var COLLISION_NODE = $CollisionPolygon2D
onready var HITSOUND_NODE = $HitSound
onready var EXPLOSIONSOUND_NODE = $ExplosionSound


func _draw():
	if lifePoints > 0:
		var points = PoolVector2Array()
		
		points.push_back(Vector2(0, -10))
		points.push_back(Vector2(-20, 0))
		points.push_back(Vector2(0, 10))
		points.push_back(Vector2(20, 0))
		
		draw_polygon(points, PoolColorArray([color]))


func _physics_process(delta):
	if not DAMAGETIMER_NODE.is_stopped():
		var variation = DAMAGETIMER_NODE.time_left / DAMAGETIMER_NODE.wait_time
		color = Color(clamp(variation, 0.5, 1), 0, 0)
		update()
	if CONTROL_NODE.ship != null and fighting:
		seek(CONTROL_NODE.ship)


func seek(player):
	var desired = player.position - position
	var d = desired.length()
	desired = desired.normalized()
	if (d < 300):
		var m = range_lerp(d, 200, 300, 0, max_vel)
		desired *= m
	else:
		desired *= max_vel
	var steer = desired - linear_velocity
	steer = steer.clamped(max_force)
	apply_impulse(Vector2(0,0), steer)


func shoot(player):
	var bullet = Bullet.instance()
	bullet.set_linear_velocity(Vector2(200, 0))
	bullet.is_enemy = true
	BULLETS_NODE.add_child(bullet)
	bullet.position = position
	var enemy_pos = position
	var ship_pos = player.position
	var ship_vel = player.linear_velocity
	var dist_vect = enemy_pos - ship_pos
	var beta = dist_vect.angle_to(ship_vel)
	var sing = ship_vel.length() / bullet.linear_velocity.length() * sin(beta)
	var dir = asin(sing)
	bullet.rotation = dist_vect.angle() - PI
	bullet.rotation -= dir
	bullet.linear_velocity = bullet.linear_velocity.rotated(bullet.rotation)


func _on_Enemy_hit(damage):
	HITSOUND_NODE.set_pitch_scale(rand_range(0.8, 1.2))
	HITSOUND_NODE.play()
	DAMAGETIMER_NODE.start()
	lifePoints -= damage / 1.5
	if lifePoints > 0:
		CAMERA_NODE.shake(damage/3)
		LIFEBAR_NODE.emit_signal("show",lifePoints)
	else:
		explode()


func explode():
	EXPLOSIONSOUND_NODE.play()
#	CAMERA_NODE.shake(8)
	CAMERA_NODE.explosion(8)
	update()
	LIFEBAR_NODE.hide()
	COLLISION_NODE.call_deferred("set_disabled", true)
#	COLLISION_NODE.disabled = true
	DEATHTIMER_NODE.start()
	TIMER_NODE.stop()
	EXPLOSION_NODE.emitting = true


func _on_Timer_timeout():
	if CONTROL_NODE.ship != null:
		shoot(CONTROL_NODE.ship)


func _on_Enemy_stop():
	TIMER_NODE.stop()
	fighting = false


func _on_DeathTimer_timeout():
	queue_free()
