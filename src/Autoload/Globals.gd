extends Node


var camera = null

var spawn_point = Vector2()

var buttonTimer

var checkpoint_check : bool = false

var breed_unlock : bool = false

var key_grabbed : bool = false

var boss_unlock : bool = false

var brother_unlock : bool = false

func update_spawn(new_point):
	spawn_point = new_point
	yield(get_tree().create_timer(0.05), "timeout")
	checkpoint_check = true
	
#NOTE: I probably could've made an array for the bools ngl
func reset_everything():
	checkpoint_check = false
	breed_unlock = false
	key_grabbed = false
	boss_unlock = false
	brother_unlock = false
