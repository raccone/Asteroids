extends ViewportContainer

var Asteroid = load("res://Asteroid.tscn")
var Ship = load("res://Ship.tscn")
var Enemy = load("res://Enemy.tscn")

#var screen_width = OS.get_window_size().x
#var screen_height = OS.get_window_size().y
var screen_width
var screen_height

var level = 1

var ship

signal new_game
signal next_level

onready var GAME_NODE = get_node("Viewport/Camera2D/Game")
onready var LEVELCOUNTER_NODE = $LevelCounter
onready var CLEARED_NODE = $Cleared
onready var VIEWPORT_NODE = $Viewport
onready var STARS_NODE = $Viewport/Camera2D/Game/Stars
onready var ASTEROIDS_NODE = $Viewport/Camera2D/Game/Asteroids
onready var ENEMY_NODE = $Viewport/Camera2D/Game/Enemy


func _ready():
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	randomize()
	level = 1
	LEVELCOUNTER_NODE.emit_signal("update_level",level)
	LEVELCOUNTER_NODE.show()
#	screen_width = OS.get_window_size().x
#	screen_height = OS.get_window_size().y
	var part_mat = STARS_NODE.process_material
	part_mat.emission_box_extents = Vector3(screen_width, screen_height, 0)
	STARS_NODE.set_process_material(part_mat)
	if ship != null:
		ship.queue_free()
	ship = Ship.instance()
	GAME_NODE.add_child(ship)
	ship.reset(screen_width,screen_height)
	if ASTEROIDS_NODE.get_child_count() > 0:
		for asteroid in ASTEROIDS_NODE.get_children():
			asteroid.queue_free()
	if ENEMY_NODE.get_child_count() > 0:
		for enemy in ENEMY_NODE.get_children():
			enemy.queue_free()
	asteroid_place(level)
	spawn_enemy(level)


func spawn_enemy(level):
	if ENEMY_NODE.get_child_count() > 0:
		for child in ENEMY_NODE.get_children():
			child.queue_free()
	if rand_range(0, 50) >= level:
		return
	var enemy = Enemy.instance()
	ENEMY_NODE.add_child(enemy)
	var random = Vector2(rand_range(0, screen_width),rand_range(0, screen_height))
	while random.distance_to(ship.position) < 40:
		random = Vector2(rand_range(0, screen_width),rand_range(0, screen_height))
	enemy.position = random


func asteroid_place(times):
	for i in range(0,clamp(times,1,15)):
		var random = Vector2(rand_range(0, screen_width),rand_range(0, screen_height))
		while random.distance_to(ship.position) < 40:
			random = Vector2(rand_range(0, screen_width),rand_range(0, screen_height))
		var asteroid = Asteroid.instance()
		ASTEROIDS_NODE.add_child(asteroid)
		asteroid.position = random
		var scale = rand_range(0.5,2.0)
		asteroid.scl = scale
		asteroid.rotation = rand_range(0, PI)
		asteroid.set_linear_velocity(Vector2(rand_range(asteroid.min_velocity, asteroid.max_velocity),0).rotated(rand_range(0, 2*PI)))


func _process(delta):
	if ASTEROIDS_NODE.get_child_count() > 0 and ship.can_control:
		for ast in ASTEROIDS_NODE.get_children():
			if ast.lifePoints > 0:
				return
		ship.can_control = false
		CLEARED_NODE.emit_signal("cleared")


func _on_Control_new_game():
	_ready()


func _on_Control_next_level():
	level +=1
	LEVELCOUNTER_NODE.emit_signal("update_level",level)
	ship.reset(screen_width,screen_height)
	asteroid_place(level)
	spawn_enemy(level)
