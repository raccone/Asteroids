extends Node

var Asteroid = load("res://Asteroid.tscn")
var Ship = load("res://Ship.tscn")
var Enemy = load("res://Enemy.tscn")

var screen_width = OS.get_window_size().x
var screen_height = OS.get_window_size().y

var level = 1

var ship

signal new_game
signal next_level


func _ready():
	randomize()
	level = 1
	$LevelCounter.emit_signal("update_level",level)
	$LevelCounter.show()
	screen_width = OS.get_window_size().x
	screen_height = OS.get_window_size().y
	var part_mat = $Stars.process_material
	part_mat.emission_box_extents = Vector3(screen_width, screen_height, 0)
	$Stars.set_process_material(part_mat)
	if ship != null:
		ship.queue_free()
	ship = Ship.instance()
	add_child(ship)
	ship.reset(screen_width,screen_height)
	if $Asteroids.get_child_count() > 0:
		for asteroid in $Asteroids.get_children():
			asteroid.queue_free()
	if $Enemy.get_child_count() > 0:
		for enemy in $Enemy.get_children():
			enemy.queue_free()
	asteroid_place(level)
	if rand_range(0, 100) < level:
		spawn_enemy()


func spawn_enemy():
	var enemy = Enemy.instance()
	$Enemy.add_child(enemy)
	enemy.position = Vector2(100,100)


func asteroid_place(times):
	for i in range(0,clamp(times,1,15)):
		var random = Vector2(rand_range(0, screen_width),rand_range(0, screen_height))
		while random.distance_to(ship.position) < 40:
			random = Vector2(rand_range(0, screen_width),rand_range(0, screen_height))
		var asteroid = Asteroid.instance()
		$Asteroids.add_child(asteroid)
		asteroid.position = random
		var scale = rand_range(0.5,2.0)
		asteroid.scl = scale
		asteroid.rotation = rand_range(0, PI)
		asteroid.set_linear_velocity(Vector2(rand_range(asteroid.min_velocity, asteroid.max_velocity),0).rotated(rand_range(0, 2*PI)))


func _process(delta):
	if $Asteroids.get_child_count() == 1 and ship.can_control:
		if $Asteroids.get_child(0).lifePoints < 0:
			ship.can_control = false
			$Cleared.emit_signal("cleared")


func _on_Game_new_game():
	_ready()


func _on_Game_next_level():
	level +=1
	$LevelCounter.emit_signal("update_level",level)
	ship.reset(OS.get_window_size().x,OS.get_window_size().y)
	asteroid_place(level)
